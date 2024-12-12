tableextension 50009 "A02 Item" extends Item
{
    fields
    {
        field(50000; "OMH Fees Price"; Decimal)
        {
            Caption = 'OMH Fees Price';
        }
        field(50001; "FER Fees Price"; Decimal)
        {
            Caption = 'FER Fees Price';
        }
        field(50002; "ENV Fees Price"; Decimal)
        {
            Caption = 'ENV Fees Price';
        }
        field(50003; "ToCharge %"; Decimal)
        {
            Caption = 'To be charged %';
        }
        field(50004; "ToCharge Item"; Code[20])
        {
            Caption = 'Service To be charged %';
            TableRelation = Item WHERE(Type = CONST(Service));
        }
        field(50005; "Validation Status"; Option)
        {
            Caption = 'Validation status';
            Editable = false;
            OptionCaption = 'Created,In WorkflowCDG,Validated,InWorkflowFOUR,InWorkflowCDC';
            OptionMembers = Created,InWorkflowCDG,Validated,InWorkflowFOUR,InWorkflowCDC;
        }
        field(50006; "RDS Fees Price"; Decimal)
        {
            Caption = 'Redevance de Dév du Secteur (RDS)';
        }
        field(50009; "Sales Category Code"; Code[10])
        {
            Caption = 'Sales Category';
            TableRelation = "Sales Category";
        }
        field(50015; "Created By UserID"; Code[50])
        {
            Caption = 'Created By';
            Editable = false;
        }
        field(50016; "Created By Date"; Date)
        {
            Caption = 'Creation Date';
            Editable = false;
        }
        field(50017; "Validated By UserID"; Code[50])
        {
            Caption = 'Validated By';
            Editable = false;
        }
        field(50018; "Validated By Date"; Date)
        {
            Caption = 'Validation Date';
            Editable = false;
        }
        field(50019; "Cargo Mgt"; Boolean)
        {
            Caption = 'Cargo Mgt';
        }
        field(50020; "Qty. in Transit AFK"; Decimal)
        {
            FieldClass = FlowField;
            CalcFormula = Sum("Adjustment Line"."Qty. in Transit (Base)" WHERE("Item No." = FIELD("No."),
                                                                                "Transfer-to Code" = FIELD("Location Filter"),
                                                                                Status = CONST(Released),
                                                                                "Shortcut Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                                "Shortcut Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                                "Receipt Date" = FIELD("Date Filter")));
            Caption = 'Qty. in Transit';
            DecimalPlaces = 0 : 5;
            Editable = false;

        }
        field(50021; "Validated CDG By UserID"; Code[50])
        {
            Caption = 'Validated By';
            Editable = false;
        }
        field(50022; "Validated CDG By Date"; Date)
        {
            Caption = 'Validation Date';
            Editable = false;
        }
        field(50023; "Shipment Group"; Option)
        {
            Caption = 'Shipment Group';
            OptionCaption = ' ,GO,SC,PL,FO';
            OptionMembers = " ",GO,SC,PL,FO;
        }
        field(50024; "VAT Correction"; Boolean)
        {
            Caption = 'Correction TVA Redevances';
        }
        field(50025; "Parent Category"; Code[20])
        {
            Caption = 'Catégorie';
            FieldClass = FlowField;
            CalcFormula = lookup("Item Category"."Parent Category" where(Code = field("Item Category Code")));
            Editable = false;
        }
    }
    keys
    {
        key(A02Key1; "Item Category Code")
        {
        }
    }

    //Unsupported feature: Property Modification (Fields) on "DropDown(FieldGroup 1)".

    procedure GetParentCategory(): Code[20]
    var
        ItemCat: Record "Item Category";
    begin
        if (ItemCat.Get(Rec."Item Category Code")) then
            exit(ItemCat."Parent Category");
    end;

}

