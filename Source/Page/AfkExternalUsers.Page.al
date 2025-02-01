page 50036 "Afk External Users"
{
    ApplicationArea = All;
    Caption = 'Afk External Users';
    PageType = List;
    SourceTable = "Afk FrontDesk User";
    UsageCategory = Lists;
    Editable = false;
    CardPageId = "Afk External User";

    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                }
                field(Name; Rec.Name)
                {
                }
                field(Active; Rec.Active)
                {
                }
                field("Customer No_"; Rec."Customer No_")
                {
                }
                field("Customer Name"; Rec."Customer Name")
                {
                }
                field("User Profile"; Rec."User Profile")
                {
                }
                field(UserMustChangePassword; Rec.UserMustChangePassword)
                {
                }
                field(PasswordIsSet; Rec.PasswordIsSet)
                {
                }
                field("Profile Description"; Rec."Profile Description")
                {
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                }
                field("Sales Person Code"; Rec."Sales Person Code")
                {
                }
                field("Language Code"; Rec."Language Code")
                {
                }
                field("Is Customer User"; Rec."Is Customer User")
                {
                }
                field("E-Mail"; Rec."E-Mail")
                {
                }
                field("Default Company Name"; Rec."Default Company Name")
                {
                }
                field("Default Company Id"; Rec."Default Company Id")
                {
                }
                field("Default Company"; Rec."Default Company")
                {
                }
                field("Can Approve As DG"; Rec."Can Approve As DG")
                {
                }
                field("Can Approve As DF"; Rec."Can Approve As DF")
                {
                }
                field("Can Approve As DD"; Rec."Can Approve As DD")
                {
                }
                field("Can Approve As DC"; Rec."Can Approve As DC")
                {
                }
                field("Can Approve As Ccredit"; Rec."Can Approve As Ccredit")
                {
                }
                field("Can Approve As CDBO"; Rec."Can Approve As CDBO")
                {
                }
                field("BC User Id"; Rec."BC User Id")
                {
                }
            }
        }
    }
}
