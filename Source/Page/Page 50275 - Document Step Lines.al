page 50275 "Document Step Lines"
{
    Caption = 'Document Step Lines';
    Editable = false;
    PageType = List;
    SourceTable = "Document Step History";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Step ID"; Rec."Step ID")
                {
                }
                field("Action"; Rec.Action)
                {
                }
                field("New Status"; Rec."New Status")
                {
                }
                field(UserID; UserID)
                {
                }
                field("Action Date"; Rec."Action Date")
                {
                }
                field("Created Document"; Rec."Created Document")
                {
                }
                field("Document Type"; Rec."Document Type")
                {
                }
                field("Document No."; Rec."Document No.")
                {
                }
                field("User Name"; Rec."User Name")
                {
                }
            }
        }
    }

    actions
    {
    }
}

