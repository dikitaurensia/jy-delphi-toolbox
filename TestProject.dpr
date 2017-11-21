program TestProject;

uses
  Forms,
  MainForm in 'forms\MainForm.pas' {frmMain},
  jyURLFunc in 'jyURLFunc.pas',
  jyDownloadFTPFile in 'jyDownloadFTPFile.pas',
  uDelphiCompress in 'uDelphiCompress.pas',
  uFileVersionProc in 'uFileVersionProc.pas',
  md5 in 'MD5.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
