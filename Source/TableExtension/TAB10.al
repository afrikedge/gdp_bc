tableextension 50001 "A02 Shipment Method" extends "Shipment Method"
{
    fields
    {

        //Unsupported feature: Code Modification on "Code(Field 1).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
        /*
        IF ValidateShipmentMethod THEN
          MESSAGE(Text10800);
        */
        //end;
        //>>>> MODIFIED CODE:
        //begin
        /*

        //JN 150419 COMMENTED
        //IF ValidateShipmentMethod THEN
        //  MESSAGE(Text10800);
        */
        //end;
        field(50000; "Disable manually Shipment"; Boolean)
        {
            Caption = 'Disable manually shipment';
        }
    }
}

