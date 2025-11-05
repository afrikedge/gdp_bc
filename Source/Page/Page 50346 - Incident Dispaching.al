page 50346 "Incident Dispaching"
{
    Caption = 'Nouvel Incident';
    LinksAllowed = false;
    ShowFilter = false;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            group("Général")
            {
                field(IncidentType; IncidentType)
                {
                    Caption = 'Type incident';
                    ColumnSpan = 1;

                    trigger OnValidate()
                    begin
                        RefreshControls;
                    end;
                }
                field(Reason; Reason)
                {
                    Caption = 'Motif';
                    ColumnSpan = 1;
                    Visible = false;
                }
                field(TypeMotif; TypeMotif)
                {
                    Caption = 'Type motif';

                    trigger OnValidate()
                    begin
                        CodeMotif := '';
                    end;
                }
                field(CodeMotif; CodeMotif)
                {
                    Caption = 'Code motif';
                    ShowMandatory = true;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        IncidentReason: Record "Dispaching Incident Type";
                    begin
                        IncidentReason.SetRange(IncidentReason."Incident Type", TypeMotif);
                        if PAGE.RunModal(PAGE::"Dispaching Incident Types", IncidentReason) = ACTION::LookupOK then
                            CodeMotif := IncidentReason."Incident Code";
                    end;
                }
                field(AnnulerBon; AnnulerBon)
                {
                    Caption = 'Annuler le bon';
                    Editable = BtnAnnulerIsActivated;
                    Enabled = BtnAnnulerIsActivated;
                }
                field(Comments; Comments)
                {
                    Caption = 'Observations';
                    ColumnSpan = 1;
                    MultiLine = true;
                }
            }
            group("Nouveau chauffeur")
            {
                Visible = IsNewChauffeur;
                field(nomchauffeur; nomchauffeur)
                {
                    Caption = 'Nom du chauffeur';
                }
                field(permis; permis)
                {
                    Caption = 'N° Permis';
                }
                field(nomTransporteur; nomTransporteur)
                {
                    Caption = 'Nom transporteur';
                }
            }
            group("Nouvelle commande")
            {
                Visible = IsNewOrder;
                field(NewOrderNo; NewOrderNo)
                {
                    Caption = 'Nouvelle commande';
                    TableRelation = "Sales Header"."No." WHERE("Document Type" = CONST(Order),
                                                                "Delivery Status" = FILTER(AttenteOrdreLiv | PartiellementLivree | PartiellementFacturee),
                                                                "Shipment Method Code" = CONST('TRP'));
                }
            }
            group("Nouveau camion")
            {
                Visible = IsNewTruck;
                field(NewTruckId; NewTruckId)
                {
                    Caption = 'Nouveau camion';
                    TableRelation = pro_moyentransport WHERE(disponible = CONST(true));
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Valider)
            {
                Caption = 'Valider';
                Image = Post;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ApplicationArea = All;

                trigger OnAction()
                var
                    EnteteBE: Record pro_enteteBE;
                begin
                    if AnnulerBon then
                        if not Confirm(Text001) then exit;

                    InsertIncident;

                    if AnnulerBon then begin
                        EnteteBE.Get(IdBE);
                        if EnteteBE.isconfirme then
                            Error(Text002);
                        LogistiqMgt.CancelBE(EnteteBE);
                    end;

                    if IncidentType = IncidentType::"Changement de chauffeur" then begin
                        EnteteBE.Get(IdBE);
                        EnteteBE.Validate(nomchauffeur, nomchauffeur);
                        EnteteBE.Validate(nomTransporteur, nomTransporteur);
                        EnteteBE.Validate(permis, permis);
                        EnteteBE.ValidatedByManager := false;
                        EnteteBE.Modify;
                    end else begin
                        EnteteBE.Get(IdBE);
                        EnteteBE.ValidatedByManager := false;
                        EnteteBE.Modify;
                    end;
                    ;

                    CurrPage.Close;
                    if not IsRefreshedOnCurr then
                        RefreshEsc();
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        RefreshControls;
    end;

    var
        IncidentType: Option "Déviation","Changement de camion","Changement de chauffeur",Autre;
        Reason: Text[50];
        Comments: Text[50];
        nomchauffeur: Text[50];
        permis: Text[50];
        nomTransporteur: Text[50];
        IsNewChauffeur: Boolean;
        AnnulerBon: Boolean;
        BtnAnnulerIsActivated: Boolean;
        IsNewOrder: Boolean;
        NewOrderNo: Code[20];
        NewTruckId: Code[30];
        IsNewTruck: Boolean;
        IdBE: Integer;
        Text001: Label 'Le bon sera annulé. Voulez-vous continuer ?';
        LogistiqMgt: Codeunit "Logistique Mgt";
        PageBon: Page "Bon Order (Dispaching)";
        IsRefreshedOnCurr: Boolean;
        Text002: Label 'Impossible d''annuler ce bon car l''enlèvement a déjà été confirmé';
        TypeMotif: Option Camion,Chauffeur,Commande,Dispatcheur,Autres;
        CodeMotif: Code[20];
        Text003: Label 'Vous devez saisir un Code motif  !';

    local procedure RefreshControls()
    begin
        IsNewChauffeur := IncidentType = IncidentType::"Changement de chauffeur";
        BtnAnnulerIsActivated := ((IncidentType = IncidentType::Autre) or (IncidentType = IncidentType::"Changement de camion"));
        AnnulerBon := ((IncidentType = IncidentType::"Déviation") or (IncidentType = IncidentType::"Changement de camion"));
        IsNewOrder := IncidentType = IncidentType::"Déviation";
        IsNewTruck := IncidentType = IncidentType::"Changement de camion";
    end;

    local procedure InsertIncident()
    var
        Incident: Record "Dispaching Incident";
        NextEntryId: Integer;
    begin

        Incident.Reset;
        if Incident.FindLast then
            NextEntryId := Incident.EntryId + 1
        else
            NextEntryId := 1;

        Incident.Reset;
        Incident.Init;
        Incident.AnnulerBon := AnnulerBon;
        Incident.Comments := Comments;
        Incident."Creation Date" := Today;
        Incident."User ID" := UserId;
        Incident.IdRef := IdBE;
        Incident.EntryId := NextEntryId;
        Incident.NewOrderNo := NewOrderNo;
        Incident.NewTruckId := NewTruckId;
        Incident.nomchauffeur := nomchauffeur;
        Incident.nomTransporteur := nomTransporteur;
        Incident.Reason := Reason;
        Incident.Comments := Comments;
        Incident.IncidentType := IncidentType;
        Incident.permis := permis;
        Incident.Posted := true;
        Incident."Reason Type" := TypeMotif;
        Incident."Reason Code" := CodeMotif;
        if (CodeMotif = '') then
            Error(Text003);
        Incident.Insert;
    end;

    procedure SetIdBE(idBe1: Integer)
    begin
        IdBE := idBe1;
    end;

    procedure SetPageBon(PageBon1: Page "Bon Order (Dispaching)")
    begin
        //PageBon:=PageBon1;
    end;

    local procedure RefreshEsc()
    var
    // WshShell: Automation BC;
    begin
        // if IsClear(WshShell) then
        //   Create(WshShell,true,true);
        // WshShell.SendKeys('{ESC}');
        // IsRefreshedOnCurr:=true;
    end;
}

