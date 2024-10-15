codeunit 50036 SingleInstance
{
    SingleInstance = true;

    var
        AFK_EscapeCheck_MultiLevelAdjmt: Boolean;
        SendVendorEmails_AFK: Boolean;

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
}
