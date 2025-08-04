page 50008 "Removal Order Subform"
{
    AutoSplitKey = true;
    Caption = 'Lines';
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = pro_detailBE;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Control1000000001)
            {
                ShowCaption = false;
                field(NavItemCode; Rec.NavItemCode)
                {
                    Editable = IsNotFromDispaching;
                }
                field("Item Name"; Rec."Item Name")
                {
                }
                field(volumeaenlever; Rec.volumeaenlever)
                {
                    Editable = IsNotFromDispaching;
                }
                field(volumeenleve; Rec.volumeenleve)
                {
                }
                field(volumea15; Rec.volumea15)
                {
                    DecimalPlaces = 0 : 6;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    Editable = IsNotFromDispaching;
                }
                field(temperature; Rec.temperature)
                {
                }
                field(densite; Rec.densite)
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    begin
        if EnteteBE.Get(Rec.numBE) then
            IsNotFromDispaching := (EnteteBE.Source = EnteteBE.Source::" ");
    end;

    var
        IsNotFromDispaching: Boolean;
        EnteteBE: Record pro_enteteBE;
}

