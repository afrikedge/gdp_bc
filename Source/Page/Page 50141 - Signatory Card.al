page 50141 "Signatory Card"
{
    Caption = 'Contact Card';
    PageType = ListPlus;
    SourceTable = Signatory;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {

                    trigger OnAssistEdit()
                    begin
                        //IF AssistEdit(xRec) THEN
                        //  CurrPage.UPDATE;
                    end;
                }
                field("Company No."; Rec."Company No.")
                {
                }
                field("Company Name"; Rec."Company Name")
                {
                    AssistEdit = true;

                    trigger OnAssistEdit()
                    begin
                        /*
                        Cont.SETRANGE("No.","Company No.");
                        CLEAR(CompanyDetails);
                        CompanyDetails.SETTABLEVIEW(Cont);
                        CompanyDetails.SETRECORD(Cont);
                        IF Type = Type::Person THEN
                          CompanyDetails.EDITABLE := FALSE;
                        CompanyDetails.RUNMODAL;
                        */

                    end;
                }
                field(Name; Rec.Name)
                {
                    AssistEdit = true;

                    trigger OnAssistEdit()
                    begin
                        /*
                        MODIFY;
                        COMMIT;
                        Cont.SETRANGE("No.","No.");
                        IF Type = Type::Person THEN BEGIN
                          CLEAR(NameDetails);
                          NameDetails.SETTABLEVIEW(Cont);
                          NameDetails.SETRECORD(Cont);
                          NameDetails.RUNMODAL;
                        END ELSE BEGIN
                          CLEAR(CompanyDetails);
                          CompanyDetails.SETTABLEVIEW(Cont);
                          CompanyDetails.SETRECORD(Cont);
                          CompanyDetails.RUNMODAL;
                        END;
                        GET("No.");
                        CurrPage.UPDATE;
                        */

                    end;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("&Signature")
            {
                Caption = '&Signature';
                Ellipsis = true;
                Image = Picture;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Signatory Picture";
                RunPageLink = "No." = FIELD("No.");
            }
            action("Co&mments")
            {
                Caption = 'Comments';
                Image = ViewComments;
                RunObject = Page "Rlshp. Mgt. Comment Sheet";
                RunPageLink = "Table Name" = CONST(Contact),
                              "No." = FIELD("No."),
                              "Sub No." = CONST(0);
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        CRMCouplingManagement: Codeunit "CRM Coupling Management";
    begin
        /*
        xRec := Rec;
        EnableFields;
        
        IF Type = Type::Person THEN
          IntegrationFindCustomerNo
        ELSE
          IntegrationCustomerNo := '';
        
        IF CRMIntegrationEnabled THEN
          CRMIsCoupledToRecord := CRMCouplingManagement.IsRecordCoupledToCRM(RECORDID);
        */

    end;

    trigger OnInit()
    begin
        /*
        "Stock CapitalEnable" := TRUE;
        "Legal FormEnable" := TRUE;
        "APE CodeEnable" := TRUE;
        "Trade RegisterEnable" := TRUE;
        NoofJobResponsibilitiesEnable := TRUE;
        OrganizationalLevelCodeEnable := TRUE;
        "Company NameEnable" := TRUE;
        "Company No.Enable" := TRUE;
        "VAT Registration No.Enable" := TRUE;
        "Currency CodeEnable" := TRUE;
        MapPointVisible := TRUE;
        */

    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    var
        Contact: Record Contact;
    begin
        /*
        IF GETFILTER("Company No.") <> '' THEN BEGIN
          "Company No." := GETRANGEMAX("Company No.");
          Type := Type::Person;
          Contact.GET("Company No.");
          InheritCompanyToPersonData(Contact,TRUE)
        END;
        */

    end;

    trigger OnOpenPage()
    var
        MapMgt: Codeunit "Online Map Management";
        CRMIntegrationManagement: Codeunit "CRM Integration Management";
    begin
        /*
        IF NOT MapMgt.TestSetup THEN
          MapPointVisible := FALSE;
        
        CRMIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled;
        */

    end;

    var
        Cont: Record Contact;
        CompanyDetails: Page "Company Details";
        NameDetails: Page "Name Details";
        IntegrationCustomerNo: Code[20];
        [InDataSet]
        MapPointVisible: Boolean;
        [InDataSet]
        "Currency CodeEnable": Boolean;
        [InDataSet]
        "VAT Registration No.Enable": Boolean;
        [InDataSet]
        "Company No.Enable": Boolean;
        [InDataSet]
        "Company NameEnable": Boolean;
        [InDataSet]
        OrganizationalLevelCodeEnable: Boolean;
        [InDataSet]
        NoofJobResponsibilitiesEnable: Boolean;
        [InDataSet]
        "Trade RegisterEnable": Boolean;
        [InDataSet]
        "APE CodeEnable": Boolean;
        [InDataSet]
        "Legal FormEnable": Boolean;
        [InDataSet]
        "Stock CapitalEnable": Boolean;
        CompanyGroupEnabled: Boolean;
        PersonGroupEnabled: Boolean;
        CRMIntegrationEnabled: Boolean;
        CRMIsCoupledToRecord: Boolean;
}

