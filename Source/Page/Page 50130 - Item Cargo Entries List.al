page 50130 "Item Cargo Entries List"
{
    Caption = 'Item Cargo Entries';
    Editable = false;
    PageType = List;
    SourceTable = "Item Cargo Entry";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                }
                field("Posting Date"; Rec."Posting Date")
                {
                }
                field("Entry Type"; Rec."Entry Type")
                {
                }
                field("Ref Cargo"; Rec."Ref Cargo")
                {
                }
                field("Item No."; Rec."Item No.")
                {
                }
                field("Item Name"; Rec."Item Name")
                {
                }
                field("Document Type"; Rec."Document Type")
                {
                }
                field("Document No."; Rec."Document No.")
                {
                }
                field("Invoice No"; Rec."Invoice No")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field(Quantity; Rec.Quantity)
                {
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                }
                field("Cost Amount"; Rec."Cost Amount")
                {
                }
                field(Positive; Rec.Positive)
                {
                }
                field("Item Ledger Entry No."; Rec."Item Ledger Entry No.")
                {
                    Visible = false;
                }
                field("Cargo Type"; Rec."Cargo Type")
                {
                }
                field("Entry Date"; Rec."Entry Date")
                {
                }
                field("User ID"; Rec."User ID")
                {
                }
                field(Journal; Rec.Journal)
                {
                }
                field("Ref Dossier Cargo"; Rec."Ref Dossier Cargo")
                {
                }
                field("Sales Channel Code"; Rec."Sales Channel Code")
                {
                }
                field("Sales Channel Name"; Rec."Sales Channel Name")
                {
                }
                field("System Entry"; Rec."System Entry")
                {
                    Visible = false;
                }
                field("Adjustment Type"; Rec."Adjustment Type")
                {
                    Visible = false;
                }
                field(Source; Rec.Source)
                {
                    Visible = false;
                }
                field(Reversed; Rec.Reversed)
                {
                }
                field("Cargo Name"; Rec."Cargo Name")
                {
                }
                field("Cargo Adjusted"; Rec."Cargo Adjusted")
                {
                }
                field("Customer No."; Rec."Customer No.")
                {
                    Visible = false;
                }
                field("Initial Qty"; Rec."Initial Qty")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("&Navigate")
            {
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Navigate.SetDoc(Rec."Posting Date", Rec."Document No.");
                    Navigate.Run;
                end;
            }
            action(FeuilleCargo)
            {
                Caption = 'Feuille cargo';
                Image = AdjustEntries;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Cargo Journal";
            }
            action(AnnulerEcr)
            {
                Caption = 'Annuler écriture';
                Image = Cancel;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if not Confirm(StrSubstNo(Text001, Rec."Document No.")) then exit;
                    ReverseCargoEntry.SetCargoEntry(Rec);
                    ReverseCargoEntry.Run;
                end;
            }
            action(AffectationCargo)
            {
                Caption = 'Affectation cargo';
                Image = Allocations;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    ProcessAffectationCargo: Report "Process Affectation Cargo";
                begin
                    ProcessAffectationCargo.Run;
                end;
            }
            action(ItemEntries)
            {
                Caption = 'Item ledger entry';
                Image = Entries;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunObject = Page "Item Ledger Entries";
                RunPageLink = "Entry No." = FIELD("Item Ledger Entry No.");
            }
            action(ValueEntries)
            {
                Caption = 'Value entries';
                Image = EntriesList;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunObject = Page "Value Entries";
                RunPageLink = "Item Ledger Entry No." = FIELD("Item Ledger Entry No.");
            }
            action(Dimensions)
            {
                AccessByPermission = TableData Dimension = R;
                Caption = 'Dimensions';
                Image = Dimensions;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ShortCutKey = 'Shift+Ctrl+D';

                trigger OnAction()
                begin
                    Rec.ShowDimensions;
                    CurrPage.SaveRecord;
                end;
            }
            action(CargoList)
            {
                Caption = 'Cargo list';
                Image = BinJournal;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                RunObject = Page "Cargo List";
            }
            action(CargoContenu)
            {
                Caption = 'Contenu des cargaisons';
                Image = Bins;
                Promoted = true;
                PromotedCategory = Category5;
                PromotedIsBig = true;
                RunObject = Page "Contenu Cargo";
            }
            action("Migration stock cargo")
            {
                Caption = 'Migration stock cargo';
                Image = Translation;

                trigger OnAction()
                begin
                    MigrationCargo.Run;
                end;
            }
        }
    }

    var
        Navigate: Page Navigate;
        ReverseCargoEntry: Report "Reverse Cargo Entry";
        Text001: Label 'Voulez-vous annuler l''écriture %1?';
        MigrationCargo: Report "Process Migration Cargo";
}

