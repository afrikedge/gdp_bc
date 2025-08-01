page 50339 "Bon Order Subform"
{
    AutoSplitKey = true;
    Caption = 'Lines';
    DelayedInsert = true;
    PageType = ListPart;
    ApplicationArea = All;
    SourceTable = pro_detailBE;

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
                    Editable = BEIsNotConfirmed;
                }
                field(volumea15; Rec.volumea15)
                {
                    DecimalPlaces = 0 : 6;
                    Editable = BEIsNotConfirmed;
                }
                field(volumealivrer; Rec.volumealivrer)
                {
                }
                field(volumelivre; Rec.volumelivre)
                {
                }
                field("Shipped Volume"; Rec."Shipped Volume")
                {
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    Editable = IsNotFromDispaching;
                }
                field(temperature; Rec.temperature)
                {
                    Editable = BEIsNotConfirmed;
                }
                field(densite; Rec.densite)
                {
                    Editable = BEIsNotConfirmed;
                }
            }
        }
    }

    actions
    {

    }


    trigger OnAfterGetCurrRecord()
    begin
        if EnteteBE.Get(Rec.numBE) then begin
            IsNotFromDispaching := (EnteteBE.Source = EnteteBE.Source::" ");
            BEIsNotConfirmed := not EnteteBE.isconfirme;
        end;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        myInt: Integer;
    begin
        if EnteteBE.Get(Rec.numBE) then begin
            if not (EnteteBE.Source = EnteteBE.Source::" ") then
                Error('Vous ne devez pas ajouter une ligne sur ce bon car il provient du dispaching');
        end;
    end;

    var
        IsNotFromDispaching: Boolean;
        EnteteBE: Record pro_enteteBE;
        BEIsNotConfirmed: Boolean;
}

