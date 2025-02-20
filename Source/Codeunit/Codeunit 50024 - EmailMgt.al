codeunit 50024 EmailMgt
{

    trigger OnRun()
    begin
        //Test
    end;

    var
        // SMTPMail: Codeunit "SMTP Mail";
        // SMTPSetup: Record "SMTP Mail Setup";
        Text001: Label 'Aucune adresse email trouvée pour l''envoi de l''alerte.';

    procedure SendMailEnvoyerValidation(PurchReq: Record "Purchase Requisition")
    var
        Objet: Text[80];
        CodeDocument: Text[30];
        Commentaires: Text[150];
        ToAdress: Text[80];
        CCAdress: Text[80];
        Sender: Text[80];
        SendDate: Text[50];
        DocType: Text[30];
        UserSetup: Record "User Setup";
    begin

        UserSetup.Get(UserId);
        UserSetup.CalcFields("User Full Name");

        Objet := 'Nouvelle demande d''achat à valider : ' + PurchReq."No.";
        CodeDocument := PurchReq."No.";
        Commentaires := PurchReq.Description;
        ToAdress := getMailCDG(PurchReq, false);
        CCAdress := getMailCDG(PurchReq, true);
        Sender := UserSetup."User ID" + ' - ' + UserSetup."User Full Name";
        SendDate := Format(WorkDate);
        DocType := 'Demande d''achat';

        if ((ToAdress <> '') or (CCAdress <> '')) then
            SendEmail(Objet, CodeDocument, Commentaires, ToAdress, CCAdress, Sender, SendDate, DocType)
        else
            Message(Text001);
    end;

    procedure SendMailValidationCDG(PurchReq: Record "Purchase Requisition")
    var
        Objet: Text[80];
        CodeDocument: Text[30];
        Commentaires: Text[150];
        ToAdress: Text[80];
        CCAdress: Text[80];
        Sender: Text[80];
        SendDate: Text[50];
        DocType: Text[30];
        UserSetup: Record "User Setup";
    begin

        UserSetup.Get(UserId);
        UserSetup.CalcFields("User Full Name");

        Objet := 'Nouvelle demande d''achat à valider : ' + PurchReq."No.";
        CodeDocument := PurchReq."No.";
        Commentaires := PurchReq.Description;
        ToAdress := getMailRespo(PurchReq, false);
        CCAdress := getMailRespo(PurchReq, true);
        Sender := UserSetup."User ID" + ' - ' + UserSetup."User Full Name";
        SendDate := Format(WorkDate);
        DocType := 'Demande d''achat';

        if ((ToAdress <> '') or (CCAdress <> '')) then
            SendEmail(Objet, CodeDocument, Commentaires, ToAdress, CCAdress, Sender, SendDate, DocType)
        else
            Message(Text001);
    end;

    procedure SendMailValidationResp(PurchReq: Record "Purchase Requisition")
    var
        Objet: Text[80];
        CodeDocument: Text[30];
        Commentaires: Text[150];
        ToAdress: Text[80];
        CCAdress: Text[80];
        Sender: Text[80];
        SendDate: Text[50];
        DocType: Text[30];
        UserSetup: Record "User Setup";
    begin

        UserSetup.Get(UserId);
        UserSetup.CalcFields("User Full Name");

        Objet := 'Demande validée : ' + PurchReq."No.";
        CodeDocument := PurchReq."No.";
        Commentaires := PurchReq.Description;
        ToAdress := getMailAcheteur(PurchReq);
        CCAdress := getMailDemandeur(PurchReq);
        Sender := UserSetup."User ID" + ' - ' + UserSetup."User Full Name";
        SendDate := Format(WorkDate);
        DocType := 'Demande d''achat';

        if ((ToAdress <> '') or (CCAdress <> '')) then
            SendEmail(Objet, CodeDocument, Commentaires, ToAdress, CCAdress, Sender, SendDate, DocType)
        else
            Message(Text001);
    end;

    procedure SendRenvoi(PurchReq: Record "Purchase Requisition")
    var
        Objet: Text[80];
        CodeDocument: Text[30];
        Commentaires: Text[150];
        ToAdress: Text[80];
        CCAdress: Text[80];
        Sender: Text[80];
        SendDate: Text[50];
        DocType: Text[30];
        UserSetup: Record "User Setup";
    begin

        UserSetup.Get(UserId);
        UserSetup.CalcFields("User Full Name");

        Objet := 'Demande rejetée : ' + PurchReq."No.";
        CodeDocument := PurchReq."No.";
        Commentaires := PurchReq.Description;
        ToAdress := getMailDemandeur(PurchReq);
        CCAdress := '';
        Sender := UserSetup."User ID" + ' - ' + UserSetup."User Full Name";
        SendDate := Format(WorkDate);
        DocType := 'Demande d''achat';

        if ((ToAdress <> '') or (CCAdress <> '')) then
            SendEmail(Objet, CodeDocument, Commentaires, ToAdress, CCAdress, Sender, SendDate, DocType)
        else
            Message(Text001);
    end;

    local procedure SendEmail(Objet: Text[80]; CodeDocument: Text[30]; Commentaires: Text[150]; ToAdress: Text[80]; CCAdress: Text[80]; Sender: Text[80]; SendDate: Text[50]; DocType: Text[30])
    var
        EmailToSend: Record "Tampon Payment Vendor Email";
        EmailMgt: Codeunit EmailMgt;
    begin
        // SMTPSetup.Get;
        // SMTPSetup.TestField(SMTPSetup."From Adress");
        // SMTPSetup.TestField(SMTPSetup."From Name");

        // //Test
        // SMTPMail.CreateMessage(SMTPSetup."From Name",SMTPSetup."From Adress",ToAdress,
        // Objet,'',true);

        // SMTPMail.AppendBody('<span style="font-family: Tahoma; font-size: 12;">');
        // //SMTPMail.AppendBody('<span style="color: #993300;font-size: 13;">Votre validation est r&eacute;quise.</span>');
        // //SMTPMail.AppendBody('<p>Un document a &eacute;t&eacute; envoy&eacute; &agrave; votre niveau pour traitement. D&eacute;tails du document :</p>');
        // SMTPMail.AppendBody('<p>D&eacute;tails du document :</p>');
        // SMTPMail.AppendBody('<ul style="list-style-type: circle;">');
        // SMTPMail.AppendBody('<li>Document : <strong>'+DocType+' ' +CodeDocument+'</strong></li>');
        // SMTPMail.AppendBody('</ul>');
        // SMTPMail.AppendBody('<ul style="list-style-type: circle;">');
        // SMTPMail.AppendBody('<li>Trait&eacute; par : <strong>'+Sender+'</strong></li>');
        // SMTPMail.AppendBody('</ul>');
        // SMTPMail.AppendBody('<ul style="list-style-type: circle;">');
        // SMTPMail.AppendBody('<li>Trait&eacute; le : <strong>'+SendDate+'</strong></li>');
        // SMTPMail.AppendBody('</ul>');
        // SMTPMail.AppendBody('<ul style="list-style-type: circle;">');
        // SMTPMail.AppendBody('<li>Commentaires : <em>'+Commentaires+'</em></li>');
        // SMTPMail.AppendBody('</ul>');
        // SMTPMail.AppendBody('</span>');
        // SMTPMail.AppendBody('<p>&nbsp;</p>');
        // SMTPMail.AppendBody('<p>_________________________________</p>');
        // SMTPMail.AppendBody('<p>Message envoy&eacute; depuis Dynamics NAV.</p>');

        // if CCAdress<>'' then SMTPMail.AddCC(CCAdress);

        // SMTPMail.Send;

        exit;

        EmailToSend.Init();
        EmailToSend.EntryID := EmailMgt.GetNextEntryNoInEmailRec();
        EmailToSend.EmailObject := Objet;
        EmailToSend.BodyAsHTML := CreateEmailBody(CodeDocument, Commentaires, Sender, SendDate, DocType);
        EmailToSend.SendTo := ToAdress;
        EmailToSend.EmailType := EmailToSend.EmailType::Purchase;
        EmailToSend."User ID" := UserId;
        EmailToSend."Entry Date" := Today;
        EmailToSend."Document No." := CodeDocument;
        if (CCAdress <> '') then
            EmailToSend.SendToCC := CCAdress;

        EmailToSend.Insert(true);
    end;

    local procedure CreateEmailBody(CodeDocument: Text[30]; Commentaires: Text[150]; Sender: Text[80]; SendDate: Text[50]; DocType: Text[30]): Text
    var
        BodyText: Text;
    begin
        BodyText := '<html><body>';
        BodyText += '<span style="font-family: Tahoma; font-size: 12;">';
        BodyText += '<p>D&eacute;tails du document :</p>';
        BodyText += '<ul style="list-style-type: circle;">';
        BodyText += '<li>Document : <strong>' + DocType + ' ' + CodeDocument + '</strong></li>';
        BodyText += '</ul>';
        BodyText += '<ul style="list-style-type: circle;">';
        BodyText += '<li>Trait&eacute; le : <strong>' + SendDate + '</strong></li>';
        BodyText += '</ul>';
        BodyText += '<ul style="list-style-type: circle;">';
        BodyText += '<li>Commentaires : <em>' + Commentaires + '</em></li>';
        BodyText += '</ul>';
        BodyText += '</span>';
        BodyText += '<p>&nbsp;</p>';
        BodyText += '<p>_________________________________</p>';
        BodyText += '<p>Message envoy&eacute; depuis Dynamics Business Central.</p>';
        BodyText += '</body></html>';

        exit(BodyText);
    end;

    local procedure getMailRespo(PurchReq: Record "Purchase Requisition"; Interim: Boolean): Text[80]
    var
        UserSetup: Record "User Setup";
    begin

        UserSetup.Get(PurchReq."Create By");

        if not Interim then begin
            if UserSetup."PR Validator" <> '' then
                if UserSetup.Get(UserSetup."PR Validator") then
                    exit(UserSetup."E-Mail");
        end else begin
            if UserSetup."PR Interim Validator" <> '' then
                if UserSetup.Get(UserSetup."PR Interim Validator") then
                    exit(UserSetup."E-Mail");
        end;
    end;

    local procedure getMailCDG(PurchReq: Record "Purchase Requisition"; Interim: Boolean): Text[80]
    var
        UserSetup: Record "User Setup";
    begin

        UserSetup.Get(PurchReq."Create By");

        if not Interim then begin
            if UserSetup."CDG Validator" <> '' then
                if UserSetup.Get(UserSetup."CDG Validator") then
                    exit(UserSetup."E-Mail");
        end else begin
            if UserSetup."CDG Interim Validator" <> '' then
                if UserSetup.Get(UserSetup."CDG Interim Validator") then
                    exit(UserSetup."E-Mail");
        end;
    end;

    local procedure getMailDemandeur(PurchReq: Record "Purchase Requisition"): Text[80]
    var
        UserSetup: Record "User Setup";
    begin

        UserSetup.Get(PurchReq."Create By");
        exit(UserSetup."E-Mail");
    end;

    local procedure getMailAcheteur(PurchReq: Record "Purchase Requisition"): Text[80]
    var
        UserSetup: Record "User Setup";
    begin

        UserSetup.Get(PurchReq."Create By");
        exit(UserSetup."Mail acheteur");
    end;

    local procedure InsertEmailToSend(GenJrnLine: Record "Gen. Journal Line"; FileName: Text)
    var
        EmailToSend: Record "Tampon Payment Vendor Email";
        NextID: Integer;
    begin

        exit;

        EmailToSend.Reset;
        if EmailToSend.FindLast then
            NextID := EmailToSend.EntryID + 1
        else
            NextID := 1;

        EmailToSend.Init;
        EmailToSend.EntryID := NextID;
        EmailToSend."Vendor No." := GenJrnLine."Account No.";
        EmailToSend."Document No." := GenJrnLine."Document No.";
        EmailToSend.Attachment := FileName;
        EmailToSend."User ID" := UserId;
        EmailToSend."Entry Date" := Today;
        EmailToSend.Amount := Abs(GenJrnLine.Amount);
        EmailToSend."Payment Method Code" := GenJrnLine."Payment Method Code";
        EmailToSend.Insert;
    end;

    local procedure GenerateReportPDF(ReportID: Integer; var OutStream: OutStream)
    var
        ReportRecRef: RecordRef;
    begin
        // Here we create a PDF of the report with the given ReportID
        // This is simplified - in reality, you need proper record filtering
        ReportRecRef.Open(ReportID);
        Report.SaveAs(ReportID, '', ReportFormat::Pdf, OutStream, ReportRecRef);
        ReportRecRef.Close();
    end;

    local procedure CreateEmailBody(Customer: Record Customer): Text
    var
        BodyText: Text;
    begin
        BodyText := '<html><body>';
        BodyText += '<p>Dear ' + Customer.Name + ',</p>';
        BodyText += '<p>Please find attached your detailed trial balance report.</p>';
        BodyText += '<p>If you have any questions regarding this report, please contact your account manager.</p>';
        BodyText += '<p>Best regards,<br>Your Company Name</p>';
        BodyText += '</body></html>';

        exit(BodyText);
    end;

    procedure GetNextEntryNoInEmailRec(): Integer
    var
        EmailTable: record "Tampon Payment Vendor Email";
    begin
        EmailTable.Reset();
        if EmailTable.FindLast() then
            exit(EmailTable.EntryID + 1)
        else
            exit(1);
    end;
    // procedure FillEmailsTable()
    // var
    //     Customer: Record Customer;
    //     EmailTable: Record "Emails";
    //     ReportID: Integer;
    //     BodyText: Text;
    //     TempBlob: Codeunit "Temp Blob";
    //     OutStream: OutStream;
    //     InStream: InStream;
    // begin
    //     // Set report ID for "Customer - Detail Trial Bal."
    //     ReportID := Report::"Customer - Detail Trial Bal.";

    //     // Process for each customer
    //     if Customer.FindSet() then
    //         repeat
    //             if Customer."E-Mail" <> '' then begin
    //                 // Create new record in Emails table
    //                 EmailTable.Init();
    //                 EmailTable."Entry No." := GetNextEntryNo();
    //                 EmailTable."Object" := 'Customer Trial Balance';

    //                 // Create email body
    //                 BodyText := CreateEmailBody(Customer);
    //                 EmailTable.Body := BodyText;

    //                 EmailTable.SentTo := Customer."E-Mail";

    //                 // Generate PDF report for the customer
    //                 TempBlob.CreateOutStream(OutStream);
    //                 Report.SaveAs(ReportID, '', ReportFormat::Pdf, OutStream, Customer.RecordId);

    //                 // Set the attachment to the record
    //                 TempBlob.CreateInStream(InStream);
    //                 EmailTable.AttachmentFile.ImportStream(InStream, 'Customer Trial Balance.pdf');

    //                 EmailTable.Insert(true);
    //             end;
    //         until Customer.Next() = 0;
    // end;
}

