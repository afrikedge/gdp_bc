page 50335 "Dispaching Events"
{
    Caption = 'Dispaching Statistiques';
    DataCaptionExpression = MonthName;
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    ModifyAllowed = false;
    SaveValues = true;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group("Général")
            {
                Caption = 'Général';
                Visible = false;
                field(MonthName; MonthName)
                {
                    Visible = false;
                }
            }
            part(DispachEventMatrix; "Dispach Event Matrix")
            {
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("Previous Period")
            {
                Caption = 'Previous Period';
                Image = PreviousRecord;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    //IF (LineDimOption = LineDimOption::Period) OR (ColumnDimOption = ColumnDimOption::Period) THEN
                    //  EXIT;
                    //FindPeriod('<');
                    ActualDate := CalcDate('<-1M>', ActualDate);
                    MonthName := GLMgt.GetDescrMois(ActualDate);
                    CurrPage.Update;
                    CurrPage.DispachEventMatrix.PAGE.LoadData(ActualDate);
                    //UpdateMatrixSubform;
                end;
            }
            action("Next Period")
            {
                Caption = 'Next Period';
                Image = NextRecord;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    //IF (LineDimOption = LineDimOption::Period) OR (ColumnDimOption = ColumnDimOption::Period) THEN
                    //  EXIT;
                    //FindPeriod('>');
                    ActualDate := CalcDate('<1M>', ActualDate);
                    MonthName := GLMgt.GetDescrMois(ActualDate);
                    CurrPage.Update;
                    //UpdateMatrixSubform;
                    CurrPage.DispachEventMatrix.PAGE.LoadData(ActualDate);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        ActualDate := GLMgt.GetDebutMois(WorkDate, 0);
        MonthName := GLMgt.GetDescrMois(ActualDate);
        CurrPage.Update;
        //UpdateMatrixSubform;
        CurrPage.DispachEventMatrix.PAGE.LoadData(ActualDate);
    end;

    var
        GLMgt: Codeunit "GL Mgt";
        MonthName: Text;
        ActualMonth: Integer;
        ActualYear: Integer;
        ActualDate: Date;


}

