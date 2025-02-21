page 50000 "AddOn Setup Card"
{
    Caption = 'Addon Configuration';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "AddOn Setup";
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(Options)
            {
                Caption = 'Options';
                field("Security on Journal"; Rec."Security on Journal")
                {
                }
                field("Desactivate Whse Sec"; Rec."Desactivate Whse Sec")
                {
                }
                field("Activer libelles Compta Client"; Rec."Activer libelles Compta Client")
                {
                }
                field("Activer libelles compta Fsseur"; Rec."Activer libelles compta Fsseur")
                {
                }
                field("Activer libelles Immos"; Rec."Activer libelles Immos")
                {
                }
                field("Activer libelles Stock"; Rec."Activer libelles Stock")
                {
                }
                field("Activate bank Acc Sec"; Rec."Activate bank Acc Sec")
                {
                }
                field("Item on Invoice"; Rec."Item on Invoice")
                {
                    Visible = false;
                }
                field("Activer ajustement Naphta"; Rec."Activer ajustement Naphta")
                {
                }
                field("Preserve Purch Approval Entry"; Rec."Preserve Purch Approval Entry")
                {
                }
                field("Jir Shipment Adj Mgt"; Rec."Jir Shipment Adj Mgt")
                {
                }
                field("GL Security On Group Users"; Rec."GL Security On Group Users")
                {
                }
                field("Pwd Expiration (Days)"; Rec."Pwd Expiration (Days)")
                {
                }
            }
            group("Comptabilité")
            {
                Caption = 'Comptabilité';
                field("NoVAT Prod. Posting Group"; Rec."NoVAT Prod. Posting Group")
                {
                }
                field("Invoice To Receive Account"; Rec."Invoice To Receive Account")
                {
                }
                field("Gen. Bus. Posting Group Def"; Rec."Gen. Bus. Posting Group Def")
                {
                }
                field("Payroll Tmpl Journal"; Rec."Payroll Tmpl Journal")
                {
                }
                field("ND Cheque Caution Account PBL"; Rec."ND Cheque Caution Account PBL")
                {
                }
                field("Compte Fonds de garantie"; Rec."Compte Fonds de garantie")
                {
                }
                field("Primes Station Acc"; Rec."Primes Station Acc")
                {
                }
                field("VAT Group Primes Gerant"; Rec."VAT Group Primes Gerant")
                {
                }
                field("Sales Exchange Fees Acc"; Rec."Sales Exchange Fees Acc")
                {
                }
                field("Purchase Exchange Fees Acc"; Rec."Purchase Exchange Fees Acc")
                {
                }
                field("LPSA Fees Storage Account"; Rec."LPSA Fees Storage Account")
                {
                }
            }
            group(Budget)
            {
                Caption = 'Budget';
                field("Code Budget Def"; Rec."Code Budget Def")
                {
                }
                field("Budget Period"; Rec."Budget Period")
                {
                }
            }
            group("Retenues Redevances")
            {
                Caption = 'Retenues Redevances';
                field("OMH Fees Account"; Rec."OMH Fees Account")
                {
                }
                field("FER Fees Account"; Rec."FER Fees Account")
                {
                }
                field("ENV Fees Account"; Rec."ENV Fees Account")
                {
                }
                field("Cancel Fees Retention Posting"; Rec."Cancel Fees Retention Posting")
                {
                }
                field("OMH Fees Account - NAPHTA"; Rec."OMH Fees Account - NAPHTA")
                {
                }
                field("FER Fees Account - NAPHTA"; Rec."FER Fees Account - NAPHTA")
                {
                }
                field("ENV Fees Account - NAPHTA"; Rec."ENV Fees Account - NAPHTA")
                {
                }
                field("Activate RDS Fees Retention"; Rec."Activate RDS Fees Retention")
                {
                }
                field("RDS Fees Account"; Rec."RDS Fees Account")
                {
                }
            }
            group("Stock Marchandises")
            {
                Caption = 'Stock Marchandises';
                field("Shipment Location PBL"; Rec."Shipment Location PBL")
                {
                }
                field("Removal Journal code"; Rec."Removal Journal code")
                {
                }
                field("Transit Location Transfer"; Rec."Transit Location Transfer")
                {
                }
                field("PBL Category Code"; Rec."PBL Category Code")
                {
                }
                field("PBL Sales Category"; Rec."PBL Sales Category")
                {
                }
                field("Station Sales Channel"; Rec."Station Sales Channel")
                {
                }
                field("Bornage Sales Channel"; Rec."Bornage Sales Channel")
                {
                }
                field("BE Adjustement Margin %"; Rec."BE Adjustement Margin %")
                {
                }
                field("BL Adjustement Margin %"; Rec."BL Adjustement Margin %")
                {
                }
                field("Soute Sales Channel"; Rec."Soute Sales Channel")
                {
                }
                field("Naphta Product Group"; Rec."Naphta Product Group")
                {
                }
                field("Naphta Fictif Location"; Rec."Naphta Fictif Location")
                {
                }
                field("LUB Shipment Location"; Rec."LUB Shipment Location")
                {
                }
                field("LUBS Sales Category"; Rec."LUBS Sales Category")
                {
                }
                field("LUBS Item Category"; Rec."LUBS Item Category")
                {
                }
                field("Consignation Location"; Rec."Consignation Location")
                {
                }
                field("Partner Location"; Rec."Partner Location")
                {
                }
                field("LPSA Vendor Code"; Rec."LPSA Vendor Code")
                {
                }
                field("GRT Vendor Code"; Rec."GRT Vendor Code")
                {
                }
                field("GRT Location Code"; Rec."GRT Location Code")
                {
                }
                field("LPSA Transit Transfer Location"; Rec."LPSA Transit Transfer Location")
                {
                }
                field("LPSA Adjustment Reason Code"; Rec."LPSA Adjustment Reason Code")
                {
                }
                field("Shipment Method Direct"; Rec."Shipment Method Direct")
                {
                }
                field("Cargo Enlevement"; Rec."Cargo Enlevement")
                {
                }
                field("GPL Sales Channel"; Rec."GPL Sales Channel")
                {
                }
                field("GPL Item Category"; Rec."GPL Item Category")
                {
                }
                field("Shipment Location GPL"; Rec."Shipment Location GPL")
                {
                }
                field("Transport Item Category"; Rec."Transport Item Category")
                {
                }
                field("GPL Sales Category"; Rec."GPL Sales Category")
                {
                }
                field(Control1000000161; '')
                {
                    ShowCaption = false;
                }
                field("Ambohimanambola Fees Location"; Rec."Ambohimanambola Fees Location")
                {
                }
            }
            group(JIRAMA)
            {
                Caption = 'JIRAMA';
                field("Jirama Customer No"; Rec."Jirama Customer No")
                {
                }
                field("Jirama Partner Code"; Rec."Jirama Partner Code")
                {
                }
                field("Jirama Affectation %"; Rec."Jirama Affectation %")
                {
                }
                field("JIRAMA Item No."; Rec."JIRAMA Item No.")
                {
                }
                field("JIRAMA Sales Channel"; Rec."JIRAMA Sales Channel")
                {
                }
                field("AMSA Sales Channel"; Rec."AMSA Sales Channel")
                {
                }
                field("Skip AMSA/JIRAMA Docs Control"; Rec."Skip AMSA/JIRAMA Docs Control")
                {
                }
                field("JIRAMA Forecast Transfer Nos."; Rec."JIRAMA Forecast Transfer Nos.")
                {
                }
                field("Shipment Method JIRAMA"; Rec."Shipment Method JIRAMA")
                {
                }
                field("JOVENNA Vendor Code"; Rec."JOVENNA Vendor Code")
                {
                }
                field("Inv To Receive Acc JOVENNA"; Rec."Inv To Receive Acc JOVENNA")
                {
                }
                field("JOVENNA Sales Channel"; Rec."JOVENNA Sales Channel")
                {
                }
                field("Jir Shipment Adj Reason Code"; Rec."Jir Shipment Adj Reason Code")
                {
                }
                field("Jirama Sales Forecast Nos."; Rec."Jirama Sales Forecast Nos.")
                {
                }
                field("Jirama Affectation Cargo %"; Rec."Jirama Affectation Cargo %")
                {
                }
            }
            group("Numéros")
            {
                Caption = 'Numéros';
                field("Fuel Statement Nos."; Rec."Fuel Statement Nos.")
                {
                }
                field("Item Loan Nos."; Rec."Item Loan Nos.")
                {
                }
                field("Item Borrow Nos."; Rec."Item Borrow Nos.")
                {
                }
                field("Item Exchange Nos."; Rec."Item Exchange Nos.")
                {
                }
                field("Item Consignation Nos."; Rec."Item Consignation Nos.")
                {
                }
                field("Item Return Consignation Nos."; Rec."Item Return Consignation Nos.")
                {
                }
                field("Item Return Loan Nos."; Rec."Item Return Loan Nos.")
                {
                }
                field("Item Return Borrow Nos."; Rec."Item Return Borrow Nos.")
                {
                }
                field("AMSA Main Invoices Nos."; Rec."AMSA Main Invoices Nos.")
                {
                }
                field("AMSA Invoices Nos."; Rec."AMSA Invoices Nos.")
                {
                }
                field("Transfer Receipt Nos."; Rec."Transfer Receipt Nos.")
                {
                }
                field("Transfer Order Nos."; Rec."Transfer Order Nos.")
                {
                }
                field("Hypo Transfer Receipt Nos."; Rec."Hypo Transfer Receipt Nos.")
                {
                }
                field("Purchase Request Nos"; Rec."Purchase Request Nos")
                {
                }
                field("Invoiced Consumption Nos."; Rec."Invoiced Consumption Nos.")
                {
                }
                field("Item Shipment Nos."; Rec."Item Shipment Nos.")
                {
                }
                field("Facture Prov FA Nos."; Rec."Facture Prov FA Nos.")
                {
                }
                field("Extourne Facture Prov Nos."; Rec."Extourne Facture Prov Nos.")
                {
                }
            }
            group(Banque)
            {
                Caption = 'Banque';
                field("Credit Bank Account"; Rec."Credit Bank Account")
                {
                }
                field("Desactivate Check Nos Control"; Rec."Desactivate Check Nos Control")
                {
                }
                field("CCL Mobile Money Acc 1"; Rec."CCL Mobile Money Acc 1")
                {
                }
                field("Curr Purchase Tmpl Journal"; Rec."Curr Purchase Tmpl Journal")
                {
                }
                field("Compte Effet A Recevoir"; Rec."Compte Effet A Recevoir")
                {
                }
                field("CCL Mobile Money Acc 2"; Rec."CCL Mobile Money Acc 2")
                {
                }
                field("CCL Mobile Money Acc 3"; Rec."CCL Mobile Money Acc 3")
                {
                }
                field("CCL Mobile Money Acc 4"; Rec."CCL Mobile Money Acc 4")
                {
                }
                field("CCL Mobile Money Acc 5"; Rec."CCL Mobile Money Acc 5")
                {
                }
                field("Progal Payment Tmpl Journal"; Rec."Progal Payment Tmpl Journal")
                {
                }
                field("LC Payment Method"; Rec."LC Payment Method")
                {
                }
                field("Check Warranty Nos."; Rec."Check Warranty Nos.")
                {
                }
                field("Letter of credit Nos."; Rec."Letter of credit Nos.")
                {
                }
            }
            group(Immos)
            {
                Caption = 'Immos';
                field("Fiscal Depreciation Book"; Rec."Fiscal Depreciation Book")
                {
                }
                field("FA Starting Nos."; Rec."FA Starting Nos.")
                {
                }
                field("FA Conso Nos."; Rec."FA Conso Nos.")
                {
                }
                field("FA Starting Nos. Impr"; Rec."FA Starting Nos. Impr")
                {
                }
                field("FA Rebut Nos."; Rec."FA Rebut Nos.")
                {
                }
                field("FA Inventory Nos."; Rec."FA Inventory Nos.")
                {
                }
                field("FA Transfer Nos."; Rec."FA Transfer Nos.")
                {
                }
                field("FA Cession Nos."; Rec."FA Cession Nos.")
                {
                }
                field("FA In Service Nos."; Rec."FA In Service Nos.")
                {
                }
            }
            group(Progal)
            {
                Caption = 'Progal';
                field("PROGAL Vendor Code"; Rec."PROGAL Vendor Code")
                {
                }
                field("PROGAL Unrealized Gains Acc."; Rec."PROGAL Unrealized Gains Acc.")
                {
                }
                field("PROGAL Realized Gains Acc."; Rec."PROGAL Realized Gains Acc.")
                {
                }
                field("PROGAL Unrealized Losses Acc."; Rec."PROGAL Unrealized Losses Acc.")
                {
                }
                field("PROGAL Realized Losses Acc."; Rec."PROGAL Realized Losses Acc.")
                {
                }
            }
            group("Interface MFiles")
            {
                Caption = 'Interface MFiles';
                field("MFiles Mgt"; Rec."MFiles Mgt")
                {
                }
            }
            group("Interface CRM")
            {
                Caption = 'Interface CRM';
                field("Create Dde Deblocage"; Rec."Create Dde Deblocage")
                {
                }
                field("CRM Web Service User"; Rec."CRM Web Service User")
                {
                }
                field("CRM Web Service Password"; Rec."CRM Web Service Password")
                {
                }
            }
            group("Interface SQL")
            {
                Caption = 'Interface SQL';
                field("SQL Server ID"; Rec."SQL Server ID")
                {
                }
                field("SQL Server DB"; Rec."SQL Server DB")
                {
                }
                field("SQL User"; Rec."SQL User")
                {
                }
                field("SQL Password"; Rec."SQL Password")
                {
                }
                field("CReports Program Path"; Rec."CReports Program Path")
                {
                }
            }
            group(Cargo)
            {
                Caption = 'Cargo';
                field("Desactivate Stock Value Mgt"; Rec."Desactivate Stock Value Mgt")
                {
                }
                field("JOVENNA Regul Cargo"; Rec."JOVENNA Regul Cargo")
                {
                }
                field("Cargo Confreres"; Rec."Cargo Confreres")
                {
                }
            }
            group(Provisions)
            {
                Caption = 'Provisions';
                field("Charges to receive Account"; Rec."Charges to receive Account")
                {
                }
                field("Invoice To Receive Acc Station"; Rec."Invoice To Receive Acc Station")
                {
                }
                field("Unbilled Revenues Account"; Rec."Unbilled Revenues Account")
                {
                }
                field("Provision Tmpl Journal"; Rec."Provision Tmpl Journal")
                {
                }
                field("Charge Item Vendor"; Rec."Charge Item Vendor")
                {
                }
                field("GRT Fees Storage Account"; Rec."GRT Fees Storage Account")
                {
                }
                field("Fees Transport Account"; Rec."Fees Transport Account")
                {
                }
                field("Fees Transfer Account"; Rec."Fees Transfer Account")
                {
                }
                field("Provisions LPSA"; Rec."Provisions LPSA")
                {
                }
                field("Fees Massif Transfer Account"; Rec."Fees Massif Transfer Account")
                {
                }
            }
            group(Cartes)
            {
                Caption = 'Cartes';
                field("Sales by Cards Import Tmpl"; Rec."Sales by Cards Import Tmpl")
                {
                }
                field("Prepaid Cards Account"; Rec."Prepaid Cards Account")
                {
                }
                field("Postpaid Cards Account"; Rec."Postpaid Cards Account")
                {
                }
                field("Cards Discount Account"; Rec."Cards Discount Account")
                {
                }
                field("GPRO Cards Account"; Rec."GPRO Cards Account")
                {
                }
                field("CAP Sales Channel"; Rec."CAP Sales Channel")
                {
                }
                field("CAP Sales Category"; Rec."CAP Sales Category")
                {
                }
                field("ND Cheque Caution Account CAP"; Rec."ND Cheque Caution Account CAP")
                {
                }
                field("Sales by Cards Nos."; Rec."Sales by Cards Nos.")
                {
                }
                field("Posted Sales by Cards Nos."; Rec."Posted Sales by Cards Nos.")
                {
                }
                field("Credit Notes Nos."; Rec."Credit Notes Nos.")
                {
                }
                field("Debit Notes Nos."; Rec."Debit Notes Nos.")
                {
                }
                field("Moneytech Billing Nos."; Rec."Moneytech Billing Nos.")
                {
                }
                field("Activer Camion Ravitailleur"; Rec."Activer Camion Ravitailleur")
                {
                }
                field("Code Article Cam Ravitailleur"; Rec."Code Article Cam Ravitailleur")
                {
                }
                field("Code Client Carte Cam Ravitall"; Rec."Code Client Carte Cam Ravitall")
                {
                }
            }
            group(Dispaching)
            {
                Caption = 'Dispaching';
                field("Dispaching Unit Code"; Rec."Dispaching Unit Code")
                {
                }
                field("Dispaching Maximum Tours"; Rec."Dispaching Maximum Tours")
                {
                }
                field("Dispaching CamionPlein"; Rec."Dispaching CamionPlein")
                {
                }
                field("Dispaching ContraintePointLivr"; Rec."Dispaching ContraintePointLivr")
                {
                }
                field("Dispaching ContrainteLivraison"; Rec."Dispaching ContrainteLivraison")
                {
                }
                field("Dispaching ContrainteTransport"; Rec."Dispaching ContrainteTransport")
                {
                }
                field("Dispaching PlusieursVoyages"; Rec."Dispaching PlusieursVoyages")
                {
                }
                field("Dispaching FusionCommandes"; Rec."Dispaching FusionCommandes")
                {
                }
                field("Dispaching Post Shipment"; Rec."Dispaching Post Shipment")
                {
                }
                field("Dispaching Program Path"; Rec."Dispaching Program Path")
                {
                }
                field("Dispaching NbreMax Station Cam"; Rec."Dispaching NbreMax Station Cam")
                {
                }
                field("Dispaching NbreMax Cam Station"; Rec."Dispaching NbreMax Cam Station")
                {
                }
                field("Bons Prefix Nos"; Rec."Bons Prefix Nos")
                {
                }
                field("Bons Nos."; Rec."Bons Nos.")
                {
                }
            }
            group("Cyptage PGP")
            {
                Caption = 'Cyptage PGP';
                field(BankPaymentTransferFilesPath; Rec.BankPaymentTransferFilesPath)
                {
                }
                field(BankPaymentTransferFilesPrefix; Rec.BankPaymentTransferFilesPrefix)
                {
                }
                field(PGPExeFilePath; Rec.PGPExeFilePath)
                {
                }
                field(PGPEmailRecipientAddress; Rec.PGPEmailRecipientAddress)
                {
                }
                field(PGPKeyFilePath; Rec.PGPKeyFilePath)
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Archiver Cdes Achats")
            {
                Caption = 'Archiver Cdes Achats';
                RunObject = XMLport "Archive Cdes Achat Force";
            }
            action(CreatePasswordTest)
            {
                ApplicationArea = All;
                Image = Create;
                Caption = 'TestJP';
                //Promoted = true;
                //PromotedCategory = Process;
                trigger OnAction()
                var
                    ApiMgt: Codeunit "Afk Api Mgt";
                    EmailMgt: Codeunit EmailMgt;
                begin
                    //ApiMgt.DebugApiFunction();
                    EmailMgt.TestSendEmail();
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Reset;
        if not Rec.Get then begin
            Rec.Init;
            Rec.Insert;
        end;
    end;
}

