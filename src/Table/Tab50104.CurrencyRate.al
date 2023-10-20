table 50104 "Currency Rate"
{
    Caption = 'Currency Rate';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Currency Name"; Text[400])
        {
            Caption = 'Currency Name';
        }
        field(2; "Buying Rate"; Decimal)
        {
            Caption = 'Buying Rate';
        }
        field(3; "Selling Rate"; Decimal)
        {
            Caption = 'Selling Rate';
        }
        field(4; "Currency Symbol"; Code[20])
        {
            Caption = 'Currency Symbol';
        }
        field(5; Unit; Decimal)
        {
            Caption = 'Unit';
        }
    }
    keys
    {
        key(PK; "Currency Name")
        {
            Clustered = true;
        }
    }
}
