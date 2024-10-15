tableextension 50039 "A02 Bank Account" extends "Bank Account"
{
    fields
    {
        modify("Check Report ID")
        {
            Caption = 'Check Report ID';
        }
        field(50000; "Authorize Payment"; Boolean)
        {
            Caption = 'Autorize Payment';
        }
        field(50001; "Starting Check No."; Code[20])
        {
            AccessByPermission = TableData 272 = R;
            Caption = 'Starting Check No.';
        }
        field(50002; "Ending Check No."; Code[20])
        {
            AccessByPermission = TableData 272 = R;
            Caption = 'Ending Check No.';
        }
        field(50003; "RIB Key Text"; Text[2])
        {
            Caption = 'RIB Key Text';
            Description = 'AFK';

            trigger OnValidate()
            begin
                //*************************************
                EVALUATE("RIB Key", "RIB Key Text");
                //*************************************
            end;
        }
        field(50004; "Check Report Usage"; enum "Report Selection Usage")
        {
            Caption = 'Check Report Usage';
        }
    }

    procedure AFKGetLongAccountNum(): Text
    begin
        EXIT("Bank Branch No." + "Agency Code" + "Bank Account No." + CONVERTSTR(FORMAT("RIB Key", 2), ' ', '0'));
    end;
}

