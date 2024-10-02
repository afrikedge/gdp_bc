tableextension 70000165 tableextension70000165 extends "User Group" 
{
    fields
    {
        field(50000;"Allow Posting From";Date)
        {
            Caption = 'Allow Posting From';

            trigger OnValidate()
            begin
                //GLSetup.CheckPostingRange("Allow Posting From",FIELDCAPTION("Allow Posting From"));
            end;
        }
        field(50001;"Allow Posting To";Date)
        {
            Caption = 'Allow Posting To';

            trigger OnValidate()
            begin
                //GLSetup.CheckPostingRange("Allow Posting To",FIELDCAPTION("Allow Posting To"));
            end;
        }
    }

    var
        GLSetup: Record "98";
}

