table 50039 "FA Transfer"
{

    fields
    {
        field(1;"Entry No.";Integer)
        {
            Caption = 'Entry No.';
        }
        field(2;"FA No.";Code[20])
        {
            Caption = 'FA No.';
            TableRelation = "Fixed Asset";
        }
        field(3;"Transfer Date";Date)
        {
            Caption = 'Posting Date';
        }
        field(4;"External Document No.";Code[35])
        {
            Caption = 'External Document No.';
        }
        field(5;Description;Text[50])
        {
            Caption = 'Description';
        }
        field(6;"FA Location Code";Code[10])
        {
            Caption = 'FA Location Code';
            TableRelation = "FA Location";
        }
        field(7;"FA Location Code New";Code[10])
        {
            Caption = 'New FA Location Code';
            TableRelation = "FA Location";
        }
        field(8;"User ID";Code[50])
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
        field(9;"Entry Date";Date)
        {
            Caption = 'Entry Date';
        }
        field(10;"New FA Location";Text[50])
        {
            Caption = 'New Location';
        }
        field(11;"Old FA Location";Text[50])
        {
            Caption = 'Old Location';
        }
        field(12;"FA Sub Location Code";Code[10])
        {
            Caption = 'FA Sub Location Code';
            TableRelation = "FA SubLocation";
        }
        field(13;"FA Sub Location Name";Text[50])
        {
        }
    }

    keys
    {
        key(Key1;"Entry No.")
        {
        }
    }

    fieldgroups
    {
    }
}

