pageextension 50014 pageextension70000151 extends "Purchase Quote Subform"
{
    layout
    {
        addafter(ShortcutDimCode8)
        {
            field(Disponibility; Rec.Disponibility)
            {
                Visible = false;
            }
            field("Disponibility 2"; Rec."Disponibility 2")
            {
            }
            field("Starting Warranty"; Rec."Starting Warranty")
            {
            }
            field("Warranty (Months)"; Rec."Warranty (Months)")
            {
            }
            field(Insurance; Rec.Insurance)
            {
            }
        }
    }
}

