tableextension 50038 "A02 Source Code Setup" extends "Source Code Setup"
{
    fields
    {
        field(60000; Payroll; Code[10])
        {
            TableRelation = "Source Code";
        }
    }
}

