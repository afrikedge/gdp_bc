tableextension 70000168 tableextension70000168 extends "General Ledger Setup" 
{
    // //JN001 301216 Pas de controle de période fiscale
    fields
    {


        //Unsupported feature: Code Modification on ""Allow Posting From"(Field 2).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            CheckAllowedPostingDates(0);
            CheckPostingRange("Allow Posting From",FIELDCAPTION("Allow Posting From"));
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*

            //CheckAllowedPostingDates(0);**************************************************************
            //CheckPostingRange("Allow Posting From",FIELDCAPTION("Allow Posting From"));***************
            */
        //end;


        //Unsupported feature: Code Modification on ""Allow Posting To"(Field 3).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            CheckAllowedPostingDates(0);
            CheckPostingRange("Allow Posting To",FIELDCAPTION("Allow Posting To"));
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*

            //CheckAllowedPostingDates(0);**************************************************************
            //CheckPostingRange("Allow Posting To",FIELDCAPTION("Allow Posting To"));*******************
            */
        //end;
    }
}

