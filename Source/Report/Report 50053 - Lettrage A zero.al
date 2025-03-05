report 50053 "Lettrage A zero"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Source/Report/Layout/Lettrage A zero.rdlc';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Cust. Ledger Entry"; "Cust. Ledger Entry")
        {
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
            column(PostingDate_GenJnlLine; Format(Today, 0, 4))
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
                column(ExtDocNo; ExtDocNo)
                {
                }
                column(DocDateDescr; DocDateDescr)
                {
                }
                column(OriginLine; OriginLine)
                {
                }
                column(LineNum; compteurLignes)
                {
                }

                trigger OnAfterGetRecord()
                var
                    Amt: Decimal;
                begin

                    compteurLignes := compteurLignes + 1;
                    DocumentNo := TabValues[compteurLignes] [1];
                    CustNo := "Cust. Ledger Entry"."Customer No.";
                    if Evaluate(Amt, TabValues[compteurLignes] [2]) then;
                    AmountLCY := Amt;
                    AmountToApply := (AmountLCY);

                    DocDescrip := TabValues[compteurLignes] [4];
                    DocDateDescr := TabValues[compteurLignes] [5];
                    ExtDocNo := TabValues[compteurLignes] [3];
                    //EVALUATE(EntryNum , TabValues[compteurTab][6] );
                    //MESSAGE('%1',TabValues[compteurLignes][2]);

                    OriginLine := false;
                    if compteurLignes = 1 then OriginLine := true;
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
                end;
            }

            trigger OnAfterGetRecord()
            var
                PaymentTerms: Record "Payment Terms";
                DimMgt: Codeunit DimensionManagement;
                TableID: array[10] of Integer;
                No: array[10] of Code[20];
            begin

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
                FindApplnEntriesDtldtLedgEntry_New("Cust. Ledger Entry");


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
        Text001 = 'Transactions client';
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
        TabValues: array[1000, 5] of Text[50];
        compteurTab: Integer;
        compteurLignes: Integer;
        User: Record User;
        ExtDocNo: Text[50];
        DocDateDescr: Text[30];
        OriginLine: Boolean;
        LineNum: Integer;
        EntryNum: Integer;
        Amount_InWords: Text;

    local procedure FindApplnEntriesDtldtLedgEntry(AppliedEntryNo: Integer; DocNo: Code[20]; EcritureOrigine: Record "Cust. Ledger Entry")
    var
        DtldCustLedgEntry1: Record "Detailed Cust. Ledg. Entry";
        DtldCustLedgEntry2: Record "Detailed Cust. Ledg. Entry";
        CustLedgEntry: Record "Cust. Ledger Entry";
        detLedgEntry: Record "Detailed Cust. Ledg. Entry";
    begin

        //TabValues[compteurTab][1] Document No
        //TabValues[compteurTab][2] Montant
        //TabValues[compteurTab][3] External Doc No
        //TabValues[compteurTab][4] Description
        //TabValues[compteurTab][5] DAte


        //Ecritureorigine
        compteurTab := compteurTab + 1;
        TabValues[compteurTab] [1] := EcritureOrigine."Document No.";
        TabValues[compteurTab] [3] := EcritureOrigine."External Document No.";
        TabValues[compteurTab] [4] := EcritureOrigine.Description;
        TabValues[compteurTab] [5] := Format(EcritureOrigine."Posting Date");
        EcritureOrigine.CalcFields(EcritureOrigine."Original Amt. (LCY)");
        TabValues[compteurTab] [2] := Format(EcritureOrigine."Original Amt. (LCY)");



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
                                    TabValues[compteurTab] [3] := CustLedgEntry."External Document No.";
                                    TabValues[compteurTab] [4] := CustLedgEntry.Description;
                                    TabValues[compteurTab] [5] := Format(CustLedgEntry."Posting Date");

                                    detLedgEntry.Reset;
                                    detLedgEntry.SetRange(detLedgEntry."Cust. Ledger Entry No.", CustLedgEntry."Entry No.");
                                    detLedgEntry.SetRange(detLedgEntry."Entry Type", detLedgEntry."Entry Type"::Application);
                                    detLedgEntry.SetRange(Unapplied, false);
                                    detLedgEntry.SetRange(detLedgEntry."Document No.", DocNo);
                                    if detLedgEntry.FindFirst then
                                        TabValues[compteurTab] [2] := Format(-detLedgEntry."Amount (LCY)");
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
                        TabValues[compteurTab] [3] := CustLedgEntry."External Document No.";
                        TabValues[compteurTab] [4] := CustLedgEntry.Description;
                        TabValues[compteurTab] [5] := Format(CustLedgEntry."Posting Date");

                        detLedgEntry.Reset;
                        detLedgEntry.SetRange(detLedgEntry."Cust. Ledger Entry No.", CustLedgEntry."Entry No.");
                        detLedgEntry.SetRange(detLedgEntry."Entry Type", detLedgEntry."Entry Type"::Application);
                        detLedgEntry.SetRange(detLedgEntry."Document No.", DocNo);
                        detLedgEntry.SetRange(Unapplied, false);
                        if detLedgEntry.FindFirst then
                            TabValues[compteurTab] [2] := Format(-detLedgEntry."Amount (LCY)");
                    end;
                end;
            until DtldCustLedgEntry1.Next = 0;
    end;

    local procedure FindApplnEntriesDtldtLedgEntry_New(EcritureOrigine: Record "Cust. Ledger Entry")
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
        detLedgEntry: Record "Detailed Cust. Ledg. Entry";
        DtldCustLedgEntry2: Record "Detailed Cust. Ledg. Entry";
        DtldCustLedgEntry: Record "Detailed Cust. Ledg. Entry";
    begin

        //Ecritureorigine
        compteurTab := compteurTab + 1;
        TabValues[compteurTab] [1] := EcritureOrigine."Document No.";
        TabValues[compteurTab] [3] := EcritureOrigine."External Document No.";
        TabValues[compteurTab] [4] := EcritureOrigine.Description;
        TabValues[compteurTab] [5] := Format(EcritureOrigine."Posting Date");
        EcritureOrigine.CalcFields(EcritureOrigine."Original Amt. (LCY)");
        TabValues[compteurTab] [2] := Format(EcritureOrigine."Original Amt. (LCY)");
        //TabValues[compteurTab][6] := FORMAT(EcritureOrigine."Entry No.");



        DtldCustLedgEntry2.Reset;
        DtldCustLedgEntry2.SetCurrentKey("Cust. Ledger Entry No.", "Entry Type", "Posting Date");
        DtldCustLedgEntry2.SetRange("Cust. Ledger Entry No.", EcritureOrigine."Entry No.");
        DtldCustLedgEntry2.SetRange("Entry Type", DtldCustLedgEntry2."Entry Type"::Application);
        DtldCustLedgEntry2.SetRange(Unapplied, false);
        if DtldCustLedgEntry2.FindSet then
            repeat

                if DtldCustLedgEntry2."Transaction No." = 0 then begin
                    DtldCustLedgEntry.SetCurrentKey("Application No.", "Customer No.", "Entry Type");
                    DtldCustLedgEntry.SetRange("Application No.", DtldCustLedgEntry2."Application No.");
                end else begin
                    DtldCustLedgEntry.SetCurrentKey("Transaction No.", "Customer No.", "Entry Type");
                    DtldCustLedgEntry.SetRange("Transaction No.", DtldCustLedgEntry2."Transaction No.");
                end;
                DtldCustLedgEntry.SetRange("Customer No.", DtldCustLedgEntry2."Customer No.");

                if DtldCustLedgEntry.FindSet then
                    repeat
                        if (DtldCustLedgEntry."Entry Type" <> DtldCustLedgEntry."Entry Type"::"Initial Entry") and
                           not DtldCustLedgEntry.Unapplied and (DtldCustLedgEntry.Amount * DtldCustLedgEntry2.Amount < 0)
                        then begin
                            compteurTab := compteurTab + 1;
                            CustLedgEntry.Get(DtldCustLedgEntry."Cust. Ledger Entry No.");
                            TabValues[compteurTab] [1] := CustLedgEntry."Document No.";
                            TabValues[compteurTab] [3] := CustLedgEntry."External Document No.";
                            TabValues[compteurTab] [4] := CustLedgEntry.Description;
                            TabValues[compteurTab] [5] := Format(CustLedgEntry."Posting Date");

                            if Abs(DtldCustLedgEntry."Amount (LCY)") < Abs(DtldCustLedgEntry2."Amount (LCY)") then
                                TabValues[compteurTab] [2] := Format(-DtldCustLedgEntry."Amount (LCY)")
                            else
                                TabValues[compteurTab] [2] := Format(DtldCustLedgEntry2."Amount (LCY)");
                            //TabValues[compteurTab][6] := FORMAT(DtldCustLedgEntry."Entry No.");
                            //Rec := DtldCustLedgEntry;
                            //INSERT;
                        end;
                    until DtldCustLedgEntry.Next = 0;

            until DtldCustLedgEntry2.Next = 0;
    end;
}

