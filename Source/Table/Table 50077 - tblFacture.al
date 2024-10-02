table 50077 tblFacture
{
    Caption = 'Facture MFiles';

    fields
    {
        field(1;ID;BigInteger)
        {
            Caption = 'ID';
        }
        field(2;DateMFiles;DateTime)
        {
            Caption = 'MFiles Date';
        }
        field(3;NumeroFacture;Code[35])
        {
            Caption = 'Vendor Invoice N°';
        }
        field(4;DateFacture;Date)
        {
            Caption = 'Invoice Date';
        }
        field(5;FactureDirecte;Boolean)
        {
            Caption = 'Direct Invoice';
        }
        field(6;NumeroBDC;Code[20])
        {
            Caption = 'Order N°';
        }
        field(7;NouveauDelaiPaiement;Code[10])
        {
            Caption = 'New Payment Terms';
            TableRelation = "Payment Terms";
        }
        field(8;MontantHTVA;Decimal)
        {
            Caption = 'Amount Excl VAT';
        }
        field(9;NumeroFournisseur;Code[20])
        {
            Caption = 'Vendor Code';
        }
        field(10;MFilesURL;Text[100])
        {
            Caption = 'URL';
            ExtendedDatatype = URL;
        }
        field(11;DateNav;Date)
        {
            Caption = 'Posting Date';
        }
        field(12;Statut;Option)
        {
            Caption = 'Processing Status';
            OptionCaption = 'Created,Integrated';
            OptionMembers = Created,Integrated;
        }
        field(13;"Vendor Name";Text[50])
        {
            CalcFormula = Lookup(Vendor.Name WHERE ("No."=FIELD(NumeroFournisseur)));
            Caption = 'Vendor Name';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;ID,DateMFiles)
        {
        }
    }

    fieldgroups
    {
    }
}

