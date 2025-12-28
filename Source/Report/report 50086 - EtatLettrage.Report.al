/// <summary>
/// Report Etat lettrage (ID 50086).
/// </summary>
report 50086 "Etat Lettrage"
{
    DefaultLayout = RDLC;
    Caption = 'Etat Lettrage';
    PreviewMode = PrintLayout;
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    RDLCLayout = './Source/Report/Layout/EtatLettrage.rdl';

    dataset
    {
        dataitem(Line; "Cust. Ledger Entry")
        {
            DataItemTableView = sorting("Entry No.");
            RequestFilterFields = "Document No.";
            RequestFilterHeading = 'Etat lettrage';
            column(CompanyPicture; CompanyInfo.Picture)
            {
            }
            column(Foot1; 'Siège social ' + CompanyInfo.Address)
            {
            }
            column(Foot2; CompanyInfo."Post Code" + ' - ' + CompanyInfo.City)
            {
            }
            column(Foot3; Foot3)
            {
            }
            column(Foot4; 'S.A. au capital de AR ' + CompanyInfo."Stock Capital" + ' - ' + 'NIF : ' + CompanyInfo."Registration No.")
            {
            }
            column(Foot5; 'R.C.S. : ' + CompanyInfo."Trade Register" + ' - ' + 'STAT : ' + CompanyInfo."Legal Form")
            {
            }
            column(Foot6; 'Email : ' + CompanyInfo."E-Mail")
            {
            }
            column(ReportTitleLbl; ReportTitleLbl)
            {
            }
            column(DateComptaLbl; DateComptaLbl)
            {
            }
            column(DateLettrageLbl; DateLettrageLbl)
            {
            }
            column(CodeLettrageLbl; CodeLettrageLbl)
            {
            }
            column(RespLettrageLbl; RespLettrageLbl)
            {
            }
            column(TypeDocLbl; TypeDocLbl)
            {
            }
            column(NoDocLbl; NoDocLbl)
            {
            }
            column(NoDocExtLbl; NoDocExtLbl)
            {
            }
            column(DesignationLbl; DesignationLbl)
            {
            }
            column(CodeDeviseLbl; CodeDeviseLbl)
            {
            }
            column(MontantInitialLbl; MontantInitialLbl)
            {
            }
            column(MontantLbl; MontantLbl)
            {
            }
            column(MntLettrageFinLbl; MntLettrageFinLbl)
            {
            }
            column(NoSeqLbl; NoSeqLbl)
            {
            }

            dataitem(Lettrage; "Cust. Ledger Entry")
            {
                DataItemTableView = sorting("Entry No.");
                DataItemLink = "Closed by Entry No." = field("Entry No.");
                DataItemLinkReference = Line;
                column(DocumentNo; Lettrage."Document No.")
                {
                }
                column(PostingDate; Format(Lettrage."Posting Date"))
                {
                }
                column(DateLettrage; Format(Lettrage."Closed at Date"))
                {
                }
                column(User_ID; Lettrage."User ID")
                {
                }
                column(DocumentType; Lettrage."Document Type")
                {
                }
                column(ExternalDocumentNo; Lettrage."External Document No.")
                {
                }
                column(Description; Lettrage.Description)
                {
                }
                column(CurrencyCode; Lettrage."Currency Code")
                {
                }
                column(Original_Amount; Lettrage."Original Amount")
                {
                }
                column(Amount; Lettrage.Amount)
                {
                }
                column(Closed_by_Amount; Lettrage."Closed by Amount")
                {
                }
                column(Entry_No; Lettrage."Entry No.")
                {
                }
                column(UserFullName; UserSetup."User Full Name")
                {
                }
                trigger OnAfterGetRecord()
                begin
                    UserFullName(UserSetup, Lettrage);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if CompanyInfos.Get() then
                    Foot3 := CompanyInfos."Phone No." + ' - Fax : ' + CompanyInfos."Fax No.";
            end;

        }
    }

    requestpage
    {
        SaveValues = true;
        layout
        {
            area(Content)
            {

            }
        }

        actions
        {
        }
    }

    trigger OnPreReport()
    begin
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
    end;

    var
        CompanyInfo: Record "Company Information";
        CompanyInfos: Record "Company Information";
        UserSetup: Record "User Setup";

        Foot3: Text;
        ReportTitleLbl: Label 'ETAT DE LETTRAGE';
        DateComptaLbl: Label 'Date compta';
        DateLettrageLbl: Label 'Date du lettrage';
        CodeLettrageLbl: Label 'Code lettrage';
        RespLettrageLbl: Label 'Responsable du lettrage';
        TypeDocLbl: Label 'Type de document';
        NoDocLbl: Label 'N° document';
        NoDocExtLbl: Label 'N° Doc externe';
        DesignationLbl: Label 'Désignation';
        CodeDeviseLbl: Label 'Code devise';
        MontantInitialLbl: Label 'Montant initial';
        MontantLbl: Label 'Montant';
        MntLettrageFinLbl: Label 'Montant lettrage final';
        NoSeqLbl: Label 'N° séquence';

    procedure UserFullName(var USetup1: record "User Setup"; CLE: Record "Cust. Ledger Entry")
    Var
        UserT: Record "User Setup";
    begin
        Clear(UserT);
        Clear(USetup1);
        UserT.Get(UserId);

        USetup1.SetRange("User ID", CLE."User ID");
        if USetup1.FindFirst() then
            USetup1.CalcFields("User Full Name");
    end;
}