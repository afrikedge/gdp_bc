table 50055 "Purchase Requisition Line"
{
    Caption = 'Service requisition line';

    fields
    {
        field(1; "Document No"; Code[20])
        {
            Caption = 'Document No';
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line N°';
        }
        field(3; Type; Option)
        {
            Caption = 'Type';
            Editable = true;
            OptionCaption = ' ,Item,G/L Account,Fixed asset,Item Charge';
            OptionMembers = " ",Item,"G/L Account","Fixed Asset","Item Charge";

            trigger OnValidate()
            begin
                if Type <> xRec.Type then
                    "No." := '';
            end;
        }
        field(4; "No."; Code[20])
        {
            Caption = 'No.';
            Editable = true;
            TableRelation = IF (Type = CONST(Item)) Item
            ELSE IF (Type = CONST("G/L Account")) "G/L Account" WHERE("Purchased Account" = CONST(true))
            ELSE IF (Type = CONST("Fixed Asset")) "Fixed Asset"
            ELSE IF (Type = CONST("Item Charge")) "Item Charge";

            trigger OnValidate()
            var
                ICPartner: Record "IC Partner";
            //ItemCrossReference: Record "Item Cross Reference";
            begin
                GLSetup.Get;

                //TestStatusOpen;

                case Type of
                    Type::Item:
                        begin
                            Item.Get("No.");
                            Item.TestField(Blocked, false);
                            if Item.Type = Item.Type::Inventory then
                                Item.TestField("Inventory Posting Group");
                            Item.TestField("Gen. Prod. Posting Group");

                            //*********************
                            //Item.TESTFIELD(Item."Statut validation",Item."Statut validation"::Validé);
                            //*********************

                            CreateDim(
                              DATABASE::Item, "No.",
                              DATABASE::Job, '',
                              DATABASE::"Responsibility Center", '');


                            Description := Item.Description;
                            "Description article" := Item.Description;
                            "Gen. Prod. Posting Group" := Item."Gen. Prod. Posting Group";
                            "VAT Prod. Posting Group" := Item."VAT Prod. Posting Group";
                            Item.TestField("Base Unit of Measure");
                            Validate("Unit Code", Item."Base Unit of Measure");

                            "Unit Price" := Item."Last Direct Cost";
                            //Item.TESTFIELD("Poste Budgétaire");
                            //IF Item."Code Nature"<>'' THEN
                            //   VALIDATE("Nature code",Item."Code Nature");


                        end;
                    Type::"G/L Account":
                        begin
                            GLAcc.Get("No.");
                            GLAcc.TestField(GLAcc.Blocked, false);
                            GLAcc.TestField("Direct Posting", true);

                            //Serv.GET("No.");
                            GLAcc.TestField("Gen. Prod. Posting Group");
                            if Description = '' then
                                Description := GLAcc.Name;
                            "Description article" := GLAcc.Name;
                            CreateDim(
                              DATABASE::"G/L Account", "No.",
                              DATABASE::Job, '',
                              DATABASE::"Responsibility Center", '');

                            "Gen. Prod. Posting Group" := GLAcc."Gen. Prod. Posting Group";
                            "VAT Prod. Posting Group" := GLAcc."VAT Prod. Posting Group";
                            "Qty. per Unit of Measure" := 1;
                            //Serv.TESTFIELD("Poste Budgétaire");
                            //IF GLAcc."Nature Code"<>'' THEN
                            //   VALIDATE("Nature Code",GLAcc."Code Nature");
                        end;

                    Type::"Item Charge":
                        begin
                            ItemCharge.Get("No.");
                            ItemCharge.TestField("Gen. Prod. Posting Group");
                            Description := ItemCharge.Description;
                            "Description article" := ItemCharge.Description;
                            CreateDim(
                              DATABASE::"Item Charge", "No.",
                              DATABASE::Job, '',
                              DATABASE::"Responsibility Center", '');

                            "Gen. Prod. Posting Group" := ItemCharge."Gen. Prod. Posting Group";
                            "VAT Prod. Posting Group" := ItemCharge."VAT Prod. Posting Group";
                            "Qty. per Unit of Measure" := 1;
                            //"Prix Unitaire" := ItemCharge."Prix unitaire";

                            //ItemCharge.TESTFIELD("Poste Budgétaire");
                            //IF ItemCharge."Poste Budgétaire"<>'' THEN
                            //   VALIDATE("Code Section 3",ItemCharge."Poste Budgétaire");
                        end;


                    Type::"Fixed Asset":
                        begin
                            FA.Get("No.");
                            FA.TestField(Inactive, false);
                            FA.TestField(Blocked, false);
                            GetFAPostingGroup;

                            CreateDim(
                              DATABASE::"Fixed Asset", "No.",
                              DATABASE::Job, '',
                              DATABASE::"Responsibility Center", '');

                            Description := FA.Description;
                            "Description article" := FA.Description;
                            "Qty. per Unit of Measure" := 1;
                            //      "Gen. Prod. Posting Group" := ;
                            //      "VAT Prod. Posting Group" := Serv."VAT Prod. Posting Group";
                            //IF FA."Code Nature"<>'' THEN
                            //   VALIDATE("Code Nature",FA."Code Nature");

                        end;
                end;


                ServRequest.Get("Document No");
                Validate("Gen. Bus. Posting Group", ServRequest."Gen. Bus. Posting Group");
                Validate("VAT Bus. Posting Group", ServRequest."VAT Bus. Posting Group");


                //*************************************************
                //Budget Mgt***************************************
                //TODO Migration
                "Purchase Account" := BudgetMgt.GetPurchAccFromReq(Rec, ServRequest);
                //*************************************************Jn0001
            end;
        }
        field(5; Description; Text[50])
        {
            Caption = 'Description';
            Editable = true;
        }
        field(6; "Unit Code"; Code[10])
        {
            Caption = 'Unit Code';
            TableRelation = IF (Type = CONST(Item)) "Item Unit of Measure".Code WHERE("Item No." = FIELD("No."))
            ELSE
            "Unit of Measure";

            trigger OnValidate()
            begin

                /*
                CASE Type OF
                  Type::" ":
                    BEGIN
                    IF "Unit Code" <> '' THEN BEGIN
                      ItemUnitofMeasure.GET("No.","Unit Code");
                      "Qty. per Unit of Measure" := ItemUnitofMeasure."Qty. per Unit of Measure";
                
                     END ELSE BEGIN
                        "Qty. per Unit of Measure" := 1;
                      END;
                
                    END;
                  Type::Item,Type::"G/L Account",Type::"Fixed Asset":
                       "Qty. per Unit of Measure" := 1;
                END;
                */

                if Type <> Rec.Type::" " then begin
                    GetItem;
                    "Qty. per Unit of Measure" := UOMMgt.GetQtyPerUnitOfMeasure(Item, Rec."Unit Code");
                    Validate(Quantity);
                end;

            end;
        }
        field(7; Quantity; Decimal)
        {
            Caption = 'Quantity';

            trigger OnValidate()
            begin
                if Quantity <> xRec.Quantity then begin
                    GetPurchHeader;
                    if ServRequest.Status = ServRequest.Status::Validated then
                        Error(Text001);
                end;


                Amount := Round(Quantity * "Unit Price", 0.00001);
                "Amount Incl VAT" := Amount + "VAT Amount";
                Validate("VAT %");

                if Type = Type::Item then
                    "Quantity (Base)" := CalcBaseQty(Quantity)
                else
                    "Quantity (Base)" := (Quantity);

                "Remaining Quantity (Base)" := "Quantity (Base)" - "Ordered Quantity (Base)";
            end;
        }
        field(8; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';

            trigger OnValidate()
            begin

                Validate(Quantity);
            end;
        }
        field(9; "Gen. Bus. Posting Group"; Code[10])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";

            trigger OnValidate()
            begin

                /*
                IF xRec."Gen. Bus. Posting Group" <> "Gen. Bus. Posting Group" THEN
                  IF GenBusPostingGrp.ValidateVatBusPostingGroup(GenBusPostingGrp,"Gen. Bus. Posting Group") THEN
                    VALIDATE("VAT Bus. Posting Group",GenBusPostingGrp."Def. VAT Bus. Posting Group");
                */

            end;
        }
        field(10; "Gen. Prod. Posting Group"; Code[10])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";

            trigger OnValidate()
            begin
                /*
                TestStatusOpen;
                
                
                IF xRec."Gen. Prod. Posting Group" <> "Gen. Prod. Posting Group" THEN
                  IF GenProdPostingGrp.ValidateVatProdPostingGroup(GenProdPostingGrp,"Gen. Prod. Posting Group") THEN
                    VALIDATE("VAT Prod. Posting Group",GenProdPostingGrp."Def. VAT Prod. Posting Group");
                */

            end;
        }
        field(11; Amount; Decimal)
        {
            Caption = 'Amount';
            Editable = false;
        }
        field(13; "Amount Incl VAT"; Decimal)
        {
            Caption = 'Amount Incl VAT';
            Editable = false;
        }
        field(14; "VAT %"; Decimal)
        {
            Caption = 'TVA %';
            DecimalPlaces = 0 : 5;
            Editable = true;
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate()
            begin
                /*
                ServRequest.GET("Document No");
                //IF SCHeader.Statut>SCHeader.Statut::"Attente Val Ctrl gestion" THEN
                //   SCHeader.FIELDERROR(Statut);
                
                GetCurrency;
                
                "VAT Amount" := ROUND((Amount*"VAT %"/100),Currency."Amount Rounding Precision");
                "Amount Incl VAT" :=Amount + "VAT Amount";
                */
                //"VAT Base Amount" := ROUND(Amount / (1 + "VAT %" / 100),Currency."Amount Rounding Precision");
                //"VAT Amount" := ROUND(Amount - "VAT Base Amount",Currency."Amount Rounding Precision",Currency.VATRoundingDirection);

            end;
        }
        field(15; "VAT Amount"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'TVA Amount';
            Editable = false;
        }
        field(16; "VAT Bus. Posting Group"; Code[10])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";

            trigger OnValidate()
            begin

                //VALIDATE("VAT Prod. Posting Group");
            end;
        }
        field(17; "VAT Prod. Posting Group"; Code[10])
        {
            Caption = 'VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group";

            trigger OnValidate()
            begin

                /*
                VATPostingSetup.GET("VAT Bus. Posting Group","VAT Prod. Posting Group");
                "VAT %" := VATPostingSetup."VAT %";
                VALIDATE("VAT %");
                */

            end;
        }
        field(18; "Vendor Code"; Code[10])
        {
            Caption = 'Vendor Code';
            TableRelation = Vendor;
        }
        field(19; "Quantity (Base)"; Decimal)
        {
            Caption = 'Quantity (Base)';
            Editable = false;
        }
        field(20; "Qty. per Unit of Measure"; Decimal)
        {
            Caption = 'Qty. per Unit of Measure';
            Editable = true;
        }
        field(21; "Posting Group"; Code[10])
        {
            Caption = 'Posting Group';
        }
        field(22; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = IF (Type = CONST(Item)) "Item Variant".Code WHERE("Item No." = FIELD("No."));

            trigger OnValidate()
            begin



                if "Variant Code" <> '' then
                    TestField(Type, Type::" ");

                ItemVariant.Get("No.", "Variant Code");
                Description := ItemVariant.Description;

                /*
                TestStatusOpen;
                
                IF xRec."Variant Code" <> "Variant Code" THEN BEGIN
                  TESTFIELD("Qty. Rcd. Not Invoiced",0);
                  TESTFIELD("Receipt No.",'');
                
                  TESTFIELD("Return Qty. Shipped Not Invd.",0);
                  TESTFIELD("Return Shipment No.",'');
                END;
                
                IF "Drop Shipment" THEN
                  ERROR(
                    Text001,
                    FIELDCAPTION("Variant Code"),"Sales Order No.");
                
                IF Type = Type::Item THEN
                  UpdateDirectUnitCost(FIELDNO("Variant Code"));
                
                IF (xRec."Variant Code" <> "Variant Code") AND (Quantity <> 0) THEN BEGIN
                  ReservePurchLine.VerifyChange(Rec,xRec);
                  WhseValidateSourceLine.PurchaseLineVerifyChange(Rec,xRec);
                END;
                UpdateLeadTimeFields;
                UpdateDates;
                
                GetDefaultBin;
                
                IF "Variant Code" = '' THEN BEGIN
                  IF Type = Type::Item THEN BEGIN
                    Item.GET("No.");
                    Description := Item.Description;
                    "Description 2" := Item."Description 2";
                    DistIntegration.EnterPurchaseItemCrossRef(Rec);
                    GetItemTranslation;
                  END;
                  EXIT;
                END;
                
                ItemVariant.GET("No.","Variant Code");
                Description := ItemVariant.Description;
                "Description 2" := ItemVariant."Description 2";
                
                DistIntegration.EnterPurchaseItemCrossRef(Rec);
                GetPurchHeader;
                IF PurchHeader."Language Code" <> '' THEN
                  GetItemTranslation;
                */

            end;
        }
        field(23; "Project Code"; Code[20])
        {
            Caption = 'Project Code';
            Description = 'Axe Sections budgétaires (Code Axe 5)';
            TableRelation = Dimension;
        }
        field(24; "Nature code"; Code[20])
        {
            Caption = 'Nature code';
            Description = 'Sections budgétaires';
            Editable = true;
        }
        field(25; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location WHERE("Use As In-Transit" = CONST(false),
                                            "Transfer Item Transit" = CONST(false));
        }
        field(28; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            end;
        }
        field(29; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
        }
        field(30; "Type document"; Option)
        {
            OptionCaption = 'Service Request';
            OptionMembers = "Service Request";
        }
        field(31; "Ordered Quantity (Base)"; Decimal)
        {
            Caption = 'Ordered Quantity';
            Editable = false;
        }
        field(32; "Remaining Quantity (Base)"; Decimal)
        {
            Caption = 'Remaining Quantity (Base)';
            Editable = false;
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDimensions;
            end;
        }
        field(5602; "Depreciation Book Code"; Code[10])
        {
            Caption = 'Depreciation Book Code';
            TableRelation = "Depreciation Book";

            trigger OnValidate()
            begin
                //GetFAPostingGroup;
            end;
        }
        field(50000; "Serial No."; Code[30])
        {
            Caption = 'Serial No.';
            Editable = true;
        }
        field(50001; "Item Ref"; Code[30])
        {
            Caption = 'Item Ref';
            Editable = true;
        }
        field(50010; "Purchase Account"; Code[20])
        {
            Caption = 'Charge Account';
            Editable = false;
        }
        field(70000; "Description article"; Text[50])
        {
            Caption = 'Item Initial Description';
            Editable = false;
        }
        field(70001; "Afk Budget Key"; Text[40])
        {
        }
    }

    keys
    {
        key(Key1; "Document No", "Line No.")
        {
        }
        key(Key2; "Purchase Account", "Shortcut Dimension 1 Code")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        TestStatusOpen;
    end;

    var
        GLAcc: Record "G/L Account";
        Item: Record Item;
        Res: Record Resource;
        ItemCharge: Record "Item Charge";
        FA: Record "Fixed Asset";
        ResUnitofMeasure: Record "Resource Unit of Measure";
        ItemUnitofMeasure: Record "Item Unit of Measure";
        ItemVariant: Record "Item Variant";
        Currency: Record Currency;
        ServRequest: Record "Purchase Requisition";
        VATPostingSetup: Record "VAT Posting Setup";
        FADeprBook: Record "FA Depreciation Book";
        LocalGLAcc: Record "G/L Account";
        FASetup: Record "FA Setup";
        GLSetup: Record "General Ledger Setup";
        DimMgt: Codeunit DimensionManagement;
        proSetup: Record "AddOn Setup";
        UOMMgt: Codeunit "Unit of Measure Management";
        BudgetMgt: Codeunit "Purchase Requisition Mgt";
        Text001: Label 'La demande ne peut plus être modifiée car elle a déjà été validée';

    local procedure CalcBaseQty(Qty: Decimal): Decimal
    begin
        TestField("Qty. per Unit of Measure");
        exit(Round(Qty * "Qty. per Unit of Measure", 0.00001));
    end;

    procedure GetCurrency()
    begin
        //ServRequest.GET("Document No");
        //ServRequest.TESTFIELD(ServRequest."Currency Code");
        //Currency.GET(ServRequest."Currency Code");
    end;

    procedure proShowDims(Edit: Boolean)
    begin

        //EngDocDim.SETRANGE("Table ID",DATABASE::"Ligne demande pieces de caisse");
        //EngDocDim.SETRANGE("Document Type",EngDocDim."Document Type"::Quote);
        //EngDocDim.SETRANGE("Document No.","No Demande");
        //EngDocDim.SETRANGE("Line No.","Line No.");

        //FeuilleEngDoc.EDITABLE := Edit;
        //FeuilleEngDoc.SETTABLEVIEW(EngDocDim);
        //FeuilleEngDoc.RUNMODAL;
    end;

    local procedure GetFAPostingGroup()
    var
        LocalGLAcc: Record "G/L Account";
        FAPostingGr: Record "FA Posting Group";
    begin
        if (Type <> Type::"G/L Account") or ("No." = '') then
            exit;

        //MESSAGE('1 %1',"Depreciation Book Code");

        if "Depreciation Book Code" = '' then begin
            FASetup.Get;
            "Depreciation Book Code" := FASetup."Default Depr. Book";
            Message('2 %1', "Depreciation Book Code");
            if not FADeprBook.Get("No.", "Depreciation Book Code") then
                "Depreciation Book Code" := '';
            if "Depreciation Book Code" = '' then
                exit;
        end;

        //MESSAGE('3 %1',"Depreciation Book Code");
        FADeprBook.Get("No.", "Depreciation Book Code");
        FADeprBook.TestField("FA Posting Group");
        FAPostingGr.Get(FADeprBook."FA Posting Group");

        FAPostingGr.TestField("Acquisition Cost Account");
        LocalGLAcc.Get(FAPostingGr."Acquisition Cost Account");

        LocalGLAcc.CheckGLAcc;
        LocalGLAcc.TestField("Gen. Prod. Posting Group");

        "Posting Group" := FADeprBook."FA Posting Group";
        "Gen. Prod. Posting Group" := LocalGLAcc."Gen. Prod. Posting Group";
        Validate("VAT Prod. Posting Group", LocalGLAcc."VAT Prod. Posting Group");
    end;

    procedure ShowBudgetStatus()
    var
        CompteGene: Code[20];
    begin

        //CompteGene := BudgetMgt.GetCompteAchatPieceCaisse(Rec);
        //IF CompteGene='' THEN EXIT;
        //
        //SCHeader.GET("Type document","No Demande");
        //BudgetMgt.ShowBudgetStatus(CompteGene,"Code Section 3",SCHeader."Posting Date",
        //   Montant);
    end;

    procedure ShowDimensions()
    begin
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet("Dimension Set ID", StrSubstNo('%1 %2 %3', '', "Document No", "Line No."));
        //VerifyItemLineDim;
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;

    procedure CreateDim(Type1: Integer; No1: Code[20]; Type2: Integer; No2: Code[20]; Type3: Integer; No3: Code[20])
    var
        SourceCodeSetup: Record "Source Code Setup";
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
    begin
        //TODO Migration
        // SourceCodeSetup.Get;
        // TableID[1] := Type1;
        // No[1] := No1;
        // TableID[2] := Type2;
        // No[2] := No2;
        // TableID[3] := Type3;
        // No[3] := No3;
        // //TableID[4] := Type4;
        // //No[4] := No4;
        // "Shortcut Dimension 1 Code" := '';
        // "Shortcut Dimension 2 Code" := '';
        // ServRequest.Get("Document No");
        // "Dimension Set ID" :=
        //   DimMgt.GetDefaultDimID(
        //     TableID,No,SourceCodeSetup.Purchases,"Shortcut Dimension 1 Code","Shortcut Dimension 2 Code",
        //     ServRequest."Dimension Set ID",DATABASE::Vendor);
        // DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
    end;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;

    procedure LookupShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.LookupDimValueCode(FieldNumber, ShortcutDimCode);
        ValidateShortcutDimCode(FieldNumber, ShortcutDimCode);
    end;

    procedure ShowShortcutDimCode(var ShortcutDimCode: array[8] of Code[20])
    begin
        DimMgt.GetShortcutDimensions("Dimension Set ID", ShortcutDimCode);
    end;

    local procedure GetItem()
    begin
        if Item."No." <> Rec."No." then
            Item.Get("No.");
    end;

    local procedure GetPurchHeader()
    begin
        TestField(Rec."Document No");
        ServRequest.Get(Rec."Document No");
        /*
        IF ("Document Type" <> PurchHeader."Document Type") OR ("Document No." <> PurchHeader."No.") THEN BEGIN
          PurchHeader.GET("Document Type","Document No.");
          IF PurchHeader."Currency Code" = '' THEN
            Currency.InitRoundingPrecision
          ELSE BEGIN
            PurchHeader.TESTFIELD("Currency Factor");
            Currency.GET(PurchHeader."Currency Code");
            Currency.TESTFIELD("Amount Rounding Precision");
          END;
        END;
        */

    end;

    local procedure TestStatusOpen()
    begin
        //IF StatusCheckSuspended THEN
        //  EXIT;
        GetPurchHeader;
        //IF NOT "System-Created Entry" THEN
        if Type <> Type::" " then
            if ServRequest.Status = ServRequest.Status::Validated then
                Error(Text001);
        //ServRequest.TESTFIELD(ServRequest.Status,ServRequest.Status::Open);
    end;
}

