xmlport 50000 "Import Fuel Statement"
{
    Caption = 'Import Fuel Statement';
    Direction = Import;
    FieldDelimiter = '<None>';
    FieldSeparator = '<TAB>';
    Format = VariableText;
    TextEncoding = WINDOWS;

    schema
    {
        textelement(Root)
        {
            tableelement("Import Fuel Statement";"Import Fuel Statement")
            {
                AutoSave = false;
                XmlName = 'ImportData';
                fieldattribute(TagID;"Import Fuel Statement".TagID)
                {
                }
                fieldattribute(SourceAppro;"Import Fuel Statement"."Source Appro")
                {
                }
                fieldattribute(LicencePlateName;"Import Fuel Statement"."License plate number")
                {
                }
                fieldattribute(EquipmentIDNumber;"Import Fuel Statement"."Equipement ID number")
                {
                }
                fieldattribute(Manufacturer;"Import Fuel Statement".Manufacturor)
                {
                }
                fieldattribute(CarType;"Import Fuel Statement"."Car Type")
                {
                }
                fieldattribute(EquipmentType;"Import Fuel Statement"."Equipment Type")
                {
                }
                fieldattribute(Process;"Import Fuel Statement".Process)
                {
                }
                fieldattribute(ProjectCode;"Import Fuel Statement"."Project Code")
                {
                }
                fieldattribute(CostCode;"Import Fuel Statement"."Cost Code")
                {
                }
                fieldattribute(DepartementName;"Import Fuel Statement"."Departement name")
                {
                }
                fieldattribute(Pump;"Import Fuel Statement".Pump)
                {
                }
                fieldattribute(DateRefuel;"Import Fuel Statement".DateRefuel)
                {
                }
                fieldattribute(TimeRefuel;"Import Fuel Statement".TimeRefuel)
                {
                }
                fieldattribute(TotalCounter;"Import Fuel Statement"."Total Counter")
                {
                }
                fieldattribute(VehiculeOdometer;"Import Fuel Statement"."Vehicle Odometer")
                {
                }
                fieldattribute(Driver;"Import Fuel Statement".Driver)
                {
                }
                fieldattribute(BadgeNum;"Import Fuel Statement"."Badge Number")
                {
                }
                fieldattribute(DateControl;"Import Fuel Statement"."Date of control")
                {
                }
                fieldattribute(ValidatedBy;"Import Fuel Statement"."Validated by")
                {
                }

                trigger OnAfterInsertRecord()
                var
                    StrSource: Text[50];
                begin

                    LineNo:=LineNo+1;

                    FSLine.Init;
                    FSLine."Document No." := FSNumber;
                    FSLine."Line No." := LineNo;
                    FSLine.TagID := "Import Fuel Statement".TagID;

                    StrSource:= "Import Fuel Statement"."Source Appro";
                    if StrPos(UpperCase(StrSource),'STATION')>0 then
                      FSLine."Source Appro" := FSLine."Source Appro"::Station
                    else
                      FSLine."Source Appro" := FSLine."Source Appro"::Tanker;


                    //FSLine."License plate number":= AsciiConv.Ascii2Ansi("Import Fuel Statement"."License plate number");
                    FSLine."License plate number":= ("Import Fuel Statement"."License plate number");



                    FSLine."Equipement ID number" := "Import Fuel Statement"."Equipement ID number";
                    FSLine.Manufacturor := "Import Fuel Statement".Manufacturor;
                    FSLine."Car Type":= "Import Fuel Statement"."Car Type";
                    if UpperCase("Import Fuel Statement"."Equipment Type")='MOBILE' then
                      FSLine."Equipment Type":=  FSLine."Equipment Type"::Mobile
                    else
                      FSLine."Equipment Type":=  FSLine."Equipment Type"::Fixed;

                    //IF ((UPPERCASE("Import Fuel Statement".BackCharge)<>'NON') AND (UPPERCASE("Import Fuel Statement".BackCharge)<>'NO')) THEN
                    //  FSLine.BackCharge:= TRUE;

                    if (UpperCase("Import Fuel Statement".Process)='PROCESS') then
                      FSLine.Process:= true;

                    FSLine."Project Code":= "Import Fuel Statement"."Project Code";
                    FSLine."Cost Code":= "Import Fuel Statement"."Cost Code";
                    FSLine."Departement name" := "Import Fuel Statement"."Departement name";

                    FSLine."Cost Center":= "Import Fuel Statement"."Cost Center";
                    FSLine.Pump:= "Import Fuel Statement".Pump;
                    Evaluate(FSLine.DateRefuel,"Import Fuel Statement".DateRefuel);
                    FSLine.TimeRefuel:= "Import Fuel Statement".TimeRefuel;
                    FSLine."Total Counter":= "Import Fuel Statement"."Total Counter";
                    FSLine."Vehicle Odometer":= "Import Fuel Statement"."Vehicle Odometer";
                    //FSLine.Company:= "Import Fuel Statement".Company;
                    FSLine.Driver:= "Import Fuel Statement".Driver;

                    FSLine."Badge Number":= "Import Fuel Statement"."Badge Number";
                    Evaluate(FSLine."Date of control","Import Fuel Statement"."Date of control");
                    FSLine."Validated by":= "Import Fuel Statement"."Validated by";

                    FSLine.Insert;
                end;
            }
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    trigger OnPostXmlPort()
    begin

        //Window.CLOSE;
        Message(TxtTraitementTerminé);
    end;

    trigger OnPreXmlPort()
    begin

        LineNo := 0;
        BesoinNo :=0;
        //Window.OPEN(Text008);


        FSLine.Reset;
        FSLine.SetRange(FSLine."Document No.",FSNumber);
        FSLine.DeleteAll;
    end;

    var
        LineNo: Integer;
        BesoinNo: Integer;
        NbreTotalLignes: Integer;
        Window: Dialog;
        Text008: Label 'Process @1@@@@@@@@@@@@@@@@@@@@@@@@@@@@\';
        "TxtTraitementTerminé": Label 'Traitement términé !';
        FSLine: Record "Fuel Statement Line";
        FSNumber: Code[20];

    procedure SetFSNumber(FSNum: Code[20])
    begin
        FSNumber:=FSNum;
    end;
}

