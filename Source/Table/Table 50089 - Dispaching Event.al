table 50089 "Dispaching Event"
{
    DrillDownPageID = "Dispaching Event Entries";
    LookupPageID = "Dispaching Event Entries";

    fields
    {
        field(1;"Entry No.";Integer)
        {
            Caption = 'Entry No.';
        }
        field(2;Type;Option)
        {
            OptionCaption = 'Commentaires,Evènement';
            OptionMembers = Comment,DispachEvent;

            trigger OnValidate()
            begin
                if Type <> xRec.Type then
                  Description := '';
            end;
        }
        field(3;"Event Code";Code[10])
        {
            Caption = 'Code';
            TableRelation = IF (Type=CONST(DispachEvent)) "Dispaching Event Type"."Event Code";

            trigger OnValidate()
            begin
                if Type = Rec.Type::DispachEvent then
                  if "Event Code" <> '' then begin
                    EventType.Get("Event Code");
                    Description := EventType.Description;
                  end else
                    Description := '';

                if "Event Code"<>'' then
                  TestField(Type,Rec.Type::DispachEvent);
            end;
        }
        field(4;Date;Date)
        {
            Caption = 'Date';
            ClosingDates = true;
        }
        field(9;Description;Text[50])
        {
            Caption = 'Description';
        }
        field(11;"User ID";Code[50])
        {
            Caption = 'User ID';
            Editable = false;
            TableRelation = User."User Name";
            //This property is currently not supported
            //TestTableRelation = false;

            trigger OnLookup()
            var
                UserMgt: Codeunit "User Management";
            begin
                UserMgt.LookupUserID("User ID");
            end;
        }
        field(16;"Last Date Modified";Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
        }
        field(17;immatriculation;Code[30])
        {
            Caption = 'Registration';
        }
    }

    keys
    {
        key(Key1;"Entry No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        TestField(Date);
        if Type=Rec.Type::DispachEvent then
          TestField(Rec."Event Code");
        LockTable;
        "User ID" := UserId;
        "Last Date Modified" := Today;
        if "Entry No." = 0 then
          "Entry No." := GetNextEntryNo;
    end;

    trigger OnModify()
    begin
        "User ID" := UserId;
        "Last Date Modified" := Today;
    end;

    var
        EventType: Record "Dispaching Event Type";

    local procedure GetNextEntryNo(): Integer
    var
        EventEntry: Record "Dispaching Event";
    begin
        EventEntry.SetCurrentKey("Entry No.");
        if EventEntry.FindLast then
          exit(EventEntry."Entry No." + 1);

        exit(1);
    end;
}

