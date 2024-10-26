page 50330 "Touring BE Subform"
{
    AutoSplitKey = false;
    DelayedInsert = true;
    Editable = false;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = pro_enteteBE;
    SourceTableView = WHERE(IsBon = CONST(true));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(NumBU; Rec.NumBU)
                {
                }
                field(depot; Rec.depot)
                {
                }
                field(dateBE; Rec.dateBE)
                {
                }
                field(idtournee; Rec.idtournee)
                {
                    Visible = false;
                }
                field(codemoyentransport; Rec.codemoyentransport)
                {
                }
                field(numBSL; Rec.numBSL)
                {
                }
                field(Imprime; Rec.Imprime)
                {
                }
                field(isconfirme; Rec.isconfirme)
                {
                }
                field(BonIsConfirme; Rec.BonIsConfirme)
                {
                }
                field(isAnnule; Rec.isAnnule)
                {
                }
                field(datevalidite; Rec.datevalidite)
                {
                }
                field(datecreation; Rec.datecreation)
                {
                }
                field(datelivraison; Rec.datelivraison)
                {
                }
                field(NavOrderNo; Rec.NavOrderNo)
                {
                }
                field("Customer No"; Rec."Customer No")
                {
                }
                field("Sales Channel Code"; Rec."Sales Channel Code")
                {
                }
                field("Customer Name"; Rec."Customer Name")
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
                    PageBE: Page "Bon Order (Dispaching)";
                    BERec: Record pro_enteteBE;
                    PageBEConf: Page "Confirmed Bon Order";
                begin
                    if BERec.Get(Rec.numBE) then begin
                        if not BERec.BonIsConfirme and not BERec.isAnnule then begin
                            //BERec.SETRANGE(numBE,numBE);
                            PageBE.SetRecord(BERec);
                            PageBE.RunModal;
                        end else begin
                            PageBEConf.SetRecord(BERec);
                            PageBEConf.RunModal;
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

