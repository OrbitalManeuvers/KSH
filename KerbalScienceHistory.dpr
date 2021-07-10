program KerbalScienceHistory;

{$R 'ver_info.res' 'ver_info.rc'}

uses
  Vcl.Forms,
  f_Main in 'f_Main.pas' {MainForm},
  u_CFGNode in 'u_CFGNode.pas',
  u_CFGReader in 'u_CFGReader.pas',
  u_CFGScienceParser in 'u_CFGScienceParser.pas',
  u_CFGWrapper in 'u_CFGWrapper.pas',
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.Title := 'KSP Science History';
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
