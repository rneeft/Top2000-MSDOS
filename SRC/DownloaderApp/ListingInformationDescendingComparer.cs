namespace DownloaderApp;

public sealed class ListingInformationDescendingComparer : Comparer<ListingInformation>
{
    public override int Compare(ListingInformation? x, ListingInformation? y) => (y?.Edition - x?.Edition) ?? 0;
}