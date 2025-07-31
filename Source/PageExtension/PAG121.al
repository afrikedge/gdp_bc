pageextension 50018 pageextension70000018 extends "G/L Budget Names"
{
    actions
    {
        addafter(EditBudget)
        {
            action(ImportBudget)
            {
                RunObject = XMLport 50005;
                ApplicationArea = All;
            }
        }
    }
}

