pageextension 50053 pageextension70000110 extends "FA Posting Groups"
{
    layout
    {
        addafter("Allocated Custom 2 %")
        {
            field("Groupe Immo Encours"; Rec."Groupe Immo Encours")
            {
            }
            field(Name; Rec.Name)
            {
            }
        }
    }
}

