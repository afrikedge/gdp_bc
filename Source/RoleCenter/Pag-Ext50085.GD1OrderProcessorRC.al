pageextension 50085 "GD1 Order Processor RC" extends "Order Processor Role Center"
{

    actions
    {
        addafter("Posted Documents")
        {
            group(GD1_SalesProcess)
            {
                Caption = 'Afk Sales Order process';
                Image = Sales;
                action(GD1Orders1)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cdes-Suivi';
                    RunObject = Page "Sales Order List";
                }
                action(GD1Orders2)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cdes-Prix non conformes';
                    RunObject = Page "Sales Order List - NC Prices";
                }
                action(GD1Orders3)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cdes- En saisie';
                    RunObject = Page "Sales Order List - Draft";
                }
                action(GD1Orders4)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cdes- validation tarifs';
                    RunObject = Page "Sales Order List - Prices val";
                }

                action(GD1Orders5)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cdes-Bloquées';
                    RunObject = Page "Sales Order List - Blocked";
                }
                action(GD1Orders6)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cdes- attente ordre de livraison';
                    RunObject = Page "Sales Order List - Pending SO";
                }
                action(GD1Orders7)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cdes-attente de livraison';
                    RunObject = Page "Sales Order List - To Ship";
                }
                action(GD1Orders8)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cdes-partiellement livrées';
                    RunObject = Page "Sales Order List - PartShipped";
                }
                action(GD1Orders9)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cdes-Livrées';
                    RunObject = Page "Sales Order List - Shipped";
                }
                action(GD1Orders10)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cdes- partiellement facturées';
                    RunObject = Page "Sales Order List - PartInvoice";
                }
                action(GD1Orders11)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cdes-entièrement facturées';
                    RunObject = Page "Sales Order List - Invoiced";
                }
                action(GD1Orders12)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cdes-Annulées';
                    RunObject = Page "Sales Order List - Cancelled";
                }
                action(GD1Orders13)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cdes-soldées';
                    RunObject = Page "Sales Order List - Closed";
                }
                action(GD1Orders14)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cdes-en rupture de stock';
                    RunObject = Page "Sales Order List - Rupture";
                }

            }
            group(GD1_Logistique)
            {
                Caption = 'Afk Logistique';
                Image = Sales;
                action(GD1Logistique15)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Liste des tournées';
                    RunObject = Page "Touring List";
                }
                action(GD1Logistique151)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Liste des tournées validées';
                    RunObject = Page "Posted Touring List";
                }
                action(GD1Logistique1)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Bons d''enlèvement';
                    RunObject = Page "Removal Order List";
                }
                action(GD1Logistique2)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Bons de livraisons';
                    RunObject = Page "Delivery Order List";
                }
                action(GD1Logistique3)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Bons (Dispaching)';
                    RunObject = Page "Bon Dispaching List";
                }
                action(GD1Logistique4)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Bons d''enlèvement confirmés';
                    RunObject = Page "Confirmed Removal Order List";
                }
                action(GD1Logistique5)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'bons de livraison confirmés';
                    RunObject = Page "Confirmed Delivery Order List";
                }
                action(GD1Logistique6)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Bons confirmés';
                    RunObject = Page "Confirmed Bon List";
                }
                action(GD1Logistique7)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'bons d''enlèvement annulés';
                    RunObject = Page "Cancelled Removal Order List";
                }
                action(GD1Logistique8)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'bons de livraison annulés';
                    RunObject = Page "Cancelled Delivery Order List";
                }
                action(GD1Logistique9)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Bons annulés';
                    RunObject = Page "Cancelled Bon List";
                }
                action(GD1Logistique10)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Compatibilité transport';
                    RunObject = Page "Transport Compatibility";
                }
                action(GD1Logistique11)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Compatibilité Dern. Livraison';
                    RunObject = Page "Last Delivery Compatibility";
                }
                action(GD1Logistique12)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Compatibilité d''axes';
                    RunObject = Page "Axe Compatibility";
                }
                action(GD1Logistique13)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Compatibilité points de livraison';
                    RunObject = Page "Delivery Site Compatibility";
                }
                action(GD1Logistique14)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Points de livraison par axe';
                    RunObject = Page "Delivery Site Per Axe";
                }

                action(GD1Logistique16)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cdes en attente de livraison';
                    RunObject = Page "Sales Order List - To Ship";
                }
                action(GD1Logistique17)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Liste des tournées confirmées';
                    RunObject = Page "Confirmed Touring List";
                }
                action(GD1Logistique18)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Type Données Dispaching';
                    RunObject = Page "Dispaching Event Types";
                }
                action(GD1Logistique19)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Statistiques Transporteurs';
                    RunObject = Page "Dispaching Events";
                }
                action(GD1Logistique20)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = '	Evènements  Dispaching';
                    RunObject = Page "Dispaching Event Entries";
                }
                action(GD1Logistique21)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Camions - edition';
                    RunObject = Page "Camions-EditList";
                }
            }
            group(GD1_Config)
            {
                Caption = 'Afk Config';
                Image = Setup;
                action(GD1Setup00)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Parametres société';
                    RunObject = Page "General Ledger Setup";
                }
                action(GD1Setup1)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Paramètres AddOn';
                    RunObject = Page "Params Setup";
                }

                action(GD1Setup2)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Paramètres AddOn2';
                    RunObject = Page "Params Setup2";
                }
                action(GD1Setup3)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Villes';
                    RunObject = Page "List of towns";
                }
                action(GD1Setup4)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Niveaux de risque';
                    RunObject = Page "Risk Levels";
                }
                action(GD1Setup5)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Catégories de vente';
                    RunObject = Page "Liste of sales categories";
                }
                action(GD1Setup6)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Canaux de vente';
                    RunObject = Page "Sales Channels";
                }
                action(GD1Setup7)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Centres de profit';
                    RunObject = Page "Profit Centers";
                }
                action(GD1Setup8)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Statuts juridiques';
                    RunObject = Page "Legal status";
                }
                action(GD1Setup9)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Secteurs d''activité';
                    RunObject = Page "Industry Groups";
                }
                action(GD1Setup10)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Vendeur/Acheteur';
                    RunObject = Page "Salespersons/Purchasers";
                }
                action(GD1Setup11)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Camions';
                    RunObject = Page "Camions";
                }
                action(GD1Setup12)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Type information Dossier d''achat';
                    RunObject = Page "Information Types";
                }
                action(GD1Setup13)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Taux de change (LPSA)';
                    RunObject = Page "LPSA Echange rates";
                }
                action(GD1Setup14)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Liste des cargaisons';
                    RunObject = Page "Cargo List";
                }
                action(GD1Setup15)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Méthodes d''allocation cargaison';
                    RunObject = Page "Cargo Allocation Config";
                }
                action(GD1Setup16)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Gr compta. four (Retenue à la source)';
                    RunObject = Page "Vendor Retention Post. Groups";
                }

                action(GD1Setup18)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Signataires';
                    RunObject = Page "Signatory List";
                }
                action(GD1Setup19)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Prix frais de passage/Stockage';
                    RunObject = Page "Item Fees Storage Pricing";
                }
                action(GD1Setup20)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Prix frais de transport massif';
                    RunObject = Page "Item Fees Transport Pricing";
                }
                action(GD1Setup21)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Prix frais de transport vers Ambatovy';
                    RunObject = Page "Fees Transpor AMBATOVY Pricing";
                }

                action(GD1Setup25)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Config doc de paiement';
                    RunObject = Page "Payment Config CCL";
                }
                action(GD1Setup26)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Transporteurs';
                    RunObject = Page "Transporteurs GDP";
                }
                action(GD1Setup27)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Articles - Admin';
                    RunObject = Page "Item List Admin";
                }
                action(GD1Setup28)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Articles à valider CDG';
                    RunObject = Page "Item List - CDG";
                }
                action(GD1Setup29)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Articles à valider - Compta';
                    RunObject = Page "Item List - Compta Four";
                }
                action(GD1Setup30)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Comptes bancaires Admin';
                    RunObject = Page "Bank Account List Admin";
                }
                action(GD1Setup31)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Plan compta Admin';
                    RunObject = Page "Chart of Accounts ADMIN";
                }

                action(GD1Setup32)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Clients - Admin';
                    RunObject = Page "Customer List Admin";
                }
                action(GD1Setup33)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Fournisseurs en attente de validation';
                    RunObject = Page "Vendor List - Workflow";
                }
                action(GD1Setup34)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sites de livraison (Logistique)';
                    RunObject = Page "Delivery Sites";
                }
                action(GD1Setup35)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Correspondances banque Swift';
                    RunObject = Page "Bank Acc. Swift Correspondence";
                }

                action(GD1Setup38)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Frais de transport sur logistique (Sites Dispaching)';
                    RunObject = Page "Sites Fees Transport";
                }
                action(GD1Setup39)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Prix de vente sites JIRAMA';
                    RunObject = Page "Jirama Sites Item Pricing";
                }
                action(GD1Setup40)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Clôture cdes vente/achat';
                    RunObject = report "Close Documents";
                }
                action(GD1Setup41)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Motifs incident Dispaching';
                    RunObject = Page "Dispaching Incident Types";
                }
            }

            group(GD1_Securite)
            {
                Caption = 'Afk Securite';
                Image = Sales;
                action(GD1Setup17)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Utilisateurs par feuille';
                    RunObject = Page "Journal users";
                }
                action(GD1Setup36)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Util. wkfl val factures fourn';
                    RunObject = Page "Vendor Inv Workflow User";
                }
                action(GD1Setup37)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Dépt/Dir Workflow Codes';
                    RunObject = Page "Purchase Workflow Codes";
                }
                action(GD1Setup22)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Magasiniers';
                    RunObject = Page "Warehouse Employees";
                }
                action(GD1Setup23)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Utilisateurs - comptes bancaires';
                    RunObject = Page "Bank Account Users";
                }
                action(GD1Setup24)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Utilisateurs par région';
                    RunObject = Page "Region Users";
                }
                action(GD1Sec25)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Utilisateurs';
                    RunObject = Page "Users";
                }
                action(GD1Sec26)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Parametres Utilisateurs';
                    RunObject = Page "User Setup";
                }
                action(GD1Sec27)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Gr. Utilisateurs';
                    RunObject = Page "User Groups";
                }
                action(GD1Sec28)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Roles';
                    RunObject = Page "Permission Set";
                }
                action(GD1Sec29)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Profiles';
                    RunObject = Page "Profile List";
                }
                action(GD1Sec30)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Roles par utilisateurs';
                    RunObject = Page "User Permission Sets";
                }
                action(GD1Sec31)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Personalisation util';
                    RunObject = Page "User Personalization";
                }
            }

            group(GD1_Jirama)
            {
                Caption = 'Afk Jirama';
                Image = Sales;
                action(GD1Jirama1)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Commandes JIRAMA';
                    RunObject = Page "JIRAMA Forecast List";
                }
                action(GD1Jirama2)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Commandes JIRAMA enregistrées';
                    RunObject = Page "Posted JIRAMA Forecast List";
                }
            }
            group(GD1_Stock)
            {
                Caption = 'Afk Stock';
                Image = Sales;
                action(GD1Stock1)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Transferts de produits';
                    RunObject = Page "Item Transfer List";
                }
                action(GD1Stock2)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Echanges de produits';
                    RunObject = Page "Item Exchange List";
                }

                action(GD1Stock3)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Prêts de produits';
                    RunObject = Page "Item Loan List";
                }
                action(GD1Stock4)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Consignations de produits';
                    RunObject = Page "Item Consignation List";
                }
                action(GD1Stock5)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Echanges de produits enregistrés';
                    RunObject = Page "Posted Item Exchange List";
                }
                action(GD1Stock6)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Prêts de produits enregistrés';
                    RunObject = Page "Posted Item Loan List";
                }
                action(GD1Stock7)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Consignations de produits enregistrées';
                    RunObject = Page "Posted Item Consignation List";
                }
                action(GD1Stock8)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Emprunts de produits enregistrés';
                    RunObject = Page "Posted Item Borrow List";
                }
                action(GD1Stock9)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Emprunts de produits';
                    RunObject = Page "Item Borrow List";
                }
                action(GD1Stock10)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Transferts de produits enreg.';
                    RunObject = Page "Posted Item Transfer List";
                }
                action(GD1Stock11)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Articles à valider';
                    RunObject = Page "Item List - CDG";
                }
            }
            group(GD1_LivraisonLubs)
            {
                Caption = 'Afk Livr Lubs';
                Image = Sales;
                action(GD1LivraisonLubs1)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Documents de préparation (Livraisons)';
                    RunObject = Page "Item Shipment List";
                }

                action(GD1LivraisonLubs2)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Documents de préparation initiés';
                    RunObject = Page "Prepared Item Shipment List";
                }
                action(GD1LivraisonLubs3)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Documents de préparation enregistrés';
                    RunObject = Page "Posted Item Shipment List";
                }
                action(GD1LivraisonLubs4)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Ordres de livraison expédiés';
                    RunObject = Page "Shipped Item Shipment List";
                }

            }
            group(GD1_Achats)
            {
                Caption = 'Afk Achats';
                Image = Sales;
                action(GD1Achats1)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Demandes d''achat';
                    RunObject = Page "Purchase Requisition List";
                }
                action(GD1Achats12)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Suivi Demandes d''achat';
                    RunObject = Page "Purchase Req Tracking List";
                }
                action(GD1Achats2)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Demandes de prix';
                    RunObject = Page "Purchase Quotes";
                }
                action(GD1Achats3)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Commandes achat';
                    RunObject = Page "Purchase Order List";
                }
                action(GD1Achats4)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cdes achat non reçues';
                    RunObject = Page "NonReceived Purch Order List";
                }
                action(GD1Achats5)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cdes achat reçues partiellement';
                    RunObject = Page "Partially Received Purch Order";
                }
                action(GD1Achats6)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cdes achat reçues totalement';
                    RunObject = Page "Received Purchase Order List";
                }
                action(GD1Achats7)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Ddes d''achat à valider (CDG)';
                    RunObject = Page "Purchase Req Pending App List ";
                }
                action(GD1Achats8)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Ddes d''achat à valider (Resp.)';
                    RunObject = Page "Purchase Req Pending Manager";
                }
                action(GD1Achats9)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Ddes d''achat validées';
                    RunObject = Page "Purchase Req Validated List";
                }
                action(GD1Achats10)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Ddes d''achat partiellement traitées';
                    RunObject = Page "Purchase Req Partially pr List";
                }
                action(GD1Achats11)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Ddes d''achat totalement traitées';
                    RunObject = Page "Purchase Req Totally pro List";
                }

                action(GD1Achats13)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Ddes d''achat enregistrées';
                    RunObject = Page "Posted Purch Requisition List";
                }
                action(GD1Achats14)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Archives cdes achat soldées';
                    RunObject = Page "Purchase Order Cancelled";
                }
                action(GD1Achats15)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Archives cdes achat facturées';
                    RunObject = Page "Purchase Order Invoiced";
                }

            }
            group(GD1_Appro)
            {
                Caption = 'Afk Approv';
                Image = Sales;
                action(GD1Appro1)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cdes achat - Approvisionnement';
                    RunObject = Page "PBL Purchase Order List";
                }
                action(GD1Appro2)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Archives liste des achats PBL';
                    RunObject = Page "Purchase List Archive PBL";
                }
            }
            group(GD1_Compta)
            {
                Caption = 'Afk Compta';
                Image = Sales;
                action(GD1Compta1)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Chèques commande encours';
                    RunObject = Page "Open Check Warranty";
                }
                action(GD1Compta2)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Chèques commande encours retournés';
                    RunObject = Page "Returned Check Warranty";
                }

                action(GD1Compta3)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Suivi factures des transporteurs';
                    RunObject = Page "Confirmed Shipment to invoice";
                }
                action(GD1Compta4)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Suivi des factures (Frais de passage)';
                    RunObject = Page "Invoice To Receive BE";
                }
                action(GD1Compta5)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Suivi des factures (Transport massif)';
                    RunObject = Page "Invoice to receive (Transport)";
                }
                action(GD1Compta6)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Lettres de crédit (Encours)';
                    RunObject = Page "Open Letters of credit";
                }
                action(GD1Compta7)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Import Payroll Data';
                    RunObject = xmlport "Import Payroll Data";
                }
                action(GD1Compta8)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Feuille règlement CCL';
                    RunObject = Page "Cash Receipt Journal CCL";
                }
                action(GD1Compta9)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Feuille Virement pour trésorerie';
                    RunObject = Page "Cash Transfer Journal TRESO";
                }
                action(GD1Compta10)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Configuration document de paiement';
                    RunObject = Page "Payment Config CCL";
                }
                action(GD1Compta11)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Chèques en caution confirmés';
                    RunObject = Page "Confirmed Check Warranty";
                }
                action(GD1Compta12)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sorties pour immobilisation';
                    RunObject = Page "FA Conso List";
                }
                action(GD1Compta13)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sorties pour immobilisation enreg.';
                    RunObject = Page "Posted FA Conso List";
                }
                action(GD1Compta14)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Noms feuilles comptabilité TRESO';
                    RunObject = Page "General Journal Batches TRESO";
                }
                action(GD1Compta15)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Documents de règlements client';
                    RunObject = Page "Customer Receipts Docs";
                }
            }
            group(GD1_Tenues)
            {
                Caption = 'Afk Tenues';
                Image = Sales;
                action(GD1Tenues1)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sorties à refacturer';
                    RunObject = Page "Item Invoiced Conso List";
                }
                action(GD1Tenues2)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sorties à refacturer (En attente facturation)';
                    RunObject = Page "Item Invoiced Conso List Relea";
                }
                action(GD1Tenues3)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sorties à refacturer enregistrées';
                    RunObject = Page "Posted Item Inv. Conso List";
                }
            }
            group(GD1_FacturesFsseur)
            {
                Caption = 'Afk Factures Fsseur';
                Image = Sales;
                action(GD1FactureF1)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Factures four en saisie';
                    RunObject = Page "Vendor Invoice List Saisie";
                }
                action(GD1FactureF2)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Documents facture fournisseur';
                    RunObject = Page "Vendor Invoice List Compta";
                }
                action(GD1FactureF3)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Factures four en validation';
                    RunObject = Page "Vendor Invoice List Validation";
                }
                action(GD1FactureF4)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Factures four en attente BAP';
                    RunObject = Page "Vendor Invoice List DFI";
                }
                action(GD1FactureF5)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Factures four en attente paiement';
                    RunObject = Page "Vendor Invoice List Treso";
                }
                action(GD1FactureF6)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Suivi des factures fournisseur';
                    RunObject = Page "Vendor Invoice List Historique";
                }

            }
            group(AfkFrontDesk)
            {
                Caption = 'Afk Front Desk';
                Image = Sales;
                action(AfkExternalUsers)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Utilisateurs externes';
                    RunObject = Page "Afk External Users";
                }
                action(AfkUnblockingList)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Demandes de déblocage';
                    RunObject = Page "Afk SO Unblocking List";
                }
            }
        }

    }
}