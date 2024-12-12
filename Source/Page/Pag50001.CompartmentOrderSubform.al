page 50001 CompartmentOrderSubform
{
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = Compartment;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Ordre1; Rec.Ordre1)
                {
                    Editable = Rec.Capacity1 > 0;
                }
                field(Ordre2; Rec.Ordre2)
                {
                    Editable = Rec.Capacity2 > 0;
                }
                field(Ordre3; Rec.Ordre3)
                {
                    Editable = Rec.Capacity3 > 0;
                }
                field(Ordre4; Rec.Ordre4)
                {
                    Editable = Rec.Capacity4 > 0;
                }
                field(Ordre5; Rec.Ordre5)
                {
                    Editable = Rec.Capacity5 > 0;
                }
                field(Ordre6; Rec.Ordre6)
                {
                    Editable = Rec.Capacity6 > 0;
                }
                field(Ordre7; Rec.Ordre7)
                {
                    Editable = Rec.Capacity7 > 0;
                }
                field(Ordre8; Rec.Ordre8)
                {
                    Editable = Rec.Capacity8 > 0;
                }
                field(Ordre9; Rec.Ordre9)
                {
                    Editable = Rec.Capacity9 > 0;
                }
                field(Ordre10; Rec.Ordre10)
                {
                    Editable = Rec.Capacity10 > 0;
                }
            }
        }
    }
}
