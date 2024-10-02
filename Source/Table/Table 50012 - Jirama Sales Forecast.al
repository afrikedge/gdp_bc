table 50012 "Jirama Sales Forecast"
{
    Caption = 'JIRAMA Sales Forecast';

    fields
    {
        field(1;"No.";Code[20])
        {
            Caption = 'No.';

            trigger OnValidate()
            begin

                if "No." <> xRec."No." then begin
                  AddOnSetup.Get;
                  AddOnSetup.TestField(AddOnSetup."Jirama Sales Forecast Nos.");
                  NoSeriesMgt.TestManual(AddOnSetup."Jirama Sales Forecast Nos.");
                  "No. Series" := '';
                end;
            end;
        }
        field(2;"Sell-to Customer No.";Code[20])
        {
            Caption = 'Sell-to Customer No.';
            TableRelation = Customer;

            trigger OnValidate()
            begin
                if Cust.Get("Sell-to Customer No.") then
                  "Customer Name" := Cust.Name;
            end;
        }
        field(3;"Starting Date";Date)
        {
            Caption = 'Starting Date';
        }
        field(4;"Ending Date";Date)
        {
            Caption = 'Ending Date';
        }
        field(5;"Partner No.";Code[20])
        {
            Caption = 'Partner No.';
            TableRelation = Vendor;

            trigger OnValidate()
            begin
                if Vend.Get("Partner No.") then
                  "Partner Name" := Vend.Name;
            end;
        }
        field(6;Status;Option)
        {
            Editable = false;
            OptionCaption = 'Created,Validated,Archived';
            OptionMembers = Created,Validated,Archived;
        }
        field(11;"Jirama Affectation %";Decimal)
        {
            Caption = 'JIRAMA Affecation %';
        }
        field(12;"JIRAMA Item No.";Code[20])
        {
            Caption = 'Item Code';
            TableRelation = Item;
        }
        field(13;"Customer Name";Text[50])
        {
            Editable = false;
        }
        field(14;"Partner Name";Text[50])
        {
            Caption = 'Partner Name';
        }
        field(15;"JIRAMA Order Ref";Code[30])
        {
            Caption = 'JIRAMA Order Ref.';
        }
        field(16;"Cargo Date";Date)
        {
            Caption = 'Cargo Date';
        }
        field(107;"No. Series";Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
    }

    keys
    {
        key(Key1;"No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        TestField(Status,Rec.Status::Created);
    end;

    trigger OnInsert()
    var
        ForecastLine: Record "Jirama Sales Forecast Line";
    begin

        AddOnSetup.Get;
        if "No." = '' then begin
          AddOnSetup.TestField(AddOnSetup."Jirama Sales Forecast Nos.");
          NoSeriesMgt.InitSeries(AddOnSetup."Jirama Sales Forecast Nos.",xRec."No. Series",Today,"No.","No. Series");
        end;

        AddOnSetup.TestField("Jirama Partner Code");
        AddOnSetup.TestField("Jirama Customer No");
        AddOnSetup.TestField("Jirama Affectation %");
        AddOnSetup.TestField("JIRAMA Item No.");

        Rec."Partner No." := AddOnSetup."Jirama Partner Code";
        Rec."Sell-to Customer No." :=AddOnSetup."Jirama Customer No";
        if Vend.Get(Rec."Partner No.") then
          Rec."Partner Name" := Vend.Name;
        Rec."Jirama Affectation %" := AddOnSetup."Jirama Affectation %";
        Rec."JIRAMA Item No." := AddOnSetup."JIRAMA Item No.";

        //Create Lines
        Cust2.Reset;
        Cust2.SetRange("Sales Channel Code",AddOnSetup."JIRAMA Sales Channel");
        Cust2.SetRange("Sales Category Code" , AddOnSetup."PBL Sales Category");
        if Cust2.FindSet then repeat
          ForecastLine.Init;
          ForecastLine."Document No." := "No.";
          ForecastLine.Validate(ForecastLine."Sell-to Customer No.",Cust2."No.");
          ForecastLine.Insert(true);
        until Cust2.Next=0;
    end;

    var
        AddOnSetup: Record "AddOn Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        Cust: Record Customer;
        Vend: Record Vendor;
        Cust2: Record Customer;
}

