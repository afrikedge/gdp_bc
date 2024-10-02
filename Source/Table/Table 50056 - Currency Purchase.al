table 50056 "Currency Purchase"
{
    Caption = 'Currency purchase';
    PasteIsValid = false;

    fields
    {
        field(1; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(4; "Posting Date"; Date)
        {
            Caption = 'Posting Date';

            trigger OnValidate()
            begin
                TestPosted;
            end;
        }
        field(5; "Amount Currency"; Decimal)
        {
            Caption = 'Amount in currency';

            trigger OnValidate()
            begin
                "Amount LCY" := Round("Amount Currency" * "Convertion Rate");
                RefreshLCLine;
                TestPosted;
            end;
        }
        field(6; "Convertion Rate"; Decimal)
        {
            Caption = 'Convertion Rate';
            DecimalPlaces = 0 : 3;

            trigger OnValidate()
            begin
                "Amount LCY" := Round("Amount Currency" * "Convertion Rate");
                RefreshLCLine;
                TestPosted;
            end;
        }
        field(7; "Amount LCY"; Decimal)
        {
            Caption = 'Amount (AR)';
            Editable = false;
        }
        field(8; "Due Line"; Integer)
        {
            Caption = 'Due Line';
            TableRelation = "Letter of credit Expiry"."Line No." WHERE("Document No." = FIELD("Document No."));
        }
        field(9; Posted; Boolean)
        {
            CalcFormula = Exist("Bank Account Ledger Entry" WHERE("LC Number" = FIELD("Document No."),
                                                                   "LC Curr Purchase Line No." = FIELD("Line No."),
                                                                   Reversed = CONST(false)));
            Caption = 'Posted';
            Editable = false;
            FieldClass = FlowField;
        }
        field(10; "Affected Provisions"; Decimal)
        {
            CalcFormula = Sum("Expiry Currency Purchase"."Purchase Amount" WHERE("LC Document No." = FIELD("Document No."),
                                                                                  "Purchase Line No." = FIELD("Line No.")));
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Document No.", "Line No.")
        {
        }
        key(Key2; "Document No.", "Posting Date")
        {
        }
        key(Key3; "Document No.", "Due Line")
        {
            SumIndexFields = "Amount LCY";
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        CapableToPromise: Codeunit "Capable to Promise";
        JobCreateInvoice: Codeunit "Job Create-Invoice";
        SalesCommentLine: Record "Sales Comment Line";
    begin


        /*
        SalesCommentLine.SETRANGE("Document Type","Document Type");
        SalesCommentLine.SETRANGE("No.","Document No.");
        SalesCommentLine.SETRANGE("Document Line No.","Line No.");
        IF NOT SalesCommentLine.ISEMPTY THEN
          SalesCommentLine.DELETEALL;
        */

    end;

    trigger OnRename()
    begin
        Error(Text001, TableCaption);
    end;

    var
        AdjustHeader: Record "Adjustment Header";
        AddOnSetup: Record "AddOn Setup";
        DimMgt: Codeunit DimensionManagement;
        UnitOfMeasure: Record "Unit of Measure";
        Item1: Record Item;
        Text001: Label 'You cannot rename a %1.';
        Text002: Label 'Vous ne pouvez pas rembourser une quantité supérieure à la quantité prêtée';
    //GLMgt: Codeunit "Treso Mgt";

    procedure SetSalesHeader(NewSalesHeader: Record "Sales Header")
    begin
    end;

    local procedure GetDocumentHeader()
    begin
        /*
        TESTFIELD(Description);
        IF ("Document No." <> AdjustHeader."Document Type") OR (Description <> AdjustHeader."No.") THEN BEGIN
          AdjustHeader.GET("Document No.",Description);
        
        END;
        */

    end;

    procedure ShowDimensions()
    begin
        /*
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet("Dimension Set ID",STRSUBSTNO('%1 %2 %3',"Document No.",Description,"Due Date"));
        
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
        */

    end;

    procedure CreateDim(Type1: Integer; No1: Code[20]; Type2: Integer; No2: Code[20]; Type3: Integer; No3: Code[20])
    var
        SourceCodeSetup: Record "Source Code Setup";
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
    begin
        /*
        SourceCodeSetup.GET;
        TableID[1] := Type1;
        No[1] := No1;
        TableID[2] := Type2;
        No[2] := No2;
        TableID[3] := Type3;
        No[3] := No3;
        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        GetDocumentHeader;
        "Dimension Set ID" :=
          DimMgt.GetDefaultDimID(
            TableID,No,SourceCodeSetup.Sales,
            "Shortcut Dimension 1 Code","Shortcut Dimension 2 Code",
            AdjustHeader."Dimension Set ID",DATABASE::Customer);
        DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID","Shortcut Dimension 1 Code","Shortcut Dimension 2 Code");
        //ATOLink.UpdateAsmDimFromSalesLine(Rec);
        */

    end;

    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        //DimMgt.ValidateShortcutDimValues(FieldNumber,ShortcutDimCode,"Dimension Set ID");
    end;

    procedure LookupShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        //DimMgt.LookupDimValueCode(FieldNumber,ShortcutDimCode);
        //ValidateShortcutDimCode(FieldNumber,ShortcutDimCode);
    end;

    procedure ShowShortcutDimCode(var ShortcutDimCode: array[8] of Code[20])
    begin
        //DimMgt.GetShortcutDimensions("Dimension Set ID",ShortcutDimCode);
    end;

    local procedure GetSalesSetup()
    begin
        //IF NOT SalesSetupRead THEN
        AddOnSetup.Get;
        //SalesSetupRead := TRUE;
    end;

    local procedure TestStatusOpen()
    begin

        GetDocumentHeader;
        //IF NOT "System-Created Entry" THEN
        //  IF Type <> Type::" " THEN
        AdjustHeader.TestField(Status, AdjustHeader.Status::Open);
    end;

    local procedure CalcBaseQty(Qty: Decimal): Decimal
    begin
        //TESTFIELD("Qty. per Unit of Measure");
        //EXIT(ROUND(Qty * "Qty. per Unit of Measure",0.00001));
    end;

    local procedure GetItem1()
    begin
        //TESTFIELD("Value Date");
        //IF "Value Date" <> Item1."No." THEN
        //  Item1.GET("Value Date");
    end;

    local procedure RefreshLCLine()
    var
        LCLine: Record "Letter of credit Expiry";
    begin
        if LCLine.Get("Document No.", Rec."Due Line") then begin
            LCLine.Validate(LCLine."Provisions %");
            LCLine.Modify;
        end else begin
            //TODO Migration
            //GLMgt.RefreshLinesLettreCredit("Document No.");
        end
    end;

    local procedure TestPosted()
    begin
        Rec.TestField(Rec.Posted, false);
    end;
}

