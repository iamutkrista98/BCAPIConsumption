codeunit 50105 "API Management"
{
    procedure GetCurrency()
    var
        HTTPClient: HttpClient;
        HttpResponse: HttpResponseMessage;
        HttpRequest: HttpRequestMessage;
        JsonObj: JsonObject;
        JsonToken: JsonToken;
        JsonArray: JsonArray;
        JsonText: Text;
        I: Integer;
        Currency: Record "Currency Rate";
        url: Text;
        J: Integer;
    begin
        url := 'https://www.nrb.org.np/api/forex/v1/rates?page=1&per_page=100&from=2023-02-12&to=2023-02-12';
        if not HTTPClient.Get(url, HttpResponse) then
            Error('Call to the web service failed');

        if not HttpResponse.IsSuccessStatusCode then
            Error('The web service returned an error message:\\' + 'Status Code: %1\' + 'Description:%2', HttpResponse.HttpStatusCode, HttpResponse.ReasonPhrase);
        HttpResponse.Content.ReadAs(JsonText);

        if not JsonObj.ReadFrom(JsonText) then
            Error('Invalid Response, Expected a Json Object');

        JsonObj.Get('data', JsonToken);//gets the object data from result
        JsonObj.ReadFrom(Format(JsonToken));
        JsonObj.Get('payload', JsonToken);//get payload array from json object
        JsonArray.ReadFrom(Format(JsonToken));
        Currency.DeleteAll();
        Message('Successfully Deleted Older Data');

        for I := 0 to JsonArray.Count - 1 do begin
            JsonArray.Get(I, JsonToken);//gets value in JToken from each iterative objects as we can see in postman
            JsonObj := JsonToken.AsObject();//since out JArray converts each iteration objects so we pass to Jobject
            JsonObj.Get('rates', JsonToken);
            JsonArray.ReadFrom(Format(JsonToken));
            for J := 0 to JsonArray.Count() - 1 do begin
                JsonArray.Get(J, JsonToken);
                JsonObj := JsonToken.AsObject();
                Currency."Buying Rate" := getToken('buy', JsonObj).AsValue().AsDecimal();
                Currency."Selling Rate" := getToken('sell', JsonObj).AsValue().AsDecimal();
                JsonObj.Get('currency', JsonToken);
                JsonObj.ReadFrom(Format(JsonToken));
                Currency."Currency Symbol" := getToken('iso3', JsonObj).AsValue().AsCode();
                Currency."Currency Name" := getToken('name', JsonObj).AsValue().AsText();
                Currency.Unit := getToken('unit', JsonObj).AsValue().AsDecimal();
                Currency.Insert(true);
            end;
            Message('New Data Updated');

        end;

    end;

    local procedure getToken(keyVal: Text; JsonObj: JsonObject) JT: JsonToken
    begin
        JsonObj.Get(keyVal, JT);

    end;

}
