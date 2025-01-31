pageextension 50088 "GD1 Fixed Asset Card" extends "Fixed Asset Card"
{
    layout
    {
        // Add custom fields to the General group
        addlast(General)
        {
            field(Codification; Rec.Codification)
            {
                ApplicationArea = All;
            }

            field(Quantity; Rec.Quantity)
            {
                ApplicationArea = All;
            }

            field("Startup Posting Date"; Rec."Startup Posting Date")
            {
                ApplicationArea = All;
                Editable = DateComptaMESIsEditable;
            }

            field("Startup Date"; Rec."Startup Date")
            {
                ApplicationArea = All;
            }

            field(Brand; Rec.Brand)
            {
                ApplicationArea = All;
            }

            field("FA Owner"; Rec."FA Owner")
            {
                ApplicationArea = All;
            }

            field("FA Type"; Rec."FA Type")
            {
                ApplicationArea = All;
            }

            field(State; Rec.State)
            {
                ApplicationArea = All;
            }

            field("FA Status"; Rec."FA Status")
            {
                ApplicationArea = All;
            }

            field(MiseEnService; Rec.MiseEnService)
            {
                ApplicationArea = All;
            }

            field("Old Number"; Rec."Old Number")
            {
                ApplicationArea = All;
            }
        }
        addafter("FA Location Code")
        {
            field("FA Location Name"; Rec."FA Location Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the name of the fixed asset location.';
            }

            field("FA Sub Location"; Rec."FA Sub Location")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the sub-location of the fixed asset.';
            }

            field("FA Sub Location Name"; Rec."FA Sub Location Name")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the name of the fixed asset sub-location.';
            }
        }
    }
    actions
    {
        addlast("Fixed &Asset")
        {
            action(StartupEntries)
            {
                Caption = 'Ecritures de mise en service';
                Image = EntriesList;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                var
                begin
                    FAMgt.ShowEcrituresMES(Rec);
                end;
            }

            action(FATransfers)
            {
                Caption = 'Historique déplacements';
                RunObject = Page "FA Transfer Entries";
                //RunPageView = SORTING("FA No.");
                RunPageLink = "FA No." = FIELD("No.");
                Image = MaintenanceLedgerEntries;
                Promoted = true;
                PromotedCategory = Category4;
                ApplicationArea = All;
            }
        }
        addafter(Acquire)
        {
            action(MiseEnServiceImmo)
            {
                Caption = 'Startup';
                Image = Continue;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                var
                begin
                    FAMgt.MiseEnService(Rec);
                end;
            }
        }
        addafter(Register)
        {
            action(Transfer)
            {
                Caption = 'Transfer';
                Ellipsis = true;
                Image = TransferFunds;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    TransferPage: Page "FA Transfer";
                begin
                    TransferPage.SetFA(Rec);
                    TransferPage.SetCodeImmo(Rec."No.");
                    TransferPage.RunModal;
                end;
            }
            action(EditionMiseEnService)
            {
                Caption = 'Etat de Mise en service';
                Image = "Report";
                Promoted = true;
                PromotedCategory = Category4;

                trigger OnAction()
                var
                    FixedAsset: Record "Fixed Asset";
                begin
                    //*******************************
                    FixedAsset.SetRange("No.", Rec."No.");
                    REPORT.RunModal(REPORT::"Fixed Asset - Mise en Serv", true, false, FixedAsset);
                end;
            }
            action(EditionTransfert)
            {
                Caption = 'Etat de transfert';
                Image = "Report";
                Promoted = true;
                PromotedCategory = Category4;

                trigger OnAction()
                var
                    FixedAsset: Record "Fixed Asset";
                begin
                    //*******************************
                    FixedAsset.SetRange("No.", Rec."No.");
                    REPORT.RunModal(REPORT::"Fixed Asset - Transf", true, false, FixedAsset);
                end;
            }
            action(EditionMiseRebut)
            {
                Caption = 'Etat de Mise En rebut';
                Image = "Report";
                Promoted = true;
                PromotedCategory = Category4;

                trigger OnAction()
                var
                    FixedAsset: Record "Fixed Asset";
                begin
                    //*******************************
                    FixedAsset.SetRange("No.", Rec."No.");
                    REPORT.RunModal(REPORT::"Fixed Asset - Rebut", true, false, FixedAsset);
                end;
            }
            action(EditionCession)
            {
                Caption = 'Etat de Cession Immo';
                Image = "Report";
                Promoted = true;
                PromotedCategory = Category4;

                trigger OnAction()
                var
                    FixedAsset: Record "Fixed Asset";
                begin
                    //*******************************
                    FixedAsset.SetRange("No.", Rec."No.");
                    REPORT.RunModal(REPORT::"Fixed Asset - Cession", true, false, FixedAsset);
                end;
            }
            action(GenerateCode)
            {
                Caption = 'Générate FA Code';
                Image = Calculate;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    NewCode: Code[30];
                begin
                    //******************************************
                    NewCode := FAMgt.GenerateCodeImmo(Rec);
                    if NewCode <> Rec.Codification then begin
                        Rec.Codification := NewCode;
                        Rec.Modify();
                    end;
                    //******************************************
                end;
            }
        }
    }
    var
        FAMgt: Codeunit "Fa Mgt";
        DateComptaMESIsEditable: Boolean;

    trigger OnAfterGetRecord()
    begin
        DateComptaMESIsEditable := Rec."Startup Date" = 0D;
    end;
}
