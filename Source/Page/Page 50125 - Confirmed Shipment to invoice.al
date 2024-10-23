page 50125 "Confirmed Shipment to invoice"
{
    Caption = 'Confirmed Shipment invoices';
    CardPageID = "Posted Delivery Order";
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = pro_enteteBL;
    SourceTableView = WHERE(isconfirme = CONST(true),
                            codemoyentransport = CONST('<>'''));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(numBL; Rec.numBL)
                {
                    Caption = 'BL No.';
                    Editable = false;
                }
                field(depot; Rec.depot)
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
                field(datecreation; Rec.datecreation)
                {
                    Editable = false;
                }
                field(NavOrderNo; Rec.NavOrderNo)
                {
                    Editable = false;
                }
                field(numBE; Rec.numBE)
                {
                    Editable = false;
                }
                field(region; Rec.region)
                {
                    Editable = false;
                }
                field("Code Transporter"; Rec."Code Transporter")
                {
                    Editable = false;
                }
                field("Transporter Name"; Rec."Transporter Name")
                {
                    Editable = false;
                }
                field("Transport invoiced"; Rec."Transport invoiced")
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

