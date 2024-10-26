// pageextension 70000034 pageextension70000034 extends "Posted Sales Credit Memo" 
// {
//     Editable = false;

//     //Unsupported feature: Property Insertion (DeleteAllowed) on ""Posted Sales Credit Memo"(Page 134)".

//     layout
//     {
//         modify("Control 75")
//         {
//             Visible = false;
//         }
//         addafter("Control 80")
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
//         }
//         addafter("Control 18")
//         {
//             field(Observations;Observations)
//             {
//                 Editable = false;
//                 MultiLine = true;
//             }
//         }
//     }
//     actions
//     {


//         //Unsupported feature: Code Modification on "Print(Action 50).OnAction".

//         //trigger OnAction()
//         //Parameters and return type have not been exported.
//         //>>>> ORIGINAL CODE:
//         //begin
//             /*
//             SalesCrMemoHeader := Rec;
//             CurrPage.SETSELECTIONFILTER(SalesCrMemoHeader);
//             SalesCrMemoHeader.PrintRecords(TRUE);
//             */
//         //end;
//         //>>>> MODIFIED CODE:
//         //begin
//             /*

//             {
//             {=======} TARGET
//             SalesCrMemoHeader := Rec;
//             {<<<<<<<}
//             CurrPage.SETSELECTIONFILTER(SalesCrMemoHeader);
//             SalesCrMemoHeader.PrintRecords(TRUE);
//             }
//             //******************************************
//             AFKCReports.PrintNoteCredit_Avoir(Rec."No.");
//             //******************************************
//             */
//         //end;
//         modify(IncomingDocument)
//         {
//             Visible = false;
//         }
//     }

//     var
//         AFKCReports: Codeunit "50027";


//     //Unsupported feature: Code Modification on "OnOpenPage".

//     //trigger OnOpenPage()
//     //>>>> ORIGINAL CODE:
//     //begin
//         /*
//         SetSecurityFilterOnRespCenter;
//         IsOfficeAddin := OfficeMgt.IsAvailable;
//         IsFoundationEnabled := ApplicationAreaMgmtFacade.IsFoundationEnabled;

//         ActivateFields;
//         */
//     //end;
//     //>>>> MODIFIED CODE:
//     //begin
//         /*

//         //**************************************
//         //SetSecurityFilterOnRespCenter;

//         #2..5
//         */
//     //end;
// }

