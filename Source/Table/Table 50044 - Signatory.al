table 50044 Signatory
{
    Caption = 'Contact';
    DataCaptionFields = "No.",Name;
    LookupPageID = "Signatory List";

    fields
    {
        field(1;"No.";Code[20])
        {
            Caption = 'No.';

            trigger OnValidate()
            begin
                /*
                IF "No." <> xRec."No." THEN BEGIN
                  RMSetup.GET;
                  NoSeriesMgt.TestManual(RMSetup."Contact Nos.");
                  "No. Series" := '';
                END;
                */

            end;
        }
        field(2;Name;Text[50])
        {
            Caption = 'Name';

            trigger OnValidate()
            begin
                //NameBreakdown;
                //ProcessNameChange;
            end;
        }
        field(4;"Name 2";Text[50])
        {
            Caption = 'Name 2';
        }
        field(89;Picture;BLOB)
        {
            Caption = 'Picture';
            Compressed = false;
            SubType = Bitmap;
        }
        field(5051;"Company No.";Code[20])
        {
            Caption = 'Company No.';
            TableRelation = Customer;

            trigger OnValidate()
            var
                Opp: Record Opportunity;
                OppEntry: Record "Opportunity Entry";
                Todo: Record "To-do";
                InteractLogEntry: Record "Interaction Log Entry";
                SegLine: Record "Segment Line";
                SalesHeader: Record "Sales Header";
                OriginalEmail: Text[80];
            begin
                /*
                IF "Company No." = xRec."Company No." THEN
                  EXIT;
                
                OriginalEmail := "E-Mail";
                
                TESTFIELD(Type,Type::Person);
                
                SegLine.SETCURRENTKEY("Contact No.");
                SegLine.SETRANGE("Contact No.","No.");
                IF SegLine.FINDFIRST THEN
                  ERROR(Text012,FIELDCAPTION("Company No."));
                
                IF Cont.GET("Company No.") THEN
                  InheritCompanyToPersonData(Cont,xRec."Company No." = '')
                ELSE
                  CLEAR("Company Name");
                
                IF Cont.GET("No.") THEN BEGIN
                  IF xRec."Company No." <> '' THEN BEGIN
                    Opp.SETCURRENTKEY("Contact Company No.","Contact No.");
                    Opp.SETRANGE("Contact Company No.",xRec."Company No.");
                    Opp.SETRANGE("Contact No.","No.");
                    Opp.MODIFYALL("Contact No.",xRec."Company No.");
                    OppEntry.SETCURRENTKEY("Contact Company No.","Contact No.");
                    OppEntry.SETRANGE("Contact Company No.",xRec."Company No.");
                    OppEntry.SETRANGE("Contact No.","No.");
                    OppEntry.MODIFYALL("Contact No.",xRec."Company No.");
                    Todo.SETCURRENTKEY("Contact Company No.","Contact No.");
                    Todo.SETRANGE("Contact Company No.",xRec."Company No.");
                    Todo.SETRANGE("Contact No.","No.");
                    Todo.MODIFYALL("Contact No.",xRec."Company No.");
                    InteractLogEntry.SETCURRENTKEY("Contact Company No.","Contact No.");
                    InteractLogEntry.SETRANGE("Contact Company No.",xRec."Company No.");
                    InteractLogEntry.SETRANGE("Contact No.","No.");
                    InteractLogEntry.MODIFYALL("Contact No.",xRec."Company No.");
                    ContBusRel.RESET;
                    ContBusRel.SETCURRENTKEY("Link to Table","No.");
                    ContBusRel.SETRANGE("Link to Table",ContBusRel."Link to Table"::Customer);
                    ContBusRel.SETRANGE("Contact No.",xRec."Company No.");
                    SalesHeader.SETCURRENTKEY("Sell-to Customer No.","External Document No.");
                    SalesHeader.SETRANGE("Sell-to Contact No.","No.");
                    IF ContBusRel.FINDFIRST THEN
                      SalesHeader.SETRANGE("Sell-to Customer No.",ContBusRel."No.")
                    ELSE
                      SalesHeader.SETRANGE("Sell-to Customer No.",'');
                    IF SalesHeader.FIND('-') THEN
                      REPEAT
                        SalesHeader."Sell-to Contact No." := xRec."Company No.";
                        IF SalesHeader."Sell-to Contact No." = SalesHeader."Bill-to Contact No." THEN
                          SalesHeader."Bill-to Contact No." := xRec."Company No.";
                        SalesHeader.MODIFY;
                      UNTIL SalesHeader.NEXT = 0;
                    SalesHeader.RESET;
                    SalesHeader.SETCURRENTKEY("Bill-to Contact No.");
                    SalesHeader.SETRANGE("Bill-to Contact No.","No.");
                    SalesHeader.MODIFYALL("Bill-to Contact No.",xRec."Company No.");
                  END ELSE BEGIN
                    Opp.SETCURRENTKEY("Contact Company No.","Contact No.");
                    Opp.SETRANGE("Contact Company No.",'');
                    Opp.SETRANGE("Contact No.","No.");
                    Opp.MODIFYALL("Contact Company No.","Company No.");
                    OppEntry.SETCURRENTKEY("Contact Company No.","Contact No.");
                    OppEntry.SETRANGE("Contact Company No.",'');
                    OppEntry.SETRANGE("Contact No.","No.");
                    OppEntry.MODIFYALL("Contact Company No.","Company No.");
                    Todo.SETCURRENTKEY("Contact Company No.","Contact No.");
                    Todo.SETRANGE("Contact Company No.",'');
                    Todo.SETRANGE("Contact No.","No.");
                    Todo.MODIFYALL("Contact Company No.","Company No.");
                    InteractLogEntry.SETCURRENTKEY("Contact Company No.","Contact No.");
                    InteractLogEntry.SETRANGE("Contact Company No.",'');
                    InteractLogEntry.SETRANGE("Contact No.","No.");
                    InteractLogEntry.MODIFYALL("Contact Company No.","Company No.");
                  END;
                  IF OriginalEmail <> '' THEN
                    "E-Mail" := OriginalEmail;
                  IF CurrFieldNo <> 0 THEN
                    MODIFY;
                END;
                */

            end;
        }
        field(5052;"Company Name";Text[50])
        {
            CalcFormula = Min(Customer.Name WHERE ("No."=FIELD("Company No.")));
            Caption = 'Company Name';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1;"No.","Company No.")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown;"No.",Name,Field5050,Field7,Field91,Field9)
        {
        }
    }

    trigger OnDelete()
    var
        Todo: Record "To-do";
        SegLine: Record "Segment Line";
        ContIndustGrp: Record "Contact Industry Group";
        ContactWebSource: Record "Contact Web Source";
        ContJobResp: Record "Contact Job Responsibility";
        ContMailingGrp: Record "Contact Mailing Group";
        ContProfileAnswer: Record "Contact Profile Answer";
        RMCommentLine: Record "Rlshp. Mgt. Comment Line";
        ContAltAddr: Record "Contact Alt. Address";
        ContAltAddrDateRange: Record "Contact Alt. Addr. Date Range";
        InteractLogEntry: Record "Interaction Log Entry";
        Opp: Record Opportunity;
        CampaignTargetGrMgt: Codeunit "Campaign Target Group Mgt";
        VATRegistrationLogMgt: Codeunit "VAT Registration Log Mgt.";
    begin
        
        /*
        DOPaymentCreditCard.DeleteByContact(Rec);
        
        Todo.SETCURRENTKEY("Contact Company No.","Contact No.",Closed,Date);
        Todo.SETRANGE("Contact Company No.","Company No.");
        Todo.SETRANGE("Contact No.","No.");
        Todo.SETRANGE(Closed,FALSE);
        IF Todo.FIND('-') THEN
          ERROR(Text000,TABLECAPTION,"No.");
        
        SegLine.SETCURRENTKEY("Contact No.");
        SegLine.SETRANGE("Contact No.","No.");
        IF SegLine.FINDFIRST THEN
          ERROR(Text001,TABLECAPTION,"No.");
        
        Opp.SETCURRENTKEY("Contact Company No.","Contact No.");
        Opp.SETRANGE("Contact Company No.","Company No.");
        Opp.SETRANGE("Contact No.","No.");
        Opp.SETRANGE(Status,Opp.Status::"Not Started",Opp.Status::"In Progress");
        IF Opp.FIND('-') THEN
          ERROR(Text002,TABLECAPTION,"No.");
        
        CASE Type OF
          Type::Company:
            BEGIN
              ContBusRel.SETRANGE("Contact No.","No.");
              ContBusRel.DELETEALL;
              ContIndustGrp.SETRANGE("Contact No.","No.");
              ContIndustGrp.DELETEALL;
              ContactWebSource.SETRANGE("Contact No.","No.");
              ContactWebSource.DELETEALL;
              DuplMgt.RemoveContIndex(Rec,FALSE);
              InteractLogEntry.SETCURRENTKEY("Contact Company No.");
              InteractLogEntry.SETRANGE("Contact Company No.","No.");
              IF InteractLogEntry.FIND('-') THEN
                REPEAT
                  CampaignTargetGrMgt.DeleteContfromTargetGr(InteractLogEntry);
                  CLEAR(InteractLogEntry."Contact Company No.");
                  CLEAR(InteractLogEntry."Contact No.");
                  InteractLogEntry.MODIFY;
                UNTIL InteractLogEntry.NEXT = 0;
        
              Cont.RESET;
              Cont.SETCURRENTKEY("Company No.");
              Cont.SETRANGE("Company No.","No.");
              Cont.SETRANGE(Type,Type::Person);
              IF Cont.FIND('-') THEN
                REPEAT
                  Cont.DELETE(TRUE);
                UNTIL Cont.NEXT = 0;
        
              Opp.RESET;
              Opp.SETCURRENTKEY("Contact Company No.","Contact No.");
              Opp.SETRANGE("Contact Company No.","Company No.");
              Opp.SETRANGE("Contact No.","No.");
              IF Opp.FIND('-') THEN
                REPEAT
                  CLEAR(Opp."Contact No.");
                  CLEAR(Opp."Contact Company No.");
                  Opp.MODIFY;
                UNTIL Opp.NEXT = 0;
        
              Todo.RESET;
              Todo.SETCURRENTKEY("Contact Company No.");
              Todo.SETRANGE("Contact Company No.","Company No.");
              IF Todo.FIND('-') THEN
                REPEAT
                  CLEAR(Todo."Contact No.");
                  CLEAR(Todo."Contact Company No.");
                  Todo.MODIFY;
                UNTIL Todo.NEXT = 0;
            END;
          Type::Person:
            BEGIN
              ContJobResp.SETRANGE("Contact No.","No.");
              ContJobResp.DELETEALL;
        
              InteractLogEntry.SETCURRENTKEY("Contact Company No.","Contact No.");
              InteractLogEntry.SETRANGE("Contact Company No.","Company No.");
              InteractLogEntry.SETRANGE("Contact No.","No.");
              InteractLogEntry.MODIFYALL("Contact No.","Company No.");
        
              Opp.RESET;
              Opp.SETCURRENTKEY("Contact Company No.","Contact No.");
              Opp.SETRANGE("Contact Company No.","Company No.");
              Opp.SETRANGE("Contact No.","No.");
              Opp.MODIFYALL("Contact No.","Company No.");
        
              Todo.RESET;
              Todo.SETCURRENTKEY("Contact Company No.","Contact No.");
              Todo.SETRANGE("Contact Company No.","Company No.");
              Todo.SETRANGE("Contact No.","No.");
              Todo.MODIFYALL("Contact No.","Company No.");
            END;
        END;
        
        ContMailingGrp.SETRANGE("Contact No.","No.");
        ContMailingGrp.DELETEALL;
        
        ContProfileAnswer.SETRANGE("Contact No.","No.");
        ContProfileAnswer.DELETEALL;
        
        RMCommentLine.SETRANGE("Table Name",RMCommentLine."Table Name"::Contact);
        RMCommentLine.SETRANGE("No.","No.");
        RMCommentLine.SETRANGE("Sub No.",0);
        RMCommentLine.DELETEALL;
        
        ContAltAddr.SETRANGE("Contact No.","No.");
        ContAltAddr.DELETEALL;
        
        ContAltAddrDateRange.SETRANGE("Contact No.","No.");
        ContAltAddrDateRange.DELETEALL;
        
        VATRegistrationLogMgt.DeleteContactLog(Rec);
        */

    end;

    trigger OnInsert()
    begin
        /*RMSetup.GET;
        
        IF "No." = '' THEN BEGIN
          RMSetup.TESTFIELD("Contact Nos.");
          NoSeriesMgt.InitSeries(RMSetup."Contact Nos.",xRec."No. Series",0D,"No.","No. Series");
        END;*/
        
        /*
        IF NOT SkipDefaults THEN BEGIN
          IF "Salesperson Code" = '' THEN
            "Salesperson Code" := RMSetup."Default Salesperson Code";
          IF "Territory Code" = '' THEN
            "Territory Code" := RMSetup."Default Territory Code";
          IF "Country/Region Code" = '' THEN
            "Country/Region Code" := RMSetup."Default Country/Region Code";
          IF "Language Code" = '' THEN
            "Language Code" := RMSetup."Default Language Code";
          IF "Correspondence Type" = "Correspondence Type"::" " THEN
            "Correspondence Type" := RMSetup."Default Correspondence Type";
          IF "Salutation Code" = '' THEN
            IF Type = Type::Company THEN
              "Salutation Code" := RMSetup."Def. Company Salutation Code"
            ELSE
              "Salutation Code" := RMSetup."Default Person Salutation Code";
        END;
        
        TypeChange;
        */
        
        //"Last Date Modified" := TODAY;
        //"Last Time Modified" := TIME;

    end;

    trigger OnModify()
    begin
        //OnModify(xRec);
    end;

    trigger OnRename()
    begin
        //VALIDATE("Lookup Contact No.");
    end;

    var
        Text000: Label 'You cannot delete the %2 record of the %1 because there are one or more to-dos open.';
        Text001: Label 'You cannot delete the %2 record of the %1 because the contact is assigned one or more unlogged segments.';
        Text002: Label 'You cannot delete the %2 record of the %1 because one or more opportunities are in not started or progress.';
        Text003: Label '%1 cannot be changed because one or more interaction log entries are linked to the contact.';
        Text005: Label '%1 cannot be changed because one or more to-dos are linked to the contact.';
        Text006: Label '%1 cannot be changed because one or more opportunities are linked to the contact.';
        Text007: Label '%1 cannot be changed because there are one or more related people linked to the contact.';
        Text009: Label 'The %2 record of the %1 has been created.';
        Text010: Label 'The %2 record of the %1 is not linked with any other table.';
        RMSetup: Record "Marketing Setup";
        Cont: Record Contact;
        ContBusRel: Record "Contact Business Relation";
        PostCode: Record "Post Code";
        DuplMgt: Codeunit DuplicateManagement;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        UpdateCustVendBank: Codeunit "CustVendBank-Update";
        CampaignMgt: Codeunit "Campaign Target Group Mgt";
        ContChanged: Boolean;
        SkipDefaults: Boolean;
        Text012: Label 'You cannot change %1 because one or more unlogged segments are assigned to the contact.';
        Text019: Label 'The %2 record of the %1 already has the %3 with %4 %5.';
        Text020: Label 'Do you want to create a contact %1 %2 as a customer using a customer template?';
        Text021: Label 'You have to set up formal and informal salutation formulas in %1  language for the %2 contact.';
        HideValidationDialog: Boolean;
        Text022: Label 'The creation of the customer has been aborted.';
        Text029: Label 'The total length of first name, middle name and surname is %1 character(s)longer than the maximum length allowed for the Name field.';
        Text032: Label 'The length of %1 is %2 character(s)longer than the maximum length allowed for the %1 field.';
        Text033: Label 'Before you can use Online Map, you must fill in the Online Map Setup window.\See Setting Up Online Map in Help.';
        Cust: Record Customer;

    procedure OnModify(xRec: Record Contact)
    var
        OldCont: Record Contact;
    begin
        
        /*
        IF Type = Type::Company THEN BEGIN
          IF (Name <> xRec.Name) OR
             ("Search Name" <> xRec."Search Name") OR
             ("Name 2" <> xRec."Name 2") OR
             (Address <> xRec.Address) OR
             ("Address 2" <> xRec."Address 2") OR
             (City <> xRec.City) OR
             ("Phone No." <> xRec."Phone No.") OR
             ("Telex No." <> xRec."Telex No.") OR
             ("Territory Code" <> xRec."Territory Code") OR
             ("Currency Code" <> xRec."Currency Code") OR
             ("Language Code" <> xRec."Language Code") OR
             ("Salesperson Code" <> xRec."Salesperson Code") OR
             ("Country/Region Code" <> xRec."Country/Region Code") OR
             ("Fax No." <> xRec."Fax No.") OR
             ("Telex Answer Back" <> xRec."Telex Answer Back") OR
             ("VAT Registration No." <> xRec."VAT Registration No.") OR
             ("Post Code" <> xRec."Post Code") OR
             (County <> xRec.County) OR
             ("E-Mail" <> xRec."E-Mail") OR
             ("Home Page" <> xRec."Home Page")
          THEN
            UpdateCustVendBank.RUN(Rec);
        
          RMSetup.GET;
          Cont.RESET;
          Cont.SETCURRENTKEY("Company No.");
          Cont.SETRANGE("Company No.","No.");
          Cont.SETRANGE(Type,Type::Person);
          IF Cont.FIND('-') THEN
            REPEAT
              ContChanged := FALSE;
              OldCont := Cont;
              IF Name <> xRec.Name THEN BEGIN
                Cont."Company Name" := Name;
                ContChanged := TRUE;
              END;
              IF RMSetup."Inherit Salesperson Code" AND
                 (xRec."Salesperson Code" <> "Salesperson Code") AND
                 (xRec."Salesperson Code" = Cont."Salesperson Code")
              THEN BEGIN
                Cont."Salesperson Code" := "Salesperson Code";
                ContChanged := TRUE;
              END;
              IF RMSetup."Inherit Territory Code" AND
                 (xRec."Territory Code" <> "Territory Code") AND
                 (xRec."Territory Code" = Cont."Territory Code")
              THEN BEGIN
                Cont."Territory Code" := "Territory Code";
                ContChanged := TRUE;
              END;
              IF RMSetup."Inherit Country/Region Code" AND
                 (xRec."Country/Region Code" <> "Country/Region Code") AND
                 (xRec."Country/Region Code" = Cont."Country/Region Code")
              THEN BEGIN
                Cont."Country/Region Code" := "Country/Region Code";
                ContChanged := TRUE;
              END;
              IF RMSetup."Inherit Language Code" AND
                 (xRec."Language Code" <> "Language Code") AND
                 (xRec."Language Code" = Cont."Language Code")
              THEN BEGIN
                Cont."Language Code" := "Language Code";
                ContChanged := TRUE;
              END;
              IF RMSetup."Inherit Address Details" THEN
                IF xRec.IdenticalAddress(Cont) THEN BEGIN
                  IF xRec.Address <> Address THEN BEGIN
                    Cont.Address := Address;
                    ContChanged := TRUE;
                  END;
                  IF xRec."Address 2" <> "Address 2" THEN BEGIN
                    Cont."Address 2" := "Address 2";
                    ContChanged := TRUE;
                  END;
                  IF xRec."Post Code" <> "Post Code" THEN BEGIN
                    Cont."Post Code" := "Post Code";
                    ContChanged := TRUE;
                  END;
                  IF xRec.City <> City THEN BEGIN
                    Cont.City := City;
                    ContChanged := TRUE;
                  END;
                  IF xRec.County <> County THEN BEGIN
                    Cont.County := County;
                    ContChanged := TRUE;
                  END;
                END;
              IF RMSetup."Inherit Communication Details" THEN BEGIN
                IF (xRec."Phone No." <> "Phone No.") AND (xRec."Phone No." = Cont."Phone No.") THEN BEGIN
                  Cont."Phone No." := "Phone No.";
                  ContChanged := TRUE;
                END;
                IF (xRec."Telex No." <> "Telex No.") AND (xRec."Telex No." = Cont."Telex No.") THEN BEGIN
                  Cont."Telex No." := "Telex No.";
                  ContChanged := TRUE;
                END;
                IF (xRec."Fax No." <> "Fax No.") AND (xRec."Fax No." = Cont."Fax No.") THEN BEGIN
                  Cont."Fax No." := "Fax No.";
                  ContChanged := TRUE;
                END;
                IF (xRec."Telex Answer Back" <> "Telex Answer Back") AND (xRec."Telex Answer Back" = Cont."Telex Answer Back") THEN BEGIN
                  Cont."Telex Answer Back" := "Telex Answer Back";
                  ContChanged := TRUE;
                END;
                IF (xRec."E-Mail" <> "E-Mail") AND (xRec."E-Mail" = Cont."E-Mail") THEN BEGIN
                  Cont.VALIDATE("E-Mail","E-Mail");
                  ContChanged := TRUE;
                END;
                IF (xRec."Home Page" <> "Home Page") AND (xRec."Home Page" = Cont."Home Page") THEN BEGIN
                  Cont."Home Page" := "Home Page";
                  ContChanged := TRUE;
                END;
                IF (xRec."Extension No." <> "Extension No.") AND (xRec."Extension No." = Cont."Extension No.") THEN BEGIN
                  Cont."Extension No." := "Extension No.";
                  ContChanged := TRUE;
                END;
                IF (xRec."Mobile Phone No." <> "Mobile Phone No.") AND (xRec."Mobile Phone No." = Cont."Mobile Phone No.") THEN BEGIN
                  Cont."Mobile Phone No." := "Mobile Phone No.";
                  ContChanged := TRUE;
                END;
                IF (xRec.Pager <> Pager) AND (xRec.Pager = Cont.Pager) THEN BEGIN
                  Cont.Pager := Pager;
                  ContChanged := TRUE;
                END;
              END;
              IF ContChanged THEN BEGIN
                Cont.OnModify(OldCont);
                Cont.MODIFY;
              END;
            UNTIL Cont.NEXT = 0;
        
          IF (Name <> xRec.Name) OR
             ("Name 2" <> xRec."Name 2") OR
             (Address <> xRec.Address) OR
             ("Address 2" <> xRec."Address 2") OR
             (City <> xRec.City) OR
             ("Post Code" <> xRec."Post Code") OR
             ("VAT Registration No." <> xRec."VAT Registration No.") OR
             ("Phone No." <> xRec."Phone No.")
          THEN
            CheckDupl;
        END;
        */

    end;

    procedure AssistEdit(OldCont: Record Contact): Boolean
    begin
        /*WITH Cont DO BEGIN
          Cont := Rec;
          RMSetup.GET;
          RMSetup.TESTFIELD("Contact Nos.");
          IF NoSeriesMgt.SelectSeries(RMSetup."Contact Nos.",OldCont."No. Series","No. Series") THEN BEGIN
            RMSetup.GET;
            RMSetup.TESTFIELD("Contact Nos.");
            NoSeriesMgt.SetSeries("No.");
            Rec := Cont;
            EXIT(TRUE);
          END;
        END;
        */

    end;
}

