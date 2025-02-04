tableextension 50002 "A02 Location" extends Location
{
    fields
    {
        field(50000; Depot; Boolean)
        {
            Caption = 'Oil Depot';
        }
        field(50001; "Item Category Code"; Code[10])
        {
            Caption = 'Item Category Code';
            //TableRelation = "Item Category";
        }
        field(50004; "Transfer Item Transit"; Boolean)
        {
            Caption = 'Use for item transfer';
        }
        field(50005; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";
        }
        field(50006; "Allow Negative Stock"; Boolean)
        {
            Caption = 'Allow Negative Stock';
        }
        field(50007; "Virtual Location"; Boolean)
        {
            Caption = 'Virtual Location';
        }
        field(50008; "Code JIRAMA"; Code[10])
        {
        }
        field(50009; "Location Type"; Option)
        {
            Caption = 'Location Type';
            OptionCaption = ' ,Expedition,TransferTransit,Confrere';
            OptionMembers = " ",Expedition,TransferTransit,Confrere;
        }
        field(50010; "GDP Location"; Boolean)
        {
            Caption = 'GDP Location';
        }
        field(50011; "Printed Location"; Code[10])
        {
            Caption = 'Printed Code';
        }
    }
}

