pageextension 50079 pageextension70000004 extends "Payment Status"
{
    layout
    {
        addafter("AcceptationCode")
        {
            field(Cancellable; Rec.Cancellable)
            {
            }
        }
    }
}

