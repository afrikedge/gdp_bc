page 50271 "Transporteurs GDP"
{
    Caption = 'Transporteurs';
    PageType = List;
    SourceTable = Vendor;
    SourceTableView = WHERE(Transporter = CONST(true));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    Editable = false;
                }
                field("Name 2"; Rec."Name 2")
                {
                }
                field(Name; Rec.Name)
                {
                    Caption = 'Name';
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Statistiques transporteurs")
            {
                Caption = 'Statistiques transporteurs';
                Image = Statistics;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Dispaching Events";
            }
        }
    }
}

