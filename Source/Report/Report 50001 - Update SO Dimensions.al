report 50001 "Update SO Dimensions"
{
    ProcessingOnly = true;

    dataset
    {
        dataitem("Sales Header";"Sales Header")
        {
            DataItemTableView = SORTING("Document Type","No.") WHERE("Document Type"=CONST(Order));
            RequestFilterFields = "No.";

            trigger OnAfterGetRecord()
            var
                SalesL: Record "Sales Line";
            begin
                
                BesoinNo := BesoinNo + 1;
                Window.Update(1,Round(BesoinNo / NbreTotalLignes * 10000,1));
                
                ManuelReOpen := false;
                
                /*IF "Sales Header".Status = "Sales Header".Status::Released THEN BEGIN
                  ReleaseSalesDocument.PerformManualReopen("Sales Header");
                  ManuelReOpen := TRUE;
                END;*/
                
                SalesL.Reset;
                SalesL.SetRange(SalesL."Document Type","Sales Header"."Document Type");
                SalesL.SetRange(SalesL."Document No.","Sales Header"."No.");
                if SalesL.FindSet then repeat
                  if SalesL.Type = SalesL.Type::Item then begin
                     UpdateDim(SalesL."Dimension Set ID",SalesL."No.");
                     SalesL.Modify;
                  end;
                until SalesL.Next = 0;
                
                //IF ManuelReOpen THEN
                //  ReleaseSalesDocument.PerformManualRelease("Sales Header");

            end;

            trigger OnPostDataItem()
            begin

                Window.Close;
                Message(TxtTraitementTerminé);
            end;

            trigger OnPreDataItem()
            begin

                BesoinNo := 0;
                NbreTotalLignes := "Sales Header".Count;
                Window.Open(Text008);

                if SelectedDimCode='' then Error(TextErrDim);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(SelectedDimCode;SelectedDimCode)
                {
                    Caption = 'Dimension code';
                    TableRelation = Dimension;
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    var
        ReleaseSalesDocument: Codeunit "Release Sales Document";
        ManuelReOpen: Boolean;
        Text008: Label 'Process @1@@@@@@@@@@@@@@@@@@@@@@@@@@@@\';
        "TxtTraitementTerminé": Label 'Process terminated !';
        BesoinNo: Integer;
        NbreTotalLignes: Integer;
        Window: Dialog;
        DimMgt: Codeunit DimensionManagement;
        SelectedDimCode: Code[20];
        TextErrDim: Label 'Please select Dimension Code';

    local procedure UpdateDim(var DimSetID: Integer;ItemNo: Code[20])
    var
        DimVal: Record "Dimension Value";
        TempDimSetEntry: Record "Dimension Set Entry" temporary;
        TempDimSetEntry_Item: Record "Dimension Set Entry" temporary;
        Item: Record Item;
        DefaultDim: Record "Default Dimension";
    begin
        DimMgt.GetDimensionSet(TempDimSetEntry,DimSetID);

        if DefaultDim.Get(DATABASE::Item,ItemNo,SelectedDimCode) then begin

          DefaultDim.TestField(DefaultDim."Dimension Value Code");
          DimVal.Get(SelectedDimCode,DefaultDim."Dimension Value Code");

          if TempDimSetEntry.Get(TempDimSetEntry."Dimension Set ID",DimVal."Dimension Code") then begin
            TempDimSetEntry."Dimension Value Code" := DimVal.Code;
            TempDimSetEntry."Dimension Value ID" := DimVal."Dimension Value ID";
            TempDimSetEntry.Modify;
          end else begin
            TempDimSetEntry.Init;
            TempDimSetEntry."Dimension Code" := DimVal."Dimension Code";
            TempDimSetEntry."Dimension Value Code" := DimVal.Code;
            TempDimSetEntry."Dimension Value ID" := DimVal."Dimension Value ID";
            if TempDimSetEntry.Insert then;
          end;

        end;

        DimSetID := DimMgt.GetDimensionSetID(TempDimSetEntry);
    end;
}

