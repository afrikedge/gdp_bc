pageextension 50065 pageextension70000132 extends "Sales Prices"
{
    actions
    {

        //Unsupported feature: Property Modification (ActionContainerType) on "Filtering(Action 3)".

        addfirst(processing)
        {
            action(ImportPrices)
            {
                Caption = 'Import sales prices';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = XMLport 50058;
            }
        }
    }
}

