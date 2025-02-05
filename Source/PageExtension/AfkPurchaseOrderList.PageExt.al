pageextension 50107 "Afk Purchase Order List" extends "Purchase Order List"
{
    layout
    {
        addafter("Buy-from Vendor Name")
        {
            field("Order Date"; Rec."Order Date") { ApplicationArea = all; }
            field("Code Demande"; Rec."Code Demande") { ApplicationArea = all; }
            field("Quote No."; Rec."Quote No.") { ApplicationArea = all; }
            field("Observations"; Rec.Observations) { ApplicationArea = all; }
            field("User ID"; Rec."User ID") { ApplicationArea = all; }
            field("Printed"; Rec.Printed) { ApplicationArea = all; }
            field("Printed Date"; Rec."Printed Date") { ApplicationArea = all; }
            field("Printed By"; Rec."Printed By") { ApplicationArea = all; }
            field("Derogation"; Rec.Derogation) { ApplicationArea = all; }
        }
    }
    var
        ReqMgt: Codeunit "Purchase Requisition Mgt";
        UserSetup: Record "User Setup";

    trigger OnOpenPage()
    var
    //PurchasesPayablesSetup: Record 312;
    begin
        UserSetup.GET(USERID);
        if not UserSetup."Enlever Filtre Commande Achat" then begin
            Rec.FILTERGROUP(2);
            Rec.SETFILTER(Rec."PO Type", '%1', ReqMgt.GetFiltreTypeCommandeAchat);
            Rec.FILTERGROUP(0);
        end;

        if not UserSetup."Enlever Filtre Demande Achat" then begin
            Rec.FILTERGROUP(2);
            Rec.SETFILTER(Rec."PR Type", '%1', ReqMgt.GetFiltreTypeDemandeAchat);
            Rec.FILTERGROUP(0);
        end;
    end;
}
