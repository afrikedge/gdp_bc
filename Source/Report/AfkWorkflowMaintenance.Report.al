

report 50061 "Afk Workflow Maintenance"
{
    ApplicationArea = All;
    Caption = 'Afk Workflow Maintenance';
    UsageCategory = Tasks;
    ProcessingOnly = true;
    dataset
    {
        dataitem(PurchaseHeader; "Purchase Header")
        {
            RequestFilterFields = "Document Type", "No.";
            trigger OnAfterGetRecord()
            var
                function: Codeunit "Record Restriction Mgt.";
            begin
                function.AllowRecordUsage(PurchaseHeader);
                i += 1;
            end;

            trigger OnPreDataItem()
            var
            begin
                i := 0;
            end;

            trigger OnPostDataItem()
            var
            begin
                Message('Traitement termine\%1 traites', i);
            end;
        }
    }
    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                }
            }
        }
        actions
        {
            area(Processing)
            {
            }
        }
    }
    var
        i: Integer;
}
