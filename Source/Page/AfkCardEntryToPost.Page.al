namespace gdp_bc.gdp_bc;
using Microsoft.Sales.Customer;

page 50232 "Afk Card Entry To Post"
{
    ApplicationArea = All;
    Caption = 'Card Entry To Post';
    PageType = List;
    SourceTable = "Afk Card Operation Entry";
    UsageCategory = Lists;

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("File"; Rec."File")
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Customer No."; Rec."Customer No.")
                {
                    TableRelation = Customer;
                }
                field(Description; Rec.Description)
                {
                }
                field(Amount; Rec.Amount)
                {
                }
                field("Posted In GL"; Rec."Posted In GL")
                {
                }
                field("Posted Document No."; Rec."Posted Document No.")
                {
                }
                field("Error Message"; Rec."Error Message")
                {
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(PostNow)
            {
                ApplicationArea = All;
                Caption = 'Comptabiliser';
                Image = PostBatch;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    CardEntryPostingMgr: Codeunit "Afk Card Operation Posting";
                begin
                    CardEntryPostingMgr.Run();
                    CurrPage.Update(false);
                end;
            }
            action("&Navigate")
            {
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Rec.Navigate;
                end;
            }
        }
    }
}
