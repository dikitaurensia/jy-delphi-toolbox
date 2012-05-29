program TestProject;

uses
  Forms,
  MainForm in 'forms\MainForm.pas' {frmMain},
  jyURLFunc in 'jyURLFunc.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmMain, frmMain);
  Application.Run;
end.
