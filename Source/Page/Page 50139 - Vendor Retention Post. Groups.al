page 50139 "Vendor Retention Post. Groups"
{
    Caption = 'Vendor Retention Posting Groups';
    PageType = List;
    SourceTable = "Vendor Posting Group";
    SourceTableView = WHERE("Retention Group" = CONST(true));

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                ShowCaption = false;
                field("Code"; Rec.Code)
                {
                }
                field("Retention %"; Rec."Retention %")
                {
                }
                field("Retention Account"; Rec."Retention Account")
                {
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                Visible = false;
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        "Retention Group" := true;
    end;
}

