codeunit 77502 SpyCreateJournalLine
{

    trigger OnRun()
    begin

    end;

    procedure CreateJournalLine(VAR journalLineList: XmlPort SpyXmlCreateJournalLine) Return: Text[50]
    begin
        journalLineList.Import();
        EXIT(Database.CompanyName);
    end;

    procedure ExportJournalLine(VAR journalLineList: XmlPort SpyXmlCreateJournalLine) Return: Text[50]
    begin
        journalLineList.Export();
        EXIT(Database.CompanyName);
    end;
}