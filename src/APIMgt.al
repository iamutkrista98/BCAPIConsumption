codeunit 50131 "API Mgt"
{
    trigger OnRun()
    begin

    end;

    procedure getAccessToken()
    var
        APICreds: Record "API Creds";
        Scopes: List of [text];
        OAuth2: Codeunit OAuth2;
        AccessToken: Text;
        AccessTime: DateTime;
    begin
        APICreds.Get();
        Scopes.Add(APICreds."Scope Url");
        if not OAuth2.AcquireTokenWithClientCredentials(APICreds."Application Clinet Id", APICreds."Client Secret Id",
        'https://login.microsoftonline.com/' + APICreds."Tenant ID" + '/oauth2/v2.0/token', '', Scopes, AccessToken) then
            Error('Cant get access token %1', GetLastErrorText());

        AccessTime := CurrentDateTime + (3599 * 1000); // 1hour //milli seconds

        APICreds."Acess Token" := AccessToken;
        APICreds."Acess Tokeb Expires" := AccessTime;
        APICreds.Modify();
    end;

    procedure getRuntimeAccessToken(): TExt
    var
        APICreds: Record "API Creds";
        Scopes: List of [text];
        OAuth2: Codeunit OAuth2;
        AccessToken: Text;

    begin
        APICreds.Get();
        Scopes.Add(APICreds."Scope Url");
        if not OAuth2.AcquireTokenWithClientCredentials(APICreds."Application Clinet Id", APICreds."Client Secret Id",
        'https://login.microsoftonline.com/' + APICreds."Tenant ID" + '/oauth2/v2.0/token', '', Scopes, AccessToken) then
            Error('Cant get access token %1', GetLastErrorText());

        //   Message(AccessToken);
        exit(AccessToken);
    end;

    procedure getAllCustomers()
    var
        HttpClinet: HttpClient;
        HRespone: HttpResponseMessage;
        HRequest: HttpRequestMessage;
        Auth: Text;
        ApiCred: Record "API Creds";
        Url: Text;
        result: Text;
        JObject: JsonObject;
        JToken: JsonToken;
        JArray: JsonArray;
        i: Integer;
        CustomerSand: Record "Customer From Sandbox";

    begin
        ApiCred.Get();
        //Url := ApiCred.URL + '/deltaCustomers';
        url := 'https://api.businesscentral.dynamics.com/v2.0/sandbox/api/AgileSolutions/Delta/v2.0/companies(b8f1bfc7-a01c-ee11-8f6e-6045bd1f6c0c)/deltaCustomers';
        Auth := StrSubstNo('Bearer %1', getRuntimeAccessToken());

        HttpClinet.DefaultRequestHeaders.Add('Authorization', Auth);
        HttpClinet.DefaultRequestHeaders.Add('Accept', 'application/json');

        if HttpClinet.Get(Url, HRespone) then
            if not HRespone.IsSuccessStatusCode then
                Error('Unable to connect API.');

        HRespone.Content.ReadAs(result);  //stores the value from the reponse into result variable

        //inserting
        JObject.ReadFrom(result); //gets the object value from resilt and pass to JObject
        JObject.Get('value', JToken); //In the Token Store the selected token called value
        JArray := JToken.AsArray(); //Store the Token obtained as array

        CustomerSand.DeleteAll();

        for i := 0 to JArray.Count - 1 do begin //looping through array 
            JArray.Get(i, JToken); //gets value in JToken from each itrative objects as we can see in postman
            //
            JObject := JToken.AsObject(); //since out JArray converts each itation objects so we pass it into Jobject

            // JObject.Get('number', JToken);
            // CustomerSand."No." := JToken.AsValue().AsCode();
            CustomerSand."No." := getToken('number', JObject).AsValue().AsCode();
            CustomerSand.Name := getToken('displayName', JObject).AsValue().AsText();
            CustomerSand.Insert(true);
        end;




    end;

    procedure getToken(keyVal: Text; JObj: JsonObject) JT: JsonToken
    var
    begin
        JObj.Get(keyVal, JT)
    end;

    procedure postCustomer()
    var
        Customer: Record "Customer From Sandbox";
        HttpClinet: HttpClient;
        Response: HttpResponseMessage;
        Request: HttpRequestMessage;
        Content: HttpContent;
        ErrorContent: HttpContent;
        Url: Text;
        APiCred: Record "API Creds";
        Auth: Text;
        result: Text;
        RequestHeader: HttpHeaders;
        JObj: JsonObject;
        payload: Text;
        contentHdr: HttpHeaders;
        err: Text;

    begin
        Customer.Reset();
        Customer.SetRange("Is not sandbox", true);
        Customer.FindFirst();


        ApiCred.Get();
        //Url := ApiCred.URL + '/deltaCustomers';
        url := 'https://api.businesscentral.dynamics.com/v2.0/sandbox/api/AgileSolutions/Delta/v2.0/companies(b8f1bfc7-a01c-ee11-8f6e-6045bd1f6c0c)/deltaCustomers';
        Auth := StrSubstNo('Bearer %1', getRuntimeAccessToken());

        RequestHeader := HttpClinet.DefaultRequestHeaders;
        RequestHeader.Add('Authorization', Auth);

        JObj.Add('number', Customer."No.");
        JObj.Add('displayName', Customer.Name);

        JObj.WriteTo(payload);  //this writs to payload
        Content.WriteFrom(payload); //payload will be passed to content
        Content.GetHeaders(contentHdr);
        contentHdr.Clear();
        contentHdr.Add('Content-Type', 'application/json');
        if HttpClinet.Post(Url, Content, Response) then begin
            if not Response.IsSuccessStatusCode then begin
                Response.Content.ReadAs(err);
                Error('Unable to connect. %1 also %2', err, GetLastErrorText());

            end;
        end;
    end;


    procedure GetUserInformation(UserNumber: Integer)
    var
        Client: HttpClient;
        ResponseMessage: HttpResponseMessage;
        ResponseString: Text;

    begin
        if not Client.Get(StrSubstNo('https://my-json-server.typicode.com/iamutkrista98/BCRestAPITesting/users/%1', UserNumber), ResponseMessage) then
            Error('The API Server Failed to Respond');

        if not ResponseMessage.IsSuccessStatusCode() then
            Error('The web service returned an error message:\\' + 'Status Code: ' + Format(ResponseMessage.HttpStatusCode()) +
            'Description: ' + ResponseMessage.ReasonPhrase());

        ResponseMessage.Content().ReadAs(ResponseString);
    end;


    var
        myInt: Integer;
}