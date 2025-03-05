// report 50026 "ND/NC MT After Post"
// {
//     DefaultLayout = RDLC;
//     RDLCLayout = './Source/Report/Layout/NDNC MT After Post.rdlc';
//     Caption = 'Debit-Credit Note';
//     PreviewMode = PrintLayout;

//     dataset
//     {
//         dataitem("Posted Moneytech Import";"Posted Moneytech Import")
//         {
//             RequestFilterFields = "No.";
//             dataitem(StationCode;"Integer")
//             {
//                 column(EMailCaption;EMailCaptionLbl)
//                 {
//                 }
//                 column(PhoneNoCaption;PhoneNoCaptionLbl)
//                 {
//                 }
//                 column(FaxCaption;FaxCaptionLbl)
//                 {
//                 }
//                 column(UnitPriceCaption;UnitPriceCaptionLbl)
//                 {
//                 }
//                 column(AmtCaption;AmtCaptionLbl)
//                 {
//                 }
//                 column(Desc_Caption;Desc_Caption)
//                 {
//                 }
//                 column(NoCaption;NoCaptionLbl)
//                 {
//                 }
//                 column(No_LineCaption;No_LineCaption)
//                 {
//                 }
//                 column(Quantity_Caption;Quantity_Caption)
//                 {
//                 }
//                 column(UnitofMeasure_Caption;UnitofMeasure_Caption)
//                 {
//                 }
//                 column(MontLetter;MontLetter)
//                 {
//                 }
//                 column(CondTerm;CondTerm)
//                 {
//                 }
//                 column(SalesCatCode;Cust."Sales Channel Code")
//                 {
//                 }
//                 column(StatCode;'STAT : '+Cust."STAT Code")
//                 {
//                 }
//                 column(CIFCIS;'CIS/CIS : ' +Cust."CIF/CIS")
//                 {
//                 }
//                 column(PaymentCond;CondPaieName)
//                 {
//                 }
//                 column(NIF;'NIF : '+Cust."VAT Registration No.")
//                 {
//                 }
//                 column(PostDate;Format("Posted Moneytech Import"."Posting Date"))
//                 {
//                 }
//                 column(Description;Descript)
//                 {
//                 }
//                 column(TotalText;TotalText)
//                 {
//                 }
//                 column(CompanyInfo_Picture;CompanyInfo.Picture)
//                 {
//                 }
//                 column(CustAddr1;CustAddr[1])
//                 {
//                 }
//                 column(CompanyAddr1;CompanyAddr[1])
//                 {
//                 }
//                 column(CustAddr2;CustAddr[2])
//                 {
//                 }
//                 column(CompanyAddr2;CompanyAddr[2])
//                 {
//                 }
//                 column(CustAddr3;CustAddr[3])
//                 {
//                 }
//                 column(CompanyAddr3;CompanyAddr[3])
//                 {
//                 }
//                 column(CustAddr4;CustAddr[4])
//                 {
//                 }
//                 column(CompanyAddr4;CompanyAddr[4])
//                 {
//                 }
//                 column(CustAddr5;CustAddr[5])
//                 {
//                 }
//                 column(CustAddr6;CustAddr[6])
//                 {
//                 }
//                 column(VATNoText;VATNoText)
//                 {
//                 }
//                 column(CompanyInfoEMail;CompanyInfo."E-Mail")
//                 {
//                 }
//                 column(CompanyInfoRCS;' - R.C.S. : '+ CompanyInfo."Trade Register")
//                 {
//                 }
//                 column(CompanyInfoCA;'S.A. au capital de AR '+CompanyInfo."Stock Capital")
//                 {
//                 }
//                 column(CompanyInfoNIF;'NIF : '+CompanyInfo."Registration No.")
//                 {
//                 }
//                 column(CompanyInfoSTAT;'STAT : ' +CompanyInfo."Legal Form")
//                 {
//                 }
//                 column(CompanyInfoPhoneNo;CompanyInfo."Phone No.")
//                 {
//                 }
//                 column(CompanyInfoFax;CompanyInfo."Fax No.")
//                 {
//                 }
//                 column(RespCent;Cust."Responsibility Center")
//                 {
//                 }
//                 column(LineNumber;StationCode.Number)
//                 {
//                 }
//                 column(CustomerNo;QStationMoneyT.Station_Code)
//                 {
//                 }
//                 column(Transaction_Type;QStationMoneyT.Transaction_Type)
//                 {
//                 }
//                 column(Amount;QStationMoneyT.Sum_Amount)
//                 {
//                 }
//                 column(DocumentNo;QStationMoneyT.Document_No)
//                 {
//                 }
//                 column(CustAddr7;CustAddr[7])
//                 {
//                 }
//                 column(CustAddr8;CustAddr[8])
//                 {
//                 }
//                 column(CompanyAddr5;CompanyAddr[5])
//                 {
//                 }
//                 column(CompanyAddr6;CompanyAddr[6])
//                 {
//                 }
//                 column(OutputNo;OutputNo)
//                 {
//                 }
//                 column(EntryNo;Num)
//                 {
//                 }
//                 column(Fact;Fact)
//                 {
//                 }
//                 column(TotalAmountLetter;Amount_InWords)
//                 {
//                 }
//                 dataitem(StationJr;"Integer")
//                 {
//                     column(Text011;Text011)
//                     {
//                     }
//                     column(ReferenceText;ReferenceText)
//                     {
//                     }
//                     column(JournalCode;CodeJournaux)
//                     {
//                     }
//                     column(JrAmount;QJrIM.Sum_Amount)
//                     {
//                     }
//                     column(JrNo;QJrIM.TransmissionNo)
//                     {
//                     }
//                     column(JrLineNo;QJrIM.LineNo)
//                     {
//                     }

