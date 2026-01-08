pageextension 50115 "Afk Contact Card" extends "Contact Card"
{
    layout
    {
        // Add changes to page layout here
        addlast(General)
        {
            field("BE Inscription"; Rec."BE Inscription")
            {
                ApplicationArea = All;
            }
            field("DN Inscription"; Rec."DN Inscription")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        // Add changes to page actions here
    }

    var
    // myInt: Integer;
}