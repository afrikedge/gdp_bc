pageextension 50047 pageextension70000012 extends "Cost Type Card"
{
    layout
    {
        addafter("New Page")
        {
            field(Order; Rec.Order)
            {
            }
            field("Rubric Type"; Rec."Rubric Type")
            {
            }
        }
    }
}

