report 50162 UpdateJournal
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Gen. Journal Line";"Gen. Journal Line")
        {

            trigger OnAfterGetRecord()
            begin
                    BesoinNo := BesoinNo + 1;
                    Window.Update(1,
                    Round(BesoinNo / NbreTotalLignes * 10000,1));
                
                
                //"Gen. Journal Line"."External Document No.":=
                //COPYSTR("Gen. Journal Line"."External Document No."+
                //' '+"Gen. Journal Line"."Document No.",1,35);
                
                /*
                IF DATE2DMY("Gen. Journal Line"."Posting Date",1) IN [1..3] THEN
                  "Gen. Journal Line"."Document No." := getDocNo(1,"Gen. Journal Line"."Posting Date");
                
                IF DATE2DMY("Gen. Journal Line"."Posting Date",1) IN [4..7] THEN
                  "Gen. Journal Line"."Document No." := getDocNo(2,"Gen. Journal Line"."Posting Date");
                
                IF DATE2DMY("Gen. Journal Line"."Posting Date",1) IN [8..11] THEN
                  "Gen. Journal Line"."Document No." := getDocNo(3,"Gen. Journal Line"."Posting Date");
                
                IF DATE2DMY("Gen. Journal Line"."Posting Date",1) IN [12..15] THEN
                  "Gen. Journal Line"."Document No." := getDocNo(4,"Gen. Journal Line"."Posting Date");
                
                IF DATE2DMY("Gen. Journal Line"."Posting Date",1) IN [16..19] THEN
                  "Gen. Journal Line"."Document No." := getDocNo(5,"Gen. Journal Line"."Posting Date");
                
                IF DATE2DMY("Gen. Journal Line"."Posting Date",1) IN [20..22] THEN
                  "Gen. Journal Line"."Document No." := getDocNo(6,"Gen. Journal Line"."Posting Date");
                
                IF DATE2DMY("Gen. Journal Line"."Posting Date",1) IN [23..26] THEN
                  "Gen. Journal Line"."Document No." := getDocNo(7,"Gen. Journal Line"."Posting Date");
                
                IF DATE2DMY("Gen. Journal Line"."Posting Date",1) IN [27..31] THEN
                  "Gen. Journal Line"."Document No." := getDocNo(8,"Gen. Journal Line"."Posting Date");
                
                */
                //IF DATE2DMY("Gen. Journal Line"."Posting Date",1) IN [1..3] THEN
                //  "Gen. Journal Line"."Document No." := getDocNo(1,"Gen. Journal Line"."Posting Date");
                /*
                "Gen. Journal Line"."Document No." := 'MIG'+
                FORMAT(DATE2DMY("Gen. Journal Line"."Posting Date",1))+
                FORMAT(DATE2DMY("Gen. Journal Line"."Posting Date",2))+
                FORMAT(DATE2DMY("Gen. Journal Line"."Posting Date",3));
                */
                
                if "Gen. Journal Line"."External Document No."='' then begin
                  "Gen. Journal Line"."External Document No.":="Gen. Journal Line"."Document No.";
                  "Gen. Journal Line".Modify;
                end;

            end;

            trigger OnPostDataItem()
            begin
                Window.Close;
                Message(TxtTraitementTerminé);
            end;

            trigger OnPreDataItem()
            begin
                "Gen. Journal Line".SetRange("Gen. Journal Line"."Journal Template Name",'GENERAL');
                "Gen. Journal Line".SetRange("Gen. Journal Line"."Journal Batch Name",'MIGRATION');
                //LineNum:=0;
                NbreTotalLignes := "Gen. Journal Line".Count;
                BesoinNo :=0;

                Window.Open(Text008);
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        BesoinNo: Integer;
        NbreTotalLignes: Integer;
        Window: Dialog;
        Text008: Label 'Process @1@@@@@@@@@@@@@@@@@@@@@@@@@@@@\';
        "TxtTraitementTerminé": Label 'Traitement términé !';

    local procedure getDocNo(Int: Integer;PostDate: Date): Code[20]
    begin
        exit(
        'MIG0' + Format(Int) + Format(Date2DMY(PostDate,2))+ Format(Date2DMY(PostDate,3))
        );
    end;
}

