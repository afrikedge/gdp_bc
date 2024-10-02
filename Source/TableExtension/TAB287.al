tableextension 50041 "A02 Customer Bank Account" extends "Customer Bank Account"
{
    procedure AFKGetLongAccountNum(): Text
    begin
        EXIT("Bank Branch No." + "Agency Code" + "Bank Account No." + CONVERTSTR(FORMAT("RIB Key", 2), ' ', '0'));
    end;
}

