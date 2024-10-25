pageextension 50066 pageextension70000133 extends "Config. Package Subform"
{
    actions
    {
        addafter(PackageFilters)
        {
            action(INIT)
            {
                Caption = 'INIT';

                trigger OnAction()
                begin
                    //CurrPage.SETSELECTIONFILTER(ConfigPackageTable);
                    //Rec.InitPackageFields;
                end;
            }
        }
    }
}

