

codeunit 50043 "Afk Card Operation Posting"
{
    trigger OnRun()
    begin
        PostCardEntries();
    end;

    procedure PostCardEntries()
    var
        CardEntryToPost: Record "Afk Card Operation Entry";
        GenJnlLine: Record "Gen. Journal Line";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
    //PostCardOperation: Codeunit "Afk Post Card Operation";
    begin

        CardEntryToPost.Reset();
        CardEntryToPost.SetRange("Posted In GL", false);

        if not CardEntryToPost.FindSet() then
            exit;

        repeat
            ProcessSingleEntryWithErrorHandling(CardEntryToPost);
        until CardEntryToPost.Next() = 0;

        ProcessAlertIfErrors();
    end;


    // local procedure ProcessSingleEntry(var CardEntryToPost: Record "Afk Card Operation Entry")
    // begin
    //     if not Codeunit.Run(Codeunit::"Afk Post Card Operation", CardEntryToPost) then begin
    //         CardEntryToPost."Error Message" := CopyStr(GetLastErrorText(), 1, 250);
    //         CardEntryToPost.Modify();
    //         ClearLastError();
    //     end;
    // end;

    local procedure ProcessAlertIfErrors()
    var
        ErrorEntries: Record "Afk Card Operation Entry";
        EmailMsg: Codeunit "Email Message";
        Email: Codeunit Email;
        EmailBody: TextBuilder;
        ErrorCounter: Integer;
        RecipientEmail: Text;
        Subject: Text;
        EmailObjectLabel: Label 'Erreurs de comptabilisation des écritures carte', Locked = true;
    begin
        AddOnSetup2.Get();
        RecipientEmail := AddOnSetup2."Email Card Posting Error"; // Remplacer par l'adresse email désirée
        Subject := EmailObjectLabel;

        ErrorEntries.Reset();
        ErrorEntries.SetRange("Posted In GL", false);
        ErrorEntries.SetFilter("Error Message", '<>%1', '');

        if ErrorEntries.FindSet() then begin
            EmailBody.AppendLine('Les écritures suivantes ont généré des erreurs lors de la comptabilisation :');
            EmailBody.AppendLine('');
            EmailBody.AppendLine('Fichier | Code client | Date | Montant | Message d''erreur');
            //EmailBody.AppendLine('-----------|-----------|--------------|---------|-----------------');

            ErrorCounter := 0;
            repeat
                ErrorCounter += 1;
                EmailBody.AppendLine(
                    Format(ErrorEntries.File) + ' | ' +
                    ErrorEntries."Customer No." + ' | ' +
                    Format(ErrorEntries."Posting Date") + ' | ' +
                    Format(ErrorEntries.Amount) + ' | ' +
                    ErrorEntries."Error Message");

                if ErrorCounter >= 100 then
                    break;
            until ErrorEntries.Next() = 0;

            // Envoi de l'email
            AddOnSetup2.TestField("Email Card Posting Error");
            EmailMsg.Create(RecipientEmail, Subject, EmailBody.ToText());
            Email.Send(EmailMsg);
        end;
    end;

    local procedure ProcessSingleEntryWithErrorHandling(var CardEntryToPost: Record "Afk Card Operation Entry")
    var
        //CardEntryPost: Codeunit "Afk Post Card Operation";
        isSuccess: Boolean;
    begin
        // Nettoyer les erreurs précédentes
        ClearLastError();

        // Essayer d'exécuter sans capturer la valeur de retour
        //CardEntryPost.SetCardEntry(CardEntryToPost);

        // Utilisation d'un bloc try-catch manuel
        commit;
        isSuccess := Codeunit.Run(Codeunit::"Afk Post Card Operation", CardEntryToPost);
        if (not isSuccess) then
            if GetLastErrorText() <> '' then begin
                CardEntryToPost."Error Message" := CopyStr(GetLastErrorText(), 1, 250);
                CardEntryToPost.Modify();
                ClearLastError();
            end;
        // if not PostOneEntry(CardEntryToPost) then
        //     if GetLastErrorText() <> '' then begin
        //         CardEntryToPost."Error Message" := CopyStr(GetLastErrorText(), 1, 250);
        //         CardEntryToPost.Modify();
        //         ClearLastError();
        //     end;
    end;


    procedure PostOneEntry(var CardEntryToPost: Record "Afk Card Operation Entry"): Boolean
    var
        GenJnlLine: Record "Gen. Journal Line";
        SourceCodeSetup: Record "Source Code Setup";
        AddOnSetup: Record "AddOn Setup";
        CardPostingConfig: Record "Afk Card Posting Config";
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
        NosSeriesMgt: Codeunit "No. Series";
        ErrorPostingLbl: Label 'Erreur lors de la comptabilisation: %1', Locked = true;
    begin
        SourceCodeSetup.Get();
        CardPostingConfig.Get(CardEntryToPost.File);
        AddOnSetup.GetRecordOnce();

        // Vérifier que l'écriture n'est pas déjà comptabilisée
        if not CardEntryToPost."Posted In GL" then begin
            // Configuration d'une seule ligne de journal avec compte et compte de contrepartie
            //ClearGenJournalLine(GenJnlLine);

            clear(GenJnlLine);
            GenJnlLine."Document Date" := CardEntryToPost."Posting Date";
            GenJnlLine.Validate("Posting Date", CardEntryToPost."Posting Date");


            if CardPostingConfig."Entry Type" = CardPostingConfig."Entry Type"::"Debit Note" then begin
                GenJnlLine."Document Type" := GenJnlLine."Document Type"::Invoice;
                AddOnSetup.TestField("Debit Notes Nos.");
                GenJnlLine."Document No." := NosSeriesMgt.GetNextNo(AddOnSetup."Debit Notes Nos.", GenJnlLine."Posting Date", true);

            end else begin
                GenJnlLine."Document Type" := GenJnlLine."Document Type"::"Credit Memo";
                AddOnSetup.TestField("Credit Notes Nos.");
                GenJnlLine."Document No." := NosSeriesMgt.GetNextNo(AddOnSetup."Credit Notes Nos.", GenJnlLine."Posting Date", true);
            end;

            GenJnlLine."Account Type" := GenJnlLine."Account Type"::Customer;
            GenJnlLine."Gen. Posting Type" := GenJnlLine."Gen. Posting Type"::" ";
            GenJnlLine.Validate(GenJnlLine."Account No.", CardEntryToPost."Customer No.");

            GenJnlLine.Description := CopyStr(CardEntryToPost.Description, 1, 100);
            GenJnlLine.Validate("Currency Code", '');
            if CardPostingConfig."Entry Type" = CardPostingConfig."Entry Type"::"Debit Note" then
                GenJnlLine.Validate(GenJnlLine.Amount, CardEntryToPost.Amount)
            else
                GenJnlLine.Validate(GenJnlLine.Amount, -CardEntryToPost.Amount);


            GenJnlLine."External Document No." := CardEntryToPost."External Doc No.";
            GenJnlLine."Source Code" := SourceCodeSetup.Sales;
            GenJnlLine.SetHideValidation(true);
            GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";

            CardPostingConfig.TestField("Bal. Account No.");

            if ((CardPostingConfig."Bal. Account No."[1] = '6') or (CardPostingConfig."Bal. Account No."[1] = '7')) then begin
                GenJnlLine.Validate("Bal. VAT Prod. Posting Group", AddOnSetup."NoVAT Prod. Posting Group");
            end;

            GenJnlLine.Validate("Bal. Account No.", CardPostingConfig."Bal. Account No.");
            GenJnlLine."Bal. Gen. Posting Type" := GenJnlLine."Bal. Gen. Posting Type"::Sale;

            if (not TryPostGenJnlLine(GenJnlLine)) then begin
                CardEntryToPost."Error Message" := CopyStr(GetLastErrorText(), 1, 250);
                CardEntryToPost.Modify();
            end else begin
                CardEntryToPost."Posted In GL" := true;
                CardEntryToPost."Error Message" := '';
                CardEntryToPost."Posted Document No." := GenJnlLine."Document No.";
                CardEntryToPost.Modify();
            end;

            exit(true);
        end;
    end;

    local procedure TryPostGenJnlLine(GenJnlLine: Record "Gen. Journal Line"): Boolean
    var
        GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";
    begin
        commit();
        if not GenJnlPostLine.Run(GenJnlLine) then
            exit(false)
        else
            exit(true);
    end;


    var
        AddOnSetup2: record "AddOn Setup2";
}
