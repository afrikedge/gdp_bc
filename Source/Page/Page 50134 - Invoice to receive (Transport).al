page 50134 "Invoice to receive (Transport)"
{
    Caption = 'Invoice Tracking (Transport)';
    PageType = List;
    SourceTable = "Transfer Receipt Header";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    Editable = false;
                }
                field("Transfer Order No."; Rec."Transfer Order No.")
                {
                    Editable = false;
                }
                field("Transfer-from Code"; Rec."Transfer-from Code")
                {
                    Editable = false;
                }
                field("Transfer-from Name"; Rec."Transfer-from Name")
                {
                    Editable = false;
                }
                field("Transfer-to Code"; Rec."Transfer-to Code")
                {
                    Editable = false;
                }
                field("Transfer-to Name"; Rec."Transfer-to Name")
                {
                    Editable = false;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    Editable = false;
                }
                field("Receipt Date"; Rec."Receipt Date")
                {
                    Editable = false;
                }
                field("Truck Code"; Rec."Truck Code")
                {
                    Enabled = false;
                }
                field("Transporter Code"; Rec."Transporter Code")
                {
                    Editable = false;
                }
                field("Invoice Received"; Rec."Invoice Received")
                {
                }
                field("Invoice Number"; Rec."Invoice Number")
                {
                }
            }
        }
    }

    actions
    {
    }
}

