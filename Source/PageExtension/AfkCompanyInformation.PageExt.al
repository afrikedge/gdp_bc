pageextension 50093 "Afk Company Information" extends "Company Information"
{
    layout
    {
        addafter(Picture)
        {
            field("Administrative Picture"; Rec."Administrative Picture")
            {

            }
        }
        addafter("Trade Register")
        {
            group(Jirama)
            {
                Caption = 'Jirama', Locked = true;
                field("JIRAMA Signature"; Rec."JIRAMA Signature")
                {

                }
                field("Company Stamp"; Rec."Company Stamp")
                {

                }
            }
        }
    }
}
