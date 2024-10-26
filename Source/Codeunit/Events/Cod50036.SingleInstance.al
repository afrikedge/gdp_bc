codeunit 50036 SingleInstance
{
    SingleInstance = true;

    var
        AFK_EscapeCheck_MultiLevelAdjmt: Boolean;
        SendVendorEmails_AFK: Boolean;
        AllowDeletionSalesHeader: Boolean;
        IsSolderCommande: Boolean;
        SalesPriceDate: Date;
        CanUpdateAchatDevise: Boolean;
        IsAfkShowItemWarning: Boolean;
        AfkInventoryPostingToGL: codeunit "Inventory Posting To G/L";
        IsPostingSortieImmo: Boolean;

    procedure Set_AFK_EscapeCheck_MultiLevelAdjmt(EscapeCheck: Boolean)
    begin
        AFK_EscapeCheck_MultiLevelAdjmt := EscapeCheck;
    end;

    procedure Get_AFK_EscapeCheck_MultiLevelAdjmt(): Boolean
    begin
        exit(AFK_EscapeCheck_MultiLevelAdjmt);
    end;

    procedure Clear_AFK_EscapeCheck_MultiLevelAdjmt()
    begin
        AFK_EscapeCheck_MultiLevelAdjmt := false;
    end;

    procedure Set_SendVendorEmails_AFK(sendEmail: Boolean)
    begin
        SendVendorEmails_AFK := sendEmail;
    end;

    procedure Get_SendVendorEmails_AFK(): Boolean
    begin
        exit(SendVendorEmails_AFK);
    end;

    procedure Set_SalesPriceDate(SalesPriceDate1: Date)
    begin
        SalesPriceDate := SalesPriceDate1;
    end;

    procedure Get_SalesPriceDate(): Date
    begin
        exit(SalesPriceDate);
    end;

    procedure Set_AllowDeletionSalesHeader(Allow: Boolean)
    begin
        AllowDeletionSalesHeader := Allow;
    end;

    procedure Get_AllowDeletionSalesHeader(): Boolean
    begin
        exit(AllowDeletionSalesHeader);
    end;

    procedure Set_IsSolderCommande(isSolde: Boolean)
    begin
        IsSolderCommande := isSolde;
    end;

    procedure Get_IsSolderCommande(): Boolean
    begin
        exit(IsSolderCommande);
    end;

    procedure Set_CanUpdateAchatDevise(modify: Boolean)
    begin
        CanUpdateAchatDevise := modify;
    end;

    procedure Get_CanUpdateAchatDevise(): Boolean
    begin
        exit(CanUpdateAchatDevise);
    end;

    procedure Set_IsAfkShowItemWarning(modify: Boolean)
    begin
        IsAfkShowItemWarning := modify;
    end;

    procedure Get_IsAfkShowItemWarning(): Boolean
    begin
        exit(IsAfkShowItemWarning);
    end;

    procedure Set_IsPostingSortieImmo(modify: Boolean)
    begin
        IsPostingSortieImmo := modify;
    end;

    procedure Get_IsPostingSortieImmo(): Boolean
    begin
        exit(IsPostingSortieImmo);
    end;

    procedure Set_InventoryPostingToGL(AfkInventoryPostingToGL1: codeunit "Inventory Posting To G/L")
    begin
        AfkInventoryPostingToGL := AfkInventoryPostingToGL1;
    end;

    procedure Get_InventoryPostingToGL(): codeunit "Inventory Posting To G/L"
    begin
        exit(AfkInventoryPostingToGL);
    end;
}
