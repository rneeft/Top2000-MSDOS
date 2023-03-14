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
    LastPlayTime AS STRING * 26
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
PRINT "TOP 2000 APP voor MS-DOS - Index generator"
PRINT "=========================================="
PRINT ""
PRINT "Deze tool cre" + CHR$(137) + "erd de indexes"
PRINT "Op de TOP 2000 database"
PRINT ""

OPEN "TOP2000.DAT" FOR ISAM ListingType "Listings" AS #1

PRINT "- Index ByEdition for listings"
CREATEINDEX #1, "ByEdition", 0, "Edition", "Position"

PRINT "- Index ByTrack for listings"
CREATEINDEX #1, "ByTrack", 0, "TrackId", "Edition"

CLOSE #1

OPEN "TOP2000.DAT" FOR ISAM TrackType "Tracks" AS #1

PRINT "- Index ById for Tracks"
CREATEINDEX #1, "ById", 0, "Id"

CLOSE #1