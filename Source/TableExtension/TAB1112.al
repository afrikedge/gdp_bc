tableextension 50053 "A02 Cost Center" extends "Cost Center"
{
    fields
    {
        field(50000; "Old Code"; Code[20])
        {
            Caption = 'Old Code';
            NotBlank = false;

            trigger OnValidate()
            begin
                //IF UPPERCASE(Code) = Text002 THEN
                //  ERROR(Text003,
                //    FIELDCAPTION(Code));
            end;
        }
        field(50001; Category; Option)
        {
            Caption = 'Category';
            OptionCaption = ' ,P&L,Analyse de charges';
            OptionMembers = " ",PL,AnalyseCharge;
        }
    }
}

