tableextension 50079 "Afk Industry Group" extends "Industry Group"
{
    fields
    {
        field(50000; "Main Industry"; Code[50])
        {
            Caption = 'Main Industry';
            DataClassification = CustomerContent;
            TableRelation = "Afk Reference".Code where(TableType = const("Main Industry"));
        }
    }
}
