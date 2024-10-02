tableextension 50018 "A02 Gen. Journal Line" extends "Gen. Journal Line"
{
    // //JN130116 Bloquer le suppression des lignes provenant de moneytech
    fields
    {

        //Unsupported feature: Property Insertion (Editable) on ""Recipient Bank Account"(Field 288)".



        //Unsupported feature: Code Modification on ""Account No."(Field 4).OnValidate".

        //trigger "(Field 4)()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        IF "Account No." <> xRec."Account No." THEN BEGIN
          ClearAppliedAutomatically;
          VALIDATE("Job No.",'');
        #4..48
          "Account Type"::Customer:
            UpdateCustomerID;
        END;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..51


        //The code has been merged but contained errors that could prevent import
        //and the code has been put in comments. Use Shift+Ctrl+O to Uncomment
        //IF "Account No." <> xRec."Account No." THEN BEGIN
        //  ClearAppliedAutomatically;
        //  VALIDATE("Job No.",'');
        //END;
        //
        //IF xRec."Account Type" IN ["Account Type"::Customer,"Account Type"::Vendor,"Account Type"::"IC Partner"] THEN
        //  "IC Partner Code" := '';
        //
        //IF "Account No." = '' THEN BEGIN
        //  CleanLine;
        //  GetDerogatorySetup;
        //  EXIT;
        //END;
        //
        //CASE "Account Type" OF
        //  "Account Type"::"G/L Account":
        //    GetGLAccount;
        //  "Account Type"::Customer:
        //{>>>>>>>} ORIGINAL
        //    BEGIN
        //      Cust.GET("Account No.");
        //      Cust.CheckBlockedCustOnJnls(Cust,"Document Type",FALSE);
        //      IF Cust."IC Partner Code" <> '' THEN BEGIN
        //        IF GenJnlTemplate.GET("Journal Template Name") THEN;
        //        IF (Cust."IC Partner Code" <> '' ) AND ICPartner.GET(Cust."IC Partner Code") THEN BEGIN
        //          ICPartner.CheckICPartnerIndirect(FORMAT("Account Type"),"Account No.");
        //          "IC Partner Code" := Cust."IC Partner Code";
        //        END;
        //      END;
        //      UpdateDescription(Cust.Name);
        //      "Payment Method Code" := Cust."Payment Method Code";
        //      VALIDATE("Recipient Bank Account",Cust."Preferred Bank Account");
        //      "Posting Group" := Cust."Customer Posting Group";
        //      "Salespers./Purch. Code" := Cust."Salesperson Code";
        //      "Payment Terms Code" := Cust."Payment Terms Code";
        //      VALIDATE("Bill-to/Pay-to No.","Account No.");
        //      VALIDATE("Sell-to/Buy-from No.","Account No.");
        //      IF NOT SetCurrencyCode("Bal. Account Type","Bal. Account No.") THEN
        //        "Currency Code" := Cust."Currency Code";
        //      ClearPostingGroups;
        //      IF (Cust."Bill-to Customer No." <> '') AND (Cust."Bill-to Customer No." <> "Account No.") THEN
        //        IF NOT CONFIRM(Text014,FALSE,Cust.TABLECAPTION,Cust."No.",Cust.FIELDCAPTION("Bill-to Customer No."),
        //             Cust."Bill-to Customer No.")
        //        THEN
        //          ERROR('');
        //      VALIDATE("Payment Terms Code");
        //      CheckPaymentTolerance;
        //    END;
        //{=======} MODIFIED
        //    BEGIN
        //      Cust.GET("Account No.");
        //      Cust.CheckBlockedCustOnJnls(Cust,"Document Type",FALSE);
        //      IF Cust."IC Partner Code" <> '' THEN BEGIN
        //        IF GenJnlTemplate.GET("Journal Template Name") THEN;
        //        IF (Cust."IC Partner Code" <> '' ) AND ICPartner.GET(Cust."IC Partner Code") THEN BEGIN
        //          ICPartner.CheckICPartnerIndirect(FORMAT("Account Type"),"Account No.");
        //          "IC Partner Code" := Cust."IC Partner Code";
        //        END;
        //      END;
        //      //******************************************************************
        //      //******************************************************************
        //      "Customer Name" := Cust.Name;
        //      //******************************************************************
        //      //******************************************************************
        //      UpdateDescription(Cust.Name);
        //      "Payment Method Code" := Cust."Payment Method Code";
        //      VALIDATE("Recipient Bank Account",Cust."Preferred Bank Account");
        //      "Posting Group" := Cust."Customer Posting Group";
        //      "Salespers./Purch. Code" := Cust."Salesperson Code";
        //      "Payment Terms Code" := Cust."Payment Terms Code";
        //      VALIDATE("Bill-to/Pay-to No.","Account No.");
        //      VALIDATE("Sell-to/Buy-from No.","Account No.");
        //      IF NOT SetCurrencyCode("Bal. Account Type","Bal. Account No.") THEN
        //        "Currency Code" := Cust."Currency Code";
        //      ClearPostingGroups;
        //      IF (Cust."Bill-to Customer No." <> '') AND (Cust."Bill-to Customer No." <> "Account No.") THEN
        //        IF NOT CONFIRM(Text014,FALSE,Cust.TABLECAPTION,Cust."No.",Cust.FIELDCAPTION("Bill-to Customer No."),
        //             Cust."Bill-to Customer No.")
        //        THEN
        //          ERROR('');
        //      VALIDATE("Payment Terms Code");
        //      CheckPaymentTolerance;
        //    END;
        //{=======} TARGET
        //    GetCustomerAccount;
        //{<<<<<<<}
        //  "Account Type"::Vendor:
        //    GetVendorAccount;
        //  "Account Type"::Employee:
        //    GetEmployeeAccount;
        //  "Account Type"::"Bank Account":
        //    GetBankAccount;
        //  "Account Type"::"Fixed Asset":
        //    GetFAAccount;
        //  "Account Type"::"IC Partner":
        //    GetICPartnerAccount;
        //END;
        //
        //VALIDATE("Currency Code");
        //VALIDATE("VAT Prod. Posting Group");
        //UpdateLineBalance;
        //UpdateSource;
        //CreateDim(
        //  DimMgt.TypeToTableID1("Account Type"),"Account No.",
        //  DimMgt.TypeToTableID1("Bal. Account Type"),"Bal. Account No.",
        //  DATABASE::Job,"Job No.",
        //  DATABASE::"Salesperson/Purchaser","Salespers./Purch. Code",
        //  DATABASE::Campaign,"Campaign No.");
        //
        //VALIDATE("IC Partner G/L Acc. No.",GetDefaultICPartnerGLAccNo);
        //ValidateApplyRequirements(Rec);
        //
        //CASE "Account Type" OF
        //  "Account Type"::"G/L Account":
        //    UpdateAccountID;
        //  "Account Type"::Customer:
        //    UpdateCustomerID;
        //END;
        */
        //end;


        //Unsupported feature: Code Modification on ""Bal. Account No."(Field 11).OnValidate".

        //trigger  Account No()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        VALIDATE("Job No.",'');

        IF xRec."Bal. Account Type" IN ["Bal. Account Type"::Customer,"Bal. Account Type"::Vendor,
        #4..55

        VALIDATE("IC Partner G/L Acc. No.",GetDefaultICPartnerGLAccNo);
        ValidateApplyRequirements(Rec);
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*

        #1..58

        //The code has been merged but contained errors that could prevent import
        //and the code has been put in comments. Use Shift+Ctrl+O to Uncomment
        //VALIDATE("Job No.",'');
        //
        //IF xRec."Bal. Account Type" IN ["Bal. Account Type"::Customer,"Bal. Account Type"::Vendor,
        //                                "Bal. Account Type"::"IC Partner"]
        //THEN
        //  "IC Partner Code" := '';
        //
        //IF "Bal. Account No." = '' THEN BEGIN
        //  UpdateLineBalance;
        //  UpdateSource;
        //  CreateDim(
        //    DimMgt.TypeToTableID1("Bal. Account Type"),"Bal. Account No.",
        //    DimMgt.TypeToTableID1("Account Type"),"Account No.",
        //    DATABASE::Job,"Job No.",
        //    DATABASE::"Salesperson/Purchaser","Salespers./Purch. Code",
        //    DATABASE::Campaign,"Campaign No.");
        //  IF NOT ("Account Type" IN ["Account Type"::Customer,"Account Type"::Vendor]) THEN
        //    "Recipient Bank Account" := '';
        //  IF xRec."Bal. Account No." <> '' THEN BEGIN
        //    ClearBalancePostingGroups;
        //    "Bal. Tax Area Code" := '';
        //    "Bal. Tax Liable" := FALSE;
        //    "Bal. Tax Group Code" := '';
        //    ClearCurrencyCode;
        //  END;
        //  EXIT;
        //END;
        //
        //CASE "Bal. Account Type" OF
        //  "Bal. Account Type"::"G/L Account":
        //{>>>>>>>} ORIGINAL
        //    BEGIN
        //      GLAcc.GET("Bal. Account No.");
        //      CheckGLAcc;
        //      IF "Account No." = '' THEN BEGIN
        //        Description := GLAcc.Name;
        //        "Currency Code" := '';
        //      END;
        //      IF ("Account No." = '') OR
        //         ("Account Type" IN
        //          ["Account Type"::"G/L Account","Account Type"::"Bank Account"])
        //      THEN BEGIN
        //        "Posting Group" := '';
        //        "Salespers./Purch. Code" := '';
        //        "Payment Terms Code" := '';
        //      END;
        //      IF NOT GenJnlBatch.GET("Journal Template Name","Journal Batch Name") OR
        //         GenJnlBatch."Copy VAT Setup to Jnl. Lines"
        //      THEN BEGIN
        //        "Bal. Gen. Posting Type" := GLAcc."Gen. Posting Type";
        //        "Bal. Gen. Bus. Posting Group" := GLAcc."Gen. Bus. Posting Group";
        //        "Bal. Gen. Prod. Posting Group" := GLAcc."Gen. Prod. Posting Group";
        //        "Bal. VAT Bus. Posting Group" := GLAcc."VAT Bus. Posting Group";
        //        "Bal. VAT Prod. Posting Group" := GLAcc."VAT Prod. Posting Group";
        //      END;
        //      "Bal. Tax Area Code" := GLAcc."Tax Area Code";
        //      "Bal. Tax Liable" := GLAcc."Tax Liable";
        //      "Bal. Tax Group Code" := GLAcc."Tax Group Code";
        //      IF "Posting Date" <> 0D THEN
        //        IF "Posting Date" = CLOSINGDATE("Posting Date") THEN
        //          ClearBalancePostingGroups;
        //    END;
        //{=======} MODIFIED
        //    BEGIN
        //      GLAcc.GET("Bal. Account No.");
        //      "Bal. Account Name" := GLAcc.Name;//***************************ADDED
        //      CheckGLAcc;
        //      IF "Account No." = '' THEN BEGIN
        //        IF Rec."CC Document Type"=Rec."CC Document Type"::" " THEN //***************************ADDED
        //          Description := GLAcc.Name;
        //        "Currency Code" := '';
        //      END;
        //      IF ("Account No." = '') OR
        //         ("Account Type" IN
        //          ["Account Type"::"G/L Account","Account Type"::"Bank Account"])
        //      THEN BEGIN
        //        "Posting Group" := '';
        //        "Salespers./Purch. Code" := '';
        //        "Payment Terms Code" := '';
        //      END;
        //      IF NOT GenJnlBatch.GET("Journal Template Name","Journal Batch Name") OR
        //         GenJnlBatch."Copy VAT Setup to Jnl. Lines"
        //      THEN BEGIN
        //        "Bal. Gen. Posting Type" := GLAcc."Gen. Posting Type";
        //        "Bal. Gen. Bus. Posting Group" := GLAcc."Gen. Bus. Posting Group";
        //        "Bal. Gen. Prod. Posting Group" := GLAcc."Gen. Prod. Posting Group";
        //        "Bal. VAT Bus. Posting Group" := GLAcc."VAT Bus. Posting Group";
        //        "Bal. VAT Prod. Posting Group" := GLAcc."VAT Prod. Posting Group";
        //      END;
        //      "Bal. Tax Area Code" := GLAcc."Tax Area Code";
        //      "Bal. Tax Liable" := GLAcc."Tax Liable";
        //      "Bal. Tax Group Code" := GLAcc."Tax Group Code";
        //      IF "Posting Date" <> 0D THEN
        //        IF "Posting Date" = CLOSINGDATE("Posting Date") THEN
        //          ClearBalancePostingGroups;
        //    END;
        //{=======} TARGET
        //    GetGLBalAccount;
        //{<<<<<<<}
        //  "Bal. Account Type"::Customer:
        //{>>>>>>>} ORIGINAL
        //    BEGIN
        //      Cust.GET("Bal. Account No.");
        //      Cust.CheckBlockedCustOnJnls(Cust,"Document Type",FALSE);
        //      IF Cust."IC Partner Code" <> '' THEN BEGIN
        //        IF GenJnlTemplate.GET("Journal Template Name") THEN;
        //        IF (Cust."IC Partner Code" <> '') AND ICPartner.GET(Cust."IC Partner Code") THEN BEGIN
        //          ICPartner.CheckICPartnerIndirect(FORMAT("Bal. Account Type"),"Bal. Account No.");
        //          "IC Partner Code" := Cust."IC Partner Code";
        //        END;
        //      END;
        //
        //      IF "Account No." = '' THEN
        //        Description := Cust.Name;
        //
        //      "Payment Method Code" := Cust."Payment Method Code";
        //      VALIDATE("Recipient Bank Account",Cust."Preferred Bank Account");
        //      "Posting Group" := Cust."Customer Posting Group";
        //      "Salespers./Purch. Code" := Cust."Salesperson Code";
        //      "Payment Terms Code" := Cust."Payment Terms Code";
        //      VALIDATE("Bill-to/Pay-to No.","Bal. Account No.");
        //      VALIDATE("Sell-to/Buy-from No.","Bal. Account No.");
        //      IF ("Account No." = '') OR ("Account Type" = "Account Type"::"G/L Account") THEN
        //        "Currency Code" := Cust."Currency Code";
        //      IF ("Account Type" = "Account Type"::"Bank Account") AND ("Currency Code" = '') THEN
        //        "Currency Code" := Cust."Currency Code";
        //      ClearBalancePostingGroups;
        //      IF (Cust."Bill-to Customer No." <> '') AND (Cust."Bill-to Customer No." <> "Bal. Account No.") THEN
        //        IF NOT CONFIRM(Text014,FALSE,Cust.TABLECAPTION,Cust."No.",Cust.FIELDCAPTION("Bill-to Customer No."),
        //             Cust."Bill-to Customer No.")
        //        THEN
        //          ERROR('');
        //      VALIDATE("Payment Terms Code");
        //      CheckPaymentTolerance;
        //    END;
        //{=======} MODIFIED
        //    BEGIN
        //      Cust.GET("Bal. Account No.");
        //      Cust.CheckBlockedCustOnJnls(Cust,"Document Type",FALSE);
        //      IF Cust."IC Partner Code" <> '' THEN BEGIN
        //        IF GenJnlTemplate.GET("Journal Template Name") THEN;
        //        IF (Cust."IC Partner Code" <> '') AND ICPartner.GET(Cust."IC Partner Code") THEN BEGIN
        //          ICPartner.CheckICPartnerIndirect(FORMAT("Bal. Account Type"),"Bal. Account No.");
        //          "IC Partner Code" := Cust."IC Partner Code";
        //        END;
        //      END;
        //      "Bal. Account Name" := Cust.Name;//***************************ADDED
        //      IF "Account No." = '' THEN
        //        Description := Cust.Name;
        //
        //      "Payment Method Code" := Cust."Payment Method Code";
        //      VALIDATE("Recipient Bank Account",Cust."Preferred Bank Account");
        //      "Posting Group" := Cust."Customer Posting Group";
        //      "Salespers./Purch. Code" := Cust."Salesperson Code";
        //      "Payment Terms Code" := Cust."Payment Terms Code";
        //      VALIDATE("Bill-to/Pay-to No.","Bal. Account No.");
        //      VALIDATE("Sell-to/Buy-from No.","Bal. Account No.");
        //      IF ("Account No." = '') OR ("Account Type" = "Account Type"::"G/L Account") THEN
        //        "Currency Code" := Cust."Currency Code";
        //      IF ("Account Type" = "Account Type"::"Bank Account") AND ("Currency Code" = '') THEN
        //        "Currency Code" := Cust."Currency Code";
        //      ClearBalancePostingGroups;
        //      IF (Cust."Bill-to Customer No." <> '') AND (Cust."Bill-to Customer No." <> "Bal. Account No.") THEN
        //        IF NOT CONFIRM(Text014,FALSE,Cust.TABLECAPTION,Cust."No.",Cust.FIELDCAPTION("Bill-to Customer No."),
        //             Cust."Bill-to Customer No.")
        //        THEN
        //          ERROR('');
        //      VALIDATE("Payment Terms Code");
        //      CheckPaymentTolerance;
        //    END;
        //{=======} TARGET
        //    GetCustomerBalAccount;
        //{<<<<<<<}
        //  "Bal. Account Type"::Vendor:
        //{>>>>>>>} ORIGINAL
        //    BEGIN
        //      Vend.GET("Bal. Account No.");
        //      Vend.CheckBlockedVendOnJnls(Vend,"Document Type",FALSE);
        //      IF Vend."IC Partner Code" <> '' THEN BEGIN
        //        IF GenJnlTemplate.GET("Journal Template Name") THEN;
        //        IF (Vend."IC Partner Code" <> '') AND ICPartner.GET(Vend."IC Partner Code") THEN BEGIN
        //          ICPartner.CheckICPartnerIndirect(FORMAT("Bal. Account Type"),"Bal. Account No.");
        //          "IC Partner Code" := Vend."IC Partner Code";
        //        END;
        //      END;
        //
        //      IF "Account No." = '' THEN
        //        Description := Vend.Name;
        //
        //      "Payment Method Code" := Vend."Payment Method Code";
        //      VALIDATE("Recipient Bank Account",Vend."Preferred Bank Account");
        //      "Posting Group" := Vend."Vendor Posting Group";
        //      "Salespers./Purch. Code" := Vend."Purchaser Code";
        //      "Payment Terms Code" := Vend."Payment Terms Code";
        //      VALIDATE("Bill-to/Pay-to No.","Bal. Account No.");
        //      VALIDATE("Sell-to/Buy-from No.","Bal. Account No.");
        //      IF ("Account No." = '') OR ("Account Type" = "Account Type"::"G/L Account") THEN
        //        "Currency Code" := Vend."Currency Code";
        //      IF ("Account Type" = "Account Type"::"Bank Account") AND ("Currency Code" = '') THEN
        //        "Currency Code" := Vend."Currency Code";
        //      ClearBalancePostingGroups;
        //      IF (Vend."Pay-to Vendor No." <> '') AND (Vend."Pay-to Vendor No." <> "Bal. Account No.") THEN
        //        IF NOT CONFIRM(Text014,FALSE,Vend.TABLECAPTION,Vend."No.",Vend.FIELDCAPTION("Pay-to Vendor No."),
        //             Vend."Pay-to Vendor No.")
        //        THEN
        //          ERROR('');
        //      VALIDATE("Payment Terms Code");
        //      CheckPaymentTolerance;
        //    END;
        //{=======} MODIFIED
        //    BEGIN
        //      Vend.GET("Bal. Account No.");
        //      Vend.CheckBlockedVendOnJnls(Vend,"Document Type",FALSE);
        //      IF Vend."IC Partner Code" <> '' THEN BEGIN
        //        IF GenJnlTemplate.GET("Journal Template Name") THEN;
        //        IF (Vend."IC Partner Code" <> '') AND ICPartner.GET(Vend."IC Partner Code") THEN BEGIN
        //          ICPartner.CheckICPartnerIndirect(FORMAT("Bal. Account Type"),"Bal. Account No.");
        //          "IC Partner Code" := Vend."IC Partner Code";
        //        END;
        //      END;
        //      "Bal. Account Name" := Vend.Name;//***************************ADDED
        //      IF "Account No." = '' THEN
        //        Description := Vend.Name;
        //
        //      "Payment Method Code" := Vend."Payment Method Code";
        //      VALIDATE("Recipient Bank Account",Vend."Preferred Bank Account");
        //      "Posting Group" := Vend."Vendor Posting Group";
        //      "Salespers./Purch. Code" := Vend."Purchaser Code";
        //      "Payment Terms Code" := Vend."Payment Terms Code";
        //      VALIDATE("Bill-to/Pay-to No.","Bal. Account No.");
        //      VALIDATE("Sell-to/Buy-from No.","Bal. Account No.");
        //      IF ("Account No." = '') OR ("Account Type" = "Account Type"::"G/L Account") THEN
        //        "Currency Code" := Vend."Currency Code";
        //      IF ("Account Type" = "Account Type"::"Bank Account") AND ("Currency Code" = '') THEN
        //        "Currency Code" := Vend."Currency Code";
        //      ClearBalancePostingGroups;
        //      IF (Vend."Pay-to Vendor No." <> '') AND (Vend."Pay-to Vendor No." <> "Bal. Account No.") THEN
        //        IF NOT CONFIRM(Text014,FALSE,Vend.TABLECAPTION,Vend."No.",Vend.FIELDCAPTION("Pay-to Vendor No."),
        //             Vend."Pay-to Vendor No.")
        //        THEN
        //          ERROR('');
        //      VALIDATE("Payment Terms Code");
        //      CheckPaymentTolerance;
        //    END;
        //{=======} TARGET
        //    GetVendorBalAccount;
        //  "Bal. Account Type"::Employee:
        //    GetEmployeeBalAccount;
        //{<<<<<<<}
        //  "Bal. Account Type"::"Bank Account":
        //{>>>>>>>} ORIGINAL
        //    BEGIN
        //      BankAcc.GET("Bal. Account No.");
        //      BankAcc.TESTFIELD(Blocked,FALSE);
        //      IF "Account No." = '' THEN
        //        Description := BankAcc.Name;
        //
        //      IF ("Account No." = '') OR
        //         ("Account Type" IN
        //          ["Account Type"::"G/L Account","Account Type"::"Bank Account"])
        //      THEN BEGIN
        //        "Posting Group" := '';
        //        "Salespers./Purch. Code" := '';
        //        "Payment Terms Code" := '';
        //      END;
        //      IF BankAcc."Currency Code" = '' THEN BEGIN
        //        IF "Account No." = '' THEN
        //          "Currency Code" := '';
        //      END ELSE
        //        IF SetCurrencyCode("Bal. Account Type","Bal. Account No.") THEN
        //          BankAcc.TESTFIELD("Currency Code","Currency Code")
        //        ELSE
        //          "Currency Code" := BankAcc."Currency Code";
        //      ClearBalancePostingGroups;
        //    END;
        //{=======} MODIFIED
        //    BEGIN
        //      BankAcc.GET("Bal. Account No.");
        //      "Bal. Account Name" := BankAcc.Name;//***************************ADDED
        //      BankAcc.TESTFIELD(Blocked,FALSE);
        //      IF "Account No." = '' THEN
        //        IF Rec."CC Document Type"=Rec."CC Document Type"::" " THEN //***************************ADDED
        //          Description := BankAcc.Name;
        //
        //      IF ("Account No." = '') OR
        //         ("Account Type" IN
        //          ["Account Type"::"G/L Account","Account Type"::"Bank Account"])
        //      THEN BEGIN
        //        "Posting Group" := '';
        //        "Salespers./Purch. Code" := '';
        //        "Payment Terms Code" := '';
        //      END;
        //      IF BankAcc."Currency Code" = '' THEN BEGIN
        //        IF "Account No." = '' THEN
        //          "Currency Code" := '';
        //      END ELSE
        //        IF SetCurrencyCode("Bal. Account Type","Bal. Account No.") THEN
        //          BankAcc.TESTFIELD("Currency Code","Currency Code")
        //        ELSE
        //          "Currency Code" := BankAcc."Currency Code";
        //      ClearBalancePostingGroups;
        //    END;
        //{=======} TARGET
        //    GetBankBalAccount;
        //{<<<<<<<}
        //  "Bal. Account Type"::"Fixed Asset":
        //{>>>>>>>} ORIGINAL
        //    BEGIN
        //      FA.GET("Bal. Account No.");
        //      FA.TESTFIELD(Blocked,FALSE);
        //      FA.TESTFIELD(Inactive,FALSE);
        //      FA.TESTFIELD("Budgeted Asset",FALSE);
        //      IF "Account No." = '' THEN
        //        Description := FA.Description;
        //
        //      IF "Depreciation Book Code" = '' THEN BEGIN
        //        FASetup.GET;
        //        "Depreciation Book Code" := FASetup."Default Depr. Book";
        //        IF NOT FADeprBook.GET("Bal. Account No.","Depreciation Book Code") THEN
        //          "Depreciation Book Code" := '';
        //      END;
        //      IF "Depreciation Book Code" <> '' THEN BEGIN
        //        FADeprBook.GET("Bal. Account No.","Depreciation Book Code");
        //        "Posting Group" := FADeprBook."FA Posting Group";
        //      END;
        //      GetFAVATSetup;
        //      GetFAAddCurrExchRate;
        //    END;
        //{=======} MODIFIED
        //    BEGIN
        //      FA.GET("Bal. Account No.");
        //      FA.TESTFIELD(Blocked,FALSE);
        //      FA.TESTFIELD(Inactive,FALSE);
        //      FA.TESTFIELD("Budgeted Asset",FALSE);
        //      IF "Account No." = '' THEN
        //        Description := FA.Description;
        //      "Bal. Account Name" := FA.Description;//***************************ADDED
        //      IF "Depreciation Book Code" = '' THEN BEGIN
        //        FASetup.GET;
        //        "Depreciation Book Code" := FASetup."Default Depr. Book";
        //        IF NOT FADeprBook.GET("Bal. Account No.","Depreciation Book Code") THEN
        //          "Depreciation Book Code" := '';
        //      END;
        //      IF "Depreciation Book Code" <> '' THEN BEGIN
        //        FADeprBook.GET("Bal. Account No.","Depreciation Book Code");
        //        "Posting Group" := FADeprBook."FA Posting Group";
        //      END;
        //      GetFAVATSetup;
        //      GetFAAddCurrExchRate;
        //    END;
        //{=======} TARGET
        //    GetFABalAccount;
        //{<<<<<<<}
        //  "Bal. Account Type"::"IC Partner":
        //{>>>>>>>} ORIGINAL
        //    BEGIN
        //      ICPartner.GET("Bal. Account No.");
        //      IF "Account No." = '' THEN
        //        Description := ICPartner.Name;
        //
        //      IF ("Account No." = '') OR ("Account Type" = "Account Type"::"G/L Account") THEN
        //        "Currency Code" := ICPartner."Currency Code";
        //      IF ("Account Type" = "Account Type"::"Bank Account") AND ("Currency Code" = '') THEN
        //        "Currency Code" := ICPartner."Currency Code";
        //      ClearBalancePostingGroups;
        //      "IC Partner Code" := "Bal. Account No.";
        //    END;
        //{=======} MODIFIED
        //    BEGIN
        //      ICPartner.GET("Bal. Account No.");
        //      IF "Account No." = '' THEN
        //        Description := ICPartner.Name;
        //      "Bal. Account Name" := ICPartner.Name;//***************************ADDED
        //      IF ("Account No." = '') OR ("Account Type" = "Account Type"::"G/L Account") THEN
        //        "Currency Code" := ICPartner."Currency Code";
        //      IF ("Account Type" = "Account Type"::"Bank Account") AND ("Currency Code" = '') THEN
        //        "Currency Code" := ICPartner."Currency Code";
        //      ClearBalancePostingGroups;
        //      "IC Partner Code" := "Bal. Account No.";
        //    END;
        //{=======} TARGET
        //    GetICPartnerBalAccount;
        //{<<<<<<<}
        //END;
        //
        //VALIDATE("Currency Code");
        //VALIDATE("Bal. VAT Prod. Posting Group");
        //UpdateLineBalance;
        //UpdateSource;
        //CreateDim(
        //  DimMgt.TypeToTableID1("Bal. Account Type"),"Bal. Account No.",
        //  DimMgt.TypeToTableID1("Account Type"),"Account No.",
        //  DATABASE::Job,"Job No.",
        //  DATABASE::"Salesperson/Purchaser","Salespers./Purch. Code",
        //  DATABASE::Campaign,"Campaign No.");
        //
        //VALIDATE("IC Partner G/L Acc. No.",GetDefaultICPartnerGLAccNo);
        //ValidateApplyRequirements(Rec);
        */
        //end;


        //Unsupported feature: Code Modification on "Amount(Field 13).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        ValidateAmount(TRUE);

        GetDerogatorySetup;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        #1..3



        //***************************************
        //***************************************
        IF NOT AFK_CanUpdateAchatDevise THEN BEGIN
          IF Rec."Origin Type" = Rec."Origin Type"::LC THEN
            IF Rec."Origin No." <> '' THEN
              ERROR(AFK_Error02);

          IF Rec."Origin Type" = Rec."Origin Type"::EchPayment THEN
            IF Rec."Origin No." <> '' THEN
              ERROR(AFK_Error02);
        END;
        //***************************************
        //***************************************
        */
        //end;
        field(50000; "MoneyTech Import No."; Code[20])
        {
            Caption = 'MoneyTech Import N°';
            Editable = false;
        }
        field(50001; TypeProvision; Option)
        {
            OptionCaption = ' ,FraisAnn,Order,Transport,Passage,Transfer,VarStock,TransportVente,Cargo,PassageTransfer';
            OptionMembers = " ",FraisAnn,"Order",Transport,Passage,Transfer,VarStock,TransportVente,Cargo,PassageTransfer;
        }
        field(50002; TiersProvisionNo; Code[20])
        {
        }
        field(50003; "DateDeb Provisions"; Date)
        {
        }
        field(50004; "DateFin Provisions"; Date)
        {
        }
        field(50010; "CC Document Type"; Option)
        {
            Caption = 'CC Document Type';
            OptionCaption = ' ,Chèque règlement,Chèque caution,Chèque commande encours,Espèces,Virement,Orange Money,Traite,Airtel Money,Mvola Money,Orange Money MarchandAirtel Money Marchand';
            OptionMembers = " ",ChequeNormal,ChequeCaution,ChequeGarantie,Especes,Virement,MobileMoney,Traite,MobileMoney2,MobileMoney3,MobileMoney4,MobileMoney5;

            trigger OnValidate()
            var
                GenJnlBatch: Record "Gen. Journal Batch";
            begin
                //*****************************************************************************
                //TRESORERIE
                //*****************************************************************************
                //Ne pas changer du compte ORANGE MNY vers un autre compte
                IF xRec."CC Document Type" IN [Rec."CC Document Type"::MobileMoney, Rec."CC Document Type"::MobileMoney2
                  , Rec."CC Document Type"::MobileMoney3, Rec."CC Document Type"::MobileMoney4
                  , Rec."CC Document Type"::MobileMoney5, Rec."CC Document Type"::Traite] THEN BEGIN
                    IF xRec."CC Document Type" <> "CC Document Type" THEN
                        //ERROR(AFK_Error01);
                        GenJnlBatch.GET("Journal Template Name", "Journal Batch Name");
                    "Bal. Account Type" := Rec."Bal. Account Type"::"Bank Account";
                    VALIDATE("Bal. Account No.", GenJnlBatch."Bal. Account No.");
                END;



                //Saisie de traite
                IF "CC Document Type" = Rec."CC Document Type"::Traite THEN BEGIN
                    AddOnSetup.GET;
                    AddOnSetup.TESTFIELD(AddOnSetup."Compte Effet A Recevoir");
                    "Bal. Account Type" := Rec."Bal. Account Type"::"G/L Account";
                    VALIDATE("Bal. Account No.", AddOnSetup."Compte Effet A Recevoir");
                END;


                //Saisie sur compte ORANGE MONEY
                IF "CC Document Type" = Rec."CC Document Type"::MobileMoney THEN BEGIN
                    AddOnSetup.GET;
                    AddOnSetup.TESTFIELD(AddOnSetup."CCL Mobile Money Acc 1");
                    "Bal. Account Type" := Rec."Bal. Account Type"::"Bank Account";
                    VALIDATE("Bal. Account No.", AddOnSetup."CCL Mobile Money Acc 1");
                END;

                IF "CC Document Type" = Rec."CC Document Type"::MobileMoney2 THEN BEGIN
                    AddOnSetup.GET;
                    AddOnSetup.TESTFIELD(AddOnSetup."CCL Mobile Money Acc 2");
                    "Bal. Account Type" := Rec."Bal. Account Type"::"Bank Account";
                    VALIDATE("Bal. Account No.", AddOnSetup."CCL Mobile Money Acc 2");
                END;

                IF "CC Document Type" = Rec."CC Document Type"::MobileMoney3 THEN BEGIN
                    AddOnSetup.GET;
                    AddOnSetup.TESTFIELD(AddOnSetup."CCL Mobile Money Acc 3");
                    "Bal. Account Type" := Rec."Bal. Account Type"::"Bank Account";
                    VALIDATE("Bal. Account No.", AddOnSetup."CCL Mobile Money Acc 3");
                END;

                IF "CC Document Type" = Rec."CC Document Type"::MobileMoney4 THEN BEGIN
                    AddOnSetup.GET;
                    AddOnSetup.TESTFIELD(AddOnSetup."CCL Mobile Money Acc 4");
                    "Bal. Account Type" := Rec."Bal. Account Type"::"Bank Account";
                    VALIDATE("Bal. Account No.", AddOnSetup."CCL Mobile Money Acc 4");
                END;

                IF "CC Document Type" = Rec."CC Document Type"::MobileMoney5 THEN BEGIN
                    AddOnSetup.GET;
                    AddOnSetup.TESTFIELD(AddOnSetup."CCL Mobile Money Acc 5");
                    "Bal. Account Type" := Rec."Bal. Account Type"::"Bank Account";
                    VALIDATE("Bal. Account No.", AddOnSetup."CCL Mobile Money Acc 5");
                END;


                IF "CC Document Type" = Rec."CC Document Type"::ChequeCaution THEN BEGIN
                    ERROR(AFK_Error03);
                END;

                //*****************************************************************************
            end;
        }
        field(50011; "Check No."; Code[20])
        {
            Caption = 'Check No.';
        }
        field(50012; "Check Date"; Date)
        {
            Caption = 'Check Date';
        }
        field(50013; "Customer Name"; Text[50])
        {
            Caption = 'Customer Name';
            Editable = false;
            FieldClass = Normal;
        }
        field(50014; "Origin Type"; Option)
        {
            Editable = false;
            OptionCaption = ' ,LC,EchPayment';
            OptionMembers = " ",LC,EchPayment;
        }
        field(50015; "Origin No."; Code[20])
        {
            Editable = false;
        }
        field(50016; "Origin Line No."; Integer)
        {
            Editable = false;
        }
        field(50017; CodeDepotProvisions; Code[10])
        {
            Caption = 'From Location';
            Editable = false;
        }
        field(50018; NumDocProvisions; Code[10])
        {
            Caption = 'BE Number';
            Editable = false;
        }
        field(50019; CodeArticleProvisions; Code[20])
        {
            Caption = 'Item No';
            Editable = false;
        }
        field(50020; CodeDepotDestProv; Code[10])
        {
            Caption = 'To Location';
            Editable = false;
        }
        field(50021; VolumeProvisions; Decimal)
        {
            Caption = 'Volume';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(50022; TransporterNameProvisions; Text[50])
        {
            Caption = 'Tranporter Name';
            Editable = false;
        }
        field(50023; VendorCodeProvisions; Code[20])
        {
            Caption = 'Vendor Code (Provisions)';
            Editable = false;
        }
        field(50024; Destinataire; Text[50])
        {
        }
        field(50025; "Cargo Entry Type"; Option)
        {
            Caption = 'Entry Type';
            Editable = false;
            OptionCaption = 'Purchase,Sale,Positive Adjmt.,Negative Adjmt.,Transfer,Consumption,Output, ,Assembly Consumption,Assembly Output';
            OptionMembers = Purchase,Sale,"Positive Adjmt.","Negative Adjmt.",Transfer,Consumption,Output," ","Assembly Consumption","Assembly Output";
        }
        field(50026; FraisProvisions; Decimal)
        {
            Caption = 'Frais pour provisions';
            Editable = false;
        }
        field(50027; "Bal. Account Name"; Text[100])
        {
            Caption = 'Nom du compte contrepartie';
            Editable = false;
        }
    }


    //Unsupported feature: Code Modification on "OnDelete".

    //trigger OnDelete()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    ApprovalsMgmt.OnCancelGeneralJournalLineApprovalRequest(Rec);

    // Lines are deleted 1 by 1, this actually check if this is the last line in the General journal Bach
    #4..8

    TESTFIELD("Check Printed",FALSE);

    ClearCustVendApplnEntry;
    ClearAppliedGenJnlLine;
    DeletePaymentFileErrors;
    #15..25
      "Journal Batch Name",0,'',"Line No.");

    VALIDATE("Incoming Document Entry No.",0);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..11
    //***************************************************************************
    //***************************************************************************
    IF Rec."MoneyTech Import No."<>'' THEN
     ERROR(TextErrImportMoneyTech);

    //***************************************************************************
    //***************************************************************************

    #12..28
    */
    //end;


    //Unsupported feature: Code Modification on "OnModify".

    //trigger OnModify()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    SetLastModifiedDateTime;

    TESTFIELD("Check Printed",FALSE);
    IF ("Applies-to ID" = '') AND (xRec."Applies-to ID" <> '') THEN
      ClearCustVendApplnEntry;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..5

    //***************************************************************************
    //***************************************************************************
    IF Rec."MoneyTech Import No."<>'' THEN
     ERROR(TextErrImportMoneyTech);

    AFKSecMgt.CheckAccessUserJournal(Rec,TRUE,FALSE);
    //***************************************************************************
    //***************************************************************************
    */
    //end;


    //Unsupported feature: Code Modification on "CheckDirectPosting(PROCEDURE 217)".

    //procedure CheckDirectPosting();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IsHandled := FALSE;
    OnBeforeCheckDirectPosting(GLAccount,IsHandled,Rec);
    IF IsHandled THEN
      EXIT;

    GLAccount.TESTFIELD("Direct Posting",TRUE);

    OnAfterCheckDirectPosting(GLAccount,Rec);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..4
    IF "CC Document Type"=Rec."CC Document Type"::" " THEN //**************************************ADDED
    #6..8
    */
    //end;


    //Unsupported feature: Code Modification on "UpdateDescription(PROCEDURE 43)".

    //procedure UpdateDescription();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IF NOT IsAdHocDescription THEN
      Description := Name;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    //*********************************************************
    //REMOVED--AFK Laisser la description manuelle dans ce cas
    {
    IF NOT IsAdHocDescription THEN
      Description := Name;
    }

    //ADDED
    IF Rec."CC Document Type"=Rec."CC Document Type"::" " THEN
      IF NOT IsAdHocDescription THEN
        Description := Name;
    */
    //end;

    //Unsupported feature: Variable Insertion (Variable: AfkCopyLabels) (VariableCollection) on "CopyFromInvoicePostBuffer(PROCEDURE 112)".



    //Unsupported feature: Code Modification on "CopyFromInvoicePostBuffer(PROCEDURE 112)".

    //procedure CopyFromInvoicePostBuffer();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    "Account No." := InvoicePostBuffer."G/L Account";
    "System-Created Entry" := InvoicePostBuffer."System-Created Entry";
    "Gen. Bus. Posting Group" := InvoicePostBuffer."Gen. Bus. Posting Group";
    #4..23
    "VAT Difference" := InvoicePostBuffer."VAT Difference";
    "VAT Base Before Pmt. Disc." := InvoicePostBuffer."VAT Base Before Pmt. Disc.";

    OnAfterCopyGenJnlLineFromInvPostBuffer(InvoicePostBuffer,Rec);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..26

    //***********************************************************
    //JN004******************************************************
    AddOnSetup.GET;
    IF "Source Type" = "Source Type"::Vendor THEN
      AfkCopyLabels := AddOnSetup."Activer libelles compta Fsseur";
    IF "Source Type" = "Source Type"::Vendor THEN
      AfkCopyLabels := AddOnSetup."Activer libelles Compta Client";

    IF AfkCopyLabels THEN BEGIN
      IF InvoicePostBuffer."Posting Description"<>'' THEN
        GenJnlLine.Description :=InvoicePostBuffer."Posting Description";
    END;
    //***********************************************************
    //JN004******************************************************

    OnAfterCopyGenJnlLineFromInvPostBuffer(InvoicePostBuffer,Rec);
    */
    //end;


    //Unsupported feature: Code Modification on "GetGLBalAccount(PROCEDURE 121)".

    //procedure GetGLBalAccount();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    GLAcc.GET("Bal. Account No.");
    CheckGLAcc(GLAcc);
    IF "Account No." = '' THEN BEGIN
      Description := GLAcc.Name;
      "Currency Code" := '';
    END;
    IF ("Account No." = '') OR
    #8..26
        ClearBalancePostingGroups;

    OnAfterAccountNoOnValidateGetGLBalAccount(Rec,GLAcc);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..3
      IF Rec."CC Document Type"=Rec."CC Document Type"::" " THEN //***************************ADDED
      Description := GLAcc.Name;
      "Bal. Account Name" := GLAcc.Name;//***************************ADDED
    #5..29
    */
    //end;


    //Unsupported feature: Code Modification on "GetCustomerAccount(PROCEDURE 47)".

    //procedure GetCustomerAccount();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    Cust.GET("Account No.");
    Cust.CheckBlockedCustOnJnls(Cust,"Document Type",FALSE);
    CheckICPartner(Cust."IC Partner Code","Account Type","Account No.");
    #4..22
        ERROR('');
    VALIDATE("Payment Terms Code");
    CheckPaymentTolerance;

    OnAfterAccountNoOnValidateGetCustomerAccount(Rec,Cust,CurrFieldNo);
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..25
    //******************************************************************
    "Customer Name" := Cust.Name;
    //******************************************************************

    OnAfterAccountNoOnValidateGetCustomerAccount(Rec,Cust,CurrFieldNo);
    */
    //end;

    procedure AFK_SetCanUpdateAchatDevise(CanUpdate: Boolean)
    begin
        //*********************************************
        AFK_CanUpdateAchatDevise := CanUpdate;
    end;

    var
        TextErrImportMoneyTech: Label 'Vous pouvez pas modifier cette ligne car il s''agit d''une écriture importée à partir de MoneyTech.';
        //AFKGLMgt: Codeunit "50014";
        //AFKSecMgt: Codeunit "50016";
        AFK_Error01: Label 'Vous ne pouvez plus modifier ce champ. Supprimez la ligne plutôt.';
        AddOnSetup: Record "50000";
        AFK_Error02: Label 'L''écriture provient d''une lettre de crédit. Vous ne pouvez pas changer le montant';
        AFK_CanUpdateAchatDevise: Boolean;
        AFK_Error03: Label 'Cette option n''est plus valide !';
}

