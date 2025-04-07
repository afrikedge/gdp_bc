table 50103 "Afk Customer Revision"
{
    Caption = 'Customer Revision';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            Editable = false;
        }
        field(2; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;
        }
        field(3; Name; Text[100])
        {
            Caption = 'Name';
        }
        field(4; "Parent Account No."; Code[20])
        {
            Caption = 'Parent Account No.';
            TableRelation = Customer;
        }
        field(5; "Sales Category Code"; Code[20])
        {
            Caption = 'Sales Category Code';
            TableRelation = "Sales Category";
        }
        field(6; Object; Text[250])
        {
            Caption = 'Object';
        }
        field(7; "Approval Status"; Enum "Afk CRM Approval Status")
        {
            Caption = 'Approval Status';
        }
        field(8; "Payment Terms Code"; Code[20])
        {
            Caption = 'Payment Terms Code';
            TableRelation = "Payment Terms";
        }
        field(9; "New Payment Terms Code"; Code[20])
        {
            Caption = 'New Payment Terms Code';
            TableRelation = "Payment Terms";
        }
        field(10; "Revised Payment Terms Code"; Boolean)
        {
            Caption = 'Revised Payment Terms Code';
        }
        field(11; "Approved Payment Terms Code"; Boolean)
        {
            Caption = 'Approved Payment Terms Code';
        }
        field(12; "Credit limit (LCY)"; Decimal)
        {
            Caption = 'Credit limit (LCY)';
        }
        field(13; "New Credit limit (LCY)"; Decimal)
        {
            Caption = 'New Credit limit (LCY)';
        }
        field(14; "Revised Credit limit (LCY)"; Boolean)
        {
            Caption = 'Revised Credit limit (LCY)';
        }
        field(15; "Approved Credit limit (LCY)"; Boolean)
        {
            Caption = 'Approved Credit limit (LCY)';
        }
        field(16; "Risk Level"; Code[20])
        {
            Caption = 'Risk Level';
            TableRelation = "Risk Level";
        }
        field(17; "New Risk Level"; Code[20])
        {
            Caption = 'New Risk Level';
            TableRelation = "Risk Level";
        }
        field(18; "Revised Risk Level"; Boolean)
        {
            Caption = 'Revised Risk Level';
        }
        field(19; "Approved Risk Level"; Boolean)
        {
            Caption = 'Approved Risk Level';
        }
        field(20; "Revised Payment Method"; Boolean)
        {
            Caption = 'Revised Payment Method';
        }
        field(21; "Approved Payment Method"; Boolean)
        {
            Caption = 'Approved Payment Method';
        }
        field(22; "Cash payment"; Boolean)
        {
            Caption = 'Cash payment';
        }
        field(23; "Check Set"; Boolean)
        {
            Caption = 'Check Set';
        }
        field(24; "Bank Transfer Bank Stamp"; Boolean)
        {
            Caption = 'Bank Transfer Bank Stamp';
        }
        field(25; Traite; Boolean)
        {
            Caption = 'Traite';
        }
        field(26; "Received Check"; Boolean)
        {
            Caption = 'Received Check';
        }
        field(27; "Credit Note"; Boolean)
        {
            Caption = 'Credit Note';
        }
        field(28; "Automatic Debit"; Boolean)
        {
            Caption = 'Automatic Debit';
        }
        field(29; "Mobile Banking"; Boolean)
        {
            Caption = 'Mobile Banking';
        }
        field(30; "New Cash payment"; Boolean)
        {
            Caption = 'New Cash payment';
        }
        field(31; "New Check Set"; Boolean)
        {
            Caption = 'New Check Set';
        }
        field(32; "New Bank Transfer Bank Stamp"; Boolean)
        {
            Caption = 'New Bank Transfer Bank Stamp';
        }
        field(33; "New Traite"; Boolean)
        {
            Caption = 'New Traite';
        }
        field(34; "New Received Check"; Boolean)
        {
            Caption = 'New Received Check';
        }
        field(35; "New Credit Note"; Boolean)
        {
            Caption = 'New Credit Note';
        }
        field(36; "New Automatic Debit"; Boolean)
        {
            Caption = 'New Automatic Debit';
        }
        field(37; "New Mobile Banking"; Boolean)
        {
            Caption = 'New Mobile Banking';
        }
        field(38; "Created By"; Code[50])
        {
            Caption = 'Created By';
            TableRelation = "Afk FrontDesk User";
        }
        field(39; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(40; "Description"; Text[500])
        {
            Caption = 'Motif';
        }

    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    var
    begin
        AddOnSetup.Get;
        if "No." = '' then begin
            AddOnSetup.TestField("Cust Revision Nos Series");
            "No. Series" := AddOnSetup."Cust Revision Nos Series";
            if (NoSeriesMgt.AreRelated(AddOnSetup."Cust Revision Nos Series", xRec."No. Series")) then
                "No. Series" := xRec."No. Series";
            "No." := NoSeriesMgt.GetNextNo("No. Series");
        end;
    end;

    trigger OnDelete()
    var
        ApprovalFlow: Record "Afk Approval Flow";
    begin
        ApprovalFlow.Reset();
        ApprovalFlow.SetRange("Record Type", ApprovalFlow."Record Type"::"Révision compte");
        ApprovalFlow.SetRange("Record No.", Rec."No.");
        if (not ApprovalFlow.IsEmpty) then
            ApprovalFlow.DeleteAll();
    end;

    var
        AddOnSetup: Record "AddOn Setup2";
        NoSeriesMgt: Codeunit "No. Series";
}
