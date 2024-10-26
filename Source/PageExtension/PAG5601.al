pageextension 50051 pageextension70000108 extends "Fixed Asset List"
{
    layout
    {
        addafter("Acquired")
        {
            field("Warranty Date"; Rec."Warranty Date")
            {
            }
            field("Serial No."; Rec."Serial No.")
            {
            }
            field(Insured; Rec.Insured)
            {
            }
            field(Comment; Rec.Comment)
            {
            }
            field(Blocked; Rec.Blocked)
            {
            }
            field(Quantity; Rec.Quantity)
            {
            }
            field("Startup Date"; Rec."Startup Date")
            {
            }
            field(Brand; Rec.Brand)
            {
            }
            field("FA Owner"; Rec."FA Owner")
            {
            }
            field("FA Type"; Rec."FA Type")
            {
            }
            field("FA Location Name"; Rec."FA Location Name")
            {
            }
            field("FA Sub Location Name"; Rec."FA Sub Location Name")
            {
            }
            field(MiseEnService; Rec.MiseEnService)
            {
            }
            field(State; Rec.State)
            {
            }
            field(Codification; Rec.Codification)
            {
            }
            field("FA Status"; Rec."FA Status")
            {
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
            }
            action(PrintInventaire)
            {
                Caption = 'Imprimer la liste inventaire Immo';
                Image = PrintReport;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunObject = Report 50029;
            }
        }
    }
}

