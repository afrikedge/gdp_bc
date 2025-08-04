page 50334 "Dispaching Event Entries"
{
    Caption = 'Dispaching Event Entries';
    DataCaptionFields = immatriculation;
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Dispaching Event";
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    Visible = false;
                }
                field(immatriculation; Rec.immatriculation)
                {
                    Editable = false;
                    Visible = false;
                }
                field(Date; Rec.Date)
                {
                }
                field(Type; Rec.Type)
                {
                }
                field("Event Code"; Rec."Event Code")
                {
                }
                field(Description; Rec.Description)
                {
                }
                field("User ID"; Rec."User ID")
                {
                    Visible = false;
                }
                field("Last Date Modified"; Rec."Last Date Modified")
                {
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1000000010; Notes)
            {
            }
            systempart(Control1000000011; Links)
            {
            }
        }
    }

    actions
    {
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Date := GetFirstDate(Rec.GetFilter(Date));
        Rec."User ID" := UserId;
        Rec.immatriculation := Rec.GetFilter(immatriculation);
        Rec.Type := Rec.Type::DispachEvent;
    end;

    local procedure GetFirstDate(DateFilter: Text[250]): Date
    var
        Period: Record Date;
    begin
        if DateFilter = '' then
            exit(0D);
        with Period do begin
            SetRange("Period Type", "Period Type"::Date);
            SetFilter("Period Start", DateFilter);
            if FindFirst then
                exit("Period Start");

            exit(0D);
        end;
    end;
}

