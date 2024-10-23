page 50121 "FA Transfer"
{
    Caption = 'Fixed Asset Transfer';

    layout
    {
        area(content)
        {
            field(TransferDate; TransferDate)
            {
                Caption = 'Transfer Date';
            }
            field(ExtDocNo; ExtDocNo)
            {
                Caption = 'External Document N°';
            }
            field(Comments; Comments)
            {
                Caption = 'Comments';
            }
            field(NewFALocation; NewFALocation)
            {
                Caption = 'New Location';
                TableRelation = "FA Location";

                trigger OnValidate()
                begin
                    if FALoc.Get(NewFALocation) then
                        NewFALocationName := FALoc.Name;
                end;
            }
            field(NewFALocationName; NewFALocationName)
            {
                Caption = 'Location Name';
                Editable = false;
                // OptionCaption = 'Location Name';
            }
            field(NewFASubLocation; NewFASubLocation)
            {
                Caption = 'Sub location Code';

                trigger OnLookup(var Text: Text): Boolean
                begin
                    FASubLoc.Reset;
                    FASubLoc.SetRange("Location Code", NewFALocation);
                    if PAGE.RunModal(50123, FASubLoc) = ACTION::LookupOK then begin
                        NewFASubLocation := FASubLoc.Code;
                        NewFASubLocationName := FASubLoc.Name;
                    end;
                end;
            }
            field(NewFASubLocationName; NewFASubLocationName)
            {
                Caption = 'Sub Location Name';
                Editable = false;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(PostDoc)
            {
                Caption = '&Post';
                Ellipsis = true;
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    if FAMgt.InsertNewTransfer(FA, CodeImmo, TransferDate, Comments, NewFALocation, ExtDocNo, NewFASubLocation) then begin
                        Message(Text001);
                        CurrPage.Close;
                    end;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        TransferDate := WorkDate;
    end;

    var
        CodeImmo: Code[20];
        Comments: Text[50];
        NewFALocation: Code[10];
        TransferDate: Date;
        NewFALocationName: Text[50];
        ExtDocNo: Text[30];
        FAMgt: Codeunit "FA Mgt";
        Text001: Label 'Traitement terminé avec succès !';
        FALoc: Record "FA Location";
        FASubLoc: Record "FA SubLocation";
        NewFASubLocation: Code[10];
        NewFASubLocationName: Text[50];
        FASubLocations: Page "FA Sub Locations";
        FA: Record "Fixed Asset";

    procedure SetCodeImmo("Code": Code[20])
    begin
        CodeImmo := Code;
    end;

    procedure SetFA(var FA1: Record "Fixed Asset")
    begin
        FA := FA1;
    end;
}

