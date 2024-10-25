report 50043 "Comparaison Offres"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Comparaison Offres.rdlc';

    dataset
    {
        dataitem("Purchase Requisition";"Purchase Requisition")
        {
            RequestFilterFields = "No.";
            column(No_PurchRequis;"No.")
            {
            }
            column(PurchType_PurchRequis;"Purchase Type")
            {
            }
            column(Descript_PurchRequis;Description)
            {
            }
            column(CompanyInfo_Picture;CompanyInfo.Picture)
            {
            }
            column(No_PurchaseCaption;No_PurchaseCaption)
            {
            }
            column(DeptCaption;DeptCaption)
            {
            }
            column(PurchTypeCaption;PurchTypeCaption)
            {
            }
            column(OrderTypeCaption;OrderTypeCaption)
            {
            }
            column(DescriptCaption;DescriptCaption)
            {
            }
            column(VendorCaption;VendorCaption)
            {
            }
            column(QuoteCaption;QuoteCaption)
            {
            }
            column(ItemNameCaption;ItemNameCaption)
            {
            }
            column(QuantityCaption;QuantityCaption)
            {
            }
            column(UOMCaption;UOMCaption)
            {
            }
            column(UnitPriceCaption;UnitPriceCaption)
            {
            }
            column(TotalPriceCaption;TotalPriceCaption)
            {
            }
            column(TotalText;TotalText)
            {
            }
            column(TotalText2;TotalText2)
            {
            }
            column(RemittranceText;RemittranceText)
            {
            }
            column(OrderType;"Purchase Requisition"."Order Type")
            {
            }
            dataitem("Purchase Header";"Purchase Header")
            {
                column(No_PurchHeader;"Purchase Header"."Vendor Order No.")
                {
                }
                column(VendorName;"Buy-from Vendor Name")
                {
                }
                column(OfferValidity;"Validity Offer")
                {
                }
                column(Disponibility;"PR Type")
                {
                }
                column(PaymentTerm;PaymName)
                {
                }
                column(VendorNo;"Buy-from Vendor No.")
                {
                }
                column(TypeCommande;Format("PO Type"))
                {
                }
                column(NomDepartement;NomDepartement)
                {
                }
                dataitem("Purchase Line";"Purchase Line")
                {
                    DataItemLink = "Document No."=FIELD("No.");
                    column(DocumentNo_PurchLine;"Document No.")
                    {
                    }
                    column(LineNo_PurchLine;"Line No.")
                    {
                    }
                    column(No_PurchLine;"No.")
                    {
                    }
                    column(Descript_PurchLine;Description)
                    {
                    }
                    column(Quantity_PurchLine;Quantity)
                    {
                    }
                    column(UOM_PurchLine;"Unit of Measure")
                    {
                    }
                    column(Amount_PurchLine;Amount)
                    {
                    }
                    column(DirectCost_PurchLine;"Direct Unit Cost")
                    {
                    }
                    column(LineAmount_PurchLine;"Line Amount")
                    {
                    }
                    column(Disponibility_PurchLine;"Purchase Line"."Disponibility 2")
                    {
                    }
                    column(Garanti_PurchLine;"Starting Warranty")
                    {
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    PaymName:='';
                    if "Payment Terms Code" <>'' then begin
                      PaymTerm.Get("Payment Terms Code");
                      PaymName:=PaymTerm.Description;
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    "Purchase Header".SetRange("Code Demande","Purchase Requisition"."No.");
                    "Purchase Header".SetRange("Document Type","Document Type"::Quote);
                    if "Purchase Header".FindFirst then;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                NomDepartement:='';
                  if Dept.Get("Purchase Requisition"."Department Code") then
                    NomDepartement := Dept.Name;
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
        Condition = 'Conditions : (Variable selon l''achat à effectuer)';
        ValOffre = 'Validité Offre';
        Dispo = 'Disponibilité';
        PaiementMode = 'Mode de Paiement';
        Garantie = 'Garantie';
        Remark = 'Remarque';
        ValidationChoice = 'Choix de la validation';
        Comm = 'Commentaire';
        Compare = 'COMPARAISON OFFRE';
        Society = 'GALANA DISTRIBUTION PETROLIERE';
        Approuve = 'APPROBATION';
        PurchDept = 'Département ACHAT';
        AutoriseBy = 'Autorisé(s) par';
        Date = 'Date';
    }

    trigger OnInitReport()
    begin
        CompanyInfo.Get;
        CompanyInfo.CalcFields(Picture);
    end;

    var
        CompanyInfo: Record "Company Information";
        No_PurchaseCaption: Label 'N° DDA';
        DeptCaption: Label 'DPT';
        PurchTypeCaption: Label 'Type d''achat';
        OrderTypeCaption: Label 'Type de commande';
        DescriptCaption: Label 'Description';
        VendorCaption: Label 'Fournisseurs';
        QuoteCaption: Label 'N° Proforma';
        ItemNameCaption: Label 'Intitulé';
        QuantityCaption: Label 'Qté';
        UOMCaption: Label 'UdM';
        UnitPriceCaption: Label 'PU';
        TotalPriceCaption: Label 'PT';
        TotalText: Label 'Tarif Total HT(Ar)';
        TotalText2: Label 'Total HT(Ar)';
        RemittranceText: Label 'Remise';
        PaymTerm: Record "Payment Terms";
        PaymName: Text;
        NomDepartement: Text[50];
        PurchReq: Record "Purchase Requisition";
        Dept: Record Subdirection;
}

