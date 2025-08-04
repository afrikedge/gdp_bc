page 50182 "AMSA Invoice List"
{
    Caption = 'AMSA Invoice List';
    CardPageID = "Fuel Statement";
    Editable = false;
    PageType = List;
    SourceTable = "Fuel Statement Header";
    SourceTableView = WHERE("Document Type" = CONST(Invoice));
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                }
                field("Starting Date"; Rec."Starting Date")
                {
                }
                field("Ending Date"; Rec."Ending Date")
                {
                }
                field("External Document No."; Rec."External Document No.")
                {
                    Caption = 'External Document No.';
                }
                field("Item No."; Rec."Item No.")
                {
                }
                field("Equipment Type"; Rec."Equipment Type")
                {
                }
                field(Backcharge; Rec.Backcharge)
                {
                }
                field("Cost Code"; Rec."Cost Code")
                {
                }
                field("Company Code"; Rec."Company Code")
                {
                }
                field(Process; Rec.Process)
                {
                }
                field("Order No."; Rec."Order No.")
                {
                    Caption = 'Order No.';
                }
            }
        }
    }

    actions
    {
    }
}

