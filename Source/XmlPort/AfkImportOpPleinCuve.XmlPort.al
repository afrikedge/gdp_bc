namespace gdp_bc.gdp_bc;

xmlport 50010 "Afk Import Op Plein Cuve"
{
    Caption = 'Import Operation Plein Cuve';
    Direction = Import;
    Format = VariableText;
    TextEncoding = UTF8;
    FieldDelimiter = '<None>';
    FieldSeparator = '<TAB>';
    UseRequestPage = false;

    schema
    {
        textelement(RootNodeName)
        {
            tableelement("ImportDocument"; "Import Data")
            {
                SourceTableView = sorting("EntryNo") order(ascending);
                AutoSave = false;

                fieldattribute(CustNo; ImportDocument.CodeAnalytique) { }
                fieldattribute(StartingDate; ImportDocument.PostingDate) { }
                fieldattribute(EndingDate; ImportDocument.PostingDate2) { }
                //fieldattribute(Inactive; ImportDocument.Boolean1) { }



                trigger OnBeforeInsertRecord()
                var
                begin
                    i := i + 1;
                    Window.UPDATE(1,
                    ROUND(i / NbreTotalLignes * 10000, 1));

                    ImportDoc.Init();
                    ImportDoc."Customer No." := ImportDocument.CodeAnalytique;
                    // ImportDoc."Starting Date" := ImportDocument.PostingDate;
                    // ImportDoc."Ending Date" := ImportDocument.PostingDate2;
                    Evaluate(ImportDoc."Starting Date", CopyStr(ImportDocument.PostingDate, 1, 6));
                    Evaluate(ImportDoc."Ending Date", CopyStr(ImportDocument.PostingDate2, 1, 6));
                    //ImportDoc.Inactif := ImportDocument.Boolean1;
                    ImportDoc.Insert();

                    ProcessedLines := ProcessedLines + 1;

                end;
            }
        }
    }
    requestpage
    {
        layout
        {
            area(content)
            {
                // group(Options)
                // {
                //     field(NosOfLines; NbreTotalLignes)
                //     {
                //         ApplicationArea = All;
                //         Caption = 'Number of lines to import';
                //     }
                // }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
    trigger OnPreXmlPort()
    var
    begin
        i := 0;
        Window.OPEN(Text008);
        if (NbreTotalLignes = 0) then
            NbreTotalLignes := 300;


    end;

    trigger OnPostXmlPort()
    begin
        Window.Close();
        Message(StrSubstNo(LblEndOfProcess, ProcessedLines));
    end;

    var
        ImportDoc: Record "Afk Operation Plein Cuve";
        LblEndOfProcess: Label 'End of importation. %1 lines processed', Comment = '%1=...';
        i: Integer;
        NbreTotalLignes: Integer;
        ProcessedLines: Integer;
        Window: Dialog;
        Text008: Label 'Traitement @1@@@@@@@@@@@@@@@@@@@@@@@@@@@@\';
    //PriceListCode: Code[20];
    //NextLineNo: Integer;
}


