unit jyURLFunc;

interface

// AnalyziFTPUrl
// 2012-05-29
// 用于分析ftp url的各部分内容，要包含文件名(如不包含，则最后一个字符必需为'/')
// 参数:
//   AFTPUrl: ftp url, like: ftp://user:password@192.168.1.168:10021/_public/test.exe
//   AUser:   Username field in url string: 'user'
//   APwd:    Password field in url string: 'password'
//   ADomain: IP Address or Domain field in url string: '192.168.1.168'
//   APort:   Port field in url string: 10021 (default: 21)
//   ADir:    Dir field in url string: '/_public/'
//   AFile:   File name field in url string: 'test.exe'

function AnalyzeFTPUrl(AFTPUrl: string; var AUser, APwd, ADomain: string; var APort: integer; var ADir, AFile: string): boolean;

implementation

uses SysUtils, StrUtils;

function AnalyzeFTPUrl(AFTPUrl: string; var AUser, APwd, ADomain: string; var APort: integer; var ADir, AFile: string): boolean;
var
  url: string;
  i: integer;
  iDomainStart: integer;
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
