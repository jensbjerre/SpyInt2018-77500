xmlport 77501 SpyXmlCreateJournalLine
{
    UseDefaultNamespace = true;
    DefaultNamespace = 'urn:microsoft-dynamics-nav/xmlports/SpyXmlCreateJournalLine';
    FormatEvaluate = Xml;

    schema
    {
        textelement(accountingLines)
        {
            MinOccurs = Zero;
            MaxOccurs = Unbounded;
            tableelement(journalLine; "Gen. Journal Line")
            {
                UseTemporary = false;

                fieldelement(templateName; journalLine."Journal Template Name")
                {
                    FieldValidate = No;
                    MinOccurs = Zero;
                    MaxOccurs = Once;

                    trigger OnAfterAssignField()
                    var

                    begin
                        templateName := journalLine."Journal Template Name";
                    end;
                }
                fieldelement(journalName; journalLine."Journal Batch Name")
                {
                    FieldValidate = No;
                    MinOccurs = Once;
                    MaxOccurs = Once;

                    trigger OnAfterAssignField()
                    var
                        myInt: Integer;
                    begin
                        batchName := journalLine."Journal Batch Name";
                        if templateName = '' then
                            templateName := 'KASSE';
                        genJournalBatch.SetFilter("Journal Template Name", templateName);
                        genJournalBatch.SetFilter("Template Type", FORMAT(genJournalBatch."Template Type"::General));
                        genJournalBatch.SetFilter(Name, journalLine."Journal Batch Name");
                        if not genJournalBatch.FindSet() then begin
                            genJournalBatch.Init();
                            genJournalBatch.Description := 'Spy Journal';
                            genJournalBatch.Name := journalLine."Journal Batch Name";
                            genJournalBatch."Template Type" := genJournalBatch."Template Type"::General;
                            genJournalBatch."Journal Template Name" := templateName;
                            genJournalBatch.Insert();
                        end;
                        journalLine."Journal Template Name" := templateName;
                    end;
                }
                fieldelement(documentNumber; journalLine."Document No.")
                {
                    MinOccurs = Once;
                    MaxOccurs = Once;

                    trigger OnAfterAssignField()
                    var
                        myInt: Integer;
                    begin
                        //Voucher := journalLine."Document No.";
                    end;
                }
                textelement(documentType)
                {
                    MinOccurs = Zero;
                    MaxOccurs = Once;
                    trigger OnAfterAssignVariable()
                    var

                    begin
                        PostingType := '';
                        case documentType of
                            'Sale':
                                begin
                                    journalLine."Document Type" := journalLine."Document Type"::Invoice;
                                    PostingType := 'Sale';
                                end;
                            'SaleCredit':
                                begin
                                    journalLine."Document Type" := journalLine."Document Type"::"Credit Memo";
                                    PostingType := 'Sale';
                                end;
                            'Purchase':
                                begin
                                    journalLine."Document Type" := journalLine."Document Type"::Invoice;
                                    PostingType := 'Purchase';
                                end;
                            'PurchaseCredit':
                                begin
                                    journalLine."Document Type" := journalLine."Document Type"::"Credit Memo";
                                    PostingType := 'Purchase';
                                end;
                        end;
                    end;
                }
                textelement(countryType)
                {
                    MinOccurs = Zero;
                    MaxOccurs = Once;
                }
                fieldelement(account; journalLine."Account No.")
                {
                    FieldValidate = No;
                    MinOccurs = Once;
                    MaxOccurs = Once;
                }
                fieldelement(description; journalLine.Description)
                {
                    MinOccurs = Once;
                    MaxOccurs = Once;

                }
                fieldelement(amount; journalLine.Amount)
                {
                    MinOccurs = Once;
                    MaxOccurs = Once;

                }
                textelement(entryType)
                {
                    MinOccurs = Zero;
                    MaxOccurs = Once;
                }
                textelement(postingDate)
                {
                    MinOccurs = Zero;
                    MaxOccurs = Once;
                    trigger OnAfterAssignVariable()
                    var
                        day: integer;
                        month: Integer;
                        year: Integer;
                    begin
                        evaluate(day, CopyStr(postingDate, 9, 2));
                        evaluate(month, CopyStr(postingDate, 6, 2));
                        evaluate(year, CopyStr(postingDate, 1, 4));
                        journalLine."Posting Date" := DMY2Date(day, month, year);
                    end;
                }
                textelement(deliveryAccount)
                {
                    MinOccurs = Zero;
                    MaxOccurs = Once;
                }
                textelement(postType)
                {
                    MinOccurs = Once;
                    MaxOccurs = Once;
                    trigger OnAfterAssignVariable()
                    var

                    begin
                        case postType of
                            'tax':
                                journalLine."Account Type" := journalLine."Account Type"::"G/L Account";
                            'ledger':
                                journalLine."Account Type" := journalLine."Account Type"::"G/L Account";
                            'customer':
                                journalLine."Account Type" := journalLine."Account Type"::Customer;
                            'supplier':
                                journalLine."Account Type" := journalLine."Account Type"::Vendor;
                        end;

                        journalLine.Validate("Account No.");

                    end;

                }
                fieldelement(invoiceNo; journalLine."External Document No.")
                {
                    MinOccurs = Zero;
                    MaxOccurs = Once;
                }
                textelement(currency)
                {
                    MinOccurs = Zero;
                    MaxOccurs = Once;
                    trigger OnAfterAssignVariable()
                    var

                    begin
                        journalLine."Currency Code" := currency;
                    end;
                }
                fieldelement(amountBaseCurrency; journalLine."Amount (LCY)")
                {
                    MinOccurs = Once;
                    MaxOccurs = Once;
                }
                textelement(countyUSTaxAccount)
                {
                    MinOccurs = Zero;
                    MaxOccurs = Once;
                }
                textelement(stateUSTaxAccount)
                {
                    MinOccurs = Zero;
                    MaxOccurs = Once;
                }
                textelement(vatCode)
                {
                    MinOccurs = Zero;
                    MaxOccurs = Once;


                    trigger OnBeforePassVariable()
                    begin
                        vatcode := '';
                    end;


                }
                textelement(vatArea)
                {
                    MinOccurs = Zero;
                    MaxOccurs = Once;
                }
                textelement(taxTitle)
                {
                    MinOccurs = Zero;
                    MaxOccurs = Once;
                    trigger OnAfterAssignVariable()
                    begin
                        taxTitle := DelChr(taxTitle, '=', '()');
                        if TaxTitle <> '' then begin
                            IF ((STRPOS(TaxTitle, 'State Tax') <> 0) OR (STRPOS(TaxTitle, 'County Tax') <> 0) OR (STRPOS(TaxTitle, 'Municipal Tax') <> 0)) THEN BEGIN
                                if STRPOS(TaxTitle, 'State Tax') <> 0 then begin
                                    DB.Init();
                                    DB."Table ID" := 81;
                                    DB."Entry No." := EntryNo;
                                    EntryNo := EntryNo + 1;
                                    DB."Dimension Code" := 'STATETAX';
                                    DB."Dimension Value Code" := TaxTitle;
                                    DB.Insert();
                                    StateTax := TaxTitle;
                                    journalLine."Account No." := stateUSTaxAccount;
                                end else begin
                                    if STRPOS(TaxTitle, 'County Tax') <> 0 then begin
                                        TaxTitle := DELSTR(TaxTitle, STRPOS(TaxTitle, 'County Tax'));
                                    end;
                                    if STRPOS(taxTitle, 'Municipal Tax') <> 0 then begin
                                        TaxTitle := DelStr(taxTitle, STRPOS(TaxTitle, ' Tax'));
                                    end;
                                    DB.Init();
                                    DB."Table ID" := 81;
                                    DB."Entry No." := EntryNo;
                                    EntryNo := EntryNo + 1;
                                    DB."Dimension Code" := 'STATETAX';
                                    DB."Dimension Value Code" := StateTax;
                                    DB.Insert();
                                    DB.Init();
                                    DB."Table ID" := 81;
                                    DB."Entry No." := EntryNo;
                                    EntryNo := EntryNo + 1;
                                    DB."Dimension Code" := 'COUNTYTAX';
                                    DB."Dimension Value Code" := TaxTitle;
                                    DB.Insert();
                                    journalLine."Account No." := countyUSTaxAccount;
                                    StateTax := '';
                                END;
                            END;
                            taxTitle := '';
                        end;
                    end;
                }
                textelement(taxPercentage)
                {
                    MinOccurs = Zero;
                    MaxOccurs = Once;
                }
                textelement(dueDate)
                {
                    MinOccurs = Zero;
                    MaxOccurs = Once;

                    trigger OnAfterAssignVariable()
                    var
                        day: integer;
                        month: Integer;
                        year: Integer;
                    begin
                        evaluate(day, CopyStr(dueDate, 9, 2));
                        evaluate(month, CopyStr(dueDate, 6, 2));
                        evaluate(year, CopyStr(dueDate, 1, 4));
                        journalLine."Due Date" := DMY2Date(day, month, year);
                    end;
                }
                textelement(paymentTerm)
                {
                    MinOccurs = Zero;
                    MaxOccurs = Once;
                }
                textelement(cashDiscountDate)
                {
                    MinOccurs = Zero;
                    MaxOccurs = Once;

                    trigger OnAfterAssignVariable()
                    var
                        day: integer;
                        month: Integer;
                        year: Integer;
                    begin
                        evaluate(day, CopyStr(cashDiscountDate, 9, 2));
                        evaluate(month, CopyStr(cashDiscountDate, 6, 2));
                        evaluate(year, CopyStr(cashDiscountDate, 1, 4));
                        journalLine."Pmt. Discount Date" := DMY2Date(day, month, year);
                    end;
                }
                textelement(cashDiscountAmount)
                {
                    MinOccurs = Zero;
                    MaxOccurs = Once;
                }
                textelement(custGroup)
                {
                    MinOccurs = Zero;
                    MaxOccurs = Once;
                }

                textelement(dimensions)
                {
                    MinOccurs = Zero;
                    MaxOccurs = Once;


                    textelement(dimension)
                    {
                        MinOccurs = Zero;
                        MaxOccurs = Unbounded;

                        textelement(dimensionName)
                        {
                            MinOccurs = Zero;
                            MaxOccurs = Once;
                        }
                        textelement(dimensionValue)
                        {
                            MinOccurs = Zero;
                            MaxOccurs = Once;
                        }
                        trigger OnAfterAssignVariable()
                        begin
                            if (dimensionName <> '') and (dimensionValue <> '') then begin
                                Dim.SetFilter(Code, dimensionName);
                                if not Dim.FindSet() then begin
                                    Dim.Init();
                                    Dim.Code := dimensionName;
                                    dim.Name := dimensionName;
                                    Dim.Insert(true);
                                end;
                                DV.SetFilter("Dimension Code", dimensionName);
                                DV.SetFilter(Code, dimensionValue);
                                if not DV.FindSet() then begin
                                    DV.Init();
                                    DV."Dimension Code" := dimensionName;
                                    DV.Code := dimensionValue;
                                    DV.Insert(true);
                                end;
                                DB.Reset();
                                DB.SetFilter("Dimension Code", dimensionName);
                                db.SetFilter("Dimension Value Code", dimensionValue);
                                db.SetFilter("Table ID", '81');
                                if not DB.FindSet() then begin
                                    DB.Reset();
                                    DB.Init();
                                    DB."Entry No." := EntryNo;
                                    EntryNo := EntryNo + 1;
                                    DB."Table ID" := 81;
                                    DB."Dimension Code" := dimensionName;
                                    DB."Dimension Value Code" := dimensionValue;
                                    DB.Insert();
                                end;
                            end;
                        end;
                    }


                }
                trigger OnBeforeInsertRecord()
                begin
                    if journalLine."Currency Code" <> currency then begin
                        journalLine."Currency Code" := currency;
                        journalLine.Validate("Currency Code");
                    end;
                    // Findes der en bankkonto
                    if (entryType = 'payment_offset') and (postType = 'ledger') then begiN
                        // Rettet så version 14 og 15 er det samme vha. FieldRef
                        MyTableRef.Open(Database::"Bank Account Posting Group");
                        if MyTableref.FieldExist(3) then
                            MyFldRef := MyTableRef.Field(3)
                        else
                            MyFldRef := MyTableRef.Field(2);

                        MyFldRef.SetFilter(journalLine."Account No.");
                        If MyTableRef.FindSet() THEN begin
                            BankAccount.SetFilter("Bank Acc. Posting Group", MyTableRef.field(1).Value);
                            BankAccount.SetFilter("Currency Code", journalLine."Currency Code");
                            if BankAccount.FindFirst() then begin
                                journalLine."Account Type" := journalLine."Account Type"::"Bank Account";
                                journalLine."Account No." := BankAccount."No.";
                                journalLine.validate("Account No.");
                            end;
                        end;
                        // PostingGroup.SetFilter("G/L Account No.", journalLine."Account No.");
                        // if PostingGroup.FindFirst() then begin
                        //     BankAccount.SetFilter("Bank Acc. Posting Group", PostingGroup.Code);
                        //     BankAccount.SetFilter("Currency Code", journalLine."Currency Code");
                        //     if BankAccount.FindFirst() then begin
                        //         journalLine."Account Type" := journalLine."Account Type"::"Bank Account";
                        //         journalLine."Account No." := BankAccount."No.";
                        //         journalLine.validate("Account No.");
                        //     end;

                        // end;
                    end;

                    genJournalLine.reset;
                    genJournalLine.SetCurrentKey(genJournalLine."Journal Template Name", genJournalLine."Journal Batch Name", genJournalLine."Line No.");
                    genJournalLine.SetFilter("Journal Batch Name", batchName);
                    genJournalLine.SetFilter("Journal Template Name", templateName);
                    if genJournalLine.FindLast() then
                        JournalLine."Line No." := genJournalLine."Line No." + 100
                    else
                        JournalLine."Line No." := 100;
                end;

                trigger OnAfterInsertRecord()
                var

                begin
                    // Set postingsgrupper
                    journalLine."Gen. Bus. Posting Group" := '';
                    journalLine."Gen. Prod. Posting Group" := '';
                    journalLine."Gen. Posting Type" := journalLine."Gen. Posting Type"::" ";
                    journalLine."VAT Prod. Posting Group" := '';
                    journalLine."VAT Bus. Posting Group" := '';
                    if vatCode <> '' then begin
                        journalLine."VAT Bus. Posting Group" := vatCode;
                        journalLine."VAT Prod. Posting Group" := 'SPY';
                        journalLine."Gen. Bus. Posting Group" := vatCode;
                        journalLine."Gen. Prod. Posting Group" := 'SPY';
                        if (PostingType = 'Sale') then
                            journalLine."Gen. Posting Type" := journalLine."Gen. Posting Type"::Sale;
                        if PostingType = 'Purchase' then
                            journalLine."Gen. Posting Type" := journalLine."Gen. Posting Type"::Purchase;
                    end;
                    journalLine.Validate("VAT Prod. Posting Group");
                    // Set dimensionsId
                    JournalLine."Dimension Set ID" := DM.CreateDimSetIDFromDimBuf(DB);
                    DB.DeleteAll();
                    EntryNo := 1;
                    journalLine.Modify();
                    // Set Sales/Purch without VAT
                    if (journalLine."Account Type" = journalLine."Account Type"::Customer) or
                        (journalLine."Account Type" = journalLine."Account Type"::Vendor) then begin
                        genJournalLine.Reset();
                        genJournalLine.SETRANGE(genJournalLine."Journal Template Name", templateName);
                        genJournalLine.SETRANGE("Journal Batch Name", batchName);
                        genJournalLine.SETFILTER("Document No.", journalLine."Document No.");
                        if genJournalLine.FindSet() then begin
                            UdenMoms := journalLine."Amount (LCY)";
                            repeat
                                UdenMoms := UdenMoms + genJournalLine."VAT Amount (LCY)";
                            until genJournalLine.next = 0;
                        end;
                        journalLine."Sales/Purch. (LCY)" := UdenMoms;
                        journalLine.Modify();
                    end;
                    // Kopier debitor dimensioner ud på alle poster i transaktion
                    if (journalLine."Account Type" = journalLine."Account Type"::Customer) then begin
                        DefDim.Setfilter("Table ID", '18');
                        cust.Reset();
                        cust.SetFilter("No.", deliveryAccount);

                        if (deliveryAccount <> '') AND cust.FindFirst() then
                            DefDim.SetFilter("No.", deliveryAccount)
                        else
                            DefDim.SetFilter("No.", journalLine."Account No.");
                        if DefDim.FindSet() then begin
                            EntryNo := 1;
                            repeat
                                IF (DefDim."Dimension Code" <> '') AND (DefDim."Dimension Value Code" <> '') then begin
                                    DBDefDim.Reset();
                                    DBDefDim.SetFilter("Dimension Code", DefDim."Dimension Code");
                                    DBDefDim.SetFilter("Dimension Value Code", DefDim."Dimension Value Code");
                                    DBDefDim.SetFilter("Table ID", '81');

                                    if not DBDefDim.FindSet() then begin
                                        DBDefDim.Reset();
                                        DBDefDim.Init();
                                        DBDefDim."Table ID" := 81;
                                        DBDefDim."Entry No." := EntryNo;
                                        EntryNo := EntryNo + 1;
                                        DBDefDim."Dimension Code" := DefDim."Dimension Code";
                                        DBDefDim."Dimension Value Code" := DefDim."Dimension Value Code";
                                        DBDefDim.Insert();
                                    end;
                                end;
                            until DefDim.Next = 0;

                            genJournalLine.Reset();
                            genJournalLine.SETRANGE(genJournalLine."Journal Template Name", templateName);
                            genJournalLine.SETRANGE("Journal Batch Name", batchName);
                            genJournalLine.SETFILTER("Document No.", journalLine."Document No.");
                            if genJournalLine.FindSet() then begin
                                repeat
                                    dse.Reset();
                                    dse.SetFilter("Dimension Set ID", FORMAT(genJournalLine."Dimension Set ID"));
                                    if DSE.FindSet() then begin
                                        repeat
                                            DB.Reset();
                                            DB.Init();
                                            DB."Entry No." := EntryNo;
                                            EntryNo := EntryNo + 1;
                                            DB."Table ID" := 81;
                                            DB."Dimension Code" := dse."Dimension Code";
                                            DB."Dimension Value Code" := dse."Dimension Value Code";
                                            DB.Insert();
                                        until dse.Next = 0;
                                    end;
                                    IF DBDefDim.FindSet() then begin
                                        repeat
                                            DB.Reset();
                                            DB.Init();
                                            DB."Entry No." := EntryNo;
                                            EntryNo := EntryNo + 1;
                                            DB."Table ID" := 81;
                                            DB."Dimension Code" := DBDefDim."Dimension Code";
                                            DB."Dimension Value Code" := DBDefDim."Dimension Value Code";
                                            DB.Insert();
                                        until DBDefDim.next = 0;
                                    end;
                                    genJournalLine."Dimension Set ID" := DM.CreateDimSetIDFromDimBuf(DB);
                                    genJournalLine.Modify();
                                    DB.DeleteAll();
                                until genJournalLine.next = 0;
                                DBDefDim.DeleteAll();
                            end;
                        end;
                    end;
                    // Set global dimensioner
                    genJournalLine.Reset();
                    genJournalLine.SETRANGE(genJournalLine."Journal Template Name", templateName);
                    genJournalLine.SETRANGE("Journal Batch Name", batchName);
                    genJournalLine.SETFILTER("Document No.", journalLine."Document No.");
                    if genJournalLine.FindSet() then begin
                        repeat
                            dm.UpdateGlobalDimFromDimSetID(genJournalLine."Dimension Set ID", genJournalLine."Shortcut Dimension 1 Code", genJournalLine."Shortcut Dimension 2 Code");
                            // if (GlobalDim1 <> '') then begin
                            //     DSE.Reset();
                            //     DSE.SetFilter("Dimension Set ID", FORMAT(genJournalLine."Dimension Set ID"));
                            //     DSE.SetFilter("Dimension Code", GlobalDim1);
                            //     if DSE.FindSet() then begin
                            //         genJournalLine."Shortcut Dimension 1 Code" := DSE."Dimension Value Code";
                            //     end;
                            // end;
                            // if (GlobalDim2 <> '') then begin
                            //     DSE.Reset();
                            //     DSE.SetFilter("Dimension Set ID", FORMAT(genJournalLine."Dimension Set ID"));
                            //     DSE.SetFilter("Dimension Code", GlobalDim2);
                            //     if DSE.FindSet() then begin
                            //         genJournalLine."Shortcut Dimension 2 Code" := DSE."Dimension Value Code";
                            //     end;
                            // end;
                            genJournalLine.Modify();
                        until genJournalLine.next = 0;
                    end;
                end;
            }
        }
    }

    trigger OnPostXmlPort()
    var

    begin
    end;

    trigger OnPreXmlPort()
    var

    begin
        EntryNo := 1;
        journalLine.LockTable(true);
        // if GL.FindSet() then begin
        //     GlobalDim1 := GL."Global Dimension 1 Code";
        //     GlobalDim2 := GL."Global Dimension 2 Code";
        // end;
    end;


    var
        MyTableRef: RecordRef;
        MyFldRef: FieldRef;
        BankAccount: record "Bank Account";
        PostingGroup: record "Bank Account Posting Group";
        templateName: code[20];
        batchName: code[20];
        genJournalLine: Record "Gen. Journal Line";
        JournalVoucher: record "Gen. Journal Line";
        genJournalTemplate: Record "Gen. Journal Template";
        genJournalBatch: Record "Gen. Journal Batch";
        DB: Record "Dimension Buffer" temporary;
        DBDefDim: Record "Dimension Buffer" temporary;
        DSE: Record "Dimension Set Entry";
        DV: Record "Dimension Value";
        Dim: Record Dimension;
        DM: Codeunit DimensionManagement;
        Cust: record Customer;
        DefDim: record "Default Dimension";
        EntryNo: Integer;
        StateTax: Text[20];
        GlobalDim1: Code[20];
        GlobalDim2: Code[20];
        GL: record "General Ledger Setup";
        UdenMoms: Decimal;
        Voucher: code[10];
        DimId: Integer;
        PostingType: text;
}