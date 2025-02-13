codeunit 50039 "Afk FrontDeskValidation Mgt"
{
    Permissions = tabledata "Afk SalesOrder Unblocking" = rmi;


    procedure RunCustRevision(input: JsonObject; IsDeletion: Boolean): Text
    var
        NoQuote: text;
    begin
        NoQuote := ws.GetText('No_', input);
        if (NoQuote <> '') then begin

            if (IsDeletion) then
                exit(DeleteCustRevision(NoQuote))
            else
                exit(ModifyCustRevision(NoQuote, input))

        end else
            exit(AddCustRevision(input));
    end;

    procedure RunLeads(input: JsonObject; IsDeletion: Boolean): Text
    var
        NoQuote: text;
    begin
        NoQuote := ws.GetText('No_', input);
        if (NoQuote <> '') then begin

            if (IsDeletion) then
                exit(DeleteContact(NoQuote))
            else
                exit(ModifyLead(NoQuote, input))

        end else
            exit(AddLead(input));
    end;

    procedure RunContacts(input: JsonObject; IsDeletion: Boolean): Text
    var
        NoQuote: text;
    begin
        NoQuote := ws.GetText('No_', input);
        if (NoQuote <> '') then begin

            if (IsDeletion) then
                exit(DeleteContact(NoQuote))
            else
                exit(ModifyContact(NoQuote, input))

        end else
            exit(AddContact(input));
    end;

    procedure RunShipToAddress(input: JsonObject; IsDeletion: Boolean): Text
    var
        NoQuote: text;
        CustNo: text;
    begin
        CustNo := ws.GetText('Customer No_', input);
        NoQuote := ws.GetText('Code', input);
        if (NoQuote <> '') then begin

            if (IsDeletion) then
                exit(DeleteShipToAddress(CustNo, NoQuote))
            else
                exit(ModifyShipToAddress(CustNo, NoQuote, input))

        end else
            exit(AddShipToAddress(CustNo, input));
    end;

    procedure RunCustomers(input: JsonObject; IsDeletion: Boolean): Text
    var
        NoQuote: text;
    begin
        NoQuote := ws.GetText('No_', input);
        if (NoQuote <> '') then begin

            // if (IsDeletion) then
            //     exit(DeleteShipToAddress(NoQuote))
            // else
            exit(ModifyCustomer(NoQuote, input))

            // end else
            //     exit(AddShipToAddress(input));
        end;
    end;

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

    procedure Run_ModifyBlockingStatus(input: JsonObject): Text
    var
        c: JsonToken;
        LinesArray: JsonArray;
        LineInput: JsonObject;
    begin

        SetOrderIfValidated(input);

        input.Get('ApprovalFlow', c);
        LinesArray := c.AsArray();
        foreach c in LinesArray do begin
            LineInput := c.AsObject();
            exit(SetDdeDeblocageStatus(LineInput));
        end;
    end;

    procedure RunLinkDocument(input: JsonObject; IsDeletion: Boolean): Text
    var
    begin
        //RecNo := ws.GetText('No_', input);
        //CustNo := ws.GetText('Customer No_', input);
        //if (RecNo <> '') then begin
        if (IsDeletion) then
            exit(DeleteLinkDocument(input))
        else
            exit(AddLinkDocument(input));

        // end else
        //     exit(AddLinkDocument(CustNo, input));
    end;

    procedure Run_ModifyLeadStatus(input: JsonObject): Text
    var
        c: JsonToken;
        LinesArray: JsonArray;
        LineInput: JsonObject;
    begin

        ModifyLeadStatusAndConvertCustomer(input);

        input.Get('ApprovalFlow', c);
        LinesArray := c.AsArray();
        foreach c in LinesArray do begin
            LineInput := c.AsObject();
            exit(SetLeadStatus(LineInput));
        end;
    end;

    procedure Run_ModifyCustRevisionStatus(input: JsonObject): Text
    var

        c: JsonToken;
        LinesArray: JsonArray;
        LineInput: JsonObject;
    begin


        SetCustomerIfRrevisionIsValidated(input);


        input.Get('ApprovalFlow', c);
        LinesArray := c.AsArray();
        foreach c in LinesArray do begin
            LineInput := c.AsObject();
            exit(SetDdeRevision_InsertApprovalFlow(LineInput));
        end;

        exit(Ws.CreateResponseSuccess(''));
    end;

    local procedure SetDdeDeblocageStatus(input: JsonObject): Text
    var
        ApprovalFlow: Record "Afk Approval Flow";
        RecRef: RecordRef;
    begin

        ApprovalFlow.Init();

        PopulateValuesApprovalFlow(ApprovalFlow, input);

        ApprovalFlow.Insert();



    end;

    local procedure ModifyBlockingStatus(var Request: Record "Afk SalesOrder Unblocking"; WebUser: Text; NewStatus: Enum "Afk CRM Approval Status"): Code[20]
    var
        SalesOrder: Record "Sales Header";
        SalesProcessMgt: Codeunit "Sales Order Process";
        ErrDocNonTraite: Label 'The document is still in draft';
    begin

    end;

    local procedure SetDdeRevision_InsertApprovalFlow(input: JsonObject): Text
    var
        ApprovalFlow: Record "Afk Approval Flow";
        CustRevision: Record "Afk Customer Revision";
        RecRef: RecordRef;
    begin

        ApprovalFlow.Init();

        PopulateValuesApprovalFlow(ApprovalFlow, input);

        ApprovalFlow.Insert();

        //exit(Ws.CreateResponseSuccess(CustRevision."No."));

    end;

    local procedure SetLeadStatus(input: JsonObject): Text
    var
        ApprovalFlow: Record "Afk Approval Flow";
        Lead: Record "Contact";
    //RecRef: RecordRef;
    begin



        ApprovalFlow.Init();

        PopulateValuesApprovalFlow(ApprovalFlow, input);

        ApprovalFlow.Insert();



        exit(Ws.CreateResponseSuccess(Lead."No."));

    end;

    local procedure ConvertLeadToCustomer(LeadNo: Code[20]; CustTemplateCode: Code[20]): Code[20]
    var
        Cont: record Contact;
    begin
        Cont.get(LeadNo);
        exit(Cont.CreateCustomerFromTemplate(CustTemplateCode));
    end;

    procedure RunUpdatePassword(input: JsonObject): Text
    var
        SecMgt: codeunit "Security Mgt";
        NewPassWd: Text;
        webUserName: Code[50];
    begin
        webUserName := Copystr(ws.GetText('webUserName', input), 1, 50);
        NewPassWd := ws.GetText('Password', input);
        SecMgt.CreateNewPassword(webUserName, NewPassWd, false);
    end;

    local procedure DeleteCustRevision(OrderNo: Text): Text
    var
        CustRevision: Record "Afk Customer Revision";
    begin
        CustRevision.Get(OrderNo);

        CustRevision.Delete(true);

        exit(Ws.CreateResponseSuccess(CustRevision."No."));
    end;

    local procedure DeleteContact(RecNo: Text): Text
    var
        Contact: Record contact;
    begin
        Contact.Get(RecNo);

        Contact.Delete(true);

        exit(Ws.CreateResponseSuccess(Contact."No."));
    end;

    local procedure DeleteShipToAddress(CustNo: Code[20]; Code: Text): Text
    var
        ShipAdr: Record "Ship-to Address";
    begin
        ShipAdr.Get(CustNo, Code);

        ShipAdr.Delete(true);

        exit(Ws.CreateResponseSuccess(ShipAdr.Code));
    end;

    local procedure ModifyCustRevision(OrderNo: Text; input: JsonObject): Text
    var
        CustRevision: Record "Afk Customer Revision";
    begin

        CustRevision.Get(OrderNo);

        ProcessCustRevisionHeader(CustRevision, input);

        //processApprovalFlows("Afk Record Type"::"Révision compte", CustRevision."No.", input);

        exit(Ws.CreateResponseSuccess(CustRevision."No."));

    end;

    local procedure ModifyLead(OrderNo: Text; input: JsonObject): Text
    var
        Lead: Record Contact;
    begin

        Lead.Get(OrderNo);

        PopulateValuesLead(Lead, input);
        Lead.Modify(true);

        processCustRequirements(Lead."No.", input, true);

        exit(Ws.CreateResponseSuccess(Lead."No."));

    end;

    local procedure ModifyCustomer(OrderNo: Text; input: JsonObject): Text
    var
        Cust: Record Customer;
    begin

        Cust.Get(OrderNo);

        PopulateValuesCustomer(Cust, input);
        Cust.Modify(true);

        processCustRequirements(Cust."No.", input, false);

        exit(Ws.CreateResponseSuccess(Cust."No."));

    end;

    local procedure AddLead(input: JsonObject): Text
    var
        Lead: Record Contact;
        AddOnSetup: Record "AddOn Setup2";
        ApprovalFlow: record "Afk Approval Flow";
        SalesQuoteLine: Record "Sales Line";
    begin

        Lead.Init();

        AddOnSetup.Get();
        AddOnSetup.TestField("Lead Nos Series");
        Lead."No." := NoSeriesMgt.GetNextNo(AddOnSetup."Lead Nos Series", Today, true);

        Lead.Insert(true);

        PopulateValuesLead(Lead, input);
        Lead.Modify(true);

        processCustRequirements(Lead."No.", input, true);

        exit(Ws.CreateResponseSuccess(Lead."No."));

    end;

    local procedure ModifyContact(OrderNo: Text; input: JsonObject): Text
    var
        Cont: Record Contact;
    begin

        Cont.Get(OrderNo);

        PopulateValuesContact(Cont, input);
        Cont.Modify(true);

        //processCustRequirements(Cont."No.", input, true);

        exit(Ws.CreateResponseSuccess(Cont."No."));

    end;

    local procedure AddContact(input: JsonObject): Text
    var
        Cont: Record Contact;
    begin

        Cont.Init();
        Cont."No." := '';

        Cont.Insert(true);

        PopulateValuesContact(Cont, input);
        Cont.Modify(true);

        //processCustRequirements(Cont."No.", input, true);

        exit(Ws.CreateResponseSuccess(Cont."No."));

    end;

    local procedure ModifyShipToAddress(CustNo: Code[20]; Code: Text; input: JsonObject): Text
    var
        Rec: Record "Ship-to Address";
    begin

        Rec.Get(CustNo, Code);

        PopulateValuesShippingAddress(Rec, input);
        Rec.Modify(true);

        exit(Ws.CreateResponseSuccess(Rec.Code));

    end;

    local procedure AddShipToAddress(CustNo: Code[20]; input: JsonObject): Text
    var
        ShipToAdr: Record "Ship-to Address";
    begin

        ShipToAdr.Init();
        ShipToAdr."Customer No." := CustNo;
        ShipToAdr.Code := GenerateShipToCode(CustNo);

        ShipToAdr.Insert(true);

        PopulateValuesShippingAddress(ShipToAdr, input);
        ShipToAdr.Modify(true);

        exit(Ws.CreateResponseSuccess(ShipToAdr.Code));

    end;

    local procedure AddCustRevision(input: JsonObject): Text
    var
        CustRevision: Record "Afk Customer Revision";
        ApprovalFlow: record "Afk Approval Flow";
        SalesQuoteLine: Record "Sales Line";
    begin

        CustRevision.Init();
        CustRevision."No." := '';

        CustRevision.Insert(true);

        ProcessCustRevisionHeader(CustRevision, input);
        CustRevision.Modify(true);

        //processApprovalFlows("Afk Record Type"::"Révision compte", CustRevision."No.", input);

        exit(Ws.CreateResponseSuccess(CustRevision."No."));

    end;

    local procedure ProcessCustRevisionHeader(var CustRevision: Record "Afk Customer Revision"; input: JsonObject)
    var
        //Cust: record Customer;
        RecRef: RecordRef;
    begin

        RecRef.GetTable(CustRevision);

        WS.ValidateField(RecRef, CustRevision.FieldNo(CustRevision."Created By"), input, 'webUserName');
        WS.ValidateField(RecRef, CustRevision.FieldNo("Customer No."), input, 'Customer No_');
        WS.ValidateField(RecRef, CustRevision.FieldNo(CustRevision.Name), input, 'Name');
        WS.ValidateField(RecRef, CustRevision.FieldNo(CustRevision."Parent Account No."), input, 'Parent Account No_');
        WS.ValidateField(RecRef, CustRevision.FieldNo(CustRevision."Sales Category Code"), input, 'Sales Category Code');
        WS.ValidateField(RecRef, CustRevision.FieldNo(CustRevision."Approval Status"), input, 'Approval Status');
        WS.ValidateField(RecRef, CustRevision.FieldNo(CustRevision."Payment Terms Code"), input, 'Payment Terms Code');
        WS.ValidateField(RecRef, CustRevision.FieldNo(CustRevision."New Payment Terms Code"), input, 'New Payment Terms Code');
        WS.ValidateField(RecRef, CustRevision.FieldNo(CustRevision."Revised Payment Terms Code"), input, 'Revised Payment Terms Code');
        WS.ValidateField(RecRef, CustRevision.FieldNo(CustRevision."Approved Payment Terms Code"), input, 'Approved Payment Terms Code');
        WS.ValidateField(RecRef, CustRevision.FieldNo(CustRevision."Credit limit (LCY)"), input, 'Credit Limit (LCY)');
        WS.ValidateField(RecRef, CustRevision.FieldNo(CustRevision."Revised Credit limit (LCY)"), input, 'Revised Credit limit (LCY)');
        WS.ValidateField(RecRef, CustRevision.FieldNo(CustRevision."Approved Credit limit (LCY)"), input, 'Approved Credit limit (LCY)');
        WS.ValidateField(RecRef, CustRevision.FieldNo(CustRevision."Risk Level"), input, 'Risk Level');
        WS.ValidateField(RecRef, CustRevision.FieldNo(CustRevision."New Risk Level"), input, 'New Risk Level');
        WS.ValidateField(RecRef, CustRevision.FieldNo(CustRevision."Revised Risk Level"), input, 'Revised Risk Level');
        WS.ValidateField(RecRef, CustRevision.FieldNo(CustRevision."Approved Risk Level"), input, 'Approved Risk Level');
        WS.ValidateField(RecRef, CustRevision.FieldNo(CustRevision."Revised Payment Method"), input, 'Revised Payment Method');
        WS.ValidateField(RecRef, CustRevision.FieldNo(CustRevision."Approved Payment Method"), input, 'Approved Payment Method');
        WS.ValidateField(RecRef, CustRevision.FieldNo(CustRevision."Cash payment"), input, 'Cash payment');
        WS.ValidateField(RecRef, CustRevision.FieldNo(CustRevision."Check Set"), input, 'Check Set');
        WS.ValidateField(RecRef, CustRevision.FieldNo(CustRevision."Bank Transfer Bank Stamp"), input, 'Bank Transfer Bank Stamp');
        WS.ValidateField(RecRef, CustRevision.FieldNo(CustRevision.Traite), input, 'Traite');
        WS.ValidateField(RecRef, CustRevision.FieldNo(CustRevision."Mobile Banking"), input, 'Mobile Banking');
        WS.ValidateField(RecRef, CustRevision.FieldNo(CustRevision."New Cash payment"), input, 'New Cash payment');
        WS.ValidateField(RecRef, CustRevision.FieldNo(CustRevision."New Check Set"), input, 'New Check Set');
        WS.ValidateField(RecRef, CustRevision.FieldNo(CustRevision."New Bank Transfer Bank Stamp"), input, 'New Bank Transfer Bank Stamp');
        WS.ValidateField(RecRef, CustRevision.FieldNo(CustRevision."New Traite"), input, 'New Traite');
        WS.ValidateField(RecRef, CustRevision.FieldNo(CustRevision."New Received Check"), input, 'New Received Check');
        WS.ValidateField(RecRef, CustRevision.FieldNo(CustRevision."New Credit Note"), input, 'New Credit Note');
        WS.ValidateField(RecRef, CustRevision.FieldNo(CustRevision."New Automatic Debit"), input, 'New Automatic Debit');
        WS.ValidateField(RecRef, CustRevision.FieldNo(CustRevision."New Mobile Banking"), input, 'New Mobile Banking');
        WS.ValidateField(RecRef, CustRevision.FieldNo(CustRevision."New Credit limit (LCY)"), input, 'New Credit limit (LCY)');
        WS.ValidateField(RecRef, CustRevision.FieldNo(CustRevision.Object), input, 'Object');

        //WS.ValidateField(RecRef, CustRevision.FieldNo(CustRevision.ve), input, 'Salesperson Code');

        RecRef.SetTable(CustRevision);
    end;

    // local procedure processApprovalFlows(RecordType: enum "Afk Record Type"; RecordNo: Code[20]; input: JsonObject)
    // var
    //     ApprovalFlow: record "Afk Approval Flow";
    //     c: JsonToken;
    //     LinesArray: JsonArray;
    //     LineInput: JsonObject;
    // begin

    //     ApprovalFlow.Reset();
    //     ApprovalFlow.SetRange("Record Type", RecordType);
    //     ApprovalFlow.SetRange("Record No.", RecordNo);
    //     if (not ApprovalFlow.IsEmpty) then
    //         ApprovalFlow.DeleteAll();

    //     input.Get('ApprovalFlow', c);
    //     LinesArray := c.AsArray();
    //     foreach c in LinesArray do begin
    //         LineInput := c.AsObject();
    //         ApprovalFlow.Init();
    //         PopulateValuesApprovalFlow(ApprovalFlow, LineInput);
    //         ApprovalFlow.Insert();
    //     end;
    // end;

    local procedure processCustRequirements(RecNo: Code[20]; input: JsonObject; IsLead: Boolean)
    var
        Requirement: record "Afk Customer Requirement";
        c: JsonToken;
        LinesArray: JsonArray;
        LineInput: JsonObject;
    begin

        if (IsLead) then begin
            Requirement.SetRange("Account Type", Requirement."Account Type"::Prospect);
            Requirement.SetRange("Lead No.", RecNo);
            if (not Requirement.IsEmpty) then
                Requirement.DeleteAll();
        end else begin
            Requirement.SetRange("Account Type", Requirement."Account Type"::Client);
            Requirement.SetRange("Customer No.", RecNo);
            if (not Requirement.IsEmpty) then
                Requirement.DeleteAll();
        end;


        input.Get('CustomerRequirement', c);
        LinesArray := c.AsArray();
        foreach c in LinesArray do begin
            LineInput := c.AsObject();
            Requirement.Init();
            PopulateValuesCustRequirement(Requirement, LineInput);
            Requirement.Insert();
        end;
    end;

    local procedure PopulateValuesApprovalFlow(var ApprovalFlow: record "Afk Approval Flow"; input: JsonObject)
    var
        RecRef: RecordRef;
    begin

        RecRef.GetTable(ApprovalFlow);

        WS.ValidateField(RecRef, ApprovalFlow.FieldNo(ApprovalFlow."Record Type"), input, 'Record Type');
        WS.ValidateField(RecRef, ApprovalFlow.FieldNo(ApprovalFlow."Record No."), input, 'Record No_');
        WS.ValidateField(RecRef, ApprovalFlow.FieldNo(ApprovalFlow."Sequence No."), input, 'Sequence No_');
        WS.ValidateField(RecRef, ApprovalFlow.FieldNo(ApprovalFlow."Approval Mode"), input, 'Approval Mode');
        WS.ValidateField(RecRef, ApprovalFlow.FieldNo(ApprovalFlow."Approved On"), input, 'Approved On');
        WS.ValidateField(RecRef, ApprovalFlow.FieldNo(ApprovalFlow."Approved by"), input, 'Approved by');
        WS.ValidateField(RecRef, ApprovalFlow.FieldNo(ApprovalFlow."Approved as"), input, 'Approved as');
        WS.ValidateField(RecRef, ApprovalFlow.FieldNo(ApprovalFlow."Actual Status"), input, 'Actual Status');
        WS.ValidateField(RecRef, ApprovalFlow.FieldNo(ApprovalFlow."Next Status"), input, 'Next Status');
        WS.ValidateField(RecRef, ApprovalFlow.FieldNo(ApprovalFlow.Comments), input, 'Comments');

        RecRef.SetTable(ApprovalFlow);
    end;

    // local procedure PopulateValuesApprovalFlow(var ApprovalFlow: record "Afk Approval Flow";)
    // var
    //     RecRef: RecordRef;
    //     field: record Field;
    //     fieldRef: FieldRef;
    // begin

    //     RecRef.GetTable(ApprovalFlow);
    //     field.Get(RecRef.Number, 10);
    //     fieldRef := RecRef.field(field."No.");

    //     fieldRef.Validate('comments');

    // end;

    //\"CustomerRequirement\":[{\"Account Type\":0,\"Customer No_\":\"C00001\",\"Lead No_\":\"L00001\",
    //\"Criteria\":\"Criteria01\",\"Criteria Description\":\"Criteria01 Description\",\"Value Type\":0,
    //\"List Value\":\"Criteria value1\",\"Numeric Value\":1000,\"Alpha Value\":\"Alpha Value\",
    //\"Date Value\":\"1753-01-01T00:00:000z\",\"Validity\":0,\"Validity Date\":\"1753-01-01T00:00:000z\",
    //\"Document required\":true,\"Document Link\":\"\",\"Updated on\":\"1753-01-01T00:00:000z\",\"Updated by\":\"GERALD\"}],
    local procedure PopulateValuesCustRequirement(var CustRequirement: record "Afk Customer Requirement"; input: JsonObject)
    var
        RecRef: RecordRef;
    begin

        RecRef.GetTable(CustRequirement);

        WS.ValidateField(RecRef, CustRequirement.FieldNo(CustRequirement."Account Type"), input, 'Account Type');
        WS.ValidateField(RecRef, CustRequirement.FieldNo(CustRequirement."Customer No."), input, 'Customer No_');
        WS.ValidateField(RecRef, CustRequirement.FieldNo(CustRequirement."Lead No."), input, 'Lead No_');
        WS.ValidateField(RecRef, CustRequirement.FieldNo(CustRequirement.Criteria), input, 'Criteria');
        WS.ValidateField(RecRef, CustRequirement.FieldNo(CustRequirement."Criteria Description"), input, 'Criteria Description');
        WS.ValidateField(RecRef, CustRequirement.FieldNo(CustRequirement."Value Type"), input, 'Value Type');
        WS.ValidateField(RecRef, CustRequirement.FieldNo(CustRequirement."List Value"), input, 'List Value');
        WS.ValidateField(RecRef, CustRequirement.FieldNo(CustRequirement."Numeric Value"), input, 'Numeric Value');
        WS.ValidateField(RecRef, CustRequirement.FieldNo(CustRequirement."Alpha Value"), input, 'Alpha Value');
        WS.ValidateField(RecRef, CustRequirement.FieldNo(CustRequirement.Validity), input, 'Validity');
        WS.ValidateField(RecRef, CustRequirement.FieldNo(CustRequirement."Validity Date"), input, 'Validity Date');
        WS.ValidateField(RecRef, CustRequirement.FieldNo(CustRequirement."Document required"), input, 'Document required');
        WS.ValidateField(RecRef, CustRequirement.FieldNo(CustRequirement."Document Link"), input, 'Document Link');
        WS.ValidateField(RecRef, CustRequirement.FieldNo(CustRequirement."Updated on"), input, 'Updated on');
        WS.ValidateField(RecRef, CustRequirement.FieldNo(CustRequirement."Updated by"), input, 'Updated by');

        RecRef.SetTable(CustRequirement);
    end;

    //{"inputJson":"{\"Parameter\":\"shipToAddress_insert\",\"webUserName\":\"GERALD\",\"Customer No_\":\"C000,
    //\"Name\":\"adresse de gerald\",\"Address\":\"antanana\",\"Address 2\":\"ivandry\",\"City\":\"tana\",
    //\"Post Code\":\"452\",\"Phone No_\":\"4644654\",\"E-Mail\":\"gerald@gmail.com\",\"Location Code\":\"AJE\",
    //\"Responsibility Center\":\"AN\"}"}
    local procedure PopulateValuesShippingAddress(var ShipToCode: record "Ship-to Address"; input: JsonObject)
    var
        RecRef: RecordRef;
    begin

        RecRef.GetTable(ShipToCode);


        WS.ValidateField(RecRef, ShipToCode.FieldNo(ShipToCode."Afk Modified By"), input, 'webUserName');
        //WS.ValidateField(RecRef, ShipToCode.FieldNo(ShipToCode."Customer No."), input, 'Customer No_');
        WS.ValidateField(RecRef, ShipToCode.FieldNo(ShipToCode.Name), input, 'Name');
        WS.ValidateField(RecRef, ShipToCode.FieldNo(ShipToCode.Address), input, 'Address');
        WS.ValidateField(RecRef, ShipToCode.FieldNo(ShipToCode."Address 2"), input, 'Address 2');
        WS.ValidateField(RecRef, ShipToCode.FieldNo(ShipToCode.City), input, 'City');
        WS.ValidateField(RecRef, ShipToCode.FieldNo(ShipToCode."Post Code"), input, 'Post Code');
        WS.ValidateField(RecRef, ShipToCode.FieldNo(ShipToCode."Phone No."), input, 'Phone No_');
        WS.ValidateField(RecRef, ShipToCode.FieldNo(ShipToCode."E-Mail"), input, 'E-Mail');
        WS.ValidateField(RecRef, ShipToCode.FieldNo(ShipToCode."Location Code"), input, 'Location Code');
        WS.ValidateField(RecRef, ShipToCode.FieldNo(ShipToCode."Responsibility Center"), input, 'Responsibility Center');

        RecRef.SetTable(ShipToCode);
    end;

    local procedure GenerateShipToCode(CustNo: code[20]): Code[10]
    var
        ShipToCode: record "Ship-to Address";
        nb: Integer;
    begin
        ShipToCode.Reset();
        ShipToCode.SetRange("Customer No.", CustNo);
        nb := ShipToCode.Count();
        // nb += 1;
        if (nb = 0) then
            exit(CustNo)
        else
            exit(CustNo + Format(nb));
    end;

    //{"inputJson":"{\"Parameter\":\"contact_insert\",\"webUserName\":\"GERALD\",\"Customer No_\":\"C000001\",
    //\"Salutation Code\":\"Mrs\",\"First Name\":\"Gérald\",\"Middle Name\":\"OK\",\"Surname\":\"Gérald\",
    //\"Name\":\"Gérald OKALA\",\"Address\":\"Tana\",\"Address 2\":\"ivandry\",\"Post Code\":\"4525\",
    //\"City\":\"Antananarivo\",\"Phone No_\":\"444256666633\",\"Mobile Phone No_\":\"444256666633\",,
    //\"E-Mail\":\"gerald@gmail.com\",\"Job Title\":\"DG\",\"Contact Type\":0,\"Signator\":false}"}//
    local procedure PopulateValuesContact(var Contact: record Contact; input: JsonObject)
    var
        RecRef: RecordRef;
    begin

        RecRef.GetTable(Contact);

        WS.ValidateField(RecRef, Contact.FieldNo(Contact."Afk Modified By"), input, 'webUserName');
        //WS.ValidateField(RecRef, Contact.FieldNo(Contact."Company No."), input, 'Customer No_');
        WS.ValidateField(RecRef, Contact.FieldNo(Contact."Salutation Code"), input, 'Salutation Code');
        WS.ValidateField(RecRef, Contact.FieldNo(Contact."First Name"), input, 'First Name');
        WS.ValidateField(RecRef, Contact.FieldNo(Contact."Middle Name"), input, 'Middle Name');
        WS.ValidateField(RecRef, Contact.FieldNo(Contact.Surname), input, 'Surname');
        WS.ValidateField(RecRef, Contact.FieldNo(Contact.Name), input, 'Name');
        WS.ValidateField(RecRef, Contact.FieldNo(Contact."Post Code"), input, 'Post Code');
        WS.ValidateField(RecRef, Contact.FieldNo(Contact.City), input, 'City');
        WS.ValidateField(RecRef, Contact.FieldNo(Contact."Phone No."), input, 'Phone No_');
        WS.ValidateField(RecRef, Contact.FieldNo(Contact."Mobile Phone No."), input, 'Mobile Phone No_');
        WS.ValidateField(RecRef, Contact.FieldNo(Contact."E-Mail"), input, 'E-Mail');
        WS.ValidateField(RecRef, Contact.FieldNo(Contact."Job Title"), input, 'Job Title');
        WS.ValidateField(RecRef, Contact.FieldNo(Contact."Afk Contact Type"), input, 'Contact Type');
        WS.ValidateField(RecRef, Contact.FieldNo(Contact.Signataire), input, 'Signator');

        WS.ValidateField(RecRef, Contact.FieldNo(Contact."Afk Bill-to Customer No."), input, 'Customer No_');
        WS.ValidateField(RecRef, Contact.FieldNo(Contact.Address), input, 'Address');
        WS.ValidateField(RecRef, Contact.FieldNo(Contact."Address 2"), input, 'Address 2');

        RecRef.SetTable(Contact);
    end;

    //{"inputJson":"{\"Parameter\":\"lead_insert\",\"webUserName\":\"GERALD\",\"Approval Status\":0,\"Name\":\"gerald\",
    //\"Name 2\":\"gerald\",\"Salesperson Code\":\"10011\",\"Legal Status\":\"11\",\"Other Legal Status\":\"\",
    //\"Responsibility Center\":\"AT\",\"Main Industry\":\"SP03\",\"Industry Group\":\"SA006\",\"Customer Level\":0,
    //\"Parent Account Type\":1,\"Parent Account No_\":\"C0000003\",\"Currency Code\":\"MGA\",
    //\"Customer Posting Group\":\"ETR\",\"Customer Price Group\":\"CTN\",\"Gen_ Bus_ Posting Group\":\"MAL\",
    //\"VAT Bus_ Posting Group\":\"SOUTE\",\"Location Code\":\"TN00REC\",\"Ship-to Code\":\"C0000003\",
    //\"Shipment Method Code\":\"ENL\",\"Bill-to Customer No_\":\"C0000002\",\"Address\":\"rue1\",\"Address 2\":\"rue2\",
    //\"Post Code\":\"2566\",\"City\":\"tana\",\"Phone No_\":\"5445646515\",\"Mobile Phone No_\":\"1545151515\",
    //\"E-Mail\":\"gerald.gmail.com\",\"Home Page\":\"gerald.site.com\",\"Primary Contact No_\":\"\",
    //\"Customer Profile\":0,\"Sales Channel\":\"100\",\"Sales Category Code\":\"\",\"Category 1\":0,\"Category 2\":0,
    //\"Description\":\"ras\",\"PNS PBL Terre\":false,\"PNS Soutes\":false,\"PNS Bornage\":false,\"PNS Carte\":false,
    //\"PNS Lubrifiants\":false,\"PNS GPL\":false,\"PNS MVOLA\":false,\"PNS Airtel Money\":false,
    //\"PNS Orange Money\":false,\"PNS SPE\":false,\"PNS ND\":false,\"Payment Terms Code\":\"I15\",
    //\"Credit Limit (LCY)\":50000,\"Risk Level\":\"02\",\"Payment Method Code\":\"ESPECES\",\"Cash payment\":true,
    //\"Check Set\":true,\"Bank Transfer Bank Stamp\":true,\"Traite\":true,\"Received Check\":true,
    //\"Credit Note\":true,\"Automatic Debit\":true,\"Mobile Banking\":true,\"Reminder Terms Code\":\"PRL\",
    //\"Fin_ Charge Terms Code\":\"2.0 ETR.\",\"Application Method\":0,\"Disable Blocking\":true,
    //\"Disable Shipment Autorisation\":true,\"Appliquer Ecart pompe JIR\":true,\"Remove JIR Ref on BE\":true,
    //\"GDP Partner\":true,\"Related Vendor\":\"\",\"Warranty Status\":1,\"Warranty Due Date\":\"2025-02-23\",
    //\"Warranty Pledge\":true,\"Warranty Collateral\":true,\"Warranty Mortgage\":true,\"Warranty Caution\":true,
    //\"Warranty Object\":\"tesxtttt\",\"Warranty Value\":50000,\"Warranty Validity\":\"2025-02-14\",
    local procedure PopulateValuesLead(var Lead: Record Contact; input: JsonObject)
    var
        RecRef: RecordRef;
    begin

        RecRef.GetTable(Lead);

        WS.ValidateField(RecRef, Lead.FieldNo(Lead."Afk Modified By"), input, 'webUserName');
        WS.ValidateField(RecRef, Lead.FieldNo(Lead."Afk Approval Status"), input, 'Approval Status');
        WS.ValidateField(RecRef, Lead.FieldNo(Lead.Name), input, 'Name');
        WS.ValidateField(RecRef, Lead.FieldNo(Lead."Name 2"), input, 'Name 2');
        WS.ValidateField(RecRef, Lead.FieldNo(Lead."Salesperson Code"), input, 'Salesperson Code');
        WS.ValidateField(RecRef, Lead.FieldNo(Lead."Afk Legal Status"), input, 'Legal Status');
        WS.ValidateField(RecRef, Lead.FieldNo(Lead."Afk Other Legal Status"), input, 'Other Legal Status');
        WS.ValidateField(RecRef, Lead.FieldNo(Lead."Afk Responsibility Center"), input, 'Responsibility Center');
        WS.ValidateField(RecRef, Lead.FieldNo(Lead."Afk Main Industry"), input, 'Main Industry');
        WS.ValidateField(RecRef, Lead.FieldNo(Lead."Afk Industry Group"), input, 'Industry Group');
        WS.ValidateField(RecRef, Lead.FieldNo(Lead."Afk Customer Level"), input, 'Customer Level');
        WS.ValidateField(RecRef, Lead.FieldNo(Lead."Afk Parent Account Type"), input, 'Parent Account Type');
        WS.ValidateField(RecRef, Lead.FieldNo(Lead."Afk Parent Account No."), input, 'Parent Account No_');
        WS.ValidateField(RecRef, Lead.FieldNo(Lead."Currency Code"), input, 'Currency Code');
        WS.ValidateField(RecRef, Lead.FieldNo(Lead."Afk Customer Posting Group"), input, 'Customer Posting Group');
        WS.ValidateField(RecRef, Lead.FieldNo(Lead."Afk Customer Price Group"), input, 'Customer Price Group');
        WS.ValidateField(RecRef, Lead.FieldNo(Lead."Afk Gen. Bus. Posting Group"), input, 'Gen_ Bus_ Posting Group');
        WS.ValidateField(RecRef, Lead.FieldNo(Lead."Afk VAT Bus_ Posting Group"), input, 'VAT Bus_ Posting Group');
        WS.ValidateField(RecRef, Lead.FieldNo(Lead."Afk Location Code"), input, 'Location Code');
        WS.ValidateField(RecRef, Lead.FieldNo(Lead."Afk Ship-to Code"), input, 'Ship-to Code');
        WS.ValidateField(RecRef, Lead.FieldNo(Lead."Afk Shipment Method Code"), input, 'Shipment Method Code');
        WS.ValidateField(RecRef, Lead.FieldNo(Lead."Afk Bill-to Customer No."), input, 'Bill-to Customer No_');
        WS.ValidateField(RecRef, Lead.FieldNo(Lead.Address), input, 'Address');
        WS.ValidateField(RecRef, Lead.FieldNo(Lead."Address 2"), input, 'Address 2');
        WS.ValidateField(RecRef, Lead.FieldNo(Lead."Post Code"), input, 'Post Code');
        WS.ValidateField(RecRef, Lead.FieldNo(Lead.City), input, 'City');
        WS.ValidateField(RecRef, Lead.FieldNo(Lead."Phone No."), input, 'Phone No_');
        WS.ValidateField(RecRef, Lead.FieldNo(Lead."Mobile Phone No."), input, 'Mobile Phone No_');
        WS.ValidateField(RecRef, Lead.FieldNo(Lead."E-Mail"), input, 'E-Mail');
        WS.ValidateField(RecRef, Lead.FieldNo(Lead."Home Page"), input, 'Home Page');
        WS.ValidateField(RecRef, Lead.FieldNo(Lead."Afk Primary Contact No."), input, 'Primary Contact No_');
        WS.ValidateField(RecRef, Lead.FieldNo(Lead."Afk Customer Profile"), input, 'Customer Profile');
        WS.ValidateField(RecRef, Lead.FieldNo(Lead."Afk Sales Channel Code"), input, 'Sales Channel');
        WS.ValidateField(RecRef, Lead.FieldNo(Lead."Afk Sales Category Code"), input, 'Sales Category Code');
        WS.ValidateField(RecRef, Lead.FieldNo(Lead."Afk Category 1"), input, 'Category 1');
        WS.ValidateField(RecRef, Lead.FieldNo(Lead."Afk Category 2"), input, 'Category 2');
        WS.ValidateField(RecRef, Lead.FieldNo(Lead."Afk Description"), input, 'Description');
        WS.ValidateField(RecRef, Lead.FieldNo(Lead."Afk PNS PBL Terre"), input, 'PNS PBL Terre');
        WS.ValidateField(RecRef, Lead.FieldNo(Lead."Afk PNS Soutes"), input, 'PNS Soutes');
        WS.ValidateField(RecRef, Lead.FieldNo(Lead."Afk PNS Bornage"), input, 'PNS Bornage');
        WS.ValidateField(RecRef, Lead.FieldNo(Lead."Afk PNS Carte"), input, 'PNS Carte');
        WS.ValidateField(RecRef, Lead.FieldNo(Lead."Afk PNS Lubrifiants"), input, 'PNS Lubrifiants');
        WS.ValidateField(RecRef, Lead.FieldNo(Lead."Afk PNS GPL"), input, 'PNS GPL');
        WS.ValidateField(RecRef, Lead.FieldNo(Lead."Afk PNS MVOLA"), input, 'PNS MVOLA');
        WS.ValidateField(RecRef, Lead.FieldNo(Lead."Afk PNS Airtel Money"), input, 'PNS Airtel Money');
        WS.ValidateField(RecRef, Lead.FieldNo(Lead."Afk PNS Orange Money"), input, 'PNS Orange Money');
        WS.ValidateField(RecRef, Lead.FieldNo(Lead."Afk PNS SPE"), input, 'PNS SPE');
        WS.ValidateField(RecRef, Lead.FieldNo(Lead."Afk PNS ND"), input, 'PNS ND');
        WS.ValidateField(RecRef, Lead.FieldNo(Lead."Afk Payment Terms Code"), input, 'Payment Terms Code');
        WS.ValidateField(RecRef, Lead.FieldNo(Lead."Afk Credit Limit (LCY)"), input, 'Credit Limit (LCY)');
        WS.ValidateField(RecRef, Lead.FieldNo(Lead."Afk Risk Level"), input, 'Risk Level');
        WS.ValidateField(RecRef, Lead.FieldNo(Lead."Afk Payment Method Code"), input, 'Payment Method Code');
        WS.ValidateField(RecRef, Lead.FieldNo(Lead."Afk Cash payment"), input, 'Cash payment');
        WS.ValidateField(RecRef, Lead.FieldNo(Lead."Afk Check Set"), input, 'Check Set');
        WS.ValidateField(RecRef, Lead.FieldNo(Lead."Afk Bank Transfer Bank Stamp"), input, 'Bank Transfer Bank Stamp');
        WS.ValidateField(RecRef, Lead.FieldNo(Lead."Afk Traite"), input, 'Traite');
        WS.ValidateField(RecRef, Lead.FieldNo(Lead."Afk Received Check"), input, 'Received Check');
        WS.ValidateField(RecRef, Lead.FieldNo(Lead."Afk Credit Note"), input, 'Credit Note');
        WS.ValidateField(RecRef, Lead.FieldNo(Lead."Afk Automatic Debit"), input, 'Automatic Debit');
        WS.ValidateField(RecRef, Lead.FieldNo(Lead."Afk Mobile Banking"), input, 'Mobile Banking');
        WS.ValidateField(RecRef, Lead.FieldNo(Lead."Afk Reminder Terms Code"), input, 'Reminder Terms Code');
        WS.ValidateField(RecRef, Lead.FieldNo(Lead."Afk Fin. Charge Terms Code"), input, 'Fin_ Charge Terms Code');
        WS.ValidateField(RecRef, Lead.FieldNo(Lead."Afk Application Method"), input, 'Application Method');
        WS.ValidateField(RecRef, Lead.FieldNo(Lead."Afk Disable Blocking"), input, 'Disable Blocking');
        WS.ValidateField(RecRef, Lead.FieldNo(Lead."Disable Shipment Autorisation"), input, 'Disable Shipment Autorisation');
        WS.ValidateField(RecRef, Lead.FieldNo(Lead."Appliquer Ecart pompe JIR"), input, 'Appliquer Ecart pompe JIR');
        WS.ValidateField(RecRef, Lead.FieldNo(Lead."Remove JIR Ref on BE"), input, 'Remove JIR Ref on BE');
        WS.ValidateField(RecRef, Lead.FieldNo(Lead."Afk GDP Partner"), input, 'GDP Partner');
        WS.ValidateField(RecRef, Lead.FieldNo(Lead."Afk Related Vendor"), input, 'Related Vendor');
        WS.ValidateField(RecRef, Lead.FieldNo(Lead."Afk Warranty Status"), input, 'Warranty Status');
        WS.ValidateField(RecRef, Lead.FieldNo(Lead."Afk Warranty Due Date"), input, 'Warranty Due Date');
        WS.ValidateField(RecRef, Lead.FieldNo(Lead."Afk Warranty Pledge"), input, 'Warranty Pledge');
        WS.ValidateField(RecRef, Lead.FieldNo(Lead."Afk Warranty Collateral"), input, 'Warranty Collateral');
        WS.ValidateField(RecRef, Lead.FieldNo(Lead."Afk Warranty Mortgage"), input, 'Warranty Mortgage');
        WS.ValidateField(RecRef, Lead.FieldNo(Lead."Afk Warranty Caution"), input, 'Warranty Caution');
        WS.ValidateField(RecRef, Lead.FieldNo(Lead."Afk Warranty Object"), input, 'Warranty Object');
        WS.ValidateField(RecRef, Lead.FieldNo(Lead."Afk Warranty Value"), input, 'Warranty Value');
        WS.ValidateField(RecRef, Lead.FieldNo(Lead."Afk Warranty Validity"), input, 'Warranty Validity');
        //WS.ValidateField(RecRef, Lead.FieldNo(Lead."Afk Currency Code"), input, 'Currency Code');
        WS.ValidateField(RecRef, Lead.FieldNo(Lead."Afk Language Code"), input, 'Language Code');
        WS.ValidateField(RecRef, Lead.FieldNo(Lead."Afk Contact Type"), input, 'Contact Type');
        WS.ValidateField(RecRef, Lead.FieldNo(Lead."Afk Blocked"), input, 'Blocked');

        RecRef.SetTable(Lead);
    end;



    //{"inputJson":"{\"Parameter\":\"customer_modify\",\"webUserName\":\"GERALD\",\"No_\":\"C000001\",
    // \"Customer Status\":0,\"Name\":\"gerald\",\"Name 2\":\"gerald\",\"Salesperson Code\":\"10011\",
    // \"Legal Status\":\"11\",\"Other Legal Status\":\"\",\"Responsibility Center\":\"AT\",
    // \"Main Industry\":\"SP03\",\"Industry Group\":\"SA006\",\"Customer Level\":0,
    // \"Parent Account No_\":\"C0000003\",\"Blocked\":0,\"Currency Code\":\"MGA\",\"Language Code\":\"FRA\",
    // \"Customer Posting Group\":\"ETR\",\"Customer Price Group\":\"CTN\",\"Gen_ Bus_ Posting Group\":\"MAL\",
    // \"VAT Bus_ Posting Group\":\"SOUTE\",\"Location Code\":\"TN00REC\",\"STAT Code\":\"\",\"CIF_CIS\":\"\",
    // \"Trade Number\":\"\",\"VAT Registration No_\":\"\",\"Ship-to Code\":\"C0000003\",\"Shipment Method Code\":\"ENL\",
    // \"Bill-to Customer No_\":\"C0000002\",\"Address\":\"rue1\",\"Address 2\":\"rue2\",\"Post Code\":\"2566\",
    // \"City\":\"tana\",\"Phone No_\":\"5445646515\",\"Mobile Phone No_\":\"1545151515\",\"E-Mail\":\"gerald.gmail.com\",
    // \"Home Page\":\"gerald.site.com\",\"Primary Contact No_\":\"\",\"Customer Profile\":0,\"Sales Channel\":\"100\",
    // \"Sales Category Code\":\"\",\"Category 1\":0,\"Category 2\":0,\"Description\":\"ras\",\"PNS PBL Terre\":false,
    // \"PNS Soutes\":false,\"PNS Bornage\":false,\"PNS Carte\":false,\"PNS Lubrifiants\":false,\"PNS GPL\":false,
    // \"PNS MVOLA\":false,\"PNS Airtel Money\":false,\"PNS Orange Money\":false,\"PNS SPE\":false,\"PNS ND\":false,
    // \"Payment Terms Code\":\"I15\",\"Credit Limit (LCY)\":50000,\"Risk Level\":\"02\",\"Payment Method Code\":\"ESPECES\",
    // \"Cash payment\":true,\"Check Set\":true,\"Bank Transfer Bank Stamp\":true,\"Traite\":true,\"Received Check\":true,
    // \"Credit Note\":true,\"Automatic Debit\":true,\"Mobile Banking\":true,\"Reminder Terms Code\":\"PRL\",
    // \"Fin_ Charge Terms Code\":\"2.0 ETR.\",\"Application Method\":0,\"Disable Blocking\":true,
    // \"Disable Shipment Autorisation\":true,\"Appliquer Ecart pompe JIR\":true,\"Remove JIR Ref on BE\":true,
    // \"GDP Partner\":true,\"Related Vendor\":\"\",\"Warranty Status\":1,\"Warranty Due Date\":\"2025-02-23\",
    // \"Warranty Pledge\":true,\"Warranty Collateral\":true,\"Warranty Mortgage\":true,\"Warranty Caution\":true,
    // \"Warranty Object\":\"tesxtttt\",\"Warranty Value\":50000,\"Warranty Validity\":\"2025-02-14\"
    local procedure PopulateValuesCustomer(var Cust: Record Customer; input: JsonObject)
    var
        RecRef: RecordRef;
    begin

        RecRef.GetTable(Cust);

        WS.ValidateField(RecRef, Cust.FieldNo(Cust."Afk Modified By"), input, 'webUserName');
        WS.ValidateField(RecRef, Cust.FieldNo(Cust."Customer Status"), input, 'Customer Status');
        WS.ValidateField(RecRef, Cust.FieldNo(Cust.Name), input, 'Name');
        WS.ValidateField(RecRef, Cust.FieldNo(Cust."Name 2"), input, 'Name 2');
        WS.ValidateField(RecRef, Cust.FieldNo(Cust."Salesperson Code"), input, 'Salesperson Code');
        WS.ValidateField(RecRef, Cust.FieldNo(Cust."Legal Status Code"), input, 'Legal Status');
        WS.ValidateField(RecRef, Cust.FieldNo(Cust."Afk Other Legal Status"), input, 'Other Legal Status');
        WS.ValidateField(RecRef, Cust.FieldNo(Cust."Responsibility Center"), input, 'Responsibility Center');
        WS.ValidateField(RecRef, Cust.FieldNo(Cust."Afk Main Industry"), input, 'Main Industry');
        WS.ValidateField(RecRef, Cust.FieldNo(Cust."Industry Group"), input, 'Industry Group');
        WS.ValidateField(RecRef, Cust.FieldNo(Cust."Afk Customer Level"), input, 'Customer Level');
        //WS.ValidateField(RecRef, Cust.FieldNo(Cust."Afk Parent Account Type"), input, 'Parent Account Type');
        WS.ValidateField(RecRef, Cust.FieldNo(Cust."Afk Parent Account No."), input, 'Parent Account No_');
        WS.ValidateField(RecRef, Cust.FieldNo(Cust.Blocked), input, 'Blocked');
        WS.ValidateField(RecRef, Cust.FieldNo(Cust."Currency Code"), input, 'Currency Code');
        WS.ValidateField(RecRef, Cust.FieldNo(Cust."Language Code"), input, 'Language Code');
        WS.ValidateField(RecRef, Cust.FieldNo(Cust."Customer Posting Group"), input, 'Customer Posting Group');
        WS.ValidateField(RecRef, Cust.FieldNo(Cust."Customer Price Group"), input, 'Customer Price Group');
        WS.ValidateField(RecRef, Cust.FieldNo(Cust."Gen. Bus. Posting Group"), input, 'Gen_ Bus_ Posting Group');
        WS.ValidateField(RecRef, Cust.FieldNo(Cust."VAT Bus. Posting Group"), input, 'VAT Bus_ Posting Group');
        WS.ValidateField(RecRef, Cust.FieldNo(Cust."Location Code"), input, 'Location Code');
        WS.ValidateField(RecRef, Cust.FieldNo(Cust."STAT Code"), input, 'STAT Code');
        WS.ValidateField(RecRef, Cust.FieldNo(Cust."CIF/CIS"), input, 'CIF_CIS');
        WS.ValidateField(RecRef, Cust.FieldNo(Cust."Trade Number"), input, 'Trade Number');
        WS.ValidateField(RecRef, Cust.FieldNo(Cust."VAT Registration No."), input, 'VAT Registration No_');
        WS.ValidateField(RecRef, Cust.FieldNo(Cust."Ship-to Code"), input, 'Ship-to Code');
        WS.ValidateField(RecRef, Cust.FieldNo(Cust."Shipment Method Code"), input, 'Shipment Method Code');
        WS.ValidateField(RecRef, Cust.FieldNo(Cust."Bill-to Customer No."), input, 'Bill-to Customer No_');
        WS.ValidateField(RecRef, Cust.FieldNo(Cust.Address), input, 'Address');
        WS.ValidateField(RecRef, Cust.FieldNo(Cust."Address 2"), input, 'Address 2');
        WS.ValidateField(RecRef, Cust.FieldNo(Cust."Post Code"), input, 'Post Code');
        WS.ValidateField(RecRef, Cust.FieldNo(Cust.City), input, 'City');
        WS.ValidateField(RecRef, Cust.FieldNo(Cust."Phone No."), input, 'Phone No_');
        WS.ValidateField(RecRef, Cust.FieldNo(Cust."Mobile Phone No."), input, 'Mobile Phone No_');
        WS.ValidateField(RecRef, Cust.FieldNo(Cust."E-Mail"), input, 'E-Mail');
        WS.ValidateField(RecRef, Cust.FieldNo(Cust."Home Page"), input, 'Home Page');
        WS.ValidateField(RecRef, Cust.FieldNo(Cust."Primary Contact No."), input, 'Primary Contact No_');
        WS.ValidateField(RecRef, Cust.FieldNo(Cust."Afk Customer Profile"), input, 'Customer Profile');
        WS.ValidateField(RecRef, Cust.FieldNo(Cust."Sales Channel Code"), input, 'Sales Channel');
        WS.ValidateField(RecRef, Cust.FieldNo(Cust."Sales Category Code"), input, 'Sales Category Code');
        WS.ValidateField(RecRef, Cust.FieldNo(Cust."Category 1"), input, 'Category 1');
        WS.ValidateField(RecRef, Cust.FieldNo(Cust."Category 2"), input, 'Category 2');
        WS.ValidateField(RecRef, Cust.FieldNo(Cust."Afk Description"), input, 'Description');
        WS.ValidateField(RecRef, Cust.FieldNo(Cust."Afk PNS PBL Terre"), input, 'PNS PBL Terre');
        WS.ValidateField(RecRef, Cust.FieldNo(Cust."Afk PNS Soutes"), input, 'PNS Soutes');
        WS.ValidateField(RecRef, Cust.FieldNo(Cust."Afk PNS Bornage"), input, 'PNS Bornage');
        WS.ValidateField(RecRef, Cust.FieldNo(Cust."Afk PNS Carte"), input, 'PNS Carte');
        WS.ValidateField(RecRef, Cust.FieldNo(Cust."Afk PNS Lubrifiants"), input, 'PNS Lubrifiants');
        WS.ValidateField(RecRef, Cust.FieldNo(Cust."Afk PNS GPL"), input, 'PNS GPL');
        WS.ValidateField(RecRef, Cust.FieldNo(Cust."Afk PNS MVOLA"), input, 'PNS MVOLA');
        WS.ValidateField(RecRef, Cust.FieldNo(Cust."Afk PNS Airtel Money"), input, 'PNS Airtel Money');
        WS.ValidateField(RecRef, Cust.FieldNo(Cust."Afk PNS Orange Money"), input, 'PNS Orange Money');
        WS.ValidateField(RecRef, Cust.FieldNo(Cust."Afk PNS SPE"), input, 'PNS SPE');
        WS.ValidateField(RecRef, Cust.FieldNo(Cust."Afk PNS ND"), input, 'PNS ND');
        WS.ValidateField(RecRef, Cust.FieldNo(Cust."Payment Terms Code"), input, 'Payment Terms Code');
        WS.ValidateField(RecRef, Cust.FieldNo(Cust."Credit Limit (LCY)"), input, 'Credit Limit (LCY)');
        WS.ValidateField(RecRef, Cust.FieldNo(Cust."Risk Level"), input, 'Risk Level');
        WS.ValidateField(RecRef, Cust.FieldNo(Cust."Payment Method Code"), input, 'Payment Method Code');
        WS.ValidateField(RecRef, Cust.FieldNo(Cust."Cash payment"), input, '"Cash payment');
        WS.ValidateField(RecRef, Cust.FieldNo(Cust."Check Set"), input, 'Check Set');
        WS.ValidateField(RecRef, Cust.FieldNo(Cust."Bank Transfer Bank Stamp"), input, 'Bank Transfer Bank Stamp');
        WS.ValidateField(RecRef, Cust.FieldNo(Cust."Traite"), input, 'Traite');
        WS.ValidateField(RecRef, Cust.FieldNo(Cust."Received Check"), input, 'Received Check');
        WS.ValidateField(RecRef, Cust.FieldNo(Cust."Credit Note"), input, 'Credit Note');
        WS.ValidateField(RecRef, Cust.FieldNo(Cust."Automatic Debit"), input, 'Automatic Debit');
        WS.ValidateField(RecRef, Cust.FieldNo(Cust."Mobile Banking"), input, 'Mobile Banking');
        WS.ValidateField(RecRef, Cust.FieldNo(Cust."Reminder Terms Code"), input, 'Reminder Terms Code');
        WS.ValidateField(RecRef, Cust.FieldNo(Cust."Fin. Charge Terms Code"), input, 'Fin_ Charge Terms Code');
        WS.ValidateField(RecRef, Cust.FieldNo(Cust."Application Method"), input, 'Application Method');
        WS.ValidateField(RecRef, Cust.FieldNo(Cust."Disable Blocking"), input, 'Disable Blocking');
        WS.ValidateField(RecRef, Cust.FieldNo(Cust."Disable Shipment Autorisation"), input, 'Disable Shipment Autorisation');
        WS.ValidateField(RecRef, Cust.FieldNo(Cust."Appliquer Ecart pompe JIR"), input, 'Appliquer Ecart pompe JIR');
        WS.ValidateField(RecRef, Cust.FieldNo(Cust."Remove JIR Ref on BE"), input, 'Remove JIR Ref on BE');
        WS.ValidateField(RecRef, Cust.FieldNo(Cust."GDP Partner"), input, 'GDP Partner');
        WS.ValidateField(RecRef, Cust.FieldNo(Cust."Related Vendor"), input, 'Related Vendor');
        WS.ValidateField(RecRef, Cust.FieldNo(Cust."Afk Warranty Status"), input, 'Warranty Status');
        WS.ValidateField(RecRef, Cust.FieldNo(Cust."Afk Warranty Due Date"), input, 'Warranty Due Date');
        WS.ValidateField(RecRef, Cust.FieldNo(Cust."Afk Warranty Pledge"), input, 'Warranty Pledge');
        WS.ValidateField(RecRef, Cust.FieldNo(Cust."Afk Warranty Collateral"), input, 'Warranty Collateral');
        WS.ValidateField(RecRef, Cust.FieldNo(Cust."Afk Warranty Mortgage"), input, 'Warranty Mortgage');
        WS.ValidateField(RecRef, Cust.FieldNo(Cust."Afk Warranty Caution"), input, 'Warranty Caution');
        WS.ValidateField(RecRef, Cust.FieldNo(Cust."Afk Warranty Object"), input, 'Warranty Object');
        WS.ValidateField(RecRef, Cust.FieldNo(Cust."Afk Warranty Value"), input, 'Warranty Value');
        WS.ValidateField(RecRef, Cust.FieldNo(Cust."Afk Warranty Validity"), input, 'Warranty Validity');
        WS.ValidateField(RecRef, Cust.FieldNo(Cust."Afk Desactivation Reason"), input, 'Deactivation Reason');

        RecRef.SetTable(Cust);
    end;

    local procedure SetCustomerIfRrevisionIsValidated(var input: JsonObject)
    var
        Cust: record Customer;
        CustRevision: Record "Afk Customer Revision";
    begin

        CustRevision.Get(ws.GetText('No_', input));
        //CustRevision."Approval Status" := ApprovalFlow."Next Status";
        CustRevision.validate("Approval Status", ws.GetInt('Approval Status', input));
        CustRevision."Approved Payment Terms Code" := ws.GetBool('Approved Payment Terms Code', input);
        CustRevision."Approved Credit limit (LCY)" := ws.GetBool('Approved Credit limit (LCY)', input);
        CustRevision."Approved Risk Level" := ws.GetBool('Approved Risk Level', input);
        CustRevision."Approved Payment Method" := ws.GetBool('Approved Payment Method', input);

        // CustRevision."Approved Payment Method" := ws.GetBool('Approved Payment Method', input);
        // CustRevision."Approved Payment Method" := ws.GetBool('Approved Payment Method', input);
        // CustRevision."Approved Payment Method" := ws.GetBool('Approved Payment Method', input);
        // CustRevision."Approved Payment Method" := ws.GetBool('Approved Payment Method', input);

        CustRevision.Modify();

        if (CustRevision."Approval Status" = CustRevision."Approval Status"::"Validé") then begin
            if (Cust.Get(CustRevision."Customer No.")) then begin
                if (CustRevision."Approved Payment Terms Code") then
                    Cust.Validate("Payment Terms Code", CustRevision."New Payment Terms Code");
                if (CustRevision."Approved Credit limit (LCY)") then
                    Cust.Validate("Credit Limit (LCY)", CustRevision."New Credit limit (LCY)");
                if (CustRevision."Approved Risk Level") then
                    Cust.Validate("Risk Level", CustRevision."New Risk Level");
                if (CustRevision."Approved Payment Method") then begin
                    Cust.Validate(Cust."Cash payment", CustRevision."New Cash payment");
                    Cust."Check Set" := CustRevision."New Check Set";
                    Cust."Bank Transfer Bank Stamp" := CustRevision."New Bank Transfer Bank Stamp";
                    Cust.Traite := CustRevision."New Traite";
                    Cust."Received Check" := CustRevision."New Received Check";
                    Cust."Credit Note" := CustRevision."New Credit Note";
                    Cust."Automatic Debit" := CustRevision."New Automatic Debit";
                    Cust."Mobile Banking" := CustRevision."New Mobile Banking";
                end;

                Cust.Modify();
            end;
        end;
    end;

    local procedure SetOrderIfValidated(var input: JsonObject): Text
    var
        DdeDeblocage: Record "Afk SalesOrder Unblocking";
        SalesOrder: Record "Sales Header";
        SalesProcessMgt: Codeunit "Sales Order Process";
    begin
        DdeDeblocage.Get(ws.GetText('No_', input));
        DdeDeblocage."Unblocking justified" := ws.GetBool('Unblocking justified', input);
        DdeDeblocage.validate("Approval Status", ws.GetInt('Approval Status', input));
        DdeDeblocage."Modified By" := CopyStr(ws.GetText('webUserName', input), 1, 50);
        DdeDeblocage.Modify();

        if (DdeDeblocage."Approval Status" = DdeDeblocage."Approval Status"::"Validé") then
            if (SalesOrder.get(SalesOrder."Document Type"::Order, DdeDeblocage."No.")) then
                SalesProcessMgt.ValidationDeblocage(SalesOrder);

        exit(DdeDeblocage."No.");
        //ModifyBlockingStatus(DdeDeblocage, ApprovalFlow."Approved by", ApprovalFlow."Next Status");

        //exit(Ws.CreateResponseSuccess(DdeDeblocage."No."));
    end;

    local procedure AddLinkDocument(input: JsonObject): Text
    var
        LinkDoc: Record "Afk Web Link Document";
    begin

        LinkDoc.Init();

        if (LinkDoc."Document No." <> WS.GetText('No_', input)) then
            LinkDoc.Validate("Document No.", WS.GetText('No_', input));

        if (LinkDoc."Function Code" <> WS.GetText('Function', input)) then
            LinkDoc.Validate("Function Code", WS.GetText('Function', input));

        if (LinkDoc."Document Name" <> WS.GetText('Document Name', input)) then
            LinkDoc.Validate("Document Name", WS.GetText('Document Name', input));

        if (LinkDoc.Link <> WS.GetText('Link', input)) then
            LinkDoc.Validate(Link, WS.GetText('Link', input));

        if (LinkDoc."Created By" <> WS.GetText('webUserName', input)) then
            LinkDoc.Validate("Created By", WS.GetText('webUserName', input));

        LinkDoc.Insert(true);

        exit(Ws.CreateResponseSuccess(LinkDoc."Document No."));

    end;

    local procedure DeleteLinkDocument(input: JsonObject): Text
    var
        LinkDoc: Record "Afk Web Link Document";
        DocNo: Code[20];
        FunctionNo: Code[20];
        DocName: Text[100];
    begin
        DocNo := CopyStr(WS.GetText('No_', input), 1, 20);
        FunctionNo := CopyStr(WS.GetText('Function', input), 1, 20);
        DocName := CopyStr(WS.GetText('Document Name', input), 1, 20);

        if (LinkDoc.Get(FunctionNo, DocNo, DocName)) then
            LinkDoc.Delete(true);

        exit(Ws.CreateResponseSuccess(LinkDoc."Document No."));

    end;

    local procedure ModifyLeadStatusAndConvertCustomer(input: JsonObject)
    var
        Lead: Record "Contact";
        Cont: Record "Contact";
    begin

        Lead.Get(ws.GetText('No_', input));
        Lead.validate("Afk Approval Status", ws.GetInt('Approval Status', input));
        //CustRevision."Approved Payment Terms Code" := ws.GetBool('Approved Payment Terms Code', input);

        Lead.Modify();

        if (Lead."Afk Approval Status" = Lead."Afk Approval Status"::"Validé") then begin
            AfkSetup.Get();
            if (Lead."Afk Customer Level" = Lead."Afk Customer Level"::Holding) then begin
                AfkSetup.TestField(AfkSetup."Holding Cust Templ");
                Lead.CreateCustomerFromTemplate(AfkSetup."Holding Cust Templ");
            end;
            if (Lead."Afk Customer Level" = Lead."Afk Customer Level"::"Opération") then begin
                AfkSetup.TestField(AfkSetup."Operation Cust Templ");
                Lead.CreateCustomerFromTemplate(AfkSetup."Operation Cust Templ");
            end;
            if (Lead."Afk Customer Level" = Lead."Afk Customer Level"::"Société") then begin
                AfkSetup.TestField(AfkSetup."Company Cust Templ");
                Lead.CreateCustomerFromTemplate(AfkSetup."Company Cust Templ");
            end;

            Cont.SetRange(Cont."Afk Parent Account No.", Lead."No.");
            if Cont.FindSet(true) then
                repeat
                    Cont.CreateCustomerFromTemplate('');
                    Cont."Afk Parent Account Type" := Cont."Afk Parent Account Type"::Client;
                    Cont.Modify();
                until Cont.Next() < 1;
        end;
    end;


    var
        AfkSetup: record "AddOn Setup2";
        WS: codeunit "Afk Api Mgt";
        NoSeriesMgt: Codeunit "No. Series";
}
