unit jyDownloadFTPFile;

interface

function DownloadAFile(AURL, AUser, APassword, ALocalFile: string; ACanOverwrite: boolean): boolean;

implementation

uses IdFTP, IdFTPCommon, jyURLFunc;

function DownloadAFile(AURL, AUser, APassword, ALocalFile: string; ACanOverwrite: boolean): boolean;
var
  idftp: TIdFTP;
  strUser: string;
  strPwd: string;
  strDomain: string;
  iPort: integer;
  strDir: string;
  strFileName: string;
begin
  result := false;

  if not AnalyzeFTPUrl(AURL, strUser, strPwd, strDomain, iPort, strDir, strFileName) then exit;
  if AUser<>'' then
  begin
    strUser := AUser;
    strPwd  := APassword;
  end;
  if strUser = '' then
  begin
    strUser := 'anonymous';
    strPwd  := '@jysoft';
  end;

  idftp := TIdFTP.Create(nil);
  try try
    idftp.TransferType := ftBinary;
    idftp.Passive := true;
    idftp.Host := strDomain;
    idftp.Port := iPort;
    idftp.Username := strUser;
    idftp.Password := strPwd;
    idftp.Connect(True);
    idftp.ChangeDir(strDir);
    idftp.Get(strFileName, ALocalFile, ACanOverwrite);
    result := true;
    idftp.Disconnect;
  finally
    if idftp.Connected then idftp.Disconnect;
    idftp.Free;
  end;
  except
  end;
end; 

end.
