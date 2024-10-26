// pageextension 70000032 pageextension70000032 extends "Posted Sales Invoice" 
// {
//     Editable = false;

//     layout
//     {

//         modify("Control 30")
//         {
//             Visible = false;
//         }
//         modify("Control 1907468901")
//         {
//             Visible = false;
//         }
//         addafter("Control 92")
//         {
//             field("Currency Code";"Currency Code")
//             {
//                 Importance = Promoted;

//                 trigger OnAssistEdit()
//                 begin
//                     ChangeExchangeRate.SetParameter("Currency Code","Currency Factor","Posting Date");
//                     ChangeExchangeRate.EDITABLE(FALSE);
//                     IF ChangeExchangeRate.RUNMODAL = ACTION::OK THEN BEGIN
//                       "Currency Factor" := ChangeExchangeRate.GetParameter;
//                       MODIFY;
//                     END;
//                     CLEAR(ChangeExchangeRate);
//                 end;
//             }
//             field(Observations;Observations)
//             {
//                 Editable = false;
//                 MultiLine = true;
//             }
//         }
//         addafter("Control 75")
//         {
//             field("JIRAMA Invoice No.";"JIRAMA Invoice No.")
//             {
//                 Editable = false;
//             }
//             field("AMSA Cost Code";"AMSA Cost Code")
//             {
//                 Editable = false;
//             }
//             field("JIRAMA Order Ref.";"JIRAMA Order Ref.")
//             {
//                 Editable = false;
//             }
//         }
//     }
//     actions
//     {
//         modify(Print)
//         {
//             PromotedIsBig = true;
//         }

//         //Unsupported feature: Property Modification (Level) on "IncomingDocCard(Action 21)".


//         //Unsupported feature: Property Modification (Level) on "SelectIncomingDoc(Action 19)".


//         //Unsupported feature: Property Modification (Level) on "IncomingDocAttachFile(Action 17)".

//         modify("Action 171")
//         {
//             Visible = false;
//         }


//         //Unsupported feature: Code Modification on "Print(Action 58).OnAction".

//         //trigger OnAction()
//         //Parameters and return type have not been exported.
//         //>>>> ORIGINAL CODE:
//         //begin
//             /*
//             SalesInvHeader := Rec;
//             CurrPage.SETSELECTIONFILTER(SalesInvHeader);
//             SalesInvHeader.PrintRecords(TRUE);
//             */
//         //end;
//         //>>>> MODIFIED CODE:
//         //begin
//             /*
//             //Print on preprint
//             {
//             #1..3
//             }
//             IF Cdemgt.IsFactureEnregLub(Rec) THEN
//               AFK_CReportsMgt.PrintFactureVenteLubs(Rec."No.")
//             ELSE
//               AFK_CReportsMgt.PrintFactureVente(Rec."No.");
//             */
//         //end;
//         modify(IncomingDocument)
//         {
//             Visible = false;
//         }
//         addafter(Dimensions)
//         {
//             action(SuiviEtapesValidation)
//             {
//                 Caption = 'Validation Step Lines';
//                 Image = History;
//                 Promoted = true;
//                 PromotedCategory = Category4;
//                 RunObject = Page 50275;
//                 RunPageLink = Document Type=CONST(Sales Order),
//                               Document No.=FIELD(Order No.);
//             }
//         }
//         addafter(Print)
//         {
//             action("&Print")
//             {
//                 Caption = '&Print';
//                 Ellipsis = true;
//                 Image = PrintAcknowledgement;
//                 Promoted = true;
//                 PromotedCategory = Process;
//                 PromotedIsBig = true;

//                 trigger OnAction()
//                 var
//                     SalesInvHeader: Record "112";
//                 begin
//                     /*
//                     SalesInvHeader := Rec;
//                     CurrPage.SETSELECTIONFILTER(SalesInvHeader);
//                     SalesInvHeader.PrintRecords(TRUE);
//                     */
//                     AFK_CReportsMgt.PrintNoteDebit_Facture(Rec."No.");

//                 end;
//             }
//         }
//         addafter("Action 59")
//         {
//             action(ImprimerFactureJIRAMA)
//             {
//                 Caption = 'Print JIRAMA Invoice';
//                 Image = PrintCover;
//                 Promoted = true;
//                 PromotedCategory = Process;
//                 PromotedIsBig = true;

//                 trigger OnAction()
//                 var
//                     SalesFilter: Record "112";
//                 begin
//                     //**********************************************************************
//                     SalesFilter.SETRANGE("No.",Rec."No.");
//                     REPORT.RUN(REPORT::"JIRAMA Sales  Invoice",TRUE,FALSE,SalesFilter);
//                     //**********************************************************************
//                 end;
//             }
//         }
//     }

//     var
//         AFK_CReportsMgt: Codeunit "50027";
//         Cdemgt: Codeunit "50001";


//     //Unsupported feature: Code Modification on "OnOpenPage".

//     //trigger OnOpenPage()
//     //>>>> ORIGINAL CODE:
//     //begin
//         /*
//         SetSecurityFilterOnRespCenter;
//         CRMIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled;

//         IsOfficeAddin := OfficeMgt.IsAvailable;
//         IsFoundationEnabled := ApplicationAreaMgmtFacade.IsFoundationEnabled;

//         ActivateFields;
//         PaymentServiceVisible := PaymentServiceSetup.IsPaymentServiceVisible;
//         */
//     //end;
//     //>>>> MODIFIED CODE:
//     //begin
//         /*
//         //SetSecurityFilterOnRespCenter;//JN Commented Afrikedge Filtre sur la liste
//         #2..8
//         */
//     //end;
// }

