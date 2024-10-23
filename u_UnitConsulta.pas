unit u_UnitConsulta;

interface

uses
  Classes, DBISAMTb, Forms, SysUtils, u_frmProgress;

type
  TConsultaHilo = class(TThread)
  private
    FQuery: TDBISAMQuery;
    FErrorMessage: string; // Para almacenar posibles errores
  protected
    procedure Execute; override;
    procedure MostrarProgreso; // Método para sincronizar la UI
    procedure OcultarProgreso; // Método para ocultar el formulario
    procedure MostrarError;    // Método para mostrar el error en la UI
  public
    constructor Create(CreateSuspended: Boolean; AQuery: TDBISAMQuery);
  end;

implementation

uses
  u_frmMainReporte;

constructor TConsultaHilo.Create(CreateSuspended: Boolean; AQuery: TDBISAMQuery);
begin
  inherited Create(CreateSuspended);
  FreeOnTerminate := True;
  FQuery := AQuery;
  FErrorMessage := ''; // Inicializamos el mensaje de error
end;

procedure TConsultaHilo.MostrarProgreso;
begin
  frmProgressBar := TfrmProgressBar.Create(nil);
  frmProgressBar.Show;
end;

procedure TConsultaHilo.OcultarProgreso;
begin
  if Assigned(frmProgressBar) then
  begin
    frmProgressBar.Close;
    FreeAndNil(frmProgressBar);
  end;
end;

procedure TConsultaHilo.MostrarError;
begin
  if FErrorMessage <> '' then
    ShowMessage('Error durante la consulta: ' + FErrorMessage);
end;

procedure TConsultaHilo.Execute;
begin
  try
    Synchronize(MostrarProgreso); // Mostrar el progreso en la UI

    // Verificación de que la query no sea nil
    if Assigned(FQuery) then
    begin
      FQuery.Open; // Ejecutar la consulta
    end
    else
      FErrorMessage := 'La consulta no está asignada.';

  except
    on E: Exception do
    begin
      FErrorMessage := E.Message; // Capturar el mensaje de error
    end;
  end;

  // Sincronizar para cerrar el formulario de progreso
  Synchronize(OcultarProgreso);

  // Si ocurrió un error, mostrarlo en la UI
  if FErrorMessage <> '' then
    Synchronize(MostrarError);
end;

end.
