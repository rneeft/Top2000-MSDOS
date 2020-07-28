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

TYPE FileType
    Name AS STRING * 12
END TYPE

DIM SHARED filesNeeded(7) AS FileType
DIM SHARED I AS INTEGER
DIM SHARED current AS STRING * 12
filesNeeded(0).Name = "EDITIONS.CSV"
filesNeeded(1).Name = "EDITIONS.TXT"
filesNeeded(2).Name = "TRACKS.CSV"
filesNeeded(3).Name = "TRACKS.TXT"
filesNeeded(4).Name = "LISTINGS.CSV"
filesNeeded(5).Name = "LISTINGS.TXT"
filesNeeded(6).Name = "C:\VBDOS\ISAMIO.EXE"

CLS
PRINT "TOP 2000 APP voor MS-DOS - database generator"
PRINT "============================================="
PRINT ""
PRINT "Deze tool cre" + CHR$(137) + "erd de ISAM database"
PRINT ""

ON ERROR GOTO catch

FOR I = 0 TO 6
    current = filesNeeded(I).Name
    OPEN current FOR INPUT AS #1
    CLOSE #1
NEXT I
current = ""
PRINT "Inlezen editions.csv"
SHELL "C:\VBDOS\ISAMIO /I editions.csv TOP2000.DAT editions editions.txt /C"

PRINT "Inlezen listings.csv"
SHELL "C:\VBDOS\ISAMIO /I listings.csv TOP2000.DAT listings listings.txt /C"

PRINT "Inlezen tracks.csv"
SHELL "C:\VBDOS\ISAMIO /I tracks.csv TOP2000.DAT tracks tracks.txt /C"

OPEN "TOP2000.DAT" FOR ISAM ListingType "Listings" AS #1

PRINT "Creating index ByEdition for listings"
CREATEINDEX #1, "ByEdition", 0, "Edition", "Position"

PRINT "Creating index ByTrack for listings"
CREATEINDEX #1, "ByTrack", 0, "TrackId", "Edition"

CLOSE #1

OPEN "TOP2000.DAT" FOR ISAM TrackType "Tracks" AS #1

PRINT "Creating indexe ById for Tracks"
CREATEINDEX #1, "ById", 0, "Id"

CLOSE #1

PRINT "Database voltooid!"

END
catch:
PRINT "Kan " + current + " niet vinden."
PRINT "Errorcode: " + STR$(ERR)
END

