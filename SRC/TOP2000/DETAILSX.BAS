DECLARE SUB AddEditionsToScreen ()
'$FORM frmDetails

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
    LastPlayTime AS STRING * 26
    Appearances AS INTEGER
    AppearancesPositions AS INTEGER
END TYPE

TYPE ListingType
    Edition AS INTEGER
    Position AS INTEGER
    TrackID AS INTEGER
    Offset AS INTEGER
    OffsetType AS INTEGER
END TYPE

DIM SHARED TrackID AS INTEGER
DIM SHARED skipEdition AS INTEGER

SUB AddEditionsToScreen ()
  OPEN "TOP2000.DAT" FOR ISAM ListingType "Listings" AS #1
  SETINDEX #1, "ByTrack"
  DIM listing AS ListingType
  DIM I AS INTEGER
    DIM tId AS INTEGER
    tId = VAL(LTRIM$(frmDetails.lblTrackId.Caption))

  FOR I = 0 TO 8

    SEEKEQ #1, tId, (lastEdition - I - skipEdition)
    frmDetails.lblEdition(I).Caption = LTRIM$(STR$(lastEdition - I - skipEdition))
    IF BOF(1) OR NOT EOF(1) THEN
        RETRIEVE #1, listing

        IF listing.Offset > 0 THEN
            frmDetails.lblDelta(I).Caption = LTRIM$(STR$(listing.Offset))
        ELSE
            frmDetails.lblDelta(I).Caption = ""
        END IF

        IF listing.OffsetType = 13 THEN listing.OffsetType = 27

        frmDetails.lblDeltaType(I).Caption = CHR$(listing.OffsetType)
        frmDetails.lblPosition(I).Caption = LTRIM$(STR$(listing.Position))

        SELECT CASE listing.OffsetType
            CASE 31
                frmDetails.lblDeltaType(I).ForeColor = 4
            CASE 30
                frmDetails.lblDeltaType(I).ForeColor = 2
            CASE 13
                frmDetails.lblDeltaType(I).ForeColor = 1
            CASE 14
                frmDetails.lblDeltaType(I).ForeColor = 1
            CASE ELSE
                frmDetails.lblDeltaType(I).ForeColor = 8
        END SELECT
    ELSE
        frmDetails.lblDelta(I).Caption = ""
        frmDetails.lblDeltaType(I).Caption = "-"
        frmDetails.lblPosition(I).Caption = "-"

        frmDetails.lblDeltaType(I).ForeColor = 8
    END IF

  NEXT I
  CLOSE #1

END SUB

SUB DetailsFormsOpen ()
  DIM back AS STRING

  back = CHR$(177) + CHR$(177) + CHR$(177) + CHR$(177) + CHR$(177) + CHR$(177) + CHR$(177) + CHR$(177) + CHR$(177) + CHR$(177) + CHR$(177) + CHR$(177) + CHR$(177) + CHR$(177) + CHR$(177) + CHR$(177) + CHR$(177) + CHR$(177) + CHR$(177) + CHR$(177)

  frmDetails.lblSinceReleaseBack.Caption = back
  frmDetails.lblInTop2000Back.Caption = back

  skipEdition = 0

END SUB

SUB LoadTrackDetails ()
    OPEN "TOP2000.DAT" FOR ISAM TrackType "Tracks" AS #1
    SETINDEX #1, "ById"
    DIM track AS TrackType
    
    DIM tId AS INTEGER
    tId = VAL(LTRIM$(frmDetails.lblTrackId.Caption))
    
    SEEKEQ #1, tId
    
    RETRIEVE #1, track

    frmDetails.lblTrackTitle.Caption = track.Title
    frmDetails.lblTrackArtist.Caption = RTRIM$(track.Artist)
    frmDetails.lblTrackYear.Caption = "(" + LTRIM$(STR$(track.Year)) + ")"
    frmDetails.lblHighPosition.Caption = LTRIM$(STR$(track.HighPosition))
    frmDetails.lblLowPosition.Caption = LTRIM$(STR$(track.LowPosition))
    frmDetails.lblFirstPosition.Caption = LTRIM$(STR$(track.FirstPosition))
    frmDetails.lblLastPosition.Caption = LTRIM$(STR$(track.LastPosition))

    frmDetails.lblHighEdition.Caption = "(" + LTRIM$(STR$(track.HighEdition)) + ")"
    frmDetails.lblLowEdition.Caption = "(" + LTRIM$(STR$(track.LowEdition)) + ")"
    frmDetails.lblFirstEdition.Caption = "(" + LTRIM$(STR$(track.firstEdition)) + ")"
    frmDetails.lblLastEdition.Caption = "(" + LTRIM$(STR$(track.lastEdition)) + ")"

    IF LEN(RTRIM$(track.LastPlayTime)) > 5 THEN
        frmDetails.lblLastPlayTime.Caption = track.LastPlayTime
    ELSE
        frmDetails.lblLastPlayTime.Caption = ""
    END IF

    frmDetails.lblSinceReleaseNr.Caption = LTRIM$(STR$(track.Appearances)) + "/" + LTRIM$(STR$(track.AppearancesPositions))
    frmDetails.lblInTop2000Nr.Caption = LTRIM$(STR$(track.Appearances)) + "/" + LTRIM$(STR$(totalEditions))

    DIM calc AS DOUBLE
    DIM toMax AS INTEGER
    DIM I AS INTEGER
    calc = track.Appearances / track.AppearancesPositions
    calc = calc * 20
    toMax = FIX(calc)
    a$ = CHR$(177)

    FOR I = 2 TO toMax
      a$ = a$ + CHR$(177)
    NEXT I
    frmDetails.lblSinceRelease.Caption = a$

    calc = track.Appearances / totalEditions
    calc = calc * 20
    toMax = FIX(calc)
    a$ = CHR$(177)

    FOR I = 2 TO toMax
      a$ = a$ + CHR$(177)
    NEXT I
    frmDetails.lblInTop2000.Caption = a$
    frmDetails.lblTrackYear.Left = LEN(RTRIM$(track.Artist)) + 3

    CLOSE #1

    CALL AddEditionsToScreen

END SUB

SUB MoveAppearancesLeft ()
 DIM leftEdition AS INTEGER
 leftEdition = VAL(frmDetails.lblEdition(0).Caption)

 IF leftEdition < lastEdition THEN
    skipEdition = skipEdition - 1
    CALL AddEditionsToScreen
 END IF


END SUB

SUB MoveAppearancesRight ()
 DIM rightEdition AS INTEGER
 rightEdition = VAL(frmDetails.lblEdition(8).Caption)

  IF rightEdition > firstEdition THEN
    skipEdition = skipEdition + 1
    CALL AddEditionsToScreen
  END IF

END SUB

