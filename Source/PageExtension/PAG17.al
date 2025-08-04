pageextension 50004 pageextension70000048 extends "G/L Account Card"
{
    Editable = false;
    layout
    {
        addlast(General)
        {
            field("Purchased Account"; Rec."Purchased Account")
            {
                ApplicationArea = All;
            }
            field("Migration Account"; Rec."Migration Account")
            {
                ApplicationArea = All;
            }
        }
    }
}

