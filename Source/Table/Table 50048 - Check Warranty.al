table 50048 "Check Warranty"
{
    Caption = 'Check Warranty';

    fields
    {
        field(1;"No.";Code[20])
        {
            Caption = 'No.';
            Editable = false;

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                  AddOnSetup.Get;
                  NoSeriesMgt.TestManual(GetNoSeriesCode);
                  "No. Series" := '';
                end;
            end;
        }
        field(2;"Check No.";Code[20])
        {
            Caption = 'Check No.';

            trigger OnValidate()
            begin
                TestField("Customer No.");
            end;
        }
        field(3;"Customer No.";Code[20])
        {
            Caption = 'Customer code';
            TableRelation = Customer;

            trigger OnValidate()
            begin
                if Cust.Get("Customer No.") then
                  "Customer Name" := Cust.Name;
            end;
        }
        field(4;"Customer Name";Text[50])
        {
            Caption = 'Customer Name';
            Editable = false;
        }
        field(5;"Posting Date";Date)
        {
            Caption = 'Posting Date';
            Editable = false;
        }
        field(7;Description;Text[100])
        {
            Caption = 'Comment';
        }
        field(8;Amount;Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount';
        }
        field(9;"Check Date";Date)
        {
            Caption = 'Check Date';
        }
        field(11;"No. Series";Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(12;Status;Option)
        {
            Caption = 'Status';
            Editable = false;
            OptionCaption = 'Open,Returned,Confirmed';
            OptionMembers = Open,Returned,Confirmed;
        }
        field(21;"User ID";Code[50])
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
                UserMgt.LookupUserID("User ID");
            end;
        }
        field(22;"Return Date";Date)
        {
            Caption = 'Return Date';
        }
        field(23;"Receipt Date";Date)
        {
            Caption = 'Receipt Date';
        }
        field(24;"CCL Tmpl";Code[10])
        {
            Caption = 'CCL Template';
            TableRelation = "Gen. Journal Template";
        }
        field(25;"CCL Jrnal";Code[20])
        {
            Caption = 'CCL Journal';
            TableRelation = "Gen. Journal Batch".Name WHERE ("Journal Template Name"=FIELD("CCL Tmpl"));
        }
        field(26;"Confirmed Date";Date)
        {
            Caption = 'Confirmed Date';
        }
        field(27;"Due Date";Date)
        {
            Caption = 'Due Date';
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
        "Posting Date" := WorkDate;

        AddOnSetup.Get;
        if "No." = '' then begin
          TestNoSeries;
          NoSeriesMgt.InitSeries(GetNoSeriesCode,xRec."No. Series","Posting Date","No.","No. Series");
        end;

        "User ID":= UserId;

        AddOnSetup.TestField(AddOnSetup."Curr Purchase Tmpl Journal");
        Rec."CCL Tmpl" := AddOnSetup."Curr Purchase Tmpl Journal";
    end;

    var
        GLSetup: Record "General Ledger Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        AddOnSetup: Record "AddOn Setup";
        Cust: Record Customer;

    local procedure TestNoSeries(): Boolean
    begin
        AddOnSetup.Get;
        AddOnSetup.TestField(AddOnSetup."Check Warranty Nos.");
    end;

    local procedure GetNoSeriesCode(): Code[10]
    begin
        exit(AddOnSetup."Check Warranty Nos.");
    end;
}

