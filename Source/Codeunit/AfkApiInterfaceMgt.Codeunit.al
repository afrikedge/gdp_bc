codeunit 50041 "Afk Api Interface Mgt"
{

    var
        WS: codeunit "Afk Api Mgt";
        FrontDeskMgt: codeunit "Afk FrontDeskValidation Mgt";
        LblUnknownParameter: Label 'Unkwnown parameter : %1', Comment = '%1 = parameter';
    /// <summary>
    /// 
    /// </summary>
    /// <param name="inputJson"></param>
    /// <returns></returns>
    procedure Run(inputJson: Text): Text
    var
        input: JsonObject;
        param: text;

    begin
        input.ReadFrom(inputJson);
        param := ws.GetText('Parameter', input);

        case param of

            'changeUserPassword':
                exit(FrontDeskMgt.RunUpdatePassword(input));

            'SOUnblocking_updateApprovalFlow':
                exit(FrontDeskMgt.Run_ModifyBlockingStatus(input));

            'revisionRequest_insert':
                exit(FrontDeskMgt.RunCustRevision(input, false));

            'revisionRequest_modify':
                exit(FrontDeskMgt.RunCustRevision(input, false));

            'revisionRequest_delete':
                exit(FrontDeskMgt.RunCustRevision(input, true));

            'RevisionRequest_updateApprovalFlow':
                exit(FrontDeskMgt.Run_ModifyCustRevisionStatus(input));

            'lead_insert':
                exit(FrontDeskMgt.RunLeads(input, false));

            'lead_modify':
                exit(FrontDeskMgt.RunLeads(input, false));

            'lead_delete':
                exit(FrontDeskMgt.RunLeads(input, true));

            'lead_updateApprovalFlow':
                exit(FrontDeskMgt.Run_ModifyLeadStatus(input));

            'shipToAddress_insert':
                exit(FrontDeskMgt.RunShipToAddress(input, false));

            'shipToAddress_modify':
                exit(FrontDeskMgt.RunShipToAddress(input, false));

            'shipToAddress_delete':
                exit(FrontDeskMgt.RunShipToAddress(input, true));


            'contact_insert':
                exit(FrontDeskMgt.RunContacts(input, false));

            'contact_modify':
                exit(FrontDeskMgt.RunContacts(input, false));

            'contact_delete':
                exit(FrontDeskMgt.RunContacts(input, true));

            'customer_modify':
                exit(FrontDeskMgt.RunCustomers(input, false));

            'documentlink_insert':
                exit(FrontDeskMgt.RunLinkDocument(input, false));

            'documentlink_delete':
                exit(FrontDeskMgt.RunLinkDocument(input, true));

            'customer_reassign':
                exit(FrontDeskMgt.Customer_Reassign(input));



            'salesOrder_getPrice':
                exit(FrontDeskMgt.GetUnitPrice(input));
            'salesOrder_insert':
                exit(FrontDeskMgt.Run_SalesOrders(input, false));
            'salesOrder_modify':
                exit(FrontDeskMgt.Run_SalesOrders(input, false));
            'salesOrder_delete':
                exit(FrontDeskMgt.Run_SalesOrders(input, true));
            'salesOrder_submit':
                exit(FrontDeskMgt.SalesOrderSentToValidation(input));
            'salesOrder_cancel':
                exit(FrontDeskMgt.Run_CancelOrder(input));

            'refresh_touring_data':
                exit(FrontDeskMgt.Run_RefreshTouringData(input));



            // 'orders_item_getPrice':
            //     exit(OrdersMgt.GetUnitPrice(input));
            // 'orders_payment_save':
            //     exit(OrdersMgt.SaveOrderPaymentLines(input));
            // 'orders_payment_validate':
            //     exit(OrdersMgt.PostSalesOrder(input));
            // 'salesOrderUnclocking_insert':
            //     exit(OrdersMgt.Run_CreateUnBlockingRequest(input));
            // 'discountRequest_insert':
            //     exit(OrdersMgt.Run_CreateDiscountRequest(input));
            // 'paymentRequest_insert':
            //     exit(OrdersMgt.Run_CreatePOSPaymentRequest(input));
            // 'request_validate':
            //     exit(OrdersMgt.Run_ModifyRequestStatus(input));


            // 'recoveryActivities_insert':
            //     exit(CreditMgt.RunRecoveryActivities(input, false));
            // 'recoveryActivities_modify':
            //     exit(CreditMgt.RunRecoveryActivities(input, false));
            // 'recoveryActivities_delete':
            //     exit(CreditMgt.RunRecoveryActivities(input, true));


            // 'repossessionRequests_insert':
            //     exit(CreditMgt.RunReposessionRequest(input, false));
            // 'repossessionRequests_modify':
            //     exit(CreditMgt.RunReposessionRequest(input, false));
            // 'repossessionRequests_delete':
            //     exit(CreditMgt.RunReposessionRequest(input, true));


            // 'paymentPromises_insert':
            //     exit(CreditMgt.RunRPaymentPromise(input, false));
            // 'paymentPromises_modify':
            //     exit(CreditMgt.RunRPaymentPromise(input, false));
            // 'paymentPromises_delete':
            //     exit(CreditMgt.RunRPaymentPromise(input, true));


            // 'customers_modify':
            //     exit(MasterFilesMgt.RunCustomers(input, false));

            // 'leads_modify':
            //     exit(MasterFilesMgt.RunLeads(input, false));
            // 'leads_insert':
            //     exit(MasterFilesMgt.RunLeads(input, false));
            // 'leads_createcustomer':
            //     exit(MasterFilesMgt.RunCreateCustomer(input));

            // 'contacts_insert':
            //     exit(MasterFilesMgt.RunContacts(input, false));
            // 'contacts_modify':
            //     exit(MasterFilesMgt.RunContacts(input, false));

            // 'creditContracts_insert':
            //     exit(MasterFilesMgt.RunCreditContracts(input, false));
            // 'creditContracts_modify':
            //     exit(MasterFilesMgt.RunCreditContracts(input, false));

            // 'shipToAddress_insert':
            //     exit(MasterFilesMgt.RunShipToAddress(input, false));
            // 'shipToAddress_modify':
            //     exit(MasterFilesMgt.RunShipToAddress(input, false));

            // 'documentlink_insert':
            //     exit(MasterFilesMgt.RunLinkDocument(input, false));
            // 'documentlink_delete':
            //     exit(MasterFilesMgt.RunLinkDocument(input, true));




            // 'serviceRequest_modify':
            //     exit(SAVMgt.RunServiceRequest(input, false));
            // 'serviceRequest_insert':
            //     exit(SAVMgt.RunServiceRequest(input, false));

            // 'transportOrder_modify':
            //     exit(SAVMgt.RunOrderTransport(input, false));
            // 'transportOrder_insert':
            //     exit(SAVMgt.RunOrderTransport(input, true));



            else
                exit(StrSubstNo(LblUnknownParameter, param));
        end;

    end;


    //{"inputJson":"{\"Parameter\":\"SOUnblocking_updateApprovalFlow\",\"webUserName\":\"GERALD\",\"Approval Status\":7,\"ApprovalFlow\":[{\"Record Type\":2,\"Record No_\":\"469658\",\"Sequence No_\":1,\"Approval Mode\":0,\"Approved On\":\"2025-02-02T13:21:35.542Z\",\"Approved by\":\"GERALD\",\"Approved as\":\"GERALD\",\"Actual Status\":5,\"Next Status\":7,\"Comments\":\"rien à signaler\"}]}"}
}

