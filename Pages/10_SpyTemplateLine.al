page 77510 SpyTemplateLine
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "Config. Template Line";

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field(Template; "Data Template Code")
                {
                    ApplicationArea = All;
                }
                field(FieldName; "Field Name")
                {
                    ApplicationArea = All;
                }
                field(DefaultValue; "Default Value")
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