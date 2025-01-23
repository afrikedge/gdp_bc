pageextension 50095 "Afk Customer Ledger Entries" extends "Customer Ledger Entries"
{
    trigger OnOpenPage()
    var
    begin
        Rec.SetRange("User ID", UserId);
    end;
}
