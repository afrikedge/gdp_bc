page 50143 "Signatory List"
{
    Caption = 'Signatory List';
    CardPageID = "Signatory Card";
    Editable = false;
    PageType = List;
    SourceTable = Signatory;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                }
                field(Name; Rec.Name)
                {
                }
                field("Company No."; Rec."Company No.")
                {
                }
                field("Company Name"; Rec."Company Name")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("&Signature")
            {
                Caption = '&Signature';
                Ellipsis = true;
                Image = Picture;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Signatory Picture";
                RunPageLink = "No." = FIELD("No.");
            }
        }
    }
}

