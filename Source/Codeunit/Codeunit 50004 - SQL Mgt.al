codeunit 50004 "SQL Mgt"
{

    trigger OnRun()
    begin
    end;

    var
        AddSetup: Record "AddOn Setup";
        Text001: Label 'Traitement terminé. \%1 client(s) crée(s) \%2 Devis traité(s)';
        Text002: Label 'Test de connexion réussie !';
        Text003: Label 'Vérifiez les informations de Groupe compta marché et Groupe compta client pour le client %1 !';
        NbreClients: Integer;
        NbreCommandes: Integer;
        MoneytechMgt: Codeunit "Conso by Cards Mgt";
        Text004: Label 'Traitement terminé. \%1 lignes(s) traitée(s)';

    procedure ImportMoneyTechEntries(MoneyTechImport: Record "MoneyTech Import"; Tranche: Integer)
    var
    // SQLParameter: DotNet BCSqlParameter;
    // SQLConnection: DotNet BCSqlConnection;
    // SQLCommand: DotNet BCSqlCommand;
    // SQLReader: DotNet BCSqlDataReader;
    // IdLigne: Text[10];
    // CodeOperation: Text[10];
    // Num_Carte: Text[50];
    // Montant: Decimal;
    // IdCommercant: Text[30];
    // CodeClient: Text[30];
    // CodeStation: Text[30];
    // PrePaid: Text[10];
    // MoneyTechImportLine: Record "MoneyTech Import Line";
    // LineNum: Integer;
    // SQLCommand2: DotNet BCSqlCommand;
    // CreateLine: Boolean;
    // NbLignes: Integer;
    // CardNum: Code[10];
    // TransmissionNo: Text[30];
    // DateTransmission: Text[30];
    begin

        // MoneyTechImportLine.Reset;
        // MoneyTechImportLine.SetRange("Document No.",MoneyTechImport."No.");
        // MoneyTechImportLine.DeleteAll;
        // Commit;//**********************************************************COMMIT HERE



        // SQLConnection := SQLConnection.SqlConnection(GetConnexionString());
        // SQLConnection.Open;



        // SQLCommand := SQLConnection.CreateCommand();
        // SQLCommand.CommandText := 'usp_getMoneyTechTrans';
        // SQLCommand.CommandType := GetEnum(SQLCommand.CommandType,'StoredProcedure');
        // SQLCommand.CommandTimeout := 0;


        // SQLParameter := SQLParameter.SqlParameter;
        // SQLParameter.ParameterName := '@year'; //Name of the parameter
        // SQLParameter.SqlDbType := GetEnum(SQLParameter.SqlDbType,'Int');
        // SQLParameter.Direction := GetEnum(SQLParameter.Direction,'Input');
        // SQLParameter.Value := Date2DMY(MoneyTechImport."Starting Date",3);
        // SQLCommand.Parameters.Add(SQLParameter);


        // SQLParameter := SQLParameter.SqlParameter;
        // SQLParameter.ParameterName := '@month'; //Name of the parameter
        // SQLParameter.SqlDbType := GetEnum(SQLParameter.SqlDbType,'Int');
        // SQLParameter.Direction := GetEnum(SQLParameter.Direction,'Input');
        // SQLParameter.Value := Date2DMY(MoneyTechImport."Starting Date",2);
        // SQLCommand.Parameters.Add(SQLParameter);


        // SQLParameter := SQLParameter.SqlParameter;
        // SQLParameter.ParameterName := '@day'; //Name of the parameter
        // SQLParameter.SqlDbType := GetEnum(SQLParameter.SqlDbType,'Int');
        // SQLParameter.Direction := GetEnum(SQLParameter.Direction,'Input');
        // SQLParameter.Value := Date2DMY(MoneyTechImport."Starting Date",1);
        // SQLCommand.Parameters.Add(SQLParameter);


        // SQLParameter := SQLParameter.SqlParameter;
        // SQLParameter.ParameterName := '@Tranche'; //Name of the parameter
        // SQLParameter.SqlDbType := GetEnum(SQLParameter.SqlDbType,'Int');
        // SQLParameter.Direction := GetEnum(SQLParameter.Direction,'Input');
        // SQLParameter.Value := Tranche;
        // SQLCommand.Parameters.Add(SQLParameter);


        // NbreCommandes:=0;
        // SQLReader := SQLCommand.ExecuteReader;

        // //MESSAGE('%1',FORMAT(SQLReader.RecordsAffected));

        // LineNum:=0;
        // NbLignes:=0;
        // while SQLReader.Read() do begin
        //   //MESSAGE( 'Reading %1',SQLReader.Item('User Name'));
        //   //Create Cust
        //   //EVALUATE(IdLigne,FORMAT(SQLReader.Item('Id')));
        //   Evaluate(CodeOperation,CopyStr(SQLReader.Item('Code_Operation'),1,10));
        //   //EVALUATE(Num_Carte,COPYSTR(SQLReader.Item('Num_Carte'),1,20));
        //   Evaluate(Montant,Format(SQLReader.Item('Montant_TTC_ar')));
        //   Evaluate(IdCommercant,CopyStr(SQLReader.Item('Id_Commerçant'),1,20));
        //   Evaluate(CodeClient,CopyStr(SQLReader.Item('CodeClient'),1,30));
        //   Evaluate(CodeStation,Format(SQLReader.Item('CodeStation')));
        //   Evaluate(PrePaid,Format(SQLReader.Item('Prepaid')));
        //   //EVALUATE(CardNum,FORMAT(SQLReader.Item('Num_Carte')));
        //   Evaluate(TransmissionNo,CopyStr(SQLReader.Item('Num_Transmission'),1,20));
        //   Evaluate(DateTransmission,CopyStr(SQLReader.Item('Date_Telecollecte'),1,30));


        //   MoneytechMgt.InsertNewTransactionLine(MoneyTechImport."No.",CodeStation,PrePaid,
        //     CodeClient,LineNum,Montant,CodeOperation,MoneyTechImport."Starting Date",CardNum,
        //     TransmissionNo,DateTransmission);

        //   NbLignes := NbLignes + 1;

        // end;

        // SQLConnection.Close;
        // Clear(SQLReader);
        // Clear(SQLCommand);
        // Clear(SQLConnection);

        // Message(Text004,NbLignes);
    end;

    procedure SynchronizeOrdersData()
    var
    // SQLParameter: DotNet BCSqlParameter;
    // SQLConnection: DotNet BCSqlConnection;
    // SQLCommand: DotNet BCSqlCommand;
    // SQLReader: DotNet BCSqlDataReader;
    // OppDescr: Text[50];
    // CurrCode: Text[10];
    // CustCode: Text[20];
    // OrderCode: Text[20];
    // PourcentageAcompte: Decimal;
    // CondPaiement: Text[30];
    // RefCdeClient: Text[30];
    // DateCdeClient: Text;
    // CodeVendeur: Text[30];
    // RefCdeClientAll: Text[50];
    begin

        // SQLConnection := SQLConnection.SqlConnection(GetConnexionString());
        // SQLConnection.Open;



        // SQLCommand := SQLConnection.CreateCommand();
        // SQLCommand.CommandText := 'usp_getNewSalesOrders';
        // SQLCommand.CommandType := GetEnum(SQLCommand.CommandType,'StoredProcedure');
        // SQLCommand.CommandTimeout := 0;

        // NbreCommandes:=0;
        // SQLReader := SQLCommand.ExecuteReader;


        // while SQLReader.Read() do begin
        //   //MESSAGE( 'Reading %1',SQLReader.Item('User Name'));
        //   //Create Cust
        //   Evaluate(OppDescr,CopyStr(SQLReader.Item('DescriptionAffaire'),1,50));
        //   Evaluate(CurrCode,CopyStr(SQLReader.Item('Devise'),1,10));
        //   Evaluate(CustCode,CopyStr(SQLReader.Item('CodeClient'),1,20));
        //   Evaluate(OrderCode,CopyStr(SQLReader.Item('CodeCommande'),1,20));
        //   Evaluate(PourcentageAcompte,Format(SQLReader.Item('PourcentageAcompte')));
        //   Evaluate(CondPaiement,CopyStr(SQLReader.Item('ConditionsPaiement'),1,10));
        //   Evaluate(RefCdeClient,CopyStr(SQLReader.Item('CommandeClient'),1,30));
        //   Evaluate(DateCdeClient,Format(SQLReader.Item('DateCommandeClient')));
        //   Evaluate(CodeVendeur,CopyStr(SQLReader.Item('Vendeur'),1,10));

        //   RefCdeClientAll := CopyStr(RefCdeClient+' DU '+Format(DateCdeClient),1,50);
        //   RefCdeClientAll := STRREPLACE(RefCdeClientAll,'00:00','');

        //   /*IF CreateOrder(OrderCode,CustCode,
        //      COPYSTR(CondPaiement,1,10),COPYSTR(CodeVendeur,1,10),COPYSTR(CurrCode,1,10),PourcentageAcompte,
        //      RefCdeClientAll,
        //      COPYSTR(OppDescr,1,50),0)
        //   THEN
        //     //UpdateCreatedOrder(OrderCode);*/
        //   Commit;
        // end;

        // SQLConnection.Close;

        // Clear(SQLReader);
        // Clear(SQLCommand);
        // Clear(SQLConnection);

    end;

    local procedure UpdateCustTest(CustCode: Code[20])
    var
    // SQLCommand2: DotNet BCSqlCommand;
    // SQLConnection2: DotNet BCSqlConnection;
    // SQLParameter: DotNet BCSqlParameter;
    begin


        // SQLConnection2 := SQLConnection2.SqlConnection(GetConnexionString());
        // SQLConnection2.Open;

        // SQLCommand2 := SQLConnection2.CreateCommand();
        // SQLCommand2.CommandText := 'usp_setInsertedCustomer';
        // SQLCommand2.CommandType := GetEnum(SQLCommand2.CommandType,'StoredProcedure');
        // SQLCommand2.CommandTimeout := 0;


        // SQLParameter := SQLParameter.SqlParameter;
        // SQLParameter.ParameterName := '@CodeClient'; //Name of the parameter
        // SQLParameter.SqlDbType := GetEnum(SQLParameter.SqlDbType,'VarChar');
        // SQLParameter.Direction := GetEnum(SQLParameter.Direction,'Input');
        // SQLParameter.Size := 20; //30 characters
        // SQLParameter.Value:=CustCode;

        // SQLCommand2.Parameters.Add(SQLParameter);
        // SQLCommand2.ExecuteNonQuery;


        // SQLConnection2.Close;
        // Clear(SQLCommand2);
        // Clear(SQLConnection2);
    end;

    procedure GetConnexionString() ConnectionString: Text[500]
    begin
        AddSetup.Get;
        AddSetup.TestField("SQL Server ID");

        ConnectionString := ''
        + 'Server=' + AddSetup."SQL Server ID" + ';'
        + 'Database=' + AddSetup."SQL Server DB" + ';'
        + 'User Id=' + AddSetup."SQL User" + ';'
        + 'Password=' + AddSetup."SQL Password" + ';';
    end;

    procedure TestConnexion()
    var
    // SQLConnection: DotNet BCSqlConnection;
    begin
        // SQLConnection := SQLConnection.SqlConnection(GetConnexionString());
        // SQLConnection.Open;

        // Message(Text002);

        // SQLConnection.Close;
        // Clear(SQLConnection);
    end;

    // procedure GetEnum(pSystemEnum: DotNet BCEnum;pEnumValue: Text[30]): Integer
    // var
    //     SystemConvert: DotNet BCConvert;
    // begin
    //     exit(SystemConvert.ToInt32(pSystemEnum.Parse(pSystemEnum.GetType,pEnumValue)));
    // end;

    procedure STRREPLACE(Chaine: Text[1024]; TxtARemplacer: Text[1024]; RemplacerPar: Text[1024]): Text[1024]
    var
        i: Integer;
    begin
        i := StrPos(Chaine, TxtARemplacer);
        if (i > 0) then begin

            // clear first needle in haystack
            Chaine := DelStr(Chaine, i, StrLen(TxtARemplacer));

            // return previous + replace + rest
            exit(CopyStr(Chaine, 1, i - 1) +
              RemplacerPar +
              STRREPLACE(CopyStr(Chaine, i, StrLen(Chaine) - i + 1), TxtARemplacer, RemplacerPar));
        end;
    end;

    local procedure getStringDate(dtDate: Date): Text[30]
    begin
        //MESSAGE('%1',FORMAT(dtDate));
        //EXIT(FORMAT(dtDate));
        exit(Format(Date2DMY(dtDate, 2)) + '/' + Format(Date2DMY(dtDate, 1)) + '/' + Format(Date2DMY(dtDate, 3)));
        //EXIT(FORMAT(DATE2DMY(dtDate,3))+'/'+FORMAT(DATE2DMY(dtDate,2))+'/'+FORMAT(DATE2DMY(dtDate,1)));
    end;

    procedure ConfirmBE(NumBE: Integer)
    var
    // SQLCommand2: DotNet BCSqlCommand;
    // SQLConnection2: DotNet BCSqlConnection;
    // SQLParameter: DotNet BCSqlParameter;
    begin


        // SQLConnection2 := SQLConnection2.SqlConnection(GetConnexionString());
        // SQLConnection2.Open;

        // SQLCommand2 := SQLConnection2.CreateCommand();
        // SQLCommand2.CommandText := 'usp_BE_CONFIRMER';
        // SQLCommand2.CommandType := GetEnum(SQLCommand2.CommandType,'StoredProcedure');
        // SQLCommand2.CommandTimeout := 0;


        // SQLParameter := SQLParameter.SqlParameter;
        // SQLParameter.ParameterName := '@num_be'; //Name of the parameter
        // SQLParameter.SqlDbType := GetEnum(SQLParameter.SqlDbType,'Int');
        // SQLParameter.Direction := GetEnum(SQLParameter.Direction,'Input');
        // //SQLParameter.Size := 20; //30 characters
        // SQLParameter.Value:=NumBE;

        // SQLCommand2.Parameters.Add(SQLParameter);
        // SQLCommand2.ExecuteNonQuery;


        // SQLConnection2.Close;
        // Clear(SQLCommand2);
        // Clear(SQLConnection2);
    end;

    procedure ConfirmBL(NumBL: Integer)
    var
    // SQLCommand2: DotNet BCSqlCommand;
    // SQLConnection2: DotNet BCSqlConnection;
    // SQLParameter: DotNet BCSqlParameter;
    begin


        // SQLConnection2 := SQLConnection2.SqlConnection(GetConnexionString());
        // SQLConnection2.Open;

        // SQLCommand2 := SQLConnection2.CreateCommand();
        // SQLCommand2.CommandText := 'usp_BL_CONFIRMER';
        // SQLCommand2.CommandType := GetEnum(SQLCommand2.CommandType,'StoredProcedure');
        // SQLCommand2.CommandTimeout := 0;


        // SQLParameter := SQLParameter.SqlParameter;
        // SQLParameter.ParameterName := '@num_bl'; //Name of the parameter
        // SQLParameter.SqlDbType := GetEnum(SQLParameter.SqlDbType,'Int');
        // SQLParameter.Direction := GetEnum(SQLParameter.Direction,'Input');
        // //SQLParameter.Size := 20; //30 characters
        // SQLParameter.Value:=NumBL;

        // SQLCommand2.Parameters.Add(SQLParameter);
        // SQLCommand2.ExecuteNonQuery;


        // SQLConnection2.Close;
        // Clear(SQLCommand2);
        // Clear(SQLConnection2);
    end;

    procedure ImportMoneyTechEntriesOld(MoneyTechImport: Record "MoneyTech Import")
    var
    // SQLParameter: DotNet BCSqlParameter;
    // SQLConnection: DotNet BCSqlConnection;
    // SQLCommand: DotNet BCSqlCommand;
    // SQLReader: DotNet BCSqlDataReader;
    // IdLigne: Text[10];
    // CodeOperation: Text[10];
    // Num_Carte: Text[50];
    // Montant: Decimal;
    // IdCommercant: Text[30];
    // CodeClient: Text[30];
    // CodeStation: Text[30];
    // PrePaid: Text[10];
    // MoneyTechImportLine: Record "MoneyTech Import Line";
    // LineNum: Integer;
    // SQLCommand2: DotNet BCSqlCommand;
    // CreateLine: Boolean;
    // NbLignes: Integer;
    // CardNum: Code[10];
    // TransmissionNo: Text[30];
    // DateTransmission: Text[30];
    begin
        // SQLConnection := SQLConnection.SqlConnection(GetConnexionString());
        // SQLConnection.Open;



        // SQLCommand := SQLConnection.CreateCommand();
        // SQLCommand.CommandText := 'usp_getMoneyTechTrans';
        // SQLCommand.CommandType := GetEnum(SQLCommand.CommandType,'StoredProcedure');
        // SQLCommand.CommandTimeout := 0;


        // SQLParameter := SQLParameter.SqlParameter;
        // SQLParameter.ParameterName := '@DateDeb'; //Name of the parameter
        // SQLParameter.SqlDbType := GetEnum(SQLParameter.SqlDbType,'VarChar');
        // SQLParameter.Direction := GetEnum(SQLParameter.Direction,'Input');
        // SQLParameter.Size := 20; //30 characters
        // SQLParameter.Value:=getStringDate(MoneyTechImport."Starting Date");

        // SQLCommand.Parameters.Add(SQLParameter);

        // SQLParameter := SQLParameter.SqlParameter;
        // SQLParameter.ParameterName := '@DateFin'; //Name of the parameter
        // SQLParameter.SqlDbType := GetEnum(SQLParameter.SqlDbType,'VarChar');
        // SQLParameter.Direction := GetEnum(SQLParameter.Direction,'Input');
        // SQLParameter.Size := 20; //30 characters
        // SQLParameter.Value:=getStringDate(MoneyTechImport."Starting Date");

        // SQLCommand.Parameters.Add(SQLParameter);

        // NbreCommandes:=0;
        // SQLReader := SQLCommand.ExecuteReader;

        // //MESSAGE('%1',FORMAT(SQLReader.RecordsAffected));

        // LineNum:=0;
        // NbLignes:=0;
        // while SQLReader.Read() do begin
        //   //MESSAGE( 'Reading %1',SQLReader.Item('User Name'));
        //   //Create Cust
        //   //EVALUATE(IdLigne,FORMAT(SQLReader.Item('Id')));
        //   Evaluate(CodeOperation,CopyStr(SQLReader.Item('Code_Operation'),1,10));
        //   //EVALUATE(Num_Carte,COPYSTR(SQLReader.Item('Num_Carte'),1,20));
        //   Evaluate(Montant,Format(SQLReader.Item('Montant_TTC_ar')));
        //   Evaluate(IdCommercant,CopyStr(SQLReader.Item('Id_Commerçant'),1,20));
        //   Evaluate(CodeClient,CopyStr(SQLReader.Item('CodeClient'),1,30));
        //   Evaluate(CodeStation,Format(SQLReader.Item('CodeStation')));
        //   Evaluate(PrePaid,Format(SQLReader.Item('Prepaid')));
        //   //EVALUATE(CardNum,FORMAT(SQLReader.Item('Num_Carte')));
        //   Evaluate(TransmissionNo,CopyStr(SQLReader.Item('Num_Transmission'),1,20));
        //   Evaluate(DateTransmission,CopyStr(SQLReader.Item('Date_Telecollecte'),1,30));


        //   MoneytechMgt.InsertNewTransactionLine(MoneyTechImport."No.",CodeStation,PrePaid,
        //     CodeClient,LineNum,Montant,CodeOperation,MoneyTechImport."Starting Date",CardNum,
        //     TransmissionNo,DateTransmission);

        //   NbLignes:=NbLignes+1;

        // end;

        // SQLConnection.Close;
        // Clear(SQLReader);
        // Clear(SQLCommand);
        // Clear(SQLConnection);

        // Message(Text004,NbLignes);
    end;

    procedure AnnulerBL(NumBL: Integer)
    var
    // SQLCommand2: DotNet BCSqlCommand;
    // SQLConnection2: DotNet BCSqlConnection;
    // SQLParameter: DotNet BCSqlParameter;
    begin


        // SQLConnection2 := SQLConnection2.SqlConnection(GetConnexionString());
        // SQLConnection2.Open;

        // SQLCommand2 := SQLConnection2.CreateCommand();
        // SQLCommand2.CommandText := 'usp_BL_ANNULER';
        // SQLCommand2.CommandType := GetEnum(SQLCommand2.CommandType,'StoredProcedure');
        // SQLCommand2.CommandTimeout := 0;


        // SQLParameter := SQLParameter.SqlParameter;
        // SQLParameter.ParameterName := '@num_bl'; //Name of the parameter
        // SQLParameter.SqlDbType := GetEnum(SQLParameter.SqlDbType,'Int');
        // SQLParameter.Direction := GetEnum(SQLParameter.Direction,'Input');
        // //SQLParameter.Size := 20; //30 characters
        // SQLParameter.Value:=NumBL;

        // SQLCommand2.Parameters.Add(SQLParameter);

        // SQLParameter := SQLParameter.SqlParameter;
        // SQLParameter.ParameterName := '@utilisateur'; //Name of the parameter
        // SQLParameter.SqlDbType := GetEnum(SQLParameter.SqlDbType,'VarChar');
        // SQLParameter.Direction := GetEnum(SQLParameter.Direction,'Input');
        // SQLParameter.Size := 50; //30 characters
        // SQLParameter.Value:=Format(UserId);

        // SQLCommand2.Parameters.Add(SQLParameter);


        // SQLCommand2.ExecuteNonQuery;


        // SQLConnection2.Close;
        // Clear(SQLCommand2);
        // Clear(SQLConnection2);
    end;

    procedure AnnulerBE(NumBE: Integer)
    var
    // SQLCommand2: DotNet BCSqlCommand;
    // SQLConnection2: DotNet BCSqlConnection;
    // SQLParameter: DotNet BCSqlParameter;
    begin


        // SQLConnection2 := SQLConnection2.SqlConnection(GetConnexionString());
        // SQLConnection2.Open;

        // SQLCommand2 := SQLConnection2.CreateCommand();
        // SQLCommand2.CommandText := 'usp_BE_ANNULER';
        // SQLCommand2.CommandType := GetEnum(SQLCommand2.CommandType,'StoredProcedure');
        // SQLCommand2.CommandTimeout := 0;


        // SQLParameter := SQLParameter.SqlParameter;
        // SQLParameter.ParameterName := '@num_be'; //Name of the parameter
        // SQLParameter.SqlDbType := GetEnum(SQLParameter.SqlDbType,'Int');
        // SQLParameter.Direction := GetEnum(SQLParameter.Direction,'Input');
        // //SQLParameter.Size := 20; //30 characters
        // SQLParameter.Value:=NumBE;

        // SQLCommand2.Parameters.Add(SQLParameter);

        // SQLParameter := SQLParameter.SqlParameter;
        // SQLParameter.ParameterName := '@utilisateur'; //Name of the parameter
        // SQLParameter.SqlDbType := GetEnum(SQLParameter.SqlDbType,'VarChar');
        // SQLParameter.Direction := GetEnum(SQLParameter.Direction,'Input');
        // SQLParameter.Size := 50; //30 characters
        // SQLParameter.Value:=Format(UserId);

        // SQLCommand2.Parameters.Add(SQLParameter);


        // SQLCommand2.ExecuteNonQuery;


        // SQLConnection2.Close;
        // Clear(SQLCommand2);
        // Clear(SQLConnection2);
    end;

    procedure SolderCommande(NumCde: Code[20])
    var
    // SQLCommand2: DotNet BCSqlCommand;
    // SQLConnection2: DotNet BCSqlConnection;
    // SQLParameter: DotNet BCSqlParameter;
    begin


        // SQLConnection2 := SQLConnection2.SqlConnection(GetConnexionString());
        // SQLConnection2.Open;

        // SQLCommand2 := SQLConnection2.CreateCommand();
        // SQLCommand2.CommandText := 'usp_COMMANDE_SOLDER';
        // SQLCommand2.CommandType := GetEnum(SQLCommand2.CommandType,'StoredProcedure');
        // SQLCommand2.CommandTimeout := 0;


        // SQLParameter := SQLParameter.SqlParameter;
        // SQLParameter.ParameterName := '@numero_commande'; //Name of the parameter
        // SQLParameter.SqlDbType := GetEnum(SQLParameter.SqlDbType,'VarChar');
        // SQLParameter.Direction := GetEnum(SQLParameter.Direction,'Input');
        // SQLParameter.Size := 50; //30 characters
        // SQLParameter.Value:=NumCde;

        // SQLCommand2.Parameters.Add(SQLParameter);
        // SQLCommand2.ExecuteNonQuery;


        // SQLConnection2.Close;
        // Clear(SQLCommand2);
        // Clear(SQLConnection2);
    end;

    procedure ChangerCamionBE(NumBE: Integer; CodeCamion: Code[30])
    var
    // SQLCommand2: DotNet BCSqlCommand;
    // SQLConnection2: DotNet BCSqlConnection;
    // SQLParameter: DotNet BCSqlParameter;
    begin


        // SQLConnection2 := SQLConnection2.SqlConnection(GetConnexionString());
        // SQLConnection2.Open;

        // SQLCommand2 := SQLConnection2.CreateCommand();
        // SQLCommand2.CommandText := 'usp_BE_MODIFIER_CAMION';
        // SQLCommand2.CommandType := GetEnum(SQLCommand2.CommandType,'StoredProcedure');
        // SQLCommand2.CommandTimeout := 0;


        // SQLParameter := SQLParameter.SqlParameter;
        // SQLParameter.ParameterName := '@num_be'; //Name of the parameter
        // SQLParameter.SqlDbType := GetEnum(SQLParameter.SqlDbType,'Int');
        // SQLParameter.Direction := GetEnum(SQLParameter.Direction,'Input');
        // //SQLParameter.Size := 20; //30 characters
        // SQLParameter.Value:=NumBE;

        // SQLCommand2.Parameters.Add(SQLParameter);

        // SQLParameter := SQLParameter.SqlParameter;
        // SQLParameter.ParameterName := '@immatriculation_camion'; //Name of the parameter
        // SQLParameter.SqlDbType := GetEnum(SQLParameter.SqlDbType,'VarChar');
        // SQLParameter.Direction := GetEnum(SQLParameter.Direction,'Input');
        // SQLParameter.Size := 30; //30 characters
        // SQLParameter.Value:=CodeCamion;

        // SQLCommand2.Parameters.Add(SQLParameter);


        // SQLCommand2.ExecuteNonQuery;


        // SQLConnection2.Close;
        // Clear(SQLCommand2);
        // Clear(SQLConnection2);
    end;

    procedure IsCdeANePasLivrerCRM(OrderNo: Code[20]) Rep: Boolean
    var
    // SQLCommand2: DotNet BCSqlCommand;
    // SQLConnection2: DotNet BCSqlConnection;
    // SQLParameter: DotNet BCSqlParameter;
    // SQLReader: DotNet BCSqlDataReader;
    // StatutDdeDeblocage: Integer;
    begin


        // SQLConnection2 := SQLConnection2.SqlConnection(GetConnexionString());
        // SQLConnection2.Open;

        // SQLCommand2 := SQLConnection2.CreateCommand();
        // SQLCommand2.CommandText := 'usp_GetStatutCdeCRM';
        // SQLCommand2.CommandType := GetEnum(SQLCommand2.CommandType,'StoredProcedure');
        // SQLCommand2.CommandTimeout := 0;


        // SQLParameter := SQLParameter.SqlParameter;
        // SQLParameter.ParameterName := '@num_commande'; //Name of the parameter
        // SQLParameter.SqlDbType := GetEnum(SQLParameter.SqlDbType,'VarChar');
        // SQLParameter.Direction := GetEnum(SQLParameter.Direction,'Input');
        // SQLParameter.Size := 20; //30 characters
        // SQLParameter.Value:=OrderNo;

        // SQLCommand2.Parameters.Add(SQLParameter);


        // SQLReader := SQLCommand2.ExecuteReader;
        // if SQLReader.Read() then
        //   Evaluate(StatutDdeDeblocage,Format(SQLReader.Item('Statut')));

        // Rep := ((StatutDdeDeblocage=9) or (StatutDdeDeblocage=12));

        // SQLConnection2.Close;
        // Clear(SQLReader);
        // Clear(SQLCommand2);
        // Clear(SQLConnection2);
        exit(true);
    end;
}

