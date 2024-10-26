page 50006 "Delivery Order Subform"
{
    AutoSplitKey = true;
    Caption = 'Lines';
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = pro_detailBL;

    layout
    {
        area(content)
        {
            repeater(Control1000000001)
            {
                ShowCaption = false;
                field(NavItemCode; Rec.NavItemCode)
                {
                    Editable = IsNotFromDispaching;
                }
                field("Item Name"; Rec."Item Name")
                {
                }
                field(volumealivrer; Rec.volumealivrer)
                {
                    Editable = IsNotFromDispaching;
                }
                field(volumelivre; Rec.volumelivre)
                {
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    Editable = IsNotFromDispaching;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    begin
        if EnteteBL.Get(Rec.numBL) then
            IsNotFromDispaching := (EnteteBL.Source = EnteteBL.Source::" ");

        if SalesOrder.Get(SalesOrder."Document Type"::Order, EnteteBL.NavOrderNo) then
            if Cust1.Get(SalesOrder."Sell-to Customer No.") then                //***
                if Cust1."Appliquer Ecart pompe JIR" then
                    IsNotFromDispaching := true;
    end;

    var
        IsNotFromDispaching: Boolean;
        EnteteBL: Record pro_enteteBL;
        SalesOrder: Record "Sales Header";
        Cust1: Record Customer;
}

