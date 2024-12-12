page 50367 "Dispaching Incident Types"
{
    Caption = 'Motifs incident Dispaching';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Dispaching Incident Type";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Incident Type"; Rec."Incident Type")
                {
                }
                field("Incident Code"; Rec."Incident Code")
                {
                }
                field(Description; Rec.Description)
                {
                }
            }
        }
    }

    actions
    {
    }
}

