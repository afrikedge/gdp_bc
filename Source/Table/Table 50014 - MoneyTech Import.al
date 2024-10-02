table 50014 "MoneyTech Import"
{
    Caption = 'MoneyTech Import';

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
            Caption = 'Starting Date';

            trigger OnValidate()
            begin
                if "Posting Description"='' then
                  "Posting Description":=StrSubstNo(Text001,Format("Starting Date"));

                if "Starting Date"<>0D then
                  MnyTechMgt.CheckDatesInsertion(Rec);

                if "Starting Date"<>xRec."Starting Date" then begin
                  PurgerLignes;
                end;
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
        field(22;"Posting Description";Text[50])
        {
            Caption = 'Posting Description';
        }
        field(23;"Total Charge";Decimal)
        {
            CalcFormula = Sum("MoneyTech Import Line".Amount WHERE ("Document No."=FIELD("No."),
                                                                    "Transaction Type"=CONST(Recharge)));
            Caption = 'Total Amount Recharge';
            Editable = false;
            FieldClass = FlowField;
        }
        field(24;"Total Decharge";Decimal)
        {
            CalcFormula = Sum("MoneyTech Import Line".Amount WHERE ("Document No."=FIELD("No."),
                                                                    "Transaction Type"=CONST(Decharge)));
            Caption = 'Total Amount Decharge';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25;"First Journal Validated";Boolean)
        {
            Editable = false;
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

            trigger OnValidate()
            begin
                if "Tranche Horaire"<>xRec."Tranche Horaire" then begin
                  PurgerLignes;
                end;
            end;
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


        if not DoNotDeleteJournalEntries then begin
          ImportEntry.Reset;
          ImportEntry.SetRange("MoneyTech Import No.",Rec."No.");
          ImportEntry.DeleteAll;
        end;
    end;

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
        ImportLine: Record "MoneyTech Import Line";
        ImportEntry: Record "Gen. Journal Line";
        Text001: Label 'Import des transactions carte du %1';
        DoNotDeleteJournalEntries: Boolean;
        MnyTechMgt: Codeunit "Conso by Cards Mgt";
        Text002: Label 'Les lignes seront supprimées. Voulez-vous continuer ?';

    procedure SetDoNotDeleteJournalEntries(NotDelete: Boolean)
    begin
        DoNotDeleteJournalEntries := NotDelete;
    end;

    local procedure PurgerLignes()
    var
        LigneImport: Record "MoneyTech Import Line";
        LigneImport2: Record "MoneyTech Import Line";
    begin
        LigneImport.Reset;
        LigneImport.SetRange(LigneImport."Document No.",Rec."No.");
        if LigneImport.FindFirst then begin
          if not Confirm(Text002) then Error('');

          LigneImport2.Reset;
          LigneImport2.SetRange("Document No.",Rec."No.");
          LigneImport2.DeleteAll;
        end;
    end;
}

