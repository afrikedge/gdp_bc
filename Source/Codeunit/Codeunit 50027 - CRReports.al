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

    // procedure PrintBE(NumBE: Integer)
    // var
    // begin


    // end;

    // procedure PrintBL(NumBE: Integer)
    // var

    // begin

    //end;

    procedure PrintFactureVente(NumBE: Code[20])
    var

    begin

    end;

    procedure PrintFactureVenteLubs(NumBE: Code[20])
    var

    begin

    end;

    procedure PrintNoteDebit_Facture(NumBE: Code[20])
    var

    begin

    end;

    procedure PrintNoteCredit_Avoir(NumBE: Code[20])
    var

    begin

    end;

    procedure PrintNoteDebitCredit_Ecriture(EntryNo: Integer)
    var

    begin

    end;

    procedure PrintBL_Lubs(NumBL: Code[20])
    var

    begin

    end;

    procedure PrintBL_Lubs_Enreg(NumBL: Code[20])
    var

    begin

    end;

    procedure CreateDdeDeblocage(OrderNo: Code[20]; CustNo: Code[20])
    var

    begin

    end;

    procedure CreateCRMCustomer(CustNo: Code[20])
    var

    begin

    end;

    procedure PrintProgrammeTournee(NumTournee: Integer)
    var

    begin

    end;

    procedure PrintBETournee(NumTournee: Integer)
    var

    begin

    end;

    procedure PrintBLTournee(NumTournee: Integer)
    var

    begin

    end;

    procedure ImportAndCrypt_PGP(FileToEncrypt: Text; OutputEncryptedFile: Text)
    var

    begin


    end;
}

