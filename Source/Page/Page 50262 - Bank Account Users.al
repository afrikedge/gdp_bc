page 50262 "Bank Account Users"
{
    Caption = 'Bank Account Users';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Security Item";
    SourceTableView = WHERE(SecurityType = CONST(BankAcc));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("User ID"; Rec."User ID")
                {
                }
                field("Item Code"; Rec."Item Code")
                {
                }
            }
        }
    }

    actions
    {
    }
}

