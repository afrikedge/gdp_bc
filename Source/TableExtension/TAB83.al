tableextension 50019 "A02 Item Journal Line" extends "Item Journal Line"
{
    fields
    {
        field(50000; "Adjustment Type"; Option)
        {
            Caption = 'Adjustment Type';
            OptionCaption = ' ,BE,Transfer,Exchange,Loan,Loan Return,Consignation,Consignation Return,Borrow,Borrow Return,Invoiced Conso,FA Conso,LUB Shipment,Shipment,Reception,Ajustement BE,Ajustement Naphta,Ajustement BL';
            OptionMembers = " ",BE,Transfer,Exchange,Loan,"Loan Return",Consignation,"Consignation Return",Borrow,"Borrow Return","Invoiced Conso","FA Conso","LUB Ship",Shipment,Reception,AdjBE,AjustNaphta,AdjBL;
        }
        field(50010; "Ref Cargo"; Code[20])
        {
            Caption = 'Cargo';
            TableRelation = Cargo;
        }
        field(50012; "Type Ecr Cargo"; Option)
        {
            Caption = 'Type écriture cargo';
            OptionCaption = ' ,Normale,Fictive';
            OptionMembers = " ",Normale,Fictive;
        }
        field(50013; "Sales Channel Code"; Code[10])
        {
            Caption = 'Sales Channel Code';
            TableRelation = "Sales Channel";
        }
        field(50014; "Customer No"; Code[20])
        {
            Caption = 'Customer Code';
            TableRelation = Customer;
        }
        field(50030; "Batch Number"; Code[100])
        {
            Caption = 'Batch Number';
        }
        field(50031; "LUB Expiration Date"; Date)
        {
            Caption = 'Expiration Date';
        }
        field(50032; "Customer No."; Code[20])
        {
            Caption = 'Code client';
            TableRelation = Customer;
        }
        field(50033; Observations; Text[100])
        {
        }
    }

    //Unsupported feature: Variable Insertion (Variable: PurchHeader) (VariableCollection) on "CopyFromPurchLine(PROCEDURE 160)".



    //Unsupported feature: Code Modification on "CopyFromPurchLine(PROCEDURE 160)".

    //procedure CopyFromPurchLine();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    "Item No." := PurchLine."No.";
    Description := PurchLine.Description;
    "Shortcut Dimension 1 Code" := PurchLine."Shortcut Dimension 1 Code";
    #4..41
    "Overhead Rate" := PurchLine."Overhead Rate";
    "Return Reason Code" := PurchLine."Return Reason Code";

    OnAfterCopyItemJnlLineFromPurchLine(Rec,PurchLine);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..44
      //*************************************************************************
      //JN002********************************************************************
      AddOnSetup.GET;
      PurchHeader.GET(PurchLine."Document Type",PurchLine."Document No.");
      IF (PurchLine."Item Category Code" = AddOnSetup."LUBS Item Category") THEN
        IF PurchHeader."Purchase Type" = PurchHeader."Purchase Type"::AchatMarchandise THEN BEGIN
            PurchLine.TESTFIELD("Expiration Date");
            PurchLine.TESTFIELD("Batch Number");
          END;

      "Ref Cargo":= PurchHeader."Ref Cargo";
      "LUB Expiration Date" := PurchLine."Expiration Date";//JN110321
      "Batch Number" := PurchLine."Batch Number";//JN110321
      //*************************************************************************
      //*************************************************************************

    OnAfterCopyItemJnlLineFromPurchLine(Rec,PurchLine);
    */
    //end;

    procedure AFK_SetDimensions(ItemNo: Code[20]; CustNo: Code[20])
    begin
        // CreateDim(
        //   DATABASE::Item, ItemNo,
        //   DATABASE::Customer, CustNo,
        //   DATABASE::"Work Center", "Work Center No.");
    end;

    procedure AFK_SetDimensionsItem(ItemNo: Code[20])
    begin
        // CreateDim(
        //   DATABASE::Item, ItemNo,
        //   DATABASE::Customer, '',
        //   DATABASE::"Work Center", "Work Center No.");
    end;

    var
    //AddOnSetup: Record "50000";
}

