pageextension 50025 pageextension70000041 extends "Posted Sales Shipments"
{
    layout
    {
        addafter("External Document No.")
        {
            field("Your Reference"; Rec."Your Reference")
            {
                ApplicationArea = All;
            }
            field("Order No."; Rec."Order No.")
            {
                ApplicationArea = All;
            }
            field("User ID"; Rec."User ID")
            {
                ApplicationArea = All;
            }
            field("Livre JIRAMA"; Rec."Livre JIRAMA")
            {
                ApplicationArea = All;
            }
        }
    }


    //Unsupported feature: Code Modification on "OnOpenPage".

    //trigger OnOpenPage()
    //>>>> ORIGINAL CODE:
    //begin
    /*
    HasFilters := GETFILTERS <> '';
    SetSecurityFilterOnRespCenter;
    IF HasFilters THEN
      IF FINDFIRST THEN;
    IsOfficeAddin := OfficeMgt.IsAvailable;
    */
    //end;
    //>>>> MODIFIED CODE:
    //begin
    /*

    SetFiltreCentreGestion;           //********************Added

    //********************
    SETRANGE("User ID",USERID);
    //********************

    HasFilters := GETFILTERS <> '';
    //SetSecurityFilterOnRespCenter;
    #3..5
    */
    //end;

    local procedure SetFiltreCentreGestion()
    var
        FiltreCG: Text[100];
        SecMgt: Codeunit "50016";
        UserMgt: Codeunit "5700";
    begin
        IF UserMgt.GetSalesFilter <> '' THEN BEGIN
            /*FILTERGROUP(2);
            SETRANGE("Responsibility Center",UserMgt.GetSalesFilter);
            FILTERGROUP(0);*/

            FiltreCG := SecMgt.GetFiltresCentresGestion;
            IF FiltreCG <> '' THEN BEGIN
                Rec.FILTERGROUP(2);
                Rec.SETFILTER("Responsibility Center", FiltreCG);
                Rec.FILTERGROUP(0);
            END;
        END;

    end;
}

