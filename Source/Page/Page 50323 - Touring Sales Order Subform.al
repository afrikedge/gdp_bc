page 50323 "Touring Sales Order Subform"
{
    AutoSplitKey = false;
    DelayedInsert = true;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Touring Sales Order";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(IdTouring; Rec.IdTouring)
                {
                    Visible = false;
                }
                field("Order No"; Rec."Order No")
                {

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        SalesH: Record "Sales Header";
                        TouringSalesOrder: Record "Touring Sales Order";
                        ExistingOrderFilter: Text;
                    begin

                        TouringH.Get(Rec.IdTouring);
                        TouringH.TestField("Location Code");

                        SalesH.Reset;
                        SalesH.FilterGroup(2);
                        SalesH.SetRange(SalesH."Document Type", SalesH."Document Type"::Order);
                        SalesH.SetFilter("Delivery Status", '%1|%2|%3', SalesH."Delivery Status"::AttenteLivraison
                          , SalesH."Delivery Status"::PartiellementLivree, SalesH."Delivery Status"::PartiellementFacturee);
                        SalesH.SetRange(SalesH."Location Code", TouringH."Location Code");
                        SalesH.SetRange(SalesH."Shipment Method Code", 'TRP');
                        SalesH.SetFilter("Dispatching Status", '%1|%2|%3', SalesH."Dispatching Status"::None
                          , SalesH."Dispatching Status"::NonTraite, SalesH."Dispatching Status"::Reliquat);

                        TouringSalesOrder.Reset;
                        TouringSalesOrder.SetRange(TouringSalesOrder.IdTouring, Rec.IdTouring);
                        if TouringSalesOrder.FindSet then
                            repeat
                                if ExistingOrderFilter = '' then
                                    ExistingOrderFilter := '<>' + TouringSalesOrder."Order No"
                                else
                                    ExistingOrderFilter := ExistingOrderFilter + '&<>' + TouringSalesOrder."Order No";
                            until TouringSalesOrder.Next = 0;
                        SalesH.SetFilter(SalesH."No.", ExistingOrderFilter);
                        SalesH.FilterGroup(0);


                        SalesH.SetRange(SalesH."Requested Delivery Date", Today, CalcDate('<+1D>', Today));


                        /*
                        IF SalesH.FINDSET THEN
                        REPEAT
                          SalesH.MARK(TRUE);
                        UNTIL SalesH.NEXT=0;
                        SalesH.MARKEDONLY(TRUE);*/

                        if PAGE.RunModal(45, SalesH) = ACTION::LookupOK then begin
                            Rec."Order No" := SalesH."No.";
                            Rec.Validate("Order No");
                        end;

                    end;

                    trigger OnValidate()
                    var
                        SalesH: Record "Sales Header";
                    begin
                    end;
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                }
                field("Ship-to Code"; Rec."Ship-to Code")
                {
                }
                field("Requested Delivery Date"; Rec."Requested Delivery Date")
                {
                }
                field("Responsibility Center"; Rec."Responsibility Center")
                {
                }
                field(Pompe; Rec.Pompe)
                {
                }
                field(GO; Rec.GO)
                {

                    trigger OnValidate()
                    begin
                        UpdatesTotals;
                    end;
                }
                field(PL; Rec.PL)
                {

                    trigger OnValidate()
                    begin
                        UpdatesTotals;
                    end;
                }
                field(SC; Rec.SC)
                {

                    trigger OnValidate()
                    begin
                        UpdatesTotals;
                    end;
                }
                field(FO; Rec.FO)
                {

                    trigger OnValidate()
                    begin
                        UpdatesTotals;
                    end;
                }
                field(Total; Rec.Total)
                {
                }
            }
            group(Control1000000014)
            {
                ShowCaption = false;
                field(TotalGO; TotalGO)
                {
                    BlankZero = true;
                    Caption = 'Total GO';
                    Editable = false;
                }
                field(TotalPL; TotalPL)
                {
                    BlankZero = true;
                    Caption = 'Total PL';
                    Editable = false;
                }
                field(TotalSC; TotalSC)
                {
                    BlankZero = true;
                    Caption = 'Total SC';
                    Editable = false;
                }
                field(TotalFO; TotalFO)
                {
                    BlankZero = true;
                    Caption = 'Total FO';
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        UpdatesTotals;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        UpdatesTotals;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        UpdatesTotals;
    end;

    var
        TouringH: Record Touring;
        TotalGO: Decimal;
        TotalPL: Decimal;
        TotalSC: Decimal;
        TotalFO: Decimal;
        GOIsVisible: Boolean;
        PLIsVisible: Boolean;
        SCIsVisible: Boolean;
        FOIsVisible: Boolean;
        Error01: Label 'La commande %1 a déjà été traitée';
        Error02: Label 'La commande ne peut pas être traitée dans cette tournée';

    local procedure UpdatesTotals()
    var
        TouringH: Record Touring;
    begin
        if TouringH.Get(Rec.IdTouring) then begin
            TouringH.CalcFields(TotalFO);
            TotalFO := TouringH.TotalFO;

            TouringH.CalcFields(TotalGO);
            TotalGO := TouringH.TotalGO;

            TouringH.CalcFields(TotalSC);
            TotalSC := TouringH.TotalSC;

            TouringH.CalcFields(TotalPL);
            TotalPL := TouringH.TotalPL;

            GOIsVisible := TotalGO > 0;
            PLIsVisible := TotalPL > 0;
            SCIsVisible := TotalSC > 0;
            FOIsVisible := TotalFO > 0;

        end;
    end;
}

