table 50022 "Posted Moneytech Import"
{
    Caption = 'Posted Moneytech Import';

    fields
    {
        field(1;"No.";Code[20])
        {
            Caption = 'No.';

            trigger OnValidate()
            begin

                if "No." <> xRec."No." then begin
                  AddOnSetup.Get;
                  AddOnSetup.TestField(AddOnSetup."Sales by Cards Nos.");
                  NoSeriesMgt.TestManual(AddOnSetup."Sales by Cards Nos.");
                  "No. Series" := '';
                end;
            end;
        }
        field(3;"Starting Date";Date)
        {
        }
        field(4;"Ending Date";Date)
        {
        }
        field(6;Status;Option)
        {
            OptionCaption = 'Created,Validated';
            OptionMembers = Created,Validated;
        }
        field(20;"Posting Date";Date)
        {
            Caption = 'Posting Date';

            trigger OnValidate()
            begin
                /*
                TestNoSeriesDate(
                  "Posting No.","Posting No. Series",
                  FIELDCAPTION("Posting No."),FIELDCAPTION("Posting No. Series"));
                TestNoSeriesDate(
                  "Prepayment No.","Prepayment No. Series",
                  FIELDCAPTION("Prepayment No."),FIELDCAPTION("Prepayment No. Series"));
                TestNoSeriesDate(
                  "Prepmt. Cr. Memo No.","Prepmt. Cr. Memo No. Series",
                  FIELDCAPTION("Prepmt. Cr. Memo No."),FIELDCAPTION("Prepmt. Cr. Memo No. Series"));
                
                VALIDATE("Document Date","Posting Date");
                
                IF ("Document Type" IN ["Document Type"::Invoice,"Document Type"::"Credit Memo"]) AND
                   NOT ("Posting Date" = xRec."Posting Date")
                THEN
                  PriceMessageIfSalesLinesExist(FIELDCAPTION("Posting Date"));
                
                IF "Currency Code" <> '' THEN BEGIN
                  UpdateCurrencyFactor;
                  IF "Currency Factor" <> xRec."Currency Factor" THEN
                    ConfirmUpdateCurrencyFactor;
                END;
                
                SynchronizeAsmHeader;
                */

            end;
        }
        field(22;"Posting Description";Text[50])
        {
            Caption = 'Posting Description';
        }
        field(23;"Total Charge";Decimal)
        {
            Caption = 'Total Amount Recharge';
            Editable = false;
            FieldClass = Normal;
        }
        field(24;"Total Decharge";Decimal)
        {
            Caption = 'Total Amount Decharge';
            FieldClass = Normal;
        }
        field(100;"External Document No.";Code[35])
        {
            Caption = 'External Document No.';
        }
        field(107;"No. Series";Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(108;"Credit Notes Import Jrnal";Code[20])
        {
            Caption = 'Credit Notes Validation Journal';
            TableRelation = "Gen. Journal Batch".Name WHERE ("Journal Template Name"=FIELD("Sales by Cards Import Tmpl"));
        }
        field(109;"Sales by Cards Import Tmpl";Code[10])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(110;"Debit Notes Import Jrnal";Code[20])
        {
            Caption = 'Debit Notes Validation Journal';
            TableRelation = "Gen. Journal Batch".Name WHERE ("Journal Template Name"=FIELD("Sales by Cards Import Tmpl"));
        }
        field(111;"Tranche Horaire";Option)
        {
            Caption = 'Hour interval';
            OptionCaption = 'Une journée (24h),De 08h à 23h59,De 00h à 07h59';
            OptionMembers = "24H","8_23h59","00_07h59";
        }
    }

    keys
    {
        key(Key1;"No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin

        AddOnSetup.Get;
        if "No." = '' then begin
          AddOnSetup.TestField(AddOnSetup."Sales by Cards Nos.");
          NoSeriesMgt.InitSeries(AddOnSetup."Sales by Cards Nos.",xRec."No. Series",Today,"No.","No. Series");
        end;

        AddOnSetup.TestField(AddOnSetup."Sales by Cards Import Tmpl");
        Rec."Sales by Cards Import Tmpl" := AddOnSetup."Sales by Cards Import Tmpl";
    end;

    var
        AddOnSetup: Record "AddOn Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
}

