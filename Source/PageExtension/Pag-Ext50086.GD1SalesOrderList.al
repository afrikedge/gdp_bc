pageextension 50086 "GD1 Sales Order List" extends "Sales Order List"
{
    Editable = false;

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
    }
}
