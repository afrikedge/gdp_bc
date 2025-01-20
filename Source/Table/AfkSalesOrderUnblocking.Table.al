table 50102 "Afk SalesOrder Unblocking"
{
    Caption = 'Afk SalesOrder Unblocking';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(2; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;
        }
        field(3; Name; Text[100])
        {
            Caption = 'Name';
        }
        field(4; Object; Text[250])
        {
            Caption = 'Object';
        }
        field(5; "Approval Status"; Enum "Afk Approval Mode")
        {
            Caption = 'Approval Status';
        }
        field(6; Observations; Text[250])
        {
            Caption = 'Observations';
        }
        field(7; "Credit Limit (LCY)"; Decimal)
        {
            Caption = 'Credit Limit (LCY)';
        }
        field(8; "Risk Level"; Code[20])
        {
            Caption = 'Risk Level';
        }
        field(9; "Payment Terms Code"; Code[20])
        {
            Caption = 'Payment Terms Code';
        }
        field(10; "Balance Amount"; Decimal)
        {
            Caption = 'Balance Amount';
        }
        field(11; "Pending Order"; Decimal)
        {
            Caption = 'Pending Order';
        }
        field(12; "Pending Delivery"; Decimal)
        {
            Caption = 'Pending Delivery';
        }
        field(13; "Pending Invoice"; Decimal)
        {
            Caption = 'Pending Invoice';
        }
        field(14; "Payment In Progress"; Decimal)
        {
            Caption = 'Payment In Progress';
        }
        field(15; "Gross exposure"; Decimal)
        {
            Caption = 'Gross exposure';
        }
        field(16; "Amount Due"; Decimal)
        {
            Caption = 'Amount Due';
        }
        field(17; "Exceeding Amount"; Decimal)
        {
            Caption = 'Exceeding Amount';
        }
        field(18; "Unpaid bills"; Decimal)
        {
            Caption = 'Unpaid bills';
        }
        field(19; "Pending Traite"; Decimal)
        {
            Caption = 'Pending Traite';
        }
        field(20; "Unblocking justified"; Boolean)
        {
            Caption = 'Unblocking justified';
        }
        field(21; "Created By"; Code[50])
        {
            Caption = 'Created By';
            TableRelation = "Afk FrontDesk User";
        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
}
