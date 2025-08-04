page 50310 "Reconciliation Infos Journal"
{
    Caption = 'Invoices to reconciliate';
    PageType = List;
    SourceTable = "Reconciliation Info";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Invoice No"; Rec."Invoice No")
                {
                }
                field("Order No"; Rec."Order No")
                {
                }
                field(Amount; Rec.Amount)
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Journal Batch Name" := Rec.GetFilter("Journal Batch Name");
        Rec."Journal Template Name" := Rec.GetFilter("Journal Template Name");
        if Evaluate(Rec."Line No.", Rec.GetFilter("Line No.")) then;
        Rec."Customer No." := Rec.GetFilter("Customer No.");
    end;

    trigger OnOpenPage()
    begin
        //Rec.FilterGroup(0);
    end;
}

