table 50001 "AddOn Setup2"
{

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; PGPExeFileTempPath; Text[100])
        {
            Caption = 'Chemin fichier temporaire pgp';
        }
        field(3; ActivateDispachingLogging; Boolean)
        {
            Caption = 'Activer le logging sur le dispaching';
        }
        field(4; "Vendor Inv Doc Series"; Code[20])
        {
            Caption = 'Nos Ref Factures Fournisseur';
            TableRelation = "No. Series".Code;
        }
        field(5; "Activate Vend Payments Process"; Boolean)
        {
            Caption = 'Do not allow payment of non validated invoices';
        }
        field(6; "User DAF"; Code[50])
        {
            Caption = 'Code utilisateur DFI';
            TableRelation = "User Setup"."User ID";
        }
        field(7; "Interim User DAF"; Code[50])
        {
            Caption = 'Intérimaire DFI';
            TableRelation = "User Setup"."User ID";
        }
        field(8; "Activate Interim DAF"; Boolean)
        {
            Caption = 'Intérim DFI activé';
        }
        field(9; "Email Vend Invoice Refusal"; Text[80])
        {
            Caption = 'Email pour les refus de validation factures fournisseur';
        }
        field(10; "Desactiver Controle Camion"; Boolean)
        {
            Caption = 'Désactiver controle camion sur BU';
        }
        field(11; "Email Avis Paiement"; Text[80])
        {
            Caption = 'Email pour copie avis de paiement fsseur';
        }
        field(12; "Fee Redevance VAT%"; Decimal)
        {
            Caption = 'Fee Redevance VAT%';
        }
        field(13; "Activate Jirama Site UP"; Boolean)
        {
            Caption = 'Activate Jirama site unit price';
        }
        field(14; "Email CC Relance"; Text[80])
        {
            Caption = 'Email CC pour relances clients';
        }
        field(15; "Def Prepmt. Payment Terms Code"; Code[10])
        {
            Caption = 'Prepmt. Payment Terms Code';
            TableRelation = "Payment Terms";
        }
        field(16; "Galitt NC Gerant Prepaid"; Code[20])
        {
            Caption = 'Prepaid Credit Note Gerant Account Galitt';
            TableRelation = "G/L Account" WHERE("Account Type" = CONST(Posting));
        }
        field(17; "Galitt ND Gerant Prepaid"; Code[20])
        {
            Caption = 'Galitt PrepaiDebit Note Gerant Account';
            TableRelation = "G/L Account" WHERE("Account Type" = CONST(Posting));
        }
        field(18; "Galitt NC Gerant Postpaid"; Code[20])
        {
            Caption = 'Galitt Postpaid Credit Note Gerant Account';
            TableRelation = "G/L Account" WHERE("Account Type" = CONST(Posting));
        }
        field(19; "Galitt ND Gerant Postpaid"; Code[20])
        {
            Caption = 'Galitt Postpaid Debit Note Gerant Account';
            TableRelation = "G/L Account" WHERE("Account Type" = CONST(Posting));
        }
        field(20; "Galitt NC Gerant GPRO"; Code[20])
        {
            Caption = 'Galitt GPRO Credit Note Gerant Account';
            TableRelation = "G/L Account" WHERE("Account Type" = CONST(Posting));
        }
        field(21; "Galitt ND Gerant GPRO"; Code[20])
        {
            Caption = 'Galitt GPRO Debit Note Gerant Account';
            TableRelation = "G/L Account" WHERE("Account Type" = CONST(Posting));
        }
        field(22; "Desactivate Provisions Ctrl"; Boolean)
        {
            Caption = 'Désactiver le contrôle des provisions';
        }
        field(23; "Galitt Facture Mensue Postpaid"; Code[20])
        {
            Caption = 'Compte factures mensuelles PostPaid Galitt';
            TableRelation = "G/L Account" WHERE("Account Type" = CONST(Posting));
        }
        field(24; "Supplier blocking period Month"; Integer)
        {
            Caption = 'Délai de blocage fsseurs dormants (Mois)';
        }
        field(25; "Block zero unit cost"; Boolean)
        {
            Caption = 'Bloquer les transactions avec cout nul';
        }
        field(26; "Galitt Fact Men Postpaid GPRO"; Code[20])
        {
            Caption = 'Compte factures mensuelles PostPaid Galitt GPRO';
            TableRelation = "G/L Account" WHERE("Account Type" = CONST(Posting));
        }
        field(27; "Cust Revision Nos Series"; Code[20])
        {
            Caption = 'Nos Demandes revision client';
            TableRelation = "No. Series".Code;
        }
        field(28; "Lead Nos Series"; Code[20])
        {
            Caption = 'Nos Prospects';
            TableRelation = "No. Series".Code;
        }

        field(29; "Operation Cust Templ"; Code[20])
        {
            Caption = 'Operation Cust template';
            TableRelation = "Customer Templ.".Code;
        }
        field(30; "Company Cust Templ"; Code[20])
        {
            Caption = 'Company Cust Templ';
            TableRelation = "Customer Templ.".Code;
        }
        field(31; "Holding Cust Templ"; Code[20])
        {
            Caption = 'Holding Cust Templ';
            TableRelation = "Customer Templ.".Code;
        }
        field(32; "Activate Email Service"; Boolean)
        {
            Caption = 'Activer service Emails';
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
        }
    }

    fieldgroups
    {
    }

    local procedure CheckGLAcc(AccNo: Code[20])
    var
        GLAcc: Record "G/L Account";
    begin
        if AccNo <> '' then begin
            GLAcc.Get(AccNo);
            GLAcc.CheckGLAcc;
        end;
    end;
}

