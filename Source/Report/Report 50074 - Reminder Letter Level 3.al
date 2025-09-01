report 50074 "Reminder Letter Level 3"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Source/Report/Layout/Reminder Letter Level 3.rdl';

    dataset
    {
        dataitem("Issued Reminder Header"; "Issued Reminder Header")
        {
            column(No_IssuedReminderHeader; "Issued Reminder Header"."No.")
            {
            }
            column(CustomerContact; Cust.Contact)
            {
            }
            column(CompanyName; Cust."Company Name")
            {
            }
            column(Address_IssuedReminderHeader; "Issued Reminder Header".Address)
            {
            }
            column(Contact_IssuedReminderHeader; "Issued Reminder Header".Contact)
            {
            }
            column(LblMonsieurMadame; LblMonsieurMadame)
            {
            }
            column("LblSociéteEntreprise"; LblSociéteEntreprise)
            {
            }
            column(LblAdresseExacte; LblAdresseExacte)
            {
            }
            column(TextAntananarivoLe; TextAntananarivoLe)
            {
            }
            column(LblALattentionDe; LblALattentionDe)
            {
            }
            column("LblRéférence"; LblRéférence)
            {
            }
            column(LblObjet; LblObjet)
            {
            }
            column(LblLettreRelance; LblLettreRelance)
            {
            }
            column(LblBodyMonsieurMadame; LblBodyMonsieurMadame)
            {
            }
            column(LblNousTenonsA; LblNousTenonsA)
            {
            }
            column(LblNousVousPrionsDe; LblNousVousPrionsDe)
            {
            }
            column(LblVeuillezAggreerMonsieur; LblVeuillezAggreerMonsieur)
            {
            }
            column(LblColDateDocument; LblColDateDocument)
            {
            }
            column(LblColNumeroDocument; LblColNumeroDocument)
            {
            }
            column(LblColDateEcheance; LblColDateEcheance)
            {
            }
            column(LblColDocType; LblColDocType)
            {
            }
            column(LblColOriginalAmount; LblColOriginalAmount)
            {
            }
            column(LblColRemainingAmount; LblColRemainingAmount)
            {
            }
            column(TotalText; TotalText)
            {
            }
            column(CompanyInfoPicture; CompanyInfo.Picture)
            {
            }
            column(LblTextBody02; LblTextBody02)
            {
            }
            column(LblTextBody03; LblTextBody03)
            {
            }
            column(LblTextBody04; LblTextBody04)
            {
            }
            column(LblTextBody05; LblTextBody05)
            {
            }
            column(TextAvecMontant; TextAvecMontant)
            {
            }
            dataitem("Issued Reminder Line"; "Issued Reminder Line")
            {
                DataItemLink = "Reminder No." = FIELD("No.");
                column(DocumentType_IssuedReminderLine; "Issued Reminder Line"."Document Type")
                {
                }
                column(DocumentNo_IssuedReminderLine; "Issued Reminder Line"."Document No.")
                {
                }
                column(DueDate_IssuedReminderLine; "Issued Reminder Line"."Due Date")
                {
                }
                column(OriginalAmount_IssuedReminderLine; "Issued Reminder Line"."Original Amount")
                {
                }
                column(RemainingAmount_IssuedReminderLine; "Issued Reminder Line"."Remaining Amount")
                {
                }
                column(DocumentDate_IssuedReminderLine; "Issued Reminder Line"."Document Date")
                {
                }

                trigger OnAfterGetRecord()
                var
                    CurrencyCode: Code[10];
                begin
                    Cust.Get("Issued Reminder Header"."Customer No.");

                    if "Issued Reminder Header"."Currency Code" = '' then begin
                        GLSetup.TestField("LCY Code");
                        TotalText := StrSubstNo(LblTotalMontant, GLSetup."LCY Code");
                        CurrencyCode := GLSetup."LCY Code";
                        //TotalInclVATText := STRSUBSTNO(Text001,GLSetup."LCY Code");
                    end else begin
                        TotalText := StrSubstNo(LblTotalMontant, "Issued Reminder Header"."Currency Code");
                        CurrencyCode := "Issued Reminder Header"."Currency Code"
                        //TotalInclVATText := STRSUBSTNO(Text001,"Currency Code");
                    end;

                    "Issued Reminder Header".CalcFields("Issued Reminder Header"."Remaining Amount");

                    RepCheck.InitTextVariable();
                    RepCheck.FormatNoText(NoText, "Issued Reminder Header"."Remaining Amount", CurrencyCode);
                    //RepCheck.FormatNoTextFR(NoText, "Issued Reminder Header"."Remaining Amount", CurrencyCode);
                    Afk_AmountInWords := NoText[1] + ' ' + NoText[2];


                    //TextMonsieurMadame := STRSUBSTNO(LblMonsieurMadame,"Issued Reminder Header".Contact);
                    //TextSocieteName := STRSUBSTNO(LblSociéteEntreprise,Cust."Company Name");
                    //TextAdresseExacte := STRSUBSTNO(LblAdresseExacte,"Issued Reminder Header".Address);

                    TextAvecMontant := StrSubstNo(LblTextBody01, Afk_AmountInWords, CurrencyCode,
                      "Issued Reminder Header"."Remaining Amount");
                    TextAntananarivoLe := StrSubstNo(LblAntananarivoLe);
                end;

                trigger OnPreDataItem()
                begin
                    CompanyInfo.Get;
                    CompanyInfo.CalcFields(CompanyInfo.Picture);
                    GLSetup.Get;
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        Cust: Record Customer;
        CompanyInfo: Record "Company Information";
        LblALattentionDe: Label 'A l''attention de';
        LblMonsieurMadame: Label 'Monsieur/Madame : ';
        "LblSociéteEntreprise": Label 'Société /Entreprise : ';
        LblAdresseExacte: Label 'Adresse exacte : ';
        "LblRéférence": Label 'Référence :';
        LblObjet: Label 'Objet :';
        LblLettreRelance: Label 'LETTRE DE MISE EN DEMEURE';
        LblBodyMonsieurMadame: Label 'Monsieur/Madame,';
        LblNousTenonsA: Label 'Nous tenons à vous informer que les factures suivantes sont arrivées à échéance :';
        LblNousVousPrionsDe: Label 'Nous vous prions de nous faire parvenir le règlement de ces impayés dans les meilleurs délais. ';
        LblVeuillezAggreerMonsieur: Label '            Veuillez agréer, Monsieur/Madame, l''expression de nos meilleures salutations.';
        LblAntananarivoLe: Label 'Antananarivo le ';
        LblColDateDocument: Label 'Date du document';
        LblColNumeroDocument: Label 'N° du Document';
        LblColDateEcheance: Label 'Date d''échéance';
        LblColDocType: Label 'Type document';
        LblColOriginalAmount: Label 'Montant initial';
        LblColRemainingAmount: Label 'Montant ouvert';
        LblTotalMontant: Label 'Total %1';
        TextMonsieurMadame: Text;
        TextSocieteName: Text;
        TextAdresseExacte: Text;
        TextAntananarivoLe: Text;
        Currency: Record Currency;
        GLSetup: Record "General Ledger Setup";
        TotalText: Text;
        LblAfterLinesText06: Label 'Veuillez agréer, Monsieur/ Madame, l''expression de nos meilleures salutations.';
        LblTextBody01: Label '            Nous tenons à vous rappeler que vous restez débiteur de la somme de  %1 ( %2 %3 ) sous toutes réserves dans nos livres, en règlement des factures échues et non encore honorées à ce jour, et dont détails qui suivent :';
        LblTextBody02: Label '            Nous vous mettons en demeure de nous régler la totalité de la somme ci-dessus mentionnée dans les HUIT (08) jours qui suivent la réception de la présente.';
        LblTextBody03: Label '            Passé ce délai, nous sommes dans l''obligation d''user tous les moyens de droit en vigueur pour recouvrer notre créance.';
        LblTextBody04: Label '            Si entre-temps, un règlement a été fait, nous vous prions de ne pas considérer la présente.';
        LblTextBody05: Label '            Dans l''attente d''un prompt règlement de votre part,';
        TextAvecMontant: Text;
        RepCheck: Report Check;
        NoText: array[2] of Text[250];
        Afk_AmountInWords: Text[250];
}

