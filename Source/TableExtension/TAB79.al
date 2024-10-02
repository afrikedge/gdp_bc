tableextension 50016 "A02 Company Information" extends "Company Information"
{
    fields
    {
        modify("Industrial Classification")
        {
            Caption = 'Industrial Classification';
        }
        modify("APE Code")
        {
            Caption = 'APE Code';
        }
        field(50001; TraitePicture; BLOB)
        {
            SubType = Bitmap;
        }
        field(50002; "JIRAMA Signature"; BLOB)
        {
            Caption = 'Signature Facture JIRAMA';
            SubType = Bitmap;
        }
        field(50003; "Administrative Picture"; BLOB)
        {
            Caption = 'Administrative Picture';
            SubType = Bitmap;
        }
        field(50004; "Company Stamp"; BLOB)
        {
            Caption = 'Company Stamp';
            SubType = Bitmap;
        }
        field(60000; "Company Social Security No"; Text[50])
        {
        }
    }
}

