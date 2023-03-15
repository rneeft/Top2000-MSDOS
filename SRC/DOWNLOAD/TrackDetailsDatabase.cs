using System.Data;
using System.Net.Http.Json;

namespace DownloaderApp;

public sealed partial class Database
{
    private readonly SQLiteAsyncConnection connection;

    public Database(SQLiteAsyncConnection connection)
    {
        this.connection = connection;
    }

    public async Task<List<Edition>> EditionsAsync()
    {
        return await connection
            .Table<Edition>()
            .OrderBy(x => x.Year)
            .ToListAsync();
    }

    public async Task<List<int>> AllTrackIdsAsync()
    {
        var allTracks = await connection.QueryAsync<Track>("SELECT Id FROM Track ORDER BY Id");
        return allTracks.Select(x => x.Id).ToList();
    }

    public async Task<TrackDetails> TrackDetailsAsync(int trackId)
    {
        var sql =
            "SELECT Year AS Edition, Position, PlayUtcDateAndTime " +
            "FROM Edition LEFT JOIN Listing " +
            "ON Listing.Edition = Edition.Year AND Listing.TrackId = ?";

        var listings = (await connection.QueryAsync<ListingInformation>(sql, trackId))
            .OrderBy(x => x.Edition)
            .ToArray();

        var track = await connection.GetAsync<Track>(trackId);

        var statusStrategy = new ListingStatusStrategy(track.RecordedYear);

        ListingInformation? previous = null;

        foreach (var listing in listings)
        {
            if (previous != null && previous.Position.HasValue)
                listing.Offset = listing.Position - previous.Position;

            listing.Status = statusStrategy.Determine(listing);
            previous = listing;
        }

        return new TrackDetails(track.Title, track.Artist, track.RecordedYear, listings.ToImmutableSortedSet(new ListingInformationDescendingComparer()));
    }

    [SuppressMessage("Minor Code Smell", "S1075:URIs should not be hardcoded")]
    public static async Task<Database> CreateAsync()
    {
        var upgradesUrl = new Uri("https://www-dev.top2000.app/api/versions/0001/upgrades");

        var client = new HttpClient();
        var upgrades = await client.GetFromJsonAsync<List<string>>(upgradesUrl) ?? throw new InvalidOperationException("Unable to retrieve upgrades list");
        upgrades.Insert(0, "0001-CreateTables.sql");
        File.Delete("top2000.db");
        var sqlConnection = new SQLiteAsyncConnection("top2000.db", SQLiteOpenFlags.ReadWrite | SQLiteOpenFlags.Create | SQLiteOpenFlags.SharedCache, storeDateTimeAsTicks: false);

        foreach (var item in upgrades)
        {
            var sqlContent = await client.GetStringAsync($"https://www-dev.top2000.app/data/{item}");
            var sections = sqlContent
                .Split(';')
                .Where(x => !string.IsNullOrWhiteSpace(x))
                .ToList();

            foreach (var section in sections)
            {
                await sqlConnection.ExecuteAsync(section);
            }
        }

        return new Database(sqlConnection);
    }
}