page 77502 SpyListJournalBatches
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Gen. Journal Batch";


    layout
    {
        area(Content)
        {
            repeater(General)
            {
                field(Name; Name)
                {
                    ApplicationArea = All;
                    Caption = 'Name';

                }
                field("Journal Template Name"; "Journal Template Name")
                {
                    ApplicationArea = All;
                    Caption = 'Journal Template Name';
                }
                field("Template Type"; "Template Type")
                {
                    ApplicationArea = All;
                    Caption = 'Template Type';
                }
                Field(Description; Description)
                {
                    ApplicationArea = All;
                    Caption = 'Description';
                }
                field("Allow VAT Difference"; "Allow VAT Difference")
                {
                    ApplicationArea = All;
                    Caption = 'Allow VAT Difference';
                }
                field("Copy VAT Setup to Jnl. Lines"; "Copy VAT Setup to Jnl. Lines")
                {
                    ApplicationArea = All;
                    Caption = 'Copy VAT Setup to Jnl. Lines';
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