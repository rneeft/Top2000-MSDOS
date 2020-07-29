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
DIM SHARED firstResize AS INTEGER

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

SUB MovePositions (positions AS INTEGER)
    currentPosition = currentPosition + positions
    IF currentPosition < 0 THEN currentPosition = 0
    IF currentPosition > 1991 THEN currentPosition = 1991

    CALL SetNewPosition
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
    frmEditions.HIDE
    frmDetails.HIDE
    frmJump2pos.HIDE
    frmMain.HIDE
    CLS
    PRINT "Bedankt voor het gebruik van TOP 2000 voor MS-DOS"
    PRINT "Bekijk de code op https://github.com/rneeft/Top2000-MSDOS"
    PRINT ""
    PRINT "Rick"
    END
END SUB

SUB OnFormLoad ()
  
  firstResize = 1
  currentEdition = lastEdition
  currentPosition = 1

  frmMain.lblEdition.Caption = LTRIM$(STR$(lastEdition))

  CALL SetNewPosition

END SUB

SUB OnFormResize ()

    IF firstResize = 1 THEN
        firstResize = 0
        EXIT SUB
    END IF

    IF frmMain.WindowSTATE = 0 THEN Top = 0
    IF frmMain.WindowSTATE = 0 THEN
        IF frmMain.Height <> 25 THEN frmMain.Height = 25
        IF frmMain.Width < 23 THEN frmMain.Width = 23
    END IF
    

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

  frmMain.lblPos(selectedTrackIndex).BackColor = 15
  frmMain.lblTitle(selectedTrackIndex).BackColor = 15
  frmMain.lblArtist(selectedTrackIndex).BackColor = 15
 
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

