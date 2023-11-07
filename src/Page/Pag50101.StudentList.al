page 50106 "Student List"
{
    ApplicationArea = All;
    Caption = 'Student List';
    PageType = List;
    SourceTable = Student;
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(ID; Rec.ID)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the ID field.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Name field.';
                    ShowMandatory = true;

                }
                field("Phone No."; Rec."Phone No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Phone No. field.';
                }
                field(Email; Rec.Email)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Email field.';
                }
                field(Website; Rec.Website)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Website field.';
                }
                field(Latitude; Rec.Latitude)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Latitude field.';
                }
                field(Longitude; Rec.Longitude)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Longitude  field.';
                }
                field(City; Rec.City)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the City field.';
                }
                field(Active; Rec.Active)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Active field.';
                }
                field("Web ID"; Rec."Web ID")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Web ID field.';
                }
                field("IP"; Rec.IP)
                {
                    ApplicationArea = All;


                }
            }
        }

    }
    actions
    {
        area(Processing)
        {
            action(GetStudentInformationFromRestAPI)
            {
                ApplicationArea = All;
                Caption = 'Get Students from REST API';
                Image = GetLines;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    http_Client: HttpClient;
                    http_ResponseMsg: HttpResponseMessage;
                    response: Text;
                begin
                    if http_Client.Get('https://jsonplaceholder.typicode.com/users', http_ResponseMsg) then begin
                        http_ResponseMsg.Content.ReadAs(response);
                        ReadResultFromResponse(response);
                    end;





                end;
            }
            action(GetSystemIP)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = Map;
                trigger OnAction()
                var
                    Stud: Record Student;

                begin
                    if not Confirm('Do you like to get the ip address?', false) then
                        exit;
                    Stud.Reset();
                    Stud.SetRange("Web ID", Rec."Web ID");
                    if Stud.FindSet() then
                        repeat
                            if Rec."Web ID" = 10 then begin

                                Rec.IP := GetIP();
                                Stud.Modify();
                            end
                            else begin

                                Rec.IP := '';
                            end;
                        until Stud.Next() = 0;
                end;




            }
            action(ReadDataFromForex)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedIsBig = true;
                Image = MapDimensions;

                trigger OnAction()
                var
                    Client: HttpClient;
                    HResp: HttpResponseMessage;
                    resp: Text;
                    jsonObj: JsonObject;

                begin
                    if Client.Get('https://www.nrb.org.np/api/forex/v1/rates?page=1&per_page=100&from=2023-02-12&to=2023-02-12', HResp) then
                        if HResp.IsSuccessStatusCode() then begin
                            HResp.Content.ReadAs(resp);
                            Message(resp);
                        end;
                end;
            }
            action(DateEvaluatpr)
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    Date1: Date;
                    c: Record "Cust. Ledger Entry";
                begin
                    c.SetFilter("Posting Date", 'YESTERDAY..TOMORROW');
                    Date1 := CalcDate('CQ+1M', Today());
                    Message('The date is: %1', Date1);
                    Message(c.GetFilter("Posting Date"));

                end;

            }
        }

    }

    local procedure ReadResultFromResponse(response: Text)
    var
        json_Array: JsonArray;//[]
        json_Object: JsonObject;//{}
        json_Value: JsonValue;
        i: Integer;
        recStudent: Record Student;
        studID: Integer;
        json_Token: JsonToken;
        valueJToken: JsonToken;
    begin
        recStudent.Reset();
        if recStudent.FindLast() then
            studID := recStudent.ID + 1
        else
            studID := 1;
        //Read the response in JsonToken Variable
        if json_Token.ReadFrom(response) then begin
            //check the response is an array as we saw it was clearly visible response was in the array
            if json_Token.IsArray then begin
                //convert jsontoken to jsonarray
                json_Array := json_Token.AsArray();
                //now a we have the response in array lets read every records from the array
                for i := 0 to json_Array.Count - 1 do begin
                    //get the first record from the array result that is an object
                    json_Array.Get(i, json_Token);

                    if json_Token.IsObject then begin
                        json_Object := json_Token.AsObject();
                        recStudent.Reset();
                        recStudent.Init();
                        recStudent.ID := studID;


                        if json_Object.Get('id', valueJToken) then begin
                            if valueJToken.IsValue then begin
                                // Message(valueJToken.AsValue().AsText());
                                recStudent."Web ID" := valueJToken.AsValue().AsInteger();

                            end;
                        end;
                        if GetResultJsonValue(json_Object, 'name', json_Value) then
                            // Message(json_Value.AsText());
                            recStudent.Name := json_Value.AsText();
                        if GetResultJsonValue(json_Object, 'email', json_Value) then
                            // Message(json_Value.AsText());
                            recStudent.Email := json_Value.AsText();
                        if GetResultJsonValue(json_Object, 'phone', json_Value) then
                            // Message(json_Value.AsText());
                            recStudent."Phone No." := json_Value.AsText();
                        if GetResultJsonValue(json_Object, 'website', json_Value) then
                            // Message(json_Value.AsText());
                            recStudent.Website := json_Value.AsText();
                        //reading level 2 values
                        if json_Object.Get('address', json_Token) then begin
                            if json_Token.IsObject then begin
                                //convert JsonToken to JsonObject
                                json_Object := json_Token.AsObject();
                                if GetResultJsonValue(json_Object, 'city', json_Value) then
                                    recStudent.City := json_Value.AsText();

                                //read level 2.1 values from geo
                                if json_Object.Get('geo', json_Token) then begin
                                    if json_Token.IsObject then begin
                                        //convert JsonToken To JsonObject
                                        json_Object := json_Token.AsObject();
                                        if GetResultJsonValue(json_Object, 'lat', json_Value) then
                                            recStudent.Latitude := json_Value.AsDecimal();
                                        if GetResultJsonValue(json_Object, 'lng', json_Value) then
                                            recStudent.Longitude := json_Value.AsDecimal();
                                    end;
                                end;


                            end;
                        end;
                        recStudent.Active := true;
                        recStudent.Insert();
                        studID += 1;
                    end;
                end;


            end;
        end;



    end;

    local procedure GetResultJsonValue(jObj: JsonObject; KeyName: Text; var jValue: JsonValue): Boolean
    var
        json_Token: JsonToken;

    begin
        if not jObj.Get(KeyName, json_Token) then exit;
        jValue := json_Token.AsValue();
        exit(true);



    end;


    local procedure GetIP(): Text
    var
        Client: HttpClient;
        Response: HttpResponseMessage;
        JObj: JsonObject;
        ResponseTxt: Text;

    begin
        if Client.Get('https://api.ipify.org?format=json', Response) then
            if Response.IsSuccessStatusCode() then begin
                Response.Content().ReadAs(ResponseTxt);
                JObj.ReadFrom(ResponseTxt);
                exit(GetJsonTextField(JObj, 'ip'));
            end;

    end;

    local procedure GetJsonTextField(JObj: JsonObject; Member: Text): Text
    var

        Result: JsonToken;
    begin
        if JObj.Get(Member, Result) then
            exit(Result.AsValue().AsText());
    end;


    var
        IP: Text;


    trigger OnOpenPage()
    begin
        Rec.Active := False;
    end;
}
