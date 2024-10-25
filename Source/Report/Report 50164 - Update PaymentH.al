report 50164 "Update PaymentH"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem(Driver;Driver)
        {

            trigger OnAfterGetRecord()
            var
                Cust: Record Customer;
            begin

                Driver.Validate(Driver.Titulaire);
                Driver.Modify;
            end;

            trigger OnPostDataItem()
            begin
                Message('Termine');
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

