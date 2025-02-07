codeunit 50039 "Afk FrontDeskValidation Mgt"
{
    Permissions = tabledata "Afk SalesOrder Unblocking" = rmi;
    procedure CreateDdeDeblocage(SalesOrder: record "Sales Header")
    var
        DdeDeblocage: Record "Afk SalesOrder Unblocking";
        Cust: record Customer;
        LblDde: label 'Demande de déblocage commande %1';
    begin
        DdeDeblocage.Init();
        DdeDeblocage."No." := SalesOrder."No.";
        Cust.Get(SalesOrder."Sell-to Customer No.");

        DdeDeblocage."Customer No." := SalesOrder."Sell-to Customer No.";
        DdeDeblocage.Object := StrSubstNo(LblDde, SalesOrder."No.");
        DdeDeblocage."Approval Status" := DdeDeblocage."Approval Status"::"Attente validation CCredit";
        DdeDeblocage."Credit Limit (LCY)" := Cust."Credit Limit (LCY)";
        DdeDeblocage."Risk Level" := Cust."Risk Level";
        DdeDeblocage."Payment Terms Code" := Cust."Payment Terms Code";
        //DdeDeblocage.Insert();
    end;

    procedure ModifyBlockingStatus(var Request: Record "Afk SalesOrder Unblocking"; WebUser: Text; NewStatus: Enum "Afk CRM Approval Status"): Code[20]
    var
        SalesOrder: Record "Sales Header";
        SalesProcessMgt: Codeunit "Sales Order Process";
        ErrDocNonTraite: Label 'The document is still in draft';
    begin
        Request."Approval Status" := NewStatus;
        Request."Modified By" := CopyStr(WebUser, 1, 50);
        Request.Modify();

        if (Request."Approval Status" = Request."Approval Status"::"Validé") then
            if (SalesOrder.get(SalesOrder."Document Type"::Order, Request."No.")) then
                SalesProcessMgt.ValidationDeblocage(SalesOrder);

        exit(Request."No.");
    end;
}