//                     trigger OnAfterGetRecord()
//                     begin
//                         if QJrIM.Read then
//                           CodeJournaux:='JRNL '+Format(QJrIM.TransmissionNo)+ ' DU '+Format("Posted Moneytech Import"."Starting Date");
//                     end;

//                     trigger OnPostDataItem()
//                     begin
//                         QJrIM.Close;
//                         Counter2:=0;
//                     end;

//                     trigger OnPreDataItem()
//                     begin
//                         SetRange(Number,1,Counter2);

//                         QJrIM.SetRange(QJrIM.Document_No,QStationMoneyT.Document_No);
//                         QJrIM.SetRange(QJrIM.Station_Code,QStationMoneyT.Station_Code);
//                         QJrIM.SetRange(Transaction_Type,QStationMoneyT.Transaction_Type);
//                         QJrIM.Open ;
//                     end;
//                 }

//                 trigger OnAfterGetRecord()
//                 begin
//                     if QStationMoneyT.Read then begin
//                       FormatAddr.Company(CompanyAddr,CompanyInfo);
//                       Num:='CAP0001';
//                       TotalText:= 'NET A PAYER';
//                       if QStationMoneyT.Transaction_Type=QStationMoneyT.Transaction_Type::Recharge then begin
//                         Fact:='Note de Débit';
//                         Descript:= 'RECHARGE CARTE A PUCE';
//                       end
//                       else if QStationMoneyT.Transaction_Type=QStationMoneyT.Transaction_Type::Decharge then begin
//                         Fact:='Note de Crédit';
//                         Descript:='CONSOMMATION CARTE A PUCE';
//                       end;

//                       Cust.Get(QStationMoneyT.Station_Code);

//                       FormatAddr.Customer(CustAddr,Cust);

//                       if CondPaiem.Get(Cust."Payment Terms Code") then
//                         CondPaieName:=CondPaiem.Description;

//                       NbTLet.InitTextVariable;
//                       NbTLet.FormatNoTextFR(TotalAmountLetter,Abs(QStationMoneyT.Sum_Amount),'');

//                     QJrIM1.SetRange(Document_No,QStationMoneyT.Document_No);
//                     QJrIM1.SetRange(Station_Code,QStationMoneyT.Station_Code);
//                     QJrIM1.SetRange(Transaction_Type,QStationMoneyT.Transaction_Type);
//                     QJrIM1.Open ;
//                     while QJrIM1.Read do
//                       begin
//                         Counter2+=1;
//                       end;
//                     QJrIM1.Close;

