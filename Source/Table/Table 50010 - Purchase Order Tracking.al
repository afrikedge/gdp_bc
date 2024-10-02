table 50010 "Purchase Order Tracking"
{

    fields
    {
        field(1;"Document Type";Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        }
        field(2;"Document No.";Code[20])
        {
            Caption = 'No.';
        }
        field(3;"Line No.";Integer)
        {
            Caption = 'N° Line No';
        }
        field(4;"Data Type";Option)
        {
            Caption = 'Data Type';
            OptionCaption = 'Tracking,Charge Item';
            OptionMembers = Suivi,FraisAnnexe;
        }
        field(5;"Tracking Type";Option)
        {
            Caption = 'Type';
            OptionCaption = 'Note,Step';
            OptionMembers = Note,Step;
        }
        field(6;"Information Code";Code[20])
        {
            Caption = 'Information Code';
            TableRelation = "PO Tracking Information";

            trigger OnValidate()
            begin
                if TypeInfos.Get(Rec."Information Code") then
                  "Information Descr":=TypeInfos.Description;
            end;
        }
        field(7;Status;Option)
        {
            Caption = 'Status';
            OptionCaption = 'Open,Closed';
            OptionMembers = Encours,Cloture;
        }
        field(8;Alert;Boolean)
        {
            Caption = 'Alert';
        }
        field(9;Alerted;Boolean)
        {
            Caption = 'Alerted';
            Editable = false;
        }
        field(10;"Warning Date";Date)
        {
            Caption = 'Warning Date';
        }
        field(11;"Due Date";Date)
        {
            Caption = 'Due Date';
        }
        field(12;Notes;Text[150])
        {
            Caption = 'Notes';
        }
        field(13;"FA Amount";Decimal)
        {
            Caption = 'Amount (AR)';

            trigger OnValidate()
            begin
                if "Provision Invoice"<>'' then Error(Text001);
            end;
        }
        field(14;"FA Code";Code[20])
        {
            Caption = 'Charge itemCode';
            TableRelation = "Item Charge";

            trigger OnValidate()
            begin
                if "Provision Invoice"<>'' then Error(Text001);

                if FraisAnn.Get("FA Code") then
                  if "Vendor Code"='' then
                    Validate("Vendor Code",FraisAnn."Vendor No");
            end;
        }
        field(15;"Information Descr";Text[60])
        {
            Caption = 'Information';
        }
        field(16;"Order";Integer)
        {
            Caption = 'Order';
        }
        field(17;"FA Name";Text[50])
        {
            CalcFormula = Min("Item Charge".Description WHERE ("No."=FIELD("FA Code")));
            Caption = 'Charge Item Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(18;"Vendor Code";Code[20])
        {
            Caption = 'Vendor Name';
            TableRelation = Vendor;

            trigger OnValidate()
            begin
                if Vend.Get(Rec."Vendor Code") then
                  Rec."Vendor Name":=Vend.Name;
            end;
        }
        field(19;"Vendor Name";Text[50])
        {
            Caption = 'Vendor Name';
            Editable = false;
        }
        field(20;Provisioned;Boolean)
        {
            Caption = 'Provisions';
            Editable = false;
        }
        field(21;"Provision Invoice";Code[20])
        {
            Caption = 'Provisions Invoice';
            Editable = false;
        }
        field(22;"Provision Posted Invoice";Code[20])
        {
            Caption = 'Provisions Posted Invoice';
            Editable = false;
        }
    }

    keys
    {
        key(Key1;"Document Type","Document No.","Line No.")
        {
        }
        key(Key2;"Data Type")
        {
        }
    }

    fieldgroups
    {
    }

    var
        TypeInfos: Record "PO Tracking Information";
        Vend: Record Vendor;
        FraisAnn: Record "Item Charge";
        Text001: Label 'La ligne fait déjà partie d''une facture de provisions de frais annexes';
}

