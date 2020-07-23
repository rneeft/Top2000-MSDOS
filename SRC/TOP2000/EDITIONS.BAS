'$FORM frmDetails
'$FORM frmMain
'$FORM frmEditions

COMMON SHARED editionOnView AS INTEGER
COMMON SHARED firstEdition AS INTEGER
COMMON SHARED lastEdition AS INTEGER

SUB OnEditionsChange ()

    DIM edition AS INTEGER
    edition = VAL(frmEditions.txtEdition.Text)
    IF edition < firstEdition OR edition > lastEdition THEN
        MSGBOX "Kies een editie tussen " + LTRIM$(STR$(firstEdition)) + " en " + LTRIM$(STR$(lastEdition))
    ELSE
        frmMain.lblEdition.Caption = frmEditions.txtEdition.Text

        UNLOAD frmEditions
    END IF

END SUB

SUB OnEditionsChangingLoad ()

  frmEditions.lblMinMax.Caption = "(" + LTRIM$(STR$(firstEdition)) + "-" + LTRIM$(STR$(lastEdition)) + ")"

END SUB

SUB ShowEditionInTextBox (KeyCode AS INTEGER)
    DIM I AS INTEGER
    I = VAL(frmEditions.txtEdition.Text)

    SELECT CASE KeyCode
        CASE 37
            I = firstEdition
        CASE 38
            I = I - 1
        CASE 39
            I = lastEdition
        CASE 40
            I = I + 1
        CASE ELSE
            EXIT SUB
    END SELECT

    IF I < firstEdition THEN I = firstEdition
    IF I > lastEdition THEN I = lastEdition

    frmEditions.txtEdition.Text = LTRIM$(STR$(I))
END SUB

