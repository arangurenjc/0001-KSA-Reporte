unit u_Acceso;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TfAcceso = class(TForm)
    edtUsername: TEdit;
    edtPassword: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fAcceso: TfAcceso;

implementation

uses
  u_DM, u_MainReporte;

{$R *.dfm}

procedure TfAcceso.Button1Click(Sender: TObject);
begin

// Validar el inicio de sesi�n usando el Data Module
  ShowMessage(edtUsername.Text + ' ' + edtPassword.Text);
  {if fMainReport.IniciarSesion(edtUsername.Text, edtPassword.Text) then
    begin
        // Si el inicio de sesi�n es exitoso, muestra el formulario principal
            //Application.CreateForm(TfMainReport, fMainReport); // Crear y mostrar el Data Module principal
                //fMainReport.Show;  // Mostrar el formulario principal
                    Close;           // Destruir el formulario de inicio de sesi�n
                      end
                        else
                            begin
                                  ShowMessage('Acceso denegado. Usuario o contrase�a incorrectos o acceso restringido.');
                                        Close;
                                            end;}

end;

end.