//                     //MESSAGE('Nb Jr %1',QStationMoneyT.Station_Code);
//                     end;
//                 end;

//                 trigger OnPostDataItem()
//                 begin
//                     QStationMoneyT.Close;
//                 end;

//                 trigger OnPreDataItem()
//                 begin
//                     SetRange(Number,1,Counter);
//                     if codeStation<>'' then begin
//                       QStationMoneyT.SetRange(Document_No,"Posted Moneytech Import"."No.");
//                       QStationMoneyT.SetRange(Station_Code,codeStation);
//                       QStationMoneyT.Open ;
//                     end else if codeStation='' then begin
//                       QStationMoneyT.SetFilter(Document_No,"Posted Moneytech Import"."No.");
//                       QStationMoneyT.Open ;
//                     end;
//                     Counter2:=0;
//                 end;
//             }

//             trigger OnAfterGetRecord()
//             begin
//                 if codeStation<>'' then begin
//                   QStationMoneyT1.SetRange(Document_No,"Posted Moneytech Import"."No.");
//                   QStationMoneyT1.SetRange(Station_Code,codeStation);
//                   QStationMoneyT1.Open ;
//                 end else if codeStation='' then begin
//                   QStationMoneyT1.SetFilter(Document_No,"Posted Moneytech Import"."No.");
//                   QStationMoneyT1.Open ;
//                 end;

//                 while QStationMoneyT1.Read do
//                   begin
//                     Counter+=1;
//                   end;
//                 QStationMoneyT1.Close;
//             end;

//             trigger OnPreDataItem()
//             begin
//                 Counter:=0;
//             end;
//         }
//     }

//     requestpage
//     {
//         SaveValues = true;

//         layout
//         {
//             area(content)
//             {
//                 group(Control1000000001)
//                 {
//                     ShowCaption = false;
//                     field(CodeStation;codeStation)
//                     {
//                         Caption = 'Code Station';
//                         DrillDown = true;
//                         Lookup = true;
//                         TableRelation = Customer;
//                     }
//                 }
//             }
//         }

//         actions
//         {
//         }

//         trigger OnInit()
//         begin
//             LogInteractionEnable := true;
//         end;

//         trigger OnOpenPage()
//         begin
//             InitLogInteraction;
//             LogInteractionEnable := LogInteraction;
//         end;
//     }

//     labels
//     {
//         Text3 = 'ACTIVITE';
//         Text4 = 'AGENCE';
//         Text5 = 'DATE';
//         Text6 = 'CLIENT';
//         PrepareBy = 'Préparée par';
//         AutoriseBy = 'Autorisée par';
//         CondPaie = 'Conditions de paiement';
//         Text7 = 'POUR GALANA';
//         Text8 = 'nom :';
//         Text9 = 'date :';
//         Text10 = 'Siège Social';
//     }

//     trigger OnInitReport()
//     begin
//         GLSetup.Get;
//         CompanyInfo.Get;
//         SalesSetup.Get;
//         //CompanyInfo.VerifyAndSetPaymentInfo;

//         CompanyInfo.CalcFields(Picture);
//     end;

//     trigger OnPreReport()
//     begin

//         if not CurrReport.UseRequestPage then

//           InitLogInteraction;

//         //IF "Cust. Ledger Entry".GETFILTER("External Document No.") = '' THEN
//         //  ERROR(Text005);
//     end;

