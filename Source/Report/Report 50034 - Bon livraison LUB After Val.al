report 50034 "Bon livraison LUB After Val"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Source/Report/Layout/Bon livraison LUB After Val.rdlc';
    PreviewMode = PrintLayout;
    ApplicationArea = All;

    dataset
    {
        dataitem("Posted Adjustment Header"; "Posted Adjustment Header")
        {
            DataItemTableView = WHERE("Document Type" = CONST(Shipment));
            RequestFilterFields = "No.";
            column(No; "No.")
            {
            }
            column(Depot; "Location Code")
            {
            }
            column(DateLiv; Format("Shipment Date"))
            {
            }
            column(TranspName; "Transporter Name")
            {
            }
            column(NumCmde; "Order No.")
            {
            }
            column(CodeCamion; "Truck Code")
            {
            }
            column(CustNum; Cust."No.")
            {
            }
            column(CustName; Cust."Search Name")
            {
            }
            column(CustAddr; Cust.Address)
            {
            }
            column(CustCity; Cust."Town Code")
            {
            }
            column(CustPhone; Cust."Phone No.")
            {
            }
            column(LocationCode; Location.Code)
            {
            }
            column(LocationName; Location.Name)
            {
            }
            column(LocationAddr; Location.Address)
            {
            }
            column(RespCenterCode; RespCenter.Code)
            {
            }
            column(RespCenterName; RespCenter.Name)
            {
            }
            column(DatePrint; Format(Today))
            {
            }
            column(NomChauffeur; nomchauffeur)
            {
            }
            column(Permis; permis)
            {
            }
            dataitem("Posted Adjustment Line"; "Posted Adjustment Line")
            {
                column(DocNo; "Document No.")
                {
                }
                column(CodeProduit; "Item No.")
                {
                }
                column(Quantity; Quantity)
                {
                }
                column(UnitCode; "Unit of Measure")
                {
                }
                column(ItemName; Description)
                {
                }
                column(MagLigne; "Location Code")
                {
                }
                column(LineNo; "Line No.")
                {
                }

                trigger OnPreDataItem()
                begin
                    "Posted Adjustment Line".SetRange("Posted Adjustment Line"."Document No.", "Posted Adjustment Header"."No.");
                    "Posted Adjustment Line".SetRange("Posted Adjustment Line"."Document Type", "Posted Adjustment Header"."Document Type");
                    if "Posted Adjustment Line".FindFirst then;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if "Posted Adjustment Header"."Location Code" <> '' then
                    Location.Get("Posted Adjustment Header"."Location Code");
                if "Posted Adjustment Header"."Customer No." <> '' then
                    Cust.Get("Posted Adjustment Header"."Customer No.");
                if Cust."Responsibility Center" <> '' then
                    RespCenter.Get(Cust."Responsibility Center");
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        Location: Record Location;
        Cust: Record Customer;
        RespCenter: Record "Responsibility Center";
}

