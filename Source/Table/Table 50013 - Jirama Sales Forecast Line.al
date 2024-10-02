table 50013 "Jirama Sales Forecast Line"
{

    fields
    {
        field(1;"Document No.";Code[20])
        {
        }
        field(2;"Sell-to Customer No.";Code[20])
        {
            Caption = 'Sell-to Customer No.';
            TableRelation = Customer;

            trigger OnValidate()
            begin

                AddOnSetup.Get;
                if Cust.Get(Rec."Sell-to Customer No.") then begin
                  Cust.TestField(Cust."Sales Channel Code",AddOnSetup."JIRAMA Sales Channel");
                  Cust.TestField(Cust."Sales Category Code",AddOnSetup."PBL Sales Category");
                  Rec."Customer Name" := Cust.Name;
                end;
            end;
        }
        field(3;Volume;Decimal)
        {
            Caption = 'Initial Volume';
        }
        field(4;"Sales Order No";Code[20])
        {
            Caption = 'Sales order No.';
            Editable = false;
        }
        field(5;"Purchase Order No";Code[20])
        {
            Caption = 'Purch Order No';
            Editable = false;
        }
        field(6;"Purchase Order Line No";Integer)
        {
            Caption = 'Purch Order No.';
            Editable = false;
        }
        field(7;"Customer Name";Text[50])
        {
            Caption = 'Customer Name';
            Editable = false;
        }
        field(8;"Added Volume";Decimal)
        {
            CalcFormula = Sum("JIRAMA Forecast Transfer".Volume WHERE ("Document No."=FIELD("Document No."),
                                                                       "To Sell-to Customer No."=FIELD("Sell-to Customer No."),
                                                                       "To Ship-to Code"=FIELD("Ship-to Code")));
            Caption = 'Added';
            Editable = false;
            FieldClass = FlowField;
        }
        field(9;"Removed Volume";Decimal)
        {
            CalcFormula = Sum("JIRAMA Forecast Transfer".Volume WHERE ("Document No."=FIELD("Document No."),
                                                                       "From Sell-to Customer No."=FIELD("Sell-to Customer No."),
                                                                       "From Ship-to Code"=FIELD("Ship-to Code")));
            Caption = 'Removed';
            Editable = false;
            FieldClass = FlowField;
        }
        field(10;"Remaining Volume";Decimal)
        {
            Caption = 'Remaining Volume';
            Editable = false;
        }
        field(11;"Total Enleve";Decimal)
        {
            Caption = 'Total Removed';
            Editable = false;
        }
        field(12;"Total Livre";Decimal)
        {
            Caption = 'Total shipped';
            Editable = false;
        }
        field(13;"Total Facture";Decimal)
        {
            Caption = 'Total Invoiced';
            Editable = false;
        }
        field(14;"Actual Volume";Decimal)
        {
            Caption = 'Actual Volume';
            Editable = false;
        }
        field(15;"Allowed Quantity";Decimal)
        {
            Caption = 'Allowed Quantity';
        }
        field(16;"Comfirmed Quantity";Decimal)
        {
            Caption = 'Confirmed Quantity';
        }
        field(17;"Ship-to Code";Code[10])
        {
            Caption = 'Ship-to Code';
            TableRelation = "Ship-to Address".Code WHERE ("Customer No."=FIELD("Sell-to Customer No."));
        }
    }

    keys
    {
        key(Key1;"Document No.","Sell-to Customer No.","Ship-to Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        TestOpen;
    end;

    trigger OnInsert()
    begin
        TestOpen;
    end;

    trigger OnModify()
    begin
        TestOpen;
    end;

    var
        Cust: Record Customer;
        AddOnSetup: Record "AddOn Setup";
        JiramaH: Record "Jirama Sales Forecast";

    local procedure TestOpen()
    begin
        if JiramaH.Get("Document No.") then
          JiramaH.TestField(JiramaH.Status,JiramaH.Status::Created);
    end;
}

