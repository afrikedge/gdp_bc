table 50070 "JIRAMA Forecast Transfer"
{
    // DrillDownPageID = "JIRAMA Forecast Transfers";
    // LookupPageID = "JIRAMA Forecast Transfers";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Document No."; Code[20])
        {
        }
        field(3; "From Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
            TableRelation = Customer;

            trigger OnValidate()
            begin
                if Cust.Get(Rec."From Sell-to Customer No.") then
                    Rec."From Customer Name" := Cust.Name;
            end;
        }
        field(4; "To Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
            TableRelation = Customer;

            trigger OnValidate()
            begin
                if Cust.Get(Rec."To Sell-to Customer No.") then
                    Rec."To Customer Name" := Cust.Name;
            end;
        }
        field(5; Volume; Decimal)
        {
        }
        field(6; "From Customer Name"; Text[50])
        {
            Caption = 'Customer Name';
            Editable = false;
        }
        field(7; "To Customer Name"; Text[50])
        {
            Caption = 'Sell-to Customer No.';
            TableRelation = Customer;
        }
        field(8; "External Document No."; Code[35])
        {
            Caption = 'External Document No.';
        }
        field(9; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(10; "User ID"; Code[50])
        {
            Caption = 'User ID';
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
        field(11; "Entry Date"; Date)
        {
            Caption = 'Entry Date';
        }
        field(12; "To Ship-to Code"; Code[10])
        {
            Caption = 'Ship-to Code';
            TableRelation = "Ship-to Address".Code WHERE("Customer No." = FIELD("To Sell-to Customer No."));
        }
        field(13; "From Ship-to Code"; Code[10])
        {
            Caption = 'Ship-to Code';
            TableRelation = "Ship-to Address".Code WHERE("Customer No." = FIELD("From Sell-to Customer No."));
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
        }
        key(Key2; "Document No.", "From Sell-to Customer No.")
        {
            SumIndexFields = Volume;
        }
        key(Key3; "Document No.", "To Sell-to Customer No.")
        {
            SumIndexFields = Volume;
        }
    }

    fieldgroups
    {
    }

    var
        Cust: Record Customer;
}

