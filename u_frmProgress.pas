unit u_frmProgress;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls;

type
  TfrmProgressBar = class(TForm)
    ProgressBar   : TProgressBar;
    Label1: TLabel;
    Label2: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
    procedure UpdateProgress(Percent: Integer);
  end;

var
  frmProgressBar: TfrmProgressBar;

implementation

{$R *.dfm}

{ TForm1 }

procedure TfrmProgressBar.UpdateProgress(Percent: Integer);
begin
  ProgressBar.Position  := Percent;
  //LabelProgress.Caption := Format('Exportando: %d%%', [Percent]);
  Application.ProcessMessages;
end;

end.
