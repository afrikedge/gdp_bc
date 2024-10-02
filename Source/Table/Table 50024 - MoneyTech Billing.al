table 50024 "MoneyTech Billing"
{
    Caption = 'MoneyTech Billing';

    fields
    {
        field(1;"No.";Code[20])
        {
            Caption = 'No.';

            trigger OnValidate()
            begin

                if "No." <> xRec."No." then begin
                  AddOnSetup.Get;
                  AddOnSetup.TestField(AddOnSetup."Moneytech Billing Nos.");
                  NoSeriesMgt.TestManual(AddOnSetup."Moneytech Billing Nos.");
                  "No. Series" := '';
                end;
            end;
        }
        field(3;"Starting Date";Date)
        {
            Caption = 'Starting Date';

            trigger OnValidate()
            begin
                //IF "Posting Description"='' THEN
                //  "Posting Description":=STRSUBSTNO(Text001,FORMAT("Starting Date"));
            end;
        }
        field(4;"Ending Date";Date)
        {
            Caption = 'Ending Date';
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
        field(24;"Total Decharge";Decimal)
        {
            CalcFormula = Sum("MoneyTech Import Line".Amount WHERE ("Document No."=FIELD("No."),
                                                                    "Transaction Type"=CONST(Decharge)));
            Caption = 'Total Amount Decharge';
            Editable = false;
            FieldClass = FlowField;
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

    trigger OnDelete()
    begin

        ImportLine.Reset;
        ImportLine.SetRange(ImportLine."Document No.",Rec."No.");
        ImportLine.DeleteAll;
    end;

    trigger OnInsert()
    begin

        AddOnSetup.Get;
        if "No." = '' then begin
          AddOnSetup.TestField(AddOnSetup."Moneytech Billing Nos.");
          NoSeriesMgt.InitSeries(AddOnSetup."Moneytech Billing Nos.",xRec."No. Series",Today,"No.","No. Series");
        end;

        //AddOnSetup.TESTFIELD(AddOnSetup."Sales by Cards Import Tmpl");
        //Rec."Sales by Cards Import Tmpl" := AddOnSetup."Sales by Cards Import Tmpl";
    end;

    var
        AddOnSetup: Record "AddOn Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        ImportLine: Record "MoneyTech Billing Line";
        Text001: Label 'Import des transactions carte du %1';
        DoNotDeleteJournalEntries: Boolean;

    procedure SetDoNotDeleteJournalEntries(NotDelete: Boolean)
    begin
        DoNotDeleteJournalEntries := NotDelete;
    end;
}

