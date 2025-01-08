pageextension 50087 "GD1 Sales Order" extends "Sales Order"
{
    Editable = false;
    actions
    {
        modify(Warehouse)
        {
            Visible = false;
        }
        modify("P&osting")
        {
            Visible = false;
        }
        modify(Action3)
        {
            Visible = false;
        }
        modify("&Print")
        {
            Visible = false;
        }
        modify(Category_Process)
        {
            Visible = false;
        }
        modify("Prepa&yment")
        {
            Visible = false;
        }
        modify(Category_Category7)
        {
            Visible = false;
        }

        modify(Category_Category4)
        {
            Visible = false;
        }
        modify(Category_Category11)
        {
            Visible = false;
        }
        modify(Category_Category9)
        {
            Visible = false;
        }
        modify(Category_Category8)
        {
            Visible = false;
        }
        modify(Category_Category10)
        {
            Visible = false;
        }
        modify(Category_Category12)
        {
            Visible = false;
        }
        modify(Category_Report)
        {
            Visible = false;
        }
        modify(Category_Synchronize)
        {
            Visible = false;
        }
        modify("&Order Confirmation")
        {
            Visible = false;
        }
        modify("O&rder")
        {
            Visible = false;
        }
    }
    trigger OnOpenPage()
    var
    //myInt: Integer;
    begin
        Error('');
    end;
}
