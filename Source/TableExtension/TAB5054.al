tableextension 50056 "A02 Contact Business Relation" extends "Contact Business Relation"
{
    // //Ajout du champ No. à la clé primaire de la table
    keys
    {

        //Unsupported feature: Deletion (KeyCollection) on ""Contact No.,Business Relation Code"(Key)".

        key(A02Key1; "Contact No.", "Business Relation Code", "No.")
        {
        }
    }
}

