codeunit 50028 "ANSI <-> ASCII converter"
{

    trigger OnRun()
    var
        Slimslam: Text[30];
        Slimslam2: Text[54];
    begin
    end;

    var
        AsciiStr: Text[250];
        AnsiStr: Text[250];
        CharVar: array [32] of Char;

    procedure Ansi2Ascii(_Text: Text[250]): Text[250]
    begin
        MakeVars;
        exit(ConvertStr(_Text,AnsiStr,AsciiStr));
    end;

    procedure Ascii2Ansi(_Text: Text[250]): Text[250]
    begin
        MakeVars;
        exit(ConvertStr(_Text,AsciiStr,AnsiStr));
    end;

    procedure MakeVars()
    begin
        AsciiStr := 'ÇüéâäàåçêëèïîìÄÅÉæÆôöòûùÿÖÜ¢£¥ƒáíóúñÑªº¿¬½¼¡«»¦¦¦¦¦…†‡ˆ¦¦++Ž++--+-+–—++--¦-+';
        AsciiStr := AsciiStr +'Ÿ¨©­®¯i´¸¹++¦_¦ÃØÊßËÌÍÎµÏÐÒÓÔÕ×ØÙÚ±=ÝÞã÷ð°õ·øý²¦ ';
        CharVar[1] := 196;
        CharVar[2] := 197;
        CharVar[3] := 201;
        CharVar[4] := 242;
        CharVar[5] := 220;
        CharVar[6] := 186;
        CharVar[7] := 191;
        CharVar[8] := 188;
        CharVar[9] := 187;
        CharVar[10] := 193;
        CharVar[11] := 194;
        CharVar[12] := 192;
        CharVar[13] := 195;
        CharVar[14] := 202;
        CharVar[15] := 203;
        CharVar[16] := 200;
        CharVar[17] := 205;
        CharVar[18] := 206;
        CharVar[19] := 204;
        CharVar[20] := 175;
        CharVar[21] := 223;
        CharVar[22] := 213;
        CharVar[23] := 254;
        CharVar[24] := 218;
        CharVar[25] := 219;
        CharVar[26] := 217;
        CharVar[27] := 180;
        CharVar[28] := 177;
        CharVar[29] := 176;
        CharVar[30] := 185;
        CharVar[31] := 179;
        CharVar[32] := 178;
        AnsiStr  := '—ýÒËÍÊÎÏÓÔÐÙØÕ'+Format(CharVar[1])+Format(CharVar[2])+Format(CharVar[3])+ 'µ–Þ÷'+Format(CharVar[4]);
        AnsiStr := AnsiStr + 'øõ ´'+Format(CharVar[5])+'°ú¹¸âß×Ý·±©¬'+Format(CharVar[6])+Format(CharVar[7]);
        AnsiStr := AnsiStr + '«¼'+Format(CharVar[8])+'í½'+Format(CharVar[9])+'___ªª' + Format(CharVar[10])+Format(CharVar[11]);
        AnsiStr := AnsiStr + Format(CharVar[12]) + 'ªª++óÑ++--+-+Ì' + Format(CharVar[13]) + '++--ª-+ñÚ¨';
        AnsiStr  :=  AnsiStr +Format(CharVar[14])+Format(CharVar[15])+Format(CharVar[16])+'i'+Format(CharVar[17])+Format(CharVar[18]);
        AnsiStr  :=  AnsiStr + 'Ÿ++__ª' + Format(CharVar[19])+Format(CharVar[20])+'®'+Format(CharVar[21])+'¯­ã';
        AnsiStr  :=  AnsiStr + Format(CharVar[22]) + '…' + Format(CharVar[23]) + 'Ã' + Format(CharVar[24])+ Format(CharVar[25]);
        AnsiStr  :=  AnsiStr + Format(CharVar[26]) + '²¦»' + Format(CharVar[27]) + '¡' + Format(CharVar[28]) +'=Ž†ºðˆ'+ Format(CharVar[29]);
        AnsiStr  :=  AnsiStr + '¿‡' + Format(CharVar[30]) +Format(CharVar[31]) +Format(CharVar[32]) +'_ ';
    end;
}

