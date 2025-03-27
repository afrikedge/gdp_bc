page 50329 "Touring Card"
{
    Editable = true;
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = Touring;
    Caption = 'Tournée';

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
                SubPageLink = idtournee = FIELD(IdTouring), isAnnule = const(false);
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
                //Visible = IsEditable;
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
                    Message(Text039);
                end;
            }

        }
    }


    trigger OnAfterGetCurrRecord()
    begin
        // if not IsRefreshedOnCurr then
        //     Refresh;
    end;

    trigger OnOpenPage()
    begin
        // if not IsRefreshedOnCurr then
        //     Refresh;
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
        Text039: Label 'Le document n''a pas d''erreurs et peut être dispaché';
        CanPrintDocuments: Boolean;
}

