public class ListingInformation
{
    public int Edition { get; set; }

    public int? Position { get; set; }

    public DateTime? PlayUtcDateAndTime { get; set; }

    public DateTime? LocalUtcDateAndTime
    {
        get
        {
            if (PlayUtcDateAndTime is null) return null;
            return DateTime.SpecifyKind((DateTime)PlayUtcDateAndTime, DateTimeKind.Utc).ToLocalTime();
        }
    }

    public int? Offset { get; set; }

    public ListingStatus Status { get; set; }

    public bool CouldBeListed(int recoredYear) => recoredYear <= Edition;
}
