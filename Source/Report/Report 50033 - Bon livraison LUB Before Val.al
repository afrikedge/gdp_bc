report 50033 "Bon livraison LUB Before Val"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Source/Report/Layout/Bon livraison LUB Before Val.rdlc';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Adjustment Header"; "Adjustment Header")
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
            column(NomChauffeur; "Adjustment Header".nomchauffeur)
            {
            }
            column(Permis; "Adjustment Header".permis)
            {
            }
            dataitem("Adjustment Line"; "Adjustment Line")
            {
                column(DocNo; "Adjustment Line"."Document No.")
                {
                }
                column(CodeProduit; "Adjustment Line"."Item No.")
                {
                }
                column(Quantity; "Adjustment Line".Quantity)
                {
                }
                column(UnitCode; "Adjustment Line"."Unit of Measure")
                {
                }
                column(ItemName; "Adjustment Line".Description)
                {
                }
                column(MagLigne; "Adjustment Line"."Location Code")
                {
                }
                column(LineNo; "Adjustment Line"."Line No.")
                {
                }

                trigger OnPreDataItem()
                begin
                    "Adjustment Line".SetRange("Adjustment Line"."Document No.", "Adjustment Header"."No.");
                    "Adjustment Line".SetRange("Adjustment Line"."Document Type", "Adjustment Header"."Document Type");
                    if "Adjustment Line".FindFirst then;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if "Adjustment Header"."Location Code" <> '' then
                    Location.Get("Adjustment Header"."Location Code");
                if "Adjustment Header"."Customer No." <> '' then
                    Cust.Get("Adjustment Header"."Customer No.");
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

