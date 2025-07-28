codeunit 50040 "Afk Api Mgt"
{

    /// <summary>
    /// GetLengthOfStringWithConfirmation
    /// </summary>
    /// <returns></returns>
    procedure GetLengthOfStringWithConfirmation(inputJson: Text): Integer
    var
        c: JsonToken;
        input: JsonObject;
    begin
        input.ReadFrom(inputJson);
        if input.Get('confirm', c) and c.AsValue().AsBoolean() = true and input.Get('str', c) then
            exit(StrLen(c.AsValue().AsText()))
        else
            exit(-1);
    end;


    /// <summary>
    /// 
    /// </summary>
    /// <returns></returns>
    procedure CreateJsonResponse(): Text
    var
        SalesLine: Record "Sales Line";
        SalesHeader: Record "Sales Header";
        HeaderJson: JsonObject;
        LineJson: JsonObject;
        TabArray: JsonArray;

    begin
        SalesHeader.Get(SalesHeader."Document Type"::Order, '101005 ');
        HeaderJson.Add('DocumentType', SalesHeader."Document Type".AsInteger());
        HeaderJson.Add('No.', SalesHeader."No.");
        HeaderJson.Add('SellToCustNo', SalesHeader."Sell-to Customer No.");
        HeaderJson.Add('PostingDate', SalesHeader."Posting Date");

        SalesLine.SetRange(SalesLine."Document Type", SalesLine."Document Type"::Order);
        SalesLine.SetRange(SalesLine."Document No.", SalesHeader."No.");
        if SalesLine.FindSet() then
            repeat
                Clear(LineJson);
                LineJson.Add('LineNo', SalesLine."No.");
                LineJson.Add('LineType', SalesLine.Type.AsInteger());
                LineJson.Add('No', SalesLine."No.");
                LineJson.Add('Qty', SalesLine.Quantity);
                LineJson.Add('UnitPrice', SalesLine."Unit Price");
                TabArray.Add(LineJson);
            until SalesLine.Next() < 1;

        HeaderJson.Add('Lines', TabArray);
        exit(format(HeaderJson));
    end;

    /// <summary>
    /// CreateResponseSuccess.
    /// </summary>
    /// <param name="PostedDocNo">Code[20].</param>
    /// <returns>Return value of type Text.</returns>
    procedure CreateResponseSuccess(PostedDocNo: Code[20]): Text
    var
        HeaderJson: JsonObject;
    begin
        HeaderJson.Add('error', false);
        HeaderJson.Add('message', PostedDocNo);
        exit(format(HeaderJson));
    end;

    /// <summary>
    /// GetText.
    /// </summary>
    /// <param name="key">Text.</param>
    /// <param name="input">JsonObject.</param>
    /// <returns>Return value of type Text.</returns>
    procedure CreateResponseError(ErrorMessage: Text): Text
    var
        HeaderJson: JsonObject;
    begin
        HeaderJson.Add('error', true);
        HeaderJson.Add('message', ErrorMessage);
        exit(format(HeaderJson));
    end;

    /// <summary>
    /// GetText.
    /// </summary>
    /// <param name="key">Text.</param>
    /// <param name="input">JsonObject.</param>
    /// <returns>Return value of type Text.</returns>
    procedure GetText("key": Text; input: JsonObject): Text
    var
        c: JsonToken;
    begin
        input.Get("key", c);
        exit(c.AsValue().AsText());
    end;

    /// <summary>
    /// GetDate.
    /// </summary>
    /// <param name="key">Text.</param>
    /// <param name="input">JsonObject.</param>
    /// <returns>Return value of type Date.</returns>
    procedure GetDate("key": Text; input: JsonObject): Date
    var
        c: JsonToken;
        actualDate: DateTime;
    begin
        input.Get("key", c);

        actualDate := ParseDateTime(c);
        exit(DT2Date(actualDate));
        //actualDate := c.AsValue().AsDate();
        // if (Date2DMY(actualDate, 3) = 1753) then
        //     exit(0D)
        // else
        //     exit(actualDate);
    end;
    /// <summary>
    /// GetDateTime.
    /// </summary>
    /// <param name="key">Text.</param>
    /// <param name="input">JsonObject.</param>
    /// <returns>Return value of type DateTime.</returns>
    procedure GetDateTime("key": Text; input: JsonObject): DateTime
    var
        c: JsonToken;
        actualDate: DateTime;
    begin
        input.Get("key", c);
        Evaluate(actualDate, c.AsValue().AsText());
        //actualDate := c.AsValue().AsDate();
        if (Date2DMY(DT2Date(actualDate), 3) = 1753) then
            exit(CreateDateTime(0D, 0T))
        else
            exit(actualDate);
    end;

    /// <summary>
    /// GetInt.
    /// </summary>
    /// <param name="key">Text.</param>
    /// <param name="input">JsonObject.</param>
    /// <returns>Return value of type Integer.</returns>
    procedure GetBool("key": Text; input: JsonObject): Boolean
    var
        c: JsonToken;
    begin
        input.Get("key", c);
        exit(c.AsValue().AsBoolean());
    end;

    /// <summary>
    /// GetDecimal.
    /// </summary>
    /// <param name="key">Text.</param>
    /// <param name="input">JsonObject.</param>
    /// <returns>Return value of type Decimal.</returns>
    procedure GetInt("key": Text; input: JsonObject): Integer
    var
        c: JsonToken;
    begin
        input.Get("key", c);
        exit(c.AsValue().AsInteger());
    end;

    /// <summary>
    /// DebugApiFunction
    /// </summary>
    procedure GetDecimal("key": Text; input: JsonObject): Decimal
    var
        c: JsonToken;
    begin
        input.Get("key", c);
        exit(c.AsValue().AsDecimal());
    end;

    procedure KeyExists("key": Text; input: JsonObject): Boolean
    var
        c: JsonToken;
    begin
        exit(input.Get("key", c));
    end;

    /// <summary>
    /// DebugApiFunction
    /// </summary>
    procedure DebugApiFunction()
    var
        MainJson: JsonObject;
        InputJsonString: Text;
        InputJsonToken: JsonToken;
        ApiInterface: Codeunit "Afk Api Interface Mgt";
        jsonText: Text;
    begin
        //jsonText := '{"inputJson":"{\"Parameter\":\"salesOrder_insert\",\"UserId\":\"S000024\",\"No_\":\"\",\"Sell-to Customer No_\":\"C0000024\",\"items\":[],\"paymentMethods\":[]}"}';
        jsonText := '{"inputJson":"{\"Parameter\":\"salesOrder_modify\",\"UserId\":\"S003601\",\"Document Date\":\"2025-07-23\",\"Requested Delivery Date\":\"2025-07-24\",\"No_\":\"463048\",\"Sell-to Customer No_\":\"CP003856\",\"items\":[{\"Linked Line No_\":0,\"Line No_\":1,\"No_\":\"31000-0000\",\"Description\":\"SUPER SP95\",\"Unit of Measure Code\":\"LITRE\",\"Quantity\":1000,\"VAT \":20,\"Unit Price\":4318.39,\"Line Amount\":4318390,\"VAT Amount\":863678,\"Amount Including VAT\":5182068},{\"Linked Line No\":1,\"Line No_\":2,\"No_\":\"TRANS008\",\"Description\":\"TRANSPORT SUPER CARBURANT\",\"Unit of Measure Code\":\"LITRE\",\"Quantity\":1000,\"VAT \":20,\"Unit Price\":25,\"Line Amount\":25000,\"VAT Amount\":5000,\"Amount Including VAT\":30000},{\"Linked Line No\":0,\"Line No_\":3,\"No_\":\"34000-0000\",\"Description\":\"GAS-OIL\",\"Unit of Measure Code\":\"LITRE\",\"Quantity\":1000,\"VAT \":20,\"Unit Price\":3968.39,\"Line Amount\":3968390,\"VAT Amount\":793678,\"Amount Including VAT\":4762068},{\"Linked Line No\":3,\"Line No_\":4,\"No_\":\"TRANS004\",\"Description\":\"TRANSPORT  GO\",\"Unit of Measure Code\":\"LITRE\",\"Quantity\":1000,\"VAT \":20,\"Unit Price\":25,\"Line Amount\":25000,\"VAT Amount\":5000,\"Amount Including VAT\":30000}],\"paymentMethods\":[{\"Line No\":1,\"No_\":\"NC_FANILO\",\"Pay Document No_\":\"CAPSSG/24/079907\",\"Amount\":4287474,\"AmountDisplayed\":\"4 287 474,00\"},{\"Line No_\":2,\"No_\":\"MOBILE\",\"Reference\":\"MBK99878191\",\"AmountDisplayed\":\"5 716 662,00\",\"Amount\":5716662,\"Observation\":\"Déjà envoyé\"}]}"}';
        //jsonText := '{"inputJson":"{\"Parameter\":\"salesOrder_cancel\",\"UserId\":\"S002855\",\"No_\":\"463036\"}"}';
        MainJson.ReadFrom(jsonText);
        MainJson.Get('inputJson', InputJsonToken);
        InputJsonString := InputJsonToken.AsValue().AsText();

        ApiInterface.Run(InputJsonString);
    end;

    local procedure ParseDateTime(Token: JsonToken): DateTime
    var
        Splits: List of [Text];
        Year: Integer;
        Month: Integer;
        Day: Integer;
        DateTimePart: Text;
        DatePart: Text;
        TimePart: Text;
        response: DateTime;
        responseDate: Date;
        responseTime: Time;
        chain: Text;
    begin

        chain := Token.AsValue().AsText();

        //YYYY-MM-DD
        if (StrLen(chain) = 10) then begin
            Splits := chain.Split('-');
            Evaluate(Day, Splits.Get(3));
            Evaluate(Month, Splits.Get(2));
            Evaluate(Year, Splits.Get(1));
            if (Year = 1753) then
                exit(CreateDateTime(0D, 0T));
            exit(CreateDateTime(DMY2Date(Day, Month, Year), 0T));
        end;

        //YYYY-MM-DDTHH:mm:ss.sssZ
        Splits := chain.Split('.');
        DateTimePart := Splits.Get(1);

        Splits := DateTimePart.Split('T');
        DatePart := Splits.Get(1);
        TimePart := Splits.Get(2);

        Splits := DatePart.Split('-');
        Evaluate(Day, Splits.Get(3));
        Evaluate(Month, Splits.Get(2));
        Evaluate(Year, Splits.Get(1));
        if (Year = 1753) then
            exit(CreateDateTime(0D, 0T));
        responseDate := DMY2Date(Day, Month, Year);

        Evaluate(responseTime, TimePart);

        response := CreateDateTime(responseDate, responseTime);

        exit(response);
    end;

    procedure ValidateIntField(MyRecordRef: RecordRef; MyFieldNo: integer; intValue: Integer)
    var
        field: record Field;
        fieldRef: FieldRef;
    begin
        if (field.Get(MyRecordRef.Number, MyFieldNo)) then begin
            fieldRef := MyRecordRef.field(field."No.");
            fieldRef.Validate(intValue);
        end;
    end;

    procedure ValidateField(MyRecordRef: RecordRef; MyFieldNo: integer; input: JsonObject; jsonKey: Text)
    var
        field: record Field;
        fieldRef: FieldRef;
        valDate: Date;
        valDateTime: DateTime;
        valInteger: Integer;
        valDecimal: Decimal;
        valBoolean: Boolean;
        //valTime: Time;
        valText: Text;
    begin
        if (not KeyExists(jsonKey, input)) then
            exit;

        // field.SetRange(TableNo, MyRecordRef.Number);
        // field.SetRange("No.", MyFieldNo);
        if (field.Get(MyRecordRef.Number, MyFieldNo)) then begin
            fieldRef := MyRecordRef.field(field."No.");
            case fieldRef.Type of
                fieldType::Date:
                    begin
                        // Evaluate(valDate, fieldRef.Value);
                        // if (valDate <> GetDate(jsonKey, input)) then
                        fieldRef.Validate(GetDate(jsonKey, input));
                    end;
                fieldType::DateTime:
                    begin
                        // Evaluate(valDateTime, fieldRef.Value);
                        // if (valDateTime <> GetDateTime(jsonKey, input)) then
                        fieldRef.Validate(GetDateTime(jsonKey, input));
                    end;
                fieldType::Option:
                    begin
                        //Evaluate(valInteger, fieldRef.Value);

                        //valText := Format(fieldRef.Value); // Get option value as text
                        //valInteger := GetOptionIndex(fieldRef, valText); // Convert to integer

                        //if (valInteger <> GetInt(jsonKey, input)) then
                        fieldRef.Validate(GetInt(jsonKey, input));
                    end;
                fieldType::Integer:
                    begin
                        //Evaluate(valInteger, fieldRef.Value);
                        //if (valInteger <> GetInt(jsonKey, input)) then
                        fieldRef.Validate(GetInt(jsonKey, input));
                    end;
                fieldType::Decimal:
                    begin
                        // Evaluate(valDecimal, fieldRef.Value);
                        // if (valDecimal <> GetDecimal(jsonKey, input)) then
                        fieldRef.Validate(GetDecimal(jsonKey, input));
                    end;
                fieldType::Boolean:
                    begin
                        // Evaluate(valBoolean, fieldRef.Value);
                        // if (valBoolean <> GetBool(jsonKey, input)) then
                        fieldRef.Validate(GetBool(jsonKey, input));
                    end;

                else begin
                    //Evaluate(valText, fieldRef.Value);
                    //if (valText <> GetText(jsonKey, input)) then
                    fieldRef.Validate(GetText(jsonKey, input));
                end;

            end;
        end;
    end;

    local procedure GetOptionIndex(FieldRef: FieldRef; OptionCaption: Text): Integer
    var
        OptionString: Text;
        OptionList: List of [Text];
        OptionIndex: Integer;
    begin
        // Retrieve all option members as a single comma-separated text string
        OptionString := FieldRef.OptionMembers();

        // Split the text into a list of option values
        OptionList := OptionString.Split(',');

        // Find the index of the matching caption
        OptionIndex := OptionList.IndexOf(OptionCaption);

        if OptionIndex = -1 then
            Error('Invalid option value: %1', OptionCaption);

        exit(OptionIndex);
    end;

    // procedure AssignValueToField(var Rec: Record "Afk Customer Revision"; FieldNo: Integer; Value: Variant)
    // var
    //     RecRef: RecordRef;
    //     FldRef: FieldRef;
    // begin
    //     RecRef.GetTable(Rec);
    //     FldRef := RecRef.Field(FieldNo);

    //     case FldRef.Type of
    //         FieldType::Text, FieldType::Code:
    //             FldRef.Value := Value;
    //         FieldType::Option
    //             FldRef.Validate(Value);
    //     end;

    //     RecRef.SetTable(Rec);
    // end;



}

