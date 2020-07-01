pageextension 77501 SpyLedJourBatchExt extends 251
{
    layout
    {
        addlast(Content)
        {
            field("Journal Template Name"; "Journal Template Name")
            {
                Caption = 'Journal Template Name';
                ApplicationArea = All;

            }
            field("Template Type"; "Template Type")
            {
                Caption = 'Template Type';
                ApplicationArea = All;
            }
        }

    }
}