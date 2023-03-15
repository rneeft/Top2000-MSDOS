using SQLite;

namespace DownloaderApp;

public sealed class Track
{
    [PrimaryKey]
    public int Id { get; set; }

    public string Title { get; set; } = string.Empty;

    public string Artist { get; set; } = string.Empty;

    public int RecordedYear { get; set; } = 1;
}
