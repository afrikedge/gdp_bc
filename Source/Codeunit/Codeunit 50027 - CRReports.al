codeunit 50027 CRReports
{

    trigger OnRun()
    begin
        //CreateDdeDeblocage('1602','C0000007');
        //PrintBE(56);
    end;

    var
        SQLMgt: Codeunit "SQL Mgt";
        AddSetup: Record "AddOn Setup";
        Text001: Label 'Une demande de déblocage a été créée sur le CRM pour la commande %1';

    procedure PrintBE(NumBE: Integer)
    var
        Process: DotNet BCProcess;
        ret: Integer;
        programm: Text[200];
        param: Text[200];
        WSHShell: Automation BC;
        WaitForReturn: Boolean;
        WshWindow: Text[10];
        cmdToRun: Text[200];
    begin
        /*
        Process := Process.Process;
        //Process.StartInfo.UseShellExecute := FALSE;
        Process.StartInfo.FileName := 'E:\WinProject\GalanaCrystalReports\GalanaCrystalReports\bin\Debug\GalanaCrystalReports.exe';
        Process.StartInfo.Arguments := STRSUBSTNO('be %1',FORMAT(NumBE));
        //Process.StartInfo.CreateNoWindow := TRUE;
        Process.Start();
        CLEAR(Process);
        */
        
        AddSetup.Get;
        AddSetup.TestField("SQL Server ID");
        AddSetup.TestField("CReports Program Path");
        
        //programm := 'E:\WinProject\GalanaCrystalReports\GalanaCrystalReports\bin\Debug\GalanaCrystalReports.exe';
        
        cmdToRun := StrSubstNo('%1 %2 %3 %4 %5 %6 %7',AddSetup."CReports Program Path",'be',Format(NumBE),
            AddSetup."SQL Server ID",AddSetup."SQL Server DB",AddSetup."SQL User",AddSetup."SQL Password");
        
        //MESSAGE(cmdToRun);
        
        if IsClear(WSHShell) then
          Create(WSHShell,false,true);
        WshWindow := '1'; //Windowsyle: minimized, maximized etc.
        WaitForReturn := true;
        WSHShell.Run(cmdToRun,WshWindow,WaitForReturn);
        Clear(WSHShell);

    end;

    procedure PrintBL(NumBE: Integer)
    var
        Process: DotNet BCProcess;
        ret: Integer;
        programm: Text[200];
        param: Text[200];
        WSHShell: Automation BC;
        WaitForReturn: Boolean;
        WshWindow: Text[10];
        cmdToRun: Text[200];
    begin
        AddSetup.Get;
        AddSetup.TestField("SQL Server ID");
        AddSetup.TestField("CReports Program Path");


        cmdToRun := StrSubstNo('%1 %2 %3 %4 %5 %6 %7',AddSetup."CReports Program Path",'bl',Format(NumBE),
            AddSetup."SQL Server ID",AddSetup."SQL Server DB",AddSetup."SQL User",AddSetup."SQL Password");


        if IsClear(WSHShell) then
          Create(WSHShell,false,true);
        WshWindow := '1'; //Windowsyle: minimized, maximized etc.
        WaitForReturn := true;
        WSHShell.Run(cmdToRun,WshWindow,WaitForReturn);
        Clear(WSHShell);
    end;

    procedure PrintFactureVente(NumBE: Code[20])
    var
        Process: DotNet BCProcess;
        ret: Integer;
        programm: Text[200];
        param: Text[200];
        WSHShell: Automation BC;
        WaitForReturn: Boolean;
        WshWindow: Text[10];
        cmdToRun: Text[200];
    begin
        AddSetup.Get;
        AddSetup.TestField("SQL Server ID");
        AddSetup.TestField("CReports Program Path");


        cmdToRun := StrSubstNo('%1 %2 %3 %4 %5 %6 %7',AddSetup."CReports Program Path",'fv',Format(NumBE),
            AddSetup."SQL Server ID",AddSetup."SQL Server DB",AddSetup."SQL User",AddSetup."SQL Password");


        if IsClear(WSHShell) then
          Create(WSHShell,false,true);
        WshWindow := '1'; //Windowsyle: minimized, maximized etc.
        WaitForReturn := true;
        WSHShell.Run(cmdToRun,WshWindow,WaitForReturn);
        Clear(WSHShell);
    end;

    procedure PrintFactureVenteLubs(NumBE: Code[20])
    var
        Process: DotNet BCProcess;
        ret: Integer;
        programm: Text[200];
        param: Text[200];
        WSHShell: Automation BC;
        WaitForReturn: Boolean;
        WshWindow: Text[10];
        cmdToRun: Text[200];
    begin
        AddSetup.Get;
        AddSetup.TestField("SQL Server ID");
        AddSetup.TestField("CReports Program Path");


        cmdToRun := StrSubstNo('%1 %2 %3 %4 %5 %6 %7',AddSetup."CReports Program Path",'fvLubs',Format(NumBE),
            AddSetup."SQL Server ID",AddSetup."SQL Server DB",AddSetup."SQL User",AddSetup."SQL Password");



        if IsClear(WSHShell) then
          Create(WSHShell,false,true);
        WshWindow := '1'; //Windowsyle: minimized, maximized etc.
        WaitForReturn := true;
        WSHShell.Run(cmdToRun,WshWindow,WaitForReturn);
        Clear(WSHShell);
    end;

    procedure PrintNoteDebit_Facture(NumBE: Code[20])
    var
        Process: DotNet BCProcess;
        ret: Integer;
        programm: Text[200];
        param: Text[200];
        WSHShell: Automation BC;
        WaitForReturn: Boolean;
        WshWindow: Text[10];
        cmdToRun: Text[200];
    begin
        AddSetup.Get;
        AddSetup.TestField("SQL Server ID");
        AddSetup.TestField("CReports Program Path");


        cmdToRun := StrSubstNo('%1 %2 %3 %4 %5 %6 %7',AddSetup."CReports Program Path",'ndf',Format(NumBE),
            AddSetup."SQL Server ID",AddSetup."SQL Server DB",AddSetup."SQL User",AddSetup."SQL Password");


        if IsClear(WSHShell) then
          Create(WSHShell,false,true);
        WshWindow := '1'; //Windowsyle: minimized, maximized etc.
        WaitForReturn := true;
        WSHShell.Run(cmdToRun,WshWindow,WaitForReturn);
        Clear(WSHShell);
    end;

    procedure PrintNoteCredit_Avoir(NumBE: Code[20])
    var
        Process: DotNet BCProcess;
        ret: Integer;
        programm: Text[200];
        param: Text[200];
        WSHShell: Automation BC;
        WaitForReturn: Boolean;
        WshWindow: Text[10];
        cmdToRun: Text[200];
    begin
        AddSetup.Get;
        AddSetup.TestField("SQL Server ID");
        AddSetup.TestField("CReports Program Path");


        cmdToRun := StrSubstNo('%1 %2 %3 %4 %5 %6 %7',AddSetup."CReports Program Path",'nca',Format(NumBE),
            AddSetup."SQL Server ID",AddSetup."SQL Server DB",AddSetup."SQL User",AddSetup."SQL Password");


        if IsClear(WSHShell) then
          Create(WSHShell,false,true);
        WshWindow := '1';
        WaitForReturn := true;
        WSHShell.Run(cmdToRun,WshWindow,WaitForReturn);
        Clear(WSHShell);
    end;

    procedure PrintNoteDebitCredit_Ecriture(EntryNo: Integer)
    var
        Process: DotNet BCProcess;
        ret: Integer;
        programm: Text[200];
        param: Text[200];
        WSHShell: Automation BC;
        WaitForReturn: Boolean;
        WshWindow: Text[10];
        cmdToRun: Text[200];
    begin
        AddSetup.Get;
        AddSetup.TestField("SQL Server ID");
        AddSetup.TestField("CReports Program Path");


        cmdToRun := StrSubstNo('%1 %2 %3 %4 %5 %6 %7',AddSetup."CReports Program Path",'ndce',Format(EntryNo),
            AddSetup."SQL Server ID",AddSetup."SQL Server DB",AddSetup."SQL User",AddSetup."SQL Password");


        if IsClear(WSHShell) then
          Create(WSHShell,false,true);
        WshWindow := '1';
        WaitForReturn := true;
        WSHShell.Run(cmdToRun,WshWindow,WaitForReturn);
        Clear(WSHShell);
    end;

    procedure PrintBL_Lubs(NumBL: Code[20])
    var
        Process: DotNet BCProcess;
        ret: Integer;
        programm: Text[200];
        param: Text[200];
        WSHShell: Automation BC;
        WaitForReturn: Boolean;
        WshWindow: Text[10];
        cmdToRun: Text[200];
    begin
        AddSetup.Get;
        AddSetup.TestField("SQL Server ID");
        AddSetup.TestField("CReports Program Path");


        cmdToRun := StrSubstNo('%1 %2 %3 %4 %5 %6 %7',AddSetup."CReports Program Path",'lubs',Format(NumBL),
            AddSetup."SQL Server ID",AddSetup."SQL Server DB",AddSetup."SQL User",AddSetup."SQL Password");


        if IsClear(WSHShell) then
          Create(WSHShell,false,true);
        WshWindow := '1';
        WaitForReturn := true;
        WSHShell.Run(cmdToRun,WshWindow,WaitForReturn);
        Clear(WSHShell);
    end;

    procedure PrintBL_Lubs_Enreg(NumBL: Code[20])
    var
        Process: DotNet BCProcess;
        ret: Integer;
        programm: Text[200];
        param: Text[200];
        WSHShell: Automation BC;
        WaitForReturn: Boolean;
        WshWindow: Text[10];
        cmdToRun: Text[200];
    begin
        AddSetup.Get;
        AddSetup.TestField("SQL Server ID");
        AddSetup.TestField("CReports Program Path");


        cmdToRun := StrSubstNo('%1 %2 %3 %4 %5 %6 %7',AddSetup."CReports Program Path",'lubenreg',Format(NumBL),
            AddSetup."SQL Server ID",AddSetup."SQL Server DB",AddSetup."SQL User",AddSetup."SQL Password");


        if IsClear(WSHShell) then
          Create(WSHShell,false,true);
        WshWindow := '1';
        WaitForReturn := true;
        WSHShell.Run(cmdToRun,WshWindow,WaitForReturn);
        Clear(WSHShell);
    end;

    procedure CreateDdeDeblocage(OrderNo: Code[20];CustNo: Code[20])
    var
        Process: DotNet BCProcess;
        ret: Integer;
        programm: Text[200];
        param: Text[200];
        WSHShell: Automation BC;
        WaitForReturn: Boolean;
        WshWindow: Text[10];
        cmdToRun: Text[200];
        paramOrder: Text[50];
    begin
        AddSetup.Get;
        AddSetup.TestField("SQL Server ID");
        AddSetup.TestField("CRM Interface Program Path");

        if not AddSetup."Create Dde Deblocage" then exit;

        paramOrder := OrderNo + '|' + CustNo + '|' + UserId;


        cmdToRun := StrSubstNo('%1 %2 %3 %4 %5 %6 %7',AddSetup."CRM Interface Program Path",'crmDeblocage',Format(paramOrder),
            AddSetup."SQL Server ID",AddSetup."SQL Server DB",AddSetup."SQL User",AddSetup."SQL Password");

        //MESSAGE('%1',cmdToRun);

        if IsClear(WSHShell) then
          Create(WSHShell,false,true);
        WshWindow := '1';
        WaitForReturn := true;
        WSHShell.Run(cmdToRun,WshWindow,WaitForReturn);
        Clear(WSHShell);


        Message(StrSubstNo(Text001,OrderNo));
    end;

    procedure CreateCRMCustomer(CustNo: Code[20])
    var
        Process: DotNet BCProcess;
        ret: Integer;
        programm: Text[200];
        param: Text[200];
        WSHShell: Automation BC;
        WaitForReturn: Boolean;
        WshWindow: Text[10];
        cmdToRun: Text[200];
        paramOrder: Text[50];
    begin
        AddSetup.Get;
        AddSetup.TestField("SQL Server ID");
        AddSetup.TestField("CRM Interface Program Path");

        //IF NOT AddSetup."Create Dde Deblocage" THEN EXIT;

        paramOrder := CustNo;


        cmdToRun := StrSubstNo('%1 %2 %3 %4 %5 %6 %7',AddSetup."CRM Interface Program Path",'crmCust',Format(paramOrder),
            AddSetup."SQL Server ID",AddSetup."SQL Server DB",AddSetup."SQL User",AddSetup."SQL Password");

        //MESSAGE('%1',cmdToRun);

        if IsClear(WSHShell) then
          Create(WSHShell,false,true);
        WshWindow := '1';
        WaitForReturn := true;
        WSHShell.Run(cmdToRun,WshWindow,WaitForReturn);
        Clear(WSHShell);


        //MESSAGE(STRSUBSTNO(Text001,OrderNo));
    end;

    procedure PrintProgrammeTournee(NumTournee: Integer)
    var
        Process: DotNet BCProcess;
        ret: Integer;
        programm: Text[200];
        param: Text[200];
        WSHShell: Automation BC;
        WaitForReturn: Boolean;
        WshWindow: Text[10];
        cmdToRun: Text[200];
    begin
        AddSetup.Get;
        AddSetup.TestField("SQL Server ID");
        AddSetup.TestField("CReports Program Path");

        cmdToRun := StrSubstNo('%1 %2 %3 %4 %5 %6 %7',AddSetup."CReports Program Path",'printProgtournee',Format(NumTournee),
            AddSetup."SQL Server ID",AddSetup."SQL Server DB",AddSetup."SQL User",AddSetup."SQL Password");


        if IsClear(WSHShell) then
          Create(WSHShell,false,true);
        WshWindow := '1'; //Windowsyle: minimized, maximized etc.
        WaitForReturn := true;
        WSHShell.Run(cmdToRun,WshWindow,WaitForReturn);
        Clear(WSHShell);
    end;

    procedure PrintBETournee(NumTournee: Integer)
    var
        Process: DotNet BCProcess;
        ret: Integer;
        programm: Text[200];
        param: Text[200];
        WSHShell: Automation BC;
        WaitForReturn: Boolean;
        WshWindow: Text[10];
        cmdToRun: Text[200];
    begin
        AddSetup.Get;
        AddSetup.TestField("SQL Server ID");
        AddSetup.TestField("CReports Program Path");

        cmdToRun := StrSubstNo('%1 %2 %3 %4 %5 %6 %7',AddSetup."CReports Program Path",'printBEtournee',Format(NumTournee),
            AddSetup."SQL Server ID",AddSetup."SQL Server DB",AddSetup."SQL User",AddSetup."SQL Password");

        if IsClear(WSHShell) then
          Create(WSHShell,false,true);
        WshWindow := '1'; //Windowsyle: minimized, maximized etc.
        WaitForReturn := true;
        WSHShell.Run(cmdToRun,WshWindow,WaitForReturn);
        Clear(WSHShell);
    end;

    procedure PrintBLTournee(NumTournee: Integer)
    var
        Process: DotNet BCProcess;
        ret: Integer;
        programm: Text[200];
        param: Text[200];
        WSHShell: Automation BC;
        WaitForReturn: Boolean;
        WshWindow: Text[10];
        cmdToRun: Text[200];
    begin
        AddSetup.Get;
        AddSetup.TestField("SQL Server ID");
        AddSetup.TestField("CReports Program Path");

        cmdToRun := StrSubstNo('%1 %2 %3 %4 %5 %6 %7',AddSetup."CReports Program Path",'printBLtournee',Format(NumTournee),
            AddSetup."SQL Server ID",AddSetup."SQL Server DB",AddSetup."SQL User",AddSetup."SQL Password");

        if IsClear(WSHShell) then
          Create(WSHShell,false,true);
        WshWindow := '1'; //Windowsyle: minimized, maximized etc.
        WaitForReturn := true;
        WSHShell.Run(cmdToRun,WshWindow,WaitForReturn);
        Clear(WSHShell);
    end;

    procedure ImportAndCrypt_PGP(FileToEncrypt: Text;OutputEncryptedFile: Text)
    var
        Process: DotNet BCProcess;
        ret: Integer;
        programm: Text[200];
        param: Text[200];
        WSHShell: Automation BC;
        WaitForReturn: Boolean;
        WshWindow: Text[10];
        cmdImportKey: Text;
        cmdEcryptFile: Text;
    begin

        //gpg --import "C:\OBJ\Encrypt\socgen.encryption.prod.txt"
        //gpg --output "C:\OBJ\Encrypt\TestData2.enc" --encrypt --recipient Cmi.Gestre@socgen.com --trust-model always "C:\OBJ\Decrypt\TestData.txt"

        AddSetup.Get;
        AddSetup.TestField(PGPExeFilePath);
        AddSetup.TestField(PGPKeyFilePath);
        AddSetup.TestField(PGPEmailRecipientAddress);

        cmdImportKey := StrSubstNo('"%1" %2 "%3"',AddSetup.PGPExeFilePath,'--import',AddSetup.PGPKeyFilePath);
        Message(cmdImportKey);

        if IsClear(WSHShell) then
          Create(WSHShell,false,true);
        WshWindow := '1'; //Windowsyle: minimized, maximized etc.
        WaitForReturn := true;
        WSHShell.Run(cmdImportKey,WshWindow,WaitForReturn);


        cmdEcryptFile := StrSubstNo('"%1" %2 "%3" %4 %5 %6 %7 "%8"',AddSetup.PGPExeFilePath,'--output',OutputEncryptedFile,'--encrypt',
          '--recipient',AddSetup.PGPEmailRecipientAddress,'--trust-model always',FileToEncrypt);
        Message(cmdEcryptFile);
        WSHShell.Run(cmdEcryptFile,WshWindow,WaitForReturn);

        Clear(WSHShell);
    end;
}

