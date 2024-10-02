tableextension 50054 "A02 Payment Export Data" extends "Payment Export Data"
{
    fields
    {
        field(50000; SenderBankLongAccNum; Code[50])
        {
        }
        field(50001; VendRecipientBankAccLongNum; Code[50])
        {
        }
        field(50002; CustRecipientBankAccLongNum; Code[50])
        {
        }
    }


    //Unsupported feature: Code Modification on "SetCustomerAsRecipient(PROCEDURE 2)".

    //procedure SetCustomerAsRecipient();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    "Recipient Name" := Customer.Name;
    "Recipient Address" := Customer.Address;
    "Recipient City" := COPYSTR(Customer.City,1,35);
    #4..14
    "Recipient Bank Acc. No." := COPYSTR(CustomerBankAccount.GetBankAccountNo,1,MAXSTRLEN("Recipient Bank Acc. No."));
    "Recipient Bank Clearing Std." := CustomerBankAccount."Bank Clearing Standard";
    "Recipient Bank Clearing Code" := CustomerBankAccount."Bank Clearing Code";
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..17

    //***********************************************************************
    CustRecipientBankAccLongNum := CustomerBankAccount.AFKGetLongAccountNum();
    //***********************************************************************
    */
    //end;


    //Unsupported feature: Code Modification on "SetVendorAsRecipient(PROCEDURE 10)".

    //procedure SetVendorAsRecipient();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    "Recipient Name" := Vendor.Name;
    "Recipient Address" := Vendor.Address;
    "Recipient City" := COPYSTR(Vendor.City,1,35);
    #4..14
    "Recipient Bank Acc. No." := COPYSTR(VendorBankAccount.GetBankAccountNo,1,MAXSTRLEN("Recipient Bank Acc. No."));
    "Recipient Bank Clearing Std." := VendorBankAccount."Bank Clearing Standard";
    "Recipient Bank Clearing Code" := VendorBankAccount."Bank Clearing Code";
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..17

    //***********************************************************************
    VendRecipientBankAccLongNum := VendorBankAccount.AFKGetLongAccountNum();
    //***********************************************************************
    */
    //end;


    //Unsupported feature: Code Modification on "SetBankAsSenderBank(PROCEDURE 11)".

    //procedure SetBankAsSenderBank();
    //Parameters and return type have not been exported.
    //>>>> ORIGINAL CODE:
    //begin
    /*
    "Sender Bank Name - Data Conv." := BankAccount."Bank Name - Data Conversion";
    "Sender Bank Name" := BankAccount.Name;
    "Sender Bank Address" := BankAccount.Address;
    #4..8
    "Sender Bank BIC" := BankAccount."SWIFT Code";
    "Sender Bank Clearing Std." := BankAccount."Bank Clearing Standard";
    "Sender Bank Clearing Code" := BankAccount."Bank Clearing Code";
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    #1..11

    //***********************************************************************
    SenderBankLongAccNum := BankAccount.AFKGetLongAccountNum();
    //***********************************************************************
    */
    //end;
}

