pageextension 50040 pageextension70000088 extends "Sales & Receivables Setup"
{
    actions
    {
        addfirst(processing)
        {
            action("Mise à jour des axes sur cde vente")
            {
                Caption = 'Mise à jour des axes sur cde vente';
                RunObject = Report 50001;
            }
        }
    }
}

