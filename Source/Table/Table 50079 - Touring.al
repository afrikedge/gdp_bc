table 50079 Touring
{
    Caption = 'Touring';

    fields
    {
        field(1; IdTouring; Integer)
        {
            AutoIncrement = true;
            Caption = 'Touring Id';
            Editable = false;
        }
        field(2; "Touring Date"; Date)
        {
            Caption = 'Touring Date';
        }
        field(3; Description; Text[50])
        {
        }
        field(4; "User ID"; Code[50])
        {
            Caption = 'User ID';
            Editable = false;
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnLookup()
            var
                UserMgt: Codeunit "User Management";
            begin
                //UserMgt.LookupUserID("User ID");
            end;

            trigger OnValidate()
            var
                UserMgt: Codeunit "User Management";
            begin
                //UserMgt.ValidateUserID("User ID");
            end;
        }
        field(5; "Creation Date"; Date)
        {
            Caption = 'Creation Date';
            Editable = false;
        }
        field(6; Status; Option)
        {
            Caption = 'Status';
            Editable = false;
            OptionCaption = 'Created,Dispached,Posted,Confirmed';
            OptionMembers = Created,Dispached,Posted,Confirmed;
        }
        field(7; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location WHERE(Depot = CONST(true));

            trigger OnValidate()
            var
                Loc: Record Location;
                SecMgt: Codeunit "Security Mgt";
            begin
                if ((Status = Rec.Status::Confirmed) or (Status = Rec.Status::Posted)) then
                    Error(Text001);

                if xRec."Location Code" <> Rec."Location Code" then
                    //IF Rec."Location Code" <> '' THEN
                    if xRec."Location Code" <> '' then
                        if Confirm(Text002) then begin
                            DeleteTouringData(Rec.IdTouring);
                        end;

                if Loc.Get("Location Code") then
                    "Responsibility Center" := Loc."Responsibility Center";

                if "Location Code" <> '' then
                    SecMgt.CheckWarehouseUser("Location Code");
            end;
        }
        field(8; "Truck capacity"; Decimal)
        {
            CalcFormula = Sum("Touring Truck"."Total Capacity" WHERE(IdTouring = FIELD(IdTouring)));
            Caption = 'Truck capacity';
            Editable = false;
            FieldClass = FlowField;
        }
        field(9; "Validity Date"; Date)
        {
            Caption = 'Validity Date';
        }
        field(10; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            Editable = false;
            TableRelation = "Responsibility Center";
        }
        field(11; "Total volume to ship"; Decimal)
        {
            CalcFormula = Sum("Touring Sales Order".Total WHERE(IdTouring = FIELD(IdTouring)));
            Caption = 'Total volume to ship';
            Editable = false;
            FieldClass = FlowField;
        }
        field(12; TotalGO; Decimal)
        {
            BlankZero = true;
            CalcFormula = Sum("Touring Sales Order".GO WHERE(IdTouring = FIELD(IdTouring)));
            Caption = 'Total GO';
            Editable = false;
            FieldClass = FlowField;
        }
        field(13; TotalPL; Decimal)
        {
            BlankZero = true;
            CalcFormula = Sum("Touring Sales Order".PL WHERE(IdTouring = FIELD(IdTouring)));
            Caption = 'Total PL';
            Editable = false;
            FieldClass = FlowField;
        }
        field(14; TotalSC; Decimal)
        {
            BlankZero = true;
            CalcFormula = Sum("Touring Sales Order".SC WHERE(IdTouring = FIELD(IdTouring)));
            Caption = 'Total SC';
            Editable = false;
            FieldClass = FlowField;
        }
        field(15; TotalFO; Decimal)
        {
            BlankZero = true;
            CalcFormula = Sum("Touring Sales Order".FO WHERE(IdTouring = FIELD(IdTouring)));
            Caption = 'Total FO';
            Editable = false;
            FieldClass = FlowField;
        }
        field(16; "Validated by User ID"; Code[50])
        {
            Caption = 'Validated by User ID';
            Editable = false;
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnLookup()
            var
                UserMgt: Codeunit "User Management";
            begin
                //UserMgt.LookupUserID("User ID");
            end;

            trigger OnValidate()
            var
                UserMgt: Codeunit "User Management";
            begin
                //UserMgt.ValidateUserID("User ID");
            end;
        }
        field(17; "Validation Date"; Date)
        {
            Caption = 'Validation Date';
            Editable = false;
        }
        field(18; "Archived Date"; Date)
        {
            Caption = 'Archived date';
            Editable = false;
        }
        field(19; "Cancelled by User ID"; Code[50])
        {
            Caption = 'Cancelled by User ID';
            Editable = false;
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnLookup()
            var
                UserMgt: Codeunit "User Management";
            begin
                //UserMgt.LookupUserID("User ID");
            end;

            trigger OnValidate()
            var
                UserMgt: Codeunit "User Management";
            begin
                //UserMgt.ValidateUserID("User ID");
            end;
        }
        field(20; "Cancelled Date"; Date)
        {
            Caption = 'Cancelled Date';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; IdTouring)
        {
        }
        key(Key2; Status)
        {
        }
        key(Key3; "User ID")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        if ((Status = Rec.Status::Confirmed) or (Status = Rec.Status::Posted)) then
            Error(Text001);

        DeleteTouringData(Rec.IdTouring);
    end;

    trigger OnInsert()
    begin
        "User ID" := UserId;
        "Creation Date" := Today;
    end;

    trigger OnModify()
    begin
        if ((Status = Rec.Status::Confirmed) or (Status = Rec.Status::Posted)) then
            Error(Text001);
    end;

    var
        Text001: Label 'La tournée a déjà été validée';
        Text002: Label 'Si vous modifiez le code dépôt, les lignes de commande et les camions utilisés pour ce dispaching seront supprimées.\Voulez-vous continuer?';
        //SecMgt: Codeunit "Security Mgt";
        Text037: Label 'La date de validité doit être postérieure à la date de création';

    local procedure DeleteTouringData(IdTour: Integer)
    var
        CdeTournee: Record "Touring Sales Order";
        CamionTournee: Record "Touring Truck";
        TourEntry: Record "Touring Product Entry";
    begin
        TourEntry.Reset;
        TourEntry.SetRange(TourEntry.IdTouring, IdTour);
        TourEntry.DeleteAll;

        CdeTournee.Reset;
        CdeTournee.SetRange(IdTouring, IdTour);
        CdeTournee.DeleteAll;

        CamionTournee.Reset;
        CamionTournee.SetRange(IdTouring, IdTour);
        CamionTournee.DeleteAll;

        TotalFO := 0;
        TotalGO := 0;
        TotalSC := 0;
        TotalPL := 0;
        "Total volume to ship" := 0;
    end;
}

