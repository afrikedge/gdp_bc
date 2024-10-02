table 50072 "Document Step History"
{
    Caption = 'Document Step History';

    fields
    {
        field(1;"Document Type";Option)
        {
            OptionCaption = 'Sales Order,Vendor Invoice';
            OptionMembers = "Sales Order",VendorInvoice;
        }
        field(2;"Document No.";Code[50])
        {
        }
        field(3;"Step ID";Integer)
        {
            Caption = 'Step ID';
        }
        field(4;"Action";Option)
        {
            OptionCaption = 'Creation,Change Status,Ship,Invoice,Deletion';
            OptionMembers = Creation,"Change Status",Ship,Invoice,Deletion;
        }
        field(5;"New Status";Text[60])
        {
            Caption = 'New Status';
        }
        field(6;UserID;Code[50])
        {
            Caption = 'User';
        }
        field(7;"Action Date";DateTime)
        {
            Caption = 'Date';
        }
        field(8;"Created Document";Code[20])
        {
            Caption = 'Created Document';
        }
        field(9;"New Status ID";Integer)
        {
        }
        field(10;"User Name";Text[80])
        {
            CalcFormula = Lookup(User."Full Name" WHERE ("User Name"=FIELD(UserID)));
            Caption = 'Nom utilisateur';
            Editable = false;
            FieldClass = FlowField;
        }
        field(11;TypeAction;Option)
        {
            Editable = false;
            OptionCaption = ' ,FinLitigeFacture';
            OptionMembers = ,FinLitigeFacture;
        }
    }

    keys
    {
        key(Key1;"Document Type","Document No.","Step ID")
        {
        }
        key(Key2;"Document No.","New Status ID")
        {
        }
    }

    fieldgroups
    {
    }
}

