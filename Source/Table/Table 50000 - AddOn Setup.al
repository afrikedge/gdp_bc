table 50000 "AddOn Setup"
{

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; "OMH Fees Account"; Code[20])
        {
            Caption = 'OMH Fees Account';
            TableRelation = "G/L Account" WHERE("Account Type" = CONST(Posting));
        }
        field(3; "FER Fees Account"; Code[20])
        {
            Caption = 'FER Fees Account';
            TableRelation = "G/L Account" WHERE("Account Type" = CONST(Posting));
        }
        field(4; "ENV Fees Account"; Code[20])
        {
            Caption = 'ENV Fees Account';
            TableRelation = "G/L Account" WHERE("Account Type" = CONST(Posting));
        }
        field(5; "Cancel Fees Retention Posting"; Boolean)
        {
            Caption = 'Cancel Fees Retention Posting';
        }
        field(6; "Shipment Location PBL"; Code[10])
        {
            Caption = 'PBL Shipment Location';
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
        }
        field(7; "Removal Journal code"; Code[10])
        {
            TableRelation = "Source Code";
        }
        field(8; "Jirama Sales Forecast Nos."; Code[10])
        {
            AccessByPermission = TableData "Sales Shipment Header" = R;
            Caption = 'Jirama Sales Forecast Nos.';
            TableRelation = "No. Series";
        }
        field(9; "Jirama Customer No"; Code[20])
        {
            Caption = 'JIRAMA Customer No.';
            TableRelation = Customer;
        }
        field(10; "Jirama Partner Code"; Code[20])
        {
            Caption = 'JIRAMA Partner Code';
            TableRelation = Vendor;
        }
        field(11; "Jirama Affectation %"; Decimal)
        {
            Caption = 'JIRAMA Purchase order Affecation %';
            Description = '% pour commande d''achat suite a une cde jirama';
            MaxValue = 100;
        }
        field(12; "JIRAMA Item No."; Code[20])
        {
            Caption = 'JIRAMA Item Code';
            TableRelation = Item;
        }
        field(13; "Sales by Cards Nos."; Code[10])
        {
            AccessByPermission = TableData "Sales Shipment Header" = R;
            Caption = 'Sales by Cards Nos.';
            TableRelation = "No. Series";
        }
        field(14; "Posted Sales by Cards Nos."; Code[10])
        {
            AccessByPermission = TableData "Sales Shipment Header" = R;
            Caption = 'Posted Sales by Cards Nos.';
            TableRelation = "No. Series";
        }
        field(15; "Sales by Cards Import Tmpl"; Code[10])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(16; "Prepaid Cards Account"; Code[20])
        {
            Caption = 'Prepaid Cards Account';
            TableRelation = "G/L Account" WHERE("Account Type" = CONST(Posting));
        }
        field(17; "Postpaid Cards Account"; Code[20])
        {
            Caption = 'Postpaid Cards Account';
            TableRelation = "G/L Account" WHERE("Account Type" = CONST(Posting));
        }
        field(18; "Credit Notes Nos."; Code[10])
        {
            AccessByPermission = TableData "Sales Shipment Header" = R;
            Caption = 'Credit Notes Nos.';
            TableRelation = "No. Series";
        }
        field(19; "Debit Notes Nos."; Code[10])
        {
            AccessByPermission = TableData "Sales Shipment Header" = R;
            Caption = 'Debit Notes Nos.';
            TableRelation = "No. Series";
        }
        field(20; "Moneytech Billing Nos."; Code[10])
        {
            Caption = 'Moneytech Billing Nos';
            TableRelation = "No. Series";
        }
        field(21; "Fuel Statement Nos."; Code[10])
        {
            AccessByPermission = TableData "Sales Shipment Header" = R;
            Caption = 'Fuel Statement Nos.';
            TableRelation = "No. Series";
        }
        field(22; "Transit Location Transfer"; Code[10])
        {
            Caption = 'Transit location for hypothetical transfers';
            Description = 'NOT USED';
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
        }
        field(23; "Hypo Transfer Receipt Nos."; Code[10])
        {
            Caption = 'Hypothetical Transfer receipt N°';
            TableRelation = "No. Series";
        }
        field(24; "Item Loan Nos."; Code[10])
        {
            Caption = 'Item Loan Nos';
            TableRelation = "No. Series";
        }
        field(25; "Item Borrow Nos."; Code[10])
        {
            Caption = 'Item Borrow Nos.';
            TableRelation = "No. Series";
        }
        field(26; "Item Exchange Nos."; Code[10])
        {
            Caption = 'Item Exchange Nos.';
            TableRelation = "No. Series";
        }
        field(27; "Item Consignation Nos."; Code[10])
        {
            Caption = 'Item Consignation Nos.';
            TableRelation = "No. Series";
        }
        field(28; "Item Return Consignation Nos."; Code[10])
        {
            Caption = 'Item Return Consignation Nos.';
            TableRelation = "No. Series";
        }
        field(29; "Item Return Loan Nos."; Code[10])
        {
            Caption = 'Item Return Loan Nos.';
            TableRelation = "No. Series";
        }
        field(30; "Item Return Borrow Nos."; Code[10])
        {
            Caption = 'Item Return Borrow Nos.';
            TableRelation = "No. Series";
        }
        field(31; "Sales Exchange Fees Acc"; Code[20])
        {
            Caption = 'Sales Exchange Fees Account';
            TableRelation = "G/L Account" WHERE("Account Type" = CONST(Posting));
        }
        field(32; "Purchase Exchange Fees Acc"; Code[20])
        {
            Caption = 'Purchase Exchange Fees Account';
            TableRelation = "G/L Account" WHERE("Account Type" = CONST(Posting));
        }
        field(33; "Consignation Location"; Code[10])
        {
            Caption = 'Consignation Location';
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
        }
        field(34; "Dispaching Unit Code"; Code[10])
        {
            Caption = 'Dispaching Unit Code';
            TableRelation = "Unit of Measure";
        }
        field(35; "Purchase Request Nos"; Code[10])
        {
            Caption = 'Purch Requisition N°';
            TableRelation = "No. Series";
        }
        field(36; "Code Budget Def"; Code[10])
        {
            TableRelation = "G/L Budget Name";
        }
        field(37; "Invoiced Consumption Nos."; Code[10])
        {
            Caption = 'Invoiced Consumption Nos.';
            TableRelation = "No. Series";
        }
        field(38; "FA Starting Nos."; Code[10])
        {
            Caption = 'FA Starting Nos.';
            TableRelation = "No. Series";
        }
        field(39; "NoVAT Prod. Posting Group"; Code[10])
        {
            Caption = '0% VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";
        }
        field(40; "Charges to receive Account"; Code[20])
        {
            Caption = 'Charges to receive Account';
            TableRelation = "G/L Account" WHERE("Account Type" = CONST(Posting));
        }
        field(41; "Budget Period"; Option)
        {
            OptionCaption = 'None,Year,Month';
            OptionMembers = "None",Year,Month;
        }
        field(42; "Unbilled Revenues Account"; Code[20])
        {
            Caption = 'Unbilled Revenues Account';
            TableRelation = "G/L Account" WHERE("Account Type" = CONST(Posting));
        }
        field(43; "Provision Tmpl Journal"; Code[10])
        {
            Caption = 'Provision Template journal';
            TableRelation = "Gen. Journal Template";
        }
        field(44; "Invoice To Receive Account"; Code[20])
        {
            Caption = 'Invoices to receive Account';
            TableRelation = "G/L Account" WHERE("Account Type" = CONST(Posting));
        }
        field(45; "Gen. Bus. Posting Group Def"; Code[10])
        {
            Caption = 'Gen. Bus. Posting Group Def';
            TableRelation = "Gen. Business Posting Group";
        }
        field(46; "PBL Category Code"; Code[10])
        {
            Caption = 'PBL Category Code';
            TableRelation = "Item Category".Code;
        }
        field(47; "Check Warranty Nos."; Code[10])
        {
            Caption = 'Check Warranty Nos.';
            TableRelation = "No. Series";
        }
        field(48; "Letter of credit Nos."; Code[10])
        {
            Caption = 'Letter of Credit Nos.';
            TableRelation = "No. Series";
        }
        field(49; "Charge Item Vendor"; Code[20])
        {
            Caption = 'Vendor (Provisions)';
            TableRelation = Vendor;
        }
        field(50; "Payroll Tmpl Journal"; Code[10])
        {
            Caption = 'Payroll Template journal';
            TableRelation = "Gen. Journal Template";
        }
        field(51; "JIRAMA Sales Channel"; Code[10])
        {
            Caption = 'JIRAMA Channel Code';
            TableRelation = "Sales Channel";
        }
        field(52; "Desactivate Stock Value Mgt"; Boolean)
        {
            Caption = 'Desactivate item allocation per cargo';
        }
        field(53; "Security on Journal"; Boolean)
        {
            Caption = 'Activate security on Journals';
        }
        field(54; "GL Security On Group Users"; Boolean)
        {
            Caption = 'GL Security On Group Users';
        }
        field(55; "ND Cheque Caution Account PBL"; Code[20])
        {
            Caption = 'Caution Account Stations';
            TableRelation = "G/L Account" WHERE("Account Type" = CONST(Posting));
        }
        field(56; "Curr Purchase Tmpl Journal"; Code[10])
        {
            Caption = 'Curr Purchase Tmpl Journal';
            TableRelation = "Gen. Journal Template";
        }
        field(57; "Credit Bank Account"; Code[20])
        {
            Caption = 'Credit Bank Account';
            TableRelation = "G/L Account" WHERE("Account Type" = CONST(Posting));
        }
        field(58; "Desactivate Check Nos Control"; Boolean)
        {
            Caption = 'Desactivate Check Nos Control';
        }
        field(59; "CAP Sales Channel"; Code[10])
        {
            Caption = 'Card Channel Code';
            TableRelation = "Sales Channel";
        }
        field(60; "AMSA Sales Channel"; Code[10])
        {
            Caption = 'AMSA Channel Code';
            TableRelation = "Sales Channel";
        }
        field(61; "Skip AMSA/JIRAMA Docs Control"; Boolean)
        {
            Caption = 'Skip AMSA/JIRAMA Docs Control';
        }
        field(62; "LUB Shipment Location"; Code[10])
        {
            Caption = 'LUB Shipment Location';
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
        }
        field(63; "PBL Sales Category"; Code[10])
        {
            Caption = 'PBL Sales Category';
            TableRelation = "Sales Category";
        }
        field(64; "LUBS Sales Category"; Code[10])
        {
            Caption = 'LUBS Sales Category';
            TableRelation = "Sales Category";
        }
        field(65; "FA Conso Nos."; Code[10])
        {
            Caption = 'FA Conso Nos.';
            TableRelation = "No. Series";
        }
        field(66; "Fiscal Depreciation Book"; Code[10])
        {
            Caption = 'Fiscal Depreciation Book';
            TableRelation = "Depreciation Book";
        }
        field(67; "CCL Mobile Money Acc 1"; Code[20])
        {
            Caption = 'Bank Account Mobile Money';
            TableRelation = "Bank Account";
        }
        field(68; "AMSA Main Invoices Nos."; Code[10])
        {
            Caption = 'AMSA Main Invoices Nos.';
            TableRelation = "No. Series";
        }
        field(69; "AMSA Invoices Nos."; Code[10])
        {
            Caption = 'AMSA Invoices Nos.';
            TableRelation = "No. Series";
        }
        field(70; "Cards Discount Account"; Code[20])
        {
            Caption = 'Cards Discount Account';
            TableRelation = "G/L Account" WHERE("Account Type" = CONST(Posting));
        }
        field(71; "Partner Location"; Code[10])
        {
            Caption = 'Partner Location';
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
        }
        field(72; "Transfer Receipt Nos."; Code[10])
        {
            Caption = 'Transfer Receipt Nos.';
            TableRelation = "No. Series";
        }
        field(73; "Transfer Order Nos."; Code[10])
        {
            Caption = 'Transfer Order Nos.';
            TableRelation = "No. Series";
        }
        field(74; "GRT Fees Storage Account"; Code[20])
        {
            Caption = 'GRT Fees Storage Account';
            TableRelation = "G/L Account" WHERE("Account Type" = CONST(Posting));
        }
        field(75; "Fees Transport Account"; Code[20])
        {
            Caption = 'Fees Transport Account';
            TableRelation = "G/L Account" WHERE("Account Type" = CONST(Posting));
        }
        field(76; "Fees Transfer Account"; Code[20])
        {
            Caption = 'Fees Transfer Account';
            TableRelation = "G/L Account" WHERE("Account Type" = CONST(Posting));
        }
        field(77; "LPSA Vendor Code"; Code[20])
        {
            Caption = 'LPSA Vendor Code';
            TableRelation = Vendor;
        }
        field(78; "GRT Vendor Code"; Code[20])
        {
            Caption = 'GRT Vendor Code';
            TableRelation = Vendor;
        }
        field(79; "GRT Location Code"; Code[10])
        {
            Caption = 'GRT Location Code';
            TableRelation = Location;
        }
        field(80; "LPSA Fees Storage Account"; Code[20])
        {
            Caption = 'LPSA Fees Storage Account';
            TableRelation = "G/L Account" WHERE("Account Type" = CONST(Posting));
        }
        field(81; "LPSA Transit Transfer Location"; Code[10])
        {
            Caption = 'LPSA Transit Transfer Location';
            TableRelation = Location;
        }
        field(83; "Compte Effet A Recevoir"; Code[20])
        {
            Caption = 'Compte Client Effets à recevoir';
            TableRelation = "G/L Account" WHERE("Account Type" = CONST(Posting));
        }
        field(84; "LPSA Adjustment Reason Code"; Code[10])
        {
            Caption = 'LPSA Adjustment Reason Code';
            TableRelation = "Reason Code";
        }
        field(85; "Desactivate Whse Sec"; Boolean)
        {
            Caption = 'Desactivate Whse Sec';
        }
        field(86; "Shipment Method Direct"; Code[10])
        {
            Caption = 'Direct Shipment Method';
            TableRelation = "Shipment Method";
        }
        field(87; "LUBS Item Category"; Code[10])
        {
            Caption = 'LUBS Category';
            TableRelation = "Item Category";
        }
        field(88; "JIRAMA Forecast Transfer Nos."; Code[10])
        {
            Caption = 'JIRAMA Forecast Transfer Nos.';
            TableRelation = "No. Series";
        }
        field(89; "CRM Web Service User"; Text[30])
        {
            Caption = 'CRM Web Service User';
        }
        field(90; "CRM Web Service Password"; Text[50])
        {
            Caption = 'CRM Web Service Password';
            ExtendedDatatype = Masked;
        }
        field(91; "CCL Mobile Money Acc 2"; Code[20])
        {
            Caption = 'AIRTEL Bank Account Mobile Money';
            TableRelation = "Bank Account";
        }
        field(92; "CCL Mobile Money Acc 3"; Code[20])
        {
            Caption = 'MVOLA Bank Account Mobile Money';
            TableRelation = "Bank Account";
        }
        field(93; "Shipment Method JIRAMA"; Code[10])
        {
            Caption = 'JIRAMA Shipment Method';
            TableRelation = "Shipment Method";
        }
        field(94; "CReports Program Path"; Text[200])
        {
            Caption = 'Crystal Reports Path';
        }
        field(95; "Activate bank Acc Sec"; Boolean)
        {
            Caption = 'Activate bank Account Security';
        }
        field(96; "Cargo Confreres"; Code[20])
        {
            Caption = 'Cargo confrères';
            TableRelation = Cargo;
        }
        field(97; "Item on Invoice"; Boolean)
        {
            Caption = 'Item in Invoice';
        }
        field(98; "Cargo Enlevement"; Code[20])
        {
            Caption = 'Cargo Enlevement';
            TableRelation = Cargo;
        }
        field(99; "GPL Sales Channel"; Code[10])
        {
            Caption = 'GPL Channel Code';
            TableRelation = "Sales Channel";
        }
        field(100; "SQL Server ID"; Code[30])
        {
            Caption = 'SQl Server Adress';
        }
        field(101; "SQL Server DB"; Code[30])
        {
            Caption = 'SQl Server Database';
        }
        field(102; "SQL User"; Code[10])
        {
            Caption = 'SQL User';
        }
        field(103; "SQL Password"; Text[30])
        {
            Caption = 'SQL User Password';
            ExtendedDatatype = Masked;
        }
        field(104; "Item Shipment Nos."; Code[10])
        {
            Caption = 'Item Shipment Nos.';
            TableRelation = "No. Series";
        }
        field(105; "GPL Item Category"; Code[10])
        {
            Caption = 'GPL Item Category';
            TableRelation = "Item Category";
        }
        field(106; "Shipment Location GPL"; Code[10])
        {
            Caption = 'GPL Shipment Location';
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));
        }
        field(107; "GPRO Cards Account"; Code[20])
        {
            Caption = 'Postpaid GPRO Cards Account';
            TableRelation = "G/L Account" WHERE("Account Type" = CONST(Posting));
        }
        field(108; "ND Cheque Caution Account CAP"; Code[20])
        {
            Caption = 'Caution Account CAP Customer';
            TableRelation = "G/L Account" WHERE("Account Type" = CONST(Posting));
        }
        field(109; "JOVENNA Vendor Code"; Code[20])
        {
            Caption = 'JOVENNA Vendor Code';
            TableRelation = Vendor;
        }
        field(110; "Inv To Receive Acc JOVENNA"; Code[20])
        {
            Caption = 'JOVENNA Invoices to receive Account';
            TableRelation = "G/L Account" WHERE("Account Type" = CONST(Posting));
        }
        field(112; "Transport Item Category"; Code[10])
        {
            Caption = 'Transport Item Category';
            TableRelation = "Item Category";
        }
        field(113; "Provisions LPSA"; Code[20])
        {
            Caption = 'Compte provisions LPSA';
            TableRelation = "G/L Account" WHERE("Account Type" = CONST(Posting));
        }
        field(114; "Activer libelles Compta Client"; Boolean)
        {
            Caption = 'Activer libellés facture vente en compta';
        }
        field(115; "Activer libelles compta Fsseur"; Boolean)
        {
            Caption = 'Activer libellés facture achat en compta';
        }
        field(116; "JOVENNA Sales Channel"; Code[10])
        {
            Caption = 'JIRAMA Channel Code';
            TableRelation = "Sales Channel";
        }
        field(117; "Fees Massif Transfer Account"; Code[20])
        {
            Caption = 'Fees Massif Transfer Account';
            TableRelation = "G/L Account" WHERE("Account Type" = CONST(Posting));
        }
        field(118; "Facture Prov FA Nos."; Code[10])
        {
            Caption = 'N° Factures Prov frais annexes';
            TableRelation = "No. Series";
        }
        field(119; "Activer libelles Stock"; Boolean)
        {
            Caption = 'Activer libellés ajustement stock en compta';
        }
        field(120; "Compte Fonds de garantie"; Code[20])
        {
            Caption = 'Compte Fonds de garantie';
            TableRelation = "G/L Account" WHERE("Account Type" = CONST(Posting));
        }
        field(121; "Activer libelles Immos"; Boolean)
        {
            Caption = 'Activer libellés immos en compta';
        }
        field(122; "Progal Payment Tmpl Journal"; Code[10])
        {
            Caption = 'Progal Payment Tmpl Journal';
            TableRelation = "Gen. Journal Template";
        }
        field(123; "Station Sales Channel"; Code[10])
        {
            Caption = 'Canal de vente réseau';
            TableRelation = "Sales Channel";
        }
        field(124; "GPL Sales Category"; Code[10])
        {
            Caption = 'GPL Sales Category';
            TableRelation = "Sales Category";
        }
        field(125; "CAP Sales Category"; Code[10])
        {
            Caption = 'CAP Sales Category';
            TableRelation = "Sales Category";
        }
        field(126; "LC Payment Method"; Code[10])
        {
            Caption = 'LC Payment Method';
            TableRelation = "Payment Method";
        }
        field(127; "BE Adjustement Margin %"; Decimal)
        {
            Caption = 'BE Adjustement Margin %';
            MaxValue = 100;
        }
        field(128; "Bornage Sales Channel"; Code[10])
        {
            Caption = 'Bornage Channel Code';
            TableRelation = "Sales Channel";
        }
        field(129; "Soute Sales Channel"; Code[10])
        {
            Caption = 'Soute Channel Code';
            TableRelation = "Sales Channel";
        }
        field(130; "Naphta Product Group"; Code[10])
        {
            Caption = 'Naphta Product Group';
            //TableRelation = "Product Group".Code;*********MIGRATION**************
        }
        field(131; "OMH Fees Account - NAPHTA"; Code[20])
        {
            Caption = 'OMH Fees Account - NAPHTA';
            TableRelation = "G/L Account" WHERE("Account Type" = CONST(Posting));
        }
        field(132; "FER Fees Account - NAPHTA"; Code[20])
        {
            Caption = 'FER Fees Account - NAPHTA';
            TableRelation = "G/L Account" WHERE("Account Type" = CONST(Posting));
        }
        field(133; "ENV Fees Account - NAPHTA"; Code[20])
        {
            Caption = 'ENV Fees Account - NAPHTA';
            TableRelation = "G/L Account" WHERE("Account Type" = CONST(Posting));
        }
        field(134; "Naphta Fictif Location"; Code[10])
        {
            Caption = 'Magasin fictif NAPHTA';
            TableRelation = Location;
        }
        field(135; "Activer ajustement Naphta"; Boolean)
        {
            Caption = 'Activer ajustement Naphta';
        }
        field(136; "FA Starting Nos. Impr"; Code[10])
        {
            Caption = 'FA Starting Nos.';
            TableRelation = "No. Series";
        }
        field(137; "FA Rebut Nos."; Code[10])
        {
            Caption = 'FA Rebut Nos.';
            TableRelation = "No. Series";
        }
        field(138; "FA Inventory Nos."; Code[10])
        {
            Caption = 'FA Inventory Nos.';
            TableRelation = "No. Series";
        }
        field(139; "FA Transfer Nos."; Code[10])
        {
            Caption = 'FA Transfer Nos.';
            TableRelation = "No. Series";
        }
        field(140; "FA Cession Nos."; Code[10])
        {
            Caption = 'FA Cession Nos.';
            TableRelation = "No. Series";
        }
        field(141; "Create Dde Deblocage"; Boolean)
        {
            Caption = 'Create deblocage on CRM';
        }
        field(142; "JOVENNA Regul Cargo"; Code[10])
        {
            Caption = 'JOVENNA Regul Cargo';
            TableRelation = Cargo.Code WHERE("Cargo Type" = CONST(JOVENNA));
        }
        field(143; "FA In Service Nos."; Code[10])
        {
            Caption = 'N° Immo validés (en service)';
            TableRelation = "No. Series";
        }
        field(144; "Preserve Purch Approval Entry"; Boolean)
        {
            Caption = 'Preserve purchase order approval entries';
        }
        field(145; "Pwd Expiration (Days)"; Integer)
        {
            Caption = 'Nbre de jours expiration mdp';
        }
        field(146; "Jir Shipment Adj Reason Code"; Code[10])
        {
            Caption = 'Jir Shipment Adj Reason Code';
            TableRelation = "Reason Code";
        }
        field(147; "Jir Shipment Adj Mgt"; Boolean)
        {
            Caption = 'Activate JIRAMA Ship. Adjust. ';
        }
        field(148; "BL Adjustement Margin %"; Decimal)
        {
            Caption = 'BL Adjustement Margin %';
            MaxValue = 100;
        }
        field(149; "Primes Station Acc"; Code[20])
        {
            Caption = 'Compte primes station';
            TableRelation = "G/L Account";
        }
        field(150; "PROGAL Vendor Code"; Code[20])
        {
            Caption = 'PROGAL Vendor Code';
            TableRelation = Vendor;
        }
        field(151; "PROGAL Unrealized Gains Acc."; Code[20])
        {
            Caption = ' PROGAL Unrealized Gains Acc.';
            TableRelation = "G/L Account";

            trigger OnValidate()
            begin
                CheckGLAcc("PROGAL Unrealized Gains Acc.");
            end;
        }
        field(152; "PROGAL Realized Gains Acc."; Code[20])
        {
            Caption = ' PROGAL Realized Gains Acc.';
            TableRelation = "G/L Account";

            trigger OnValidate()
            begin
                CheckGLAcc("PROGAL Realized Gains Acc.");
            end;
        }
        field(153; "PROGAL Unrealized Losses Acc."; Code[20])
        {
            Caption = ' PROGAL Unrealized Losses Acc.';
            TableRelation = "G/L Account";

            trigger OnValidate()
            begin
                CheckGLAcc("PROGAL Unrealized Losses Acc.");
            end;
        }
        field(154; "PROGAL Realized Losses Acc."; Code[20])
        {
            Caption = ' PROGAL Realized Losses Acc.';
            TableRelation = "G/L Account";

            trigger OnValidate()
            begin
                CheckGLAcc("PROGAL Realized Losses Acc.");
            end;
        }
        field(155; "MFiles Mgt"; Boolean)
        {
            Caption = 'Activate MFiles Interface';
        }
        field(156; "VAT Group Primes Gerant"; Code[10])
        {
            Caption = 'Gas Station Bonus Mgr VAT Group';
            TableRelation = "VAT Product Posting Group";
        }
        field(157; "JIRAMA Ambohimanambola Loc"; Code[20])
        {
            Caption = 'Magasin JIRAMA Ambohimanambola';
            Description = 'Depot 11JIR';
            TableRelation = Location;
        }
        field(158; "Ambohimanambola Fees Location"; Code[20])
        {
            Caption = 'Dépôt pour le calul de frais de transfert GRT vers 11JIR';
            Description = 'Depot pour le calul de frais de transfert GRT vers 11JIR';
            TableRelation = Location;
        }
        field(159; "Jirama Affectation Cargo %"; Decimal)
        {
            Caption = '% Répartition cargo normal cde jirama';
            Description = '% sur cargo normal';
            MaxValue = 100;
            MinValue = 0;
        }
        field(160; "Invoice To Receive Acc Station"; Code[20])
        {
            Caption = 'Invoices to receive Account (Services Stations)';
            TableRelation = "G/L Account" WHERE("Account Type" = CONST(Posting));
        }
        field(161; "Extourne Facture Prov Nos."; Code[10])
        {
            Caption = 'N° Extourne Factures Prov frais annexes';
            TableRelation = "No. Series";
        }
        field(162; "Traite Acc To Cach"; Code[20])
        {
            Caption = 'Compte traite à encaisser';
            TableRelation = "G/L Account";
        }
        field(163; "Check Acc To Cach"; Code[20])
        {
            Caption = 'Compte chèque à encaisser';
            TableRelation = "G/L Account";
        }
        field(164; "Prov Transfert Amba Region"; Code[10])
        {
            Caption = 'Region pour prov. transfert Ambatovy';
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = FILTER('REGION'));
        }
        field(165; "Prov Transfert Amba Project"; Code[10])
        {
            Caption = 'Projet pour prov. transfert Ambatovy';
            TableRelation = "Dimension Value".Code WHERE("Dimension Code" = CONST('PROJET'));
        }
        field(166; "CCL Mobile Money Acc 4"; Code[20])
        {
            Caption = 'Orange Money Marchand';
            TableRelation = "Bank Account";
        }
        field(167; "Activate RDS Fees Retention"; Boolean)
        {
            Caption = 'Activer les retenues RDS';
        }
        field(168; "RDS Fees Account"; Code[20])
        {
            Caption = 'RDS Fees Account';
            TableRelation = "G/L Account" WHERE("Account Type" = CONST(Posting));
        }
        field(169; "Remove MFiles Num Check"; Boolean)
        {
            Caption = 'Désactiver le controles des N° MFiles';
        }
        field(170; "CAP CreditNote Gerant Prepaid"; Code[20])
        {
            Caption = 'Prepaid Credit Note Gerant Account';
            TableRelation = "G/L Account" WHERE("Account Type" = CONST(Posting));
        }
        field(171; "CAP DebitNote Gerant Prepaid"; Code[20])
        {
            Caption = 'PrepaiDebit Note Gerant Account';
            TableRelation = "G/L Account" WHERE("Account Type" = CONST(Posting));
        }
        field(172; "CAP VAT Group NDNC Gerant"; Code[10])
        {
            Caption = 'VAT Group NDNC Gerant';
            TableRelation = "VAT Product Posting Group";
        }
        field(173; "CAP CreditNote Gerant Postpaid"; Code[20])
        {
            Caption = 'Postpaid Credit Note Gerant Account';
            TableRelation = "G/L Account" WHERE("Account Type" = CONST(Posting));
        }
        field(174; "CAP DebitNote Gerant Postpaid"; Code[20])
        {
            Caption = 'Postpaid Debit Note Gerant Account';
            TableRelation = "G/L Account" WHERE("Account Type" = CONST(Posting));
        }
        field(175; "CAP CreditNote Gerant GPRO"; Code[20])
        {
            Caption = 'GPRO Credit Note Gerant Account';
            TableRelation = "G/L Account" WHERE("Account Type" = CONST(Posting));
        }
        field(176; "CAP DebitNote Gerant GPRO"; Code[20])
        {
            Caption = 'GPRO Debit Note Gerant Account';
            TableRelation = "G/L Account" WHERE("Account Type" = CONST(Posting));
        }
        field(177; GOItem; Code[20])
        {
            Caption = 'GO Item Code';
            TableRelation = Item;
        }
        field(178; "CRM Web Service Adress"; Text[200])
        {
            Caption = 'CRM Web Service Adress';
        }
        field(179; "CRM DB Server"; Text[30])
        {
            Caption = 'CRM DB Server';
        }
        field(180; "CRM DB Name"; Code[30])
        {
            Caption = 'CRM Database';
        }
        field(181; "CRM DB User"; Code[30])
        {
            Caption = 'CRM SQL User';
        }
        field(182; "CRM DB Password"; Text[50])
        {
            Caption = 'CRM SQL User Password';
            ExtendedDatatype = Masked;
        }
        field(183; "Print Directory Setup"; Text[50])
        {
            Caption = 'Directory for printing';
        }
        field(184; "Dispaching Maximum Tours"; Integer)
        {
            Caption = 'Dispaching Maximum tours';
        }
        field(185; "Dispaching CamionPlein"; Boolean)
        {
            Caption = 'Camions toujours pleins à la sortie du dépôt';
        }
        field(186; "Dispaching ContraintePointLivr"; Boolean)
        {
            Caption = 'Tenir compte des contraintes géographique des points de livraison';
        }
        field(187; "Dispaching ContrainteLivraison"; Boolean)
        {
            Caption = 'Tenir compte de la compatibilité des produits en livraison';
        }
        field(188; "Dispaching ContrainteTransport"; Boolean)
        {
            Caption = 'Tenir compte de la compatibilité des produits en transport';
        }
        field(189; "Dispaching PlusieursVoyages"; Boolean)
        {
            Caption = 'Autoriser plusieurs voyages dans la même journée';
        }
        field(190; "Dispaching FusionCommandes"; Boolean)
        {
            Caption = 'Fusionner les commandes du même point de livraison';
        }
        field(191; "CRM Interface Program Path"; Text[100])
        {
            Caption = 'CRM Interface Path';
        }
        field(192; "Dispaching Post Shipment"; Boolean)
        {
            Caption = 'Activer livr sur confirmation BL';
        }
        field(193; "Dispaching Program Path"; Text[100])
        {
            Caption = 'Dispaching Program Path';
        }
        field(194; "Activer Camion Ravitailleur"; Boolean)
        {
            Caption = 'Activer Livraison camion ravitalleur';
        }
        field(195; "Code Article Cam Ravitailleur"; Code[20])
        {
            Caption = 'Code article Camion Ravitalleur';
            TableRelation = Item;
        }
        field(196; "Code Client Carte Cam Ravitall"; Code[20])
        {
            Caption = 'Code client carte (Camion Ravitalleur)';
            TableRelation = Customer;
        }
        field(197; BankPaymentTransferFilesPath; Text[100])
        {
            Caption = 'Bank Payments Transfer Files Path';
        }
        field(198; BankTransfCertificatIssuerName; Text[100])
        {
            Caption = 'Bank Transfer Certificat Issuer Name';
        }
        field(199; "Dispaching NbreMax Station Cam"; Integer)
        {
            Caption = 'Nbre max de stations à livrer par un camion pour une tournée';
        }
        field(200; "Dispaching NbreMax Cam Station"; Integer)
        {
            Caption = 'Nbre Max de camions pour livrer une station par tournée';
        }
        field(201; BankPaymentTransferFilesPrefix; Text[30])
        {
            Caption = 'Préfixe pour le nom du fichier crypté généré pour les virements bancaires';
        }
        field(202; PGPExeFilePath; Text[100])
        {
            Caption = 'Chemin fichier gpg.exe';
        }
        field(203; PGPEmailRecipientAddress; Text[80])
        {
            Caption = 'Adresse email destinataire clé PGP';
        }
        field(204; PGPKeyFilePath; Text[100])
        {
            Caption = 'Emplacement fichier clé PGP';
        }
        field(205; "Bons Nos."; Code[10])
        {
            Caption = 'Bons Nos.';
            TableRelation = "No. Series";
        }
        field(206; "Bons Prefix Nos"; Code[10])
        {
            Caption = 'Préfixe des bons (Dispaching)';
        }
        field(207; "CCL Mobile Money Acc 5"; Code[20])
        {
            Caption = 'AIRTEL Money Marchand';
            TableRelation = "Bank Account";
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
        }
    }

    fieldgroups
    {
    }

    local procedure CheckGLAcc(AccNo: Code[20])
    var
        GLAcc: Record "G/L Account";
    begin
        if AccNo <> '' then begin
            GLAcc.Get(AccNo);
            GLAcc.CheckGLAcc;
        end;
    end;

    var
        RecordHasBeenRead: Boolean;

    procedure GetRecordOnce()
    begin
        if RecordHasBeenRead then
            exit;
        Get();
        RecordHasBeenRead := true;
    end;
}

