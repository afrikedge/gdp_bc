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
        DdeDeblocage.Name := Cust.Name;
        DdeDeblocage.Object := StrSubstNo(LblDde, SalesOrder."No.");
        DdeDeblocage."Approval Status" := DdeDeblocage."Approval Status"::"Attente validation CCredit";
        DdeDeblocage."Credit Limit (LCY)" := Cust."Credit Limit (LCY)";
        DdeDeblocage."Risk Level" := Cust."Risk Level";
        DdeDeblocage."Payment Terms Code" := Cust."Payment Terms Code";
        DdeDeblocage.Insert();
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

    //{"inputJson":"{\"Parameter\":\"SOUnblocking_updateApprovalFlow\",\"webUserName\":\"GERALD\",\"Approval Status\":7,
    //\"ApprovalFlow\":[{\"Record Type\":2,\"Record No_\":\"469658\",\"Sequence No_\":1,\"Approval Mode\":0,
    //\"Approved On\":\"2025-02-02T13:21:35.542Z\",\"Approved by\":\"GERALD\",\"Approved as\":\"GERALD\",
    //\"Actual Status\":5,\"Next Status\":7,\"Comments\":\"rien à signaler\"}]}"}
    procedure Run_ModifyBlockingStatus(input: JsonObject): Text
    var
        Request: Record "Afk SalesOrder Unblocking";
        c: JsonToken;
        LinesArray: JsonArray;
        LineInput: JsonObject;
    begin
        input.Get('ApprovalFlow', c);
        LinesArray := c.AsArray();
        foreach c in LinesArray do begin
            LineInput := c.AsObject();
            exit(AddApprovalFlow(LineInput));
        end;
    end;

    local procedure AddApprovalFlow(input: JsonObject): Text
    var
        ApprovalFlow: Record "Afk Approval Flow";
        DdeDeblocage: Record "Afk SalesOrder Unblocking";
    begin

        ApprovalFlow.Init();
        ApprovalFlow.Validate("Record Type", ws.GetInt('Record Type', input));
        ApprovalFlow."Record No." := ws.GetText('Record No_', input);
        ApprovalFlow."Sequence No." := ws.GetInt('Sequence No_', input);
        ApprovalFlow.Validate("Approval Mode", ws.GetInt('Approval Mode', input));
        ApprovalFlow."Approved On" := ws.GetDate('Approved On', input);
        ApprovalFlow."Approved by" := ws.GetText('Approved by', input);
        ApprovalFlow."Approved as" := ws.GetText('Approved as', input);
        ApprovalFlow.Validate("Actual Status", ws.GetInt('Actual Status', input));
        ApprovalFlow.Validate("Next Status", ws.GetInt('Next Status', input));
        ApprovalFlow.Comments := ws.GetText('Comments', input);
        ApprovalFlow.Insert();

        DdeDeblocage.Get(ApprovalFlow."Record No.");
        ModifyBlockingStatus(DdeDeblocage, ApprovalFlow."Approved by", ApprovalFlow."Next Status");

        exit(Ws.CreateResponseSuccess(DdeDeblocage."No."));

    end;

    var
        WS: codeunit "Afk Api Mgt";
}
