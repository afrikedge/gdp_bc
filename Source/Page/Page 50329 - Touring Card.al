page 50329 "Touring Card"
{
    Editable = true;
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = Touring;

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
                    Editable = IsEditable;
                }
                field("Touring Date"; Rec."Touring Date")
                {
                    Editable = IsEditable;
                }
                field(Description; Rec.Description)
                {
                    Editable = IsEditable;
                }
                field("User ID"; Rec."User ID")
                {
                }
                field("Creation Date"; Rec."Creation Date")
                {
                }
                field("Validity Date"; Rec."Validity Date")
                {
                    Editable = IsEditable;
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
                Visible = IsPosted;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(RunDispach)
            {
                Caption = 'Dispach';
                //Image = "Where-Used";
                Image = Approval;
                Visible = IsEditable;
                // Promoted = true;
                // PromotedCategory = Process;
                // PromotedIsBig = true;

                trigger OnAction()
                var
                    TourOrder: Record "Touring Sales Order";
                begin

                    if Rec.Status <> Rec.Status::Confirmed then begin

                        TourOrder.Reset;
                        TourOrder.SetRange(IdTouring, Rec.IdTouring);
                        if TourOrder.FindSet then
                            repeat
                                DispachMgt.CheckNewOrderDispaching(Rec.IdTouring, TourOrder."Order No");
                            until TourOrder.Next = 0;

                        Rec.TestField(Description);
                        Rec.TestField("Touring Date");
                        Rec.TestField("Validity Date");
                        Rec.TestField("Location Code");
                        Rec.CalcFields("Total volume to ship", "Truck capacity");
                        Rec.TestField("Total volume to ship");
                        Rec.TestField("Truck capacity");
                        if (Rec."Validity Date" < (Rec."Creation Date")) then Error(Text037);
                        if (Rec."Validity Date" < (Rec."Touring Date")) then Error(Text038);
                    end;

                    //DispachMgt.RunDispach(Rec.IdTouring);

                    // if Rec.Status <> Rec.Status::Confirmed then
                    //     CurrPage.Close;
                end;
            }
            action(ListeBE)
            {
                Caption = 'Removal Order List';
                Image = ItemSubstitution;
                RunObject = Page "Bon Dispaching List";
                RunPageLink = idtournee = FIELD(IdTouring);
                Visible = CanPrintDocuments;
            }
            action(ListeBL)
            {
                Caption = 'Delivery Order List';
                Image = SKU;
                RunObject = Page "Delivery Order List";
                RunPageLink = idtournee = FIELD(IdTouring);
                Visible = false;
            }
            group(Print)
            {
                Caption = 'Print';
                group(ActionGroup1000000025)
                {
                    Caption = 'Print';
                    Image = Transactions;
                    action(PrintBE)
                    {
                        Caption = 'Les bons d''enlèvements';
                        Image = "Report";
                        Visible = CanPrintDocuments;

                        trigger OnAction()
                        begin
                            CRReport.PrintBETournee(Rec.IdTouring);
                        end;
                    }
                    action(PrintBL)
                    {
                        Caption = 'Les bons de livraison';
                        Image = "Report";
                        Visible = CanPrintDocuments;

                        trigger OnAction()
                        begin
                            CRReport.PrintBLTournee(Rec.IdTouring);
                        end;
                    }
                    action(PrintProg)
                    {
                        Caption = 'Le programme';
                        Image = "Report";
                        Visible = CanPrintDocuments;

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
                }
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
        }
    }


    trigger OnAfterGetCurrRecord()
    begin
        if not IsRefreshedOnCurr then
            Refresh;
    end;

    trigger OnOpenPage()
    begin
        if not IsRefreshedOnCurr then
            Refresh;
        IsPosted := ((Rec.Status = Rec.Status::Posted) or (Rec.Status = Rec.Status::Confirmed));
        IsEditable := not IsPosted;
        CurrPage.Editable := IsEditable;
        CanPrintDocuments := IsPosted;
    end;

    var
        DispachMgt: Codeunit "Logistique Mgt";
        CRReport: Codeunit CRReports;
        IsPosted: Boolean;
        IsEditable: Boolean;
        IsRefreshedOnCurr: Boolean;
        Text037: Label 'La date de validité doit être postérieure à la date de création';
        Text038: Label 'La date de validité doit être postérieure à la date de début de la tournée';
        CanPrintDocuments: Boolean;

    local procedure Refresh()
    var
    // WshShell: Automation BC;
    begin
        // if IsClear(WshShell) then
        //   Create(WshShell,true,true);
        // WshShell.SendKeys('{F5}');
        // IsRefreshedOnCurr:=true;
    end;
}

