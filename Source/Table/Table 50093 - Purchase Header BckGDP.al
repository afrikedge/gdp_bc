table 50093 "Purchase Header BckGDP"
{
    // //Archiver si suppression manuelle (Cas de commande facturées a partir de la création d'une facture directe)
    // 121017  MFiles Interface Mgt

    Caption = 'Purchase Header';
    DataCaptionFields = "No.", "Buy-from Vendor Name";
    LookupPageID = "Purchase List";

    fields
    {
        field(1; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        }
        field(2; "Buy-from Vendor No."; Code[20])
        {
            Caption = 'Buy-from Vendor No.';
            TableRelation = Vendor;
        }
        field(3; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(4; "Pay-to Vendor No."; Code[20])
        {
            Caption = 'Pay-to Vendor No.';
            NotBlank = true;
            TableRelation = Vendor;
        }
        field(5; "Pay-to Name"; Text[50])
        {
            Caption = 'Pay-to Name';
        }
        field(6; "Pay-to Name 2"; Text[50])
        {
            Caption = 'Pay-to Name 2';
        }
        field(7; "Pay-to Address"; Text[50])
        {
            Caption = 'Pay-to Address';
        }
        field(8; "Pay-to Address 2"; Text[50])
        {
            Caption = 'Pay-to Address 2';
        }
        field(9; "Pay-to City"; Text[30])
        {
            Caption = 'Pay-to City';
            TableRelation = IF ("Pay-to Country/Region Code" = CONST('')) "Post Code".City
            ELSE IF ("Pay-to Country/Region Code" = FILTER(<> '')) "Post Code".City WHERE("Country/Region Code" = FIELD("Pay-to Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                PostCode.ValidateCity(
                  "Pay-to City", "Pay-to Post Code", "Pay-to County", "Pay-to Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(10; "Pay-to Contact"; Text[50])
        {
            Caption = 'Pay-to Contact';
        }
        field(11; "Your Reference"; Text[35])
        {
            Caption = 'Your Reference';
        }
        field(12; "Ship-to Code"; Code[10])
        {
            Caption = 'Ship-to Code';
            TableRelation = "Ship-to Address".Code WHERE("Customer No." = FIELD("Sell-to Customer No."));

            trigger OnValidate()
            begin
                if ("Document Type" = "Document Type"::Order) and
                   (xRec."Ship-to Code" <> "Ship-to Code")
                then begin
                    PurchLine.SetRange("Document Type", PurchLine."Document Type"::Order);
                    PurchLine.SetRange("Document No.", "No.");
                    PurchLine.SetFilter("Sales Order Line No.", '<>0');
                    if not PurchLine.IsEmpty then
                        Error(
                          Text006,
                          FieldCaption("Ship-to Code"));
                end;

                if "Ship-to Code" <> '' then begin
                    ShipToAddr.Get("Sell-to Customer No.", "Ship-to Code");
                    "Ship-to Name" := ShipToAddr.Name;
                    "Ship-to Name 2" := ShipToAddr."Name 2";
                    "Ship-to Address" := ShipToAddr.Address;
                    "Ship-to Address 2" := ShipToAddr."Address 2";
                    "Ship-to City" := ShipToAddr.City;
                    "Ship-to Post Code" := ShipToAddr."Post Code";
                    "Ship-to County" := ShipToAddr.County;
                    "Ship-to Country/Region Code" := ShipToAddr."Country/Region Code";
                    "Ship-to Contact" := ShipToAddr.Contact;
                    "Shipment Method Code" := ShipToAddr."Shipment Method Code";
                    if ShipToAddr."Location Code" <> '' then
                        Validate("Location Code", ShipToAddr."Location Code");
                end else begin
                    TestField("Sell-to Customer No.");
                    Cust.Get("Sell-to Customer No.");
                    "Ship-to Name" := Cust.Name;
                    "Ship-to Name 2" := Cust."Name 2";
                    "Ship-to Address" := Cust.Address;
                    "Ship-to Address 2" := Cust."Address 2";
                    "Ship-to City" := Cust.City;
                    "Ship-to Post Code" := Cust."Post Code";
                    "Ship-to County" := Cust.County;
                    "Ship-to Country/Region Code" := Cust."Country/Region Code";
                    "Ship-to Contact" := Cust.Contact;
                    "Shipment Method Code" := Cust."Shipment Method Code";
                    if Cust."Location Code" <> '' then
                        Validate("Location Code", Cust."Location Code");
                end;
            end;
        }
        field(13; "Ship-to Name"; Text[50])
        {
            Caption = 'Ship-to Name';
        }
        field(14; "Ship-to Name 2"; Text[50])
        {
            Caption = 'Ship-to Name 2';
        }
        field(15; "Ship-to Address"; Text[50])
        {
            Caption = 'Ship-to Address';
        }
        field(16; "Ship-to Address 2"; Text[50])
        {
            Caption = 'Ship-to Address 2';
        }
        field(17; "Ship-to City"; Text[30])
        {
            Caption = 'Ship-to City';
            TableRelation = IF ("Ship-to Country/Region Code" = CONST('')) "Post Code".City
            ELSE IF ("Ship-to Country/Region Code" = FILTER(<> '')) "Post Code".City WHERE("Country/Region Code" = FIELD("Ship-to Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                PostCode.ValidateCity(
                  "Ship-to City", "Ship-to Post Code", "Ship-to County", "Ship-to Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(18; "Ship-to Contact"; Text[50])
        {
            Caption = 'Ship-to Contact';
        }
        field(19; "Order Date"; Date)
        {
            AccessByPermission = TableData "Purch. Rcpt. Header" = R;
            Caption = 'Order Date';
        }
        field(20; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(21; "Expected Receipt Date"; Date)
        {
            Caption = 'Expected Receipt Date';
        }
        field(22; "Posting Description"; Text[50])
        {
            Caption = 'Posting Description';
        }
        field(23; "Payment Terms Code"; Code[10])
        {
            Caption = 'Payment Terms Code';
            TableRelation = "Payment Terms";
        }
        field(24; "Due Date"; Date)
        {
            Caption = 'Due Date';
        }
        field(25; "Payment Discount %"; Decimal)
        {
            Caption = 'Payment Discount %';
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate()
            begin
                if not (CurrFieldNo in [0, FieldNo("Posting Date"), FieldNo("Document Date")]) then
                    TestField(Status, Status::Open);
                GLSetup.Get;
                if "Payment Discount %" < GLSetup."VAT Tolerance %" then
                    "VAT Base Discount %" := "Payment Discount %"
                else
                    "VAT Base Discount %" := GLSetup."VAT Tolerance %";
                Validate("VAT Base Discount %");
            end;
        }
        field(26; "Pmt. Discount Date"; Date)
        {
            Caption = 'Pmt. Discount Date';
        }
        field(27; "Shipment Method Code"; Code[10])
        {
            Caption = 'Shipment Method Code';
            TableRelation = "Shipment Method";

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
            end;
        }
        field(28; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false));

            trigger OnValidate()
            var
                Loc: Record Location;
            begin
            end;
        }
        field(29; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));
        }
        field(30; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));
        }
        field(31; "Vendor Posting Group"; Code[10])
        {
            Caption = 'Vendor Posting Group';
            Editable = false;
            TableRelation = "Vendor Posting Group";
        }
        field(32; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(33; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;
        }
        field(35; "Prices Including VAT"; Boolean)
        {
            Caption = 'Prices Including VAT';

            trigger OnValidate()
            var
                PurchLine: Record "Purchase Line";
                Currency: Record Currency;
                RecalculatePrice: Boolean;
            begin
            end;
        }
        field(37; "Invoice Disc. Code"; Code[20])
        {
            Caption = 'Invoice Disc. Code';
        }
        field(41; "Language Code"; Code[10])
        {
            Caption = 'Language Code';
            TableRelation = Language;
        }
        field(43; "Purchaser Code"; Code[10])
        {
            Caption = 'Purchaser Code';
            TableRelation = "Salesperson/Purchaser";

            trigger OnValidate()
            var
                ApprovalEntry: Record "Approval Entry";
            begin
            end;
        }
        field(45; "Order Class"; Code[10])
        {
            Caption = 'Order Class';
        }
        field(46; Comment; Boolean)
        {
            CalcFormula = Exist("Purch. Comment Line" WHERE("Document Type" = FIELD("Document Type"),
                                                             "No." = FIELD("No."),
                                                             "Document Line No." = CONST(0)));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(47; "No. Printed"; Integer)
        {
            Caption = 'No. Printed';
            Editable = false;
        }
        field(51; "On Hold"; Code[3])
        {
            Caption = 'On Hold';
        }
        field(52; "Applies-to Doc. Type"; Option)
        {
            Caption = 'Applies-to Doc. Type';
            OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
        }
        field(53; "Applies-to Doc. No."; Code[20])
        {
            Caption = 'Applies-to Doc. No.';
        }
        field(55; "Bal. Account No."; Code[20])
        {
            Caption = 'Bal. Account No.';
            TableRelation = IF ("Bal. Account Type" = CONST("G/L Account")) "G/L Account"
            ELSE IF ("Bal. Account Type" = CONST("Bank Account")) "Bank Account";
        }
        field(56; "Recalculate Invoice Disc."; Boolean)
        {
            CalcFormula = Exist("Purchase Line" WHERE("Document Type" = FIELD("Document Type"),
                                                       "Document No." = FIELD("No."),
                                                       "Recalculate Invoice Disc." = CONST(true)));
            Caption = 'Recalculate Invoice Disc.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(57; Receive; Boolean)
        {
            Caption = 'Receive';
        }
        field(58; Invoice; Boolean)
        {
            Caption = 'Invoice';
        }
        field(59; "Print Posted Documents"; Boolean)
        {
            Caption = 'Print Posted Documents';
        }
        field(60; Amount; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Purchase Line".Amount WHERE("Document Type" = FIELD("Document Type"),
                                                            "Document No." = FIELD("No.")));
            Caption = 'Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(61; "Amount Including VAT"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = Sum("Purchase Line"."Amount Including VAT" WHERE("Document Type" = FIELD("Document Type"),
                                                                            "Document No." = FIELD("No.")));
            Caption = 'Amount Including VAT';
            Editable = false;
            FieldClass = FlowField;
        }
        field(62; "Receiving No."; Code[20])
        {
            Caption = 'Receiving No.';
        }
        field(63; "Posting No."; Code[20])
        {
            Caption = 'Posting No.';
        }
        field(64; "Last Receiving No."; Code[20])
        {
            Caption = 'Last Receiving No.';
            Editable = false;
            TableRelation = "Purch. Rcpt. Header";
        }
        field(65; "Last Posting No."; Code[20])
        {
            Caption = 'Last Posting No.';
            Editable = false;
            TableRelation = "Purch. Inv. Header";
        }
        field(66; "Vendor Order No."; Code[35])
        {
            Caption = 'Vendor Order No.';
        }
        field(67; "Vendor Shipment No."; Code[35])
        {
            Caption = 'Vendor Shipment No.';
        }
        field(68; "Vendor Invoice No."; Code[35])
        {
            Caption = 'Vendor Invoice No.';

            trigger OnValidate()
            begin
                //******************121017
            end;
        }
        field(69; "Vendor Cr. Memo No."; Code[35])
        {
            Caption = 'Vendor Cr. Memo No.';
        }
        field(70; "VAT Registration No."; Text[20])
        {
            Caption = 'VAT Registration No.';
        }
        field(72; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
            TableRelation = Customer;
        }
        field(73; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
        }
        field(74; "Gen. Bus. Posting Group"; Code[10])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";
        }
        field(76; "Transaction Type"; Code[10])
        {
            Caption = 'Transaction Type';
            TableRelation = "Transaction Type";
        }
        field(77; "Transport Method"; Code[10])
        {
            Caption = 'Transport Method';
            TableRelation = "Transport Method";
        }
        field(78; "VAT Country/Region Code"; Code[10])
        {
            Caption = 'VAT Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(79; "Buy-from Vendor Name"; Text[50])
        {
            Caption = 'Buy-from Vendor Name';
        }
        field(80; "Buy-from Vendor Name 2"; Text[50])
        {
            Caption = 'Buy-from Vendor Name 2';
        }
        field(81; "Buy-from Address"; Text[50])
        {
            Caption = 'Buy-from Address';
        }
        field(82; "Buy-from Address 2"; Text[50])
        {
            Caption = 'Buy-from Address 2';
        }
        field(83; "Buy-from City"; Text[30])
        {
            Caption = 'Buy-from City';
            TableRelation = IF ("Buy-from Country/Region Code" = CONST('')) "Post Code".City
            ELSE IF ("Buy-from Country/Region Code" = FILTER(<> '')) "Post Code".City WHERE("Country/Region Code" = FIELD("Buy-from Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                PostCode.ValidateCity(
                  "Buy-from City", "Buy-from Post Code", "Buy-from County", "Buy-from Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(84; "Buy-from Contact"; Text[50])
        {
            Caption = 'Buy-from Contact';
        }
        field(85; "Pay-to Post Code"; Code[20])
        {
            Caption = 'Pay-to Post Code';
            TableRelation = IF ("Pay-to Country/Region Code" = CONST('')) "Post Code"
            ELSE IF ("Pay-to Country/Region Code" = FILTER(<> '')) "Post Code" WHERE("Country/Region Code" = FIELD("Pay-to Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                PostCode.ValidatePostCode(
                  "Pay-to City", "Pay-to Post Code", "Pay-to County", "Pay-to Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(86; "Pay-to County"; Text[30])
        {
            Caption = 'Pay-to County';
        }
        field(87; "Pay-to Country/Region Code"; Code[10])
        {
            Caption = 'Pay-to Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(88; "Buy-from Post Code"; Code[20])
        {
            Caption = 'Buy-from Post Code';
            TableRelation = IF ("Buy-from Country/Region Code" = CONST('')) "Post Code"
            ELSE IF ("Buy-from Country/Region Code" = FILTER(<> '')) "Post Code" WHERE("Country/Region Code" = FIELD("Buy-from Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                PostCode.ValidatePostCode(
                  "Buy-from City", "Buy-from Post Code", "Buy-from County", "Buy-from Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(89; "Buy-from County"; Text[30])
        {
            Caption = 'Buy-from County';
        }
        field(90; "Buy-from Country/Region Code"; Code[10])
        {
            Caption = 'Buy-from Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(91; "Ship-to Post Code"; Code[20])
        {
            Caption = 'Ship-to Post Code';
            TableRelation = IF ("Ship-to Country/Region Code" = CONST('')) "Post Code"
            ELSE IF ("Ship-to Country/Region Code" = FILTER(<> '')) "Post Code" WHERE("Country/Region Code" = FIELD("Ship-to Country/Region Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                PostCode.ValidatePostCode(
                  "Ship-to City", "Ship-to Post Code", "Ship-to County", "Ship-to Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(92; "Ship-to County"; Text[30])
        {
            Caption = 'Ship-to County';
        }
        field(93; "Ship-to Country/Region Code"; Code[10])
        {
            Caption = 'Ship-to Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(94; "Bal. Account Type"; Option)
        {
            Caption = 'Bal. Account Type';
            OptionCaption = 'G/L Account,Bank Account';
            OptionMembers = "G/L Account","Bank Account";
        }
        field(95; "Order Address Code"; Code[10])
        {
            Caption = 'Order Address Code';
            TableRelation = "Order Address".Code WHERE("Vendor No." = FIELD("Buy-from Vendor No."));
        }
        field(97; "Entry Point"; Code[10])
        {
            Caption = 'Entry Point';
            TableRelation = "Entry/Exit Point";
        }
        field(98; Correction; Boolean)
        {
            Caption = 'Correction';
        }
        field(99; "Document Date"; Date)
        {
            Caption = 'Document Date';
        }
        field(101; "Area"; Code[10])
        {
            Caption = 'Area';
            TableRelation = Area;
        }
        field(102; "Transaction Specification"; Code[10])
        {
            Caption = 'Transaction Specification';
            TableRelation = "Transaction Specification";
        }
        field(104; "Payment Method Code"; Code[10])
        {
            Caption = 'Payment Method Code';
            TableRelation = "Payment Method";
        }
        field(107; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(108; "Posting No. Series"; Code[10])
        {
            Caption = 'Posting No. Series';
            TableRelation = "No. Series";
        }
        field(109; "Receiving No. Series"; Code[10])
        {
            Caption = 'Receiving No. Series';
            TableRelation = "No. Series";
        }
        field(114; "Tax Area Code"; Code[20])
        {
            Caption = 'Tax Area Code';
            TableRelation = "Tax Area";
        }
        field(115; "Tax Liable"; Boolean)
        {
            Caption = 'Tax Liable';
        }
        field(116; "VAT Bus. Posting Group"; Code[10])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
        }
        field(118; "Applies-to ID"; Code[50])
        {
            Caption = 'Applies-to ID';

            trigger OnValidate()
            var
                TempVendLedgEntry: Record "Vendor Ledger Entry";
            begin
            end;
        }
        field(119; "VAT Base Discount %"; Decimal)
        {
            Caption = 'VAT Base Discount %';
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;
        }
        field(120; Status; Option)
        {
            Caption = 'Status';
            Editable = false;
            OptionCaption = 'Open,Released,Pending Approval,Pending Prepayment';
            OptionMembers = Open,Released,"Pending Approval","Pending Prepayment";
        }
        field(121; "Invoice Discount Calculation"; Option)
        {
            Caption = 'Invoice Discount Calculation';
            Editable = false;
            OptionCaption = 'None,%,Amount';
            OptionMembers = "None","%",Amount;
        }
        field(122; "Invoice Discount Value"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Invoice Discount Value';
            Editable = false;
        }
        field(123; "Send IC Document"; Boolean)
        {
            Caption = 'Send IC Document';
        }
        field(124; "IC Status"; Option)
        {
            Caption = 'IC Status';
            OptionCaption = 'New,Pending,Sent';
            OptionMembers = New,Pending,Sent;
        }
        field(125; "Buy-from IC Partner Code"; Code[20])
        {
            Caption = 'Buy-from IC Partner Code';
            Editable = false;
            TableRelation = "IC Partner";
        }
        field(126; "Pay-to IC Partner Code"; Code[20])
        {
            Caption = 'Pay-to IC Partner Code';
            Editable = false;
            TableRelation = "IC Partner";
        }
        field(129; "IC Direction"; Option)
        {
            Caption = 'IC Direction';
            OptionCaption = 'Outgoing,Incoming';
            OptionMembers = Outgoing,Incoming;
        }
        field(130; "Prepayment No."; Code[20])
        {
            Caption = 'Prepayment No.';
        }
        field(131; "Last Prepayment No."; Code[20])
        {
            Caption = 'Last Prepayment No.';
            TableRelation = "Purch. Inv. Header";
        }
        field(132; "Prepmt. Cr. Memo No."; Code[20])
        {
            Caption = 'Prepmt. Cr. Memo No.';
        }
        field(133; "Last Prepmt. Cr. Memo No."; Code[20])
        {
            Caption = 'Last Prepmt. Cr. Memo No.';
            TableRelation = "Purch. Cr. Memo Hdr.";
        }
        field(134; "Prepayment %"; Decimal)
        {
            Caption = 'Prepayment %';
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;
        }
        field(135; "Prepayment No. Series"; Code[10])
        {
            Caption = 'Prepayment No. Series';
            TableRelation = "No. Series";
        }
        field(136; "Compress Prepayment"; Boolean)
        {
            Caption = 'Compress Prepayment';
            InitValue = true;
        }
        field(137; "Prepayment Due Date"; Date)
        {
            Caption = 'Prepayment Due Date';
        }
        field(138; "Prepmt. Cr. Memo No. Series"; Code[10])
        {
            Caption = 'Prepmt. Cr. Memo No. Series';
            TableRelation = "No. Series";
        }
        field(139; "Prepmt. Posting Description"; Text[50])
        {
            Caption = 'Prepmt. Posting Description';
        }
        field(142; "Prepmt. Pmt. Discount Date"; Date)
        {
            Caption = 'Prepmt. Pmt. Discount Date';
        }
        field(143; "Prepmt. Payment Terms Code"; Code[10])
        {
            Caption = 'Prepmt. Payment Terms Code';
            TableRelation = "Payment Terms";

            trigger OnValidate()
            var
                PaymentTerms: Record "Payment Terms";
            begin
            end;
        }
        field(144; "Prepmt. Payment Discount %"; Decimal)
        {
            Caption = 'Prepmt. Payment Discount %';
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;
        }
        field(151; "Quote No."; Code[20])
        {
            Caption = 'Quote No.';
            Editable = false;
        }
        field(160; "Job Queue Status"; Option)
        {
            Caption = 'Job Queue Status';
            Editable = false;
            OptionCaption = ' ,Scheduled for Posting,Error,Posting';
            OptionMembers = " ","Scheduled for Posting",Error,Posting;

            trigger OnLookup()
            var
                JobQueueEntry: Record "Job Queue Entry";
            begin
            end;
        }
        field(161; "Job Queue Entry ID"; Guid)
        {
            Caption = 'Job Queue Entry ID';
            Editable = false;
        }
        field(165; "Incoming Document Entry No."; Integer)
        {
            Caption = 'Incoming Document Entry No.';
            TableRelation = "Incoming Document";

            trigger OnValidate()
            var
                IncomingDocument: Record "Incoming Document";
            begin
            end;
        }
        field(170; "Creditor No."; Code[20])
        {
            Caption = 'Creditor No.';
            Numeric = true;
        }
        field(171; "Payment Reference"; Code[50])
        {
            Caption = 'Payment Reference';
            Numeric = true;
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";
        }
        field(1305; "Invoice Discount Amount"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("Purchase Line"."Inv. Discount Amount" WHERE("Document No." = FIELD("No."),
                                                                            "Document Type" = FIELD("Document Type")));
            Caption = 'Invoice Discount Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5043; "No. of Archived Versions"; Integer)
        {
            CalcFormula = Max("Purchase Header Archive"."Version No." WHERE("Document Type" = FIELD("Document Type"),
                                                                             "No." = FIELD("No."),
                                                                             "Doc. No. Occurrence" = FIELD("Doc. No. Occurrence")));
            Caption = 'No. of Archived Versions';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5048; "Doc. No. Occurrence"; Integer)
        {
            Caption = 'Doc. No. Occurrence';
        }
        field(5050; "Campaign No."; Code[20])
        {
            Caption = 'Campaign No.';
            TableRelation = Campaign;
        }
        field(5052; "Buy-from Contact No."; Code[20])
        {
            Caption = 'Buy-from Contact No.';
            TableRelation = Contact;

            trigger OnLookup()
            var
                Cont: Record Contact;
                ContBusinessRelation: Record "Contact Business Relation";
            begin
            end;

            trigger OnValidate()
            var
                ContBusinessRelation: Record "Contact Business Relation";
                Cont: Record Contact;
            begin
            end;
        }
        field(5053; "Pay-to Contact No."; Code[20])
        {
            Caption = 'Pay-to Contact No.';
            TableRelation = Contact;

            trigger OnLookup()
            var
                Cont: Record Contact;
                ContBusinessRelation: Record "Contact Business Relation";
            begin
            end;

            trigger OnValidate()
            var
                ContBusinessRelation: Record "Contact Business Relation";
                Cont: Record Contact;
            begin
            end;
        }
        field(5700; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";
        }
        field(5752; "Completely Received"; Boolean)
        {
            CalcFormula = Min("Purchase Line"."Completely Received" WHERE("Document Type" = FIELD("Document Type"),
                                                                           "Document No." = FIELD("No."),
                                                                           Type = FILTER(<> " "),
                                                                           "Location Code" = FIELD("Location Filter")));
            Caption = 'Completely Received';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5753; "Posting from Whse. Ref."; Integer)
        {
            AccessByPermission = TableData Location = R;
            Caption = 'Posting from Whse. Ref.';
        }
        field(5754; "Location Filter"; Code[10])
        {
            Caption = 'Location Filter';
            FieldClass = FlowFilter;
            TableRelation = Location;
        }
        field(5790; "Requested Receipt Date"; Date)
        {
            AccessByPermission = TableData "Order Promising Line" = R;
            Caption = 'Requested Receipt Date';
        }
        field(5791; "Promised Receipt Date"; Date)
        {
            Caption = 'Promised Receipt Date';
        }
        field(5792; "Lead Time Calculation"; DateFormula)
        {
            AccessByPermission = TableData "Purch. Rcpt. Header" = R;
            Caption = 'Lead Time Calculation';
        }
        field(5793; "Inbound Whse. Handling Time"; DateFormula)
        {
            AccessByPermission = TableData Location = R;
            Caption = 'Inbound Whse. Handling Time';
        }
        field(5796; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(5800; "Vendor Authorization No."; Code[35])
        {
            Caption = 'Vendor Authorization No.';
        }
        field(5801; "Return Shipment No."; Code[20])
        {
            Caption = 'Return Shipment No.';
        }
        field(5802; "Return Shipment No. Series"; Code[10])
        {
            Caption = 'Return Shipment No. Series';
            TableRelation = "No. Series";
        }
        field(5803; Ship; Boolean)
        {
            Caption = 'Ship';
        }
        field(5804; "Last Return Shipment No."; Code[20])
        {
            Caption = 'Last Return Shipment No.';
            Editable = false;
            TableRelation = "Return Shipment Header";
        }
        field(9000; "Assigned User ID"; Code[50])
        {
            Caption = 'Assigned User ID';
            TableRelation = "User Setup";
        }
        field(9001; "Pending Approvals"; Integer)
        {
            CalcFormula = Count("Approval Entry" WHERE("Table ID" = CONST(38),
                                                        "Document Type" = FIELD("Document Type"),
                                                        "Document No." = FIELD("No."),
                                                        Status = FILTER(Open | Created)));
            Caption = 'Pending Approvals';
            FieldClass = FlowField;
        }
        field(50001; "Created By Doc No."; Code[20])
        {
            Caption = 'Created By Doc No.';
            Editable = false;
        }
        field(50002; "Created By Doc Type"; Option)
        {
            Caption = 'Created By Doc Type';
            OptionCaption = ' ,Exchange,Loan,Borrow,Consignation,ProvisionsFA';
            OptionMembers = " ",Exchange,Loan,Borrow,Consignation,ProvisionsFA;
        }
        field(50010; DelaiDeLivraison; Text[50])
        {
            Caption = 'Delivery Terms';
        }
        field(50020; "Code Demande"; Code[20])
        {
            Caption = 'Purchase Requiqition Code';
            Editable = false;
        }
        field(50021; "Code Budget"; Code[10])
        {
            Editable = false;
            TableRelation = "G/L Budget Name";
        }
        field(50022; "Purchase Type"; Option)
        {
            Caption = 'Purchase Type';
            Editable = false;
            ExtendedDatatype = Masked;
            OptionCaption = 'Purchase of goods,Others purchases';
            OptionMembers = AchatMarchandise,AchatAutre;
        }
        field(50023; "Validity Offer"; Text[30])
        {
            Caption = 'Validity of Offer';
        }
        field(50024; "PR Type"; Option)
        {
            Caption = 'Purch Req Type';
            OptionCaption = ' ,DOP Travaux,DOP Maintenance,DOP Supply,DOP Logistique,HSE,DCM,IT,SGX,SGX Service,RH,DG,Reseau,Energie,Travaux&Maintenance,Comptabilite,Agence,B2B,DSP,CAP,RSE';
            OptionMembers = " ","DOP Travaux","DOP Maintenance","DOP Supply","DOP Logistique",HSE,DCM,IT,SGX,"SGX Service",RH,DG,Reseau,Energie,"Travaux&Maintenance",Comptabilite,Agence,B2B,DSP,CAP,RSE;
        }
        field(50025; "PO Type"; Option)
        {
            Caption = 'Purch Order Type';
            OptionCaption = ' ,Achats,SGX Services,RH,DG';
            OptionMembers = " ",Achats,"SGX Services",RH,DG;
        }
        field(50050; ProvisionValide; Boolean)
        {
            Caption = 'Provision charge item generated';
            Editable = false;
        }
        field(50055; "Ref Cargo"; Code[20])
        {
            Caption = 'Cargo';
            TableRelation = Cargo WHERE(Closed = CONST(false));

            trigger OnValidate()
            var
                Cargo1: Record Cargo;
            begin
            end;
        }
        field(50056; "Vendor Retention Posting Group"; Code[10])
        {
            Caption = 'Source retention Group';
            TableRelation = "Vendor Posting Group";

            trigger OnLookup()
            var
                VendPostingGroup: Record "Vendor Posting Group";
            begin
            end;
        }
        field(50060; "User ID"; Code[50])
        {
            Caption = 'User ID';
            Editable = false;
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;

            trigger OnLookup()
            var
                UserMgt: Codeunit "User Management";
            begin
                //UserMgt.LookupUserID("User ID");
            end;
        }
        field(50061; "Processing Status"; Option)
        {
            Caption = 'Processing Status';
            OptionCaption = ' ,Soldee';
            OptionMembers = " ",Soldee;
        }
        field(50062; "Offer Prepayment %"; Decimal)
        {
            Caption = 'Offer Prepayment %';
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;
        }
        field(50063; Observations; Text[150])
        {
            Caption = 'Description';
        }
        field(50064; ProvisionValideVarStock; Boolean)
        {
            Caption = 'Provision inventory generated';
            Editable = false;
        }
        field(50065; Anticipated; Boolean)
        {
            Caption = 'Anticipated';
        }
        field(50066; Printed; Boolean)
        {
            Caption = 'Printed';
            Editable = false;
        }
        field(50067; "Printed Date"; Date)
        {
            Caption = 'Printed Date';
            Editable = false;
        }
        field(50068; "Printed By"; Code[50])
        {
            Caption = 'Printed By';
            Editable = false;
        }
        field(50069; "Ref Dossier Cargo"; Code[30])
        {
            Caption = 'Ref. Dossier (Cargo)';
        }
        field(50070; "MFiles Invoice"; Boolean)
        {
        }
        field(50071; MFilesURL; Text[100])
        {
            Caption = 'URL';
            Editable = false;
            ExtendedDatatype = URL;
        }
        field(60000; "Partially Received"; Boolean)
        {
            CalcFormula = Max("Purchase Line"."Partially Received" WHERE("Document Type" = FIELD("Document Type"),
                                                                          "Document No." = FIELD("No."),
                                                                          Type = FILTER(<> " "),
                                                                          "Location Code" = FIELD("Location Filter")));
            Caption = 'Partially Received';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Document Type", "No.")
        {
        }
        key(Key2; "No.", "Document Type")
        {
        }
        key(Key3; "Document Type", "Buy-from Vendor No.")
        {
        }
        key(Key4; "Document Type", "Pay-to Vendor No.")
        {
        }
        key(Key5; "Buy-from Vendor No.")
        {
        }
        key(Key6; "Incoming Document Entry No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        BudgetLineP: Record "Purchase Budget Line";
    begin
    end;

    trigger OnRename()
    begin
        Error(Text003, TableCaption);
    end;

    var
        Text000: Label 'Do you want to print receipt %1?';
        Text001: Label 'Do you want to print invoice %1?';
        Text002: Label 'Do you want to print credit memo %1?';
        Text003: Label 'You cannot rename a %1.';
        Text004: Label 'Do you want to change %1?';
        Text005: Label 'You cannot reset %1 because the document still has one or more lines.';
        Text006: Label 'You cannot change %1 because the order is associated with one or more sales orders.';
        Text007: Label '%1 is greater than %2 in the %3 table.\';
        Text008: Label 'Confirm change?';
        Text009: Label 'Deleting this document will cause a gap in the number series for receipts. ';
        Text010: Label 'An empty receipt %1 will be created to fill this gap in the number series.\\';
        Text011: Label 'Do you want to continue?';
        Text012: Label 'Deleting this document will cause a gap in the number series for posted invoices. ';
        Text013: Label 'An empty posted invoice %1 will be created to fill this gap in the number series.\\';
        Text014: Label 'Deleting this document will cause a gap in the number series for posted credit memos. ';
        Text015: Label 'An empty posted credit memo %1 will be created to fill this gap in the number series.\\';
        Text016: Label 'If you change %1, the existing purchase lines will be deleted and new purchase lines based on the new information in the header will be created.\\';
        Text018: Label 'You must delete the existing purchase lines before you can change %1.';
        Text019: Label 'You have changed %1 on the purchase header, but it has not been changed on the existing purchase lines.\';
        Text020: Label 'You must update the existing purchase lines manually.';
        Text021: Label 'The change may affect the exchange rate used on the price calculation of the purchase lines.';
        Text022: Label 'Do you want to update the exchange rate?';
        Text023: Label 'You cannot delete this document. Your identification is set up to process from %1 %2 only.';
        Text024: Label 'Do you want to print return shipment %1?';
        Text025: Label 'You have modified the %1 field. Note that the recalculation of VAT may cause penny differences, so you must check the amounts afterwards. ';
        Text027: Label 'Do you want to update the %2 field on the lines to reflect the new value of %1?';
        Text028: Label 'Your identification is set up to process from %1 %2 only.';
        Text029: Label 'Deleting this document will cause a gap in the number series for return shipments. ';
        Text030: Label 'An empty return shipment %1 will be created to fill this gap in the number series.\\';
        Text032: Label 'You have modified %1.\\';
        Text033: Label 'Do you want to update the lines?';
        PurchSetup: Record "Purchases & Payables Setup";
        GLSetup: Record "General Ledger Setup";
        GLAcc: Record "G/L Account";
        PurchLine: Record "Purchase Line";
        xPurchLine: Record "Purchase Line";
        VendLedgEntry: Record "Vendor Ledger Entry";
        Vend: Record Vendor;
        PaymentTerms: Record "Payment Terms";
        PaymentMethod: Record "Payment Method";
        CurrExchRate: Record "Currency Exchange Rate";
        PurchHeader: Record "Purchase Header";
        PurchCommentLine: Record "Purch. Comment Line";
        ShipToAddr: Record "Ship-to Address";
        Cust: Record Customer;
        CompanyInfo: Record "Company Information";
        PostCode: Record "Post Code";
        OrderAddr: Record "Order Address";
        BankAcc: Record "Bank Account";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchCrMemoHeader: Record "Purch. Cr. Memo Hdr.";
        ReturnShptHeader: Record "Return Shipment Header";
        PurchInvHeaderPrepmt: Record "Purch. Inv. Header";
        PurchCrMemoHeaderPrepmt: Record "Purch. Cr. Memo Hdr.";
        GenBusPostingGrp: Record "Gen. Business Posting Group";
        GenJnILine: Record "Gen. Journal Line";
        RespCenter: Record "Responsibility Center";
        Location: Record Location;
        WhseRequest: Record "Warehouse Request";
        InvtSetup: Record "Inventory Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        TransferExtendedText: Codeunit "Transfer Extended Text";
        GenJnlApply: Codeunit "Gen. Jnl.-Apply";
        PurchPost: Codeunit "Purch.-Post";
        VendEntrySetApplID: Codeunit "Vend. Entry-SetAppl.ID";
        DimMgt: Codeunit DimensionManagement;
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        UserSetupMgt: Codeunit "User Setup Management";
        ArchiveManagement: Codeunit ArchiveManagement;
        ApplyVendEntries: Page "Apply Vendor Entries";
        CurrencyDate: Date;
        HideValidationDialog: Boolean;
        Confirmed: Boolean;
        Text034: Label 'You cannot change the %1 when the %2 has been filled in.';
        Text037: Label 'Contact %1 %2 is not related to vendor %3.';
        Text038: Label 'Contact %1 %2 is related to a different company than vendor %3.';
        Text039: Label 'Contact %1 %2 is not related to a vendor.';
        SkipBuyFromContact: Boolean;
        SkipPayToContact: Boolean;
        Text040: Label 'You can not change the %1 field because %2 %3 has %4 = %5 and the %6 has already been assigned %7 %8.';
        Text041: Label 'The purchase %1 %2 has item tracking. Do you want to delete it anyway?';
        Text042: Label 'You must cancel the approval process if you wish to change the %1.';
        Text043: Label 'Do you want to print prepayment invoice %1?';
        Text044: Label 'Do you want to print prepayment credit memo %1?';
        Text045: Label 'Deleting this document will cause a gap in the number series for prepayment invoices. An empty prepayment invoice %1 will be created to fill this gap in the number series.\\Do you want to continue?';
        Text046: Label 'Deleting this document will cause a gap in the number series for prepayment credit memos. An empty prepayment credit memo %1 will be created to fill this gap in the number series.\\Do you want to continue?';
        Text049: Label '%1 is set up to process from %2 %3 only.';
        Text050: Label 'Reservations exist for this order. These reservations will be canceled if a date conflict is caused by this change.\\';
        Text051: Label 'You may have changed a dimension.\\Do you want to update the lines?';
        Text052: Label 'The %1 field on the purchase order %2 must be the same as on sales order %3.';
        NameAddressDetails: Text[512];
        DropShptNameAddressDetails: Text[512];
        SpecOrderNameAddressDetails: Text[512];
        UpdateDocumentDate: Boolean;
        Text053: Label 'There are unposted prepayment amounts on the document of type %1 with the number %2.';
        Text054: Label 'There are unpaid prepayment invoices that are related to the document of type %1 with the number %2.';
        ChangeCurrencyQst: Label 'If you change %1, the existing purchase lines will be deleted and new purchase lines based on the new information in the header will be created. You may need to update the price information manually.\\Do you want to change %1?';
        //ServRequisitionMgt: Codeunit "Purchase Requisition Mgt";
        TextErr01: Label 'Ce fournisseur a été blacklisté';
        AddOnSetup: Record "AddOn Setup";
        AFK_Text0001: Label 'Cette facture ne peut pas être modifiée car elle provient d''un document MFiles';
}

