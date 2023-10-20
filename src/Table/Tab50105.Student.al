table 50105 Student
{
    Caption = 'Student';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; ID; Integer)
        {
            Caption = 'ID';
            AutoIncrement = true;
        }
        field(2; Name; Text[50])
        {
            Caption = 'Name';
        }
        field(3; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
        }
        field(4; Email; Text[250])
        {
            Caption = 'Email';
        }
        field(5; Website; Text[250])
        {
            Caption = 'Website';
        }
        field(6; Latitude; Decimal)
        {
            Caption = 'Latitude';
        }
        field(7; "Longitude"; Decimal)
        {
            Caption = 'Longitude ';
        }
        field(8; City; Text[100])
        {
            Caption = 'City';
        }
        field(9; Active; Boolean)
        {
            Caption = 'Active';
        }
        field(10; "Web ID"; Integer)
        {
            Caption = 'Web ID';
        }
        field(11; IP; Text[100])
        {

        }

    }
    keys
    {
        key(PK; ID)
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin
        if Rec.Name = '' then
            Error('Name must have a value');
    end;
}
