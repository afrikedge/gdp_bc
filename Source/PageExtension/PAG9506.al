// pageextension 50077 pageextension70000149 extends "Session List" 
// {
//     actions
//     {
//         addfirst(Session)
//         {
//             action(KillSession)
//             {
//                 Caption = 'Kill the session';
//                 Image = Delete;
//                 Promoted = true;
//                 PromotedCategory = Process;
//                 PromotedIsBig = true;

//                 trigger OnAction()
//                 begin
//                     //****************************
//                     IF CONFIRM (Text001) THEN
//                        STOPSESSION("Session ID");
//                     //****************************
//                 end;
//             }
//         }
//     }

//     var
//         Text001: Label 'Do you want to kill the session ?';
// }

