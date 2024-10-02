table 50052 "Purchase Budget Line"
{

    fields
    {
        field(1;"Document Type";Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,Requisition';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",Requisition;
        }
        field(2;"Document No.";Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "Purchase Header"."No." WHERE ("Document Type"=FIELD("Document Type"));
        }
        field(3;"G/L Account No";Code[20])
        {
            Caption = 'G/L Account N°';
        }
        field(4;"G/L Account Name";Text[50])
        {
            Caption = 'G/L Account Name';
        }
        field(5;"Global Dimension 1";Code[20])
        {
            Caption = 'Global Dimension 1';
        }
        field(28;"Date Filter";Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(29;"Global Dimension 1 Filter";Code[20])
        {
            CaptionClass = '1,3,1';
            Caption = 'Global Dimension 1 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(1));
        }
        field(30;"Global Dimension 2 Filter";Code[20])
        {
            CaptionClass = '1,3,2';
            Caption = 'Global Dimension 2 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No."=CONST(2));
        }
        field(32;"Net Change";Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("G/L Entry".Amount WHERE ("G/L Account No."=FIELD("G/L Account No"),
                                                        "Posting Date"=FIELD("Date Filter"),
                                                        "Global Dimension 1 Code"=FIELD("Global Dimension 1 Filter"),
                                                        "Global Dimension 2 Code"=FIELD("Global Dimension 2 Filter")));
            Caption = 'Net Change';
            Editable = false;
            FieldClass = FlowField;
        }
        field(33;"Budgeted Amount";Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("G/L Budget Entry".Amount WHERE ("Budget Name"=FIELD("Budget Filter"),
                                                               "G/L Account No."=FIELD("G/L Account No"),
                                                               "Global Dimension 1 Code"=FIELD("Global Dimension 1 Filter"),
                                                               "Global Dimension 2 Code"=FIELD("Global Dimension 2 Filter"),
                                                               Date=FIELD("Date Filter")));
            Caption = 'Budgeted Amount';
            FieldClass = FlowField;
        }
        field(34;"Commitment Amount";Decimal)
        {
            Caption = 'Commitment Amount';
        }
        field(35;"Remaining Amount";Decimal)
        {
            Caption = 'Remaining Amount';
        }
        field(36;"Document Amount";Decimal)
        {
            Caption = 'Document Amount';
        }
        field(37;"Net Change Value";Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Realized Amount';
            Editable = false;
        }
        field(38;"Budgeted Amount Value";Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Budgeted Amount';
        }
        field(40;"Budget Filter";Code[10])
        {
            Caption = 'Budget Filter';
            FieldClass = FlowFilter;
            TableRelation = "G/L Budget Name";
        }
        field(42;"Acc Budgeted Amt";Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Acc Budgeted Amt';
        }
        field(43;"Monthly Budgeted Amt";Decimal)
        {
            Caption = 'Monthly Budgeted Amt';
        }
        field(44;"Yearly Budgeted Amt";Decimal)
        {
            Caption = 'Yearly Budgeted Amt';
        }
        field(45;"Monthly Commitment";Decimal)
        {
            Caption = 'Monthly Commitment';
        }
        field(46;"Acc Commitment";Decimal)
        {
            Caption = 'Acc Commitment';
        }
        field(47;"Monthly Realized Amt";Decimal)
        {
            Caption = 'Monthly Realized Amt';
        }
        field(48;"Acc Realized Amt";Decimal)
        {
            Caption = 'Acc Realized Amt';
        }
        field(49;"Monthly Available Amt";Decimal)
        {
            Caption = 'Monthly Available Amt';
        }
        field(50;"Acc Available Amt";Decimal)
        {
            Caption = 'Acc Available Amt';
        }
    }

    keys
    {
        key(Key1;"Document Type","Document No.","G/L Account No","Global Dimension 1")
        {
        }
    }

    fieldgroups
    {
    }
}

