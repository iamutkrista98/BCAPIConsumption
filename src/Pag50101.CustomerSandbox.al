page 50132 "Customer Sandbox"
{
    ApplicationArea = All;
    Caption = 'Customer Sandbox';
    PageType = List;
    SourceTable = "Customer From Sandbox";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the value of the No. field.';
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ToolTip = 'Specifies the value of the Name field.';
                    ApplicationArea = All;

                }
                field("Is not sandbox"; Rec."Is not sandbox")
                {
                    ToolTip = 'Specifies the value of the Name field.';
                    ApplicationArea = All;

                }
            }
        }
    }
}
