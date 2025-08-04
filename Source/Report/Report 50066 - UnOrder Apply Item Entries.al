report 50066 "UnOrder Apply Item Entries"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Source/Report/Layout/UnOrder Apply Item Entries.rdlc';
    Caption = 'Lettrage article incorrect';
    ApplicationArea = All;

    dataset
    {
        dataitem("Item Ledger Entry"; "Item Ledger Entry")
        {
            PrintOnlyIfDetail = true;
            RequestFilterFields = "Item No.", "Location Code", "Item Category Code";
            dataitem("Item Application Entry"; "Item Application Entry")
            {
                DataItemLink = "Outbound Item Entry No." = FIELD("Entry No.");
                DataItemTableView = SORTING("Outbound Item Entry No.", "Item Ledger Entry No.", "Cost Application", "Transferred-from Entry No.") WHERE("Outbound Item Entry No." = FILTER(> 0));
                column(CodeArticle; CodeArticle)
                {
                }
                column(CodeMagasin; CodeMagasin)
                {
                }
                column(DateEntree; DateEntree)
                {
                }
                column(NumEntree; NumEntree)
                {
                }
                column(DocEntree; DocEntree)
                {
                }
                column(DateSortie; DateSortie)
                {
                }
                column(NumSortie; NumSortie)
                {
                }
                column(DocSortie; DocSortie)
                {
                }
                column(NatureLigne; NatureLigne)
                {
                }
                column(Qte; Qte)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    ILEEntree.Get("Item Application Entry"."Inbound Item Entry No.");
                    if ILEEntree."Item Category Code" <> CategoryCode then CurrReport.Skip;

                    ILESortie.Get("Item Application Entry"."Outbound Item Entry No.");

                    NatureLigne := '';
                    if ((ILEEntree."Posting Date" > EvaluationDate) and (ILESortie."Posting Date" <= EvaluationDate)) then
                        NatureLigne := 'AVANT';

                    if ((ILEEntree."Posting Date" <= EvaluationDate) and (ILESortie."Posting Date" > EvaluationDate)) then
                        NatureLigne := 'APRES';

                    Qte := -"Item Application Entry".Quantity;

                    NumEntree := ILEEntree."Entry No.";
                    NumSortie := ILESortie."Entry No.";

                    DocEntree := ILEEntree."Document No.";
                    DocSortie := ILESortie."Document No.";

                    DateEntree := ILEEntree."Posting Date";
                    DateSortie := ILESortie."Posting Date";

                    CodeArticle := ILEEntree."Item No.";
                    CodeMagasin := ILEEntree."Location Code";

                    if NatureLigne = '' then
                        CurrReport.Skip;
                end;

                trigger OnPreDataItem()
                begin
                    if CategoryCode = '' then Error(Text001);
                    if EvaluationDate = 0D then Error(Text002);
                end;
            }
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                field(EvaluationDate; EvaluationDate)
                {
                    Caption = 'Date d''évaluation';
                }
                field(CategoryCode; CategoryCode)
                {
                    Caption = 'Code catégorie';
                    TableRelation = "Item Category";
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        Apply: Codeunit "Item Jnl.-Post Line";
        EvaluationDate: Date;
        CategoryCode: Code[20];
        Text001: Label 'Code catégorie invalide!';
        CodeArticle: Code[20];
        CodeMagasin: Code[20];
        DateEntree: Date;
        NumEntree: Integer;
        DocEntree: Code[20];
        DateSortie: Date;
        NumSortie: Integer;
        DocSortie: Code[20];
        ILEEntree: Record "Item Ledger Entry";
        ILESortie: Record "Item Ledger Entry";
        NatureLigne: Code[20];
        Qte: Decimal;
        Text002: Label 'Date d''évaluation invalide!';

    local procedure RemoveApplications(Inbound: Integer; OutBound: Integer)
    var
        Application: Record "Item Application Entry";
    begin
        Application.SetCurrentKey("Inbound Item Entry No.", "Outbound Item Entry No.");
        Application.SetRange("Inbound Item Entry No.", Inbound);
        Application.SetRange("Outbound Item Entry No.", OutBound);
        if Application.Find('-') then
            repeat
                Apply.UnApply(Application);
            until Application.Next = 0;
    end;
}

