unit uHash;

interface

function CalcFileAESMD5(AFile: string): string;
function CalcPathAESMD5(APath: string): string;
function AESMD5ToMD5String(AAESMD5: string): string;

implementation

uses md5, SysUtils, IDEA, AES, Classes, StrUtils;

const
  AES_PWD = 'C1870CCCFFEDB8A623AAEE88C2751C0B';
  HaShuangKey : array [0..7] of WORD = ($7171,$6477,$6A6C,$6B6E,$716A,$796A,$646C,7371);
//////////////////////////////////////////////////////////////////////////////
//  Ω‚√‹ ˝æ›ø‚√‹¬Î
//////////////////////////////////////////////////////////////////////////////
function DecryptDBPassword(const ASource: string; var AResultPwd: string): boolean;
var
  bTemp : array of byte;
  len   : integer;
  i: integer;
begin
  result := false;
  AResultPwd := '';

  try
    len := Length(ASource);
    if len mod 32 <> 0 then exit;
    len := round(len/2);
    setlength(bTemp, len);
    for i:=0 to len-1 do
      bTemp[i] := strtoint('$'+Copy(ASource, i*2+1, 2));
    IDEA_Crypt(@bTemp[0], len, HaShuangKey, 1);
    AResultPwd := pchar(@bTemp[0]);
    result := true;
  except
  end;
end;

function CalcFileAESMD5(AFile: string): string;
var
  strMD5: string;
  binMD5: string;
  strAESKey: string;
begin
  result := '';

  if not FileExists(AFile) then exit;

  if not DecryptDBPassword(AES_PWD, strAESKey) then exit;

  strMD5 := MD5DigestToStr(MD5File(AFile));
  binMD5 := DupeString('0', 16);
  HexToBin(@strMD5[1], @binMD5[1], 16);
  result := EncryptString(binMD5, strAESKey, kb256);
end;

function CalcPathAESMD5(APath: string): string;
var
  strMD5: string;
  binMD5: string;
  strAESKey: string;
begin
  result := '';

  if not DecryptDBPassword(AES_PWD, strAESKey) then exit;

  strMD5 := MD5DigestToStr(MD5String(APath));
  binMD5 := DupeString('0', 16);
  HexToBin(@strMD5[1], @binMD5[1], 16);
  result := EncryptString(binMD5, strAESKey, kb256);
end;

function AESMD5ToMD5String(AAESMD5: string): string;
var
  binMD5: string;
  strMD5: string;
  strAESKey: string;
begin
  result := '';
  
  if not DecryptDBPassword(AES_PWD, strAESKey) then exit;

  binMD5 := DecryptString(AAESMD5, strAESKey, kb256);

  strMD5 := DupeString('0', Length(binMD5) * 2);

  BinToHex(@binMD5[1], @strMD5[1], Length(binMD5));

  result := strMD5;
end;

end.
