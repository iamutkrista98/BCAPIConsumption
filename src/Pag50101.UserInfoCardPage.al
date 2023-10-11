page 50104 "UserInfoCard.Page"
{
    Caption = 'User Information Card';
    PageType = Card;
    UsageCategory = Documents;
    ApplicationArea = All;


    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(ID; ID)
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        GetUserInfo();
                    end;

                }
                field(Name; Name)
                {
                    Editable = false;
                    ApplicationArea = All;

                }
                field(Email; Email)
                {
                    Editable = false;
                    ApplicationArea = All;



                }
                field(Phone; Phone)
                {
                    Editable = false;
                    ApplicationArea = All;



                }
                field(CompanyName; CompanyName)
                {
                    Editable = false;
                    ApplicationArea = All;



                }

            }
        }

    }
    local procedure GetUserInfo()
    var
        Client: HttpClient;
        ResponseMessage: HttpResponseMessage;
        Token: JsonToken;
        Object: JsonObject;
        JsonText: Text;
        Url: Text;
    begin
        Url := 'https://jsonplaceholder.typicode.com/users/' + Format(ID);
        if not Client.Get(Url, ResponseMessage) then
            Error('The call to the web services failed');
        if not ResponseMessage.IsSuccessStatusCode then
            Error('The web service returned an error message:\\' +
            'Status Code: %1\' +
            'Description: %2',
            ResponseMessage.HttpStatusCode,
            ResponseMessage.ReasonPhrase);

        ResponseMessage.Content.ReadAs(JsonText);

        if not Object.ReadFrom(JsonText) then
            Error('Invalid Response, expected a JSON Object!');

        Object.Get('name', Token);
        Name := Token.AsValue().AsText();
        Object.Get('phone', Token);
        Phone := Token.AsValue().AsText();
        Object.Get('email', Token);
        Email := Token.AsValue().AsText();
        Object.Get('company', Token);
        Token.AsObject().Get('name', Token);
        CompanyName := Token.AsValue().AsText();
    end;

    var
        ID: Integer;
        Name: Text;
        Email: Text;
        Phone: Text;
        CompanyName: Text;


}
