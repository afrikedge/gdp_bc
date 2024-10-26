// pageextension 50063 pageextension70000126 extends "Sales Return Order" 
// {
//     layout
//     {
//         modify("Control 41")
//         {
//             Visible = false;
//         }
//         modify("Control 91")
//         {
//             Visible = false;
//         }
//         modify("Control 100")
//         {
//             Visible = false;
//         }
//         modify("Control 137")
//         {
//             Visible = false;
//         }
//         modify("Control 74")
//         {
//             Visible = false;
//         }
//         modify("Control 78")
//         {
//             Visible = false;
//         }
//         modify("Control 14")
//         {
//             Visible = false;
//         }
//         modify("Control 16")
//         {
//             Visible = false;
//         }
//         modify("Control 94")
//         {
//             Visible = false;
//         }
//         modify("Control 1907468901")
//         {
//             Visible = false;
//         }
//         addafter("Control 2")
//         {
//             field("Sell-to Customer No.";"Sell-to Customer No.")
//             {
//             }
//         }
//         addafter("Control 58")
//         {
//             field("Shortcut Dimension 1 Code";"Shortcut Dimension 1 Code")
//             {
//                 Visible = false;

//                 trigger OnValidate()
//                 begin
//                     ShortcutDimension1CodeOnAfterV;
//                 end;
//             }
//             field("Shortcut Dimension 2 Code";"Shortcut Dimension 2 Code")
//             {
//                 Visible = false;

//                 trigger OnValidate()
//                 begin
//                     ShortcutDimension2CodeOnAfterV;
//                 end;
//             }
//         }
//         addafter("Control 107")
//         {
//             field("Currency Code";"Currency Code")
//             {
//                 Importance = Promoted;

//                 trigger OnAssistEdit()
//                 begin
//                     IF "Posting Date" <> 0D THEN
//                       ChangeExchangeRate.SetParameter("Currency Code","Currency Factor","Posting Date")
//                     ELSE
//                       ChangeExchangeRate.SetParameter("Currency Code","Currency Factor",WORKDATE);
//                     IF ChangeExchangeRate.RUNMODAL = ACTION::OK THEN BEGIN
//                       VALIDATE("Currency Factor",ChangeExchangeRate.GetParameter);
//                       CurrPage.UPDATE;
//                     END;
//                     CLEAR(ChangeExchangeRate);
//                 end;

//                 trigger OnValidate()
//                 begin
//                     CurrPage.UPDATE;
//                     SalesCalcDiscByType.ApplyDefaultInvoiceDiscount(0,Rec);
//                 end;
//             }
//             field("Applies-to Doc. Type";"Applies-to Doc. Type")
//             {
//                 Importance = Promoted;
//             }
//             field("Applies-to Doc. No.";"Applies-to Doc. No.")
//             {
//                 Importance = Promoted;
//             }
//             field("Applies-to ID";"Applies-to ID")
//             {
//             }
//             field("Prices Including VAT";"Prices Including VAT")
//             {
//                 Visible = false;

//                 trigger OnValidate()
//                 begin
//                     PricesIncludingVATOnAfterValid;
//                 end;
//             }
//             field("VAT Bus. Posting Group";"VAT Bus. Posting Group")
//             {
//             }
//             field("Posting Description";"Posting Description")
//             {
//             }
//         }
//     }
// }

