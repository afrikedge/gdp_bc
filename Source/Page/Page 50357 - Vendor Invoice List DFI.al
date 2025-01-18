page 50357 "Vendor Invoice List DFI"
{
    Caption = 'Documents facture fournisseur en attente BAP';
    CardPageID = "Vendor Invoice Card Encours";
    Editable = false;
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Vendor Invoice Doc";
    SourceTableView = WHERE(Status = CONST(Validee));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Reference Number"; Rec."Reference Number")
                {
                }
                field("Vendor No"; Rec."Vendor No")
                {
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                }
                field("Vendor Invoice No."; Rec."Vendor Invoice No.")
                {
                }
                field("Invoice Date"; Rec."Invoice Date")
                {
                }
                field("Order No"; Rec."Order No")
                {
                }
                field(MontantTTC; Rec.MontantTTC)
                {
                }
                field(Type; Rec.Type)
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("Create By"; Rec."Create By")
                {
                }
                field("Creation Date"; Rec."Creation Date")
                {
                }
                field("Arrival Date"; Rec."Arrival Date")
                {
                }
                field("Due Date"; Rec."Due Date")
                {
                }
                field("Entry No"; Rec."Entry No")
                {
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control16; Links)
            {
            }
            systempart(Control15; Notes)
            {
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        //FILTERGROUP(2);
        //SETRANGE("Create By",USERID);
        //FILTERGROUP(0);
    end;
}

