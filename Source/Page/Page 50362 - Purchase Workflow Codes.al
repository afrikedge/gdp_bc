page 50362 "Purchase Workflow Codes"
{
    Caption = 'Département/Direction Workflow Codes';
    PageType = List;
    SourceTable = "Purchase Dept Workflow Code";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                }
                field(Libelle; Rec.Libelle)
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

