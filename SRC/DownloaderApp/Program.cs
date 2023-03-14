using SQLite;
using System.Collections.Immutable;
using System.Globalization;
using System.Net.Http.Json;
using System.Text;

var upgradesUrl = new Uri("https://www-dev.top2000.app/api/versions/0001/upgrades");
var utf8WithoutBom = new UTF8Encoding(encoderShouldEmitUTF8Identifier: false);

var client = new HttpClient();
var upgrades = await client.GetFromJsonAsync<List<string>>(upgradesUrl) ?? throw new InvalidOperationException("Unable to retrieve upgrades list");
upgrades.Insert(0, "0001-CreateTables.sql");
File.Delete("top2000.db");
var connection = new SQLiteAsyncConnection("top2000.db", SQLiteOpenFlags.ReadWrite | SQLiteOpenFlags.Create | SQLiteOpenFlags.SharedCache, storeDateTimeAsTicks: false);

foreach (var item in upgrades)
{
    Console.WriteLine(item);

    var sqlContent = await client.GetStringAsync($"https://www-dev.top2000.app/data/{item}");
    var sections = sqlContent
        .Split(';')
        .Where(x => !string.IsNullOrWhiteSpace(x))
        .ToList();

    await connection.RunInTransactionAsync(connection =>
    {
        foreach (var section in sections)
        {
            try
            {
                connection.Execute(section);
            }
            catch(Exception ex)
            {
                Console.WriteLine(section);
                throw;
            }
        }
    });
}

var tracks = new List<string>()
{
    "Id,Title,Artist,Year,HighPosition,HighEdition,LowPosition,LowEdition,FirstPosition,FirstEdition,LastPosition,LastEdition,LastPlayTime,Appearances,AppearancesPositions"
};
var possList = new List<string>
{
    "Edition,Position,TrackId,Offset,OffsetType"
};

var editions = (await connection.Table<Edition>().OrderBy(x => x.Year).ToListAsync())
    .Select(x => $"{x.Year}")
    .ToList();
editions.Insert(0, "Year");

var allTracks = await connection.QueryAsync<Track>("SELECT Id FROM Track ORDER BY Id");
var allTrackIds = allTracks.Select(x => x.Id).ToList();

foreach (var trackId in allTrackIds)
{
    var track = await GetTrackDetails(connection, trackId);

    var strings = new List<string>
    {
        trackId.ToString(CultureInfo.InvariantCulture),
        Replace(track.Title),
        Replace(track.Artist),
        track.RecordedYear.ToString(CultureInfo.InvariantCulture),
        track.Highest.Position?.ToString(CultureInfo.InvariantCulture) ?? throw new InvalidOperationException("Position should be available"),
        track.Highest.Edition.ToString(CultureInfo.InvariantCulture),
        track.Lowest.Position?.ToString(CultureInfo.InvariantCulture) ?? throw new InvalidOperationException("Position should be available"),
        track.Lowest.Edition.ToString(CultureInfo.InvariantCulture),
        track.First.Position?.ToString(CultureInfo.InvariantCulture) ?? throw new InvalidOperationException("Position should be available"),
        track.First.Edition.ToString(CultureInfo.InvariantCulture),
        track.Latest.Position?.ToString(CultureInfo.InvariantCulture) ?? throw new InvalidOperationException("Position should be available"),
        track.Latest.Edition.ToString(CultureInfo.InvariantCulture),
        track.Latest.PlayUtcDateAndTime.HasValue ? track.Latest.PlayUtcDateAndTime.Value.ToLocalTime().ToString("dd-MM-yyyy HH:mm") + $"-{track.Latest.PlayUtcDateAndTime.Value.ToLocalTime().Hour+1}:00" : "-",
        track.Appearances.ToString(),
        track.AppearancesPossible.ToString()
    }.ToArray();

    var listings = track.Listings
        .Where(x => x.Status != ListingStatus.NotAvailable && x.Status != ListingStatus.NotListed && x.Status != ListingStatus.Unknown)
        .OrderBy(x => x.Edition);

    foreach (var listing in listings)
    {
        var listingString = new List<int>
            {
                listing.Edition,
                listing?.Position ?? throw new InvalidOperationException("Position should be available"),
                trackId,
                ReadOffSet(listing.Offset),
                ToChr(listing.Status)
            }.ToArray();

        possList.Add(string.Join(',', listingString));
    }

    tracks.Add(string.Join(',', strings));
}

await File.WriteAllLinesAsync("editions.csv", editions, utf8WithoutBom);
await File.WriteAllLinesAsync("tracks.csv", tracks, utf8WithoutBom);
await File.WriteAllLinesAsync("listings.csv", possList, utf8WithoutBom);

static string Replace(string input)
{
    return input
        .Replace("ä", "a", StringComparison.InvariantCulture)
        .Replace("á", "a", StringComparison.InvariantCulture)
        .Replace("à", "a", StringComparison.InvariantCulture)
        .Replace("ã", "a", StringComparison.InvariantCulture)
        .Replace("â", "a", StringComparison.InvariantCulture)

        .Replace("ê", "e", StringComparison.InvariantCulture)
        .Replace("ë", "e", StringComparison.InvariantCulture)
        .Replace("é", "e", StringComparison.InvariantCulture)
        .Replace("è", "e", StringComparison.InvariantCulture)
        .Replace("È", "E", StringComparison.InvariantCulture)

        .Replace("ö", "o", StringComparison.InvariantCulture)
        .Replace("ó", "o", StringComparison.InvariantCulture)
        .Replace("ò", "o", StringComparison.InvariantCulture)
        .Replace("ô", "o", StringComparison.InvariantCulture)
        .Replace("õ", "o", StringComparison.InvariantCulture)

        .Replace("ø", "o", StringComparison.InvariantCulture)
        .Replace("Ø", "O", StringComparison.InvariantCulture)

        .Replace("î", "i", StringComparison.InvariantCulture)
        .Replace("ï", "i", StringComparison.InvariantCulture)
        .Replace("í", "i", StringComparison.InvariantCulture)
        .Replace("ì", "i", StringComparison.InvariantCulture)
        .Replace("î", "i", StringComparison.InvariantCulture)

        .Replace("&", "+", StringComparison.InvariantCulture)
        .Replace(",", " ", StringComparison.InvariantCulture)
        ;
}

static int ReadOffSet(int? value)
{
    if (!value.HasValue)
        return 0;

    if (value.Value < 0)
        return value.Value * -1;

    return value.Value;
}

static int ToChr(ListingStatus status)
{
    return status switch
    {
        ListingStatus.New => 14,
        ListingStatus.Decreased => 31,
        ListingStatus.Increased => 30,
        ListingStatus.Unchanged => 61,
        ListingStatus.Back => 27,
        _ => throw new Exception(),
    };
}

async Task<TrackDetails> GetTrackDetails(SQLiteAsyncConnection connection, int trackId)
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

public sealed class Track
{
    [PrimaryKey]
    public int Id { get; set; }

    public string Title { get; set; } = string.Empty;

    public string Artist { get; set; } = string.Empty;

    public int RecordedYear { get; set; } = 1;
}
public sealed class ListingInformationDescendingComparer : Comparer<ListingInformation>
{
    public override int Compare(ListingInformation x, ListingInformation y) => y.Edition - x.Edition;
}