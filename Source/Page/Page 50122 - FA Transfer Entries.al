page 50122 "FA Transfer Entries"
{
    Caption = 'Fixed Asset Transfers';
    Editable = false;
    PageType = List;
    SourceTable = "FA Transfer";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("FA No."; Rec."FA No.")
                {
                }
                field("Transfer Date"; Rec."Transfer Date")
                {
                }
                field("External Document No."; Rec."External Document No.")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("FA Location Code"; Rec."FA Location Code")
                {
                }
                field("Old FA Location"; Rec."Old FA Location")
                {
                }
                field("FA Location Code New"; Rec."FA Location Code New")
                {
                }
                field("New FA Location"; Rec."New FA Location")
                {
                }
                field("User ID"; Rec."User ID")
                {
                }
                field("Entry Date"; Rec."Entry Date")
                {
                }
            }
        }
    }

    actions
    {
    }
}

