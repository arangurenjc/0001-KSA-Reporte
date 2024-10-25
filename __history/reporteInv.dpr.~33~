program reporteInv;

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.Themes,
  Vcl.Styles,
  u_DM in 'u_DM.pas' {DM: TDataModule},
  u_Acceso in 'u_Acceso.pas' {fAcceso},
  u_MainReporte in 'u_MainReporte.pas' {fMainReport},
  uFSplash in 'uFSplash.pas' {fSplash},
  u_frmProgress in 'u_frmProgress.pas' {frmProgressBar};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Luna');
  Application.CreateForm(TDM, DM);
  Application.CreateForm(TfMainReport, fMainReport);
  Application.CreateForm(TfAcceso, fAcceso);
  Application.CreateForm(TfSplash, fSplash);
  Application.Run;
end.
