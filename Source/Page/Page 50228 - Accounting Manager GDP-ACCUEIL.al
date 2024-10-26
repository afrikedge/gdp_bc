page 50228 "Accounting Manager GDP-ACCUEIL"
{
    Caption = 'Role Center';
    PageType = RoleCenter;

    layout
    {
        area(rolecenter)
        {
            group(Control1900724808)
            {
                ShowCaption = false;
                part(Control1902304208;"Account Manager Activities")
                {
                }
                part(Control1907692008;"My Customers")
                {
                }
            }
            group(Control1900724708)
            {
                ShowCaption = false;
                part(Control1902476008;"My Vendors")
                {
                }
                systempart(Control1901377608;MyNotes)
                {
                }
            }
        }
    }

    actions
    {
        area(embedding)
        {
            action("Payroll Modif Validated")
            {
                Caption = 'Payroll Modif Validated';
                RunObject = Page "Vendor Invoice List Saisie";
            }
            action(Historique)
            {
                Caption = 'Historique';
                RunObject = Page "Vendor Invoice List Historique";
            }
        }
    }
}