//     var
//         Text000: Label 'Salesperson';
//         Text001: Label 'Total %1';
//         Text002: Label 'Total %1 Incl. VAT';
//         Text003: Label 'COPY';
//         Text004: Label 'Sales - Invoice %1';
//         PageCaptionCap: Label 'Page %1 of %2';
//         Text006: Label 'Total %1 Excl. VAT';
//         GLSetup: Record "General Ledger Setup";
//         ShipmentMethod: Record "Shipment Method";
//         PaymentTerms: Record "Payment Terms";
//         SalesPurchPerson: Record "Salesperson/Purchaser";
//         CompanyInfo: Record "Company Information";
//         SalesSetup: Record "Sales & Receivables Setup";
//         Cust: Record Customer;
//         TempLineFeeNoteOnReportHist: Record "Line Fee Note on Report Hist." temporary;
//         FormatAddr: Codeunit "Format Address";
//         SegManagement: Codeunit SegManagement;
//         CustAddr: array [8] of Text[50];
//         ShipToAddr: array [8] of Text[50];
//         CompanyAddr: array [8] of Text[50];
//         OrderNoText: Text[80];
//         SalesPersonText: Text[30];
//         VATNoText: Text[80];
//         ReferenceText: Text[80];
//         TotalText: Text[50];
//         MoreLines: Boolean;
//         CopyText: Text[30];
//         i: Integer;
//         NextEntryNo: Integer;
//         FirstValueEntryNo: Integer;
//         DimText: Text[120];
//         OldDimText: Text[75];
//         ShowInternalInfo: Boolean;
//         Continue: Boolean;
//         LogInteraction: Boolean;
//         Text007: Label 'VAT Amount Specification in ';
//         Text008: Label 'Local Currency';
//         Text009: Label 'Exchange rate: %1/%2';
//         Text010: Label 'Sales - Prepayment Invoice %1';
//         OutputNo: Integer;
//         TotalSubTotal: Decimal;
//         TotalAmount: Decimal;
//         TotalAmountInclVAT: Decimal;
//         TotalAmountVAT: Decimal;
//         [InDataSet]
//         LogInteractionEnable: Boolean;
//         DisplayAssemblyInformation: Boolean;
//         NoCaptionLbl: Label 'Invoice No.';
//         UnitPriceCaptionLbl: Label 'Unit Price';
//         AmtCaptionLbl: Label 'Amount';
//         PostedShpDateCaptionLbl: Label 'Posted Shipment Date';
//         InvDiscAmtCaptionLbl: Label 'Inv. Discount Amount';
//         TotalCaptionLbl: Label 'Total';
//         ShiptoAddrCaptionLbl: Label 'Ship-to Address';
//         PmtTermsDescCaptionLbl: Label 'Payment Terms';
//         DisplayAdditionalFeeNote: Boolean;
//         CondTerm: Label 'Subtotal';
//         MontLetter: Label 'Arrêté le présent document à la somme de :   ';
//         OrderNoCaptionLbl: Label 'Order No.';
//         Location: Record Location;
//         LocationName: Text[100];
//         Desc_Caption: Label 'DESIGNATION';
//         No_LineCaption: Label 'REFERENCE';
//         UnitofMeasure_Caption: Label 'UNITE';
//         Quantity_Caption: Label 'QUANTITE';
//         NbTLet: Report Check;
//         TotalAmountLetter: array [2] of Text[150];
//         PhoneNoCaptionLbl: Label 'Phone No.';
//         EMailCaptionLbl: Label 'E-Mail';
//         FaxCaptionLbl: Label 'Fax : ';
//         CondPaieName: Text[50];
//         Fact: Text[30];
//         Descript: Text[50];
//         Text005: Label 'Vous devez renseigner le numéro de document externe';
//         Num: Text[20];
//         QStationMoneyT: Query "Regroup Station IM Posted";
//         CondPaiem: Record "Payment Terms";
//         Counter: Integer;
//         QStationMoneyT1: Query "Regroup Station IM Posted";
//         CodeJournaux: Text[300];
//         Text011: Label 'Code Journaux';
//         QJrIM: Query "Regroup Station Jr IM Posted";
//         Counter2: Integer;
//         QJrIM1: Query "Regroup Station Jr IM Posted";
//         codeStation: Code[10];
//         TypeTransaction: Text[10];

//     procedure InitLogInteraction()
//     begin
//         LogInteraction := SegManagement.FindInteractTmplCode(4) <> '';
//     end;

//     procedure InitializeRequest(NewNoOfCopies: Integer;NewShowInternalInfo: Boolean;NewLogInteraction: Boolean;IncludeShptNo: Boolean;DisplAsmInfo: Boolean)
//     begin
//         ShowInternalInfo := NewShowInternalInfo;
//         LogInteraction := NewLogInteraction;
//         IncludeShptNo := IncludeShptNo;
//         DisplayAssemblyInformation := DisplAsmInfo;
//     end;
// }

