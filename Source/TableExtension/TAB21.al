tableextension 50006 "A02 Cust. Ledger Entry" extends "Cust. Ledger Entry"
{
    fields
    {
        field(50000; "Customer Name2"; Text[100])
        {
            CalcFormula = Lookup(Customer.Name WHERE("No." = FIELD("Customer No.")));
            Caption = 'Customer Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50010; "CC Document Type"; Option)
        {
            Caption = 'CC Document Type';
            OptionCaption = ' ,Chèque règlement,Chèque caution,Chèque commande encours,Espèces,Virement,Orange Money,Traite,Airtel Money,Mvola Money,Orange Money Marchand,Airtel Money Marchand';
            OptionMembers = " ",ChequeNormal,ChequeCaution,ChequeGarantie,Especes,Virement,MobileMoney,Traite,MobileMoney2,MobileMoney3,MobileMoney4,MobileMoney5;
        }
        field(50011; "Check No."; Code[20])
        {
            Caption = 'Check No.';
        }
        field(50012; "Check Date"; Date)
        {
            Caption = 'Check Date';
        }
        field(50100; "Transaction Date"; Date)
        {
            Caption = 'Transaction Date';
            Editable = false;
        }
    }
}

