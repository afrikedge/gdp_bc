page 50331 "Touring BL Subform"
{
    AutoSplitKey = false;
    DelayedInsert = true;
    Editable = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = pro_enteteBL;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(numBL; Rec.numBL)
                {
                }
                field(codemoyentransport; Rec.codemoyentransport)
                {
                }
                field(NavOrderNo; Rec.NavOrderNo)
                {
                }
                field(AdrLivraisonBL; Rec.AdrLivraisonBL)
                {
                }
                field(depot; Rec.depot)
                {
                    Visible = false;
                }
                field(numBE; Rec.numBE)
                {
                }
                field(idtournee; Rec.idtournee)
                {
                    Visible = false;
                }
                field(datevalidite; Rec.datevalidite)
                {
                }
                field(isconfirme; Rec.isconfirme)
                {
                }
                field(Imprime; Rec.Imprime)
                {
                }
                field(isAnnule; Rec.isAnnule)
                {
                }
                field("Posted Shipment No"; Rec."Posted Shipment No")
                {
                }
                field(datecreation; Rec.datecreation)
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(OpenCard)
            {
                Caption = 'Open card';
                Image = Document;

                trigger OnAction()
                var
                    PageBL: Page "Delivery Order";
                    BLRec: Record pro_enteteBL;
                    PageBLConf: Page "Posted Delivery Order";
                begin
                    if BLRec.Get(Rec.numBL) then begin

                        if not BLRec.isconfirme then begin
                            PageBL.SetRecord(BLRec);
                            PageBL.RunModal;
                        end else begin
                            PageBLConf.SetRecord(BLRec);
                            PageBLConf.RunModal;
                        end;
                    end;
                end;
            }
        }
    }

    var
        TouringH: Record Touring;
        AddOn: Record "AddOn Setup";
        DispachingMgt: Codeunit "Logistique Mgt";
}

