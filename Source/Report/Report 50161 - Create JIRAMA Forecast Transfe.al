report 50161 "Create JIRAMA Forecast Transfe"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Integer";"Integer")
        {
            DataItemTableView = SORTING(Number) ORDER(Ascending) WHERE(Number=CONST(1));

            trigger OnAfterGetRecord()
            begin
                JIRAMAMgt.AddNewTransfert(ForecastNum,ToCodeClient,FromCodeClient,Volume,Descr,ToNomClient,FromNomClient,ToSite,FromSite);
            end;

            trigger OnPreDataItem()
            begin
                SetRange(Number,1);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(FromCodeClient;FromCodeClient)
                {
                    Caption = 'Du code agence';

                    trigger OnLookup(var Text: Text): Boolean
                    begin

                        Cust.Reset;
                        Cust.SetCurrentKey(Cust."Sales Channel Code");
                        Cust.SetRange(Cust."Sales Channel Code",AddOnSetup."JIRAMA Sales Channel");
                        if PAGE.RunModal(22, Cust) = ACTION::LookupOK then
                        begin
                          Cust.TestField(Cust."Sales Channel Code",AddOnSetup."JIRAMA Sales Channel");
                          Cust.TestField(Cust."Sales Category Code",AddOnSetup."PBL Sales Category");
                          FromCodeClient := Cust."No.";
                          FromNomClient := Cust.Name;
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        if Cust.Get(FromCodeClient) then
                          FromNomClient := Cust.Name;
                    end;
                }
                field(FromSite;FromSite)
                {
                    Caption = 'Du site';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        ShipToAddress: Record "Ship-to Address";
                    begin
                        ShipToAddress.Reset;
                        ShipToAddress.SetRange("Customer No.",FromCodeClient);
                        if PAGE.RunModal(301, ShipToAddress) = ACTION::LookupOK then
                        begin
                          //Cust.TESTFIELD(Cust."Sales Channel Code",AddOnSetup."JIRAMA Sales Channel");
                          //Cust.TESTFIELD(Cust."Sales Category Code",AddOnSetup."PBL Sales Category");
                          FromSite := ShipToAddress.Code;

                        end;
                    end;
                }
                field(FromNomClient;FromNomClient)
                {
                    Caption = 'Nom de l''agence (Origine)';
                    Editable = false;
                }
                field(Volume;Volume)
                {
                    Caption = 'Volume à transférer';
                }
                field(ToCodeClient;ToCodeClient)
                {
                    Caption = 'Vers code agence';

                    trigger OnLookup(var Text: Text): Boolean
                    begin

                        Cust.Reset;
                        Cust.SetCurrentKey(Cust."Sales Channel Code");
                        Cust.SetRange(Cust."Sales Channel Code",AddOnSetup."JIRAMA Sales Channel");
                        if PAGE.RunModal(22, Cust) = ACTION::LookupOK then
                        begin
                          Cust.TestField(Cust."Sales Channel Code",AddOnSetup."JIRAMA Sales Channel");
                          Cust.TestField(Cust."Sales Category Code",AddOnSetup."PBL Sales Category");
                          ToCodeClient := Cust."No.";
                          ToNomClient := Cust.Name;
                        end;
                    end;

                    trigger OnValidate()
                    begin
                        if Cust.Get(ToCodeClient) then
                          ToNomClient := Cust.Name;
                    end;
                }
                field(ToSite;ToSite)
                {
                    Caption = 'Vers le site';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        ShipToAddress: Record "Ship-to Address";
                    begin
                        ShipToAddress.Reset;
                        ShipToAddress.SetRange(ShipToAddress."Customer No.",ToCodeClient);
                        if PAGE.RunModal(301, ShipToAddress) = ACTION::LookupOK then
                        begin
                          //Cust.TESTFIELD(Cust."Sales Channel Code",AddOnSetup."JIRAMA Sales Channel");
                          //Cust.TESTFIELD(Cust."Sales Category Code",AddOnSetup."PBL Sales Category");
                          ToSite := ShipToAddress.Code;

                        end;
                    end;
                }
                field(ToNomClient;ToNomClient)
                {
                    Caption = 'Nom de l''agence (Destination)';
                    Editable = false;
                }
                field(Descr;Descr)
                {
                    Caption = 'Description';
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(Validate)
                {
                    Caption = 'Valider le transfert de quota';
                    Image = PostDocument;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                }
            }
        }

        trigger OnOpenPage()
        begin
            AddOnSetup.Get;
            AddOnSetup.TestField("JIRAMA Sales Channel");
        end;
    }

    labels
    {
    }

    var
        FromCodeClient: Code[20];
        ToCodeClient: Code[20];
        Volume: Decimal;
        FromNomClient: Text[50];
        ToNomClient: Text[50];
        Cust: Record Customer;
        AddOnSetup: Record "AddOn Setup";
        ForecastNum: Code[20];
        JIRAMAMgt: Codeunit "JIRAMA Sales Mgt";
        Descr: Text[50];
        FromSite: Code[10];
        ToSite: Code[10];

    procedure SetForeCastNo(NewNo: Code[20])
    begin
        ForecastNum := NewNo;
    end;
}

