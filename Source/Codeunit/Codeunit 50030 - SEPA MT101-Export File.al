codeunit 50030 "SEPA MT101-Export File"
{
    Permissions = TableData "Data Exch. Field" = rimd;
    TableNo = "Gen. Journal Line";

    trigger OnRun()
    var
        BankAccount: Record "Bank Account";
        ExpUserFeedbackGenJnl: Codeunit "Exp. User Feedback Gen. Jnl.";
    begin
        // LockTable();
        // BankAccount.Get("Bal. Account No.");
        // if Export(Rec, BankAccount.GetPaymentExportXMLPortID) then
        //     ExpUserFeedbackGenJnl.SetExportFlagOnGenJnlLine(Rec);
    end;

    var
        ExportToServerFile: Boolean;
        Text001: Label 'Export terminé !\Fichier crée : %1';

    procedure Export(var GenJnlLine: Record "Gen. Journal Line"; XMLPortID: Integer): Boolean
    var
    // CreditTransferRegister: Record "Credit Transfer Register";
    // TempBlob: Record TempBlob;
    // FileManagement: Codeunit "File Management";
    // OutStr: OutStream;
    // UseCommonDialog: Boolean;
    // CreatedFile: Text;
    begin
        // TempBlob.Init;
        // TempBlob.Blob.CreateOutStream(OutStr);
        // XMLPORT.Export(XMLPortID, OutStr, GenJnlLine);

        // CreditTransferRegister.FindLast;
        // UseCommonDialog := not ExportToServerFile;
        // //IF FileManagement.BLOBExport(TempBlob,STRSUBSTNO('%1.TXT',CreditTransferRegister.Identifier),UseCommonDialog) <> '' THEN
        // //  SetCreditTransferRegisterToFileCreated(CreditTransferRegister,TempBlob);

        // CreatedFile := FileManagement.AFK_BLOBExportEncrypt(TempBlob, StrSubstNo('%1.TXT', CreditTransferRegister.Identifier), UseCommonDialog, CreditTransferRegister.Identifier);
        // if CreatedFile <> '' then
        //     SetCreditTransferRegisterToFileCreated(CreditTransferRegister, TempBlob);

        // Message(Text001, CreatedFile);

        // exit(CreditTransferRegister.Status = CreditTransferRegister.Status::"File Created");
    end;

    // local procedure SetCreditTransferRegisterToFileCreated(var CreditTransferRegister: Record "Credit Transfer Register"; var TempBlob: Record TempBlob)
    // begin
    //     CreditTransferRegister.Status := CreditTransferRegister.Status::"File Created";
    //     CreditTransferRegister."Exported File" := TempBlob.Blob;
    //     CreditTransferRegister.Modify;
    // end;

    procedure EnableExportToServerFile()
    begin
        ExportToServerFile := true;
    end;
}

