table 50094 "Vendor Invoice Doc"
{
    Caption = 'Vendor invoice';
    DataCaptionFields = "Reference Number","Vendor Invoice No.";

    fields
    {
        field(1;"Entry No";Integer)
        {
            AutoIncrement = true;
        }
        field(2;"Vendor Invoice No.";Code[35])
        {
            Caption = 'Vendor Invoice No.';

            trigger OnValidate()
            var
                VendorLedgerEntry: Record "Vendor Ledger Entry";
            begin
                /*
                IF "Vendor Invoice No." <> '' THEN
                  IF FindPostedDocumentWithSameExternalDocNo(VendorLedgerEntry,"Vendor Invoice No.") THEN
                    ShowExternalDocAlreadyExistNotification(VendorLedgerEntry)
                  ELSE
                    RecallExternalDocAlreadyExistsNotification;
                */

            end;
        }
        field(5;Type;Option)
        {
            OptionCaption = 'Invoice,Credit Memo';
            OptionMembers = Invoice,CreditMemo;
        }
        field(6;"Arrival Date";Date)
        {
            Caption = 'Arrival Date';
        }
        field(7;"Invoice Date";Date)
        {
            Caption = 'Invoice Date';
        }
        field(8;FactureDirecte;Boolean)
        {
            Caption = 'Direct Invoice';
        }
        field(9;"Order No";Code[20])
        {
            Caption = 'Order N°';
            TableRelation = "Purchase Header"."No." WHERE ("Document Type"=CONST(Order),
                                                           "Buy-from Vendor No."=FIELD("Vendor No"));
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                if PurchOrder.Get(PurchOrder."Document Type"::Order,"Order No") then begin
                  if PurchReq.Get(PurchOrder."Code Demande") then begin
                    "Requestor ID" := PurchReq."Create By";
                    "Requisition No.":= PurchReq."No.";

                  end else begin
                    "Requestor ID" := PurchOrder."User ID";
                  end;
                end;

                if ("Requestor ID"<>'') then begin
                  WkfwCode.Reset;
                  WkfwCode.SetRange(WkfwCode."Workflow Type",WkfwCode."Workflow Type"::VendorInvoice);
                  WkfwCode.SetRange(WkfwCode."User 1","Requestor ID");
                  if WkfwCode.FindFirst then
                    Validate("Workflow Code",WkfwCode."Workflow Code");
                end;
            end;
        }
        field(10;MontantTTC;Decimal)
        {
            Caption = 'Amount Incl VAT';

            trigger OnValidate()
            begin
                CheckAmounts(MontantTTC);
            end;
        }
        field(11;"Vendor No";Code[20])
        {
            Caption = 'Vendor Code';
            TableRelation = Vendor."No.";
        }
        field(12;"Vendor Name";Text[50])
        {
            CalcFormula = Lookup(Vendor.Name WHERE ("No."=FIELD("Vendor No")));
            Caption = 'Vendor Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(13;Status;Option)
        {
            Caption = 'Statut';
            Editable = false;
            OptionCaption = 'On hold,Received,Rejected,Awaiting requestor,Awaiting manager 1,Awaiting manager 2,Awaiting manager 3,Validated,Litigious,Awaiting payment,Cancelled,Paid,Posted,Archived';
            OptionMembers = EnSaisie,Receptionee,Rejetee,AttenteValDemandeur,AttenteValResp1,AttenteValResp2,AttenteValResp3,Validee,Litigieuse,AttentePaiement,Annulee,Payee,Comptabilise,Archived;
        }
        field(14;"Creation Date";DateTime)
        {
            Caption = 'Creation Date';
            Editable = false;
        }
        field(15;"Create By";Code[50])
        {
            Caption = 'Created by';
            Editable = false;
        }
        field(18;"Requestor ID";Code[50])
        {
            Caption = 'Requestor ID';
            Editable = false;
            TableRelation = "User Setup";
        }
        field(19;"Requisition No.";Code[20])
        {
            Caption = 'Purchase Requisition';
            Editable = false;
        }
        field(20;"Reference Number";Code[20])
        {
            Caption = 'Reference';
            Editable = false;
        }
        field(21;"Sent To Validation Date";DateTime)
        {
            Caption = 'Sent to validation date';
            Editable = false;
        }
        field(22;Validator;Code[50])
        {
            Caption = 'Validator';
            Editable = false;
            TableRelation = "User Setup";
        }
        field(23;"Requestor Val Date";DateTime)
        {
            Caption = 'Requestor Validation Date';
            Editable = false;
        }
        field(24;"Payment Doc";Code[20])
        {
            Caption = 'Payment Doc';
            Editable = false;
        }
        field(25;"Pay By";Code[50])
        {
            Caption = 'Paid By';
            Editable = false;
        }
        field(26;Devise;Option)
        {
            OptionCaption = 'MGA,EUR,USD,MUR,GBP,ZAR';
            OptionMembers = MGA,EUR,USD,MUR,GBP,ZAR;
        }
        field(28;"Manager Val Date";DateTime)
        {
            Caption = 'Manager validation date';
            Editable = false;
        }
        field(29;"Manager ID";Code[50])
        {
            Caption = 'Manager ID';
            Editable = false;
        }
        field(30;"Send Email for rejection";Boolean)
        {
            Caption = 'Send email to vendor (Rejection)';
        }
        field(31;"Reason for rejection";Text[250])
        {
            Caption = 'Reason for rejection';
            Description = 'Rejet de la facture (avant la validation, renvoi vers le fournisseur)';
        }
        field(32;"Reason for refusal";Text[250])
        {
            Caption = 'Reason for refusal';
            Description = 'Refus de la facture (encours de validation)';
        }
        field(33;"Validation Level";Option)
        {
            Editable = false;
            OptionCaption = 'On hold,Received,Rejected,Awaiting requestor,Awaiting manager 1,Awaiting manager 2,Awaiting manager 3,Validated,Litigious,Awaiting payment,Cancelled,Paid,Posted,Archived';
            OptionMembers = EnSaisie,Receptionee,Rejetee,AttenteValDemandeur,AttenteValResp1,AttenteValResp2,AttenteValResp3,Validee,Litigieuse,AttenteBAP,Annulee,Payee,Comptabilise,Archived;
        }
        field(34;"Workflow Code";Code[20])
        {
            Caption = 'Requestor Service';
            TableRelation = "Custom Workflow Config"."Workflow Code" WHERE ("Workflow Type"=CONST(VendorInvoice));

            trigger OnValidate()
            begin
                if((Status=Rec.Status::Receptionee) or (Status=Rec.Status::Rejetee)) then begin
                  if ("Workflow Code"<>'') then
                    if WkfwCode.Get(WkfwCode."Workflow Type"::VendorInvoice,"Workflow Code") then
                      Validator := WkfwCode."User 1";
                end;
            end;
        }
        field(35;"Payment Date";DateTime)
        {
            Caption = 'Payment Date';
            Editable = false;
        }
        field(36;"Posted Invoice No";Code[20])
        {
            Caption = 'Facture enregistrée';
            Editable = false;
        }
        field(37;"Due Date";Date)
        {
            Caption = 'Due Date';
            Editable = false;
        }
        field(38;MontantHTVA;Decimal)
        {
            Caption = 'Montant HTVA';

            trigger OnValidate()
            begin
                CheckAmounts(MontantHTVA);
            end;
        }
        field(39;"Validator Name";Text[80])
        {
            CalcFormula = Lookup(User."Full Name" WHERE ("User Name"=FIELD(Validator)));
            Caption = 'Nom du validateur';
            Editable = false;
            FieldClass = FlowField;
        }
        field(40;"Payment Method Code";Code[10])
        {
            CalcFormula = Lookup("Vendor Ledger Entry"."Payment Method Code" WHERE ("Vendor No."=FIELD("Vendor No"),
                                                                                    "Document No."=FIELD("Payment Doc")));
            Caption = 'Payment Method Code';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"Entry No")
        {
        }
        key(Key2;"Vendor No","Vendor Invoice No.")
        {
        }
        key(Key3;"Workflow Code")
        {
        }
        key(Key4;"Reference Number")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown;"Reference Number","Vendor Invoice No.","Vendor No","Vendor Name","Arrival Date")
        {
        }
    }

    trigger OnInsert()
    begin
        "Creation Date" := CreateDateTime(Today,Time);
        "Create By" := UserId;

        gRequisitionSetup.Get;
        gRequisitionSetup.TestField("Vendor Inv Doc Series");
        "Reference Number" := NosSeriesMgt.GetNextNo(gRequisitionSetup."Vendor Inv Doc Series",WorkDate,true);
    end;

    var
        gRequisitionSetup: Record "AddOn Setup2";
        NosSeriesMgt: Codeunit NoSeriesManagement;
        PurchOrder: Record "Purchase Header";
        PurchReq: Record "Purchase Requisition";
        WkfwCode: Record "Custom Workflow Config";
        Text043: Label 'Vous devez saisir des montants positifs pour le type "Facture" et négatifs pour le type "Avoir"';

    local procedure CheckAmounts(Amt: Decimal)
    begin
        if Rec.Type = Rec.Type::Invoice then
          if (Amt<0) then
            Error(Text043);

        if Rec.Type=Rec.Type::CreditMemo then
          if (Amt>0) then
            Error(Text043);
    end;
}

