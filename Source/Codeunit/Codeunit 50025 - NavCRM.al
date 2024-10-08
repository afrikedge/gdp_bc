codeunit 50025 NavCRM
{

    trigger OnRun()
    begin
        TestWS;
    end;

    var
        HttpClient: DotNet BCHttpClient;
        Uri: DotNet BCUri;
        null: DotNet BCObject;
        HttpResponseMessage: DotNet BCHttpResponseMessage;

    local procedure TestWS()
    begin
        CallRESTWebService(
        'http://services.groupkt.com/',
        StrSubstNo('country/get/iso2code/%1','CM'),
        'GET',null,
        HttpResponseMessage);

        Message('%1', HttpResponseMessage.Content.ReadAsStringAsync.Result);
    end;

    local procedure CallRESTWebService(BaseUrl: Text[100];Method: Text[50];RestMethod: Text;HttpContent: DotNet BCHttpContent;HttpResponseMessage: DotNet BCHttpResponseMessage)
    begin

        HttpClient := HttpClient.HttpClient();
        HttpClient.BaseAddress := Uri.Uri(BaseUrl);


        case RestMethod of

        'GET':
          HttpResponseMessage := HttpClient.GetAsync(Method).Result;
        'POST':
          HttpResponseMessage := HttpClient.PostAsync(Method,HttpContent).Result;

        'PUT':
          HttpResponseMessage := HttpClient.PutAsync(Method,HttpContent).Result;

        'DELETE':
          HttpResponseMessage := HttpClient.DeleteAsync(Method).Result;

        end;
        HttpResponseMessage.EnsureSuccessStatusCode(); // Throws an error when no success
    end;
}

