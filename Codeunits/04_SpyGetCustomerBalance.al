codeunit 77504 SpyCalcCustomerBalance
{
    trigger OnRun()
    begin

    end;

    procedure calcCustomerBalance()
    var
        cust: record Customer;
    begin

        cust.CalcFields("Balance (LCY)", "Balance Due (LCY)");
        cust.FindSet();

    end;

    var

}