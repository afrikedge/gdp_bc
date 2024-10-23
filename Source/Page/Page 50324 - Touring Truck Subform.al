page 50324 "Touring Truck Subform"
{
    AutoSplitKey = false;
    DelayedInsert = true;
    MultipleNewLines = true;
    PageType = ListPart;
    SourceTable = "Touring Truck";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(IdTouring; Rec.IdTouring)
                {
                    Visible = false;
                }
                field(immatriculation; Rec.immatriculation)
                {

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        Camion: Record pro_moyentransport;
                        TouringTruck: Record "Touring Truck";
                        ExistingTruckFilter: Text;
                    begin
                        TouringH.Get(Rec.IdTouring);
                        TouringH.TestField(TouringH."Responsibility Center");

                        AddOn.Get;

                        Camion.Reset;
                        Camion.FilterGroup(2);
                        TouringTruck.Reset;
                        TouringTruck.SetRange(IdTouring, Rec.IdTouring);
                        if TouringTruck.FindSet then
                            repeat
                                if ExistingTruckFilter = '' then
                                    ExistingTruckFilter := '<>' + TouringTruck.immatriculation
                                else
                                    ExistingTruckFilter := ExistingTruckFilter + '&<>' + TouringTruck.immatriculation;
                            until TouringTruck.Next = 0;
                        Camion.SetFilter(Camion.immatriculation, ExistingTruckFilter);
                        Camion.SetRange(Camion.disponible, true);

                        Camion.FilterGroup(0);
                        Camion.SetRange(Camion.lieuaffectation, TouringH."Responsibility Center");
                        //Camion.SETRANGE(Camion.entournee,FALSE);


                        /*
                        IF Camion.FINDSET THEN
                        REPEAT
                          IF AddOn."Dispaching PlusieursVoyages" THEN BEGIN
                            IF DispachingMgt.NbreVoyagesEncoursCamion(Camion.immatriculation)<AddOn."Dispaching Maximum Tours" THEN
                              Camion.MARK(TRUE);
                          END ELSE BEGIN
                            IF NOT Camion.entournee THEN
                              Camion.MARK(TRUE);
                          END;
                        UNTIL Camion.NEXT=0;
                        */
                        //Camion.MARKEDONLY(TRUE);

                        if PAGE.RunModal(50067, Camion) = ACTION::LookupOK then begin
                            Rec.immatriculation := Camion.immatriculation;
                            Rec.Validate(immatriculation);
                        end;

                    end;
                }
                field("Total Capacity"; Rec."Total Capacity")
                {
                }
                field("Remaining Tours"; Rec."Remaining Tours")
                {
                }
                field(Pompe; Rec.Pompe)
                {
                }
                field(Capacity1; Rec.Capacity1)
                {
                }
                field(Capacity2; Rec.Capacity2)
                {
                }
                field(Capacity3; Rec.Capacity3)
                {
                }
                field(Capacity4; Rec.Capacity4)
                {
                }
                field(Capacity5; Rec.Capacity5)
                {
                }
                field(Capacity6; Rec.Capacity6)
                {
                }
                field(Capacity7; Rec.Capacity7)
                {
                }
                field(Capacity8; Rec.Capacity8)
                {
                }
                field(Capacity9; Rec.Capacity9)
                {
                }
                field(Capacity10; Rec.Capacity10)
                {
                }
            }
        }
    }

    actions
    {
    }

    var
        TouringH: Record Touring;
        AddOn: Record "AddOn Setup";
        DispachingMgt: Codeunit "Logistique Mgt";
}

