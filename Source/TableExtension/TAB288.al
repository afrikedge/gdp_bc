tableextension 70000121 tableextension70000121 extends "Vendor Bank Account" 
{
    fields
    {
        modify(Name)
        {
            Caption = 'Name';
        }
        modify("Name 2")
        {
            Caption = 'Name 2';
        }

        //Unsupported feature: Code Insertion on "Code(Field 2)".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //begin
            /*
            //***********************
            ResetVendorValidation;
            //***********************
            */
        //end;


        //Unsupported feature: Code Insertion on "Name(Field 3)".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //begin
            /*
            //***********************
            ResetVendorValidation;
            //***********************
            */
        //end;


        //Unsupported feature: Code Insertion on ""Name 2"(Field 5)".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //begin
            /*
            //***********************
            ResetVendorValidation;
            //***********************
            */
        //end;


        //Unsupported feature: Code Modification on ""Bank Branch No."(Field 13).OnValidate".

        //trigger "(Field 13)()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            "RIB Checked" := RIBKey.Check("Bank Branch No.","Agency Code","Bank Account No.","RIB Key");
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            "RIB Checked" := RIBKey.Check("Bank Branch No.","Agency Code","Bank Account No.","RIB Key");

            IBAN := CollectIBAN();//*********

            IF SwiftCorrespondence.GET("Bank Branch No.") THEN BEGIN
              "SWIFT Code" := SwiftCorrespondence."SWIFT Code";
            END;
            //***********************
            ResetVendorValidation;
            //***********************
            */
        //end;


        //Unsupported feature: Code Modification on ""Bank Account No."(Field 14).OnValidate".

        //trigger "(Field 14)()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            "RIB Checked" := RIBKey.Check("Bank Branch No.","Agency Code","Bank Account No.","RIB Key");
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            "RIB Checked" := RIBKey.Check("Bank Branch No.","Agency Code","Bank Account No.","RIB Key");

            IBAN := CollectIBAN();//*********
            //***********************
            ResetVendorValidation;
            //***********************
            */
        //end;


        //Unsupported feature: Code Insertion on ""Currency Code"(Field 16)".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //begin
            /*
            //***********************
            ResetVendorValidation;
            //***********************
            */
        //end;


        //Unsupported feature: Code Modification on "IBAN(Field 24).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            CompanyInfo.CheckIBAN(IBAN);
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            //CompanyInfo.CheckIBAN(IBAN);//***********
            //***********************
            ResetVendorValidation;
            //***********************
            */
        //end;


        //Unsupported feature: Code Insertion on ""SWIFT Code"(Field 25)".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //begin
            /*
            //***********************
            ResetVendorValidation;
            //***********************
            */
        //end;


        //Unsupported feature: Code Modification on ""Agency Code"(Field 10851).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            IF STRLEN("Agency Code") < 5 THEN
              "Agency Code" := PADSTR('',5 - STRLEN("Agency Code"),'0') + "Agency Code";
            "RIB Checked" := RIBKey.Check("Bank Branch No.","Agency Code","Bank Account No.","RIB Key");
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            #1..3

            IBAN := CollectIBAN();//*********
            //***********************
            ResetVendorValidation;
            //***********************
            */
        //end;


        //Unsupported feature: Code Modification on ""RIB Key"(Field 10852).OnValidate".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //>>>> ORIGINAL CODE:
        //begin
            /*
            "RIB Checked" := RIBKey.Check("Bank Branch No.","Agency Code","Bank Account No.","RIB Key");
            */
        //end;
        //>>>> MODIFIED CODE:
        //begin
            /*
            "RIB Checked" := RIBKey.Check("Bank Branch No.","Agency Code","Bank Account No.","RIB Key");

            IBAN := CollectIBAN();//*********

            //***********************
            ResetVendorValidation;
            //***********************
            */
        //end;


        //Unsupported feature: Code Insertion on ""RIB Checked"(Field 10853)".

        //trigger OnValidate()
        //Parameters and return type have not been exported.
        //begin
            /*
            //***********************
            ResetVendorValidation;
            //***********************
            */
        //end;
        field(50000;"RIB Key Text";Text[2])
        {
            Caption = 'RIB Key Text';
            Description = 'AFK';

            trigger OnValidate()
            begin
                //*************************************
                EVALUATE("RIB Key","RIB Key Text");

                ResetVendorValidation;
                //***********************
            end;
        }
    }

    procedure AFKGetLongAccountNum(): Text
    begin
        EXIT("Bank Branch No." + "Agency Code" + "Bank Account No." + CONVERTSTR(FORMAT("RIB Key",2),' ','0'));
    end;

    procedure CollectIBAN(): Code[50]
    begin
        EXIT("Bank Branch No." + "Agency Code" + "Bank Account No." + CONVERTSTR(FORMAT("RIB Key",2),' ','0'));
    end;

    local procedure ResetVendorValidation()
    var
        Vend1: Record "23";
    begin
        IF Vend1.GET("Vendor No.") THEN BEGIN
          IF Vend1."Validation Status"<>Vend1."Validation Status"::Created THEN
            IF NOT CONFIRM(STRSUBSTNO( ErrAfk001,Vend1.Name)) THEN ERROR('');
          Vend1."Validation Status":=Vend1."Validation Status"::Created;
          Vend1.MODIFY;
        END;
    end;

    var
        SwiftCorrespondence: Record "50090";
        ErrAfk001: Label 'La modification de ce champ va ramener la fiche fournisseur %1 au statut ''En création''. Il devra de nouveau être validé.\Voulez-vous poursuivre la modification ?';
}

