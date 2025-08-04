pageextension 50000 pageextension70000131 extends "Customer Price Groups"
{
    actions
    {
        addafter(SalesPrices)
        {
            action(ImportPrices)
            {
                ApplicationArea = All;
                Caption = 'Import sales prices';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = XMLport 50058;
            }
        }
    }
}

