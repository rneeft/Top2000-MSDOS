DECLARE SUB LoadTrackDetails ()
DECLARE SUB PutTracksOnScreen ()
'$FORM frmAbout
'$FORM frmEditions
'$FORM frmJump2pos
'$FORM frmMain
'$FORM frmDetails
DECLARE SUB SetNewPosition ()
COMMON SHARED editionOnView AS INTEGER
COMMON SHARED firstEdition AS INTEGER
COMMON SHARED lastEdition AS INTEGER
COMMON SHARED totalEditions AS INTEGER
DIM SHARED currentEdition AS INTEGER
DIM SHARED currentPosition AS INTEGER
DIM SHARED selectedTrackIndex AS INTEGER

TYPE ListingType
    edition AS INTEGER
    position AS INTEGER
    trackId AS INTEGER
END TYPE

TYPE TrackType
    Id AS INTEGER
    TITLE AS STRING * 57
    Artist AS STRING * 44
    Year AS INTEGER
END TYPE

SUB GotoDelta (D AS INTEGER)
    DIM current AS INTEGER
    current = scrPositions.Value + D

    IF current > 1991 THEN
        current = 1991
    END IF

    IF current < 1 THEN
        current = 1
    END IF

    scrPositions.Value = current

END SUB

SUB MovePositions (positions AS INTEGER)
    MSGBOX STR$(positions)
END SUB

SUB OnEditionChanged ()
    DIM newEdition AS INTEGER
    newEdition = VAL(frmMain.lblEdition.Caption)

    IF NOT currentEdition = newEdition THEN
        currentEdition = newEdition
        CALL SetNewPosition
    END IF

END SUB

SUB OnExit ()
    frmAbout.HIDE
    frmEditions.HIDE
    frmDetails.HIDE
    frmJump2pos.HIDE
    frmMain.HIDE
    CLS
    END
END SUB

SUB OnFormLoad ()
  'ON LOCAL ERROR GOTO DiskCheck

  Left = 0

  currentEdition = lastEdition
  currentPosition = 1

  frmMain.lblEdition.Caption = LTRIM$(STR$(lastEdition))

  CALL SetNewPosition
  EXIT SUB

DiskCheck:
    M$ = "Unable to find the TOP 2000 database." + CHR$(13) + CHR$(10) + CHR$(13) + CHR$(10)
    M$ = M$ + "Please make the the TOP2000.DAT file " + CHR$(13) + CHR$(10)
    M$ = M$ + "is located next to the Top2000 executable" + CHR$(13) + CHR$(10)
    M$ = M$ + CHR$(13) + CHR$(10)
    M$ = M$ + "Error code: " + STR$(ERR)
    MSGBOX M$, 0, "TOP 2000 database missing"
    END


END SUB

SUB OnFormResize ()
    IF frmMain.WindowSTATE = 0 THEN Top = 0
    IF frmMain.Height <> 25 THEN frmMain.Height = 25
    IF frmMain.Width < 23 THEN frmMain.Width = 23

    IF frmMain.Width > 10 THEN

        frmMain.lblEdition.Width = frmMain.Width - 4
        frmMain.lblBottom.Width = frmMain.Width - 4
        frmMain.scrPositions.Left = frmMain.Width - 4

        CALL PutTracksOnScreen

    END IF

END SUB

SUB OnPositionChanged ()
    currentPosition = frmMain.scrPositions.Value
    CALL SetNewPosition
END SUB

SUB OnTrackClick (Index AS INTEGER)

    frmMain.lblPos(selectedTrackIndex).BackColor = 15
    frmMain.lblTitle(selectedTrackIndex).BackColor = 15
    frmMain.lblArtist(selectedTrackIndex).BackColor = 15

    selectedTrackIndex = Index
    frmMain.lblPos(selectedTrackIndex).BackColor = 4
    frmMain.lblTitle(selectedTrackIndex).BackColor = 4
    frmMain.lblArtist(selectedTrackIndex).BackColor = 4

    frmDetails.lblTrackId.Caption = frmMain.lblPos(selectedTrackIndex).Tag
    CALL LoadTrackDetails
    frmDetails.SHOW 0
    frmDetails.SETFOCUS
    

END SUB

SUB OpenAbout ()
    frmAbout.SHOW 0
END SUB

SUB PutTracksOnScreen ()
    DIM maxSize AS INTEGER
    DIM I AS INTEGER
    maxSize = frmMain.Width - 9
    
    FOR I = 0 TO 9

        IF LEN(frmMain.lblTitle(I).Tag) > maxSize THEN
            frmMain.lblTitle(I).Caption = LEFT$(frmMain.lblTitle(I).Tag, (maxSize - 3)) + ".."
        ELSE
            frmMain.lblTitle(I).Caption = frmMain.lblTitle(I).Tag
        END IF

        IF LEN(frmMain.lblArtist(I).Tag) > maxSize THEN
            frmMain.lblArtist(I).Caption = LEFT$(frmMain.lblArtist(I).Tag, maxSize - 3) + ".."
        ELSE
            frmMain.lblArtist(I).Caption = frmMain.lblArtist(I).Tag
        END IF

        frmMain.lblArtist(I).Width = maxSize
        frmMain.lblTitle(I).Width = maxSize

    NEXT I
END SUB

SUB SelectOtherEdition ()
    frmEditions.SHOW 0
END SUB

SUB SetNewPosition ()

  OPEN "TOP2000.DAT" FOR ISAM ListingType "Listings" AS #1
  OPEN "TOP2000.DAT" FOR ISAM TrackType "Tracks" AS #2

  SETINDEX #1, "ByEdition"
  SETINDEX #2, "ById"

  DIM listing AS ListingType
  DIM track AS TrackType
  DIM maxSize AS INTEGER
  maxSize = frmMain.Width - 9

  DIM I AS INTEGER
  IF currentPosition < 1 THEN currentPosition = 1
  IF currentPosition + max > 2001 THEN currentPosition = 2001 - max

  FOR I = 0 TO 9
    SEEKEQ #1, currentEdition, (currentPosition + I)
    RETRIEVE #1, listing

    SEEKEQ #2, listing.trackId
    RETRIEVE #2, track

    frmMain.lblTitle(I).Tag = RTRIM$(track.TITLE)
    frmMain.lblArtist(I).Tag = RTRIM$(track.Artist)
    frmMain.lblPos(I).Caption = STR$(listing.position)
    frmMain.lblPos(I).Tag = STR$(listing.trackId)

    IF LEN(frmMain.lblTitle(I).Tag) > maxSize THEN
        frmMain.lblTitle(I).Caption = LEFT$(frmMain.lblTitle(I).Tag, (maxSize - 3)) + ".."
    ELSE
        frmMain.lblTitle(I).Caption = frmMain.lblTitle(I).Tag
    END IF

    IF LEN(frmMain.lblArtist(I).Tag) > maxSize THEN
        frmMain.lblArtist(I).Caption = LEFT$(frmMain.lblArtist(I).Tag, maxSize - 3) + ".."
    ELSE
        frmMain.lblArtist(I).Caption = frmMain.lblArtist(I).Tag
    END IF

  NEXT I

  CLOSE #2
  CLOSE #1

END SUB

