table 50003 "Sales Order Pay Doc"
{
    Caption = 'Credit notes / payment';
    DataClassification = CustomerContent;
    DrillDownPageId = "Sales Order Payments";

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(2; "Pay Document No."; Code[20])
        {
            Caption = 'Pay Document No.';
            trigger OnValidate()
            var
                CustLedgerEntry: record "Cust. Ledger Entry";
            begin
                CustLedgerEntry.SetCurrentKey("Document No.");
                CustLedgerEntry.SetRange("Document No.", "Pay Document No.");
                if (CustLedgerEntry.FindFirst()) then begin
                    CustLedgerEntry.CalcFields("Remaining Amt. (LCY)");
                    "Paid Amount" := CustLedgerEntry."Remaining Amt. (LCY)";
                end;
            end;
        }
        field(3; "Paid Amount"; Decimal)
        {
            Caption = 'Paid Amount';
            trigger OnValidate()
            var
                CustLedgerEntry: record "Cust. Ledger Entry";
                ErrLbl: Label 'The amount to be paid must not exceed the open amount %1', comment = '%1';
            begin
                CustLedgerEntry.SetCurrentKey("Document No.");
                CustLedgerEntry.SetRange("Document No.", "Pay Document No.");
                if (CustLedgerEntry.FindFirst()) then begin
                    CustLedgerEntry.CalcFields("Remaining Amt. (LCY)");
                    if (Abs("Paid Amount") > Abs(CustLedgerEntry."Remaining Amt. (LCY)")) then
                        error(ErrLbl, CustLedgerEntry."Remaining Amt. (LCY)")

                end;
            end;
        }
        field(4; "Pay Doc Entry No."; integer)
        {
            Caption = 'Pay Doc Entry No.';
        }
        field(5; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
        }
        field(6; "Frontdesk Pay Method"; Code[20])
        {
            Caption = 'Frontdesk Payment Method';
            TableRelation = "Afk Reference".Code where(TableType = const("Payment Method"));
        }
        field(7; "Frontdesk Pay Method Name"; Text[100])
        {
            Caption = 'Frontdesk Payment Method Name';
            Editable = false;
            FieldClass = FlowField;
            CalcFormula = lookup("Afk Reference".Description where(TableType = const("Payment Method"), Code = field("Frontdesk Pay Method")));
        }
        field(9; "Frontdesk Reference"; Code[60])
        {
            Caption = 'Frontdesk Reference';
        }
        field(10; "Frontdesk Amount"; Decimal)
        {
            Caption = 'Frontdesk Amount';
        }
        field(11; "Frontdesk Observations"; Text[300])
        {
            Caption = 'Frontdesk Observations';
        }
        field(12; "Line No."; Integer)
        {
            Caption = 'Frontdesk Observations';
        }
    }
    keys
    {
        key(PK; "Customer No.", "Document No.", "Pay Document No.", "Line No.")
        {
            Clustered = true;
        }
    }
}
