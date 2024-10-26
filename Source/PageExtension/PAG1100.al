pageextension 50046 pageextension70000011 extends "Chart of Cost Types"
{
    layout
    {
        addafter("Balance at Date")
        {
            field("Rubric Type"; Rec."Rubric Type")
            {
                Visible = false;
            }
            field(Order; Rec.Order)
            {
            }
        }
    }
}

