pageextension 50008 pageextension70000073 extends "General Journal"
{
    layout
    {
        addafter("Correction")
        {

            field(CodeDepotProvisions; Rec.CodeDepotProvisions)
            {
                Visible = false;
            }
            field(NumDocProvisions; Rec.NumDocProvisions)
            {
                Visible = false;
            }
            field(CodeArticleProvisions; Rec.CodeArticleProvisions)
            {
                Visible = false;
            }
            field(CodeDepotDestProv; Rec.CodeDepotDestProv)
            {
                Visible = false;
            }
            field(VolumeProvisions; Rec.VolumeProvisions)
            {
                Visible = false;
            }
            field(TransporterNameProvisions; Rec.TransporterNameProvisions)
            {
                Visible = false;
            }
            field(VendorCodeProvisions; Rec.VendorCodeProvisions)
            {
                Visible = false;
            }
            field(FraisProvisions; Rec.FraisProvisions)
            {
                Visible = false;
            }
            field(Destinataire; Rec.Destinataire)
            {
                Visible = false;
            }
        }
    }
    actions
    {
        modify(Preview)
        {
            Visible = false;
        }
        modify(DeferralSchedule)
        {
            Visible = false;
        }
        modify(IncomingDocument)
        {
            Visible = false;
        }
        modify(IncomingDocCard)
        {
            Visible = false;
        }
        modify(SelectIncomingDoc)
        {
            Visible = false;
        }
        modify(IncomingDocAttachFile)
        {
            Visible = false;
        }
        modify(RemoveIncomingDoc)
        {
            Visible = false;
        }
        modify(SendApprovalRequest)
        {
            Visible = false;
        }
        addafter(DeferralSchedule)
        {

            action(GenererProvFraisPassage)
            {
                Caption = 'Generate Prov Storage fees Vte';
                Image = GeneralLedger;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    reportProv: Report "50158";
                begin
                    reportProv.SetFeuille(Rec."Journal Template Name", Rec."Journal Batch Name");
                    reportProv.RUN;
                end;
            }
            action(GenererProvFraisPassageTransfert)
            {
                Caption = 'Generate Prov Storage fees Transfer';
                Image = GeneralLedger;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    reportProv: Report "50183";
                begin
                    reportProv.SetFeuille(Rec."Journal Template Name", Rec."Journal Batch Name");
                    reportProv.RUN;
                end;
            }
            action(GenererProvFraisTransfert)
            {
                Caption = 'Generate Transfer fees';
                Image = GeneralLedger;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    reportProv: Report "50159";
                begin
                    reportProv.SetTransfertMassif(FALSE);
                    reportProv.SetFeuille(Rec."Journal Template Name", Rec."Journal Batch Name");
                    reportProv.RUN;
                end;
            }
            action(GenererProvFraisTransfertMassif)
            {
                Caption = 'Generate Transfer fees (Massif)';
                Image = GeneralLedger;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    reportProv: Report "50159";
                begin
                    reportProv.SetTransfertMassif(TRUE);
                    reportProv.SetFeuille(Rec."Journal Template Name", Rec."Journal Batch Name");
                    reportProv.RUN;
                end;
            }
            action(GenererProvFraisTransfertToAmbatovy)
            {
                Caption = 'Generate Transfer fees';
                Image = TransferReceipt;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    reportProv: Report "50181";
                begin
                    //reportProv.SetTransfertMassif(FALSE);
                    reportProv.SetFeuille(Rec."Journal Template Name", Rec."Journal Batch Name");
                    reportProv.RUN;
                end;
            }

            action(GenererProvFraisVente)
            {
                Caption = 'Generate Sales order provisions';
                Image = GeneralLedger;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    reportProv: Report "50155";
                begin
                    reportProv.SetFeuille(Rec."Journal Template Name", Rec."Journal Batch Name");
                    reportProv.RUN;
                end;
            }
            action(GenererProvFraisAchat)
            {
                Caption = 'Generate Purchase order provisions';
                Image = GeneralLedger;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    reportProv: Report "50156";
                begin
                    reportProv.SetFeuille(Rec."Journal Template Name", Rec."Journal Batch Name");
                    reportProv.RUN;
                end;
            }
            action(GenererProvtransportVente)
            {
                Caption = 'Provisions transport sur vente';
                Image = GeneralLedger;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    reportProv: Report "50166";
                begin
                    reportProv.SetFeuille(Rec."Journal Template Name", Rec."Journal Batch Name");
                    reportProv.RUN;
                end;
            }
            action(GenererCargoCdeVenteAncticipee)
            {
                Caption = 'Generate Sales order provisions (Cargo)';
                Image = GeneralLedger;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    reportProv: Report "50172";
                begin
                    reportProv.SetFeuille(Rec."Journal Template Name", Rec."Journal Batch Name");
                    reportProv.RUN;
                end;
            }
            action(ComptaStockCargo)
            {
                Caption = 'Comptabilisation Stock Cargo';
                Image = GeneralLedger;
                Promoted = true;
                PromotedCategory = Category4;

                trigger OnAction()
                var
                    reportProv: Report "50173";
                begin
                    reportProv.SetFeuille(Rec."Journal Template Name", Rec."Journal Batch Name");
                    reportProv.RUN;
                end;
            }
            action(ComptaStockCargotest)
            {
                Caption = 'Comptabilisation Stock Cargo TEST';
                Image = GeneralLedger;
                Promoted = true;
                PromotedCategory = Category4;
                Visible = false;

                trigger OnAction()
                var
                    reportProv: Report "50179";
                begin
                    reportProv.SetFeuille(Rec."Journal Template Name", Rec."Journal Batch Name");
                    reportProv.RUN;
                end;
            }
            action(GenererProvStockvente)
            {
                Caption = 'Provisions Variation Stock Cde vente';
                Image = GeneralLedger;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    reportProv: Report "50176";
                begin
                    reportProv.SetFeuille(Rec."Journal Template Name", Rec."Journal Batch Name");
                    reportProv.RUN;
                end;
            }
            action(GenererProvFraisTransfertJiramaAmba)
            {
                Caption = 'Generate Transfer fees';
                Image = GLBalance;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    reportProv: Report "50180";
                begin
                    reportProv.SetTransfertMassif(FALSE);
                    reportProv.SetFeuille(Rec."Journal Template Name", Rec."Journal Batch Name");
                    reportProv.RUN;
                end;
            }

            action(GenererEcrituresPaie)
            {
                Caption = 'Import payroll journal';
                Image = GeneralLedger;
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;

                trigger OnAction()
                var
                    XMLPortCard: XMLport 50001;
                begin
                    //**********************************
                    CLEAR(XMLPortCard);
                    XMLPortCard.SetFeuille(Rec.GETRANGEMAX("Journal Template Name"), Rec.GETRANGEMAX("Journal Batch Name"));
                    XMLPortCard.RUN;
                    //**********************************
                end;
            }
            action(GenererEcrituresPettyCash)
            {
                Caption = 'Import Petty Cash journal';
                Image = GeneralLedger;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    XMLPortCard: XMLport "50007";
                begin
                    //**********************************
                    CLEAR(XMLPortCard);
                    XMLPortCard.SetFeuille(Rec.GETRANGEMAX("Journal Template Name"), Rec.GETRANGEMAX("Journal Batch Name"));
                    XMLPortCard.RUN;
                    //**********************************
                end;
            }
            action(GenererEcrituresEcartCoutImmo)
            {
                Caption = 'Compta. écart coût immbilisations';
                Image = FixedAssets;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    XMLPortCard: XMLport "50007";
                    reportProv: Report "50178";
                begin
                    //**********************************
                    reportProv.SetFeuille(Rec."Journal Template Name", Rec."Journal Batch Name");
                    reportProv.RUN;
                    //**********************************
                end;
            }
        }
        // addafter(Comment)
        // {
        //     action(TEST_FR_PASS)
        //     {
        //         Caption = 'TEST_FR_PASS';
        //         RunObject = Report 50184;
        //     }
        // }
    }
}

