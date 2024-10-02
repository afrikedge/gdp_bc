tableextension 50064 "A02 FA Depreciation Book" extends "FA Depreciation Book"
{
    fields
    {
        field(50000; "Starting FA Posting Group"; Code[10])
        {
            Caption = 'Starting FA Posting Group';
            TableRelation = "FA Posting Group";

            trigger OnValidate()
            begin
                //ModifyDeprFields;
            end;
        }
    }
}

