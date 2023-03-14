public sealed class Edition
{
    public int Year { get; set; }

    public DateTime LocalStartDateAndTime => DateTime.SpecifyKind(StartUtcDateAndTime, DateTimeKind.Utc).ToLocalTime();

    public DateTime LocalEndDateAndTime => DateTime.SpecifyKind(EndUtcDateAndTime, DateTimeKind.Utc).ToLocalTime();

    public DateTime StartUtcDateAndTime { get; set; }

    public DateTime EndUtcDateAndTime { get; set; }

    public bool HasPlayDateAndTime { get; set; }
}