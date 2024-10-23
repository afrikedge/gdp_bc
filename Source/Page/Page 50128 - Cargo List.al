page 50128 "Cargo List"
{
    Caption = 'Cargo List';
    PageType = List;
    SourceTable = Cargo;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Cargo Type"; Rec."Cargo Type")
                {
                }
                field("Arrival Date"; Rec."Arrival Date")
                {
                }
                field("Cargo Number"; Rec."Cargo Number")
                {
                }
                field("Cargo Date"; Rec."Cargo Date")
                {
                }
                field("Vessel Name"; Rec."Vessel Name")
                {
                }
                field(Closed; Rec.Closed)
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(CargoEntries)
            {
                Caption = 'Cargo entries';
                Image = EntriesList;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Item Cargo Entries";
                RunPageLink = "Ref Cargo" = FIELD(Code);
            }
            action(Contenu)
            {
                Image = AssemblyBOM;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Contenu Cargo";
                RunPageLink = "Ref Cargo" = FIELD(Code);
            }
        }
    }
}

