page 50135 "LC Currency Purchase Subform"
{
    AutoSplitKey = true;
    Caption = 'Currency Purchase';
    DelayedInsert = true;
    PageType = ListPart;
    PopulateAllFields = true;
    SourceTable = "Currency Purchase";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Due Line"; Rec."Due Line")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Amount Currency"; Rec."Amount Currency")
                {
                }
                field("Convertion Rate"; Rec."Convertion Rate")
                {
                }
                field("Amount LCY"; Rec."Amount LCY")
                {
                }
                field("Line No."; Rec."Line No.")
                {
                    Visible = false;
                }
                field(Posted; Rec.Posted)
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(GenerateEntries)
            {
                Caption = 'Add new purchase';
                Ellipsis = true;
                Image = Purchase;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    GLMgt.GenerateEcritureAchatDevise(Rec."Document No.", Rec);
                end;
            }
        }
    }

    var
        GLMgt: Codeunit "Treso Mgt";
}

