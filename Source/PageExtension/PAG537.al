pageextension 50043 pageextension70000106 extends "Dimension Values"
{
    layout
    {
        addafter("Consolidation Code")
        {
            field("Old Code"; Rec."Old Code")
            {
                ApplicationArea = All;
            }
        }
    }
}

