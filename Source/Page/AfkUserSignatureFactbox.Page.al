page 50035 "Afk User Signature Factbox"
{
    ApplicationArea = All;
    PageType = CardPart;
    SourceTable = "User Setup";
    Caption = 'Signature';
    UsageCategory = None;

    layout
    {
        area(Content)
        {
            field(Signature; Rec."Afk Signature")
            {
                ApplicationArea = All;
                Caption = 'Signature';

                trigger OnDrillDown()
                begin
                    UploadSignature();
                end;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ImportSignature)
            {
                ApplicationArea = All;
                Caption = 'Import Signature';
                Image = Import;
                ToolTip = 'Import a signature image';

                trigger OnAction()
                begin
                    UploadSignature();
                end;
            }
            action(ClearSignatureAction)
            {
                ApplicationArea = All;
                Caption = 'Clear Signature';
                Image = Delete;
                ToolTip = 'Remove the signature image';
                Enabled = HasSignature();

                trigger OnAction()
                begin
                    if Confirm('Are you sure you want to clear the signature?', false) then
                        ClearSignature();
                end;
            }
        }
    }

    local procedure UploadSignature()
    var
        FileManagement: Codeunit "File Management";
        TempBlob: Codeunit "Temp Blob";
        FileName: Text;
        InStream: InStream;
        OutStream: OutStream;
    begin
        FileName := FileManagement.BLOBImport(TempBlob, '');
        if FileName = '' then
            exit;
        TempBlob.CreateInStream(InStream);
        Rec."Afk Signature".CreateOutStream(OutStream);
        CopyStream(OutStream, InStream);
        Rec.Modify(true);
    end;

    local procedure ClearSignature()
    begin
        Clear(Rec."Afk Signature");
        Rec.Modify(true);
    end;

    local procedure HasSignature(): Boolean
    begin
        exit(Rec."Afk Signature".HasValue());
    end;
}




