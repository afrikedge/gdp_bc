pageextension 50086 "GD1 Sales Order List" extends "Sales Order List"
{
    Editable = false;
    Caption = 'Suivi des commandes de vente';

    layout
    {
        addafter(Status)
        {
            field("Delivery Status"; Rec."Delivery Status")
            {
                ApplicationArea = all;
            }
        }
    }
    actions
    {
        modify(Post)
        {
            Visible = false;
            Enabled = false;
        }
        modify("Post &Batch")
        {
            Visible = false;
            Enabled = false;
        }
        modify(PostAndSend)
        {
            Visible = false;
            Enabled = false;
        }
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
}
