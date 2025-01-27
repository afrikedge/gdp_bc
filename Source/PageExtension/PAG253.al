pageextension 50029 pageextension70000056 extends "Sales Journal"
{
    layout
    {
        addafter("Debit Amount")
        {
            field("VAT Base Amount"; Rec."VAT Base Amount")
            {
            }
            // field("Bal. Account Name";Rec."Bal. Account Name")
            // {
            // }
        }
    }
    actions
    {
        modify(Preview)
        {
            Visible = false;
        }
        addafter("RedistributeAccAllocations")
        {
            action(ImportFacturesCartes)
            {
                Caption = 'Import Cards Invoices';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    XMLPortCard: XMLport "50002";
                begin
                    //**********************************
                    CLEAR(XMLPortCard);
                    XMLPortCard.SetJournalCode(Rec.GETRANGEMAX("Journal Template Name"), Rec.GETRANGEMAX("Journal Batch Name"));
                    XMLPortCard.SetIsGPRO(FALSE);
                    XMLPortCard.RUN;
                    //**********************************
                end;
            }
            action(ImportFacturesCartesGPRO)
            {
                Caption = 'Import Cards Invoices GPRO';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    XMLPortCard: XMLport "50002";
                begin
                    //**********************************
                    CLEAR(XMLPortCard);
                    XMLPortCard.SetJournalCode(Rec.GETRANGEMAX("Journal Template Name"), Rec.GETRANGEMAX("Journal Batch Name"));
                    XMLPortCard.SetIsGPRO(TRUE);
                    XMLPortCard.RUN;
                    //**********************************
                end;
            }
            action(ImportPrimesStation)
            {
                Caption = 'Import les primes station';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    XMLPortCard: XMLport "50077";
                begin
                    //**********************************
                    CLEAR(XMLPortCard);
                    XMLPortCard.SetFeuille(Rec.GETRANGEMAX("Journal Template Name"), Rec.GETRANGEMAX("Journal Batch Name"));
                    //XMLPortCard.SetIsGPRO(TRUE);
                    XMLPortCard.RUN;
                    //**********************************
                end;
            }
            action(ImportNDGerant)
            {
                Caption = 'Import des notes de débit gérant';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    XMLPortCard: XMLport "50078";
                begin
                    //**********************************
                    CLEAR(XMLPortCard);
                    XMLPortCard.SetFeuille(Rec.GETRANGEMAX("Journal Template Name"), Rec.GETRANGEMAX("Journal Batch Name"));
                    //XMLPortCard.SetIsGPRO(TRUE);
                    //XMLPortCard.SetDebit(TRUE);
                    XMLPortCard.RUN;
                    //**********************************
                end;
            }
            action(ImportNCGerant)
            {
                Caption = 'Import des notes de crédit gérant';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    XMLPortCard: XMLport "50079";
                begin
                    //**********************************
                    CLEAR(XMLPortCard);
                    XMLPortCard.SetFeuille(Rec.GETRANGEMAX("Journal Template Name"), Rec.GETRANGEMAX("Journal Batch Name"));
                    //XMLPortCard.SetIsGPRO(TRUE);
                    //XMLPortCard.SetDebit(FALSE);
                    XMLPortCard.RUN;
                    //**********************************
                end;
            }
        }
    }
}

