tableextension 50102 "Sales Line Ext" extends "Sales Line"
{
    fields
    {
        field(50100; cust1; Code[20])
        {
            Caption = 'cust1';
            DataClassification = ToBeClassified;
        }
    }
}
