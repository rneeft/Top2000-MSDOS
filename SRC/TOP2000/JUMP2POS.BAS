'$FORM frmJump2Pos

SUB OnCancelClick ()
    frmJump2Pos.HIDE
END SUB

SUB OnOkClick ()
    DIM position AS INTEGER
    position = VAL(frmJump2Pos.txtPosition.Text)

    IF position < 1 OR position > 2000 THEN
        MSGBOX "Positie moet tussen 1 en 2000 liggen"
    ELSE
        IF position > 1991 THEN position = 1991

        Main.scrPositions.Value = position
        frmJump2Pos.HIDE
    END IF

END SUB

