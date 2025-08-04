page 50028 "PO FA Subform"
{
    AutoSplitKey = true;
    Caption = 'Fixed Asset Lines';
    DelayedInsert = true;
    PageType = ListPart;
    ApplicationArea = All;
    PopulateAllFields = true;
    SourceTable = "Purchase Order Tracking";
    SourceTableView = WHERE("Data Type" = CONST(FraisAnnexe));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("FA Code"; Rec."FA Code")
                {
                }
                field("FA Name"; Rec."FA Name")
                {
                }
                field("FA Amount"; Rec."FA Amount")
                {
                }
                field("Vendor Code"; Rec."Vendor Code")
                {
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                }
                field("Information Descr"; Rec."Information Descr")
                {
                    Caption = 'Receipt Infos';
                }
                field(Provisioned; Rec.Provisioned)
                {
                }
                field("Provision Invoice"; Rec."Provision Invoice")
                {
                }
                field("Provision Posted Invoice"; Rec."Provision Posted Invoice")
                {
                }
            }
        }
    }

    actions
    {
    }
}

