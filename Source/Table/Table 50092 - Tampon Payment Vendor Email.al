table 50092 "Tampon Payment Vendor Email"
{

    fields
    {
        field(1; EntryID; Integer)
        {
            Editable = false;
        }
        field(3; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            Editable = false;
            TableRelation = Vendor;
        }
        field(6; "Document No."; Code[50])
        {
            Caption = 'Document No.';
            Editable = false;
        }
        field(7; "Vendor Name"; Text[100])
        {
            CalcFormula = Lookup(Vendor.Name WHERE("No." = FIELD("Vendor No.")));
            Caption = 'Vendor Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(8; "Vendor Email"; Text[250])
        {
            CalcFormula = Lookup(Vendor."E-Mail" WHERE("No." = FIELD("Vendor No.")));
            Caption = 'Email';
            Editable = false;
            FieldClass = FlowField;
        }
        field(9; Attachment; Text[250])
        {
            Caption = 'Attachment';
            Editable = false;
        }
        field(10; "Entry Date"; Date)
        {
            Caption = 'Entry Date';
            Editable = false;
        }
        field(27; "User ID"; Code[50])
        {
            Caption = 'User ID';
            Editable = false;
            TableRelation = User."User Name";

            // trigger OnLookup()
            // var
            //     UserMgt: Codeunit "User Management";
            // begin
            //     UserMgt.LookupUserID("User ID");
            // end;
        }
        field(28; Amount; Decimal)
        {
            Caption = 'Amount';
            Editable = false;
        }
        field(29; SendTo; Text[250])
        {
            Caption = 'Sent To';
            Editable = false;
        }
        field(30; SendToCC; Text[250])
        {
            Caption = 'CC';
            Editable = false;
        }
        field(31; EmailObject; Text[250])
        {
            Caption = 'Email Object';
            Editable = false;
        }
        field(32; BodyAsHTML; Text[2000])
        {
            Caption = 'Body';
        }
        field(33; AttachmentFile; Blob)
        {
            Caption = 'Attachment File';
            //DataClassification = SystemMetadata;
            //Subtype =UserDefined;
        }

        field(34; EmailSent; Boolean)
        {
            Caption = 'Email Sent';
            Editable = false;
        }
        field(35; EmailType; enum AfkEmailType)
        {
            Caption = 'Email Type';
        }
        field(36; AttachmentMedia; Media)
        {
            Caption = 'Attachment media';
            //DataClassification = SystemMetadata;
            //Subtype =UserDefined;
        }

        field(172; "Payment Method Code"; Code[10])
        {
            Caption = 'Payment Method Code';
            TableRelation = "Payment Method";
        }


    }

    keys
    {
        key(Key1; EntryID)
        {
        }
    }

    fieldgroups
    {
    }
}

