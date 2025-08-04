codeunit 50044 "Afk Post Card Operation"
{
    TableNo = "Afk Card Operation Entry";

    trigger OnRun()
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
        CardPostingConfig.Get(Rec.File);
        AddOnSetup.GetRecordOnce();

        // Vérifier que l'écriture n'est pas déjà comptabilisée
        if not Rec."Posted In GL" then begin
            // Configuration d'une seule ligne de journal avec compte et compte de contrepartie
            //ClearGenJournalLine(GenJnlLine);

            clear(GenJnlLine);
            GenJnlLine."Document Date" := Rec."Posting Date";
            GenJnlLine.Validate("Posting Date", Rec."Posting Date");


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
            GenJnlLine.Validate(GenJnlLine."Account No.", Rec."Customer No.");

            GenJnlLine.Description := CopyStr(Rec.Description, 1, 100);
            GenJnlLine.Validate("Currency Code", '');
            if CardPostingConfig."Entry Type" = CardPostingConfig."Entry Type"::"Debit Note" then
                GenJnlLine.Validate(GenJnlLine.Amount, Rec.Amount)
            else
                GenJnlLine.Validate(GenJnlLine.Amount, -Rec.Amount);


            GenJnlLine."External Document No." := CopyStr(Rec.File, 1, 35);
            GenJnlLine."Source Code" := SourceCodeSetup.Sales;
            GenJnlLine.SetHideValidation(true);
            GenJnlLine."Bal. Account Type" := GenJnlLine."Bal. Account Type"::"G/L Account";

            CardPostingConfig.TestField("Bal. Account No.");

            if ((CardPostingConfig."Bal. Account No."[1] = '6') or (CardPostingConfig."Bal. Account No."[1] = '7')) then begin
                GenJnlLine.Validate("Bal. VAT Prod. Posting Group", AddOnSetup."NoVAT Prod. Posting Group");
            end;

            GenJnlLine.Validate("Bal. Account No.", CardPostingConfig."Bal. Account No.");
            GenJnlLine."Bal. Gen. Posting Type" := GenJnlLine."Bal. Gen. Posting Type"::Sale;

            // Tentative de comptabilisation
            //GenJnlPostLine.Run(GenJnlLine);
            GenJnlPostLine.Run(GenJnlLine);
            //Error(ErrorPostingLbl, GetLastErrorText());

            // Si tout s'est bien passé, marquer l'écriture comme comptabilisée
            Rec."Posted In GL" := true;
            Rec."Error Message" := '';
            Rec."Posted Document No." := GenJnlLine."Document No.";
            Rec.Modify();
        end;
    end;

    // [TryFunction]
    // local procedure PostSingleEntry(var CardEntryToPost: Record "Afk Card Operation Entry")
    // var
    //     CardEntryPost: Codeunit "Afk Post Card Operation";
    // begin
    //     CardEntryPost.Run(CardEntryToPost);
    // end;
}
