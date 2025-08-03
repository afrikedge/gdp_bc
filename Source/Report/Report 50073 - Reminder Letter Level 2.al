report 50073 "Reminder Letter Level 2"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Source/Report/Layout/Reminder Letter Level 2.rdlc';
    ApplicationArea = All;

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
            column(LblAfterLinesText01; LblAfterLinesText01)
            {
            }
            column(LbAfterlLinesText02; LbAfterlLinesText02)
            {
            }
            column(LblAfterLinesText03; LblAfterLinesText03)
            {
            }
            column(LblAfterLinesText04; LblAfterLinesText04)
            {
            }
            column(LblAfterLinesText05; LblAfterLinesText05)
            {
            }
            column(LblAfterLinesText06; LblAfterLinesText06)
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
                begin
                    Cust.Get("Issued Reminder Header"."Customer No.");
                    //TextMonsieurMadame := STRSUBSTNO(LblMonsieurMadame,"Issued Reminder Header".Contact);
                    //TextSocieteName := STRSUBSTNO(LblSociéteEntreprise,Cust."Company Name");
                    //TextAdresseExacte := STRSUBSTNO(LblAdresseExacte,"Issued Reminder Header".Address);
                    TextAntananarivoLe := StrSubstNo(LblAntananarivoLe);

                    if "Issued Reminder Header"."Currency Code" = '' then begin
                        GLSetup.TestField("LCY Code");
                        TotalText := StrSubstNo(LblTotalMontant, GLSetup."LCY Code");
                        //TotalInclVATText := STRSUBSTNO(Text001,GLSetup."LCY Code");
                    end else begin
                        TotalText := StrSubstNo(LblTotalMontant, "Issued Reminder Header"."Currency Code");
                        //TotalInclVATText := STRSUBSTNO(Text001,"Currency Code");
                    end;
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
        LblLettreRelance: Label 'Lettre de relance n° 02';
        LblBodyMonsieurMadame: Label 'Monsieur/Madame,';
        LblNousTenonsA: Label 'Nous tenons à vous informer que les factures suivantes sont arrivées à échéance :';
        LblNousVousPrionsDe: Label 'Nous vous prions de nous faire parvenir le règlement de ces impayés dans les meilleurs délais. ';
        LblVeuillezAggreerMonsieur: Label 'Veuillez agréer, Monsieur/Madame, l''expression de nos meilleures salutations.';
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
        LblAfterLinesText01: Label 'Sauf erreur de notre part, nous n''avons encaissé aucun paiement/qu''un paiement partiel de ';
        LbAfterlLinesText02: Label 'votre part pour régulariser vos factures impayées dans nos livres, et ce malgré nos relances de paiement.';
        LblAfterLinesText03: Label 'paiement.';
        LblAfterLinesText04: Label 'Nous vous prions de nous faire parvenir le règlement de la totalité de ces impayés dans les ';
        LblAfterLinesText05: Label 'plus brefs délais. ';
        LblAfterLinesText06: Label 'Veuillez agréer, Monsieur/ Madame, l''expression de nos meilleures salutations.';
}

