table 50061 "AMSA Sales Price"
{
    Caption = 'AMSA Sales Price';
    LookupPageID = "Sales Prices";

    fields
    {
        field(1;"Item No.";Code[20])
        {
            Caption = 'Item No.';
            NotBlank = true;
            TableRelation = Item;

            trigger OnValidate()
            begin
                /*
                IF "Item No." <> xRec."Item No." THEN BEGIN
                  Item.GET("Item No.");
                  "Unit of Measure Code" := Item."Sales Unit of Measure";
                  "Variant Code" := '';
                END;
                
                IF "Sales Type" = "Sales Type"::"1" THEN
                  IF CustPriceGr.GET("Sales Code") AND
                     (CustPriceGr."Allow Invoice Disc." = "Allow Invoice Disc.")
                  THEN
                    EXIT;
                
                UpdateValuesFromItem;
                */

            end;
        }
        field(3;"Currency Code";Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(4;"Starting Date";Date)
        {
            Caption = 'Starting Date';

            trigger OnValidate()
            begin
                //IF ("Starting Date" > "Ending Date") AND ("Ending Date" <> 0D) THEN
                //  ERROR(Text000,FIELDCAPTION("Starting Date"),FIELDCAPTION("Ending Date"));

                if CurrFieldNo = 0 then
                  exit;

                //IF "Starting Date" <> 0D THEN
                //  IF "Sales Type" = "Sales Type"::"3" THEN
                //    ERROR(Text002,"Sales Type");
            end;
        }
        field(5;"Unit Price";Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 2;
            Caption = 'Unit Price';
            MinValue = 0;
        }
        field(6;"Source Type";Option)
        {
            Caption = 'Source Appro';
            OptionCaption = 'Station,Tanker';
            OptionMembers = Station,Tanker;
        }
    }

    keys
    {
        key(Key1;"Source Type","Item No.","Starting Date","Currency Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        //IF "Sales Type" = "Sales Type"::"2" THEN
        //  "Sales Code" := ''
        //ELSE
        //  TESTFIELD("Sales Code");
        //TESTFIELD("Item No.");
    end;

    trigger OnRename()
    begin
        //IF "Sales Type" <> "Sales Type"::"2" THEN
        //  TESTFIELD("Sales Code");
        //TESTFIELD("Item No.");
    end;

    var
        CustPriceGr: Record "Customer Price Group";
        Text000: Label '%1 cannot be after %2';
        Cust: Record Customer;
        Text001: Label '%1 must be blank.';
        Campaign: Record Campaign;
        Item: Record Item;
        Text002: Label 'If Sales Type = %1, then you can only change Starting Date and Ending Date from the Campaign Card.';

    local procedure UpdateValuesFromItem()
    begin
    end;
}

