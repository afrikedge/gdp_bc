pageextension 50013 pageextension70000107 extends "Purchase Order Subform"
{
    layout
    {
        modify("Gen. Bus. Posting Group")
        {
            Visible = false;
        }
        modify("Gen. Prod. Posting Group")
        {
            Visible = false;
        }
        addafter(ShortcutDimCode8)
        {
            field("Starting Warranty"; Rec."Starting Warranty")
            {
                Visible = false;
            }
            field("Warranty (Months)"; Rec."Warranty (Months)")
            {
                Visible = false;
            }
            field(Insurance; Rec.Insurance)
            {
                Visible = false;
            }
            field("Overhead Rate"; Rec."Overhead Rate")
            {
                Visible = false;
            }
            field("Batch Number"; Rec."Batch Number")
            {
                Visible = false;
            }
            field("Expiration Date"; Rec."Expiration Date")
            {
                Visible = false;
            }
        }
    }

    var
        AfkErr001: Label 'Ce type n''est pas valide pour les commandes d''achats';
}

