tableextension 50040 "A02 Bank Account Ledger Entry" extends "Bank Account Ledger Entry"
{
    fields
    {
        field(50000; "LC Number"; Code[20])
        {
        }
        field(50001; "LC Curr Purchase Line No."; Integer)
        {
        }
        field(50010; "CC Document Type"; Option)
        {
            Caption = 'CC Document Type';
            OptionCaption = ' ,Chèque règlement,Chèque caution,Chèque commande encours,Espèces,Virement,Orange Money,Traite,Airtel Money,Mvola Money,Orange Money MarchandAirtel Money Marchand';
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
        field(50013; "LC Ech Payment Line No."; Integer)
        {
        }
        field(50100; "Transaction Date"; Date)
        {
            Caption = 'Transaction Date';
            Editable = false;
        }
    }
    keys
    {
        // key(Key1;"LC Number","LC Curr Purchase Line No.",Reversed)
        // {
        // }
    }
}

