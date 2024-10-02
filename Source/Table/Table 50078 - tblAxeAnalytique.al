table 50078 tblAxeAnalytique
{
    Caption = 'Ligne facture MFiles';

    fields
    {
        field(1;ID;BigInteger)
        {
        }
        field(2;DateMFiles;DateTime)
        {
            Caption = 'MFiles Date';
        }
        field(3;IDFacture;BigInteger)
        {
        }
        field(4;CodeBudget;Code[20])
        {
            Caption = 'Budget Code';
        }
        field(5;CodeCentreCout;Code[20])
        {
            Caption = 'Cost center code';
        }
        field(6;CodeCentreProfit;Code[20])
        {
            Caption = 'Profit center code';
        }
        field(7;CodeProjet;Code[20])
        {
            Caption = 'Project Code';
        }
        field(8;CodeRegion;Code[20])
        {
            Caption = 'Region Code';
        }
        field(9;MontantHTVA;Decimal)
        {
            Caption = 'Amount Excl VAT';
        }
        field(10;TypeLigne;Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,G/L Account,Item,Fixed Asset,Charge (Item)';
            OptionMembers = " ","G/L Account",Item,"Fixed Asset","Charge (Item)";
        }
        field(11;CodeLigne;Code[20])
        {
            Caption = 'Item Code';
            TableRelation = IF (TypeLigne=CONST(Item)) Item
                            ELSE IF (TypeLigne=CONST("Fixed Asset")) "Fixed Asset"
                            ELSE IF (TypeLigne=CONST("G/L Account")) "G/L Account" WHERE ("Direct Posting"=CONST(true),
                                                                                          "Account Type"=CONST(Posting),
                                                                                          Blocked=CONST(false),
                                                                                          "Purchased Account"=CONST(true))
                                                                                          ELSE IF (TypeLigne=CONST("Charge (Item)")) "Item Charge";
        }
        field(12;CodeCentreProfit2;Code[20])
        {
            Caption = 'Cost center code 2';
        }
        field(13;CodeProduit;Code[20])
        {
            Caption = 'Product code';
        }
    }

    keys
    {
        key(Key1;ID,DateMFiles)
        {
        }
    }

    fieldgroups
    {
    }
}

