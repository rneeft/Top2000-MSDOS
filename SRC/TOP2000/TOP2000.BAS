OPTION EXPLICIT

DECLARE SUB LoadMetaData ()
'$FORM frmDetails
'$FORM frmMain

COMMON SHARED editionOnView AS INTEGER
COMMON SHARED firstEdition AS INTEGER
COMMON SHARED lastEdition AS INTEGER
COMMON SHARED totalEditions AS INTEGER

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
    firstEdition AS INTEGER
    LastPosition AS INTEGER
    lastEdition AS INTEGER
    LastPlayTime AS STRING * 16
    Appearances AS INTEGER
    AppearancesPositions AS INTEGER
END TYPE

TYPE EditionType
    Year AS INTEGER
END TYPE

TYPE ListingType
    Edition AS INTEGER
    Position AS INTEGER
    TrackID AS INTEGER
    Offset AS INTEGER
    OffsetType AS INTEGER
END TYPE

CLS

CALL LoadMetaData
LOAD frmMain
frmMain.Top = 0
frmMain.Left = 0
frmMain.SHOW 0

SUB LoadMetaData ()

    DIM Edition AS EditionType
    OPEN "TOP2000.DAT" FOR ISAM EditionType "Editions" AS #1
    MOVEFIRST #1
    RETRIEVE #1, Edition
    firstEdition = Edition.Year

    MOVELAST #1
    RETRIEVE #1, Edition
    lastEdition = Edition.Year

    totalEditions = LOF(1)
    CLOSE #1

END SUB

