table 50004 "Import Recettes Commerciales"
{

    fields
    {
        field(1;"Entry No.";Integer)
        {
        }
        field(2;COD710;Code[12])
        {
        }
        field(3;DAT710;Date)
        {
        }
        field(4;JOR710;Code[20])
        {
        }
        field(5;BOR710;Code[20])
        {
        }
        field(6;CPD710;Code[20])
        {
        }
        field(7;SCD710;Code[4])
        {
        }
        field(8;CPC710;Code[20])
        {
        }
        field(9;SCC710;Code[20])
        {
        }
        field(10;LIB710;Text[50])
        {
        }
        field(11;NPI710;Code[20])
        {
        }
        field(12;ELT710;Code[20])
        {
        }
        field(13;MTD710;Decimal)
        {
        }
        field(14;MTC710;Decimal)
        {
        }
        field(15;DVD710;Decimal)
        {
        }
        field(16;DVC710;Decimal)
        {
        }
        field(17;MON710;Code[20])
        {
        }
        field(18;TAU710;Decimal)
        {
        }
        field(50;"Imported Date";Date)
        {
        }
        field(51;"Import Type";Option)
        {
            OptionMembers = "Vente Passagers",Ajustement,Remboursements,"RAS Transp PAX Cargo","Factu PAX CE","RAS débit","RAS Emission";
        }
    }

    keys
    {
        key(Key1;"Entry No.")
        {
        }
        key(Key2;MTD710,MTC710)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        L_Rec: Record "Import Recettes Commerciales";
    begin
        if "Entry No." = 0 then begin
          L_Rec.Reset;
          if L_Rec.FindLast then
            "Entry No." := L_Rec."Entry No." + 1
          else "Entry No." := 1;
        end;
    end;
}

