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
                    Caption = 'Commandes- En saisie';
                    RunObject = Page "Sales Order List - Draft";
                }
                action(GD1Orders4)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Commandes- validation tarifs';
                    RunObject = Page "Sales Order List - Prices val";
                }

                action(GD1Orders5)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Commandes-Bloquées';
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
                    Caption = 'Liste des tournées traitées';
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
        }
    }
}