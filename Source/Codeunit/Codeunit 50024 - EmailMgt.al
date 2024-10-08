codeunit 50024 EmailMgt
{

    trigger OnRun()
    begin
        //Test
    end;

    var
        SMTPMail: Codeunit "SMTP Mail";
        SMTPSetup: Record "SMTP Mail Setup";
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
        Sender := UserSetup."User ID"+ ' - '+ UserSetup."User Full Name";
        SendDate := Format(WorkDate);
        DocType := 'Demande d''achat';

        if ((ToAdress<>'') or (CCAdress<>'')) then
          SendEmail(Objet,CodeDocument,Commentaires,ToAdress,CCAdress,Sender,SendDate,DocType)
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
        Sender := UserSetup."User ID"+ ' - '+ UserSetup."User Full Name";
        SendDate := Format(WorkDate);
        DocType := 'Demande d''achat';

        if ((ToAdress<>'') or (CCAdress<>'')) then
          SendEmail(Objet,CodeDocument,Commentaires,ToAdress,CCAdress,Sender,SendDate,DocType)
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
        Sender := UserSetup."User ID"+ ' - '+ UserSetup."User Full Name";
        SendDate := Format(WorkDate);
        DocType := 'Demande d''achat';

        if ((ToAdress<>'') or (CCAdress<>'')) then
          SendEmail(Objet,CodeDocument,Commentaires,ToAdress,CCAdress,Sender,SendDate,DocType)
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
        Sender := UserSetup."User ID"+ ' - '+ UserSetup."User Full Name";
        SendDate := Format(WorkDate);
        DocType := 'Demande d''achat';

        if ((ToAdress<>'') or (CCAdress<>'')) then
          SendEmail(Objet,CodeDocument,Commentaires,ToAdress,CCAdress,Sender,SendDate,DocType)
        else
          Message(Text001);
    end;

    local procedure SendEmail(Objet: Text[80];CodeDocument: Text[30];Commentaires: Text[150];ToAdress: Text[80];CCAdress: Text[80];Sender: Text[80];SendDate: Text[50];DocType: Text[30])
    begin
        SMTPSetup.Get;
        SMTPSetup.TestField(SMTPSetup."From Adress");
        SMTPSetup.TestField(SMTPSetup."From Name");

        //Test
        SMTPMail.CreateMessage(SMTPSetup."From Name",SMTPSetup."From Adress",ToAdress,
        Objet,'',true);

        SMTPMail.AppendBody('<span style="font-family: Tahoma; font-size: 12;">');
        //SMTPMail.AppendBody('<span style="color: #993300;font-size: 13;">Votre validation est r&eacute;quise.</span>');
        //SMTPMail.AppendBody('<p>Un document a &eacute;t&eacute; envoy&eacute; &agrave; votre niveau pour traitement. D&eacute;tails du document :</p>');
        SMTPMail.AppendBody('<p>D&eacute;tails du document :</p>');
        SMTPMail.AppendBody('<ul style="list-style-type: circle;">');
        SMTPMail.AppendBody('<li>Document : <strong>'+DocType+' ' +CodeDocument+'</strong></li>');
        SMTPMail.AppendBody('</ul>');
        SMTPMail.AppendBody('<ul style="list-style-type: circle;">');
        SMTPMail.AppendBody('<li>Trait&eacute; par : <strong>'+Sender+'</strong></li>');
        SMTPMail.AppendBody('</ul>');
        SMTPMail.AppendBody('<ul style="list-style-type: circle;">');
        SMTPMail.AppendBody('<li>Trait&eacute; le : <strong>'+SendDate+'</strong></li>');
        SMTPMail.AppendBody('</ul>');
        SMTPMail.AppendBody('<ul style="list-style-type: circle;">');
        SMTPMail.AppendBody('<li>Commentaires : <em>'+Commentaires+'</em></li>');
        SMTPMail.AppendBody('</ul>');
        SMTPMail.AppendBody('</span>');
        SMTPMail.AppendBody('<p>&nbsp;</p>');
        SMTPMail.AppendBody('<p>_________________________________</p>');
        SMTPMail.AppendBody('<p>Message envoy&eacute; depuis Dynamics NAV.</p>');

        if CCAdress<>'' then SMTPMail.AddCC(CCAdress);

        SMTPMail.Send;
    end;

    local procedure getMailRespo(PurchReq: Record "Purchase Requisition";Interim: Boolean): Text[80]
    var
        UserSetup: Record "User Setup";
    begin

        UserSetup.Get(PurchReq."Create By");

        if not Interim then begin
          if UserSetup."PR Validator"<>'' then
            if UserSetup.Get(UserSetup."PR Validator") then
              exit(UserSetup."E-Mail");
        end else begin
          if UserSetup."PR Interim Validator"<>'' then
            if UserSetup.Get(UserSetup."PR Interim Validator") then
              exit(UserSetup."E-Mail");
        end;
    end;

    local procedure getMailCDG(PurchReq: Record "Purchase Requisition";Interim: Boolean): Text[80]
    var
        UserSetup: Record "User Setup";
    begin

        UserSetup.Get(PurchReq."Create By");

        if not Interim then begin
          if UserSetup."CDG Validator"<>'' then
            if UserSetup.Get(UserSetup."CDG Validator") then
              exit(UserSetup."E-Mail");
        end else begin
          if UserSetup."CDG Interim Validator"<>'' then
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

    procedure Add(X: Decimal;Y: Decimal) Z: Decimal
    begin
        Z := (X+Y);
    end;
}

