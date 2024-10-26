xmlport 50056 importRoles
{
    Caption = 'Permissions import';
    Direction = Both;
    FieldDelimiter = '<None>';
    FieldSeparator = '<TAB>';
    Format = VariableText;

    schema
    {
        textelement(Root)
        {
            tableelement(Permission;Permission)
            {
                AutoSave = false;
                XmlName = 'InvoiceData';
                fieldattribute(RoleID;Permission."Role ID")
                {
                }
                fieldattribute(ObjectType;Permission."Object Type")
                {
                }
                fieldattribute(ObjectID;Permission."Object ID")
                {
                }
                fieldattribute(Read;Permission."Read Permission")
                {
                }
                fieldattribute(Isert;Permission."Insert Permission")
                {
                }
                fieldattribute(Modify;Permission."Modify Permission")
                {
                }
                fieldattribute(Delete;Permission."Delete Permission")
                {
                }

                trigger OnAfterGetRecord()
                var
                    Cust2: Record Customer;
                begin
                    //Process Date Here
                end;

                trigger OnBeforeInsertRecord()
                var
                    GLAccNo: Code[20];
                    strDate: Code[10];
                    Permission1: Record Permission;
                    TextRole: Text;
                begin
                    
                    BesoinNo := BesoinNo + 1;
                    Window.Update(1,
                    Round(BesoinNo / NbreTotalLignes * 10000,1));
                    
                    
                    if not EnsRole.Get(Permission."Role ID") then begin
                      EnsRole.Init;
                      EnsRole."Role ID" := Permission."Role ID";
                      EnsRole.Insert;
                    end;
                    
                    //Role ID,Object Type,Object ID
                    if Permission1.Get(Permission."Role ID",Permission."Object Type",Permission."Object ID") then
                      begin
                        //TextRole := FORMAT(Permission."Read Permission");
                        TransformValue(Permission1."Read Permission",Format(Permission."Read Permission"));
                        TransformValue(Permission1."Delete Permission",Format(Permission."Delete Permission"));
                        TransformValue(Permission1."Insert Permission",Format(Permission."Insert Permission"));
                        TransformValue(Permission1."Modify Permission",Format(Permission."Modify Permission"));
                        /*
                        Permission1."Read Permission" := Permission."Read Permission";
                        Permission1."Delete Permission" := Permission."Delete Permission";
                        Permission1."Insert Permission" := Permission."Insert Permission";
                        Permission1."Modify Permission" := Permission."Modify Permission";
                        */
                        Permission1.Modify;
                    end else begin
                      Permission1.Init;
                      Permission1:=Permission;
                      Permission1.Insert;
                    end;

                end;
            }
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
        }

        actions
        {
        }
    }

    trigger OnPostXmlPort()
    begin


        Window.Close;
        Message(TxtTraitementTerminé);
    end;

    trigger OnPreXmlPort()
    begin

        //AddOnSetup.GET;
        //AddOnSetup.TESTFIELD("Sales Templ Journal Code");



        BesoinNo :=0;
        //IF "Monthly Invoice Data".FIND('-') THEN
           //NbreTotalLignes :=34226;
        //IF   NbreTotalLignes=0 THEN ERROR('Entrez le nombre de lignes');
        NbreTotalLignes :=250;
        Window.Open(Text008);
    end;

    var
        GenJrnTemplate: Code[20];
        GenJrnBatch: Code[20];
        PostingDate: Date;
        GenJrnTable: Record "Gen. Journal Batch";
        GenJrnLine: Record "Gen. Journal Line";
        Text001: Label 'La feuille %1 doit être vide pour effectuer cette opération !';
        LineNo: Integer;
        Cust2: Record Customer;
        BesoinNo: Integer;
        NbreTotalLignes: Integer;
        Window: Dialog;
        Text008: Label 'Traitement...        @2@@@@@@@@@@@@@\';
        "TxtTraitementTerminé": Label 'Traitement términé !';
        AddOnSetup: Record "AddOn Setup";
        JrnTmplName: Record "Gen. Journal Template";
        Text002: Label 'This account %1 does not exists !';
        GLAcc2: Record "G/L Account";
        GrpeComptabanque: Record "Bank Account Posting Group";
        BankAcc: Record "Bank Account";
        Vend2: Record Vendor;
        ModeleFeuille: Code[20];
        NomFeuille: Code[20];
        EnsRole: Record "Permission Set";

    procedure GetCorrectAcc(AccToCheck: Code[20]): Code[20]
    var
        GLAcc1: Record "G/L Account";
    begin
        /*
        IF Corresp.GET(AccToCheck) THEN BEGIN
            EXIT(Corresp.NewAccNumber);
        END ELSE BEGIN
           //IF GLAcc1.GET(COPYSTR(AccToCheck,1,7)) THEN
           //  EXIT(COPYSTR(AccToCheck,1,7))
           //ELSE
            ERROR(Text002,AccToCheck);
        END;
        */
        /*
        IF GLAcc1.GET(COPYSTR(AccToCheck,1,7)) THEN BEGIN
          EXIT(COPYSTR(AccToCheck,1,7));
        END ELSE BEGIN
          IF Corresp.GET(AccToCheck) THEN
            EXIT(Corresp.NewAccNumber)
          ELSE
            ERROR(Text002,AccToCheck);
        END;
        */

    end;

    procedure GetCorrectVendorAcc(AccToCheck: Code[20]): Code[20]
    var
        GLAcc1: Record "G/L Account";
        Vend1: Record Vendor;
    begin
        /*
        IF Vend1.GET(AccToCheck) THEN BEGIN
          EXIT(AccToCheck);
        END ELSE BEGIN
          //IF Corresp.GET(AccToCheck) THEN
          //  EXIT(Corresp.NewAccNumber)
          //ELSE
            ERROR(Text002,AccToCheck);
        END;
        */

    end;

    local procedure TransformValue(var RoleType: Option " ",Oui,Indirect;RoleTexte: Text[20])
    begin
        // ,Yes,Indirect
        RoleType:=0;
        if CopyStr(RoleTexte,1,1)='O' then RoleType:=1;
        if  CopyStr(RoleTexte,1,1)='I' then RoleType:=2;
    end;
}

