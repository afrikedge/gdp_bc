tableextension 70000122 tableextension70000122 extends "Payment Method" 
{
    fields
    {
        field(50000;"CC Document Type";Option)
        {
            Caption = 'CC Document Type';
            OptionCaption = ' ,Chèque règlement,Chèque caution,Chèque commande encours,Espèces,Virement,Orange Money,Traite,Airtel Money,Mvola Money';
            OptionMembers = " ",ChequeNormal,ChequeCaution,ChequeGarantie,Especes,Virement,MobileMoney,Traite,MobileMoney2,MobileMoney3;
        }
        field(50001;"Allow vendor email";Boolean)
        {
            Caption = 'Allow vendor email';
        }
    }
}

