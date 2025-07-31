pageextension 50068 pageextension70000135 extends "Small Business Owner RC"
{
    actions
    {
        addafter(CashReceiptJournals)
        {
            action("Cash Receipt Journals")
            {
                Caption = 'Cash Receipt Journals';
                Image = Journals;
                RunObject = Page 50184;
                RunPageView = WHERE("Template Type" = CONST("Cash Receipts"),
                                    "Recurring" = CONST(false));
                ApplicationArea = All;
            }
        }
    }
}

