pageextension 50054 pageextension70000111 extends "FA Locations"
{
    layout
    {
        addafter("Name")
        {
            field("Project Code"; Rec."Project Code")
            {
            }
        }
    }
    actions
    {

        addfirst(processing)
        {
            action(SubLocations)
            {
                Caption = 'Sub Locations';
                Ellipsis = true;
                Image = SelectEntries;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page 50123;
                RunPageLink = "Location Code" = FIELD(Code);
            }
        }
    }
}

