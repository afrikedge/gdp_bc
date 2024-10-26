page 50156 "Posted Purch Requisit Subform"
{
    Caption = 'Lines';
    PageType = ListPart;
    SourceTable = "Posted Purch Requisition Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Type; Rec.Type)
                {
                }
                field("No."; Rec."No.")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Serial No."; Rec."Serial No.")
                {
                }
                field("Item Ref"; Rec."Item Ref")
                {
                }
                field(Quantity; Rec.Quantity)
                {
                }
                field("Unit Code"; Rec."Unit Code")
                {
                }
                field("Dimension Set ID"; Rec."Dimension Set ID")
                {
                    Visible = false;
                }
                field("Shortcut Dimension 1 Code"; Rec."Shortcut Dimension 1 Code")
                {
                    Visible = false;
                }
                field("Shortcut Dimension 2 Code"; Rec."Shortcut Dimension 2 Code")
                {
                    Visible = false;
                }
                field("Line No."; Rec."Line No.")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }
}

