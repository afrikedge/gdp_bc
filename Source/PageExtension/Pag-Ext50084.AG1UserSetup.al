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
                ApplicationArea = All;
            }
            field("PO Type"; Rec."PO Type")
            {
                ApplicationArea = All;
            }
            field("Enlever Filtre Commande Achat"; Rec."Enlever Filtre Commande Achat")
            {
                ApplicationArea = All;
            }
            field("Enlever Filtre Demande Achat"; Rec."Enlever Filtre Demande Achat")
            {
                ApplicationArea = All;
            }
            field("E-Mail"; Rec."E-Mail")
            {
                ApplicationArea = All;
            }
            field("PR Validator"; Rec."PR Validator")
            {
                ApplicationArea = All;
            }
            field("PR Interim Validator"; Rec."PR Interim Validator")
            {
                ApplicationArea = All;
            }
            field("Direction Code"; Rec."Direction Code")
            {
                ApplicationArea = All;
            }
            field("Service Code"; Rec."Service Code")
            {
                ApplicationArea = All;
            }
            field("Department Code"; Rec."Department Code")
            {
                ApplicationArea = All;
            }
            field("CDG Validator"; Rec."CDG Validator")
            {
                ApplicationArea = All;
            }
            field("CDG Interim Validator"; Rec."CDG Interim Validator")
            {
                ApplicationArea = All;
            }
            field("Can Update Prices"; Rec."Can Update Prices")
            {
                ApplicationArea = All;
            }
            field("Can Unlock Order"; Rec."Can Unlock Order")
            {
                ApplicationArea = All;
            }
            field("Can Cancel SO"; Rec."Can Cancel SO")
            {
                ApplicationArea = All;
            }
            field(CanUpdateOrderAfterValidation; Rec.CanUpdateOrderAfterValidation)
            {
                ApplicationArea = All;
            }
            field(CanUpdateLubOrderAfterVal; Rec.CanUpdateLubOrderAfterVal)
            {
                ApplicationArea = All;
            }
            field("Can Validate Item"; Rec."Can Validate Item")
            {
                ApplicationArea = All;
            }
            field("Can Validate Vendor"; Rec."Can Validate Vendor")
            {
                ApplicationArea = All;
            }
            field("Can delete blocked Orders"; Rec."Can delete blocked Orders")
            {
                ApplicationArea = All;
            }
            field("Can Reverse Transaction"; Rec."Can Reverse Transaction")
            {
                ApplicationArea = All;
            }
            field("Reverse Amount Limit"; Rec."Reverse Amount Limit")
            {
                ApplicationArea = All;
            }
            field("Can Reverse Reconciliation"; Rec."Can Reverse Reconciliation")
            {
                ApplicationArea = All;
            }
            field("Can Update JIRAMA Qty"; Rec."Can Update JIRAMA Qty")
            {
                ApplicationArea = All;
            }
            field("Can Reverse BE/BL"; Rec."Can Reverse BE/BL")
            {
                ApplicationArea = All;
            }
            field("Can Apply GLEntries"; Rec."Can Apply GLEntries")
            {
                ApplicationArea = All;
            }
            field("Dispatching User Name"; Rec."Dispatching User Name")
            {
                ApplicationArea = All;
            }
            field("Dispatching Manager Name"; Rec."Dispatching Manager Name")
            {
                ApplicationArea = All;
            }
            field(IsVendorAccountant; Rec.IsVendorAccountant)
            {
                ApplicationArea = All;
            }
            field(CanPostDirectPurchInvoice; Rec.CanPostDirectPurchInvoice)
            {
                ApplicationArea = All;
            }
            field("Item on sales invoice"; Rec."Item on sales invoice")
            {
                ApplicationArea = All;
            }
            field(CanPostDirectPurchInvNoControl; Rec.CanPostDirectPurchInvNoControl)
            {
                ApplicationArea = All;
            }
            field("Sales Resp. Ctr. Filter2"; Rec."Sales Resp. Ctr. Filter2")
            {
                ApplicationArea = All;
            }
            field("Sales Resp. Ctr. Filter3"; Rec."Sales Resp. Ctr. Filter3")
            {
                ApplicationArea = All;
            }
            field("Sales Resp. Ctr. Filter4"; Rec."Sales Resp. Ctr. Filter4")
            {
                ApplicationArea = All;
            }
            field("Sales Resp. Ctr. Filter5"; Rec."Sales Resp. Ctr. Filter5")
            {
                ApplicationArea = All;
            }
            field("GLAccount on Purchase Order"; Rec."GLAccount on Purchase Order")
            {
                ApplicationArea = All;
            }
            // field("Dispaching Windows User"; Rec."Dispaching Windows User")
            // {
            // }
            field("Afk Function Name on PO"; Rec."Afk Function Name on PO") { ApplicationArea = All; }
            field("Afk Commercial Manager"; Rec."Afk Commercial Manager")
            {
                ApplicationArea = All;
            }

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

