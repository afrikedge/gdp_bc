report 50046 "Facture AMSA Posted"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Source/Report/Layout/Facture AMSA Posted.rdlc';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Posted Fuel Statement"; "Posted Fuel Statement")
        {
            column(No_FuelStat; "No.")
            {
            }
            column(CustNo_FuelStat; "Customer No")
            {
            }
            column(CustName_FuelStat; Cust."Search Name")
            {
            }
            column(CustAddr1; Cust.Address)
            {
            }
            column(CustAddr2; Cust."Address 2")
            {
            }
            column(ConditionText; PaymentTerm.Description)
            {
            }
            column(CustStatCode; 'Id Stat : ' + Cust."STAT Code")
            {
            }
            column(CustCIFCode; 'CIF ' + Cust."CIF/CIS")
            {
            }
            column(CustNIFCode; 'NIF : ' + Cust."VAT Registration No.")
            {
            }
            column(CustRCSCode; 'RCS : ' + Cust."Trade Number")
            {
            }
            column(CustEmail; 'Email : ' + Cust."E-Mail")
            {
            }
            column(RegionClient; Cust.County)
            {
            }
            column(NumFact; "External Document No.")
            {
            }
            column(NumFactText; NumFactText)
            {
            }
            column(NumCmd; "Order No.")
            {
            }
            column(NumContrat; FuelStat."External Document No.")
            {
            }
            column(AdresseLivraisonText; ShipToAddress.Name)
            {
            }
            column(PrintDate; Format(Today))
            {
            }
            dataitem("Posted AMSA Invoice Line"; "Posted AMSA Invoice Line")
            {
                DataItemLink = "Document No." = FIELD("No."), "Document Type" = FIELD("Document Type");
                DataItemTableView = SORTING("Document Type", "Document No.", "Line No.");
                column(LineNo; "Line No.")
                {
                }
                column(PostingDate; Format("Posting Date"))
                {
                }
                column(Product; "Item Name")
                {
                }
                column(Quantity; "Invoice Qty")
                {
                }
                column(OrderRef; "Order Ref")
                {
                }
                column(InvoiceRef; "Invoice Ref")
                {
                }
                column(UnitPrice; "Unit Price")
                {
                }
                column(AmountHT; Amount)
                {
                }
                column(VATAmount; "VAT Amount")
                {
                }
                column(AmountTTC; "Amount Incl. VAT")
                {
                }
                column(QuantityText; QuantityText)
                {
                }
                column(TotalText; TotalText)
                {
                }
                column(TotalAmountLetter; TotalAmountLetter[1])
                {
                }

                trigger OnPreDataItem()
                begin
                    CurrReport.CreateTotals("Amount Incl. VAT");
                end;
            }

            trigger OnAfterGetRecord()
            begin
                Cust.Get("Posted Fuel Statement"."Customer No");
                PaymentTerm.Get(Cust."Payment Terms Code");

                PayConditionsTxt := PaymentTerm.Description + ' par ';

                if Cust."Cash payment" or Cust."Credit Note" then
                    PayConditionsTxt := PayConditionsTxt + 'Espèces,';

                if Cust."Check Set" or Cust."Received Check" then
                    PayConditionsTxt := PayConditionsTxt + ' Chèque,';

                if Cust."Bank Transfer Bank Stamp" then
                    PayConditionsTxt := PayConditionsTxt + ' Virement,';

                if Cust.Traite then
                    PayConditionsTxt := PayConditionsTxt + ' Traite,';

                AmsaInvoice.SetRange("Document No.", "Posted Fuel Statement"."No.");
                AmsaInvoice.SetRange("Document Type", "Posted Fuel Statement"."Document Type");
                if AmsaInvoice.FindFirst then begin
                    repeat
                        //AmsaInvoice.CALCSUMS("Amount Incl. VAT");
                        TotalAmount := AmsaInvoice."Amount Incl. VAT" + TotalAmount;
                    until AmsaInvoice.Next = 0;
                end;

                FuelStat.SetRange("Document Type", "Document Type"::"Main invoice");
                FuelStat.SetRange("No.", "Posted Fuel Statement"."Parent Invoice No.");
                if FuelStat.FindFirst then
                    Location.Get(FuelStat."Location Code");

                NbTLet.InitTextVariable;
                //TODO Montants
                //NbTLet.FormatNoTextFR(TotalAmountLetter,TotalAmount,'');

                if ShipToAddress.Get(Cust."No.", Cust."Ship-to Code2") then;
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
        Date = 'DATE';
        Reffuel = 'REF FUEL LOG';
        Prdt = 'Produit';
        Lit = 'Litrage';
        Com = 'Com/de';
        RefFact = 'Réf. Facture';
        PU = 'PUHTVA(AR/L)';
        MontHT = 'Montant HT (Ariary)';
        MontTVA = 'Montant TVA (Ariary)';
        MontTTC = 'Montant TTC (Ariary)';
        Letter = 'Facture arrêtée à la somme de';
        PrGal = 'Pour GALANA';
        Prepareby = 'Préparée par';
        Autoriseby = 'Autorisée par';
        Dat = 'date';
        Cont = 'CONTRAT';
        CondPaie = 'Condition de paiement';
        LieuLiv = 'Lieu de livraison /';
        Clt = 'CLIENT';
    }

    trigger OnPreReport()
    begin
        TotalAmount := 0;
    end;

    var
        Cust: Record Customer;
        NbTLet: Report Check;
        TotalAmountLetter: array[2] of Text[150];
        QuantityText: Label 'QUANTITE TOTALE';
        TotalText: Label 'TOTAL A PAYER';
        AmsaInvoice: Record "Posted AMSA Invoice Line";
        TotalAmount: Decimal;
        AdresseLivraisonText: Label 'SS AMBATOVY';
        PaymentTerm: Record "Payment Terms";
        NumFactText: Label 'Facture N° : ';
        Location: Record Location;
        FuelStat: Record "Posted Fuel Statement";
        ShipToAddress: Record "Ship-to Address";
        PayConditionsTxt: Text[150];
}

