page 77504 SpyJournalPage
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Gen. Journal Line";

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Document No."; "Document No.")
                {
                    ApplicationArea = All;
                }
                field("External Document No."; "External Document No.")
                {
                    ApplicationArea = All;
                }
                field("Account No."; "Account No.")
                {
                    ApplicationArea = All;
                }
                field("Account Type"; "Account Type")
                {
                    ApplicationArea = All;
                }
                field(Amount; Amount)
                {
                    ApplicationArea = All;
                }
                field("Currency Code"; "Currency Code")
                {
                    ApplicationArea = All;
                }
                field("Amount (LCY)"; "Amount (LCY)")
                {
                    ApplicationArea = All;
                }
                field("Document Type"; "Document Type")
                {
                    ApplicationArea = All;
                }
                field(Description; Description)
                {
                    ApplicationArea = All;
                }
                field("Journal Template Name"; "Journal Template Name")
                {
                    ApplicationArea = All;
                }
                field("Journal Batch Name"; "Journal Batch Name")
                {
                    ApplicationArea = All;
                }

            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}