pageextension 50096 "Afk Vendor Card" extends "Vendor Card"
{
    layout
    {
        modify("Name 2")
        {
            Caption = 'Nom Transporteur Dispaching';
        }
        addlast(General)
        {
            field("GDP Partner"; Rec."GDP Partner")
            {

            }
            field(Transporter; Rec.Transporter)
            {

            }
            field(Statut; Rec.Statut)
            {

            }
            field("Activity Area"; Rec."Activity Area")
            {

            }
            field("Related Customer"; Rec."Related Customer")
            {

            }
        }
        addafter("VAT Registration No.")
        {
            field("CIF/CIS"; Rec."CIF/CIS")
            {

            }
            field("STAT Code"; Rec."STAT Code")
            {

            }
            field("Trade Number"; Rec."Trade Number")
            {

            }
            field("Vendor Retention Posting Group"; Rec."Vendor Retention Posting Group")
            {

            }
        }
    }
    actions
    {
        addafter("Purchase Journal")
        {
            action(Valider)
            {
                Caption = 'Envoyer en validation';
                Visible = ShowValidation;
                trigger OnAction()
                var
                    GLMgt: Codeunit "GL Mgt";
                begin
                    GLMgt.ValidateVendor(Rec, 0);
                end;
            }
        }
    }
    trigger OnAfterGetRecord()
    var
    begin
        ShowValidation := Rec."Validation Status" = Rec."Validation Status"::Created;
    end;

    var
        ShowValidation: Boolean;
}
