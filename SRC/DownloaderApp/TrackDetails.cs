using System.Collections.Immutable;

public class TrackDetails
{
    public TrackDetails(string title, string artist, int recordedYear, ImmutableSortedSet<ListingInformation> listings)
    {
        this.Title = title;
        this.Artist = artist;
        this.RecordedYear = recordedYear;
        this.Listings = listings;
    }

    public string Title { get; }

    public string Artist { get; }

    public int RecordedYear { get; }

    public ImmutableSortedSet<ListingInformation> Listings { get; }

    public ListingInformation Highest => Listings
        .Where(x => x.Position.HasValue)
        .OrderBy(x => x.Position)
        .ThenBy(x => x.Edition)
        .First();

    public ListingInformation Lowest => Listings
        .Where(x => x.Position.HasValue)
        .OrderBy(x => x.Position)
        .ThenBy(x => x.Edition)
        .Last();

    public ListingInformation First => Listings.Single(x => x.Status == ListingStatus.New);

    public ListingInformation Latest => Listings.First(x => x.Position.HasValue);

    public int Appearances => Listings.Count(x => x.Position.HasValue);

    public int AppearancesPossible => Listings.Count(x => x.Status != ListingStatus.NotAvailable);
}
