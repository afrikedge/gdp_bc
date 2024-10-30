page 50137 "Letter of Credit"
{
    Caption = 'Letter of credit';
    PageType = Document;
    SourceTable = "Letter of credit";
    SourceTableView = WHERE(Status = CONST(Open));
    ApplicationArea = All;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            group("Général")
            {
                field("No."; Rec."No.")
                {
                }
                field("Letter of Credit Ref"; Rec."Letter of Credit Ref")
                {
                }
                field("Vendor No."; Rec."Vendor No.")
                {
                }
                field("Vendor Name"; Rec."Vendor Name")
                {
                }
                field("Document Date"; Rec."Document Date")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("Bank Account"; Rec."Bank Account")
                {
                }
                field("Bank Name"; Rec."Bank Name")
                {
                }
                field("Currency Code"; Rec."Currency Code")
                {
                }
                field("CIF Amount"; Rec."CIF Amount")
                {
                }
                field("BL Date"; Rec."BL Date")
                {
                }
                field(Status; Rec.Status)
                {
                }
                field("Payment Terms Code"; Rec."Payment Terms Code")
                {
                }
                field("Due Date"; Rec."Due Date")
                {
                }
                field("Purchase rate"; Rec."Purchase rate")
                {
                }
                field("Structure rate"; Rec."Structure rate")
                {
                }
                field("Purchase Quote Amount"; Rec."Purchase Quote Amount")
                {
                }
                field("Vendor Invoice Number"; Rec."Vendor Invoice Number")
                {
                }
                field("Invoice Amount"; Rec."Invoice Amount")
                {
                }
                field("Total Purchased"; Rec."Total Purchased")
                {
                }
                field("Total Purchased (LCY)"; Rec."Total Purchased (LCY)")
                {
                }
                field("Provisions %"; Rec."Provisions %")
                {
                }
                field("Provisions Amount"; Rec."Provisions Amount")
                {
                }
                field("Total Purchased Prov."; Rec."Total Purchased Prov.")
                {
                }
                field("Total Purchased Prov. (LCY)"; Rec."Total Purchased Prov. (LCY)")
                {
                }
                field("Paiement Echeance Jrnal"; Rec."Paiement Echeance Jrnal")
                {
                }
                field("Currency Purchase Jrnal"; Rec."Currency Purchase Jrnal")
                {
                }
                field("Accreditif Bank Account"; Rec."Accreditif Bank Account")
                {
                }
            }
            part(Control1000000022; "LC Steps Subform")
            {
                SubPageLink = "Document No." = FIELD("No.");
            }
            part(Control1000000023; "LC Currency Purchase Subform")
            {
                SubPageLink = "Document No." = FIELD("No.");
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Cloturer)
            {
                Caption = 'Close Document';
                Image = Close;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ComptaMgt.CloseLetterOfCredit(Rec);
                end;
            }
            action(Calculate)
            {
                Caption = 'Calculate';
                Ellipsis = true;
                Image = Calculate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Rec.CalcValues;
                end;
            }
            separator(Separator1000000031)
            {
            }
            action(AddAchatDevise)
            {
                Caption = 'Add Currency purchase';
                Image = Purchase;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;

                trigger OnAction()
                begin
                    //ComptaMgt.GenerateEcritureAchatDevise(Rec);
                end;
            }
            action("Open Journal")
            {
                Caption = 'Open Journal';
                Image = Journals;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Cash Receipt Journal";
            }
        }
    }

    var
        ComptaMgt: Codeunit "Treso Mgt";
}

