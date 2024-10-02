tableextension 50051 "A02 Cost Type" extends "Cost Type"
{
    fields
    {
        field(50000; "Rubric Type"; Option)
        {
            Caption = 'Rubric Type';
            OptionCaption = 'P&L,Cost Analysis, ';
            OptionMembers = "P&L",CostAnalysis,"None";
        }
        field(50001; "Order"; Code[10])
        {
            Caption = 'Order';
        }
    }
}

