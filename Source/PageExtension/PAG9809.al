// pageextension 50077 pageextension70000154 extends "Change Password" 
// {
//     var
//         Text003: Label 'The passwords that you entered do not match.';
//         AddOnSetup: Record "50000";


//     //Unsupported feature: Code Modification on "OnQueryClosePage".

//     //trigger OnQueryClosePage(CloseAction: Action): Boolean
//     //>>>> ORIGINAL CODE:
//     //begin
//         /*
//         IF CloseAction = ACTION::OK THEN BEGIN
//           IF SetPassword <> ConfirmPassword THEN
//             ERROR(Text001);
//           IF IdentityManagement.ValidatePasswordStrength(SetPassword) THEN BEGIN
//             CHANGEUSERPASSWORD(OldPassword,SetPassword);
//           END ELSE
//             ERROR(Text002);
//         END;
//         */
//     //end;
//     //>>>> MODIFIED CODE:
//     //begin
//         /*
//         AddOnSetup.GET;//*******************************

//         IF CloseAction = ACTION::OK THEN BEGIN

//           IF SetPassword <> ConfirmPassword THEN
//             ERROR(Text001);
//           //*******************************
//           IF AddOnSetup."Pwd Expiration (Days)">0 THEN
//             IF OldPassword=SetPassword THEN
//               ERROR(Text003);
//           //*******************************
//           IF IdentityManagement.ValidatePasswordStrength(SetPassword) THEN BEGIN
//             CHANGEUSERPASSWORD(OldPassword,SetPassword);
//             SetPwdChange;//*********************************Added
//           END ELSE
//             ERROR(Text002);

//         END;
//         */
//     //end;

//     local procedure SetPwdChange()
//     var
//         UserPro1: Record "2000000121";
//     begin
//         //*************************************
//         UserPro1.RESET;
//         UserPro1.SETRANGE("User Security ID","User Security ID");
//         IF UserPro1.FINDFIRST THEN BEGIN
//           UserPro1."Pwd Modified Date" := CREATEDATETIME(TODAY,TIME);
//           UserPro1."Modify Password" := FALSE;
//           UserPro1.MODIFY;
//         END;
//         //*************************************
//     end;
// }

