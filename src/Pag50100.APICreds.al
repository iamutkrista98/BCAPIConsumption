page 50131 "API Creds"
{
    ApplicationArea = All;
    Caption = 'API Creds';
    PageType = Card;
    SourceTable = "API Creds";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';

                field("Scope Url"; Rec."Scope Url")
                {
                    ApplicationArea = All;
                    // FieldPropertyName = FieldPropertyValue;
                }

                field("Application Clinet Id"; Rec."Application Clinet Id")
                {
                    ApplicationArea = All;
                    // FieldPropertyName = FieldPropertyValue;
                }

                field("Client Secret Id"; Rec."Client Secret Id")
                {
                    ApplicationArea = All;
                    // FieldPropertyName = FieldPropertyValue;
                }
                field("Tenant ID"; Rec."Tenant ID")
                {
                    ApplicationArea = All;
                    // FieldPropertyName = FieldPropertyValue;
                }
                field("Acess Token"; Rec."Acess Token")
                {
                    ApplicationArea = All;
                    // FieldPropertyName = FieldPropertyValue;
                }
                field("Acess Token Expires"; Rec."Acess Tokeb Expires")
                {
                    ApplicationArea = All;
                    // FieldPropertyName = FieldPropertyValue;
                }

                field(URL; Rec.URL)
                {
                    ApplicationArea = All;
                    // FieldPropertyName = FieldPropertyValue;
                }


            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Get Customer")
            {
                ApplicationArea = All;
                Image = AddWatch;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    APIMgt: Codeunit "API Mgt";
                begin
                    APIMgt.getAllCustomers();
                    //APIMgt.getRuntimeAccessToken;
                end;
            }

            action("Post Customer")
            {
                ApplicationArea = All;
                Image = PostedDeposit;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    APIMgt: Codeunit "API Mgt";
                begin
                    APIMgt.postCustomer();
                end;
            }
        }
    }
}
