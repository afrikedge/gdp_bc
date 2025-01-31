page 50352 "Print Bon Card"
{
    Caption = 'Imprimer';
    Editable = false;
    LinksAllowed = false;
    ShowFilter = false;
    SourceTable = pro_enteteBE;

    layout
    {
        area(content)
        {
            group("Général")
            {
                field(NumBU; Rec.NumBU)
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(ImprimerBE)
            {
                Caption = 'Imprimer BE';
                Image = PrintCover;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    EnteteBE: Record pro_enteteBE;
                begin
                    EnteteBE.SETRANGE(numBE, Rec.numBE);
                    EnteteBE.SetRange(NumBU, Rec.NumBU);
                    EnteteBE.SetRange(idtournee, Rec.idtournee);
                    REPORT.RUN(50190, TRUE, FALSE, EnteteBE);


                    //BonIsEditable:=FALSE;
                    //CurrPage.ACTIVATE;

                    PrintCrystal.PrintBE(Rec.numBE);

                    if not Rec.Imprime then begin
                        Rec.Imprime := true;
                        Rec."Nos Printed" := Rec."Nos Printed" + 1;
                        Rec."Last Printed Date" := CreateDateTime(Today, Time);
                        Rec.Modify;
                        //COMMIT;//********
                    end;
                end;
            }
            action(Imprimer)
            {
                Caption = 'Imprimer BL';
                Image = PrintForm;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    EnteteBL: Record pro_enteteBE;
                begin
                    EnteteBL.SETRANGE(numBL, Rec.numBL);
                    EnteteBL.SetRange(NumBU, Rec.NumBU);
                    EnteteBL.SetRange(idtournee, Rec.idtournee);
                    REPORT.RUN(50189, TRUE, FALSE, EnteteBL);

                    PrintCrystal.PrintBL(Rec.numBL);

                    RelatedBL.Get(Rec.numBL);
                    if not RelatedBL.Imprime then begin
                        RelatedBL.Imprime := true;
                        RelatedBL."Last Printed Date" := CreateDateTime(Today, Time);
                        RelatedBL.Modify;
                    end;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        //RefreshControls;
    end;

    var
        IncidentType: Option "Déviation","Changement de camion","Changement de chauffeur",Autre;
        Text001: Label 'Le bon sera annulé. Voulez-vous continuer ?';
        Text002: Label 'Impossible d''annuler ce bon car l''enlèvement a déjà été confirmé';
        NumBon: Code[20];
        PrintCrystal: Codeunit CRReports;
        RelatedBL: Record pro_enteteBL;
}

