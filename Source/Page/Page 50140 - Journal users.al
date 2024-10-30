page 50140 "Journal users"
{
    Caption = 'Journal Users';
    PageType = List;
    SourceTable = "Journal User";
    ApplicationArea = All;
    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("User ID"; Rec."User ID")
                {
                }
                field("Journal Template Name"; Rec."Journal Template Name")
                {
                }
                field("Journal Batch Name"; Rec."Journal Batch Name")
                {
                }
                field(Edit; Rec.Edit)
                {
                }
                field(Validate; Rec.Validate)
                {
                }
            }
        }
    }

    actions
    {
    }
}

