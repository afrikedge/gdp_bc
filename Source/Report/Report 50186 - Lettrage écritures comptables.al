report 50186 "Lettrage écritures comptables"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Lettrage écritures comptables.rdlc';

    dataset
    {
        dataitem("G/L Entry";"G/L Entry")
        {
            DataItemTableView = SORTING("G/L Account No.","Document No.","Posting Date");
            RequestFilterFields = "G/L Account No.","Posting Date","Document No.";
            column(AccountNo;"G/L Account No.")
            {
            }
            column(PostingDate;"Posting Date")
            {
            }
            column(DocumentNo;"Document No.")
            {
            }
            column(Description;Description)
            {
            }
            column(DocumentType;"Document Type")
            {
            }
            column(Letter;Letter)
            {
            }
            column(DateLetter;"Letter Date")
            {
            }
            column(IDLetter;"Applies-to ID")
            {
            }
            column(AccountName;"G/L Account Name")
            {
            }
            column(BalAccountNo;"Bal. Account No.")
            {
            }
            column(Amount;Amount)
            {
            }
            column(ExternalDocumentNo;"External Document No.")
            {
            }
            column(TransactionDate;"Transaction Date")
            {
            }
            column(let;let)
            {
            }
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(Lettrage;let)
                {
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        let: Boolean;
}

