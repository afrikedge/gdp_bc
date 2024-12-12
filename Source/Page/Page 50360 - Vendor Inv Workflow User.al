page 50360 "Vendor Inv Workflow User"
{
    Caption = 'Utilisateurs workflow de validation de factures fournisseur';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Custom Workflow Config";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Workflow Code"; Rec."Workflow Code")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("User 1"; Rec."User 1")
                {
                }
                field("Interim User 1"; Rec."Interim User 1")
                {
                }
                field("Activate Interim 1"; Rec."Activate Interim 1")
                {
                }
                field("User 2"; Rec."User 2")
                {
                }
                field("Interim User 2"; Rec."Interim User 2")
                {
                }
                field("Activate Interim 2"; Rec."Activate Interim 2")
                {
                }
                field("User 3"; Rec."User 3")
                {
                }
                field("Interim User 3"; Rec."Interim User 3")
                {
                }
                field("Activate Interim 3"; Rec."Activate Interim 3")
                {
                }
                field("Invoice Type"; Rec."Invoice Type")
                {
                }
                field("Department Code"; Rec."Department Code")
                {
                }
                field(Regularisation; Rec.Regularisation)
                {
                }
            }
        }
    }

    actions
    {
    }
}

