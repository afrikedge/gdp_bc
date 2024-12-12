page 50272 "Période de validation Societe"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "General Ledger Setup";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Allow Posting From"; Rec."Allow Posting From")
                {
                }
                field("Allow Posting To"; Rec."Allow Posting To")
                {
                }
            }
        }
    }

    actions
    {
    }
}

