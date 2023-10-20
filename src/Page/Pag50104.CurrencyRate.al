page 50108 "Currency Rate"
{
    ApplicationArea = All;
    Caption = 'Currency Rate';
    PageType = List;
    SourceTable = "Currency Rate";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Currency Name"; Rec."Currency Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Currency Name field.';
                }
                field("Buying Rate"; Rec."Buying Rate")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Buying Rate field.';
                }
                field("Selling Rate"; Rec."Selling Rate")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Selling Rate field.';
                }
                field("Currency Symbol"; Rec."Currency Symbol")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Currency Symbol field.';
                }
                field(Unit; Rec.Unit)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Unit field.';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Get Currency")
            {
                ApplicationArea = All;
                Image = Currencies;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                trigger OnAction()
                var
                    ApiMgt: Codeunit "API Management";
                begin
                    ApiMgt.GetCurrency();


                end;
            }
        }
    }
}
