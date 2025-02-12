codeunit 50016 "Security Mgt"
{

    trigger OnRun()
    begin
    end;



    procedure CheckAccessUserJournal(GenJnlLine: Record "Gen. Journal Line"; Edit: Boolean; Validate: Boolean)
    var
        JournalUser: Record "Journal User";
    begin
        AddOnSetup.Get;
        if AddOnSetup."Security on Journal" then begin
            if ((GenJnlLine."Journal Template Name" <> '') and (GenJnlLine."Journal Batch Name" <> '')) then begin
                //JournalUser.SETCURRENTKEY(Code,Description,"Journal Template Name","Journal Batch Name");
                JournalUser.SetRange("User ID", UserId);
                //JournalUser.SETRANGE(Description,SecurityUser.Description::"1");
                JournalUser.SetRange("Journal Template Name", GenJnlLine."Journal Template Name");
                JournalUser.SetRange("Journal Batch Name", GenJnlLine."Journal Batch Name");
                //IF Edit THEN JournalUser.SETRANGE(JournalUser.Edit,TRUE);
                //IF Validate THEN JournalUser.SETRANGE(JournalUser.Validate,TRUE);
                if JournalUser.IsEmpty then begin
                    Message(TextErr0001, GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name");
                    Error('');
                end else begin
                    JournalUser.FindFirst;
                    if Edit and not JournalUser.Edit then
                        Error(StrSubstNo(TextErr0002, GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name"));
                    if Validate and not JournalUser.Validate then
                        Error(StrSubstNo(TextErr0003, GenJnlLine."Journal Template Name", GenJnlLine."Journal Batch Name"));
                end;
            end;
        end;
    end;

    procedure CheckWarehouseUser(CodeMagasin: Code[10])
    var
        WarehouseUser: Record "Warehouse Employee";
        Loc: Record Location;
    begin

        AddOnSetup.Get;
        if AddOnSetup."Desactivate Whse Sec" then exit;

        if ((UserId <> '') and (CodeMagasin <> '')) then begin
            if Loc.Get(CodeMagasin) then begin
                if Loc."Virtual Location" then exit;
                if Loc."Transfer Item Transit" then exit;
                if Loc."Use As In-Transit" then exit;
                if Loc."Location Type" <> Loc."Location Type"::" " then exit;
            end;
            WarehouseUser.Reset;
            WarehouseUser.SetRange(WarehouseUser."User ID", UserId);
            WarehouseUser.SetRange(WarehouseUser."Location Code", CodeMagasin);
            if WarehouseUser.IsEmpty then Error(Text001, CodeMagasin);
        end;
    end;

    procedure GetFiltresMagasinsDispaching(CodeRegion: Code[20]) Rep: Text[1024]
    var
        UserSetup1: Record "User Setup";
        Location: Record Location;
    begin

        /*
        IF CodeRegion='' THEN EXIT('*');
        
        Location.RESET;
        Location.SETRANGE(Location."Responsibility Center",CodeRegion);
        Location.SETRANGE(Depot,TRUE);
        IF Location.FINDSET THEN
          REPEAT
        
              IF STRLEN(Rep + Location.Code) > 1024 THEN EXIT('');
              IF Rep='' THEN
                Rep := Location.Code
              ELSE
                Rep := Rep + '|' + Location.Code;
        
          UNTIL Location.NEXT=0;
        
        IF Rep='' THEN Rep:='#K##+';
        */


        warehouseEmp.Reset;
        warehouseEmp.SetRange(warehouseEmp."User ID", UserId);
        //Location.SETRANGE(Depot,TRUE);
        if warehouseEmp.FindSet then
            repeat

                if StrLen(Rep + warehouseEmp."Location Code") > 1024 then exit('');
                if Rep = '' then
                    Rep := warehouseEmp."Location Code"
                else
                    Rep := Rep + '|' + warehouseEmp."Location Code";

            until warehouseEmp.Next = 0;

        if Rep = '' then Rep := '#K##+';

    end;

    procedure GetDefaultLocationDispaching(): Code[10]
    var
        UserSetup1: Record "User Setup";
        Location: Record Location;
    begin

        UserSetup1.Get(UserId);
        UserSetup1.TestField(UserSetup1."Sales Resp. Ctr. Filter");

        Location.Reset;
        Location.SetRange("Responsibility Center", UserSetup1."Sales Resp. Ctr. Filter");
        Location.SetRange(Depot, true);
        if Location.FindFirst then
            exit(Location.Code)
        else
            Error(Text002);
    end;

    procedure GetOldUser(): Code[50]
    var
        UserSetup1: Record "User Setup";
    begin
        UserSetup1.SetRange("User ID", UserId);
        exit(UserSetup1."Old Nav User")
    end;

    local procedure CheckDepotDispaching(CodeDepot: Code[10])
    var
        UserSetup1: Record "User Setup";
        Location: Record Location;
    begin

        UserSetup1.Get(UserId);
        UserSetup1.TestField(UserSetup1."Sales Resp. Ctr. Filter");

        Location.Get(CodeDepot);
        Location.TestField(Location."Responsibility Center", UserSetup1."Sales Resp. Ctr. Filter");
    end;

    procedure CanUpdatePrices(): Boolean
    var
        UserSet: Record "User Setup";
    begin
        if UserSet.Get(UserId) then
            exit(UserSet."Can Update Prices");
    end;

    procedure CanUnlockOrders(): Boolean
    var
        UserSet: Record "User Setup";
    begin
        if UserSet.Get(UserId) then
            exit(UserSet."Can Unlock Order");
    end;

    procedure GetFiltresFeuilles(CodeModele: Code[10]) Rep: Text[1024]
    var
        UserSetup1: Record "User Setup";
        Location: Record Location;
        JournalUser: Record "Journal User";
    begin

        JournalUser.Reset;
        JournalUser.SetRange("User ID", UserId);
        JournalUser.SetRange("Journal Template Name", CodeModele);
        //JournalUser.SETRANGE("Journal Batch Name",GenJnlLine."Journal Batch Name");
        if JournalUser.FindSet then
            repeat

                if StrLen(Rep + JournalUser."Journal Batch Name") > 1024 then exit('*');
                if Rep = '' then
                    Rep := JournalUser."Journal Batch Name"
                else
                    Rep := Rep + '|' + JournalUser."Journal Batch Name";

            until JournalUser.Next = 0;

        if Rep = '' then Rep := '#K##+';
    end;

    procedure CheckCanUseBankAcc(BankAcc: Code[20])
    var
        UserItem: Record "Security Item";
    begin

        AddOnSetup.Get;
        if not AddOnSetup."Activate bank Acc Sec" then exit;

        UserItem.Reset;
        UserItem.SetRange("User ID", UserId);
        UserItem.SetRange(SecurityType, UserItem.SecurityType::BankAcc);
        UserItem.SetRange("Item Code", BankAcc);
        if not UserItem.FindFirst then
            Error(Text003, BankAcc);
    end;

    procedure GetFiltresCentresGestion() Rep: Text[1024]
    var
        UserSetup1: Record "User Setup";
        Location: Record Location;
    begin

        UserSetup.Get(UserId);

        if UserSetup."Sales Resp. Ctr. Filter" <> '' then begin
            if Rep = '' then
                Rep := UserSetup."Sales Resp. Ctr. Filter"
            else
                Rep := Rep + '|' + UserSetup."Sales Resp. Ctr. Filter";
        end;

        if UserSetup."Sales Resp. Ctr. Filter2" <> '' then begin
            if Rep = '' then
                Rep := UserSetup."Sales Resp. Ctr. Filter2"
            else
                Rep := Rep + '|' + UserSetup."Sales Resp. Ctr. Filter2";
        end;

        if UserSetup."Sales Resp. Ctr. Filter3" <> '' then begin
            if Rep = '' then
                Rep := UserSetup."Sales Resp. Ctr. Filter3"
            else
                Rep := Rep + '|' + UserSetup."Sales Resp. Ctr. Filter3";
        end;

        if UserSetup."Sales Resp. Ctr. Filter4" <> '' then begin
            if Rep = '' then
                Rep := UserSetup."Sales Resp. Ctr. Filter4"
            else
                Rep := Rep + '|' + UserSetup."Sales Resp. Ctr. Filter4";
        end;


        if UserSetup."Sales Resp. Ctr. Filter5" <> '' then begin
            if Rep = '' then
                Rep := UserSetup."Sales Resp. Ctr. Filter5"
            else
                Rep := Rep + '|' + UserSetup."Sales Resp. Ctr. Filter5";
        end;

        if Rep = '' then Rep := '#K##+';

        /*
        warehouseEmp.RESET;
        warehouseEmp.SETRANGE(warehouseEmp."User ID",USERID);
        //Location.SETRANGE(Depot,TRUE);
        IF warehouseEmp.FINDSET THEN
          REPEAT
        
              IF STRLEN(Rep + warehouseEmp."Location Code") > 1024 THEN EXIT('');
              IF Rep='' THEN
                Rep := warehouseEmp."Location Code"
              ELSE
                Rep := Rep + '|' + warehouseEmp."Location Code";
        
          UNTIL warehouseEmp.NEXT=0;
        
        IF Rep='' THEN Rep:='#K##+';
        */

    end;

    procedure CanValidateItems(): Boolean
    var
        UserSet: Record "User Setup";
    begin
        if UserSet.Get(UserId) then
            exit(UserSet."Can Validate Item");
    end;

    procedure CanDeleteBlockedOrders(): Boolean
    var
        UserSet: Record "User Setup";
    begin
        if UserSet.Get(UserId) then
            exit(UserSet."Can delete blocked Orders");
    end;

    procedure CanReverseReconciliation(): Boolean
    var
        UserSet: Record "User Setup";
    begin
        if UserSet.Get(UserId) then
            exit(UserSet."Can Reverse Reconciliation");
    end;

    procedure CanReverseTransaction(): Boolean
    var
        UserSet: Record "User Setup";
    begin
        if UserSet.Get(UserId) then
            exit(UserSet."Can Reverse Transaction");
    end;

    procedure CanCancelSO(): Boolean
    var
        UserSet: Record "User Setup";
    begin
        if UserSet.Get(UserId) then
            exit(UserSet."Can Cancel SO");
    end;

    procedure CheckCanReverseReconciliation()
    begin
        if not CanReverseReconciliation then
            Error(Text004);
    end;

    procedure CheckCanReverseTransaction()
    begin
        if not CanReverseTransaction then
            Error(Text004);
    end;

    procedure CheckCanCancelSO()
    begin
        if not CanCancelSO then
            Error(Text005);
    end;

    procedure CanValidateVendors(): Boolean
    var
        UserSet: Record "User Setup";
    begin
        if UserSet.Get(UserId) then
            exit(UserSet."Can Validate Vendor");
    end;

    procedure CanUpdateQtyJIRAMA_SO(): Boolean
    var
        UserSet: Record "User Setup";
    begin
        if UserSet.Get(UserId) then
            exit(UserSet."Can Update JIRAMA Qty");
    end;

    procedure CanReverseBE_BL(): Boolean
    var
        UserSet: Record "User Setup";
    begin
        if UserSet.Get(UserId) then
            exit(UserSet."Can Reverse BE/BL");
    end;

    procedure CheckCanReverseBE_BL()
    begin
        if not CanReverseBE_BL then
            Error(Text005);
    end;

    procedure CanReconciliateGLEntries(): Boolean
    var
        UserSet: Record "User Setup";
    begin
        if UserSet.Get(UserId) then
            exit(UserSet."Can Apply GLEntries");
    end;

    procedure CheckCanApplyGLEntries()
    begin
        if not CanReconciliateGLEntries then
            Error(Text005);
    end;

    procedure GetDefaultOrFirstLocation(): Code[10]
    begin
        warehouseEmp.Reset;
        warehouseEmp.SetRange(warehouseEmp."User ID", UserId);
        warehouseEmp.SetRange(warehouseEmp.Default, true);
        if warehouseEmp.FindFirst then
            exit(warehouseEmp."Location Code");

        warehouseEmp.Reset;
        warehouseEmp.SetRange(warehouseEmp."User ID", UserId);
        if warehouseEmp.FindFirst then
            exit(warehouseEmp."Location Code");
    end;

    procedure CanUpdateSOAfterValidation(): Boolean
    var
        UserSet: Record "User Setup";
    begin
        if UserSet.Get(UserId) then
            exit(UserSet.CanUpdateOrderAfterValidation);
    end;

    procedure CanPostVendInvoiceDirectly(): Boolean
    var
        UserSet: Record "User Setup";
    begin
        if UserSet.Get(UserId) then
            exit(UserSet.CanPostDirectPurchInvoice);
    end;

    procedure CheckReverseAmount(EntryAmt: Decimal)
    var
        UserSet: Record "User Setup";
    begin
        if UserSet.Get(UserId) then
            if ((UserSet."Reverse Amount Limit" > 0) and (EntryAmt > UserSet."Reverse Amount Limit")) then
                Error(Text006, EntryAmt, UserSet."Reverse Amount Limit");
    end;

    procedure CanAddItemOnSalesInv(): Boolean
    begin
        if UserSetup.Get(UserId) then
            exit(UserSetup."Item on sales invoice");
    end;

    procedure FindUser(var UserSetup: record "User Setup"; UserId: code[50])
    var
    begin
        UserSetup.SetRange("User ID", UserId);
        if (UserSetup.FindFirst) then begin
            UserSetup.CalcFields("Afk Signature");
            UserSetup.CalcFields("User Full Name");
            exit;
        end;

        UserSetup.Reset();
        UserSetup.SetRange("Old Nav User", UserId);
        if (UserSetup.FindFirst) then begin
            UserSetup.CalcFields("Afk Signature");
            UserSetup.CalcFields("User Full Name");
            exit;
        end;
    end;

    procedure CreateNewPassword(UserCode: Code[50]; NewPassord: Text; UserMustChangePassword: Boolean)
    var
        ExternalUser: Record "Afk FrontDesk User";
        HashedPass: Text;
    begin
        ExternalUser.get(UserCode);
        HashedPass := CryptoMgt.GenerateHashAsBase64String(NewPassord, 2);//Option MD5,SHA1,SHA256,SHA384,SHA512
        ExternalUser.Password := CopyStr(HashedPass, 1, 255);
        ExternalUser.UserMustChangePassword := UserMustChangePassword;
        ExternalUser.PasswordIsSet := true;
        ExternalUser.Modify();
    end;


    procedure SetFiltresCentresGestion(var SalesHeader: record "Sales Header")
    var
        FiltreCG: Text;
    begin
        IF GetSalesFilter() <> '' THEN BEGIN

            FiltreCG := GetFiltresCentresGestion;
            IF FiltreCG <> '' THEN BEGIN
                SalesHeader.FILTERGROUP(2);
                SalesHeader.SETFILTER("Responsibility Center", FiltreCG);
                SalesHeader.FILTERGROUP(0);
            END;
        END;
    end;

    procedure SetFiltresCentresGestion(var SalesHeader: record "Sales Cr.Memo Header")
    var
        FiltreCG: Text;
    begin
        IF GetSalesFilter() <> '' THEN BEGIN
            FiltreCG := GetFiltresCentresGestion;
            IF FiltreCG <> '' THEN BEGIN
                SalesHeader.FILTERGROUP(2);
                SalesHeader.SETFILTER("Responsibility Center", FiltreCG);
                SalesHeader.FILTERGROUP(0);
            END;
        END;
    end;

    procedure SetFiltresCentresGestion(var SalesHeader: record "Sales Invoice Header")
    var
        FiltreCG: Text;
    begin
        IF GetSalesFilter() <> '' THEN BEGIN
            FiltreCG := GetFiltresCentresGestion;
            IF FiltreCG <> '' THEN BEGIN
                SalesHeader.FILTERGROUP(2);
                SalesHeader.SETFILTER("Responsibility Center", FiltreCG);
                SalesHeader.FILTERGROUP(0);
            END;
        END;
    end;

    procedure GetSalesFilter(): Code[10]
    var
        CompanyInfo: record "Company Information";
        SalesUserRespCenter: Code[10];
    begin
        CompanyInfo.GetRecordOnce();
        SalesUserRespCenter := CompanyInfo."Responsibility Center";
        //UserLocation := CompanyInfo."Location Code";
        IF UserSetup.GET(UserId) AND (UserId <> '') THEN
            IF UserSetup."Sales Resp. Ctr. Filter" <> '' THEN
                SalesUserRespCenter := UserSetup."Sales Resp. Ctr. Filter";
        exit(SalesUserRespCenter);
    end;

    var
        AddOnSetup: Record "AddOn Setup";
        CryptoMgt: Codeunit "Cryptography Management";
        TextErr0001: Label 'You are not associate to this general journal\Template : %1\Journal : %2';
        TextErr0002: Label 'You are not associate to this general journal\Template : %1\Journal : %2';
        TextErr0003: Label 'You are not associate to this general journal\Template : %1\Journal : %2';
        Text001: Label 'Vous n''êtes pas autorisé à utiliser le code magasin %1';
        Text002: Label 'Aucun dépot configuré sur votre région';
        Text003: Label 'Vous n''êtes pas autorisé à utiliser le compte bancaire %1';
        warehouseEmp: Record "Warehouse Employee";
        UserSetup: Record "User Setup";
        Text004: Label 'Vous n''êtes pas autorisé à utiliser cette fonctionnalité.';
        Text005: Label 'Vous n''êtes pas autorisé à utiliser cette fonctionnalité.';
        Text006: Label 'Vous n''etes pas autorisé à contrepasser cette opération car sa valeur %1 est supérieure à votre limite : %2 ';
}

