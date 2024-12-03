table 50003 "Sales Order Pay Doc"
{
    Caption = 'Sales Order Payment Doc';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(2; "Pay Document No."; Code[20])
        {
            Caption = 'Pay Document No.';
        }
        field(3; "Paid Amount"; Decimal)
        {
            Caption = 'Paid Amount';
        }
        field(4; "Pay Doc Entry No."; integer)
        {
            Caption = 'Pay Doc Entry No.';
        }
        field(5; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
        }
    }
    keys
    {
        key(PK; "Customer No.", "Document No.", "Pay Document No.")
        {
            Clustered = true;
        }
    }
}
