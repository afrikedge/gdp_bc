tableextension 50000 "A02 Currency" extends Currency
{

    //Unsupported feature: Code Modification on "GetGainLossAccount(PROCEDURE 6)".

    //procedure GetGainLossAccount();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    OnBeforeGetGainLossAccount(Rec,DtldCVLedgEntryBuf);

    CASE DtldCVLedgEntryBuf."Entry Type" OF
    #4..11
      ELSE
        ERROR(IncorrectEntryTypeErr,DtldCVLedgEntryBuf."Entry Type");
    END;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*

    //***************************************************Cpte change Progal
    AddOnSetup.GET;
    AddOnSetup.TESTFIELD(AddOnSetup."PROGAL Vendor Code");
    IF (AddOnSetup."PROGAL Vendor Code"=DtldCVLedgEntryBuf."CV No.") THEN
      EXIT (GetGainLossAccount_PROGAL(DtldCVLedgEntryBuf));
    //***************************************************


    #1..14
    */
    //end;

    procedure GetGainLossAccount_PROGAL(DtldCVLedgEntryBuf: Record "Detailed CV Ledg. Entry Buffer"): Code[20]
    begin
        AddOnSetup.GET;
        CASE DtldCVLedgEntryBuf."Entry Type" OF
            DtldCVLedgEntryBuf."Entry Type"::"Unrealized Loss":
                BEGIN
                    AddOnSetup.TESTFIELD("PROGAL Unrealized Losses Acc.");
                    EXIT(AddOnSetup."PROGAL Unrealized Losses Acc.");
                END;
            DtldCVLedgEntryBuf."Entry Type"::"Unrealized Gain":
                BEGIN
                    AddOnSetup.TESTFIELD("PROGAL Unrealized Gains Acc.");
                    EXIT(AddOnSetup."PROGAL Unrealized Gains Acc.");
                END;
            DtldCVLedgEntryBuf."Entry Type"::"Realized Loss":
                BEGIN
                    AddOnSetup.TESTFIELD("PROGAL Realized Losses Acc.");
                    EXIT(AddOnSetup."PROGAL Realized Losses Acc.");
                END;
            DtldCVLedgEntryBuf."Entry Type"::"Realized Gain":
                BEGIN
                    AddOnSetup.TESTFIELD("PROGAL Realized Gains Acc.");
                    EXIT(AddOnSetup."PROGAL Realized Gains Acc.");
                END;
            ELSE
                ERROR(IncorrectEntryTypeErr, DtldCVLedgEntryBuf."Entry Type");
        END;
    end;

    var
        AddOnSetup: Record "AddOn Setup";
        IncorrectEntryTypeErr: Label 'Incorrect Entry Type %1.';
}

