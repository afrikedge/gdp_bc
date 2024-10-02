tableextension 50022 "A02 Vendor Posting Group" extends "Vendor Posting Group"
{
    fields
    {

        //Unsupported feature: Code Modification on ""Payables Account"(Field 2).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        IF "View All Accounts on Lookup" THEN
          GLAccountCategoryMgt.CheckGLAccountWithoutCategory("Payables Account",FALSE,FALSE)
        ELSE
          GLAccountCategoryMgt.CheckGLAccount(
            "Payables Account",FALSE,FALSE,GLAccountCategory."Account Category"::Liabilities,GLAccountCategoryMgt.GetCurrentLiabilities);
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*

        //******************************************************
        IF "Retention %"<>0=TRUE THEN
          FIELDERROR(Rec."Payables Account");
        //******************************************************

        #1..5
        */
        //end;
        field(50000; "Retention Group"; Boolean)
        {
            Caption = 'Retention Group';

            trigger OnValidate()
            begin
                //******************************************************
                IF "Retention Group" = TRUE THEN
                    IF "Payables Account" <> '' THEN
                        FIELDERROR(Rec."Payables Account");
                //******************************************************
            end;
        }
        field(50001; "Retention %"; Decimal)
        {
            Caption = 'Retention %';

            trigger OnValidate()
            begin
                //******************************************************
                IF ("Retention %" <> 0) THEN
                    IF "Payables Account" <> '' THEN
                        FIELDERROR(Rec."Payables Account");
                //******************************************************
            end;
        }
        field(50002; "Retention Account"; Code[20])
        {
            Caption = 'Retention Account';
            TableRelation = "G/L Account";

            trigger OnValidate()
            begin
                //******************************************************
                IF ("Retention Account" <> '') THEN
                    IF "Payables Account" <> '' THEN
                        FIELDERROR(Rec."Payables Account");
                //******************************************************
            end;
        }
    }
}

