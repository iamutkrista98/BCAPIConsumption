table 50133 "Customer From Sandbox"
{
    Caption = 'Customer From Sandbox';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(2; Name; Text[2048])
        {
            Caption = 'Name';
        }
        field(3; "Is not sandbox"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
}
