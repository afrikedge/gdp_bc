table 50062 "Posted Fuel Statement"
{
    Caption = 'Posted Fuel Statement';

    fields
    {
        field(1;"No.";Code[20])
        {
            Caption = 'No.';

            trigger OnValidate()
            begin

                if "No." <> xRec."No." then begin
                  AddOnSetup.Get;
                  AddOnSetup.TestField(AddOnSetup."Fuel Statement Nos.");
                  NoSeriesMgt.TestManual(AddOnSetup."Fuel Statement Nos.");
                  "No. Series" := '';
                end;
            end;
        }
        field(2;"Document Type";Option)
        {
            OptionCaption = 'FS,Main invoice,Invoice';
            OptionMembers = FS,"Main invoice",Invoice;
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
            Editable = false;
            OptionCaption = 'Created,Validated';
            OptionMembers = Created,Validated;
        }
        field(7;"Item No.";Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item WHERE (Type=CONST(Inventory));

            trigger OnValidate()
            var
                PrepaymentMgt: Codeunit "Prepayment Mgt.";
            begin
            end;
        }
        field(8;"Customer No";Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;

            trigger OnValidate()
            begin
                if Cust.Get("Customer No") then
                  "Customer Name" := Cust.Name;
            end;
        }
        field(9;"Customer Name";Text[50])
        {
            Caption = 'Customer Name';
            Editable = false;
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
        field(24;"Total Counter";Decimal)
        {
            CalcFormula = Sum("Posted Fuel Statement Line"."Total Counter" WHERE ("Document No."=FIELD("No.")));
            Caption = 'Total Amount counter';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25;"Location Code";Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location;
        }
        field(26;"Parent Invoice No.";Code[20])
        {
        }
        field(27;"User ID";Code[50])
        {
            Caption = 'User ID';
            Editable = false;
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;

            trigger OnLookup()
            var
                UserMgt: Codeunit "User Management";
            begin
                //UserMgt.LookupUserID("User ID");
            end;
        }
        field(28;"Equipment Type";Option)
        {
            Caption = 'Equipment Type';
            OptionCaption = 'Mobile,Fixed';
            OptionMembers = Mobile,"Fixed";
        }
        field(29;Backcharge;Option)
        {
            Caption = 'Backcharge';
            OptionCaption = ' ,Yes,No';
            OptionMembers = " ",Yes,No;
        }
        field(30;"Cost Code";Code[20])
        {
            Caption = 'Cost Code';
        }
        field(31;"Company Code";Code[30])
        {
        }
        field(32;Process;Option)
        {
            OptionCaption = ' ,Yes,No';
            OptionMembers = " ",Yes,No;
        }
        field(33;"Order No.";Code[30])
        {
            Caption = 'Order No.';
        }
        field(34;"AMSA Invoice Type";Option)
        {
            Caption = 'AMSA Invoicing Type';
            OptionCaption = 'Fuel Statement,Group Invoices';
            OptionMembers = FS,Commande;
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
        field(108;"Grouping Type";Option)
        {
            Caption = 'Grouping Type';
            OptionCaption = 'Client,Société';
            OptionMembers = Client,"Société";
        }
        field(109;"Grouping Customer";Code[20])
        {
            Caption = 'Grouping Code';
        }
        field(110;"Creation Date";Date)
        {
            Caption = 'Creation Date';
            Editable = false;
        }
    }

    keys
    {
        key(Key1;"Document Type","No.")
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
          AddOnSetup.TestField(AddOnSetup."Fuel Statement Nos.");
          NoSeriesMgt.InitSeries(AddOnSetup."Fuel Statement Nos.",xRec."No. Series",Today,"No.","No. Series");
        end;

        //AddOnSetup.TESTFIELD(AddOnSetup."Sales by Cards Import Tmpl");
        //Rec."Sales by Cards Import Tmpl" := AddOnSetup."Sales by Cards Import Tmpl";
    end;

    var
        AddOnSetup: Record "AddOn Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        ImportLine: Record "Fuel Statement Line";
        ImportEntry: Record "Gen. Journal Line";
        Text001: Label 'Import des transactions carte du %1';
        DoNotDeleteJournalEntries: Boolean;
        Cust: Record Customer;

    procedure SetDoNotDeleteJournalEntries(NotDelete: Boolean)
    begin
        DoNotDeleteJournalEntries := NotDelete;
    end;
}

