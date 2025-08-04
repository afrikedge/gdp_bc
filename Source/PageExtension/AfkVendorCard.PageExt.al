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
                ApplicationArea = All;
            }
            field(Transporter; Rec.Transporter)
            {
                ApplicationArea = All;
            }
            field(Statut; Rec.Statut)
            {
                ApplicationArea = All;
            }
            field("Activity Area"; Rec."Activity Area")
            {
                ApplicationArea = All;
            }
            field("Related Customer"; Rec."Related Customer")
            {
                ApplicationArea = All;
            }
        }
        addafter("VAT Registration No.")
        {
            field("CIF/CIS"; Rec."CIF/CIS")
            {
                ApplicationArea = All;
            }
            field("STAT Code"; Rec."STAT Code")
            {
                ApplicationArea = All;
            }
            field("Trade Number"; Rec."Trade Number")
            {
                ApplicationArea = All;
            }
            field("Vendor Retention Posting Group"; Rec."Vendor Retention Posting Group")
            {
                ApplicationArea = All;
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
                ApplicationArea = All;
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
