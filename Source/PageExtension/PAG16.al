pageextension 50003 pageextension70000047 extends "Chart of Accounts"
{
    Editable = false;
    actions
    {
        addafter("Dimensions")
        {
            action("<Etat lettrage des écritures>")
            {
                Caption = 'Etat lettrage des écritures';
                Image = "Report";
                RunObject = Report 50186;
                ShortCutKey = 'Shift+F11';
                ApplicationArea = All;
            }
            action(AutoReconciliation)
            {
                Caption = 'Lettrage automatique';
                Image = Reconcile;
                ApplicationArea = All;

                trigger OnAction()
                var
                    "XMLPort": XMLport "50082";
                begin
                    XMLPort.SetAccount(Rec."No.");//**********************************
                    XMLPort.RUN;//**********************************
                end;
            }
        }
        addafter(IndentChartOfAccounts)
        {
            action("Vérification heure")
            {
                Caption = 'Vérification heure';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    MESSAGE(Text001, CREATEDATETIME(TODAY, TIME));
                end;
            }
        }
    }

    var
        Text001: Label 'Heure detéctée %1';
}

