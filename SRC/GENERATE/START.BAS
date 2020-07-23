TYPE EditionType
    Year AS INTEGER
END TYPE

TYPE TrackType
    Id AS INTEGER
    Title AS STRING * 57
    Artist AS STRING * 44
    Year AS INTEGER
    HighPosition AS INTEGER
    HighEdition AS INTEGER
    LowPosition AS INTEGER
    LowEdition AS INTEGER
    FirstPosition AS INTEGER
    FirstEdition AS INTEGER
    LastPosition AS INTEGER
    LastEdition AS INTEGER
    LastPlayTime AS STRING * 16
    Appearances AS INTEGER
    AppearancesPositions AS INTEGER
END TYPE

TYPE ListingType
    Edition AS INTEGER
    Position AS INTEGER
    TrackId AS INTEGER
    Offset AS INTEGER
    OffsetType AS INTEGER
END TYPE

CLS

OPEN "LISTINGS.DAT" FOR ISAM ListingType "Listings" AS #1

PRINT "Creating index ByEdition for listings"
CREATEINDEX #1, "ByEdition", 0, "Edition", "Position"

PRINT "Creating index ByTrack for listings"
CREATEINDEX #1, "ByTrack", 0, "TrackId", "Edition"

CLOSE #1

OPEN "TRACKS.DAT" FOR ISAM TrackType "Tracks" AS #1

PRINT "Creating indexe ById for Tracks"
CREATEINDEX #1, "ById", 0, "Id"

CLOSE #1