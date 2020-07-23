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

    ON LOCAL ERROR GOTO DiskCheck

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
    EXIT SUB

DiskCheck:
    PRINT "Helaas TOP2000 voor MS-DOS kan niet gestart worden"
    PRINT "Error code: " + STR$(ERR)
    PRINT ""

    IF ERR = 73 THEN
        PRINT "Kan TOP2000.DAT niet openen"
        PRINT "Controleer of PROISAMD.EXE is gestart voordat u VBDOS opende"
    ELSE
        PRINT "Kan de TOP2000 database niet vinden."
        PRINT "Controleer of het bestand 'TOP2000.DAT' in dezelfde directory staat"
        PRINT "als de de TOP2000.EXE"
    END IF
    
    END

END SUB

