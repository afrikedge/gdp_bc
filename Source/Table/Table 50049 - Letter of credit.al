table 50049 "Letter of credit"
{
    DataCaptionFields = "No.", "Letter of Credit Ref";

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            Editable = false;

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    AddOnSetup.Get;
                    NoSeriesMgt.TestManual(GetNoSeriesCode);
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "Letter of Credit Ref"; Code[20])
        {
            Caption = 'Letter of Credit Ref';
        }
        field(3; "Vendor No."; Code[20])
        {
            Caption = 'Vendor Code';
            TableRelation = Vendor;

            trigger OnValidate()
            begin
                if Vend.Get("Vendor No.") then
                    "Vendor Name" := Vend.Name;
            end;
        }
        field(4; "Vendor Name"; Text[50])
        {
            Caption = 'Vendor Name';
            Editable = false;
        }
        field(5; "Document Date"; Date)
        {
            Caption = 'Document Date';
        }
        field(7; Description; Text[100])
        {
            Caption = 'Comment';
        }
        field(8; "CIF Amount"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'CIF Amount';
        }
        field(9; "BL Date"; Date)
        {
            Caption = 'BL Date';

            trigger OnValidate()
            begin
                Validate("Payment Terms Code");
            end;
        }
        field(11; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(12; Status; Option)
        {
            Caption = 'Status';
            Editable = false;
            OptionCaption = 'Open,Closed';
            OptionMembers = Open,Closed;
        }
        field(21; "User ID"; Code[50])
        {
            Caption = 'User ID';
            TableRelation = User."User Name";
            DataClassification = EndUserIdentifiableInformation;
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                UserSelection: Codeunit "User Selection";
            begin
                UserSelection.ValidateUserName("User ID");
            end;
        }
        field(23; "Payment Terms Code"; Code[10])
        {
            Caption = 'Payment Terms Code';
            TableRelation = "Payment Terms";

            trigger OnValidate()
            begin
                if ("Payment Terms Code" <> '') and ("BL Date" <> 0D) then begin
                    PaymentTerms.Get("Payment Terms Code");

                    "Due Date" := CalcDate(PaymentTerms."Due Date Calculation", "BL Date");

                end else begin
                    Validate("Due Date", "BL Date");
                end;
            end;
        }
        field(24; "Due Date"; Date)
        {
            Caption = 'Due Date';
        }
        field(25; "Invoice Amount"; Decimal)
        {
            Caption = 'Invoice Amount';

            trigger OnValidate()
            begin
                Clear(LCEcheance);
                LCEcheance.SetRange(LCEcheance."Document No.", Rec."No.");
                if LCEcheance.FindSet then
                    repeat
                        LCEcheance."Due Amount" := Round(LCEcheance."Due %" * Rec."Invoice Amount" / 100);
                        LCEcheance.Modify;
                    until LCEcheance.Next = 0;

                Validate("Provisions %");
            end;
        }
        field(26; "Purchase Quote Amount"; Decimal)
        {
            Caption = 'Purchase Quote Amount';
        }
        field(27; "Vendor Invoice Number"; Code[20])
        {
            Caption = 'Vendor Invoice Number';
            TableRelation = "Purch. Inv. Header"."No." WHERE("Pay-to Vendor No." = FIELD("Vendor No."));
        }
        field(28; "Purchase rate"; Decimal)
        {
            Caption = 'Purchase rate';
            Editable = false;
        }
        field(29; "Structure rate"; Decimal)
        {
            Caption = 'Structure rate';
        }
        field(30; "Total Purchased (LCY)"; Decimal)
        {
            CalcFormula = Sum("Currency Purchase"."Amount LCY" WHERE("Document No." = FIELD("No.")));
            Caption = 'Total Purchased (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(32; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(33; "Closed Date"; Date)
        {
            Caption = 'Closed Date';
            Editable = false;
        }
        field(34; "Bank Account"; Code[20])
        {
            Caption = 'Bank Account';
            TableRelation = "Bank Account";

            trigger OnValidate()
            begin
                if Bank.Get(Rec."Bank Account") then begin
                    "Bank Name" := Bank.Name;
                    "Currency Code" := Bank."Currency Code";
                end;
            end;
        }
        field(35; "Bank Name"; Text[50])
        {
            Caption = 'Bank Name';
            Editable = false;
        }
        field(36; "Provisions %"; Decimal)
        {
            Caption = 'Provisions %';

            trigger OnValidate()
            begin
                //"Provisions Amount" := ROUND("Provisions %"*"Invoice Amount"/100);
                "Provisions Amount" := Round("Provisions %" * Rec."Purchase Quote Amount" / 100);
            end;
        }
        field(37; "Total Purchased Prov. (LCY)"; Decimal)
        {
            CalcFormula = Sum("Currency Purchase"."Amount LCY" WHERE("Document No." = FIELD("No."),
                                                                      "Due Line" = FILTER(= 0)));
            Caption = 'Total Purchased Provisions AR';
            Editable = false;
            FieldClass = FlowField;
        }
        field(38; "Provisions Amount"; Decimal)
        {
            Caption = 'Provisions Amount';
            Editable = false;
        }
        field(39; "Currency Purchase Tmpl"; Code[10])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(40; "Currency Purchase Jrnal"; Code[20])
        {
            Caption = 'Currency Purchase Journal';
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Currency Purchase Tmpl"));
        }
        field(41; "Accreditif Bank Account"; Code[20])
        {
            Caption = 'Credit Bank Account';
            TableRelation = "Bank Account";
        }
        field(42; "Total Purchased Prov."; Decimal)
        {
            CalcFormula = Sum("Currency Purchase"."Amount Currency" WHERE("Document No." = FIELD("No."),
                                                                           "Due Line" = FILTER(= 0)));
            Caption = 'Total Purchased Provisions';
            Editable = false;
            FieldClass = FlowField;
        }
        field(43; "Total Purchased"; Decimal)
        {
            CalcFormula = Sum("Currency Purchase"."Amount Currency" WHERE("Document No." = FIELD("No.")));
            Caption = 'Total Purchased';
            Editable = false;
            FieldClass = FlowField;
        }
        field(44; "Paiement Echeance Tmpl"; Code[10])
        {
            TableRelation = "Gen. Journal Template";
        }
        field(45; "Paiement Echeance Jrnal"; Code[20])
        {
            Caption = 'Feuille de validation Paiement échéance';
            TableRelation = "Gen. Journal Batch".Name WHERE("Journal Template Name" = FIELD("Paiement Echeance Tmpl"));
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

    trigger OnDelete()
    begin
        Rec.TestField(Status, Rec.Status::Open);

        LCEcheance.Reset;
        LCEcheance.SetRange(LCEcheance."Document No.", "No.");
        LCEcheance.DeleteAll;

        CurrencyPurchase.Reset;
        CurrencyPurchase.SetRange(CurrencyPurchase."Document No.", "No.");
        CurrencyPurchase.DeleteAll;
    end;

    trigger OnInsert()
    begin
        "Document Date" := WorkDate;

        AddOnSetup.Get;
        if "No." = '' then begin
            TestNoSeries;
            NoSeriesMgt.InitSeries(GetNoSeriesCode, xRec."No. Series", "Document Date", "No.", "No. Series");
        end;

        AddOnSetup.TestField(AddOnSetup."Curr Purchase Tmpl Journal");
        Rec."Currency Purchase Tmpl" := AddOnSetup."Curr Purchase Tmpl Journal";

        AddOnSetup.TestField(AddOnSetup."Progal Payment Tmpl Journal");
        Rec."Paiement Echeance Tmpl" := AddOnSetup."Progal Payment Tmpl Journal";


        "User ID" := UserId;
    end;

    var
        GLSetup: Record "General Ledger Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        AddOnSetup: Record "AddOn Setup";
        Vend: Record Vendor;
        PaymentTerms: Record "Payment Terms";
        LCEcheance: Record "Letter of credit Expiry";
        CurrencyPurchase: Record "Currency Purchase";
        Bank: Record "Bank Account";
    //TresoMgt: Codeunit "Treso Mgt";

    local procedure TestNoSeries(): Boolean
    begin
        AddOnSetup.Get;
        AddOnSetup.TestField(AddOnSetup."Letter of credit Nos.");
    end;

    local procedure GetNoSeriesCode(): Code[10]
    begin
        exit(AddOnSetup."Letter of credit Nos.");
    end;

    procedure CalcValues()
    var
        TotalAchatAR: Decimal;
        TotalAchat: Decimal;
        CurrPurch: Record "Currency Purchase";
    begin
        Validate("Provisions %");
        //TODO Migration
        //TresoMgt.AffecterProvisionsLC(Rec);
        CalcFields("Total Purchased (LCY)", "Total Purchased Prov. (LCY)");

        Clear(LCEcheance);
        LCEcheance.SetRange("Document No.", Rec."No.");
        if LCEcheance.FindSet then
            repeat
                //LCEcheance."Due Amount" := ROUND(LCEcheance."Due %"*Rec."Invoice Amount"/100);
                LCEcheance.Validate(LCEcheance."Provisions %");
                //LCEcheance."Provisions Amount Purchased":=ROUND(LCEcheance."Provisions %"*Rec."Invoice Amount"/100);
                LCEcheance.Updated := true;
                LCEcheance.Modify;
            until LCEcheance.Next = 0;

        //Taux moyen d'achat de devises
        CurrPurch.Reset;
        CurrPurch.SetRange("Document No.", Rec."No.");
        if CurrPurch.FindSet then
            repeat
                CurrPurch.CalcFields(Posted);
                if CurrPurch.Posted then begin
                    TotalAchatAR := TotalAchatAR + CurrPurch."Amount LCY";
                    TotalAchat := TotalAchat + CurrPurch."Amount Currency";
                end;
            until CurrPurch.Next = 0;

        "Purchase rate" := 0;
        if TotalAchat <> 0 then
            "Purchase rate" := Round(TotalAchatAR / TotalAchat);
    end;
}

