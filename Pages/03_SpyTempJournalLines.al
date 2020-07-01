page 77503 SpyTempJournalLines
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Gen. Journal Line";
    SourceTableTemporary = true;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Journal Batch Name"; "Journal Batch Name")
                {
                    ApplicationArea = All;
                    Caption = 'Journal Batch Name';

                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(UPJO)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin
                    message('UPJO');
                end;
            }
        }
    }

    procedure UpdateJournal()
    var
        myInt: Integer;
    begin
        message('Test');
    end;

    trigger OnClosePage()
    begin
        UpdateJournal();
    end;

    var
        myInt: Integer;
}