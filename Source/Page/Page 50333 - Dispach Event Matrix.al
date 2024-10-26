page 50333 "Dispach Event Matrix"
{
    Caption = 'Dispaching Event Matrix';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = ListPart;
    SaveValues = true;
    SourceTable = pro_moyentransport;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(TransporterName; Rec.NomDispaching)
                {
                    Caption = 'Tramsporter';
                }
                field(immatriculation; Rec.immatriculation)
                {
                    Editable = false;
                }
                field(Field1; MATRIX_CellData[1])
                {
                    CaptionClass = '3,' + MATRIX_CaptionSet[1];
                    Editable = false;
                    StyleExpr = TRUE;
                    Width = 10;

                    trigger OnDrillDown()
                    begin
                        MATRIX_OnDrillDown(1);
                    end;
                }
                field(Field2; MATRIX_CellData[2])
                {
                    CaptionClass = '3,' + MATRIX_CaptionSet[2];
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        MATRIX_OnDrillDown(2);
                    end;
                }
                field(Field3; MATRIX_CellData[3])
                {
                    CaptionClass = '3,' + MATRIX_CaptionSet[3];
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        MATRIX_OnDrillDown(3);
                    end;
                }
                field(Field4; MATRIX_CellData[4])
                {
                    CaptionClass = '3,' + MATRIX_CaptionSet[4];
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        MATRIX_OnDrillDown(4);
                    end;
                }
                field(Field5; MATRIX_CellData[5])
                {
                    CaptionClass = '3,' + MATRIX_CaptionSet[5];
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        MATRIX_OnDrillDown(5);
                    end;
                }
                field(Field6; MATRIX_CellData[6])
                {
                    CaptionClass = '3,' + MATRIX_CaptionSet[6];
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        MATRIX_OnDrillDown(6);
                    end;
                }
                field(Field7; MATRIX_CellData[7])
                {
                    CaptionClass = '3,' + MATRIX_CaptionSet[7];
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        MATRIX_OnDrillDown(7);
                    end;
                }
                field(Field8; MATRIX_CellData[8])
                {
                    CaptionClass = '3,' + MATRIX_CaptionSet[8];
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        MATRIX_OnDrillDown(8);
                    end;
                }
                field(Field9; MATRIX_CellData[9])
                {
                    CaptionClass = '3,' + MATRIX_CaptionSet[9];
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        MATRIX_OnDrillDown(9);
                    end;
                }
                field(Field10; MATRIX_CellData[10])
                {
                    CaptionClass = '3,' + MATRIX_CaptionSet[10];
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        MATRIX_OnDrillDown(10);
                    end;
                }
                field(Field11; MATRIX_CellData[11])
                {
                    CaptionClass = '3,' + MATRIX_CaptionSet[11];
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        MATRIX_OnDrillDown(11);
                    end;
                }
                field(Field12; MATRIX_CellData[12])
                {
                    CaptionClass = '3,' + MATRIX_CaptionSet[12];
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        MATRIX_OnDrillDown(12);
                    end;
                }
                field(Field13; MATRIX_CellData[13])
                {
                    CaptionClass = '3,' + MATRIX_CaptionSet[13];
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        MATRIX_OnDrillDown(13);
                    end;
                }
                field(Field14; MATRIX_CellData[14])
                {
                    CaptionClass = '3,' + MATRIX_CaptionSet[14];
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        MATRIX_OnDrillDown(14);
                    end;
                }
                field(Field15; MATRIX_CellData[15])
                {
                    CaptionClass = '3,' + MATRIX_CaptionSet[15];
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        MATRIX_OnDrillDown(15);
                    end;
                }
                field(Field16; MATRIX_CellData[16])
                {
                    CaptionClass = '3,' + MATRIX_CaptionSet[16];
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        MATRIX_OnDrillDown(16);
                    end;
                }
                field(Field17; MATRIX_CellData[17])
                {
                    CaptionClass = '3,' + MATRIX_CaptionSet[17];
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        MATRIX_OnDrillDown(17);
                    end;
                }
                field(Field18; MATRIX_CellData[18])
                {
                    CaptionClass = '3,' + MATRIX_CaptionSet[18];
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        MATRIX_OnDrillDown(18);
                    end;
                }
                field(Field19; MATRIX_CellData[19])
                {
                    CaptionClass = '3,' + MATRIX_CaptionSet[19];
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        MATRIX_OnDrillDown(19);
                    end;
                }
                field(Field20; MATRIX_CellData[20])
                {
                    CaptionClass = '3,' + MATRIX_CaptionSet[20];
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        MATRIX_OnDrillDown(20);
                    end;
                }
                field(Field21; MATRIX_CellData[21])
                {
                    CaptionClass = '3,' + MATRIX_CaptionSet[21];
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        MATRIX_OnDrillDown(21);
                    end;
                }
                field(Field22; MATRIX_CellData[22])
                {
                    CaptionClass = '3,' + MATRIX_CaptionSet[22];
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        MATRIX_OnDrillDown(22);
                    end;
                }
                field(Field23; MATRIX_CellData[23])
                {
                    CaptionClass = '3,' + MATRIX_CaptionSet[23];
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        MATRIX_OnDrillDown(23);
                    end;
                }
                field(Field24; MATRIX_CellData[24])
                {
                    CaptionClass = '3,' + MATRIX_CaptionSet[24];
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        MATRIX_OnDrillDown(24);
                    end;
                }
                field(Field25; MATRIX_CellData[25])
                {
                    CaptionClass = '3,' + MATRIX_CaptionSet[25];
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        MATRIX_OnDrillDown(25);
                    end;
                }
                field(Field26; MATRIX_CellData[26])
                {
                    CaptionClass = '3,' + MATRIX_CaptionSet[26];
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        MATRIX_OnDrillDown(26);
                    end;
                }
                field(Field27; MATRIX_CellData[27])
                {
                    CaptionClass = '3,' + MATRIX_CaptionSet[27];
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        MATRIX_OnDrillDown(27);
                    end;
                }
                field(Field28; MATRIX_CellData[28])
                {
                    CaptionClass = '3,' + MATRIX_CaptionSet[28];
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        MATRIX_OnDrillDown(28);
                    end;
                }
                field(Field29; MATRIX_CellData[29])
                {
                    CaptionClass = '3,' + MATRIX_CaptionSet[29];
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        MATRIX_OnDrillDown(29);
                    end;
                }
                field(Field30; MATRIX_CellData[30])
                {
                    CaptionClass = '3,' + MATRIX_CaptionSet[30];
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        MATRIX_OnDrillDown(30);
                    end;
                }
                field(Field31; MATRIX_CellData[31])
                {
                    CaptionClass = '3,' + MATRIX_CaptionSet[31];
                    Editable = false;

                    trigger OnDrillDown()
                    begin
                        MATRIX_OnDrillDown(31);
                    end;
                }
                field(TotalLivrNormales; TotalLivrNormales)
                {
                    Caption = 'Nombre liv. normales';
                    Editable = false;
                }
                field(TotalLivrAppoint; TotalLivrAppoint)
                {
                    Caption = 'Nombre appoint';
                    Editable = false;
                }
                field(TotalLivrJIRAMA; TotalLivrJIRAMA)
                {
                    Caption = 'JIRAMA';
                    Editable = false;
                }
                field(TotalLivr; TotalLivr)
                {
                    Caption = 'Nombre voyages';
                    Editable = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    var
        DispachEntry: Record "Dispaching Event";
        ChaineReponse: Text;
        i: Integer;
        FilterDate: Date;
        finMois: Date;
        debMois: Date;
        NbreLivrNormales: Integer;
        NbreLivrAppoint: Integer;
        NbreLivrJIRAMA: Integer;
        NbreLivrNormalesMois: Integer;
        NbreLivrAppointMois: Integer;
        NbreLivrJIRAMAMois: Integer;
        j: Integer;
    begin
        for i := 1 to 31 do begin
            ChaineReponse := '';

            debMois := DMY2Date(1, Date2DMY(ActualDate, 2), Date2DMY(ActualDate, 3));
            finMois := GetFinMois(debMois);

            if (i > Date2DMY(finMois, 1)) then
                exit;

            FilterDate := DMY2Date(i, Date2DMY(ActualDate, 2), Date2DMY(ActualDate, 3));


            //Livraisons
            NbreLivrNormales := 0;
            NbreLivrAppoint := 0;
            NbreLivrJIRAMA := 0;
            LivrMgt.GetNbreLivrCamions(Rec.immatriculation, FilterDate, FilterDate, NbreLivrNormales, NbreLivrAppoint, NbreLivrJIRAMA);
            for j := 1 to NbreLivrNormales do begin
                ChaineReponse := ChaineReponse + 'O';
            end;

            if NbreLivrJIRAMA > 0 then
                if ChaineReponse = '' then
                    ChaineReponse := 'JIR'
                else
                    ChaineReponse := ChaineReponse + '/' + 'JIR';

            if NbreLivrAppoint > 0 then
                if ChaineReponse = '' then
                    ChaineReponse := 'APP'
                else
                    ChaineReponse := ChaineReponse + '/' + 'APP';

            //Commentaires et incidents
            DispachEntry.Reset;
            DispachEntry.SetRange(immatriculation, Rec.immatriculation);
            DispachEntry.SetRange(DispachEntry.Date, FilterDate);
            if DispachEntry.FindFirst then
                repeat

                    if DispachEntry.Type = DispachEntry.Type::Comment then
                        if not (StrPos('...', ChaineReponse) > 0) then
                            if ChaineReponse = '' then
                                ChaineReponse := '...'
                            else
                                ChaineReponse := ChaineReponse + '/' + '...';

                    if DispachEntry.Type = DispachEntry.Type::DispachEvent then
                        if not (StrPos(DispachEntry."Event Code", ChaineReponse) > 0) then
                            if ChaineReponse = '' then
                                ChaineReponse := DispachEntry."Event Code"
                            else
                                ChaineReponse := ChaineReponse + '/' + DispachEntry."Event Code";

                until DispachEntry.Next = 0;

            MATRIX_CellData[i] := ChaineReponse;
        end;

        NbreLivrNormalesMois := 0;
        NbreLivrAppointMois := 0;
        NbreLivrJIRAMAMois := 0;
        LivrMgt.GetNbreLivrCamions(Rec.immatriculation, debMois, finMois, NbreLivrNormalesMois, NbreLivrAppointMois, NbreLivrJIRAMAMois);
        TotalLivrNormales := NbreLivrNormalesMois;
        TotalLivrAppoint := NbreLivrAppointMois;
        TotalLivrJIRAMA := NbreLivrJIRAMAMois;
        TotalLivr := TotalLivrNormales + TotalLivrAppoint + TotalLivrJIRAMA;
    end;

    trigger OnOpenPage()
    begin
        ActualDate := WorkDate;
    end;

    var
        MATRIX_CurrentNoOfMatrixColumn: Integer;
        MATRIX_CellData: array[31] of Text;
        Transporter: Text[50];
        ActualMonth: Integer;
        ActualDate: Date;
        MATRIX_CaptionSet: array[31] of Text[80];
        LivrMgt: Codeunit "Logistique Mgt";
        TotalLivrNormales: Integer;
        TotalLivrAppoint: Integer;
        TotalLivrJIRAMA: Integer;
        TotalLivr: Integer;

    local procedure MATRIX_OnDrillDown(MATRIX_ColumnOrdinal: Integer)
    var
        DispachingEvent: Record "Dispaching Event";
        FilterDate: Date;
        ADate: Date;
        finMois: Date;
        debMois: Date;
    begin
        /*
        MATRIX_MatrixRecord := MatrixRecords[MATRIX_ColumnOrdinal];
        SetCommonFilters(GLAccBudgetBuf);
        SetDimFilters(GLAccBudgetBuf,0);
        SetDimFilters(GLAccBudgetBuf,1);
        BudgetDrillDown;
        */

        debMois := DMY2Date(1, Date2DMY(ActualDate, 2), Date2DMY(ActualDate, 3));
        finMois := GetFinMois(debMois);

        if (MATRIX_ColumnOrdinal <= Date2DMY(finMois, 1)) then begin

            FilterDate := DMY2Date(MATRIX_ColumnOrdinal, Date2DMY(ActualDate, 2), Date2DMY(ActualDate, 3));
            DispachingEvent.SetRange(immatriculation, Rec.immatriculation);
            DispachingEvent.SetRange(Date, FilterDate);
            PAGE.Run(0, DispachingEvent);

        end;

    end;

    procedure LoadData(ActDate: Date)
    var
        i: Integer;
    begin

        ActualDate := ActDate;


        for i := 1 to 31 do begin

            MATRIX_CaptionSet[i] := GetTexteJour(i);
            //MatrixRecords[i] := MatrixRecords1[i];
        end;
    end;

    local procedure GetTexteJour(jour: Integer): Text
    var
        Text01: Label 'Lun';
        Text02: Label 'Mar';
        Text03: Label 'Mer';
        Text04: Label 'Jeu';
        Text05: Label 'Ven';
        Text06: Label 'Sam';
        Text07: Label 'Dim';
        ADate: Date;
        finMois: Date;
        debMois: Date;
    begin

        debMois := DMY2Date(1, Date2DMY(ActualDate, 2), Date2DMY(ActualDate, 3));
        finMois := GetFinMois(debMois);

        if (jour > Date2DMY(finMois, 1)) then
            exit('N/A');

        ADate := DMY2Date(jour, Date2DMY(ActualDate, 2), Date2DMY(ActualDate, 3));

        if Date2DWY(ADate, 1) = 1 then exit(StrSubstNo('%1 %2', Text01, jour));
        if Date2DWY(ADate, 1) = 2 then exit(StrSubstNo('%1 %2', Text02, jour));
        if Date2DWY(ADate, 1) = 3 then exit(StrSubstNo('%1 %2', Text03, jour));
        if Date2DWY(ADate, 1) = 4 then exit(StrSubstNo('%1 %2', Text04, jour));
        if Date2DWY(ADate, 1) = 5 then exit(StrSubstNo('%1 %2', Text05, jour));
        if Date2DWY(ADate, 1) = 6 then exit(StrSubstNo('%1 %2', Text06, jour));
        if Date2DWY(ADate, 1) = 7 then exit(StrSubstNo('%1 %2', Text07, jour));
    end;

    procedure GetFinMois(DateRef: Date): Date
    var
        Date1: Date;
    begin
        //Fin du mois de paie
        if DateRef <> 0D then begin
            Date1 := GetDebutMois(DateRef, 0);
            exit(CalcDate('<1M>', Date1) - 1);
        end;
    end;

    procedure GetDebutMois(DateRef: Date; AnneesRef: Integer): Date
    begin
        if DateRef <> 0D then
            exit(DMY2Date(1, Date2DMY(DateRef, 2), Date2DMY(DateRef, 3) - AnneesRef));   //Debut de l'année de DateRef - AnneeRef
    end;
}

