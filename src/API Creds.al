table 50131 "API Creds"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Code; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(2; "Scope Url"; Text[1048])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Application Clinet Id"; Text[1048])
        {
            DataClassification = ToBeClassified;

        }
        field(4; "Client Secret Id"; Text[1048])
        {
            DataClassification = ToBeClassified;
        }

        field(5; "Tenant ID"; Text[1048])
        {
            DataClassification = ToBeClassified;
        }

        field(6; "Acess Token"; Text[1048])
        {
            DataClassification = ToBeClassified;
        }

        field(7; "Acess Tokeb Expires"; DateTime)
        {
            DataClassification = ToBeClassified;
        }
        field(8; URL; Text[1048])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; Code)
        {
            Clustered = true;
        }
    }

    var
        myInt: Integer;

    trigger OnInsert()
    begin

    end;

    trigger OnModify()
    begin

    end;

    trigger OnDelete()
    begin

    end;

    trigger OnRename()
    begin

    end;

}