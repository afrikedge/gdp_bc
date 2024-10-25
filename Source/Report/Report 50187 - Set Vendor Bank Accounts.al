report 50187 "Set Vendor Bank Accounts"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Vendor Bank Account";"Vendor Bank Account")
        {

            trigger OnAfterGetRecord()
            var
                VendBankAcc: Record "Vendor Bank Account";
            begin

                "Vendor Bank Account".Validate("Bank Branch No.");
                "Vendor Bank Account".Modify;
            end;

            trigger OnPostDataItem()
            begin
                Message('Traitement termine');
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }
}

