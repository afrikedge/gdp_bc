xmlport 50008 "SEPA MT101"
{
    Caption = 'SEPA MT101';
    //DefaultNamespace = 'urn:iso:std:iso:20022:tech:xsd:pain.001.001.03';
    Direction = Export;
    // Encoding = UTF8;
    FieldDelimiter = '<None>';
    FieldSeparator = '<None>';
    Format = VariableText;
    FormatEvaluate = Legacy;
    RecordSeparator = '<None>';
    TableSeparator = '<None>';
    TextEncoding = UTF8;
    //UseDefaultNamespace = true;

    schema
    {
        textelement(Root)
        {
            tableelement("Gen. Journal Line"; "Gen. Journal Line")
            {
                XmlName = 'Document';
                UseTemporary = true;
            }
            tableelement(companyinformation; "Company Information")
            {
                XmlName = 'GeneralInformation';
                textelement(messageid)
                {
                    XmlName = 'SenderReference';
                }
                textelement(messageindex)
                {
                    XmlName = 'MessageIndexTotal';
                }
                textelement(customeribanaccount)
                {
                    XmlName = 'CustomerIBANAccount';
                }
                textelement(customername)
                {
                    XmlName = 'CustomerName';
                }
                textelement(CustomerAdress)
                {
                }
                textelement(CustomerAdress2)
                {
                }
                textelement(CustomerAdress3)
                {
                }
                textelement(customerbicaccount)
                {
                    XmlName = 'CustomerBICAccount';
                }
                textelement(executiondate)
                {
                    XmlName = 'ExecutionDate';
                }

                trigger OnAfterGetRecord()
                begin
                    if not PaymentExportData.GetPreserveNonLatinCharacters then
                        PaymentExportData.CompanyInformationConvertToLatin(CompanyInformation);
                end;
            }
            tableelement(paymentexportdatagroup; "Payment Export Data")
            {
                XmlName = 'PmtInf';
                UseTemporary = true;
            }
            tableelement(paymentexportdata; "Payment Export Data")
            {
                LinkFields = "Sender Bank BIC" = FIELD("Sender Bank BIC"), "SEPA Instruction Priority Text" = FIELD("SEPA Instruction Priority Text"), "Transfer Date" = FIELD("Transfer Date"), "SEPA Batch Booking" = FIELD("SEPA Batch Booking"), "SEPA Charge Bearer Text" = FIELD("SEPA Charge Bearer Text");
                LinkTable = PaymentExportDataGroup;
                XmlName = 'CdtTrfTxInf';
                UseTemporary = true;
                textelement(transactionref)
                {
                    XmlName = 'TransactionRef';
                }
                textelement(curramount)
                {
                    XmlName = 'CurrAmount';
                }
                textelement(VendorBICAccount)
                {
                }
                textelement(VendorIBANAccount)
                {
                }
                textelement(VendorName)
                {
                }
                textelement(VendorAdress)
                {
                }
                textelement(VendorAdress2)
                {
                }
                textelement(VendorAdress3)
                {
                }
                textelement(RemittanceText1)
                {
                }
                textelement(DetailsOfCharges)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    TransactionRef := ':21:' + PaymentExportData."Document No." + NewLine;
                    CurrAmount := StrSubstNo('%1%2%3', ':32B:', PaymentExportData."Currency Code", Format(PaymentExportData.Amount, 0, 9)) + NewLine;
                    VendorBICAccount := ':57A:' + PaymentExportData."Recipient Bank BIC" + NewLine;
                    VendorIBANAccount := ':59:/' + PaymentExportData."Recipient Bank Acc. No." + NewLine;
                    RemittanceText1 := ':70:' + CopyStr(PaymentExportData."Applies-to Ext. Doc. No.", 1, 30) + NewLine;
                    DetailsOfCharges := ':71A:OUR' + NewLine;
                    VendorName := CopyStr(PaymentExportData."Recipient Name", 1, 35) + NewLine;

                    VendorAdress := CopyStr(PaymentExportData."Recipient Address", 1, 35);
                    if VendorAdress <> '' then VendorAdress := VendorAdress + NewLine;

                    VendorAdress2 := PaymentExportData."Recipient City";
                    if VendorAdress2 <> '' then VendorAdress2 := VendorAdress2 + NewLine;

                    VendorAdress3 := PaymentExportData."Recipient Post Code";
                    if VendorAdress3 <> '' then VendorAdress3 := VendorAdress3 + NewLine;
                end;
            }
            tableelement(Integer; Integer)
            {
                XmlName = 'EndOfMessage';
                SourceTableView = SORTING(Number) WHERE(Number = CONST(1));
                textelement(EOF)
                {
                }
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    trigger OnPreXmlPort()
    begin
        InitData;
    end;

    var
        TempPaymentExportRemittanceText: Record "Payment Export Remittance Text" temporary;
        NoDataToExportErr: Label 'There is no data to export.', Comment = '%1=Field;%2=Value;%3=Value';

    local procedure InitData()
    var
        SEPACTFillExportBuffer: Codeunit "SEPA CT-Fill Export Buffer";
        PaymentGroupNo: Integer;
        CompanyInformation2: Record "Company Information";
    begin
        SEPACTFillExportBuffer.FillExportBuffer("Gen. Journal Line", PaymentExportData);
        PaymentExportData.GetRemittanceTexts(TempPaymentExportRemittanceText);

        //NoOfTransfers := FORMAT(PaymentExportData.COUNT);
        MessageID := ':20:' + PaymentExportData."Message ID" + NewLine;
        MessageIndex := ':28D:1/1' + NewLine;
        CustomerIBANAccount := ':50H:/' + PaymentExportData."Sender Bank Account No." + NewLine;
        CustomerBICAccount := ':52A:' + PaymentExportData."Sender Bank BIC" + NewLine;
        //ExecutionDate := ':30:'+ FORMAT(PaymentExportData."Transfer Date", 0, '<Year>/<Month>/ <Day,2>')  + NewLine;
        ExecutionDate := ':30:' + FormatDate(PaymentExportData."Transfer Date") + NewLine;
        //CreatedDateTime := FORMAT(CURRENTDATETIME,19,9);
        //PaymentExportData.CALCSUMS(Amount);
        //ControlSum := FORMAT(PaymentExportData.Amount,0,9);
        CompanyInformation2.Get;
        CustomerName := CopyStr(CompanyInformation2.Name, 1, 35) + NewLine;
        CustomerAdress := CopyStr(CompanyInformation2.Address, 1, 35);
        if CustomerAdress <> '' then CustomerAdress := CustomerAdress + NewLine;

        CustomerAdress2 := CopyStr(CompanyInformation2."Address 2", 1, 35);
        if CustomerAdress2 <> '' then CustomerAdress2 := CustomerAdress2 + NewLine;

        CustomerAdress3 := CompanyInformation2.City;
        if CustomerAdress3 <> '' then CustomerAdress3 := CustomerAdress3 + NewLine;

        EOF := '-}';

        PaymentExportData.SetCurrentKey(
          "Sender Bank BIC", "SEPA Instruction Priority Text", "Transfer Date",
          "SEPA Batch Booking", "SEPA Charge Bearer Text");

        if not PaymentExportData.FindSet then
            Error(NoDataToExportErr);

        InitPmtGroup;
        repeat
            if IsNewGroup then begin
                InsertPmtGroup(PaymentGroupNo);
                InitPmtGroup;
            end;
            PaymentExportDataGroup."Line No." += 1;
            PaymentExportDataGroup.Amount += PaymentExportData.Amount;
        until PaymentExportData.Next = 0;
        InsertPmtGroup(PaymentGroupNo);
    end;

    local procedure IsNewGroup(): Boolean
    begin
        exit(
          (PaymentExportData."Sender Bank BIC" <> PaymentExportDataGroup."Sender Bank BIC") or
          (PaymentExportData."SEPA Instruction Priority Text" <> PaymentExportDataGroup."SEPA Instruction Priority Text") or
          (PaymentExportData."Transfer Date" <> PaymentExportDataGroup."Transfer Date") or
          (PaymentExportData."SEPA Batch Booking" <> PaymentExportDataGroup."SEPA Batch Booking") or
          (PaymentExportData."SEPA Charge Bearer Text" <> PaymentExportDataGroup."SEPA Charge Bearer Text"));
    end;

    local procedure InitPmtGroup()
    begin
        PaymentExportDataGroup := PaymentExportData;
        PaymentExportDataGroup."Line No." := 0; // used for counting transactions within group
        PaymentExportDataGroup.Amount := 0; // used for summarizing transactions within group
    end;

    local procedure InsertPmtGroup(var PaymentGroupNo: Integer)
    begin
        PaymentGroupNo += 1;
        PaymentExportDataGroup."Entry No." := PaymentGroupNo;
        PaymentExportDataGroup."Payment Information ID" :=
          CopyStr(
            StrSubstNo('%1/%2', PaymentExportData."Message ID", PaymentGroupNo),
            1, MaxStrLen(PaymentExportDataGroup."Payment Information ID"));
        PaymentExportDataGroup.Insert;
    end;

    local procedure NewLine(): Text
    var
        Char10: Char;
        Char13: Char;
    begin
        Char13 := 13;
        Char10 := 10;
        exit(Format(Char13) + Format(Char10));
    end;

    local procedure FormatDate(Date1: Date): Text
    var
        d: Integer;
        m: Integer;
        y: Integer;
        day: Text;
        month: Text;
        year: Text;
    begin
        d := Date2DMY(Date1, 1);
        if StrLen(Format(d)) = 1 then
            day := '0' + Format(d)
        else
            day := Format(d);

        m := Date2DMY(Date1, 2);
        if StrLen(Format(m)) = 1 then
            month := '0' + Format(m)
        else
            month := Format(m);

        y := Date2DMY(Date1, 3);
        year := CopyStr(Format(y), 3, 2);

        exit(year + month + day);
    end;
}

