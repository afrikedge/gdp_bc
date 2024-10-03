table 50054 "Posted Purchase Requisition"
{
    Caption = 'Posted Purchase requisition';

    fields
    {
        field(1; "No."; Code[20])
        {
        }
        field(2; "Budget Code"; Code[10])
        {
            Caption = 'Budget Code';
            TableRelation = "G/L Budget Name";
        }
        field(3; "Purchase Type"; Option)
        {
            Caption = 'Purchase Type';
            ExtendedDatatype = Masked;
            OptionCaption = 'Purchase of goods,Others purchases,Purchase of FA';
            OptionMembers = AchatMarchandise,AchatAutre,AchatImmos;
        }
        field(4; "Origin Doc No"; Code[20])
        {
            Caption = 'Origin Document No';
            Editable = false;
        }
        field(6; "Project Code"; Code[30])
        {
            Caption = 'Code Projet';
        }
        field(7; "Nature Code"; Code[20])
        {
            Caption = 'Nature Code';
        }
        field(8; Initiator; Text[50])
        {
            Caption = 'Initiator';
        }
        field(9; "Purchaser Code"; Code[20])
        {
            Caption = 'Purchaser Code';
            TableRelation = "Salesperson/Purchaser";
        }
        field(10; "Creation Date"; Date)
        {
            Caption = 'Creation Date';
            Editable = false;
        }
        field(11; "Create By"; Code[50])
        {
            Caption = 'Create By';
            Editable = false;
        }
        field(12; Description; Text[150])
        {
            Caption = 'Description';
        }
        field(14; "Created Doc Type"; Option)
        {
            Caption = 'Created Document Type';
            Editable = false;
            OptionCaption = 'Purchase order,Contract';
            OptionMembers = Commande,Contrat;
        }
        field(15; "Created Doc Code"; Code[20])
        {
            Caption = 'Created Document Code';
            Editable = false;
        }
        field(16; Comments; Boolean)
        {
            Caption = 'Comments';
            Editable = false;
        }
        field(17; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(18; Status; Option)
        {
            Caption = 'Status';
            Editable = false;
            OptionCaption = 'Open,CDG,Manager,Validated';
            OptionMembers = Open,CDG,Manager,Validated;
        }
        field(21; "Requested Receipt Date"; Date)
        {
            Caption = 'Requested Receipt Date';
        }
        field(23; "Total Amount Incl.VAT (LCY)"; Decimal)
        {
            Caption = 'Estimated amount incl VAT';
            Editable = false;
        }
        field(27; "Request Recipient"; Text[50])
        {
            Caption = 'Destinataire de la demande';
        }
        field(28; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(29; "Gen. Bus. Posting Group"; Code[10])
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
        field(30; "VAT Bus. Posting Group"; Code[10])
        {
            Caption = 'Gen. Prod. VAT Posting Group';
            TableRelation = "VAT Business Posting Group";

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
        field(31; "Retained Offer Code"; Code[10])
        {
            Caption = 'Retained Offer Code';
            TableRelation = "Purchase Header"."No." WHERE("Document Type" = CONST(Quote),
                                                           Status = CONST(Released),
                                                           "Code Demande" = FIELD("No."));
        }
        field(32; "Closed Date"; Date)
        {
            Caption = 'Closed Date';
            Editable = false;
        }
        field(33; "Closed By"; Code[50])
        {
            Caption = 'Closed By';
            Editable = false;
        }
        field(34; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
            end;
        }
        field(35; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE("Global Dimension No." = CONST(2));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
            end;
        }
        field(36; "Autorisation Ref"; Text[30])
        {
            Caption = 'Authorization Ref';
        }
        field(37; "External Doc No"; Text[30])
        {
            Caption = 'External Doc. No';
        }
        field(40; "Direction Code"; Text[10])
        {
            Caption = 'Direction Name';
        }
        field(41; "Service Code"; Text[10])
        {
            Caption = 'Service Name';
        }
        field(42; "Department Code"; Text[10])
        {
            Caption = 'Department Name';
        }
        field(43; "Type Achat"; Option)
        {
            Caption = 'Purchase';
            OptionCaption = 'Item,Service,Intellectual';
            OptionMembers = Item,Service,Intellectual;
        }
        field(44; "Type article"; Option)
        {
            Caption = 'Item Type';
            OptionCaption = 'Fixed Asset,Item,Non Item,Others';
            OptionMembers = FA,Item,"Non Item",Others;
        }
        field(45; "Order Type"; Option)
        {
            Caption = 'Order type';
            OptionCaption = 'Regular,Prioritary,Urgent,Marginal';
            OptionMembers = Regular,Prioritary,Urgent,Marginal;
        }
        field(46; Budgeted; Boolean)
        {
            Caption = 'Budgeted';
        }
        field(47; "Budgeted Amount"; Decimal)
        {
            Caption = 'Budgeted Amount';
        }
        field(48; "Under Contract"; Boolean)
        {
            Caption = 'Under contract';
        }
        field(49; "Contract Ref"; Text[30])
        {
            Caption = 'Contract Ref.';
        }
        field(50; Project; Boolean)
        {
            Caption = 'Project';
        }
        field(100; "PR Type"; Option)
        {
            Caption = 'Purch Req Type';
            OptionCaption = ' ,DOP Travaux,DOP Maintenance,DOP Supply,DOP Logistique,HSE,DCM,IT,SGX,SGX Service,RH,DG';
            OptionMembers = " ","DOP Travaux","DOP Maintenance","DOP Supply","DOP Logistique",HSE,DCM,IT,SGX,"SGX Service",RH,DG;
        }
        field(101; "User Validation"; Date)
        {
        }
        field(102; "CDG Validation"; Date)
        {
        }
        field(103; "Manager Validation"; Date)
        {
        }
        field(104; "CDG User"; Code[50])
        {
        }
        field(105; "Manager User"; Code[50])
        {
        }
        field(106; "PO Type"; Option)
        {
            Caption = 'Purch Order Type';
            OptionCaption = ' ,Achats,SGX Services,RH,DG';
            OptionMembers = " ",Achats,"SGX Services",RH,DG;
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDocDim;
            end;
        }
        field(50000; Process; Option)
        {
            Editable = false;
            OptionCaption = 'Not processed,Processed';
            OptionMembers = "Not Processed",Processed;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        AddOnSetup: Record "AddOn Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        DimMgt: Codeunit DimensionManagement;
        DimManagement: Codeunit DimensionManagement;
        ReglHeader: Record "Purchase Requisition";
        CurrencyDate: Date;
        CurrExchRate: Record "Currency Exchange Rate";
        RegLine: Record "Purchase Requisition Line";
        DefaultDimension: Record "Default Dimension";
        PurchLine: Record "Purchase Requisition Line";
        PurchH: Record "Purchase Header";
        UserSetup: Record "User Setup";
        //PurchReqMgt: Codeunit "Item Borrow Mgt";
        Text051: Label 'You may have changed a dimension.\\Do you want to update the lines?';
        Text001: Label 'Toutes les offres associées à cette demande seront supprimées ! Voulez-vous continuer ?';

    procedure LookupShortcutDimCode(FieldNo: Integer; var ShortcutDimCode: Code[20])
    begin
        DimManagement.LookupDimValueCode(FieldNo, ShortcutDimCode);
        DimManagement.ValidateShortcutDimValues(FieldNo, ShortcutDimCode, "Dimension Set ID");
    end;

    procedure ValidateShortcutDimCode(FieldNo: Integer; var ShortcutDimCode: Code[20])
    begin
        DimManagement.ValidateShortcutDimValues(FieldNo, ShortcutDimCode, "Dimension Set ID");
    end;

    procedure PurchLinesExist(): Boolean
    begin
        PurchLine.Reset;
        //PurchLine.SETRANGE("Document Type","Document Type");
        PurchLine.SetRange(PurchLine."Document No", "No.");
        exit(PurchLine.FindFirst);
    end;

    procedure CreateDim(Type1: Integer; No1: Code[20]; Type2: Integer; No2: Code[20]; Type3: Integer; No3: Code[20]; Type4: Integer; No4: Code[20])
    var
        SourceCodeSetup: Record "Source Code Setup";
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
        OldDimSetID: Integer;
    begin
        // SourceCodeSetup.Get;
        // TableID[1] := Type1;
        // No[1] := No1;
        // TableID[2] := Type2;
        // No[2] := No2;
        // TableID[3] := Type3;
        // No[3] := No3;
        // TableID[4] := Type4;
        // No[4] := No4;
        // "Shortcut Dimension 1 Code" := '';
        // "Shortcut Dimension 2 Code" := '';
        // OldDimSetID := "Dimension Set ID";
        // "Dimension Set ID" :=
        //   DimMgt.GetDefaultDimID(TableID, No, SourceCodeSetup.Purchases, "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", 0, 0);

        // if (OldDimSetID <> "Dimension Set ID") and PurchLinesExist then begin
        //     Modify;
        //     UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        // end;
    end;

    procedure ShowDocDim()
    var
        OldDimSetID: Integer;
    begin
        // OldDimSetID := "Dimension Set ID";
        // "Dimension Set ID" :=
        //   DimMgt.EditDimensionSet2(
        //     "Dimension Set ID", StrSubstNo('%1 %2', '', "No."),
        //     "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");

        // if OldDimSetID <> "Dimension Set ID" then begin
        //     Modify;
        //     if PurchLinesExist then
        //         UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        // end;
    end;

    local procedure UpdateAllLineDim(NewParentDimSetID: Integer; OldParentDimSetID: Integer)
    var
        NewDimSetID: Integer;
    begin
        // Update all lines with changed dimensions.

        if NewParentDimSetID = OldParentDimSetID then
            exit;
        if not Confirm(Text051) then
            exit;

        PurchLine.Reset;
        //PurchLine.SETRANGE("Document Type","Document Type");
        PurchLine.SetRange("Document No", "No.");
        PurchLine.LockTable;
        if PurchLine.Find('-') then
            repeat
                NewDimSetID := DimMgt.GetDeltaDimSetID(PurchLine."Dimension Set ID", NewParentDimSetID, OldParentDimSetID);
                if PurchLine."Dimension Set ID" <> NewDimSetID then begin
                    PurchLine."Dimension Set ID" := NewDimSetID;
                    DimMgt.UpdateGlobalDimFromDimSetID(
                      PurchLine."Dimension Set ID", PurchLine."Shortcut Dimension 1 Code", PurchLine."Shortcut Dimension 2 Code");
                    PurchLine.Modify;
                end;
            until PurchLine.Next = 0;
    end;
}

