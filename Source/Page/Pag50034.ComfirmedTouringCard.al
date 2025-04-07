page 50034 "Posted Touring Card"
{
    Caption = 'Posted Touring Card';
    Editable = false;
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = Touring;
    SourceTableView = where(Status = filter(Confirmed | Posted));

    layout
    {
        area(content)
        {
            group("Général")
            {
                field(IdTouring; Rec.IdTouring)
                {
                }
                field("Location Code"; Rec."Location Code")
                {

                }
                field("Touring Date"; Rec."Touring Date")
                {

                }
                field(Description; Rec.Description)
                {

                }
                field("User ID"; Rec."User ID")
                {
                }
                field("Creation Date"; Rec."Creation Date")
                {
                }
                field("Validity Date"; Rec."Validity Date")
                {

                }
                field(Status; Rec.Status)
                {
                }
                field("Total volume to ship"; Rec."Total volume to ship")
                {
                    Importance = Promoted;
                }
                field("Truck capacity"; Rec."Truck capacity")
                {
                    Importance = Promoted;
                }
            }
            part(SalesOrderSubform; "Touring Sales Order Subform")
            {
                Caption = 'Sales Orders';
                SubPageLink = IdTouring = FIELD(IdTouring);
            }
            part(TruckSubform; "Touring Truck Subform")
            {
                Caption = 'Trucks';
                SubPageLink = IdTouring = FIELD(IdTouring);
            }
            part("Bons List"; "Touring BE Subform")
            {
                Caption = 'Bons List';
                SubPageLink = idtournee = FIELD(IdTouring);

            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(ListeBons)
            {
                Caption = 'Bon Dispaching List';
                Image = ItemSubstitution;
                RunObject = Page "Bon Dispaching List";
                RunPageLink = idtournee = FIELD(IdTouring);

            }
        }
        area(Reporting)
        {
            action(PrintBE)
            {
                Caption = 'Imprimer BEs';
                Image = "Report";

                trigger OnAction()
                var
                    BE: record pro_enteteBE;
                    PrintBE: Report "PickUp Order";
                begin
                    BE.SetRange(idtournee, Rec.IdTouring);
                    BE.SetRange(isAnnule, false);
                    PrintBE.SetTableView(BE);
                    PrintBE.RunModal();
                end;
            }
            action(PrintBL)
            {
                Caption = 'Imprimer BLs';
                Image = "Report";

                trigger OnAction()
                var
                    BE: record pro_enteteBE;
                    PrintBL: Report "PBL FO Delivery Note";
                begin
                    BE.SetRange(idtournee, Rec.IdTouring);
                    BE.SetRange(isAnnule, false);
                    PrintBL.SetTableView(BE);
                    PrintBL.RunModal();
                end;
            }
            action(PrintProg)
            {
                Caption = 'Imprimer le programme';
                Image = "Report";

                trigger OnAction()
                var
                    Touring: record Touring;
                    TouringProgram: Report "Touring Program";
                begin
                    Touring.SetRange(IdTouring, Rec.IdTouring);
                    TouringProgram.SetTableView(Touring);
                    TouringProgram.RunModal();
                    //CRReport.PrintProgrammeTournee(Rec.IdTouring);
                end;
            }
            action(PrintTransferFile)
            {
                Caption = 'Importation fichier';
                Image = "Report";

                trigger OnAction()
                var
                    Touring: record Touring;
                    TouringProgram: Report "Touring Importation File";
                begin
                    Touring.SetRange(IdTouring, Rec.IdTouring);
                    TouringProgram.SetTableView(Touring);
                    TouringProgram.RunModal();
                    //CRReport.PrintProgrammeTournee(Rec.IdTouring);
                end;
            }
        }


        area(Promoted)
        {
            actionref(PrintBERef; PrintBE)
            {
            }
            actionref(PrintBLRef; PrintBL)
            {
            }
            actionref(PrintProgRef; PrintProg)
            {
            }
            actionref(PrintProgRef2; PrintTransferFile)
            {
            }
        }
    }


    trigger OnAfterGetCurrRecord()
    begin

    end;

    trigger OnOpenPage()
    begin
        // if not IsRefreshedOnCurr then
        //     Refresh;
        // IsPosted := ((Rec.Status = Rec.Status::Posted) or (Rec.Status = Rec.Status::Confirmed));
        // IsEditable := not IsPosted;
        // CurrPage.Editable := IsEditable;
        // CanPrintDocuments := IsPosted;
    end;

    var
        DispachMgt: Codeunit "Logistique Mgt";
        CRReport: Codeunit CRReports;
        IsPosted: Boolean;
        IsEditable: Boolean;
        IsRefreshedOnCurr: Boolean;
        CanPrintDocuments: Boolean;


}
