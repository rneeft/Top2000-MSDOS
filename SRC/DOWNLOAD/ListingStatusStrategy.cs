namespace DownloaderApp;

public sealed class ListingStatusStrategy
{
    private readonly int recordedYear;
    private readonly List<ListingInformation> previous = new();

    public ListingStatusStrategy(int recordedYear)
    {
        this.recordedYear = recordedYear;
    }

    public ListingStatus Determine(ListingInformation current)
    {
        var status = GetStatus(current);
        previous.Add(current);
        return status;
    }

    private ListingStatus GetStatus(ListingInformation current)
    {
        if (!current.CouldBeListed(recordedYear))
            return ListingStatus.NotAvailable;

        if (!current.Position.HasValue)
            return ListingStatus.NotListed;

        if (!previous.Any(x => x.Status == ListingStatus.New))
            return ListingStatus.New;

        if (!current.Offset.HasValue)
            return ListingStatus.Back;

        if (current.Offset == 0)
            return ListingStatus.Unchanged;

        if (current.Offset < 0)
            return ListingStatus.Increased;

        if (current.Offset > 0)
            return ListingStatus.Decreased;

        throw new InvalidOperationException();
    }
}