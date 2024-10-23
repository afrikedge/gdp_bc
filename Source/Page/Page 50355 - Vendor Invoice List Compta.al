page 50355 "Vendor Invoice List Compta"
{
    Caption = 'Vendor Invoice Doc on hold';
    CardPageID = "Vendor Invoice Card Encours";
    Description = 'WHERE(Status=FILTER(Receptionee|Rejetee|AttenteComptabilisation|Comptabilise|AttenteBAP|Payee))';
    Editable = false;
    PageType = List;
    SourceTable = "Vendor Invoice Doc";
    SourceTableView = WHERE(Status = FILTER(<> EnSaisie));

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
                field("Entry No"; Rec."Entry No")
                {
                    Visible = false;
                }
                field("Due Date"; Rec."Due Date")
                {
                }
                field("Send Email for rejection"; Rec."Send Email for rejection")
                {
                }
                field("Reason for rejection"; Rec."Reason for rejection")
                {
                }
                field("Reason for refusal"; Rec."Reason for refusal")
                {
                }
                field("Workflow Code"; Rec."Workflow Code")
                {
                }
                field("Validator Name"; Rec."Validator Name")
                {
                }
                field("Payment Date"; Rec."Payment Date")
                {
                }
                field("Payment Method Code"; Rec."Payment Method Code")
                {
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

