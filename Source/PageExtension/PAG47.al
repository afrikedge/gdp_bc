pageextension 50011 pageextension70000090 extends "Sales Invoice Subform"
{
    layout
    {

        //Unsupported feature: Property Deletion (Visible) on "Control 14".

        // addafter("Control 106")
        // {
        //     field("AMSA Source Type";Rec."AMSA Source Type")
        //     {
        //         Visible = AFK_IsAMSA;
        //     }
        //     field("AMSA Cost Code";Rec."AMSA Cost Code")
        //     {
        //         Visible = AFK_IsAMSA;
        //     }
        //     field("AMSA BackCharge";Rec."AMSA BackCharge")
        //     {
        //         Visible = AFK_IsAMSA;
        //     }
        //     field("AMSA Equipment Type";Rec."AMSA Equipment Type")
        //     {
        //         Visible = AFK_IsAMSA;
        //     }
        //     field("AMSA Company Code";Rec."AMSA Company Code")
        //     {
        //         Visible = AFK_IsAMSA;
        //     }
        //     field("AMSA Process";Rec."AMSA Process")
        //     {
        //         Visible = AFK_IsAMSA;
        //     }
        // }
        // moveafter("Control 4";Rec."Control 6")
        // moveafter("Control 6";Rec."Control 32")
        // moveafter("Control 32";Rec."Control 8")
        // moveafter("Control 10";Rec."Control 12")
        // moveafter("Control 12";Rec."Control 64")
        // moveafter("Control 64";Rec."Control 20")
    }

    var
        SalesHeader: Record "36";

    var
        AFK_IsAMSA: Boolean;
        AFK_SalesProcess: Codeunit "50001";
        CanEditPrices: Boolean;
        AddOnSetup: Record "50000";
        AFK_CanUpdatePrice: Boolean;
        AFK_SecMgt: Codeunit "50016";


    //Unsupported feature: Code Insertion (VariableCollection) on "OnAfterGetCurrRecord".

    //trigger (Variable: SalesHeader)()
    //Parameters and return type have not been exported.
    //begin
    /*
    */
    //end;


    //Unsupported feature: Code Modification on "OnAfterGetCurrRecord".

    //trigger OnAfterGetCurrRecord()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    GetTotalSalesHeader;
    CalculateTotals;
    UpdateEditableOnRow;
    SetItemChargeFieldsStyle;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*



    //***********************************************************
    //***********************************************************
    IF SalesHeader.GET("Document Type","Document No.") THEN;
    AddOnSetup.GET;
    AFK_IsAMSA := AFK_SalesProcess.IsCdeAMSA(SalesHeader);
    CanEditPrices := TRUE;
    IF ((NOT AFK_SalesProcess.IsCdeJIRAMA(SalesHeader)
      AND (Rec."Item Category Code"=AddOnSetup."PBL Category Code")))THEN
      CanEditPrices := FALSE;

    AFK_CanUpdatePrice := AFK_SecMgt.CanUpdatePrices;

    #1..4
    */
    //end;
}

