page 50065 "Fuel Statement Line subform"
{
    AutoSplitKey = true;
    Caption = 'Lines';
    DelayedInsert = true;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = ListPart;
    SourceTable = "Fuel Statement Line";
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
                field(Manufacturor; Rec.Manufacturor)
                {
                }
                field("Car Type"; Rec."Car Type")
                {
                }
                field("Equipment Type"; Rec."Equipment Type")
                {
                }
                field(BackCharge; Rec.BackCharge)
                {
                }
                field(Process; Rec.Process)
                {
                }
                field("Project Code"; Rec."Project Code")
                {
                }
                field("Cost Code"; Rec."Cost Code")
                {
                }
                field("Departement name"; Rec."Departement name")
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
                field("Badge Number"; Rec."Badge Number")
                {
                }
                field("Date of control"; Rec."Date of control")
                {
                }
                field("Validated by"; Rec."Validated by")
                {
                }
            }
        }
    }

    actions
    {
    }
}

