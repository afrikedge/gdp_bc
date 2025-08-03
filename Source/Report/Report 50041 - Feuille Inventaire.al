report 50041 "Feuille Inventaire"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Source/Report/Layout/Feuille Inventaire.rdlc';
    PreviewMode = PrintLayout;
    ApplicationArea = All;

    dataset
    {
        dataitem("Item Journal Batch"; "Item Journal Batch")
        {
            RequestFilterFields = "Journal Template Name", Name;
            column(TemplateName_ItemJnlBatch; "Journal Template Name")
            {
            }
            column(Name_ItemJournalBatch; Name)
            {
            }
            column(CompanyAddr1; CompanyAddr[1])
            {
            }
            column(CompanyAddr2; CompanyAddr[2])
            {
            }
            column(CompanyAddr3; CompanyAddr[3])
            {
            }
            column(CompanyAddr4; CompanyAddr[4])
            {
            }
            column(CompanyInfo_Picture; CompanyInfo.Picture)
            {
            }
            column(ItemCaption; ItemCaption)
            {
            }
            column(QuantityCaption; QuantityCaption)
            {
            }
            column(ObservationCaption; ObservationCaption)
            {
            }
            column(InventoryText; InventoryText)
            {
            }
            column(TotalText; TotalText)
            {
            }
            column(LocationText; LocationText)
            {
            }
            column(LocationCaption; LocationCaption)
            {
            }
            column(ItemCodeCaption; ItemCodeCaption)
            {
            }
            dataitem("Item Journal Line"; "Item Journal Line")
            {
                DataItemLink = "Journal Template Name" = FIELD("Journal Template Name"), "Journal Batch Name" = FIELD(Name);
                DataItemTableView = SORTING("Journal Template Name", "Journal Batch Name", "Line No.");
                RequestFilterFields = "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", "Location Code", "Bin Code";
                column(PostingDt_ItemJournalLine; Format("Posting Date"))
                {
                }
                column(DocNo_ItemJournalLine; "Document No.")
                {
                }
                column(ItemNo_ItemJournalLine; "Item No.")
                {
                }
                column(Desc_ItemJournalLine; Description)
                {
                }
                column(LocCode_ItemJournalLine; "Location Code")
                {
                }
                column(QtyCalculated_ItemJnlLin; "Qty. (Calculated)")
                {
                }
                column(BinCode_ItemJournalLine; "Bin Code")
                {
                }
                column(LineNo_ItemJournalLine; "Line No.")
                {
                }
                column(LocationName; Location.Name)
                {
                }

                trigger OnPreDataItem()
                begin
                    if "Item Journal Line"."Bin Code" <> '' then
                        Location.Get("Item Journal Line"."Bin Code");
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if ItemJournalTemplate.Get("Journal Template Name") then
                    if ItemJournalTemplate.Type <> ItemJournalTemplate.Type::"Phys. Inventory" then
                        CurrReport.Skip;

                FormatAddr.Company(CompanyAddr, CompanyInfo);
            end;
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

    labels
    {
        Sign = 'Signature';
        Name = 'Nom';
        Date = 'Date';
        CDG = 'CONTRËLE DE GESTION';
        Other = 'AUTRE(S)';
        Resp = 'RESPONSABLE MAGASIN';
        Date_Time = 'Date et Heure d''impression';
    }

    trigger OnInitReport()
    begin
        CompanyInfo.Get;
        CompanyInfo.CalcFields(Picture);
    end;

    var
        ItemJournalTemplate: Record "Item Journal Template";
        ItemJnlLine: Record "Item Journal Line";
        ItemCaption: Label 'ARTICLES';
        QuantityCaption: Label 'STOCKS PHYSIQUES';
        ObservationCaption: Label 'OBSERVATION(S)';
        InventoryText: Label 'FICHE D''INVENTAIRE AU : .........../............/...........';
        TotalText: Label 'TOTAL';
        LocationText: Label 'LOCALITE :';
        CompanyInfo: Record "Company Information";
        CompanyAddr: array[8] of Text[50];
        FormatAddr: Codeunit "Format Address";
        LocationCaption: Label 'Magasin';
        Location: Record Location;
        ItemCodeCaption: Label 'CODE';
}

