page 50169 "Posted Fuel Statement subform"
{
    AutoSplitKey = true;
    Caption = 'Lines';
    DelayedInsert = true;
    PageType = ListPart;
    ApplicationArea = All;
    SourceTable = "Posted Fuel Statement Line";
    SourceTableView = WHERE("Document Type" = CONST(FS));

    layout
    {
        area(content)
        {
            repeater(Control1000000008)
            {
                ShowCaption = false;
                field("Line No."; Rec."Line No.")
                {
                    Visible = false;
                }
                field(TagID; Rec.TagID)
                {
                }
                field("Source Appro"; Rec."Source Appro")
                {
                }
                field("License plate number"; Rec."License plate number")
                {
                }
                field("Equipement ID number"; Rec."Equipement ID number")
                {
                }
                field("Vehicule Description"; Rec."Vehicule Description")
                {
                }
                field("Car Type"; Rec."Car Type")
                {
                }
                field(BackCharge; Rec.BackCharge)
                {
                }
                field("Equipment Type"; Rec."Equipment Type")
                {
                }
                field("Project Code"; Rec."Project Code")
                {
                }
                field("Cost Code"; Rec."Cost Code")
                {
                }
                field("Cost Center"; Rec."Cost Center")
                {
                }
                field(Pump; Rec.Pump)
                {
                }
                field(DateRefuel; Rec.DateRefuel)
                {
                }
                field(TimeRefuel; Rec.TimeRefuel)
                {
                }
                field("Total Counter"; Rec."Total Counter")
                {
                }
                field("Vehicle Odometer"; Rec."Vehicle Odometer")
                {
                }
                field(Company; Rec.Company)
                {
                }
                field(Driver; Rec.Driver)
                {
                }
                field(Notes; Rec.Notes)
                {
                }
            }
        }
    }

    actions
    {
    }
}

