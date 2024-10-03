tableextension 50065 "A02 Transfer Header" extends "Transfer Header"
{
    fields
    {
        field(50000; "Transfer Type"; Option)
        {
            Caption = 'Transfer Type';
            Editable = false;
            OptionCaption = 'Normal Transfer,Hypothetical Transfer';
            OptionMembers = Normal,Hypothetical;

            trigger OnValidate()
            begin
                AFK_CheckShippedLinesExists;
                IF Rec."Transfer Type" = Rec."Transfer Type"::Hypothetical THEN BEGIN
                    AddOnSetup.GET;
                    AddOnSetup.TESTFIELD(AddOnSetup."Transit Location Transfer");
                    Rec.VALIDATE(Rec."Transfer-to Code", AddOnSetup."Transit Location Transfer");
                    Rec."Transfer Doc Type" := Rec."Transfer Doc Type"::"Hypothetical Shipment";
                END;
            end;
        }
        field(50001; "Original Transfer No"; Code[20])
        {
            Caption = 'Original Transfer No';
        }
        field(50002; "Transfer Doc Type"; Option)
        {
            Caption = 'Transfer Document';
            Editable = false;
            OptionCaption = 'Simple,Hypothetical Shipment,Hypothetical Receipt';
            OptionMembers = Simple,"Hypothetical Shipment","Hypothetical Receipt";
        }
        field(50003; "Receive-to Code"; Code[10])
        {
            Caption = 'Receive to Location';
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));

            trigger OnValidate()
            var
                //Location: Record "14";
                Confirmed: Boolean;
            begin
            end;
        }
        field(50004; "Truck Code"; Code[20])
        {
            Caption = 'Truck code';
            TableRelation = pro_moyentransport.immatriculation;

            trigger OnValidate()
            begin
                IF Camion.GET("Truck Code") THEN BEGIN
                    nomchauffeur := Camion.nomchauffeur;
                    prenomchauffeur := Camion.prenomchauffeur;
                    permis := Camion.permis;
                    CarteGrise := Camion.CarteGrise;
                    IF (Camion.codetransporteur <> '') THEN
                        VALIDATE("Transporter Code", Camion.codetransporteur);
                END
            end;
        }
        field(50005; "Transporter Code"; Code[20])
        {
            Caption = 'Transporter';
            TableRelation = Vendor WHERE(Transporter = CONST(false));

            trigger OnValidate()
            begin
                IF Vend1.GET("Transporter Code") THEN
                    "Transporter Name" := Vend1.Name;
            end;
        }
        field(50006; "Transporter Name"; Text[50])
        {
        }
        field(50007; nomchauffeur; Text[50])
        {
            Caption = 'Driver Name';
        }
        field(50008; prenomchauffeur; Text[50])
        {
            Caption = 'Driver First Name';
        }
        field(50009; permis; Text[50])
        {
            Caption = 'Permis';
        }
        field(50010; CarteGrise; Text[30])
        {
        }
    }

    //Unsupported feature: Variable Insertion (Variable: DoNotDelete) (VariableCollection) on "DeleteOneTransferOrder(PROCEDURE 4)".



    //Unsupported feature: Code Modification on "DeleteOneTransferOrder(PROCEDURE 4)".

    //procedure DeleteOneTransferOrder();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    No := TransHeader2."No.";

    WhseRequest.SETRANGE("Source Type",DATABASE::"Transfer Line");
    WhseRequest.SETRANGE("Source No.",No);
    IF NOT WhseRequest.ISEMPTY THEN
      WhseRequest.DELETEALL(TRUE);

    InvtCommentLine.SETRANGE("Document Type",InvtCommentLine."Document Type"::"Transfer Order");
    InvtCommentLine.SETRANGE("No.",No);
    InvtCommentLine.DELETEALL;
    #11..18
      TransLine2.DELETEALL;

    TransHeader2.DELETE;
    IF NOT HideValidationDialog THEN
      MESSAGE(TransferOrderPostedMsg1,No);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*

    No := TransHeader2."No.";

    //*********************************************************************************************
    //*********************************************************************************************
    IF TransHeader2."Transfer Type"=TransHeader2."Transfer Type"::Hypothetical THEN BEGIN
      IF TransHeader2."Transfer Doc Type" = TransHeader2."Transfer Doc Type"::"Hypothetical Shipment" THEN
        IF NOT AFKAllowDeletionHypo THEN
          DoNotDelete := TRUE;
    END;
    IF DoNotDelete THEN EXIT;
    //*********************************************************************************************
    //*********************************************************************************************


    #2..7
    //************************************************************************
    //Archive before deletion
    //************************************************************************
    AFKTransferMgt.ArchiveTransfer(TransHeader2);
    //************************************************************************
    //************************************************************************

    #8..21
    //IF NOT HideValidationDialog THEN **************************************
    //  MESSAGE(TransferOrderPostedMsg1,No);**************************************


    // No := TransHeader2."No.";
    //
    // {>>>>>>>} ORIGINAL
    // IF NOT DoNotDelete THEN BEGIN
    //  WhseRequest.SETRANGE("Source Type",DATABASE::"Transfer Line");
    //  WhseRequest.SETRANGE("Source No.",No);
    // {=======} MODIFIED
    //
    // //*********************************************************************************************
    // //*********************************************************************************************
    // IF TransHeader2."Transfer Type"=TransHeader2."Transfer Type"::Hypothetical THEN BEGIN
    //  IF TransHeader2."Transfer Doc Type" = TransHeader2."Transfer Doc Type"::"Hypothetical Shipment" THEN
    //    IF NOT AFKAllowDeletionHypo THEN
    //      DoNotDelete := TRUE;
    // END;
    // //*********************************************************************************************
    // //*********************************************************************************************
    //
    // IF NOT DoNotDelete THEN BEGIN
    //  WhseRequest.SETRANGE("Source Type",DATABASE::"Transfer Line");
    //  WhseRequest.SETRANGE("Source No.",No);
    // {=======} TARGET
    // WhseRequest.SETRANGE("Source Type",DATABASE::"Transfer Line");
    // WhseRequest.SETRANGE("Source No.",No);
    // IF NOT WhseRequest.ISEMPTY THEN
    // {<<<<<<<}
    //  WhseRequest.DELETEALL(TRUE);
    //
    // {>>>>>>>} ORIGINAL
    //  InvtCommentLine.SETRANGE("Document Type",InvtCommentLine."Document Type"::"Transfer Order");
    //  InvtCommentLine.SETRANGE("No.",No);
    //  InvtCommentLine.DELETEALL;
    // {=======} MODIFIED
    //  //************************************************************************
    //  //Archive before deletion
    //  //************************************************************************
    //  AFKTransferMgt.ArchiveTransfer(TransHeader2);
    //  //************************************************************************
    //  //************************************************************************
    //
    //
    //  InvtCommentLine.SETRANGE("Document Type",InvtCommentLine."Document Type"::"Transfer Order");
    //  InvtCommentLine.SETRANGE("No.",No);
    //  InvtCommentLine.DELETEALL;
    // {=======} TARGET
    // InvtCommentLine.SETRANGE("Document Type",InvtCommentLine."Document Type"::"Transfer Order");
    // InvtCommentLine.SETRANGE("No.",No);
    // InvtCommentLine.DELETEALL;
    // {<<<<<<<}
    //
    // ItemChargeAssgntPurch.SETCURRENTKEY(
    //  "Applies-to Doc. Type","Applies-to Doc. No.","Applies-to Doc. Line No.");
    // ItemChargeAssgntPurch.SETRANGE("Applies-to Doc. Type",ItemChargeAssgntPurch."Applies-to Doc. Type"::"Transfer Receipt");
    // ItemChargeAssgntPurch.SETRANGE("Applies-to Doc. No.",TransLine2."Document No.");
    // ItemChargeAssgntPurch.DELETEALL;
    //
    // IF TransLine2.FIND('-') THEN
    //  TransLine2.DELETEALL;
    //
    // {>>>>>>>} ORIGINAL
    //  TransHeader2.DELETE;
    //  IF NOT HideValidationDialog THEN
    //    MESSAGE(Text003,No);
    //  EXIT(TRUE);
    // END;
    // EXIT(FALSE);
    // {=======} MODIFIED
    //  TransHeader2.DELETE;
    //  //IF NOT HideValidationDialog THEN    //*************************************************
    //  //  MESSAGE(Text003,No);               //************************************************
    //  EXIT(TRUE);
    // END;
    // EXIT(FALSE);
    // {=======} TARGET
    // TransHeader2.DELETE;
    // IF NOT HideValidationDialog THEN
    //  MESSAGE(TransferOrderPostedMsg1,No);
    // {<<<<<<<}
    */
    //end;

    local procedure AFK_CheckShippedLinesExists()
    begin
        //************************************************
        //TODO Migration
        // TransLine.RESET;
        // TransLine.SETRANGE("Document No.", "No.");
        // IF TransLine.FINDSET THEN
        //     REPEAT
        //         TransLine.TESTFIELD("Quantity Shipped", 0);
        //     UNTIL TransLine.NEXT = 0;
    end;

    procedure AFK_SetAllowDeletionHypo(CanDelete: Boolean)
    begin
        AFKAllowDeletionHypo := CanDelete;
    end;

    var
        AddOnSetup: Record "50000";
        AFKGriserMagasinDest: Boolean;
        AFKAllowDeletionHypo: Boolean;
        //AFKTransferMgt: Codeunit "50005";
        Camion: Record "50009";
        Vend1: Record "23";
}

