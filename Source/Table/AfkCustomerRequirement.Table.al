table 50107 "Afk Customer Requirement"
{
    Caption = 'Afk Customer Requirement';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Account Type"; Enum "Afk CRM Account Type")
        {
            Caption = 'Account Type';
        }
        field(2; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;
        }
        field(3; "Lead No."; Code[20])
        {
            Caption = 'Lead No.';
            TableRelation = Contact where("Afk Contact Type" = const(Prospect));
        }
        field(4; Criteria; Code[20])
        {
            Caption = 'Criteria';
            TableRelation = "Afk Requirement Criteria";
        }
        field(5; "Criteria Description"; Text[100])
        {
            Caption = 'Criteria Description';
        }
        field(6; "Value Type"; Enum "Afk Value Type")
        {
            Caption = 'Value Type';
        }
        field(7; "List Value"; Code[20])
        {
            Caption = 'List Value';
            TableRelation = "Afk Criteria Value";//where ("Value Type"=field("Value Type"));
        }
        field(8; "Numeric Value"; Decimal)
        {
            Caption = 'Numeric Value';
        }
        field(9; "Alpha Value"; Code[20])
        {
            Caption = 'Alpha Value';
        }
        field(10; "Date Value"; Date)
        {
            Caption = 'Date Value';
        }
        field(11; Validity; Enum "Afk Validity Type")
        {
            Caption = 'Validity';
        }
        field(12; "Validity Date"; Date)
        {
            Caption = 'Validity Date';
        }
        field(13; "Document required"; Boolean)
        {
            Caption = 'Document required';
        }
        field(14; "Document Link"; Text[250])
        {
            Caption = 'Document Link';
        }
        field(15; "Updated by"; Code[50])
        {
            Caption = 'Updated by';
            TableRelation = "Afk FrontDesk User";
        }
    }
    keys
    {
        key(PK; "Account Type")
        {
            Clustered = true;
        }
    }
}
