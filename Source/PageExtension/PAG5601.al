pageextension 50051 pageextension70000108 extends "Fixed Asset List"
{
    layout
    {
        addafter("Acquired")
        {
            field("Warranty Date"; Rec."Warranty Date")
            {
                ApplicationArea = All;
            }
            field("Serial No."; Rec."Serial No.")
            {
                ApplicationArea = All;
            }
            field(Insured; Rec.Insured)
            {
                ApplicationArea = All;
            }
            field(Comment; Rec.Comment)
            {
                ApplicationArea = All;
            }
            field(Blocked; Rec.Blocked)
            {
                ApplicationArea = All;
            }
            field(Quantity; Rec.Quantity)
            {
                ApplicationArea = All;
            }
            field("Startup Date"; Rec."Startup Date")
            {
                ApplicationArea = All;
            }
            field(Brand; Rec.Brand)
            {
                ApplicationArea = All;
            }
            field("FA Owner"; Rec."FA Owner")
            {
                ApplicationArea = All;
            }
            field("FA Type"; Rec."FA Type")
            {
                ApplicationArea = All;
            }
            field("FA Location Name"; Rec."FA Location Name")
            {
                ApplicationArea = All;
            }
            field("FA Sub Location Name"; Rec."FA Sub Location Name")
            {
                ApplicationArea = All;
            }
            field(MiseEnService; Rec.MiseEnService)
            {
                ApplicationArea = All;
            }
            field(State; Rec.State)
            {
                ApplicationArea = All;
            }
            field(Codification; Rec.Codification)
            {
                ApplicationArea = All;
            }
            field("FA Status"; Rec."FA Status")
            {
                ApplicationArea = All;
            }
        }
    }
    actions
    {
        addafter("Dimensions")
        {
            action(PrintRegistre)
            {
                Caption = 'Imprimer le registre';
                Image = PrintForm;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunObject = Report 50036;
                ApplicationArea = All;
            }
            action(PrintInventaire)
            {
                Caption = 'Imprimer la liste inventaire Immo';
                Image = PrintReport;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunObject = Report 50029;
                ApplicationArea = All;
            }
        }
    }
}

