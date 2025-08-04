page 50351 "Params Setup2"
{
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "AddOn Setup2";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(PGPExeFileTempPath; Rec.PGPExeFileTempPath)
                {
                }
                field(ActivateDispachingLogging; Rec.ActivateDispachingLogging)
                {
                }
                field("Vendor Inv Doc Series"; Rec."Vendor Inv Doc Series")
                {
                }
                field("User DAF"; Rec."User DAF")
                {
                }
                field("Interim User DAF"; Rec."Interim User DAF")
                {
                }
                field("Activate Interim DAF"; Rec."Activate Interim DAF")
                {
                }
                field("Email Vend Invoice Refusal"; Rec."Email Vend Invoice Refusal")
                {
                }
                field("Desactiver Controle Camion"; Rec."Desactiver Controle Camion")
                {
                }
                field("Email Avis Paiement"; Rec."Email Avis Paiement")
                {
                }
                field("Fee Redevance VAT%"; Rec."Fee Redevance VAT%")
                {
                }
                field("Activate Jirama Site UP"; Rec."Activate Jirama Site UP")
                {
                }
                field("Email CC Relance"; Rec."Email CC Relance")
                {
                }
                field("Def Prepmt. Payment Terms Code"; Rec."Def Prepmt. Payment Terms Code")
                {
                }
                field("Galitt NC Gerant Prepaid"; Rec."Galitt NC Gerant Prepaid")
                {
                }
                field("Galitt ND Gerant Prepaid"; Rec."Galitt ND Gerant Prepaid")
                {
                }
                field("Galitt NC Gerant Postpaid"; Rec."Galitt NC Gerant Postpaid")
                {
                }
                field("Galitt ND Gerant Postpaid"; Rec."Galitt ND Gerant Postpaid")
                {
                }
                field("Galitt NC Gerant GPRO"; Rec."Galitt NC Gerant GPRO")
                {
                }
                field("Galitt ND Gerant GPRO"; Rec."Galitt ND Gerant GPRO")
                {
                }
                field("Desactivate Provisions Ctrl"; Rec."Desactivate Provisions Ctrl")
                {
                }
                field("Galitt Facture Mensue Postpaid"; Rec."Galitt Facture Mensue Postpaid")
                {
                }
                field("Supplier blocking period Month"; Rec."Supplier blocking period Month")
                {
                }
                field("Block zero unit cost"; Rec."Block zero unit cost")
                {
                }
                field("Galitt Fact Men Postpaid GPRO"; Rec."Galitt Fact Men Postpaid GPRO")
                {
                }
                field("Cust Revision Nos Series"; Rec."Cust Revision Nos Series")
                {
                }
                field("Lead Nos Series"; Rec."Lead Nos Series")
                {
                }
                field("Operation Cust Templ"; Rec."Operation Cust Templ")
                {
                }
                field("Holding Cust Templ"; Rec."Holding Cust Templ")
                {
                }
                field("Company Cust Templ"; Rec."Company Cust Templ")
                {
                }
                field("Activate Email Service"; Rec."Activate Email Service")
                {
                }
                field("Email for Customers Creation"; Rec."Email for Customers Creation")
                {
                }
                field("Desactivate Loc Type Control"; Rec."Desactivate Loc Type Control")
                {
                }
                field("Desactivate Calc Interest"; Rec."Desactivate Calc Interest")
                {
                }
                field("Email Card Posting Error"; Rec."Email Card Posting Error")
                {
                }
                field("Customer blocking period Month"; Rec."Customer blocking period Month")
                {
                }
                field("Email Copie New Sales Order"; Rec."Email Copie New Sales Order")
                {
                }
                field("BC Main Url"; Rec."BC Main Url")
                {
                }
                field("Card print Item"; Rec."Card print Item")
                {
                }
                field("Card print Item Descr"; Rec."Card print Item Descr")
                {
                }
                field("Orange Money WP Acc"; Rec."Orange Money WP Acc")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Solder Commandes Achat (Avec contrôle)")
            {
                Caption = 'Solder Commandes Achat (Avec contrôle)';
                Image = "Action";
                RunObject = XMLport "Archive SO With Control";
            }
            action("Solder Commandes Achat (Sans contrôle)")
            {
                Caption = 'Solder Commandes Achat (Sans contrôle)';
                Image = DeleteAllBreakpoints;
                RunObject = XMLport "Archive Cdes Achat Force";
            }
        }
    }

    var
        testAnnulation: Codeunit "SQL Mgt";
}

