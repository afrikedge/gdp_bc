pageextension 50009 pageextension70000076 extends "Item Journal"
{
    layout
    {
        addafter("Bin Code")
        {
            field("Ref Cargo"; Rec."Ref Cargo")
            {
            }
            field("Customer No"; Rec."Customer No")
            {
            }
        }
    }
    actions
    {


        //Unsupported feature: Code Modification on "Action 70.OnAction".

        //trigger OnAction()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        ItemJnlLine.COPY(Rec);
        ItemJnlLine.SETRANGE("Journal Template Name","Journal Template Name");
        ItemJnlLine.SETRANGE("Journal Batch Name","Journal Batch Name");
        REPORT.RUNMODAL(REPORT::"Inventory Movement",TRUE,TRUE,ItemJnlLine);
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*

        #1..3
        //REPORT.RUNMODAL(REPORT::"Inventory Movement",TRUE,TRUE,ItemJnlLine);
        REPORT.RUNMODAL(50042,TRUE,TRUE,ItemJnlLine);
        */
        //end;
        addafter("Update Item Tracking Lines")
        {
            action(PrintBE)
            {
                Caption = '&Print BE';
                Ellipsis = true;
                Image = Print;

                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;

                trigger OnAction()
                var
                    ItemJnlLine: Record "83";
                    "report": Report "50042";
                begin
                    CLEAR(report);

                    ItemJnlLine.COPY(Rec);
                    ItemJnlLine.SETRANGE("Journal Template Name", Rec."Journal Template Name");
                    ItemJnlLine.SETRANGE("Journal Batch Name", Rec."Journal Batch Name");
                    //REPORT.RUNMODAL(REPORT::"Inventory Movement",TRUE,TRUE,ItemJnlLine);

                    report.SetTypeEtat(1);
                    report.SETTABLEVIEW(ItemJnlLine);
                    report.RUNMODAL;
                    //report.RUNMODAL(TRUE,TRUE,ItemJnlLine);
                end;
            }
            action(PrintBL)
            {
                Caption = '&Print BL';
                Ellipsis = true;
                Image = Print;

                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;

                trigger OnAction()
                var
                    ItemJnlLine: Record "83";
                    "report": Report "50042";
                begin
                    CLEAR(report);

                    ItemJnlLine.COPY(Rec);
                    ItemJnlLine.SETRANGE("Journal Template Name", Rec."Journal Template Name");
                    ItemJnlLine.SETRANGE("Journal Batch Name", Rec."Journal Batch Name");
                    //REPORT.RUNMODAL(REPORT::"Inventory Movement",TRUE,TRUE,ItemJnlLine);
                    //REPORT.RUNMODAL(50042,TRUE,TRUE,ItemJnlLine);

                    report.SetTypeEtat(2);
                    report.SETTABLEVIEW(ItemJnlLine);
                    report.RUNMODAL;
                end;
            }
        }
    }

    var
        TextErr001: Label 'Ce type n''est pas autorisé sur cette feuille';


    //Unsupported feature: Code Modification on "OnInsertRecord".

    //trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    //>>>> ORIGINAL CODE:
    //begin
    /*
    IF "Entry Type" > "Entry Type"::"Negative Adjmt." THEN
      ERROR(Text000,"Entry Type");
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*
    IF "Entry Type" > "Entry Type"::"Negative Adjmt." THEN
      ERROR(Text000,"Entry Type");

    //***********************************************
    //***********************************************
    IF (("Entry Type"=Rec."Entry Type"::Sale) OR ("Entry Type"=Rec."Entry Type"::Purchase)) THEN
      ERROR(Text000,"Entry Type");
    //***********************************************
    //***********************************************
    */
    //end;
}

