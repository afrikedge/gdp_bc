pageextension 50055 pageextension70000112 extends "FA Depreciation Books"
{
    layout
    {
        addafter("Temp. Fixed Depr. Amount")
        {
            field("Book Value"; Rec."Book Value")
            {
            }
        }
    }
}

