report 50082 "Recu Encais_Ecritures clients2"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Source/Report/Layout/Recu Encais_Ecritures clients2.rdlc';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("G/L Entry"; "G/L Entry")
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
            column(PostingDate_GenJnlLine; Format("Posting Date", 0, 4))
            {
            }
            column(DocType_GenJnlLine; "Document Type")
            {
            }
            column(DocNo_GenJnlLine; "Document No.")
            {
            }
            column(AccountNo_GenJnlLine; "G/L Entry"."External Document No.")
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
            column(CurrencyCode_GenJnlLine; '')
            {
            }
            column(BalAccNo_GenJnlLine; "Bal. Account No.")
            {
            }
            column(AmountLCY_GenJnlLine; "G/L Entry".Amount)
            {
            }
            column(Cust_Name; Cust.Name)
            {
            }
            column(TotalAmountLetter; Amount_InWords)
            {
            }
            column(NoTitre; "G/L Entry"."Document No.")
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
            dataitem(Facture; "Reconciliation Info")
            {
                DataItemLink = "G/L Entry No" = FIELD("Entry No.");
                DataItemTableView = SORTING("Entry No.") ORDER(Ascending);
                column(DocumentNo; Facture."Invoice No")
                {
                }
                column(DocDate; Format(DocDate))
                {
                }
                column(DocDescrip; DocDescrip)
                {
                }
                column(AmountLCY; Facture.Amount)
                {
                }
                column(RefCust; RefCust)
                {
                }
                column(CustNo; Facture."Customer No.")
                {
                }
                column(OrderNo; Facture."Order No")
                {
                }

                trigger OnAfterGetRecord()
                var
                    Amt: Decimal;
                begin

                    /*
                    compteurLignes:=compteurLignes+1;
                    DocumentNo:=TabValues[compteurLignes][1];
                    
                    //CustNo:= "Cust. Ledger Entry"."Customer No.";
                    CustNo:="G/L Entry"."External Document No.";
                    
                    {
                    IF EVALUATE(Amt,TabValues[compteurLignes][2]) THEN;
                    AmountLCY:=-Amt;
                    AmountToApply:=(AmountLCY);
                    }
                    
                    
                    OrderNo:='';
                    IF SalesInv.GET(DocumentNo) THEN
                      OrderNo:=SalesInv."Order No.";
                    
                    */

                end;

                trigger OnPreDataItem()
                begin
                    /*
                    SETRANGE(Number,1,compteurTab);
                    
                    DocumentNo:='';
                    RefCust:='';
                    DocDate:=0D;
                    AmountLCY:=0;
                    CustNo:='';
                    OrderNo:='';
                    DocDescrip:='';
                    AmountLCY:=0;
                    AmountToApply:=0;
                    */

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

                User.SetRange(User."User Name", UserId);
                if User.FindFirst then;

                //IF ("Currency Code" = '') OR ("Currency Code"='MGA')THEN BEGIN
                Devise1 := 'MGA';
                Devise2 := 'Ar';
                DevTrans := 'Ar';
                /*END ELSE BEGIN
                  Devise1:="Currency Code";
                  Devise2:="Currency Code";
                  DevTrans:="Currency Code";
                END;*/

                Cust.Get("G/L Entry"."External Document No.");

                //FindApplnEntriesDtldtLedgEntry("Cust. Ledger Entry"."Entry No.","Cust. Ledger Entry"."Document No.");


                /*
                IF ("G/L Entry"."CC Document Type" = "G/L Entry"."CC Document Type"::"1") OR
                  ("G/L Entry"."CC Document Type"="G/L Entry"."CC Document Type"::"2") OR
                  ("G/L Entry"."CC Document Type"="G/L Entry"."CC Document Type"::"3") THEN
                  ModeRG:='CHEQUE';
                IF ("G/L Entry"."CC Document Type"="G/L Entry"."CC Document Type"::"4") THEN
                  ModeRG:='ESPECE';
                IF ("G/L Entry"."CC Document Type"="G/L Entry"."CC Document Type"::"7") THEN
                  ModeRG:='TRAITE';
                IF ("G/L Entry"."CC Document Type"="G/L Entry"."CC Document Type"::"5") THEN
                  ModeRG:='VIREMENT';
                IF ("G/L Entry"."CC Document Type"="G/L Entry"."CC Document Type"::"6") THEN
                  ModeRG:='ORANGE MONEY';
                IF ("G/L Entry"."CC Document Type"="G/L Entry"."CC Document Type"::"9") THEN
                  ModeRG:='MOBILE MONEY';
                IF ("G/L Entry"."CC Document Type"="G/L Entry"."CC Document Type"::"8") THEN
                  ModeRG:='MOBILE MONEY';
                  */

                NbTLet.InitTextVariable;

                NbTLet.FormatNoText(TotalAmountLetter, Abs("G/L Entry".Amount), '');

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
        DocDescrip: Text[60];
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
        User: Record User;
        Amount_InWords: Text;

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

