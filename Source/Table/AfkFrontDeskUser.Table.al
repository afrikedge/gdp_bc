table 50099 "Afk FrontDesk User"
{
    Caption = 'Afk FrontDesk User';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Code"; Code[50])
        {
            Caption = 'Code';
        }
        field(2; Name; Text[100])
        {
            Caption = 'Name';
        }
        field(3; Active; Boolean)
        {
            Caption = 'Active';
        }
        field(4; "E-Mail"; Text[80])
        {
            Caption = 'E-Mail';
        }
        field(5; Password; Text[255])
        {
            Caption = 'Password';
        }
        field(6; "Default Company"; Code[20])
        {
            Caption = 'Default Company';
        }
        field(7; "Default Company Name"; Text[100])
        {
            Caption = 'Default Company Name';
        }
        field(8; "Default Company Id"; Guid)
        {
            Caption = 'Default Company Id';
        }
        field(9; UserMustChangePassword; Boolean)
        {
            Caption = 'UserMustChangePassword';
        }
        field(10; "BC User Id"; Code[50])
        {
            Caption = 'BC User Id';
        }
        field(11; "Sales Person Code"; Code[20])
        {
            Caption = 'Sales Person Code';
        }
        field(12; "Is Customer User"; Boolean)
        {
            Caption = 'Is Customer User';
        }
        field(13; "Customer No_"; Code[20])
        {
            Caption = 'Customer No_';
        }
        field(14; "Customer Name"; Text[100])
        {
            Caption = 'Customer Name';
        }
        field(15; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
        }
        field(16; "User Profile"; Code[20])
        {
            Caption = 'User Profile';
        }
        field(17; "Profile Description"; Text[100])
        {
            Caption = 'Profile Description';
        }
        field(18; "Language Code"; Code[10])
        {
            Caption = 'Language Code';
        }
        field(19; "Can Approve As Ccredit"; Boolean)
        {
            Caption = 'Can Approve As Ccredit';
        }
        field(20; "Can Approve As DD"; Boolean)
        {
            Caption = 'Can Approve As DD';
        }
        field(21; "Can Approve As DC"; Boolean)
        {
            Caption = 'Can Approve As DC';
        }
        field(22; "Can Approve As DF"; Boolean)
        {
            Caption = 'Can Approve As DF';
        }
        field(23; "Can Approve As DG"; Boolean)
        {
            Caption = 'Can Approve As DG';
        }
        field(24; "Can Approve As CDBO"; Boolean)
        {
            Caption = 'Can Approve As CDBO';
        }
        field(25; PasswordIsSet; Boolean)
        {
            Editable = false;
            Caption = 'Password Exists';
        }
    }
    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
}
