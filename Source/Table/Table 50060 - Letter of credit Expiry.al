table 50060 "Letter of credit Expiry"
{
    Caption = 'Letter of credit expiry';
    PasteIsValid = false;

    fields
    {
        field(1;"Document No.";Code[20])
        {
            Caption = 'Document No.';
        }
        field(2;"Line No.";Integer)
        {
            Caption = 'Line No.';
        }
        field(3;Description;Text[50])
        {
            Caption = 'Description';
        }
        field(4;"Due Date";Date)
        {
            Caption = 'Due Date';

            trigger OnValidate()
            begin
                if "Posting Date"=0D then "Posting Date":="Due Date";
            end;
        }
        field(5;"Due Amount";Decimal)
        {
            Caption = 'Due Amount';

            trigger OnValidate()
            begin
                TestPosted;
                GetDocumentHeader;
                if LC."Invoice Amount"<>0 then
                  "Due %" := Round(Rec."Due Amount"*100/LC."Invoice Amount",0.00001);
                Updated := false;
            end;
        }
        field(6;"Value Date";Date)
        {
            Caption = 'Value Date';
        }
        field(7;"Due %";Decimal)
        {
            Caption = 'Due %';
            DecimalPlaces = 0:5;
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate()
            begin
                TestPosted;
                GetDocumentHeader;
                Rec."Due Amount" := Round(LC."Invoice Amount"*"Due %"/100);
                Updated := false;
            end;
        }
        field(8;"Total Purchased Due (LCY)";Decimal)
        {
            Caption = 'Total Purchased (LCY)';
            Editable = false;
            FieldClass = Normal;
        }
        field(9;"Balance To Pay";Decimal)
        {
            Caption = 'Balance To Pay';
        }
        field(10;"Provisions %";Decimal)
        {
            Caption = 'Provisions %';
            MaxValue = 100;
            MinValue = 0;

            trigger OnValidate()
            var
                CurrPurch: Record "Currency Purchase";
                AchatProvision: Record "Expiry Currency Purchase";
            begin
                TestPosted;
                GetDocumentHeader;
                "Provisions Amount" := Round(LC."Provisions Amount" * "Provisions %"/100);
                //LC.CALCFIELDS(LC."Total Purchased Prov. (LCY)");
                CalcFields(Rec."Provisions Amount Purch (LCY)");

                Rec."Total Purchased Due" := 0;
                Rec."Total Purchased Due (LCY)" := 0;

                CurrPurch.Reset;
                CurrPurch.SetRange("Document No.",Rec."Document No.");
                CurrPurch.SetRange("Due Line",Rec."Line No.");
                if CurrPurch.FindSet then repeat
                  CurrPurch.CalcFields(Posted);
                  if CurrPurch.Posted then begin
                    Rec."Total Purchased Due" := Rec."Total Purchased Due" + CurrPurch."Amount Currency";
                    Rec."Total Purchased Due (LCY)" := Rec."Total Purchased Due (LCY)" + CurrPurch."Amount LCY";
                  end;
                until CurrPurch.Next=0;

                AchatProvision.Reset;
                AchatProvision.SetRange(AchatProvision."LC Document No.",Rec."Document No.");
                AchatProvision.SetRange("Expiry Line No.",Rec."Line No.");
                if AchatProvision.FindSet then repeat
                  Rec."Total Purchased Due" := Rec."Total Purchased Due" + AchatProvision."Purchase Amount";
                  //Rec."Total Purchased Due (LCY)" := Rec."Total Purchased Due (LCY)" + AchatProvision."Purchase Amount (LCY)";
                until AchatProvision.Next=0;

                ///"Provisions Amount Purch (LCY)" := ROUND(LC."Total Purchased Prov. (LCY)" * "Provisions %"/100);
                "Total Purchased LCY" := "Provisions Amount Purch (LCY)" + "Total Purchased Due (LCY)";
                Updated := false;
            end;
        }
        field(11;"Provisions Amount Purch (LCY)";Decimal)
        {
            CalcFormula = Sum("Expiry Currency Purchase"."Purchase Amount (LCY)" WHERE ("LC Document No."=FIELD("Document No."),
                                                                                        "Expiry Line No."=FIELD("Line No.")));
            Caption = 'Provisions Amount Purchased';
            Description = 'LCY';
            Editable = false;
            FieldClass = FlowField;
        }
        field(12;"Total Purchased LCY";Decimal)
        {
            Caption = 'Total Purchased (AR)';
            Editable = false;
        }
        field(13;Posted;Boolean)
        {
            CalcFormula = Exist("Bank Account Ledger Entry" WHERE ("LC Number"=FIELD("Document No."),
                                                                   "LC Ech Payment Line No."=FIELD("Line No."),
                                                                   Reversed=CONST(false)));
            Caption = 'Posted';
            Editable = false;
            FieldClass = FlowField;
        }
        field(14;"Total Purchased Due";Decimal)
        {
            Caption = 'Total Purchased';
            Editable = false;
            FieldClass = Normal;
        }
        field(15;"Posting Date";Date)
        {
            Caption = 'Posting Date';

            trigger OnValidate()
            begin
                TestPosted;
            end;
        }
        field(16;"Provisions Amount";Decimal)
        {
            Caption = 'Provisions amount';
            Editable = false;
        }
        field(17;"Affected Provisions";Decimal)
        {
            CalcFormula = Sum("Expiry Currency Purchase"."Purchase Amount" WHERE ("LC Document No."=FIELD("Document No."),
                                                                                  "Expiry Line No."=FIELD("Line No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(18;Updated;Boolean)
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1;"Document No.","Line No.")
        {
        }
        key(Key2;"Document No.","Due Date")
        {
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
        Error(Text001,TableCaption);
    end;

    var
        LC: Record "Letter of credit";
        AddOnSetup: Record "AddOn Setup";
        DimMgt: Codeunit DimensionManagement;
        UnitOfMeasure: Record "Unit of Measure";
        Item1: Record Item;
        Text001: Label 'You cannot rename a %1.';
        Text002: Label 'Vous ne pouvez pas rembourser une quantité supérieure à la quantité prêtée';

    procedure SetSalesHeader(NewSalesHeader: Record "Sales Header")
    begin
    end;

    local procedure GetDocumentHeader()
    begin

        TestField("Document No.");
        if ("Document No." <> LC."No.") then begin
          LC.Get("Document No.");
        end;
    end;

    local procedure TestPosted()
    begin
        Rec.TestField(Rec.Posted,false);
    end;
}

