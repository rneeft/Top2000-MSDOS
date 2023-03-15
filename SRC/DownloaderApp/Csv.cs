namespace DownloaderApp;

public static class Csv
{
    public static string ToCsvString(Edition edition)
    {
        return edition.Year.ToString();
    }

    public static string ToCsvString(int trackId, ListingInformation listing)
    {
        var listingString = new List<int>
        {
            listing.Edition,
            listing?.Position ?? throw new InvalidOperationException("Position should be available"),
            trackId,
            ReadOffSet(listing.Offset),
            ToChr(listing.Status)
        };
        
        return string.Join(',', listingString);
    }

    public static string ToCsvString(int trackId, TrackDetails track)
    {
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
        };

        return string.Join(',', strings);
    }
    public static string Replace(string input)
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

    public static int ReadOffSet(int? value)
    {
        if (!value.HasValue)
            return 0;

        if (value.Value < 0)
            return value.Value * -1;

        return value.Value;
    }

    public static int ToChr(ListingStatus status)
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
}