page 50133 "Invoice To Receive BE"
{
    Caption = 'Invoice tracking (moving expenses)';
    PageType = List;
    SourceTable = pro_enteteBE;
    SourceTableView = WHERE(isconfirme = CONST(true));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(numBE; Rec.numBE)
                {
                    Editable = false;
                }
                field(depot; Rec.depot)
                {
                    Editable = false;
                }
                field(dateBE; Rec.dateBE)
                {
                    Editable = false;
                }
                field(idtournee; Rec.idtournee)
                {
                    Editable = false;
                }
                field(codemoyentransport; Rec.codemoyentransport)
                {
                    Editable = false;
                }
                field(numBSL; Rec.numBSL)
                {
                    Editable = false;
                }
                field("Invoice Received"; Rec."Invoice Received")
                {
                }
                field("Invoice Number"; Rec."Invoice Number")
                {
                }
            }
        }
    }

    actions
    {
    }
}

