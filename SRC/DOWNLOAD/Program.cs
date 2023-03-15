
var database = await Database.CreateAsync();

var csvEditions = new List<string>()
{
    "Year"
};
var csvTracks = new List<string>()
{
    "Id,Title,Artist,Year,HighPosition,HighEdition,LowPosition,LowEdition,FirstPosition,FirstEdition,LastPosition,LastEdition,LastPlayTime,Appearances,AppearancesPositions"
};
var csvPossList = new List<string>
{
    "Edition,Position,TrackId,Offset,OffsetType"
};

var editions = await database.EditionsAsync();

foreach (var item in editions)
{
    csvEditions.Add(Csv.ToCsvString(item));
}

var allTrackIds = await database.AllTrackIdsAsync();

foreach (var trackId in allTrackIds)
{
    var track = await database.TrackDetailsAsync(trackId);

    csvTracks.Add(Csv.ToCsvString(trackId, track));

    var listings = track.Listings
        .Where(x => x.Status != ListingStatus.NotAvailable && x.Status != ListingStatus.NotListed && x.Status != ListingStatus.Unknown)
        .OrderBy(x => x.Edition)
        .Select(x => Csv.ToCsvString(trackId, x));

    foreach (var listing in listings)
    {
        csvPossList.Add(listing);
    }

}

var utf8WithoutBom = new UTF8Encoding(encoderShouldEmitUTF8Identifier: false);

await File.WriteAllLinesAsync("editions.csv", csvEditions, utf8WithoutBom);
await File.WriteAllLinesAsync("tracks.csv", csvTracks, utf8WithoutBom);
await File.WriteAllLinesAsync("listings.csv", csvPossList, utf8WithoutBom);
