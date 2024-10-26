xmlport 50016 "Import Permission Set"
{
    Encoding = UTF8;
    Format = Xml;
    //TextEncoding = UTF8;

    schema
    {
        textelement(Permissions)
        {
            tableelement("Permission Set"; "Permission Set")
            {
                XmlName = 'PermissionSet';
                fieldattribute(Role; "Permission Set"."Role ID")
                {
                }
                fieldattribute(Name; "Permission Set".Name)
                {
                }
                tableelement(Permission; Permission)
                {
                    LinkFields = "Role ID" = FIELD("Role ID"), "Role Name" = FIELD(Name);
                    LinkTable = "Permission Set";
                    XmlName = 'Permissions';
                    fieldattribute(RoleID; Permission."Role ID")
                    {
                    }
                    fieldattribute(RoleName; Permission."Role Name")
                    {
                    }
                    fieldattribute(ObjectType; Permission."Object Type")
                    {
                    }
                    fieldattribute(ObjectID; Permission."Object ID")
                    {
                    }
                    fieldattribute(ObjectName; Permission."Object Name")
                    {
                    }
                    fieldattribute(ReadPermission; Permission."Read Permission")
                    {
                    }
                    fieldattribute(InsertPermission; Permission."Insert Permission")
                    {
                    }
                    fieldattribute(ModifyPermission; Permission."Modify Permission")
                    {
                    }
                    fieldattribute(DeletePermission; Permission."Delete Permission")
                    {
                    }
                    fieldattribute(ExecutePermission; Permission."Execute Permission")
                    {
                    }
                    fieldattribute(SecurityFilter; Permission."Security Filter")
                    {
                    }
                }
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
        Message(Text001);
    end;

    var
        Text001: Label 'Traitement terminé !';
}

