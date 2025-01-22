page 50359 "Vendor Invoice Card Encours"
{
    Caption = 'Vendor invoice doc card';
    DataCaptionFields = "Vendor Invoice No.", "Reference Number";
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Vendor Invoice Doc";

    layout
    {
        area(content)
        {
            group("Général")
            {
                field("Reference Number"; Rec."Reference Number")
                {
                }
                field("Vendor No"; Rec."Vendor No")
                {
                    Editable = Afk_FormIsEditableComptaFsseur;
                    Importance = Promoted;
                    ShowMandatory = true;
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                }
                field(Type; Rec.Type)
                {
                    Editable = Afk_FormIsEditableComptaFsseur;
                }
                field("Vendor Invoice No."; Rec."Vendor Invoice No.")
                {
                    Editable = Afk_FormIsEditableComptaFsseur;
                    ShowMandatory = true;
                }
                field("Invoice Date"; Rec."Invoice Date")
                {
                    Editable = Afk_FormIsEditableComptaFsseur;
                }
                field("Arrival Date"; Rec."Arrival Date")
                {
                    Editable = ArrivalDateIsEditable;
                }
                field("Order No"; Rec."Order No")
                {
                    Editable = Afk_FormIsEditableComptaFsseur;
                }
                field(MontantHTVA; Rec.MontantHTVA)
                {
                    Editable = Afk_FormIsEditableComptaFsseur;
                }
                field(MontantTTC; Rec.MontantTTC)
                {
                    Editable = Afk_FormIsEditableComptaFsseur;
                }
                field(Devise; Rec.Devise)
                {
                    Editable = Afk_FormIsEditableComptaFsseur;
                }
                field("Workflow Code"; Rec."Workflow Code")
                {
                    Editable = WorkflowIsEditable;
                    Importance = Promoted;
                    ShowMandatory = true;
                }
                field("Requestor ID"; Rec."Requestor ID")
                {
                }
                field("Requisition No."; Rec."Requisition No.")
                {
                    Visible = false;
                }
            }
            group(Infos)
            {
                Caption = 'Infos';
                Visible = CanViewRefusal;
                field("Reason for refusal"; Rec."Reason for refusal")
                {
                    MultiLine = true;
                    Visible = CanViewRefusal;
                }
            }
            group(Control100000010)
            {
                Caption = 'Infos';
                Visible = CanViewRejection;
                field("Reason for rejection"; Rec."Reason for rejection")
                {
                    MultiLine = true;
                    Visible = CanViewRejection;
                }
                field("Send Email for rejection"; Rec."Send Email for rejection")
                {
                    Visible = CanViewRejection;
                }
            }
            group(Control22)
            {
                Caption = 'Infos';
                field(Status; Rec.Status)
                {
                }
                field("Creation Date"; Rec."Creation Date")
                {
                }
                field("Create By"; Rec."Create By")
                {
                }
                field(Validator; Rec.Validator)
                {
                }
                field("Due Date"; Rec."Due Date")
                {
                }
                field("Posted Invoice No"; Rec."Posted Invoice No")
                {
                }
                field("Payment Doc"; Rec."Payment Doc")
                {
                }
                field("Pay By"; Rec."Pay By")
                {
                }
                field("Payment Date"; Rec."Payment Date")
                {
                }
            }
        }
        area(factboxes)
        {
            part("Attached Documents"; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = const(Database::"Vendor Invoice Doc"),
                              "No." = field("Reference Number");
            }
            systempart(Control15; Links)
            {
            }
            systempart(Control16; Notes)
            {
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Documents)
            {
                Caption = 'Documents';
                Image = Documents;
            }
        }
        area(processing)
        {
            action(TraiterFacture)
            {
                Caption = 'Process';
                Ellipsis = true;
                Enabled = Afk_EnableValidation;
                Image = "Action";
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    CloseForm1: Boolean;
                begin
                    CloseForm1 := VendInvMgt.TraiterFacture(Rec);
                    if CloseForm1 then CurrPage.Close;
                end;
            }
            action(SuiviEtapesValidation)
            {
                Caption = 'Validation Step Lines';
                Image = History;
                Promoted = true;
                PromotedCategory = Category4;
                RunObject = Page "Document Step Lines";
                RunPageLink = "Document Type" = CONST(VendorInvoice),
                              "Document No." = FIELD("Reference Number");
            }
            action(RegulFacture)
            {
                Caption = 'Renvoyer la facture en validation';
                Visible = CanRegulInvoice;

                trigger OnAction()
                var
                    Nbre: Integer;
                begin
                    Nbre := VendInvMgt.RegulFactureFournisseur(Rec);
                    if Nbre > 0 then CurrPage.Close;
                end;
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        IsNotSaisie := Rec.Status <> Rec.Status::EnSaisie;

        AFK_ActivatedControls;
        CurrPage.Editable := Afk_FormIsEditable;
        WorkflowIsEditable := ((Rec.Status = Rec.Status::Receptionee) or (Rec.Status = Rec.Status::Litigieuse));
        IsSaisie := not IsNotSaisie;
        ArrivalDateIsEditable := ((Rec.Status = Rec.Status::EnSaisie) or (Rec.Status = Rec.Status::Receptionee));
        CanRegulInvoice := Rec.Status = Rec.Status::Receptionee;
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        //****************************
        if not Afk_FormIsEditable then Error('');

        //****************************
    end;

    trigger OnOpenPage()
    begin
        //**********************************************
        AFK_ActivatedControls;
        CurrPage.Editable := Afk_FormIsEditable;
        CanRegulInvoice := Rec.Status = Rec.Status::Receptionee;
        //**********************************************
    end;

    var
        VendInvMgt: Codeunit VendorInvoiceMgt;
        Afk_FormIsEditable: Boolean;
        Afk_EnableValidation: Boolean;
        IsNotSaisie: Boolean;
        CanViewRejection: Boolean;
        CanViewRefusal: Boolean;
        CanViewZoneRejet: Boolean;
        CanViewZoneRefus: Boolean;
        WorkflowIsEditable: Boolean;
        IsSaisie: Boolean;
        ArrivalDateIsEditable: Boolean;
        CanRegulInvoice: Boolean;
        Afk_FormIsEditableComptaFsseur: Boolean;

    local procedure AFK_ActivatedControls()
    begin



        if Rec."Validation Level" in [Rec."Validation Level"::Receptionee, Rec."Validation Level"::Rejetee] then
            if VendInvMgt.CanValidateAsCompta then begin
                Afk_FormIsEditable := true;
                Afk_FormIsEditableComptaFsseur := true;
                Afk_EnableValidation := true;
                CanViewRejection := true;
            end;

        if Rec."Validation Level" = Rec."Validation Level"::AttenteValResp1 then begin
            if ((VendInvMgt.CanValidateAsUser1(Rec)) and (Rec.Status <> Rec.Status::Litigieuse)) then begin
                Afk_EnableValidation := true;
                CanViewRefusal := true;
                Afk_FormIsEditable := true;
            end;
        end;

        if Rec."Validation Level" = Rec."Validation Level"::AttenteValResp2 then begin
            if ((VendInvMgt.CanValidateAsUser2(Rec)) and (Rec.Status <> Rec.Status::Litigieuse)) then begin
                Afk_EnableValidation := true;
                CanViewRefusal := true;
                Afk_FormIsEditable := true;
            end;
            //IF ((VendInvMgt.CanValidateAsUser1(Rec)) AND (Rec.Status=Rec.Status::Litigieuse)) THEN BEGIN
            //  //Afk_EnableValidation := TRUE;
            //  CanViewRefusal := TRUE;
            //  Afk_FormIsEditable := TRUE;
            //END;
        end;

        if Rec."Validation Level" = Rec."Validation Level"::AttenteValResp3 then
            if ((VendInvMgt.CanValidateAsUser3(Rec)) and (Rec.Status <> Rec.Status::Litigieuse)) then begin
                Afk_EnableValidation := true;
                CanViewRefusal := true;
                Afk_FormIsEditable := true;
            end;

        if Rec."Validation Level" = Rec."Validation Level"::Validee then
            if VendInvMgt.CanValidateAsDAF then begin
                begin
                    Afk_EnableValidation := true;
                    CanViewRefusal := true;
                    Afk_FormIsEditable := true;
                end;
            end;

        if Rec.Status = Rec.Status::Litigieuse then
            if VendInvMgt.CanValidateAsCompta then begin
                Afk_FormIsEditable := true;
                Afk_EnableValidation := true;
                //CanViewRejection := TRUE;
                CanViewRefusal := true;
            end;
    end;
}

