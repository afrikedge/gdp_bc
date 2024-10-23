page 50358 "Vendor Invoice List Treso"
{
    Caption = 'Vendor Invoice Doc on hold';
    CardPageID = "Vendor Invoice Card Encours";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    PageType = List;
    SourceTable = "Vendor Invoice Doc";
    SourceTableView = WHERE(Status = CONST(AttentePaiement));

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
                field(Devise; Rec.Devise)
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
        area(processing)
        {
            action("Insérer les lignes sélectionnées")
            {
                Caption = 'Insérer les lignes sélectionnées';
                Image = Allocations;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    ProcessLines;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        //FILTERGROUP(2);
        //SETRANGE("Create By",USERID);
        //FILTERGROUP(0);
    end;

    var
        ModeleFeuille: Code[10];
        NomFeuille: Code[10];
        AddOnSetup: Record "AddOn Setup";
        GenJrnLine: Record "Gen. Journal Line";
        GenJrnTemplate: Record "Gen. Journal Template";
        NoSeriesMgt: Codeunit NoSeriesManagement;
        GenJrnTableND: Record "Gen. Journal Batch";
        LineNum: Integer;
        LastDocNo: Code[20];
        Text001: Label 'La feuille %1 doit être vide pour effectuer cette opération !';
        "TxtTraitementTerminé": Label 'Traitement términé !';
        VendInvMgt: Codeunit VendorInvoiceMgt;

    local procedure ProcessLines()
    var
        VendLedEntry: Record "Vendor Ledger Entry";
    begin
        AddOnSetup.Get;
        GenJrnTableND.Get(ModeleFeuille, NomFeuille);
        GenJrnTemplate.Get(ModeleFeuille);
        LineNum := 10;

        GenJrnLine.Reset;
        GenJrnLine.SetRange("Journal Template Name", ModeleFeuille);
        GenJrnLine.SetRange("Journal Batch Name", NomFeuille);
        if GenJrnLine.FindFirst then Error(Text001, NomFeuille);

        CurrPage.SetSelectionFilter(Rec);
        if (Rec.FindFirst) then
            repeat

                GenJrnTableND.TestField("No. Series");
                Clear(NoSeriesMgt);

                if LastDocNo = '' then
                    LastDocNo := NoSeriesMgt.GetNextNo(GenJrnTableND."No. Series", GenJrnLine."Posting Date", false);
                Rec.TestField(Rec."Posted Invoice No");
                VendLedEntry.SetRange(VendLedEntry."Document No.", Rec."Posted Invoice No");
                VendLedEntry.FindFirst;

                VendInvMgt.InsertNewPayment(VendLedEntry, GenJrnLine, LineNum, LastDocNo, GenJrnTableND, GenJrnTemplate);

            until Rec.Next = 0;

        CurrPage.Close;
        //MESSAGE(TxtTraitementTerminé);
    end;

    procedure SetFeuille(CodeModele1: Code[10]; CodeFeuille1: Code[10])
    begin
        ModeleFeuille := CodeModele1;
        NomFeuille := CodeFeuille1;
    end;
}

