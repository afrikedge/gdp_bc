namespace Microsoft.Bank.Reports;

using Microsoft.Bank.BankAccount;
using Microsoft.Bank.Ledger;
using System.Utilities;

report 50075 "AfkCpteBancaireGrdLivre"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Source/Report/Layout/AfkReport1404.rdl';
    ApplicationArea = Basic, Suite;
    Caption = 'Comptes Bancaire - Grand Livre';
    UsageCategory = ReportsAndAnalysis;
    WordMergeDataItem = "Bank Account";
    DataAccessIntent = ReadOnly;

    dataset
    {
        dataitem("Bank Account"; "Bank Account")
        {
            DataItemTableView = sorting("No.");
            PrintOnlyIfDetail = true;
            RequestFilterFields = "No.", "Search Name", "Bank Acc. Posting Group", "Date Filter";
            column(FilterPeriod_BankAccLedg; StrSubstNo(Text000, DateFilter_BankAccount))
            {
            }
            column(CompanyName; COMPANYPROPERTY.DisplayName())
            {
            }
            column(ExcludeBalanceOnly; ExcludeBalanceOnlyReq)
            {
            }
            column(BankAccFilter; BankAccFilter)
            {
            }
            column(StartBalanceLCY; StartBalanceLCY)
            {
            }
            column(StartBalance; StartBalance)
            {
            }
            column(PrintOnlyOnePerPage; PrintOnlyOnePerPageReq)
            {
            }
            column(ReportFilter; StrSubstNo('%1: %2', TableCaption(), BankAccFilter))
            {
            }
            column(No_BankAccount; "No.")
            {
            }
            column(Name_BankAccount; Name)
            {
            }
            column(PhNo_BankAccount; "Phone No.")
            {
                IncludeCaption = true;
            }
            column(CurrencyCode_BankAccount; "Currency Code")
            {
                IncludeCaption = true;
            }
            column(StartBalance2; StartBalance)
            {
                AutoFormatExpression = "Bank Account Ledger Entry"."Currency Code";
                AutoFormatType = 1;
            }
            column(BankAccDetailTrialBalCap; BankAccDetailTrialBalCapLbl)
            {
            }
            column(CurrReportPageNoCaption; CurrReportPageNoCaptionLbl)
            {
            }
            column(RepInclBankAcchavingBal; RepInclBankAcchavingBalLbl)
            {
            }
            column(BankAccLedgPostingDateCaption; BankAccLedgPostingDateCaptionLbl)
            {
            }
            column(BankAccBalanceCaption; BankAccBalanceCaptionLbl)
            {
            }
            column(OpenFormatCaption; OpenFormatCaptionLbl)
            {
            }
            column(BankAccBalanceLCYCaption; BankAccBalanceLCYCaptionLbl)
            {
            }
            dataitem("Bank Account Ledger Entry"; "Bank Account Ledger Entry")
            {
                DataItemLink = "Bank Account No." = field("No."), "Posting Date" = field("Date Filter"), "Global Dimension 2 Code" = field("Global Dimension 2 Filter"), "Global Dimension 1 Code" = field("Global Dimension 1 Filter");
                DataItemTableView = sorting("Bank Account No.", "Posting Date");
                column(PostingDate_BankAccLedg; Format("Posting Date"))
                {
                }
                column(DocType_BankAccLedg; "Document Type")
                {
                    IncludeCaption = true;
                }
                column(DocNo_BankAccLedg; "Document No.")
                {
                    IncludeCaption = true;
                }
                column(ExtDocNo_BankAccLedg; "External Document No.")
                {
                    IncludeCaption = true;
                }
                column(Desc_BankAccLedg; Description)
                {
                    IncludeCaption = true;
                }
                column(BankAccBalance; BankAccBalance)
                {
                    AutoFormatExpression = "Currency Code";
                    AutoFormatType = 1;
                }
                column(RemaningAmt_BankAccLedg; "Remaining Amount")
                {
                    IncludeCaption = true;
                }
                column(EntryNo_BankAccLedg; "Entry No.")
                {
                    IncludeCaption = true;
                }
                column(OpenFormat; Format(Open))
                {
                }
                column(Amount_BankAccLedg; Amount)
                {
                    IncludeCaption = true;
                }
                column(EntryAmtLcy_BankAccLedg; "Amount (LCY)")
                {
                    IncludeCaption = true;
                }
                column(BankAccBalanceLCY; BankAccBalanceLCY)
                {
                    AutoFormatType = 1;
                }
                column(ContinuedCaption; ContinuedCaptionLbl)
                {
                }
                column(AfkCheckNo; "Check No.")
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if not PrintReversedEntriesReq and Reversed then
                        CurrReport.Skip();
                    BankAccLedgEntryExists := true;
                    BankAccBalance := BankAccBalance + Amount;
                    BankAccBalanceLCY := BankAccBalanceLCY + "Amount (LCY)"
                end;

                trigger OnPreDataItem()
                begin
                    BankAccLedgEntryExists := false;
                end;
            }
            dataitem("Integer"; "Integer")
            {
                DataItemTableView = sorting(Number) where(Number = const(1));

                trigger OnAfterGetRecord()
                begin
                    if not BankAccLedgEntryExists and ((StartBalance = 0) or ExcludeBalanceOnlyReq) then begin
                        StartBalanceLCY := 0;
                        CurrReport.Skip();
                    end;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                StartBalance := 0;
                if DateFilter_BankAccount <> '' then
                    if GetRangeMin("Date Filter") <> 0D then begin
                        SetRange("Date Filter", 0D, GetRangeMin("Date Filter") - 1);
                        CalcFields("Net Change", "Net Change (LCY)");
                        StartBalance := "Net Change";
                        StartBalanceLCY := "Net Change (LCY)";
                        SetFilter("Date Filter", DateFilter_BankAccount);
                    end;
                CurrReport.PrintOnlyIfDetail := ExcludeBalanceOnlyReq or (StartBalance = 0);
                BankAccBalance := StartBalance;
                BankAccBalanceLCY := StartBalanceLCY;

                if PrintOnlyOnePerPageReq then
                    PageGroupNo := PageGroupNo + 1;
            end;

            trigger OnPreDataItem()
            begin
                Clear(StartBalanceLCY);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(PrintOnlyOnePerPage; PrintOnlyOnePerPageReq)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Nouvelle page par banque';
                        ToolTip = 'Indique si vous souhaitez imprimer chaque compte bancaire sur une page distincte.';
                    }
                    field(ExcludeBalanceOnly; ExcludeBalanceOnlyReq)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Exclure seulement les comptes bancaires qui ont un solde ouvert';
                        MultiLine = true;
                        ToolTip = 'Indique si vous ne souhaitez pas que l''état inclue les écritures des comptes bancaires qui ont un solde, mais qui n''ont pas de solde période pour la période sélectionnée.';
                    }
                    field(PrintReversedEntries; PrintReversedEntriesReq)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Inclure écritures contrepasées';
                        ToolTip = 'Indique si vous souhaitez inclure les écritures contrepassées dans l''état.';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        PageGroupNo := 1;
    end;

    trigger OnPreReport()
    begin
        BankAccFilter := "Bank Account".GetFilters();
        DateFilter_BankAccount := "Bank Account".GetFilter("Date Filter");
    end;

    var
        Text000: Label 'Période: %1';
        BankAccFilter: Text;
        DateFilter_BankAccount: Text;
        BankAccBalance: Decimal;
        BankAccBalanceLCY: Decimal;
        PageGroupNo: Integer;
        BankAccDetailTrialBalCapLbl: Label 'Banque : Grand livre';
        CurrReportPageNoCaptionLbl: Label 'Page';
        RepInclBankAcchavingBalLbl: Label 'Cet état inclut aussi les comptes bancaires ne présentent que des soldes.';
        BankAccLedgPostingDateCaptionLbl: Label 'Date comptabilisation';
        BankAccBalanceCaptionLbl: Label 'Solde';
        OpenFormatCaptionLbl: Label 'Ouvert';
        BankAccBalanceLCYCaptionLbl: Label 'Solde DS';
        ContinuedCaptionLbl: Label 'Suite';

    protected var
        BankAccLedgEntryExists: Boolean;
        ExcludeBalanceOnlyReq: Boolean;
        PrintOnlyOnePerPageReq: Boolean;
        PrintReversedEntriesReq: Boolean;
        StartBalance: Decimal;
        StartBalanceLCY: Decimal;

    procedure InitializeRequest(NewPrintOnlyOnePerPage: Boolean; NewExcludeBalanceOnly: Boolean; NewPrintReversedEntries: Boolean)
    begin
        PrintOnlyOnePerPageReq := NewPrintOnlyOnePerPage;
        ExcludeBalanceOnlyReq := NewExcludeBalanceOnly;
        PrintReversedEntriesReq := NewPrintReversedEntries;
    end;
}

