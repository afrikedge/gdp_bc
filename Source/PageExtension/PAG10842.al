pageextension 50078 pageextension70000003 extends "Apply G/L Entries"
{
    // 300819 JN Security on GL Entries Application
    actions
    {


        //Unsupported feature: Code Modification on "SetAppliesToID(Action 1120010).OnAction".

        //trigger OnAction()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        CLEAR(GLEntry);
        GLEntry.COPY(Rec);
        CurrPage.SETSELECTIONFILTER(GLEntry);
        #4..22
            GLEntry.MODIFY;
          UNTIL GLEntry.NEXT = 0;
        END;
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        //******************************
        SecMgt.CheckCanApplyGLEntries;
        //******************************

        #1..25
        */
        //end;


        //Unsupported feature: Code Modification on "PostApplication(Action 1120011).OnAction".

        //trigger OnAction()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        GLEntriesApplication.Validate(Rec);
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        //******************************
        SecMgt.CheckCanApplyGLEntries;
        //******************************
        GLEntriesApplication.Validate(Rec);
        */
        //end;


        //Unsupported feature: Code Modification on "UnapplyEntries(Action 1120012).OnAction".

        //trigger OnAction()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        CLEAR(GLEntry);
        GLEntry.SETRANGE("G/L Account No.","G/L Account No.");
        GLEntry.SETRANGE(Letter,Letter);
        #4..8
          UNTIL GLEntry.NEXT = 0;
        IF Letter <> '' THEN
          MESSAGE('%1',Text001);
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*
        //******************************
        SecMgt.CheckCanApplyGLEntries;
        //******************************
        #1..11
        */
        //end;
    }

    var
        SecMgt: Codeunit "50016";
}

