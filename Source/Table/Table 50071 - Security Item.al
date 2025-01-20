table 50071 "Security Item"
{
    Caption = 'Security Item';

    fields
    {
        field(1; "User ID"; Code[50])
        {
            Caption = 'User ID';
            TableRelation = User."User Name";
            DataClassification = EndUserIdentifiableInformation;
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                UserSelection: Codeunit "User Selection";
            begin
                UserSelection.ValidateUserName("User ID");
            end;
        }
        field(2; SecurityType; Option)
        {
            OptionCaption = 'Region,BankAcc';
            OptionMembers = Region,BankAcc;
        }
        field(3; "Item Code"; Code[20])
        {
            Caption = 'Code';
            TableRelation = IF (SecurityType = CONST(Region)) "Responsibility Center"
            ELSE IF (SecurityType = CONST(BankAcc)) "Bank Account";
        }
    }

    keys
    {
        key(Key1; "User ID", SecurityType, "Item Code")
        {
        }
    }

    fieldgroups
    {
    }
}

