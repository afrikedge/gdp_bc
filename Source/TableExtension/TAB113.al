tableextension 50027 "A02 Sales Invoice Line" extends "Sales Invoice Line"
{
    // Confirm Consignation Sales from Invoice
    // //JN 310718 Sauvegarde PU utilises pour redevance OMH dans les lignes factures
    fields
    {
        field(50000; "Card Number"; Code[10])
        {
            Caption = 'Card Number';
        }
        field(50001; "Consignation Line No."; Integer)
        {
            Editable = false;
        }
        field(50002; "Qty to remove"; Decimal)
        {
            Caption = 'Qty to remove';
        }
        field(50003; "Qty to prepare"; Decimal)
        {
            Caption = 'Qty to prepare';
        }
        field(50010; "OMH Fees Price"; Decimal)
        {
        }
        field(50011; "FER Fees Price"; Decimal)
        {
        }
        field(50012; "ENV Fees Price"; Decimal)
        {
        }
        field(50013; "Sales Category Code"; Code[10])
        {
            Caption = 'Sales Category';
            TableRelation = "Sales Category";
        }
        field(50014; "RDS Fees Price"; Decimal)
        {
        }
        field(50030; "Initial Qty"; Decimal)
        {
            Caption = 'Initial Qty';
            Editable = false;
        }
        field(50070; "AMSA Source Type"; Option)
        {
            Caption = 'AMSA Source Type';
            OptionCaption = 'Station,Tanker';
            OptionMembers = Station,Tanker;
        }
        field(50071; IsAMSA; Boolean)
        {
        }
        field(50072; "AMSA Cost Code"; Code[20])
        {
        }
        field(50073; "AMSA BackCharge"; Option)
        {
            Caption = 'Backcharge';
            OptionCaption = ' ,Yes,No';
            OptionMembers = " ",Yes,No;
        }
        field(50074; "AMSA Equipment Type"; Option)
        {
            Caption = 'Equipment Type';
            OptionCaption = 'Mobile,Fixed';
            OptionMembers = Mobile,"Fixed";
        }
        field(50075; "AMSA Company Code"; Code[30])
        {
        }
        field(50076; "AMSA Process"; Option)
        {
            OptionCaption = ' ,Yes,No';
            OptionMembers = " ",Yes,No;
        }
        field(50077; "AMSA Invoice No."; Code[20])
        {
        }
        field(50078; "AMSA Order No."; Code[20])
        {
        }
        field(50079; "Real Location"; Code[10])
        {
        }
        field(50080; VAT20Amount; Decimal)
        {
        }
        field(50081; VAT15Amount; Decimal)
        {
        }
    }
    keys
    {
        // key(Key1;IsAMSA,"Posting Date")
        // {
        // }
        // key(Key2;"Sell-to Customer No.",Type,"No.","Posting Date")
        // {
        // }
    }
    procedure GetParentCategory(): Code[20]
    var
        ItemCat: Record "Item Category";
    begin
        if (ItemCat.Get(Rec."Item Category Code")) then
            exit(ItemCat."Parent Category");
    end;

    //Unsupported feature: Variable Insertion (Variable: AFKItem1) (VariableCollection) on "InitFromSalesLine(PROCEDURE 12)".



    //Unsupported feature: Code Modification on "InitFromSalesLine(PROCEDURE 12)".

    //procedure InitFromSalesLine();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    INIT;
    TRANSFERFIELDS(SalesLine);
    IF ("No." = '') AND (Type IN [Type::"G/L Account"..Type::"Charge (Item)"]) THEN
    #4..6
    Quantity := SalesLine."Qty. to Invoice";
    "Quantity (Base)" := SalesLine."Qty. to Invoice (Base)";

    OnAfterInitFromSalesLine(Rec,SalesInvHeader,SalesLine);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..9
    //310718**************************************************
    IF (SalesLine.Type = SalesLine.Type::Item) THEN BEGIN
      AFKItem1.GET(SalesLine."No.");
      "OMH Fees Price" := AFKItem1."OMH Fees Price";
      "FER Fees Price" := AFKItem1."FER Fees Price";
      "ENV Fees Price" := AFKItem1."ENV Fees Price";
      "RDS Fees Price" := AFKItem1."RDS Fees Price";
    END;
    //END*****************************************************

    OnAfterInitFromSalesLine(Rec,SalesInvHeader,SalesLine);
    */
    //end;

    var
    //ItemConsignationMgt: Codeunit "50008";
}

