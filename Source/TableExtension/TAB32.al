tableextension 50010 "A02 Item Ledger Entry" extends "Item Ledger Entry"
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
        field(50011; "Reason Code"; Code[10])
        {
            AccessByPermission = TableData 223 = R;
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
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
        field(50030; "Batch Number"; Code[100])
        {
            Caption = 'Batch Number';
        }
        field(50031; "LUB Expiration Date"; Date)
        {
            Caption = 'Expiration Date';
        }
        field(50100; "Transaction Date"; Date)
        {
            Caption = 'Transaction Date';
            Editable = false;
        }
        field(50101; "User ID"; Code[50])
        {
            Caption = 'User ID';
            Editable = false;
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnLookup()
            var
            //UserMgt: Codeunit "418";
            begin
                //UserMgt.LookupUserID("User ID");
            end;
        }
        field(50102; "Cargo Adjusted"; Boolean)
        {
        }
        field(50103; "Num Doc Liaison PBL"; Code[20])
        {
            Caption = 'N° Doc Liaison PBL';
            Editable = false;
        }
    }
    keys
    {
        //TODO********MIGRATION*******************************
        // key(A02Key1;"Entry Type","Ref Cargo","Item No.")
        // {
        // }
        // key(A02Key2;Positive,"Sales Channel Code","Posting Date")
        // {
        // }
    }

    //Unsupported feature: Variable Insertion (Variable: Loc) (VariableCollection) on "VerifyOnInventory(PROCEDURE 9)".



    //Unsupported feature: Code Modification on "VerifyOnInventory(PROCEDURE 9)".

    //procedure VerifyOnInventory();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IF NOT Open THEN
      EXIT;
    IF Quantity >= 0 THEN
      EXIT;
    CASE "Entry Type" OF
      "Entry Type"::Consumption,"Entry Type"::"Assembly Consumption","Entry Type"::Transfer:
        ERROR(IsNotOnInventoryErr,"Item No.");
      ELSE BEGIN
        Item.GET("Item No.");
        IF Item.PreventNegativeInventory THEN
          ERROR(IsNotOnInventoryErr,"Item No.");
      END;
    END;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..5

      "Entry Type"::Consumption,"Entry Type"::"Assembly Consumption","Entry Type"::Transfer:
        ERROR(IsNotOnInventoryErr,"Item No.");

      ELSE BEGIN
        Item.GET("Item No.");
        Loc.GET("Location Code");//**********************************************************************ADDED
        IF Item.PreventNegativeInventory THEN
          IF NOT Loc."Allow Negative Stock" THEN//*******************************************************ADDED
            ERROR(IsNotOnInventoryErr,"Item No.");
        //IF Item.PreventNegativeInventory THEN
          //ERROR(IsNotOnInventoryErr,"Item No.");
      END;
    END;
    */
    //end;
}

