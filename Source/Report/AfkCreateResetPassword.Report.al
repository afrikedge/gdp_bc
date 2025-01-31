report 50026 "Afk CreateResetPassword"
{
    Caption = 'Create or reset password';
    ProcessingOnly = true;
    UsageCategory = None;
    dataset
    {
        // dataitem(Integer; "Integer")
        // {
        // }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(NewPasswordCtrl; NewPassword)
                    {
                        ApplicationArea = All;
                        Caption = 'New password';
                        ShowMandatory = true;
                        ExtendedDatatype = Masked;
                    }
                    field(ConfirmNewPasswordCtrl; ConfirmNewPassword)
                    {
                        ApplicationArea = All;
                        Caption = 'Confirm password';
                        ShowMandatory = true;
                        ExtendedDatatype = Masked;
                    }
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }

    trigger OnPreReport()
    begin
        if (NewPassword = '') then
            error(ErrMissingField);
        if (NewPassword = '') then
            error(ErrMissingField);
        if (NewPassword <> ConfirmNewPassword) then
            error(ErrNotSamePasswords);
        SecurityMgt.CreateNewPassword(UserCode, NewPassword, true);
    end;


    var
        SecurityMgt: Codeunit "Security Mgt";
        NewPassword: Text[50];
        ConfirmNewPassword: Text[50];
        UserCode: Code[50];
        ErrNotSamePasswords: Label 'The two passwords are not identical';
        ErrMissingField: Label 'Please fill all the fields';


    /// <summary>
    /// 
    /// </summary>
    /// <param name="UserC"></param>
    procedure SetUserCode(UserC: Code[50])
    begin
        UserCode := UserC;
    end;
}
