page 50316 "Compartment Subform"
{
    DeleteAllowed = false;
    InsertAllowed = true;
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = Compartment;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Capacity1; Rec.Capacity1)
                {
                }
                field(Capacity2; Rec.Capacity2)
                {
                }
                field(Capacity3; Rec.Capacity3)
                {
                }
                field(Capacity4; Rec.Capacity4)
                {
                }
                field(Capacity5; Rec.Capacity5)
                {
                }
                field(Capacity6; Rec.Capacity6)
                {
                }
                field(Capacity7; Rec.Capacity7)
                {
                }
                field(Capacity8; Rec.Capacity8)
                {
                }
                field(Capacity9; Rec.Capacity9)
                {
                }
                field(Capacity10; Rec.Capacity10)
                {
                }
                field("Total Capacity"; Rec."Total Capacity")
                {
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        Compart: Record Compartment;
    begin
        Compart.Reset;
        Compart.SetRange(Compart.immatriculation, Rec.immatriculation);
        if Compart.FindFirst then
            Error(Text001);
    end;

    var
        Text001: Label 'Un compartiment existe déjà pour ce camion';
}

