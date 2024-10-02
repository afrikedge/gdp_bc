table 50002 "Reconciliation Info"
{

    fields
    {
        field(1;"Entry No.";Integer)
        {
            AutoIncrement = true;
            Caption = 'Entry No.';
        }
        field(2;"Journal Template Name";Code[10])
        {
            Caption = 'Journal Template Name';
            Editable = false;
            TableRelation = "Gen. Journal Template";
        }
        field(3;"Line No.";Integer)
        {
            Caption = 'Line No.';
            Editable = false;
        }
        field(4;"Journal Batch Name";Code[10])
        {
            Caption = 'Journal Batch Name';
            Editable = false;
            TableRelation = "Gen. Journal Batch".Name WHERE ("Journal Template Name"=FIELD("Journal Template Name"));
        }
        field(5;"G/L Entry No";Integer)
        {
            Editable = false;
        }
        field(6;"Order No";Code[20])
        {
            Caption = 'Order N°';
            TableRelation = "Sales Header"."No." WHERE ("Document Type"=CONST(Order),
                                                        "Sell-to Customer No."=FIELD("Customer No."));
            ValidateTableRelation = false;
        }
        field(7;"Invoice No";Code[20])
        {
            Caption = 'Invoice N°';
            TableRelation = "Sales Invoice Header"."No." WHERE ("Sell-to Customer No."=FIELD("Customer No."),
                                                                "Remaining Amount"=FILTER(>0));
            ValidateTableRelation = false;

            trigger OnLookup()
            var
                CustLedgEntry: Record "Cust. Ledger Entry";
                ReconInfo: Record "Reconciliation Info";
            begin
                with ReconInfo do begin
                  ReconInfo := Rec;
                  CustLedgEntry.SetCurrentKey("Customer No.",Open,Positive,"Due Date","Currency Code");
                  CustLedgEntry.SetRange(CustLedgEntry."Customer No.",Rec."Customer No.");
                  CustLedgEntry.SetRange(Open,true);
                  CustLedgEntry.SetRange(Positive,true);
                  if PAGE.RunModal(50314,CustLedgEntry) = ACTION::LookupOK then begin
                    "Invoice No" := CustLedgEntry."Document No.";
                    Validate("Invoice No");
                    Rec := ReconInfo;
                  end;
                end;
            end;

            trigger OnValidate()
            var
                SalesInvH: Record "Sales Invoice Header";
                CustLedgEntry: Record "Cust. Ledger Entry";
            begin
                if SalesInvH.Get("Invoice No") then begin
                  "Order No" := SalesInvH."Order No.";
                  //IF Amount=0 THEN BEGIN
                    SalesInvH.CalcFields("Remaining Amount");
                    Amount:=SalesInvH."Remaining Amount";
                  //END;
                end else begin
                  CustLedgEntry.SetCurrentKey("Customer No.","Document No.","Posting Date");
                  CustLedgEntry.SetRange(CustLedgEntry."Customer No.","Customer No.");
                  CustLedgEntry.SetRange(CustLedgEntry."Document No.","Invoice No");
                  if CustLedgEntry.FindFirst then begin
                    CustLedgEntry.CalcFields("Remaining Amount");
                    Amount:=CustLedgEntry."Remaining Amount";
                  end;
                end;
            end;
        }
        field(8;Amount;Decimal)
        {
            Caption = 'Amount';
        }
        field(9;"Customer No.";Code[20])
        {
            Caption = 'Customer No.';
            Editable = false;
            TableRelation = Customer;
        }
    }

    keys
    {
        key(Key1;"Entry No.")
        {
        }
    }

    fieldgroups
    {
    }
}

