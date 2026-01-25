page 50037 "Afk External User"
{
    ApplicationArea = All;
    Caption = 'Afk External User';
    PageType = Card;
    SourceTable = "Afk FrontDesk User";
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field("Code"; Rec."Code")
                {
                }
                field(Name; Rec.Name)
                {
                }
                field("E-Mail"; Rec."E-Mail")
                {
                }
                field("BC User Id"; Rec."BC User Id")
                {
                }
                field(Active; Rec.Active)
                {
                }
                field("Default Company"; Rec."Default Company")
                {
                }
                // field("Default Company Id"; Rec."Default Company Id")
                // {
                // }
                // field("Default Company Name"; Rec."Default Company Name")
                // {
                // }
                field("Customer No_"; Rec."Customer No_")
                {
                }
                // field("Customer Name"; Rec."Customer Name")
                // {
                // }
                field("Language Code"; Rec."Language Code")
                {
                }
                field(UserMustChangePassword; Rec.UserMustChangePassword)
                {
                }
                field(PasswordIsSet; Rec.PasswordIsSet)
                {
                }
                field("Sales Person Code"; Rec."Sales Person Code")
                {
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                }
                field("Can Consult GM"; Rec."Can Consult GM")
                {
                }
            }
            group(Autorisations)
            {
                Caption = 'Autorisations';

                field("User Profile"; Rec."User Profile")
                {
                }
                // field("Profile Description"; Rec."Profile Description")
                // {
                // }
                field("Is Customer User"; Rec."Is Customer User")
                {
                }
                field("Can Approve As CDBO"; Rec."Can Approve As CDBO")
                {
                }
                field("Can Approve As Ccredit"; Rec."Can Approve As Ccredit")
                {
                }
                field("Can Approve As DC"; Rec."Can Approve As DC")
                {
                }
                field("Can Approve As DD"; Rec."Can Approve As DD")
                {
                }
                field("Can Approve As DF"; Rec."Can Approve As DF")
                {
                }
                field("Can Approve As DG"; Rec."Can Approve As DG")
                {
                }
            }
        }
    }
    actions
    {
        area(navigation)
        {
            group(Process)
            {
                action(CreatePassword)
                {
                    ApplicationArea = All;
                    Image = Create;
                    Caption = 'Create or reset password';
                    //Promoted = true;
                    //PromotedCategory = Process;
                    trigger OnAction()
                    var
                        ResetPasswordPage: Report "Afk CreateResetPassword";
                    begin
                        ResetPasswordPage.SetUserCode(Rec.Code);
                        ResetPasswordPage.RunModal();
                    end;
                }
                // action(CreatePasswordTest)
                // {
                //     ApplicationArea = All;
                //     Image = Create;
                //     Caption = 'TestJP';
                //     //Promoted = true;
                //     //PromotedCategory = Process;
                //     trigger OnAction()
                //     var
                //         ApiMgt: Codeunit "A01 Api Mgt";
                //     begin
                //         ApiMgt.DebugApiFunction();
                //     end;
                // }
            }
        }
    }
}
