pageextension 50014 pageextension70000151 extends "Purchase Quote Subform"
{
    layout
    {
        addafter(ShortcutDimCode8)
        {
            field(Disponibility; Rec.Disponibility)
            {
                Visible = false;
                ApplicationArea = All;
            }
            field("Disponibility 2"; Rec."Disponibility 2")
            {
                ApplicationArea = All;
            }
            field("Starting Warranty"; Rec."Starting Warranty")
            {
                ApplicationArea = All;
            }
            field("Warranty (Months)"; Rec."Warranty (Months)")
            {
                ApplicationArea = All;
            }
            field(Insurance; Rec.Insurance)
            {
                ApplicationArea = All;
            }
        }
    }
}

