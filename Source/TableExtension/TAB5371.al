table 5371 "Service Connection Error"
{
    Caption = 'Service Connection Error';

    fields
    {
        field(1;"Code";Guid)
        {
            Caption = 'Code';
        }
        field(2;"Server Address";Text[250])
        {
            Caption = 'Dynamics CRM URL';
            TableRelation = "CRM Connection Setup"."Server Address";
        }
        field(3;"Last Occurrence";DateTime)
        {
            Caption = 'Last Occurrence';
        }
        field(4;Error;BLOB)
        {
            Caption = 'Error';
        }
        field(5;Hash;Integer)
        {
            Caption = 'Hash';
        }
        field(6;"First Occurrence";DateTime)
        {
            Caption = 'First Occurrence';
        }
        field(7;"Occurrence Count";Integer)
        {
            Caption = 'Occurrence Count';
        }
    }

    keys
    {
        key(Key1;"Code")
        {
        }
        key(Key2;Hash)
        {
        }
    }

    fieldgroups
    {
    }

    var
        ConfirmQst: Label 'Are you sure that you want to delete connection failure errors?';

    procedure SetError(ErrorMsg: Text)
    var
        DataStream: OutStream;
    begin
        CLEAR(Error);
        Error.CREATEOUTSTREAM(DataStream);
        DataStream.WRITE(ErrorMsg);
        MODIFY;
    end;

    procedure GetError() ErrorMsg: Text
    var
        DataStream: InStream;
    begin
        ErrorMsg := '';
        CALCFIELDS(Error);
        IF Error.HASVALUE THEN BEGIN
          Error.CREATEINSTREAM(DataStream);
          DataStream.READ(ErrorMsg);
        END;
    end;

    procedure CanInsertRecord(Error: Text;HostName: Text): Boolean
    var
        HashText: Text;
    begin
        HashText := FORMAT(CreateHash(Error,HostName));
        SETFILTER(Hash,HashText);
        EXIT(NOT FINDSET);
    end;

    procedure DeleteEntries(DaysOld: Integer)
    begin
        IF NOT CONFIRM(ConfirmQst) THEN
          EXIT;
        SETFILTER("First Occurrence",'<=%1',CREATEDATETIME(TODAY - DaysOld,TIME));
        DELETEALL;
    end;

    procedure CreateHash(Error: Text;HostName: Text): Integer
    var
        DotNetString: DotNet String;
    begin
        DotNetString := DotNetString.Concat(HostName,Error);
        DotNetString := DotNetString.ToUpper;
        EXIT(DotNetString.GetHashCode);
    end;
}

