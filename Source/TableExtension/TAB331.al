tableextension 70000126 tableextension70000126 extends "Adjust Exchange Rate Buffer" 
{
    fields
    {
        field(50000;IsProgal;Boolean)
        {
        }
    }
    keys
    {

        //Unsupported feature: Deletion (KeyCollection) on ""Currency Code,Posting Group,Dimension Entry No.,Posting Date,IC Partner Code"(Key)".

        key(Key1;"Currency Code","Posting Group","Dimension Entry No.","Posting Date","IC Partner Code",IsProgal)
        {
        }
    }
}

