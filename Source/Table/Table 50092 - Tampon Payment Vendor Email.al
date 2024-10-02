table 50092 "Tampon Payment Vendor Email"
{

    fields
    {
        field(1;EntryID;Integer)
        {
            Editable = false;
        }
        field(3;"Vendor No.";Code[20])
        {
            Caption = 'Vendor No.';
            Editable = false;
            TableRelation = Vendor;
        }
        field(6;"Document No.";Code[20])
        {
            Caption = 'Document No.';
            Editable = false;

            trigger OnLookup()
            var
                IncomingDocument: Record "Incoming Document";
            begin
            end;
        }
        field(7;"Vendor Name";Text[50])
        {
            CalcFormula = Lookup(Vendor.Name WHERE ("No."=FIELD("Vendor No.")));
            Caption = 'Vendor Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(8;"Vendor Email";Text[250])
        {
            CalcFormula = Lookup(Vendor."E-Mail" WHERE ("No."=FIELD("Vendor No.")));
            Caption = 'Email';
            Editable = false;
            FieldClass = FlowField;
        }
        field(9;Attachment;Text[250])
        {
            Caption = 'Attachment';
            Editable = false;
        }
        field(10;"Entry Date";Date)
        {
            Caption = 'Entry Date';
            Editable = false;
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
        field(28;Amount;Decimal)
        {
            Caption = 'Amount';
            Editable = false;
        }
        field(172;"Payment Method Code";Code[10])
        {
            Caption = 'Payment Method Code';
            TableRelation = "Payment Method";
        }
    }

    keys
    {
        key(Key1;EntryID)
        {
        }
    }

    fieldgroups
    {
    }
}

