pageextension 50084 "AG1 User Setup" extends "User Setup"
{
    layout
    {
        addfirst(FactBoxes)
        {
            part(UserSignatureFactbox; "Afk User Signature Factbox")
            {
                ApplicationArea = All;
                SubPageLink = "User ID" = field("User ID");
            }
        }
        addafter("Time Sheet Admin.")
        {
            field("Old Nav User"; Rec."Old Nav User")
            {
                ApplicationArea = all;
            }
            field("PR Type"; Rec."PR Type")
            {
            }
            field("PO Type"; Rec."PO Type")
            {
            }
            field("Enlever Filtre Commande Achat"; Rec."Enlever Filtre Commande Achat")
            {
            }
            field("Enlever Filtre Demande Achat"; Rec."Enlever Filtre Demande Achat")
            {
            }
            field("E-Mail"; Rec."E-Mail")
            {
            }
            field("PR Validator"; Rec."PR Validator")
            {
            }
            field("PR Interim Validator"; Rec."PR Interim Validator")
            {
            }
            field("Direction Code"; Rec."Direction Code")
            {
            }
            field("Service Code"; Rec."Service Code")
            {
            }
            field("Department Code"; Rec."Department Code")
            {
            }
            field("CDG Validator"; Rec."CDG Validator")
            {
            }
            field("CDG Interim Validator"; Rec."CDG Interim Validator")
            {
            }
            field("Can Update Prices"; Rec."Can Update Prices")
            {
            }
            field("Can Unlock Order"; Rec."Can Unlock Order")
            {
            }
            field("Can Cancel SO"; Rec."Can Cancel SO")
            {
            }
            field(CanUpdateOrderAfterValidation; Rec.CanUpdateOrderAfterValidation)
            {
            }
            field(CanUpdateLubOrderAfterVal; Rec.CanUpdateLubOrderAfterVal)
            {
            }
            field("Can Validate Item"; Rec."Can Validate Item")
            {
            }
            field("Can Validate Vendor"; Rec."Can Validate Vendor")
            {
            }
            field("Can delete blocked Orders"; Rec."Can delete blocked Orders")
            {
            }
            field("Can Reverse Transaction"; Rec."Can Reverse Transaction")
            {
            }
            field("Reverse Amount Limit"; Rec."Reverse Amount Limit")
            {
            }
            field("Can Reverse Reconciliation"; Rec."Can Reverse Reconciliation")
            {
            }
            field("Can Update JIRAMA Qty"; Rec."Can Update JIRAMA Qty")
            {
            }
            field("Can Reverse BE/BL"; Rec."Can Reverse BE/BL")
            {
            }
            field("Can Apply GLEntries"; Rec."Can Apply GLEntries")
            {
            }
            field("Dispatching User Name"; Rec."Dispatching User Name")
            {
            }
            field("Dispatching Manager Name"; Rec."Dispatching Manager Name")
            {
            }
            field(IsVendorAccountant; Rec.IsVendorAccountant)
            {
            }
            field(CanPostDirectPurchInvoice; Rec.CanPostDirectPurchInvoice)
            {
            }
            field("Item on sales invoice"; Rec."Item on sales invoice")
            {
            }
            field(CanPostDirectPurchInvNoControl; Rec.CanPostDirectPurchInvNoControl)
            {
            }
            field("Sales Resp. Ctr. Filter2"; Rec."Sales Resp. Ctr. Filter2")
            {
            }
            field("Sales Resp. Ctr. Filter3"; Rec."Sales Resp. Ctr. Filter3")
            {
            }
            field("Sales Resp. Ctr. Filter4"; Rec."Sales Resp. Ctr. Filter4")
            {
            }
            field("Sales Resp. Ctr. Filter5"; Rec."Sales Resp. Ctr. Filter5")
            {
            }
            field("GLAccount on Purchase Order"; Rec."GLAccount on Purchase Order")
            {
            }
            // field("Dispaching Windows User"; Rec."Dispaching Windows User")
            // {
            // }
            field("Afk Function Name on PO"; Rec."Afk Function Name on PO") { }


        }
    }

    // actions
    // {
    //     addlast(Processing)
    //     {
    //         action(ImportSignature)
    //         {
    //             ApplicationArea = All;
    //             Caption = 'Import Signature';
    //             Image = Import;
    //             ToolTip = 'Import a signature image';

    //             trigger OnAction()
    //             begin
    //                 UploadSignature();
    //             end;
    //         }
    //         action(ExportSignature)
    //         {
    //             ApplicationArea = All;
    //             Caption = 'Export Signature';
    //             Image = Export;
    //             ToolTip = 'Export the signature image';
    //             Enabled = HasSignature();

    //             trigger OnAction()
    //             begin
    //                 DownloadSignature();
    //             end;
    //         }
    //         action(ClearSignature)
    //         {
    //             ApplicationArea = All;
    //             Caption = 'Clear Signature';
    //             Image = Delete;
    //             ToolTip = 'Remove the signature image';
    //             Enabled = HasSignature();

    //             trigger OnAction()
    //             begin
    //                 if Confirm('Are you sure you want to clear the signature?', false) then
    //                     ClearSignature();
    //             end;
    //         }
    //     }
}

// local procedure UploadSignature()
// var
//     FileManagement: Codeunit "File Management";
//     TempBlob: Codeunit "Temp Blob";
//     FileName: Text;
//     InStream: InStream;
//     OutStream: OutStream;
// begin
//     FileName := FileManagement.BLOBImport(TempBlob, '');
//     if FileName = '' then
//         exit;
//     TempBlob.CreateInStream(InStream);
//     Rec."Afk Signature".CreateOutStream(OutStream);
//     CopyStream(OutStream, InStream);
//     Rec.Modify(true);
// end;

// local procedure DownloadSignature()
// var
//     FileManagement: Codeunit "File Management";
//     TempBlob: Codeunit "Temp Blob";
//     FileName: Text;
//     InStream: InStream;
//     OutStream: OutStream;
// begin
//     if not HasSignature() then
//         exit;

//     Rec."Afk Signature".CreateInStream(InStream);
//     TempBlob.CreateOutStream(OutStream);
//     CopyStream(OutStream, InStream);

//     FileName := 'Signature.jpg';
//     FileManagement.BLOBExport(TempBlob, FileName, true);
// end;



// local procedure ClearSignature()
// var
//     TempBlob: Codeunit "Temp Blob";
// begin
//     Clear(Rec."Afk Signature");
//     Rec.Modify(true);
// end;

// local procedure HasSignature(): Boolean
// var
//     TempBlob: Codeunit "Temp Blob";
//     InStream: InStream;
// begin
//     if Rec."Afk Signature".HasValue() then
//         exit(true);
//     exit(false);
// end;

