unit jyURLFunc;

interface

function AnalyzeFTPUrl(AFTPUrl: string; var AUser, APwd, ADomain: string; var APort: integer; var ADir, AFile: string): boolean;

implementation

uses SysUtils, StrUtils;

function AnalyzeFTPUrl(AFTPUrl: string; var AUser, APwd, ADomain: string; var APort: integer; var ADir, AFile: string): boolean;
var
  url: string;
  i: integer;
  iDomainStart: integer;
  iDomainEnd: integer;
  iFileStart: integer;
begin
  result := false;
  AUser := '';
  APwd := '';
  ADomain := '';
  APort := 21;
  ADir := '';
  AFile := '';

  url := Trim(AFTPUrl);

  try
    if LowerCase(LeftStr(url, 6)) <> 'ftp://' then exit;

    //去掉 ftp:// 6个字符
    Delete(url, 1, 6);

    //去掉域名后的字符串,是域名、端口、用户、密码
    ADomain := LeftStr(url, Pos('/', url)-1);
    Delete(url, 1, Length(ADomain));
    //解析域名、端口、用户、密码
    iDomainStart := 1;
    for i := Length(ADomain) downto 1 do
    begin
      if (ADomain[i] = '@') then
      begin
        iDomainStart := i+1;
        break;
      end;
    end;
    AUser := LeftStr(ADomain, iDomainStart-2);
    Delete(ADomain, 1, iDomainStart-1);
    if Pos(':', ADomain) < 1 then ADomain := Format('%s:21', [ADomain]);
    APort := StrToInt(RightStr(ADomain, Length(ADomain)-Pos(':', ADomain)));
    ADomain := LeftStr(ADomain, Pos(':', ADomain)-1);

    APwd := RightStr(AUser, Length(AUser)-Pos(':', AUser));
    AUser := LeftStr(AUser, Pos(':', AUser)-1);


    iFileStart := 1;
    for i := Length(url) downto 1 do
    begin
      if (url[i] = '/') then
      begin
        iFileStart := i+1;
        break;
      end;
    end;
    AFile := RightStr(url, Length(url)-iFileStart+1);
    Delete(url, iFileStart, Length(AFile));

    ADir := url;

    result := true;
  except
  end;
end;

end.
