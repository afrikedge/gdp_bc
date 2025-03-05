report 50051 "Recu Encais_Ecritures clients"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Source/Report/Layout/Recu Encais_Ecritures clients.rdlc';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
        {
            RequestFilterFields = "Customer No.", "Posting Date", "Document Type";
            column(UserID; User."User Name")
            {
            }
            column(UserName; User."Full Name")
            {
            }
            column(Devise1; Devise1)
            {
            }
            column(Devise2; Devise2)
            {
            }
            column(PostingDate_GenJnlLine; Format("Posting Date", 0, 4))
            {
            }
            column(DocType_GenJnlLine; "Document Type")
            {
            }
            column(DocNo_GenJnlLine; "Document No.")
            {
            }
            column(AccountNo_GenJnlLine; "Customer No.")
            {
            }
            column(ModeRG; ModeRG)
            {
            }
            column(Description_GenJnlLine; Description)
            {
            }
            column(Amount_GenJnlLine; Amount)
            {
            }
            column(CurrencyCode_GenJnlLine; "Currency Code")
            {
            }
            column(BalAccNo_GenJnlLine; "Bal. Account No.")
            {
            }
            column(AmountLCY_GenJnlLine; "Amount (LCY)")
            {
            }
            column(Cust_Name; Cust.Name)
            {
            }
            column(TotalAmountLetter; Amount_InWords)
            {
            }
            column(NoTitre; "Check No.")
            {
            }
            column(CompanyInfoEMail; CompanyInfo."E-Mail")
            {
            }
            column(CompanyInfoRCS; ' - R.C.S. : ' + CompanyInfo."Trade Register")
            {
            }
            column(CompanyInfoCA; 'S.A. au capital de AR ' + CompanyInfo."Stock Capital")
            {
            }
            column(CompanyInfoNIF; 'NIF : ' + CompanyInfo."Registration No.")
            {
            }
            column(CompanyInfoSTAT; 'STAT : ' + CompanyInfo."Legal Form")
            {
            }
            column(CompanyInfoPhoneNo; CompanyInfo."Phone No.")
            {
            }
            column(CompanyInfoFax; CompanyInfo."Fax No.")
            {
            }
            column(CompanyInfo_Picture; CompanyInfo.Picture)
            {
            }
            column(PhoneNoCaption; PhoneNoCaptionLbl)
            {
            }
            column(FaxCaption; FaxCaptionLbl)
            {
            }
            column(CompanyAddr1; CompanyAddr[1])
            {
            }
            column(CompanyAddr2; CompanyAddr[2])
            {
            }
            column(CompanyAddr3; CompanyAddr[3])
            {
            }
            column(CompanyAddr4; CompanyAddr[4])
            {
            }
            column(TelCaption; TelCaption)
            {
            }
            column(BPCaption; BPCaption)
            {
            }
            column(EmailCaption; EmailCaption)
            {
            }
            dataitem(Facture; "Integer")
            {
                DataItemTableView = SORTING(Number) ORDER(Ascending);
                column(DocumentNo; DocumentNo)
                {
                }
                column(DocDate; Format(DocDate))
                {
                }
                column(DocDescrip; DocDescrip)
                {
                }
                column(AmountLCY; AmountToApply)
                {
                }
                column(RefCust; RefCust)
                {
                }
                column(CustNo; CustNo)
                {
                }
                column(OrderNo; OrderNo)
                {
                }

                trigger OnAfterGetRecord()
                var
                    Amt: Decimal;
                begin
                    //MESSAGE('entree  %1',TmpDetCustLedgEntry."Document No.");
                    /*IF Number = 1 THEN
                      TmpDetCustLedgEntry.FIND('-')
                    ELSE
                      TmpDetCustLedgEntry.NEXT;
                      */

                    //MESSAGE('entree  %1',TmpDetCustLedgEntry."Document No.");

                    /*
                    
                    DocumentNo:=TmpDetCustLedgEntry."Document No.";
                    //RefCust:=CustLedgEntry."External Document No.";
                    DocDate:=TmpDetCustLedgEntry."Posting Date";
                    //DocDescrip:=CustLedgEntry.Description;
                    CustNo:= TmpDetCustLedgEntry."Customer No.";
                    //DetCustLedgEntry.CALCFIELDS("Amount (LCY)");
                    AmountLCY:=(TmpDetCustLedgEntry."Amount (LCY)");
                    AmountToApply:=(TmpDetCustLedgEntry.Amount);
                    */

                    compteurLignes := compteurLignes + 1;
                    DocumentNo := TabValues[compteurLignes] [1];
                    //DocDate := TmpDetCustLedgEntry."Posting Date";
                    CustNo := "Cust. Ledger Entry"."Customer No.";
                    if Evaluate(Amt, TabValues[compteurLignes] [2]) then;
                    AmountLCY := -Amt;
                    AmountToApply := (AmountLCY);


                    OrderNo := '';
                    if SalesInv.Get(DocumentNo) then
                        OrderNo := SalesInv."Order No.";
                    //IF TmpDetCustLedgEntry.NEXT<>0 THEN;
                    //MESSAGE('entree 2  %1',TmpDetCustLedgEntry."Document No.");

                end;

                trigger OnPreDataItem()
                begin
                    SetRange(Number, 1, compteurTab);
                    //IF TmpDetCustLedgEntry.FINDSET THEN;
                    DocumentNo := '';
                    RefCust := '';
                    DocDate := 0D;
                    AmountLCY := 0;
                    CustNo := '';
                    OrderNo := '';
                    DocDescrip := '';
                    AmountLCY := 0;
                    AmountToApply := 0;
                    compteurLignes := 0;
                end;
            }

            trigger OnAfterGetRecord()
            var
                PaymentTerms: Record "Payment Terms";
                DimMgt: Codeunit DimensionManagement;
                TableID: array[10] of Integer;
                No: array[10] of Code[20];
            begin
                //CLEARALL;
                compteurTab := 0;

                FormatAddr.Company(CompanyAddr, CompanyInfo);

                //IF UserSetup.GET(USERID) THEN
                //IF UserSetup.GET(USERID) THEN
                //  UserSetup.CALCFIELDS("User Full Name");
                User.SetRange(User."User Name", UserId);
                if User.FindFirst then;

                if ("Currency Code" = '') or ("Currency Code" = 'MGA') then begin
                    Devise1 := 'MGA';
                    Devise2 := 'Ar';
                    DevTrans := 'Ar'
                end else begin
                    Devise1 := "Currency Code";
                    Devise2 := "Currency Code";
                    DevTrans := "Currency Code";
                end;
                Cust.Get("Cust. Ledger Entry"."Customer No.");
                //TmpDetCustLedgEntry.RESET;
                //TmpDetCustLedgEntry.SETRANGE(DetCustLedgEntry."Cust. Ledger Entry No.","Cust. Ledger Entry"."Entry No.");
                //TmpDetCustLedgEntry.SETRANGE(DetCustLedgEntry."Entry Type",DetCustLedgEntry."Entry Type"::Application);
                FindApplnEntriesDtldtLedgEntry("Cust. Ledger Entry"."Entry No.", "Cust. Ledger Entry"."Document No.");

                //CustLedgEntry.RESET;
                //CustLedgEntry.SETRANGE(CustLedgEntry."Customer No.","Cust. Ledger Entry"."Customer No.");
                //CustLedgEntry.SETRANGE(CustLedgEntry."Closed by Entry No.","Cust. Ledger Entry"."Entry No.");
                //Counter := TmpDetCustLedgEntry.COUNT;

                if ("Cust. Ledger Entry"."CC Document Type" = "Cust. Ledger Entry"."CC Document Type"::ChequeNormal) or
                  ("Cust. Ledger Entry"."CC Document Type" = "Cust. Ledger Entry"."CC Document Type"::ChequeCaution) or
                  ("Cust. Ledger Entry"."CC Document Type" = "Cust. Ledger Entry"."CC Document Type"::ChequeGarantie) then
                    ModeRG := 'CHEQUE';
                if ("Cust. Ledger Entry"."CC Document Type" = "Cust. Ledger Entry"."CC Document Type"::Especes) then
                    ModeRG := 'ESPECE';
                if ("Cust. Ledger Entry"."CC Document Type" = "Cust. Ledger Entry"."CC Document Type"::Traite) then
                    ModeRG := 'TRAITE';
                if ("Cust. Ledger Entry"."CC Document Type" = "Cust. Ledger Entry"."CC Document Type"::Virement) then
                    ModeRG := 'VIREMENT';
                if ("Cust. Ledger Entry"."CC Document Type" = "Cust. Ledger Entry"."CC Document Type"::MobileMoney) then
                    ModeRG := 'ORANGE MONEY';
                if ("Cust. Ledger Entry"."CC Document Type" = "Cust. Ledger Entry"."CC Document Type"::MobileMoney3) then
                    ModeRG := 'MOBILE MONEY';
                if ("Cust. Ledger Entry"."CC Document Type" = "Cust. Ledger Entry"."CC Document Type"::MobileMoney2) then
                    ModeRG := 'MOBILE MONEY';

                //IF TmpDetCustLedgEntry.FINDSET THEN;
                NbTLet.InitTextVariable;
                NbTLet.FormatNoText(TotalAmountLetter, Abs("Cust. Ledger Entry".Amount), "Cust. Ledger Entry"."Currency Code");


                Amount_InWords := TotalAmountLetter[1] + ' ' + TotalAmountLetter[2];
            end;

            trigger OnPreDataItem()
            begin
                GLSetup.Get;
            end;
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
        Text001 = 'Reçu Encaissement';
        Text002 = 'N° Encaiss.';
        Text004 = 'Référence :';
        Text005 = 'Date';
        Text006 = 'Récu la somme de :';
        Text008 = 'Code client :';
        Text009 = 'Nom client :';
        Text010 = 'Mode règlt :';
        Text011 = 'N° Chèque';
        Text012 = 'Le Client';
        Text013 = 'Nom et signature';
        // The label 'Text014' could not be exported.
        Text015 = 'Réf Commande';
        Text016 = 'N°';
        Text017 = 'Montant';
        Text018 = 'Total (Ar)';
        Text019 = 'Date/Heure saisie :';
        Text10 = 'Siège Social';
        Text020 = 'Reçu par :';
    }

    trigger OnInitReport()
    begin
        CompanyInfo.Get;
        CompanyInfo.CalcFields(Picture);
    end;

    var
        Devise1: Text[20];
        Devise2: Text[20];
        GLSetup: Record "General Ledger Setup";
        SalesSetup: Record "Sales & Receivables Setup";
        PurchSetup: Record "Purchases & Payables Setup";
        UserSetup: Record "User Setup";
        GenJnlLineFilter: Text;
        ComBank: Record "Bank Account";
        DevBank: Text[20];
        DevTrans: Text[20];
        BankMess: Text[50];
        Cust: Record Customer;
        NbTLet: Report Check;
        TotalAmountLetter: array[2] of Text[150];
        ComBankCode: Text[30];
        Reference: Text[30];
        TmpDetCustLedgEntry: Record "Detailed Cust. Ledg. Entry" temporary;
        Counter: Integer;
        DocumentNo: Code[20];
        DocDescrip: Text[100];
        DocDate: Date;
        AmountLCY: Decimal;
        RefCust: Text[20];
        CustNo: Code[20];
        AmountToApply: Decimal;
        SalesInv: Record "Sales Invoice Header";
        OrderNo: Text[20];
        CompanyInfo: Record "Company Information";
        CompanyAddr: array[8] of Text[50];
        PhoneNoCaptionLbl: Label 'Phone No.';
        EMailCaptionLbl: Label 'E-Mail';
        FaxCaptionLbl: Label 'Fax : ';
        // Text007: ;
        FormatAddr: Codeunit "Format Address";
        TelCaption: Label 'Tél/Fax : ';
        BPCaption: Label 'BP : ';
        EmailCaption: Label 'Email : ';
        ModeRG: Text[20];
        CustLedgEntry: Record "Cust. Ledger Entry";
        TableauRec: Record "Detailed Cust. Ledg. Entry";
        TabValues: array[100, 3] of Text[50];
        compteurTab: Integer;
        compteurLignes: Integer;
        Amount_InWords: Text;
        User: Record User;

    local procedure FindApplnEntriesDtldtLedgEntry(AppliedEntryNo: Integer; DocNo: Code[20])
    var
        DtldCustLedgEntry1: Record "Detailed Cust. Ledg. Entry";
        DtldCustLedgEntry2: Record "Detailed Cust. Ledg. Entry";
        CustLedgEntry: Record "Cust. Ledger Entry";
        detLedgEntry: Record "Detailed Cust. Ledg. Entry";
    begin
        DtldCustLedgEntry1.SetCurrentKey("Cust. Ledger Entry No.");
        DtldCustLedgEntry1.SetRange("Cust. Ledger Entry No.", AppliedEntryNo);
        DtldCustLedgEntry1.SetRange(Unapplied, false);
        if DtldCustLedgEntry1.Find('-') then
            repeat
                if DtldCustLedgEntry1."Cust. Ledger Entry No." =
                   DtldCustLedgEntry1."Applied Cust. Ledger Entry No."
                then begin
                    DtldCustLedgEntry2.Init;
                    DtldCustLedgEntry2.SetCurrentKey("Applied Cust. Ledger Entry No.", "Entry Type");
                    DtldCustLedgEntry2.SetRange(
                      "Applied Cust. Ledger Entry No.", DtldCustLedgEntry1."Applied Cust. Ledger Entry No.");
                    DtldCustLedgEntry2.SetRange("Entry Type", DtldCustLedgEntry2."Entry Type"::Application);
                    DtldCustLedgEntry2.SetRange(Unapplied, false);
                    if DtldCustLedgEntry2.Find('-') then
                        repeat
                            if DtldCustLedgEntry2."Cust. Ledger Entry No." <>
                               DtldCustLedgEntry2."Applied Cust. Ledger Entry No."
                            then begin
                                CustLedgEntry.SetCurrentKey("Entry No.");
                                CustLedgEntry.SetRange("Entry No.", DtldCustLedgEntry2."Cust. Ledger Entry No.");
                                if CustLedgEntry.Find('-') then begin
                                    //MARK(TRUE);
                                    compteurTab := compteurTab + 1;
                                    TabValues[compteurTab] [1] := CustLedgEntry."Document No.";
                                    //MESSAGE('%1',CustLedgEntry."Document No.");
                                    detLedgEntry.Reset;
                                    detLedgEntry.SetRange(detLedgEntry."Cust. Ledger Entry No.", CustLedgEntry."Entry No.");
                                    detLedgEntry.SetRange(detLedgEntry."Entry Type", detLedgEntry."Entry Type"::Application);
                                    detLedgEntry.SetRange(detLedgEntry."Document No.", DocNo);
                                    if detLedgEntry.FindFirst then
                                        TabValues[compteurTab] [2] := Format(detLedgEntry."Amount (LCY)");
                                    //MESSAGE('%1',TabValues[compteurTab][2]);
                                end;
                            end;
                        until DtldCustLedgEntry2.Next = 0;
                end else begin
                    CustLedgEntry.SetCurrentKey("Entry No.");
                    CustLedgEntry.SetRange("Entry No.", DtldCustLedgEntry1."Applied Cust. Ledger Entry No.");
                    if CustLedgEntry.Find('-') then begin
                        //MARK(TRUE);
                        compteurTab := compteurTab + 1;
                        TabValues[compteurTab] [1] := CustLedgEntry."Document No.";
                        detLedgEntry.Reset;
                        detLedgEntry.SetRange(detLedgEntry."Cust. Ledger Entry No.", CustLedgEntry."Entry No.");
                        detLedgEntry.SetRange(detLedgEntry."Entry Type", detLedgEntry."Entry Type"::Application);
                        detLedgEntry.SetRange(detLedgEntry."Document No.", DocNo);
                        if detLedgEntry.FindFirst then
                            TabValues[compteurTab] [2] := Format(detLedgEntry."Amount (LCY)");
                    end;
                end;
            until DtldCustLedgEntry1.Next = 0;
    end;
}

