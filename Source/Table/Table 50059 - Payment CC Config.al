table 50059 "Payment CC Config"
{
    Caption = 'Payment CC Config';

    fields
    {
        field(1;"Journal Template Name";Code[10])
        {
            Caption = 'Journal Template Name';
            TableRelation = "Gen. Journal Template";
        }
        field(2;"Journal Batch Name";Code[10])
        {
            Caption = 'Journal Batch Name';
            TableRelation = "Gen. Journal Batch".Name WHERE ("Journal Template Name"=FIELD("Journal Template Name"));
        }
        field(3;"CC Document Type";Option)
        {
            Caption = 'CC Document Type';
            OptionCaption = ' ,Chèque règlement,Chèque caution,Chèque commande encours,Espèces,Virement,Orange Money,Traite,Airtel Money,Mvola Money,Fonds de garantie';
            OptionMembers = " ",ChequeNormal,ChequeCaution,ChequeGarantie,Especes,Virement,MobileMoney,Traite,MobileMoney2,MobileMoney3,FondsGarantie;
        }
        field(4;"Payment Class";Text[30])
        {
            Caption = 'Payment Class';
            TableRelation = "Payment Class";
        }
    }

    keys
    {
        key(Key1;"Journal Template Name","Journal Batch Name","CC Document Type")
        {
        }
    }

    fieldgroups
    {
    }
}

