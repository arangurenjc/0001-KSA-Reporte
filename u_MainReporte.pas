unit u_MainReporte;

interface

uses
  //Estas son puestas por mi segun mis necesidades
  IniFiles, DBISAMTb, DateUtils, DB, System.Math, System.Threading, Excel2000, ComObj,
  System.StrUtils,  Vcl.ExtCtrls,  Winapi.ShellAPI, IdHTTP, IdSSLOpenSSL, ZLib, IdComponent,
  System.Net.HttpClient, System.Net.HttpClientComponent, System.Zip,

  // Estas son propias de delphi
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.StdCtrls,
  Vcl.ComCtrls, Vcl.Mask, scControls, scCalendar, Vcl.WinXPickers, vcl.wwdbdatetimepicker,
  Vcl.Grids, Vcl.DBGrids, vcl.wwdbedit, vcl.wwdotdot, vcl.wwdbcomb, Vcl.WinXPanels, Vcl.Buttons,
  System.ImageList, Vcl.ImgList, Vcl.VirtualImageList, Vcl.BaseImageCollection, Vcl.ImageCollection;

type
  TPeriodo = record
    Periodo : string;
    FechaI  : TDateTime;
    FechaF  : TDateTime;
  end;

  TVendedores=class
  private
    FVendedorID : string;
    FVendedorNa : string;

  public
    constructor CreateVendedores(const AVendedorID, AVendedorNa : string);
    property VendedorID : string read FVendedorID write FVendedorID;
    property VendedorNa : string read FVendedorNa write FVendedorNa;
  end;


  TfMainReport = class(TForm)
    MainMenu1           : TMainMenu;
    I1                  : TMenuItem;
    R1                  : TMenuItem;
    G1                  : TMenuItem;
    V1                  : TMenuItem;
    C1                  : TMenuItem;

    btnCalcular         : TButton;
    Button2             : TButton;
    btnExportExcel      : TButton;
    Button3             : TButton;
    Button1             : TButton;
    spbExportExcel      : TSpeedButton;
    spbCalcularReport   : TSpeedButton;
    spbExportTxt        : TSpeedButton;

    chkStatus_Inv       : TCheckBox;
    chkStatus_Prov      : TCheckBox;
    chkData             : TCheckBox;

    dtpFechaIniCom      : TwwDBDateTimePicker;
    wwDBDateTimePicker2 : TwwDBDateTimePicker;
    dtpFechaIni         : TwwDBDateTimePicker;
    dtpFechaFin         : TwwDBDateTimePicker;
    dtpFechaDataIni     : TwwDBDateTimePicker;
    dtpFechaDataFin     : TwwDBDateTimePicker;

    pnlBotonesCalculo   : TPanel;
    Memo1               : TMemo;
    GroupBox1           : TGroupBox;

    Label3              : TLabel;
    Label2              : TLabel;
    lblCantPeriodos     : TLabel;
    lblExport           : TLabel;
    Label1              : TLabel;
    Label7              : TLabel;
    Label8              : TLabel;
    Label4              : TLabel;
    Label5              : TLabel;
    Label6              : TLabel;

    ProgressBar1        : TProgressBar;

    Edit1               : TEdit;

    CardPanel1          : TCardPanel;
    cardCompras         : TCard;
    cardVentas          : TCard;

    cbVendedores        : TwwDBComboBox;
    cbDepartamentos     : TwwDBComboBox;
    cbDepositos         : TwwDBComboBox;

    chkProductosInactivos: TCheckBox;
    chkDepartamento     : TCheckBox;
    chkDeposito         : TCheckBox;
    chkVendedor         : TCheckBox;

    imgCollection       : TImageCollection;
    imgList             : TVirtualImageList;

    GroupBox2           : TGroupBox;
    scLabel2: TscLabel;
    scLabel3: TscLabel;
    pnlInfoApp: TPanel;
    wwDBDateTimePicker1: TwwDBDateTimePicker;

    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure dtpFechaIniComChange(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure c1Click(Sender: TObject);
    procedure V1Click(Sender: TObject);
    procedure chkVendedorClick(Sender: TObject);
    procedure cbVendedoresChange(Sender: TObject);
    procedure spbCalcularReportClick(Sender: TObject);
    procedure spbExportExcelClick(Sender: TObject);
    procedure chkDepartamentoClick(Sender: TObject);
    procedure cbDepartamentosChange(Sender: TObject);
    procedure chkDepositoClick(Sender: TObject);
    procedure cbDepositosChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure importarDataHAC;
    procedure descomprimirArchivo(const CompressedFile, OutputPath: string);
    procedure btnExportExcelClick(Sender: TObject);

    procedure spbExportTxtClick(Sender: TObject);
    procedure dtpFechaDataFinChange(Sender: TObject);


  private
    { Private declarations }
      function encapsularPeriodo(t : TDate) : string;
      function verificarBDHoy(const RutaArchivo: string): Boolean;

      procedure encapsularPeriodo2(t: string);

      function usuarioTieneAcceso: Boolean;
      //function EsFechaValida(Fecha: TDateTime): Boolean;

      procedure getVariableEntorno;
      procedure calcularPeriodos;
      procedure calcularReporte(tipo : Integer);

      procedure borrarTablaTmp( IdUser : Integer);

      procedure crearTablaTMP_c( idUser : Integer);
      procedure crearTablaTMP_V( idUser : Integer);

      //PARA CREAR TABLAS TEM�PORALES
      procedure crearTablaTMP_Inven( idUser : Integer);
      procedure crearTablaTMP_Prove( idUser : Integer);
      procedure crearTablaTMP_Categ( idUser : Integer);
      procedure crearTablaTMP_SubCa( idUser : Integer);
      procedure crearTablaTMP_Marca( idUser : Integer);
      procedure crearTablaTMP_Depo(idUser: Integer);

      procedure crearTablaTMP_Compr( idUser : Integer);
      procedure crearTablaTMP_NotaE( idUser : Integer);
      procedure crearTablaTMP_InvDe( idUser : Integer);
      procedure crearTablaTMP_VtaAc( idUser : Integer);
      PROCEDURE crearTablaTMP_VtaDe( idUser : Integer; tabla : String);

      //PARA INSERTAR DATOS EN LAS TABLAS CREADAS
      procedure insertTablaTMP_Inven( tabla : string);
      procedure insertTablaTMP_Prove( tabla : string);
      procedure insertTablaTMP_Categ( tabla : string);
      procedure insertTablaTMP_SubCa( tabla : string);
      procedure insertTablaTMP_Marca( tabla : string);
      procedure insertTablaTMP_Depo(tabla: string);

      procedure insertTablaTMP_Compr( tabla : string);
      procedure insertTablaTMP_NotaE( tabla : string);
      procedure insertTablaTMP_InvDe( tabla : string);
      procedure insertTablaTMP_VtaAc( tabla : string);
      procedure insertTablaTMP_VtaDe( tabla : string; rutaDatos:string; fechaI, fechaF : TDate);

      procedure consultaFinalCompras;
      procedure consultaFinalVentas;

      procedure ExportToExcel(DBQuery : TDBISAMQuery);
      //procedure ExportToExcel_Version(DBQuery : TDBISAMQuery);

      procedure asignarTablas_Posicion;
      procedure ExportToTxt(DBQuery: TDBISAMQuery);
      procedure calcularOtrasColumnasCompra;


var

  public
    { Public declarations }
    accesoPermitido : Boolean;
    userName        : string;
    userIndex       : Integer;
    finalizaImport  : Boolean;

  end;

var
  fMainReport : TfMainReport;

  archivoINI  : string;
  tablasBD    : array[1..14] of string;
  Periodos    : array[1..7] of TPeriodo;  // Array de 7 periodos

  {Periodos desde 1 hasta 6 para los 6 meses de consulta de venta
   posicion 7 es para la Data Actual si lo requieren.}

  {***************************************
    Estas son las variables de Entorno}
  claveCadena,
  rutaServer,
  portServer,
  rutaData,
  rutaTemp,
  tablaReport,
  vendedor,
  dpto,
  reportComAc,
  reportComEx,
  reportVtaAc : String;
  tipoReport,
  nPeriodo,
  deposito    : Integer;
  fechaInicio : TDate;
  fechaTope   : TDate;

  flagDpto,
  flagVend,
  flagDepo : Boolean;
  // *************************************

  mesIni, mesFin, yearIni, yearFin : integer;

Const
  mesesPeriodo: array[1..12] of string = (
    'ENE', 'FEB', 'MAR', 'ABR', 'MAY', 'JUN',
    'JUL', 'AGO', 'SEP', 'OCT', 'NOV', 'DIC');

    BD_INVE = 'B01';   //tmp_Inventario
    BD_PROV = 'B02';   //tmp_Proveedor
    BD_CATE = 'B03';   //tmp_categorias
    BD_SUBC = 'B04';   //tmp_SubCategoria
    BD_MARC = 'B05';   //tmp_Marcas
    BD_DEPO = 'B06';   //tmp_Depositos

    BD_COMP = 'B21';   //tmp_Compras
    BD_NENT = 'B22';   //tmp_Nota Entrega
    BD_INVD = 'B23';   //tmp_Inventario Deposito
    BD_VTAA = 'B24';   //tmp_Ventas Acaumuladas
    BD_VTAD = 'B25';   //tmp_Ventas detalle del periodo
    BD_VTA2 = 'B26';   //tmp_Ventas detalle del periodo

    BD_ENDX = 'B50';   //tmp_Resultado de todas las consultas Movimiento Compras
    BD_ENDV = 'B51';   //tmp_Resultado de todas las consultas Movimiento Ventas

    CONVD = 11591;
    CONVM = 91407;
    CONVY = 19749;

    CLAVE_D = '13567412';
    CLAVE_M = '73182567';
    CLAVE_Y = '45163872';

    CHUNK_SIZE = 10 * 1024 * 1024;

implementation

uses
  u_DM, uFSplash ;

{$R *.dfm}


procedure TfMainReport.asignarTablas_Posicion;
var
  i:Integer;

begin
  //ShowMessage('ASignando Tablas');
  tablasBD[1]   :=  IntToStr(userIndex) + BD_INVE ;   //tmp_Inventario
  tablasBD[2]   :=  IntToStr(userIndex) + BD_PROV ;   //tmp_�Proveedor
  tablasBD[3]   :=  IntToStr(userIndex) + BD_CATE ;   //tmp_�categorias
  tablasBD[4]   :=  IntToStr(userIndex) + BD_SUBC ;   //tmp_�SubCategoria
  tablasBD[5]   :=  IntToStr(userIndex) + BD_MARC ;   //tmp_�Marcas
  tablasBD[6]   :=  IntToStr(userIndex) + BD_DEPO ;   //tmp_�Depositos

  tablasBD[7]   :=  IntToStr(userIndex) + BD_COMP ;   //tmp_�Compras
  tablasBD[8]   :=  IntToStr(userIndex) + BD_NENT ;   //tmp_�Nota Entrega
  tablasBD[9]   :=  IntToStr(userIndex) + BD_INVD ;   //tmp_�Inventario Deposito
  tablasBD[10]  :=  IntToStr(userIndex) + BD_VTAA ;   //tmp_�Ventas Acaumuladas
  tablasBD[11]  :=  IntToStr(userIndex) + BD_VTAD ;   //tmp_�Ventas Acaumuladas
  tablasBD[12]  :=  IntToStr(userIndex) + BD_VTA2 ;   //tmp_�Ventas Acaumuladas

  tablasBD[13]  :=  IntToStr(userIndex) + BD_ENDX ;   //tmp_�Todas las conultas agrupadas
  tablasBD[14]  :=  IntToStr(userIndex) + BD_ENDV ;   //tmp_�Ventas Acaumuladas   BD_ENDV

  Memo1.Lines.Add('Lista de Tablas Asignadas : ');
  for i := 0 to High(tablasBD) do
    begin

      Memo1.Lines.Add(tablasBD[i]);

    end;

end;


procedure TfMainReport.borrarTablaTmp(IdUser : Integer);
var
  Query     : TDBISAMQuery;
  i         : Integer;
  tablaName : string;

begin
  Query := TDBISAMQuery.Create(nil);
  try
    Query.DatabaseName := u_DM.DM.a2DATA.DatabaseName; // Aseg�rate de asignar la base de datos correcta
    for i := 0 to High(tablasBD) do
    begin
      tablaName := tablasBD[i];
      try
        // Ejecuta el comando SQL para eliminar la tabla
        Query.SQL.Clear;
        Query.SQL.Text := 'DROP TABLE IF EXISTS ' + Chr(34) + rutaTemp + '\' + tablaName + Chr(34);
        Query.ExecSQL;
      except
        on E: Exception do
          ShowMessage('Error eliminando tabla ' + tablaName + ': ' + E.Message);
      end;
    end;
  finally
    Query.Free;
  end;
end;


procedure TfMainReport.btnExportExcelClick(Sender: TObject);
var
  FilePath    : string;
  ZipFile     : TZipFile;
  i           : Integer;
begin
  FilePath  := rutaTemp + '\reporte.zip'; // Puedes cambiar el nombre del archivo si es necesario

  if TZipFile.IsValid(FilePath) then
        begin
          ShowMessage('Descomprmir ZIP');
          ZipFile := TZipFile.Create;
          try
            ZipFile.Open(FilePath, zmRead);
            // Extrae todos los archivos en el archivo .zip
            for i := 0 to ZipFile.FileCount - 1 do
              ZipFile.Extract(i, rutaTemp);
            //ShowMessage('Archivo descomprimido exitosamente en ' + ExtractPath);
          finally
            ZipFile.Free;
          end;
          // Elimina el archivo ZIP despu�s de la descompresi�n
          if DeleteFile(FilePath) then
            ShowMessage('Archivo .zip eliminado correctamente')
          else
            ShowMessage('Error al eliminar el archivo .zip');
        end
        else
          ShowMessage('El archivo descargado no es un archivo ZIP v�lido.');

end;



procedure TfMainReport.Button1Click(Sender: TObject);
begin
  encapsularPeriodo(wwDBDateTimePicker2.Date);
end;


procedure TfMainReport.Button2Click(Sender: TObject);
begin
  encapsularPeriodo2(Edit1.Text);
end;


//-------------------------------------------  Respaldar BD
procedure TfMainReport.Button3Click(Sender: TObject);
var
  StartTime, EndTime: TDateTime;
  TimeElapsed       : Double;
begin
  StartTime := Now;
  Memo1.Lines.Add('Hora de Inicio   : ' + DateTimeToStr(StartTime));
  // Aqu� pones el c�digo de la tarea que deseas medir
  importarDataHAC;
  // Guardar la hora de finalizaci�n
  EndTime := Now;
  Memo1.Lines.Add('Hora de Finaliza : ' + DateTimeToStr(EndTime));
  // Calcular el tiempo transcurrido en milisegundos
  TimeElapsed := MilliSecondsBetween(EndTime, StartTime);
  // Mostrar el tiempo transcurrido en un mensaje
  Memo1.Lines.Add('Tiempo transcurrido: ' + FloatToStr(TimeElapsed) + ' milisegundos.');

end;
  


procedure TfMainReport.c1Click(Sender: TObject);
begin
  tipoReport              := 1;
  spbExportTxt.Enabled    := false;
  spbExportExcel.Enabled  := false;
  dtpFechaDataIni.date    := EncodeDate(YearOf(Now), MonthOf(Now),1);
  dtpFechaDataFin.date    := Now;

  if not CardPanel1.Visible then
  begin
    CardPanel1.Visible          := True;
    CardPanel1.ActiveCardIndex  := 0;

    if not pnlBotonesCalculo.Visible then
      pnlBotonesCalculo.Visible := True;
  end
  else
    CardPanel1.ActiveCardIndex  := 0;

end;


procedure TfMainReport.V1Click(Sender: TObject);
begin
  tipoReport              := 2;
  spbExportTxt.Enabled    := false;
  spbExportExcel.Enabled  := false;

  if not CardPanel1.Visible then
  begin
    CardPanel1.Visible          := True;
    CardPanel1.ActiveCardIndex  := 1;

    if not pnlBotonesCalculo.Visible then
      pnlBotonesCalculo.Visible := True;
  end
  else
    CardPanel1.ActiveCardIndex  := 1;

  spbCalcularReport.Enabled := True;
end;



function TfMainReport.verificarBDHoy(const RutaArchivo: string): Boolean;
var
  DatosArchivo: TWin32FileAttributeData;
  FechaUltimoAcceso: TFileTime;
  SistemaTime: TSystemTime;
  FechaUltimoAccesoDT, FechaActual: TDateTime;
begin
  Result := False;
  FechaActual := Date; // Obtiene la fecha de hoy
  // Verifica si el archivo existe
  if FileExists(RutaArchivo) then
  begin
    // Obtiene los atributos del archivo
    if GetFileAttributesEx(PChar(RutaArchivo), GetFileExInfoStandard, @DatosArchivo) then
    begin
      // Obtiene la fecha del �ltimo acceso
      FechaUltimoAcceso := DatosArchivo.ftLastAccessTime;
      // Convierte el formato TFileTime a TSystemTime y luego a TDateTime
      FileTimeToSystemTime(FechaUltimoAcceso, SistemaTime);
      FechaUltimoAccesoDT := SystemTimeToDateTime(SistemaTime);
      // Compara si la fecha de �ltimo acceso es hoy
      Result := SameDate(FechaUltimoAccesoDT, FechaActual);
    end;
  end;

end;

procedure TfMainReport.calcularPeriodos;
var
  selectedMonth, selectedYear : Integer;
  I, indexCombo, dias : Integer;

begin
  selectedMonth := MonthOf(dtpFechaIniCom.Date);
  selectedYear  := YearOf(dtpFechaIniCom.Date);
  dias          := DaysBetween(dtpFechaIniCom.Date,
                               dtpFechaIniCom.MaxDate);
  indexCombo    := Trunc(Roundto( (dias/ 30),0));
  lblCantPeriodos.Caption := IntToStr(indexCombo);

  for I := 1 to indexCombo  do
  begin
    //ShowMessage('Posicion ' + IntToStr(I));
    periodos[I].Periodo := mesesPeriodo[selectedMonth] + '-' + IntToStr(selectedYear);
    Periodos[I].FechaI  := EncodeDate(selectedYear,selectedMonth,1);
    Periodos[I].FechaF  := EndOfAMonth(YearOf(Periodos[I].FechaI), MonthOf(Periodos[I].FechaI));

    inc(selectedMonth);
    if selectedMonth > High(mesesPeriodo) then
    begin
      inc(selectedYear);
      selectedMonth := 1;
    end;
  end;

  //periodos[7].Periodo := mesesPeriodo[MonthOf(dtpFechaDataIni.Date)] + '-' +
  //                       Format('%.2d', [DayOf(dtpFechaDataFin.Date)]) ;  //'DATA';

  //Periodos[7].FechaI  := dtpFechaDataIni.Date;
  //Periodos[7].FechaF  := dtpFechaDataFin.Date;

  //EndOfAMonth(YearOf(Periodos[7].FechaI), MonthOf(Periodos[7].FechaI));

end;


procedure TfMainReport.calcularReporte(tipo : Integer);
var
  tareaInsert : ITask;
  //mensaje     : string;
begin
  spbCalcularReport.Enabled := False;
  tareaInsert := TTask.Create(
    procedure
    begin
      try
        // Sincronizaci�n de la interfaz en el hilo principal
        TThread.Queue(nil,
          procedure
          var
            i: integer;
          begin
            i := 0;
            progressBar1.Visible := True;
            while (i < ProgressBar1.Max) do
            begin
              if i = ProgressBar1.Max then
                i := 0
              else
                inc(i);
            end;
          end);

        lblExport.Caption := 'Esp�re mientras se realiza la importaci�n de Datos' + #13#10 +
                             'este proceso puede demorar, sea paciente' + #13#10 +
                             '�No Cierre el Generador de Reporte... !';
        importarDataHAC;
        // L�gica seg�n el tipo de reporte
        if tipo = 1 then
        begin
          crearTablaTMP_c(userIndex);
          lblExport.Caption := 'Importando Data Inventario...';
          insertTablaTMP_Inven(#34 + rutaTemp + '\' + tablasBD[1] + #34);
          lblExport.Caption := 'Importando Data Proveedores...';
          insertTablaTMP_Prove(#34 + rutaTemp + '\' + tablasBD[2] + #34);
          lblExport.Caption := 'Importando Data Categorias...';
          insertTablaTMP_Categ(#34 + rutaTemp + '\' + tablasBD[3] + #34);
          lblExport.Caption := 'Importando Data Sub Categorias...';
          insertTablaTMP_SubCa(#34 + rutaTemp + '\' + tablasBD[4] + #34);
          lblExport.Caption := 'Importando Data Marcas...';
          insertTablaTMP_Marca(#34 + rutaTemp + '\' + tablasBD[5] + #34);
          lblExport.Caption := 'Consulta movimientos de Compras...';
          insertTablaTMP_Compr(#34 + rutaTemp + '\' + tablasBD[7] + #34);
          lblExport.Caption := 'Consulta movimientos de Nota Entregas...';
          insertTablaTMP_NotaE(#34 + rutaTemp + '\' + tablasBD[8] + #34);
          lblExport.Caption := 'Consultando Existencias en Depositos...';
          insertTablaTMP_InvDe(#34 + rutaTemp + '\' + tablasBD[9] + #34);
          lblExport.Caption := 'Calculando Ventas acumuladas...';
          insertTablaTMP_VtaAc(#34 + rutaTemp + '\' + tablasBD[10] + #34);
          tablaReport := tablasBD[13];
          lblExport.Caption := 'Consolidando Reporte Final de Compras...';
          consultaFinalCompras;
        end
        else
        begin
          crearTablaTMP_v(userIndex);
          lblExport.Caption := 'Importando Data Inventario...';
          insertTablaTMP_Inven(#34 + rutaTemp + '\' + tablasBD[1] + #34);
          lblExport.Caption := 'Importando Data Categorias...';
          insertTablaTMP_Categ(#34 + rutaTemp + '\' + tablasBD[3] + #34);
          lblExport.Caption := 'Importando Data Sub Categorias...';
          insertTablaTMP_SubCa(#34 + rutaTemp + '\' + tablasBD[4] + #34);
          lblExport.Caption := 'Importando Data Dep�sitos...';
          insertTablaTMP_Depo(#34 + rutaTemp + '\' + tablasBD[6] + #34);

          lblExport.Caption := 'Acumulado Ventas del per�odo...';
          insertTablaTMP_VtaDe(#34 + rutaTemp + '\' + tablasBD[11] + #34, rutaTemp, dtpFechaIni.Date, dtpFechaFin.Date);

          if dtpFechaFin.Date = Now then //wwDBDateTimePicker1.Date then
            insertTablaTMP_VtaDe(#34 + rutaTemp + '\' + tablasBD[11] + #34, rutaData, dtpFechaFin.Date, dtpFechaFin.Date);

          tablaReport := tablasBD[14];           //BD_ENDV
          lblExport.Caption := 'Consolidando Reporte Final de Ventas...';
          consultaFinalVentas;
        end;
        // Finalizar la tarea y habilitar el bot�n
        TThread.Queue(nil,
          procedure
          var
            respuesta: integer;
          begin
            lblExport.Caption := '';
            progressBar1.Visible := False;
            respuesta := MessageDlg('Consulta Finalizada...', TMsgDlgType.mtInformation, [TMsgDlgBtn.mbOK], 0);
            spbExportExcel.Enabled := True;
            spbExportTxt.Enabled := True;
          end);
      except
        on E: Exception do
        begin
          // Captura cualquier excepci�n y la muestra en un cuadro de di�logo
          TThread.Queue(nil,
            procedure
            begin
              lblExport.Caption := '';
              progressBar1.Visible := False;
              MessageDlg('Error: ' + E.Message, TMsgDlgType.mtError, [TMsgDlgBtn.mbOK], 0);
              spbCalcularReport.Enabled := True; // Habilitar el bot�n de nuevo en caso de error
            end);
        end;
      end;
    end);
  tareaInsert.Start;

end;


procedure TfMainReport.cbDepartamentosChange(Sender: TObject);
var
  infoDpto : TVendedores;

begin
  if cbDepartamentos.ItemIndex > -1 then
  begin
    infoDpto  := TVendedores(cbDepartamentos.Items.Objects[cbDepartamentos.ItemIndex]);
    dpto      := infoDpto.FVendedorID;
  end;
end;


procedure TfMainReport.cbDepositosChange(Sender: TObject);
var
  infoDeposito : TVendedores;

begin
  if cbDepositos.ItemIndex > -1 then
  begin
    infoDeposito  := TVendedores(cbDepositos.Items.Objects[cbDepositos.ItemIndex]);
    deposito      := StrToInt(infoDeposito.FVendedorID);
  end;

end;

procedure TfMainReport.cbVendedoresChange(Sender: TObject);
var
  infoVendedor : TVendedores;

begin
  if cbVendedores.ItemIndex > -1 then
  begin
    infoVendedor  := TVendedores(cbVendedores.Items.Objects[cbVendedores.ItemIndex]);
    vendedor      := infoVendedor.FVendedorID;
  end;
end;


procedure TfMainReport.chkDepartamentoClick(Sender: TObject);
var
  dptoID, dptoNom : string;

begin
  if (chkDepartamento.Checked) and (flagDpto = False) then
  begin
    cbDepartamentos.Enabled := True;
    cbDepartamentos.Clear;
    with dm.SQl_Dpto do
    begin
      Close;
      Active := False;
      SQL.Clear;

      SQL.Add('SELECT FD_CODIGO AS CODIGO, CAST(FD_DESCRIPCION AS VARCHAR(30)) AS NOMBRE ');
      SQL.Add('FROM "' + rutaData + '\SCATEGORIA"');
      open;

      First;
      while not Eof do
      begin
        dptoID  := FieldByName('CODIGO').AsString;
        dptoNom := FieldByName('NOMBRE').AsString;;
        cbDepartamentos.Items.AddObject(dptoID + '-' + dptoNom, TVendedores.CreateVendedores(dptoID,dptoNom));
        Next;
      end;
      Close;
    end;
    cbDepartamentos.ItemIndex := 0;
    flagDpto := True;
  end
  else
  begin
    if not chkDepartamento.Checked and flagDpto = True then
    begin
      cbDepartamentos.ItemIndex := -1;
      cbDepartamentos.Enabled := False;
    end
    else
    begin
      cbDepartamentos.ItemIndex := 0;
      cbDepartamentos.Enabled := True;
    end;
  end;
end;


procedure TfMainReport.chkDepositoClick(Sender: TObject);
var
   depoID, depoNom : string;
   
begin
  if (chkDeposito.Checked) and (flagDepo = False)   then
  begin
    cbDepositos.Clear;
    cbDepositos.Enabled := True;

    with dm.SQl_Depositos do
    begin
      Close;
      Active := False;
      SQL.Clear;

      SQL.Add('SELECT FDP_CODIGO AS CODIGO, CAST(FDP_DESCRIPCION AS VARCHAR(30)) AS NOMBRE ');
      SQL.Add('FROM "' + rutaData + '\SDEPOSITOS"');
      open;

      //ShowMessage('Registros : ' + IntToStr(RecordCount) );
      First;
      while not Eof do
      begin
        depoID  := FieldByName('CODIGO').AsString;
        depoNom := FieldByName('NOMBRE').AsString;;
        cbDepositos.Items.AddObject(depoID + '-' + depoNom, TVendedores.CreateVendedores(depoID,depoNom));

        Next;
      end;
      Close;
    end;
    cbDepositos.ItemIndex := 0;
    flagDepo := True;
  end
  else
  begin
    if not chkDeposito.Checked and flagDepo = True then
    begin
      cbDepositos.ItemIndex := -1;
      cbDepositos.Enabled := False;
    end
    else
    begin
      cbDepositos.ItemIndex := 0;
      cbDepositos.Enabled := True;
    end;
  end;

end;


procedure TfMainReport.chkVendedorClick(Sender: TObject);
var
   vendID, vendNom : string;


begin
  if (chkVendedor.Checked) and (flagVend = False) then
  begin
    cbVendedores.Enabled := True;
    cbVendedores.Clear;
    with dm.SQl_Vendedor do
    begin
      Close;
      Active := False;
      SQL.Clear;

      SQL.Add('SELECT FV_CODIGO AS CODIGO, CAST(FV_DESCRIPCION AS VARCHAR(30)) AS NOMBRE ');
      SQL.Add('FROM "' + rutaData + '\SVENDEDORES"');
      open;

      First;
      while not Eof do
      begin
        vendID  := FieldByName('CODIGO').AsString;
        vendNom := FieldByName('NOMBRE').AsString;;
        cbVendedores.Items.AddObject(vendID + '-' + vendNom, TVendedores.CreateVendedores(vendID,vendNom));

        Next;
      end;
      Close;
    end;
    cbVendedores.ItemIndex := 0;
    flagVend := True;
  end
  else
  begin
    if not chkVendedor.Checked and flagVend = True then
    begin
      cbVendedores.ItemIndex := -1;
      cbVendedores.Enabled := False;
    end
    else
    begin
      cbVendedores.ItemIndex := 0;
      cbVendedores.Enabled := True;
    end;
  end;
end;


{
===============================================================================
    CREACION DE TODAS LAS TABLAS TEMPORALES
===============================================================================
}
procedure TfMainReport.crearTablaTMP_c(idUser: Integer);
begin
  borrarTablaTmp(idUser);
  crearTablaTMP_Inven(idUser);
  crearTablaTMP_Prove(idUser);
  crearTablaTMP_Categ(idUser);
  crearTablaTMP_SubCa(idUser);
  crearTablaTMP_Marca(idUser);
  
  crearTablaTMP_Compr(idUser);
  crearTablaTMP_NotaE(idUser);
  crearTablaTMP_InvDe(idUser);
  crearTablaTMP_VtaAc(idUser);

end;


procedure TfMainReport.crearTablaTMP_V(idUser: Integer);
begin
  borrarTablaTmp(idUser);
  crearTablaTMP_Inven(idUser);
  crearTablaTMP_Categ(idUser);
  crearTablaTMP_SubCa(idUser);
  crearTablaTMP_Depo(idUser);
  crearTablaTMP_VtaDe(idUser, tablasBD[11]);
  crearTablaTMP_VtaDe(idUser, tablasBD[12]);
end;


{----------------------------------------------------------------------------1
     CREACION DE TABLA TEMPORAL PARA DATOS DE INVENTARIO
}
procedure TfMainReport.crearTablaTMP_Inven(idUser: Integer);
var
  TableToCreate: TDBISAMTable;

begin
  TableToCreate :=  TDBISAMTable.Create(Application);
  try
    with TableToCreate do
    begin
      Memo1.Lines.Add('Creando Tabla : ' + tablasbd[1]);
      DatabaseName  :=  rutaTemp;
      TableName     :=  tablasBD[1];   //:=  TableName; //IntToStr(idUser) + BD_INVE;
      Exclusive     :=  True;
      Memo1.Lines.Add('Finaliza creacion de Tabla : ' + rutaTemp);

      if (not Exists) then
      begin
        with FieldDefs do
        begin
          Clear;
          Add('FI_CODIGO', ftString, 30, True);
          Add('FI_DESCRIPCION',ftString,150,True);
          Add('FI_CATEGORIA',ftString,30,True);
          Add('FI_SUBCATEGORIA',ftString,100);
          Add('FI_UNIDAD',ftString,30);
          Add('FI_REFERENCIA',ftString,30);
          Add('ZZCAMPO_001',ftString,60);
          Add('FI_MARCA',ftString,60);
          Add('FI_CREACION',ftDate,0);
          Add('FI_CAPACIDAD',ftCurrency);
          Add('FI_MODELO',ftString,60);
          Add('FI_PROVEEDORCOMPRANAC',ftString,10);
        end;

        with IndexDefs do
        begin
          Clear;
          Add('','FI_CODIGO',[ixPrimary, ixUnique], '', icNone, False);
          Add('FI_KEY_CAT1','FI_CATEGORIA',[], '', icNone, False);
          Add('FI_KEY_CAT2','FI_SUBCATEGORIA',[], '', icNone, False);
          Add('FI_KEY_PROV','FI_PROVEEDORCOMPRANAC',[], '', icNone, False);
          Add('FI_KEY_MARC','FI_MARCA',[], '', icNone, False);
        end;
            CreateTable(0,1,0,False,'','',4096,512,0)
      end;

    end;

   finally
      TableToCreate.Free;
   end;
end;


{----------------------------------------------------------------------------2
     CREACION DE TABLA TEMPORAL PARA DATOS DE PROVEEDORES
}
procedure TfMainReport.crearTablaTMP_Prove(idUser: Integer);
var
  TableToCreate: TDBISAMTable;

begin
  TableToCreate :=  TDBISAMTable.Create(Application);
  try
    with TableToCreate do
    begin
      DatabaseName :=  rutaTemp;
      TableName    :=  tablasBD[2] ; //IntToStr(idUser) + BD_PROV;
      Exclusive    :=  True;
      //tablasBD[2]  :=  TableName;

      if (not Exists) then
      begin
        with FieldDefs do
        begin
          Clear;
          Add('FP_CODIGO',ftString,30,True);
          Add('FP_DESCRIPCION',ftString,150,True);
        end;

        with IndexDefs do
        begin
          Clear;
          Add('','FP_CODIGO',[ixPrimary, ixUnique], '', icNone, False);
          Add('FP_KEYCODIGO','FP_CODIGO',[], '', icNone, False);
        end;

        CreateTable(0,1,0,False,'','',4096,512,0)
      end;
    end;

  finally
      TableToCreate.Free;
  end;

end;


{ ----------------------------------------------------------------------------3
     CREACION DE TABLA TEMPORAL PARA DATOS DE CATEGORIAS
}
procedure TfMainReport.crearTablaTMP_Categ(idUser: Integer);
var
  TableToCreate: TDBISAMTable;

begin
  TableToCreate :=  TDBISAMTable.Create(Application);
  try
    with TableToCreate do
    begin
      DatabaseName :=  rutaTemp;
      TableName    :=  tablasBD[3]; //IntToStr(idUser) + BD_CATE;
      Exclusive    :=  True;

      if (not Exists) then
      begin
        with FieldDefs do
        begin
          Clear;
          Add('FD_CODIGO',ftString,30,True);
          Add('FD_DESCRIPCION',ftString,150,True);
        end;
        with IndexDefs do
        begin
          Clear;
          Add('','FD_CODIGO',[ixPrimary, ixUnique], '', icNone, False);
          Add('FD_KEYCODIGO','FD_CODIGO',[], '', icNone, False);
        end;
        CreateTable(0,1,0,False,'','',4096,512,0)
      end;
    end;

   finally
      TableToCreate.Free;
   end;

end;


{----------------------------------------------------------------------------4
     CREACION DE TABLA TEMPORAL PARA DATOS DE SUBCATEGORIAS
}
procedure TfMainReport.crearTablaTMP_SubCa(idUser: Integer);
var
  TableToCreate: TDBISAMTable;

begin
  TableToCreate :=  TDBISAMTable.Create(Application);
  try
    with TableToCreate do
    begin
      DatabaseName :=  rutaTemp;
      TableName    :=  tablasBD[4] ; //IntToStr(idUser) + BD_SUBC;
      Exclusive    :=  True;

      if (not Exists) then
      begin
        with FieldDefs do
        begin
          Clear;
          Add('FDS_CODIGO',ftString,30,True);
          Add('FDS_DESCRIPCION',ftString,150,True);
        end;
        with IndexDefs do
        begin
          Clear;
          Add('','FDS_CODIGO',[ixPrimary, ixUnique], '', icNone, False);
          Add('FDS_KEYCODIGO','FDS_CODIGO',[], '', icNone, False);
        end;

        CreateTable(0,1,0,False,'','',4096,512,0)
      end;
    end;

   finally
      TableToCreate.Free;
  end;

end;


{----------------------------------------------------------------------------5
     CREACION DE TABLA TEMPORAL PARA DATOS DE MARCAS
}
procedure TfMainReport.crearTablaTMP_Marca(idUser: Integer);
var
  TableToCreate: TDBISAMTable;

begin
  TableToCreate :=  TDBISAMTable.Create(Application);
  try
    with TableToCreate do
    begin
      DatabaseName :=  rutaTemp;
      TableName    :=  tablasBD[5]; //IntToStr(idUser) + BD_MARC;
      Exclusive    :=  True;

      if (not Exists) then
      begin
        with FieldDefs do
        begin
          Clear;
          Add('FMA_CODIGO',ftString,30,True);
          Add('FMA_DESCRIPCION',ftString,150,True);
        end;

        with IndexDefs do
        begin
          Clear;
          Add('','FMA_CODIGO',[ixPrimary, ixUnique], '', icNone, False);
          Add('FMA_KEYCODIGO','FMA_CODIGO',[], '', icNone, False);
        end;

        CreateTable(0,1,0,False,'','',4096,512,0)
      end;
    end;

  finally
      TableToCreate.Free;
  end;

end;


{----------------------------------------------------------------------------6
     CREACION DE TABLA TEMPORAL PARA DATOS DE EPOSITOS
}
procedure TfMainReport.crearTablaTMP_Depo(idUser: Integer);
var
  TableToCreate: TDBISAMTable;

begin
  TableToCreate :=  TDBISAMTable.Create(Application);
  try
    with TableToCreate do
    begin
      DatabaseName :=  rutaTemp;
      TableName    :=  tablasBD[6]; // IntToStr(idUser) + BD_DEPO;
      Exclusive    :=  True;

      if (not Exists) then
      begin
        with FieldDefs do
        begin
          Clear;
          Add('FD_CODIGO',ftInteger);
          Add('FD_DESCRIPCION',ftString,150,True);
        end;

        with IndexDefs do
        begin
          Clear;
          Add('','FD_CODIGO',[ixPrimary, ixUnique], '', icNone, False);
          Add('FD_KEYCODIGO','FD_CODIGO',[], '', icNone, False);
        end;

        CreateTable(0,1,0,False,'','',4096,512,0)
      end;
    end;

  finally
      TableToCreate.Free;
  end;

end;


{----------------------------------------------------------------------------7
     CREACION DE TABLA TEMPORAL PARA DATOS PROVEEDOR INVENTARIO (COMPRAS)
}
procedure TfMainReport.crearTablaTMP_Compr(idUser: Integer);
var
  TableToCreate: TDBISAMTable;

begin
  TableToCreate :=  TDBISAMTable.Create(Application);
  try
    with TableToCreate do
    begin
      DatabaseName :=  rutaTemp;
      TableName    :=  tablasBD[7]; //IntToStr(idUser) + BD_COMP;
      Exclusive    :=  True;

      if (not Exists) then
      begin
        with FieldDefs do
        begin
          Clear;
          Add('FIP_CODIGO',ftString,50);
          Add('FIP_PROVEEDOR',ftString,60);
          Add('FIP_NOMBREPROV',ftString,150,True);
          Add('FIP_COSTOCOMPRA',ftFloat);
          Add('FIP_CANTIDAD',ftFloat);
          Add('FIP_FECHA',ftDate,0,True);
        end;
        with IndexDefs do
        begin
          Clear;
          Add('','FIP_CODIGO',[ixPrimary, ixUnique], '', icNone, False);
          Add('FIP_KEYCODIGO','FIP_CODIGO',[], '', icNone, False);
          Add('FIP_KEYPROV','FIP_PROVEEDOR',[], '', icNone, False);
        end;
        CreateTable(0,1,0,False,'','',4096,512,0)
        end;
    end;

   finally
      TableToCreate.Free;
   end;

end;


{----------------------------------------------------------------------------8
     CREACION DE TABLA TEMPORAL PARA DATOS NOTAS DE ENTREGA PENDIENTE
}
procedure TfMainReport.crearTablaTMP_NotaE(idUser: Integer);
var
  TableToCreate: TDBISAMTable;

begin
  TableToCreate :=  TDBISAMTable.Create(Application);
  try
    with TableToCreate do
    begin
      DatabaseName :=  rutaTemp;
      TableName    :=  tablasBD[8]; //IntToStr(idUser) + BD_NENT;
      Exclusive    :=  True;

      if (not Exists) then
      begin
        with FieldDefs do
        begin
          Clear;
          Add('FNE_CODIGO',ftString,50);
          Add('FNE_PROVEEDOR',ftString,60);
          Add('FNE_NOMBREPROV',ftString,150,True);
          Add('FNE_CANTIDAD',ftFloat);
          Add('FNE_FECHA',ftDate,0,True);
        end;

        with IndexDefs do
        begin
          Clear;
          Add('','FNE_CODIGO',[ixPrimary, ixUnique], '', icNone, False);
          Add('FNE_KEYCODIGO','FNE_CODIGO',[], '', icNone, False);
          Add('FNE_KEYPROV','FNE_NOMBREPROV',[], '', icNone, False);
        end;

        CreateTable(0,1,0,False,'','',4096,512,0)
      end;
    end;

  finally
      TableToCreate.Free;
  end;

end;


{----------------------------------------------------------------------------9
     CREACION DE TABLA TEMPORAL PARA DATOS EXISTENCIA ALMACENES DE INVENTARIO
}
procedure TfMainReport.crearTablaTMP_InvDe(idUser: Integer);
var
  TableToCreate: TDBISAMTable;

begin
  TableToCreate :=  TDBISAMTable.Create(Application);
  try
    with TableToCreate do
    begin
      DatabaseName :=  rutaTemp;
      TableName    :=  tablasBD[9]; //IntToStr(idUser) + BD_INVD;
      Exclusive    :=  True;

      if (not Exists) then
      begin
        with FieldDefs do
        begin
          Clear;
          Add('FID_CODIGO',ftString,50);
          Add('FID_ALMACEN',ftFloat);
          Add('FID_TIENDA',ftFloat);
          Add('FID_INSUMOS',ftFloat);
          Add('FID_DEFECTOS',ftFloat);
          Add('FID_MEZZANINA',ftFloat);
          Add('FID_CCERAMICO',ftFloat);
          Add('FID_CONSTRUCT',ftFloat);
          Add('FID_EXISTENCIAP',ftFloat);
          Add('FID_OCALMACEN',ftFloat);
          Add('FID_OCTIENDA',ftFloat);
        end;
        with IndexDefs do
        begin
          Clear;
          Add('','FID_CODIGO',[ixPrimary, ixUnique], '', icNone, False);
          Add('FID_KEYCODIGO','FID_CODIGO',[], '', icNone, False);
        end;

        CreateTable(0,1,0,False,'','',4096,512,0);
      end;
    end;

  finally
    TableToCreate.Free;
  end;

end;


{----------------------------------------------------------------------------10
     CREACION DE TABLA TEMPORAL PARA ALMACENAR LAS VENTAS ULTIMOS 6 MESES
}
procedure TfMainReport.crearTablaTMP_VtaAc(idUser: Integer);
var
  TableToCreate: TDBISAMTable;

begin
  TableToCreate :=  TDBISAMTable.Create(Application);
  try
    with TableToCreate do
    begin
      DatabaseName :=  rutaTemp;
      TableName    :=  tablasBD[10]; //IntToStr(idUser) + BD_VTAA;
      Exclusive    :=  True;

      if (not Exists) then
      begin
        with FieldDefs do
        begin
          Clear;
          Add('FVA_CODIGO',ftString,50);
          Add('FVA_PERIODO1',ftFloat);
          Add('FVA_PERIODO2',ftFloat);
          Add('FVA_PERIODO3',ftFloat);
          Add('FVA_PERIODO4',ftFloat);
          Add('FVA_PERIODO5',ftFloat);
          Add('FVA_PERIODO6',ftFloat);
          Add('FVA_PERIODODATA',ftFloat);

        end;
        with IndexDefs do
        begin
          Clear;
          Add('','FVA_CODIGO',[ixPrimary, ixUnique], '', icNone, False);
          Add('FVA_KEYCODIGO','FVA_CODIGO',[], '', icNone, False);
        end;

        CreateTable(0,1,0,False,'','',4096,512,0)
      end;
    end;

   finally
      TableToCreate.Free;
  end;

end;


{----------------------------------------------------------------------------11
     CREACION DE TABLA TEMPORAL PARA ALMACENAR LAS VENTAS ULTIMOS 6 MESES
}
procedure TfMainReport.crearTablaTMP_VtaDe(idUser: Integer; tabla : String);
var
  TableToCreate: TDBISAMTable;

begin
  TableToCreate :=  TDBISAMTable.Create(Application);
  try
    with TableToCreate do
    begin
      DatabaseName :=  rutaTemp;
      TableName    :=  tabla; //IntToStr(idUser) + BD_VTAD;
      Exclusive    :=  True;

      if (not Exists) then
      begin
        with FieldDefs do
        begin
          Clear;
          Add('FVD_AUTO',ftAutoInc);
          Add('FVD_CODIGO',ftString,50);
          Add('FVD_DEPOSITO',ftInteger);
          Add('FVD_CANTIDAD',ftFloat);

          Add('FVD_MTOBRUTO',ftCurrency);
          Add('FVD_DESCUENTO',ftCurrency);
          Add('FVD_MTONETO',ftCurrency);
          Add('FVD_IVA',ftCurrency);
          Add('FVD_COSTO',ftCurrency);
          Add('FVD_UTILIDADM',ftCurrency);
          Add('FVD_UTILIDADP',ftFloat);

        end;
        with IndexDefs do
        begin
          Clear;
          Add('','FVD_AUTO',[ixPrimary, ixUnique ], '', icNone, False);
          Add('FVD_KEYCODIGO','FVD_CODIGO',[], '', icNone, False);
        end;

        CreateTable(0,1,0,False,'','',4096,512,0)
      end;
    end;

   finally
      TableToCreate.Free;
  end;

end;



procedure TfMainReport.descomprimirArchivo(const CompressedFile, OutputPath: string);
var
  FileStream: TFileStream;
  Decompressor: TZDecompressionStream;
  OutputFileStream: TFileStream;
begin
  FileStream := TFileStream.Create(CompressedFile, fmOpenRead);
  try
    // Crear el stream descomprimido
    Decompressor := TZDecompressionStream.Create(FileStream);
    try
      OutputFileStream := TFileStream.Create(OutputPath + 'reporte_descomprimido', fmCreate);
      try
        OutputFileStream.CopyFrom(Decompressor, 0);
      finally
        OutputFileStream.Free;
      end;
    finally
      Decompressor.Free;
    end;
  finally
    FileStream.Free;
  end;

end;


function TfMainReport.encapsularPeriodo(t: TDate): string;
var
  D, M, Y, i,j : Integer;
  Ds, Ms, Ys : string;

  text, textDs, textMs, textYs : string;

begin
  D := CONVD * (DayOf(t));
  M := CONVM * (MonthOf(t));
  Y := CONVY * (YearOf(t));

  Ds := Format(Format('%%.%dd', [8]), [D]);
  Ms := Format(Format('%%.%dd', [8]), [M]);
  Ys := Format(Format('%%.%dd', [8]), [Y]);

  for i:=1 to Length(Ds) do
  begin
    for j := 1 to Length(Ds) do
    begin
      if j = StrToInt(CLAVE_D[i]) then
        text := text + Ds[i]
      else
        text := text + char(Random(31)+40);

      textDs := text
    end;

  end;

  text := '';

  for i:=1 to Length(Ms) do
  begin
    for j := 1 to Length(Ms) do
    begin
      if j = StrToInt(CLAVE_M[i]) then
        text := text + Ms[i]
      else
        text := text + char(Random(31)+40);

      textMs := text
    end;
  end;

  text := '';

  for i:=1 to Length(Ys) do
  begin
    for j := 1 to Length(Ys) do
    begin
      if j = StrToInt(CLAVE_Y[i]) then
        text := text + Ys[i]
      else
        text := text + char(Random(31)+40);

      textYs := text
    end;
  end;
  Memo1.Lines.Add(textDs + textMs + textYs);

end;


procedure TfMainReport.encapsularPeriodo2(t: string);
var
  I,J, indClave : Integer;

  cadenaBlock, texto  : string;
  block :  Array[1..3] of string;
  block2 : Array[1..3] of string;

  D, M, Y : Integer;

begin
  J := 1;

  try
    begin
      for I := 1 to Length(t)  do
      begin
        if (I mod 64) = 0 then
        begin
          texto     := texto + t[i];
          block[J]  := texto;
          texto     := '';
          inc(J);
        end
        else
          texto := texto + t[i];
      end;
      texto := '';

      for i := 1 to 3 do
      begin
        cadenaBlock := block[i];
        indClave := 0;

        for j := 1 to 64 do
        begin
          if (j mod 8) = 0 then
          begin
            Inc(indClave);
            texto := texto + cadenaBlock[j];

            case i of
              1: block2[i] :=  block2[i] + Copy( texto, StrToInt(CLAVE_D[indClave]), 1);
              2: block2[i] :=  block2[i] + Copy( texto, StrToInt(CLAVE_M[indClave]), 1);
              3: block2[i] :=  block2[i] + Copy( texto, StrToInt(CLAVE_Y[indClave]), 1);
            end;
            texto := '';
          end
          else
            texto := texto + cadenaBlock[j];
        end;
      end;

      D := StrToInt(block2[1]) div CONVD;
      M := StrToInt(block2[2]) div CONVM;
      Y := StrToInt(block2[3]) div CONVY;

      fechaTope :=  EncodeDate(Y,M,D);
      memo1.Lines.Add('Cadena : ' + t);
      memo1.Lines.Add('Fecha : ' + DateToStr(fechaTope));

    end;
  Except
    on E : Exception do
    begin
      MessageBox(0, 'Error en la lectura de la Clave Cadena', 'Warning', MB_OK);
      fMainReport.Close;
    end;


  end;

end;

{function TfMainReport.EsFechaValida(Fecha: TDateTime): Boolean;
{begin
  Result := (Fecha <> 0) and (Fecha > EncodeDate(1900, 1, 1)) and (Fecha <= Now);
end;}


procedure TfMainReport.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //ShowMessage('CERRANDO 01');
end;

procedure TfMainReport.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
//var
  //IniFile     : TIniFile;
  //variableSQL : string;

begin
  //ShowMessage('CERRANDO');

  borrarTablaTmp(userIndex);

  {archivoINI  := ExtractFilePath(ParamStr(0)) + 'config.ini';
  IniFile     := TIniFile.Create(archivoINI);


  try
    variableSQL := IniFile.ReadString('CONSULTA', 'SQL', '');

    if variableSQL = '256' then
      IniFile.WriteString('CONSULTA', 'SQL', '123');

  finally
    IniFile.Free;
  end;}

end;


procedure TfMainReport.FormCreate(Sender: TObject);
//var
//  i: integer;
begin
  accesoPermitido := False;
  flagDpto        := False;
  flagVend        := False;
  flagDepo        := False;

  getVariableEntorno;
  Memo1.Lines.Add(rutaData);
  Memo1.Lines.Add(rutaTemp);
  //Memo1.Lines.Add(report01);
  //Memo1.Lines.Add(report02);
  Memo1.Lines.Add(IntToStr(nPeriodo));
  Memo1.Lines.Add(DateToStr(fechaInicio));

  mesFin  := MonthOf(Now)-1;
  yearFin := YearOf(Now);

  case MonthOf(Now) of
    1..6:
      begin
        mesIni  := mesFin + 7;
        yearIni := YearOf(Now) - 1;
      end;
    7..12:
      begin
        mesIni  := mesFin - 5;
        yearIni := YearOf(Now);
      end;
  end;

  dtpFechaIniCom.MinDate := encodeDate(yearIni,mesIni,1);
  dtpFechaIniCom.MaxDate := EndOfAMonth(yearFin, mesFin);
end;


procedure TfMainReport.FormShow(Sender: TObject);
begin
  fSplash.ShowModal;

  if Length(claveCadena) <> 192 then
  begin
    MessageBox(0, 'Error en la lectura de la Clave Cadena', 'Warning', MB_OK);
      fMainReport.Close;
  end
  else
  begin
    encapsularPeriodo2(claveCadena);
    //ShowMessage('Fecha Actual : ' + DateToStr(Now) + #13#10 +
    //            'Fecha Tope   : ' + DateToStr(fechaTope) );

    if Now > fechaTope  then
    begin
      MessageBox(0, 'La fecha ha Expirado', 'Warning', MB_OK);
      fMainReport.Close;
    end;

  end;

  if accesoPermitido = True then
  begin
    if usuarioTieneAcceso = False then
    begin
      MessageBox(0, 'Este usuario no puede ver reportes', 'Warning', MB_OK);
      fMainReport.Close;
    end;
    asignarTablas_Posicion;
  end
  else
    Close;

end;


procedure TfMainReport.getVariableEntorno;
var
  IniFile     : TIniFile;
  variableSQL : string;

begin
  archivoINI  := ExtractFilePath(ParamStr(0)) + 'config.ini';
  IniFile     := TIniFile.Create(archivoINI);

  try
    rutaData    := IniFile.ReadString('RUTAS', 'DATA', '');
    rutaTemp    := IniFile.ReadString('RUTAS', 'TEMP', '');
    rutaServer  := IniFile.ReadString('RUTAS', 'SERVER', '');
    portServer  := IniFile.ReadString('RUTAS', 'PORT', '');

    reportComAc := IniFile.ReadString('REPORT', 'REPORTCOMAC', '');
    reportComEx := IniFile.ReadString('REPORT', 'REPORTCOMEX', '');
    reportVtaAc := IniFile.ReadString('REPORT', 'REPORTVTAAC', '');

    nPeriodo    := IniFile.ReadInteger('PERIODOS', 'PERIODO', 0);
    fechaInicio := IniFile.ReadDate('PERIODOS', 'FINICIO', now);

    claveCadena := IniFile.ReadString('SERIAL', 'CADENA', '');

    variableSQL := IniFile.ReadString('CONSULTA', 'SQL', '');

    if variableSQL <> '256' then
      IniFile.WriteString('CONSULTA', 'SQL', '256');


    with DM.a2DATA do
    begin
      Connected := false;
      Directory := rutaData;
      Connected := True;
    end;


  finally
    IniFile.Free;
  end;

end;


{
****************************************************************************************************
    INSERTANDO DATOS EN LAS TABLAS TEMPORALES
****************************************************************************************************
}

{----------------------------------------------------------------------------
     INSERTANDO DATOS DE CATEGORIAS
}
procedure TfMainReport.importarDataHAC;
var
  HTTPClient  : TNetHTTPClient;
  Response    : IHTTPResponse;
  FileStream  : TFileStream;
  URL,
  //ExtractPath,
  FilePath    : string;
  ZipFile     : TZipFile;
  j           : Integer;
  flag        : Boolean;

begin

  // Define la URL y la ruta donde se guardar� el archivo
  URL         := 'http://' + rutaServer + ':' + portServer + '/download_reporte/';
  FilePath    := rutaTemp + '\reporte.zip'; // Puedes cambiar el nombre del archivo si es necesario
  flag        := False;
  HTTPClient  := TNetHTTPClient.Create(nil);

  if verificarBDHoy(rutaTemp + '\SOperacionInv.dat') = False then
  begin
    try
      // Crea el stream para guardar el archivo
      FileStream := TFileStream.Create(FilePath, fmCreate);
      try
        // Realiza la solicitud GET para descargar el archivo
        Response := HTTPClient.Get(URL, FileStream);
        // Verifica si la respuesta fue exitosa (c�digo HTTP 200)
        if Response.StatusCode = 200 then
          flag := True
        else
          ShowMessage('Error al Importar DATA : ' + Response.StatusText);
      finally
        FileStream.Free;
      end;
    finally
      HTTPClient.Free;
    end;

    if TZipFile.IsValid(FilePath) then
    begin
      //ShowMessage('Descomprmir ZIP');
      ZipFile := TZipFile.Create;
      try
        ZipFile.Open(FilePath, zmRead);
              // Extrae todos los archivos en el archivo .zip
        for j := 0 to ZipFile.FileCount - 1 do
          ZipFile.Extract(j, rutaTemp);

              //ShowMessage('Archivo descomprimido exitosamente en ' + ExtractPath);
            finally
        ZipFile.Free;
      end;

      // Elimina el archivo ZIP despu�s de la descompresi�n
      if DeleteFile(FilePath) then
      begin
        flag := true;
      end;
      finalizaImport := True;
    end;
  end;

end;


procedure TfMainReport.insertTablaTMP_Categ(tabla: string);
begin
  with DM.SQL_Insert do
  begin
    Close;
    Active := False;
    SQL.Clear;

    Memo1.Lines.Add('================== Insertando Categoria ==================');
    SQL.Add('INSERT INTO ' + tabla);
    SQL.Add('SELECT  FD_CODIGO, FD_DESCRIPCION');
    SQL.Add('FROM ' + #34 + rutaData + '\SCATEGORIA"');
    SQL.Add('WHERE FD_CODIGO IS NOT NULL');
    SQL.Add('ORDER BY FD_CODIGO ASC;');

    Memo1.Lines.Add(SQL.Text);
    ExecSQL;
    Close;

  end;
end;


{----------------------------------------------------------------------------
     INSERTANDO DATOS DE ULTIMA COMPRA DEL PRODUCTO
}
procedure TfMainReport.insertTablaTMP_Compr(tabla: string);
begin
  with DM.SQL_Insert do
  begin
    Close;
    Active := False;
    SQL.Clear;

    Memo1.Lines.Add('================== Insertando Compras ================== ' + tabla);
    SQL.Add('INSERT INTO ' + tabla);
    SQL.Add('SELECT FTP_CODEPRODUCTO, FTP_CODPROVEEDOR, ');
    SQL.Add('   FP_DESCRIPCION, FTP_ULTCOSTO, ');
    SQL.Add('   FTP_ULTCANTIDAD, FTP_FECHACOMPRA');
    SQL.Add('FROM "' + rutaTemp + '\SPROVINVENT"');

    SQL.Add('INNER JOIN "' + rutaData + '\SPROVEEDOR" ON FTP_CODPROVEEDOR = FP_CODIGO');
    SQL.Add('GROUP BY FTP_CODEPRODUCTO');
    SQL.Add('ORDER BY FTP_CODEPRODUCTO');

    Memo1.Lines.Add(SQL.Text);
    ExecSQL;
    Close;
  end;
end;


{----------------------------------------------------------------------------
     INSERTANDO DATOS DE EXISTENCIAS SEEGUN DEPOSITOS
}
procedure TfMainReport.insertTablaTMP_InvDe(tabla: string);
begin
  with DM.SQL_Insert do
  begin
    Close;
    Active := False;
    SQL.Clear;

    Memo1.Lines.Add('================== Insertando Existencia Depositos ==================');
    SQL.Add('INSERT INTO ' + tabla);
    SQL.Add('SELECT FT_CODIGOPRODUCTO,');
    SQL.Add('   SUM(CASE WHEN FT_CODIGODEPOSITO = 1 THEN COALESCE(FT_EXISTENCIA, 0.0) ELSE 0 END) AS ALMACEN,');
    SQL.Add('   SUM(CASE WHEN FT_CODIGODEPOSITO = 2 THEN COALESCE(FT_EXISTENCIA, 0.0) ELSE 0 END) AS TIENDA,');
    SQL.Add('   SUM(CASE WHEN FT_CODIGODEPOSITO = 3 THEN COALESCE(FT_EXISTENCIA, 0.0) ELSE 0 END) AS INSUMOS,');
    SQL.Add('   SUM(CASE WHEN FT_CODIGODEPOSITO = 5 THEN COALESCE(FT_EXISTENCIA, 0.0) ELSE 0 END) AS DEFECTOS,');
    SQL.Add('   SUM(CASE WHEN FT_CODIGODEPOSITO = 6 THEN COALESCE(FT_EXISTENCIA, 0.0) ELSE 0 END) AS MEZZANINA,');
    SQL.Add('   SUM(CASE WHEN FT_CODIGODEPOSITO = 7 THEN COALESCE(FT_EXISTENCIA, 0.0) ELSE 0 END) AS CCERAMICO,');
    SQL.Add('   SUM(CASE WHEN FT_CODIGODEPOSITO = 8 THEN COALESCE(FT_EXISTENCIA, 0.0) ELSE 0 END) AS CONSTRUCT,');
    SQL.Add('   SUM(COALESCE(FT_EXISTENCIA, 0.0)) AS EXISTENCIAP,');
    SQL.Add('   SUM(CASE WHEN FT_CODIGODEPOSITO = 1 THEN COALESCE(FT_EXISTENCIAORDENCOMPRA, 0.0) ELSE 0 END) AS [OC. ALMACEN],');
    SQL.Add('   SUM(CASE WHEN FT_CODIGODEPOSITO = 2 THEN COALESCE(FT_EXISTENCIAORDENCOMPRA, 0.0) ELSE 0 END) AS [OC. TIENDA]');

    SQL.Add('FROM "' + rutaTemp + '\SINVDEP"');
    SQL.Add('GROUP BY FT_CODIGOPRODUCTO');
    SQL.Add('ORDER BY FT_CODIGOPRODUCTO ASC');

    Memo1.Lines.Add(SQL.Text);
    ExecSQL;
    Close;
  end;
end;


{----------------------------------------------------------------------------1
     INSERTANDO DATOS DE INVENTARIO
}
procedure TfMainReport.insertTablaTMP_Inven(tabla: string);
begin
  with DM.SQL_Insert do
  begin
    Close;
    Active := False;
    SQL.Clear;

    Memo1.Lines.Add('================== Insertando Inventario ==================');
    SQL.Add('INSERT INTO ' + tabla);
    SQL.Add('SELECT FI_CODIGO, FI_DESCRIPCION, FI_CATEGORIA, FI_SUBCATEGORIA,');
    SQL.Add('   FI_UNIDAD, FI_REFERENCIA, ZZCAMPO_001, FI_MARCA,');
    SQL.Add('   COALESCE(FI_CREACION, ' + QuotedStr('1974-09-24') + '), ');
    SQL.Add('   FI_CAPACIDAD, FI_MODELO, FI_PROVEEDORCOMPRANAC');

    SQL.Add('FROM "' + rutaTemp + '\SINVENTARIO"');
    SQL.Add('WHERE FI_CODIGO IS NOT NULL ');

    if tipoReport = 1 then
      if chkStatus_Inv.Checked = True then
        SQL.Add('   AND FI_STATUS IN (0, 1) ')
      else
        SQL.Add('   AND FI_STATUS IN (1) ')
    else
      if chkProductosInactivos.Checked = True then
        SQL.Add('   AND FI_STATUS IN (0, 1) ')
      else
        SQL.Add('   AND FI_STATUS IN (1) ');

    SQL.Add('ORDER BY FI_CODIGO');

    Memo1.Lines.Add(SQL.Text);
    //Active := True;
    ExecSQL;
    Close;
    Memo1.Lines.Add('Finalizado Insertando Inventario');
  end;
end;


{----------------------------------------------------------------------------
     INSERTANDO DATOS DE MARCAS
}
procedure TfMainReport.insertTablaTMP_Marca(tabla: string);
begin
  with DM.SQL_Insert do
  begin
    Close;
    Active := False;
    SQL.Clear;
    Memo1.Lines.Add('================== Insertando Marcas ==================');
    SQL.Add('INSERT INTO ' + tabla);
    SQL.Add('SELECT FCMM_CODIGO, FCMM_DESCRIPCION');
    SQL.Add('FROM ' + #34 + rutaData + '\CMS_MARCAS"');
    SQL.Add('WHERE FCMM_CODIGO IS NOT NULL');
    SQL.Add('ORDER BY FCMM_CODIGO ASC;');

    Memo1.Lines.Add(SQL.Text);
    ExecSQL;
    Close;

  end;
end;


{----------------------------------------------------------------------------
     INSERTANDO DATOS DE ULTIMA COMPRA DEL PRODUCTO
}
procedure TfMainReport.insertTablaTMP_NotaE(tabla: string);
begin
  with DM.SQL_Insert do
  begin
    Close;
    Active := False;
    SQL.Clear;

    Memo1.Lines.Add('================== Insertando Nota Entrega ==================');
    SQL.Add('INSERT INTO ' + tabla);
    SQL.Add('SELECT FDI_CODIGO, FDI_CLIENTEPROVEEDOR,');
    SQL.Add(QuotedStr('X') + ', FDI_CANTIDAD,');
    SQL.Add('   MAX(FDI_FECHAOPERACION) AS FECHA');

    SQL.Add('FROM "' + rutaTemp + '\SDETALLECOMPRA"');
    SQL.Add('WHERE FDI_TIPOOPERACION = 8 AND FDI_STATUS = 4 ');
    SQL.Add('GROUP BY FDI_CODIGO');
    SQL.Add('ORDER BY FDI_CODIGO ASC');

    Memo1.Lines.Add(SQL.Text);
    ExecSQL;
    Close;

    {----------------------------------------------------------------------------
     ACTUALIZA EL PROVEEDOR EN LA TABLA tmp_NotaE}
    //ShowMessage('Modifiando');
    SQL.Clear;
    SQL.Add('UPDATE ' + tabla);
    SQL.Add('SET FNE_NOMBREPROV = FP_DESCRIPCION');

    SQL.Add('FROM ' + tabla);
    SQL.Add('INNER JOIN "' + rutaTemp + '\' + tablasBD[2] + '" ON FNE_PROVEEDOR = FP_CODIGO');

    Memo1.Lines.Add(SQL.Text);
    ExecSQL;
    Close;

  end;

end;


{----------------------------------------------------------------------------
     INSERTANDO DATOS DE PROVEEDORES
}
procedure TfMainReport.insertTablaTMP_Prove(tabla: string);
begin
  with DM.SQL_Insert do
  begin
    Close;
    Active := False;
    SQL.Clear;

    Memo1.Lines.Add('================== Insertando Proveedor ==================');
    SQL.Add('INSERT INTO ' + tabla);
    SQL.Add('SELECT FP_CODIGO, FP_DESCRIPCION');
    SQL.Add('FROM "' + rutaData + '\SPROVEEDOR"');
    SQL.Add('WHERE FP_CODIGO IS NOT NULL AND FP_STATUS = 1 ');
    SQL.Add('ORDER BY FP_CODIGO ASC');

    Memo1.Lines.Add(SQL.Text);
    ExecSQL;
    Close;

  end;
end;


{----------------------------------------------------------------------------
     INSERTANDO DATOS DE SUBCATEGORIAS
}
procedure TfMainReport.insertTablaTMP_SubCa(tabla: string);
begin
  with DM.SQL_Insert do
  begin
    Close;
    Active := False;
    SQL.Clear;

    Memo1.Lines.Add('================== Insertando SubCategoria ==================');
    SQL.Add('INSERT INTO ' + tabla);
    SQL.Add('SELECT FCMS_CODIGO, FCMS_DESCRIPCION');
    SQL.Add('FROM "' + rutaData + '\CMS_Sub_Cat"');
    SQL.Add('WHERE FCMS_CODIGO IS NOT NULL');
    SQL.Add('ORDER BY FCMS_CODIGO ASC');

    Memo1.Lines.Add(SQL.Text);
    ExecSQL;
    Close;

  end;
end;


{----------------------------------------------------------------------------
     INSERTANDO DATOS DE DEPOSITOS
}
procedure TfMainReport.insertTablaTMP_Depo(tabla: string);
begin
  with DM.SQL_Insert do
  begin
    Close;
    Active := False;
    SQL.Clear;

    Memo1.Lines.Add('================== Insertando Depositos ==================');
    SQL.Add('INSERT INTO ' + tabla);
    SQL.Add('SELECT FDP_CODIGO, FDP_DESCRIPCION');
    SQL.Add('FROM "' + rutaData + '\SDEPOSITOS"');
    SQL.Add('WHERE FDP_CODIGO IS NOT NULL');
    SQL.Add('ORDER BY FDP_CODIGO ASC');

    Memo1.Lines.Add(SQL.Text);
    ExecSQL;
    Close;

  end;
end;


{----------------------------------------------------------------------------
     INSERTANDO DATOS DE EXISTENCIAS SEEGUN DEPOSITOS
}
procedure TfMainReport.insertTablaTMP_VtaAc(tabla: string);
var
  cantP : Integer;
  F1,F2 : String;

begin
  cantP := StrToInt(lblCantPeriodos.Caption);
  with DM.SQL_Insert do
  begin
    Close;
    Active := False;
    SQL.Clear;

    DateTimeToString( F1, 'yyyy-mm-dd', Periodos[1].FechaI );
    DateTimeToString( F2, 'yyyy-mm-dd', Periodos[1].FechaF );

    Memo1.Lines.Add('================== Insertando Ventas Acumuladas ==================');
    SQL.Add('INSERT INTO ' + tabla);
    SQL.Add('SELECT FDI_CODIGO,');
    SQL.Add('  SUM(CASE WHEN FDI_FECHAOPERACION BETWEEN ' + QuotedStr(F1) + ' AND ' + QuotedStr(F2) + ' THEN');
    SQL.Add('           CASE WHEN FDI_TIPOOPERACION = 11 THEN FDI_CANTIDAD ');
    SQL.Add('                WHEN FDI_TIPOOPERACION = 12 THEN FDI_CANTIDAD * -1');
    SQL.Add('           END ELSE 0.00');
    SQL.Add('      END) AS P1,');

    if (cantP >= 2) then
    begin
      DateTimeToString( F1, 'yyyy-mm-dd', Periodos[2].FechaI );
      DateTimeToString( F2, 'yyyy-mm-dd', Periodos[2].FechaF );

      SQL.Add('  SUM(CASE WHEN FDI_FECHAOPERACION BETWEEN ' + QuotedStr(F1) + ' AND ' + QuotedStr(F2) + ' THEN');
      SQL.Add('            CASE WHEN FDI_TIPOOPERACION = 11 THEN FDI_CANTIDAD ');
      SQL.Add('                 WHEN FDI_TIPOOPERACION = 12 THEN FDI_CANTIDAD * -1');
      SQL.Add('           END ELSE 0.00');
      SQL.Add('       END) AS P2,');
    end
    else
      SQL.Add('  0.00 AS P2,');

    if (cantP >= 3) then
    begin
      DateTimeToString( F1, 'yyyy-mm-dd', Periodos[3].FechaI );
      DateTimeToString( F2, 'yyyy-mm-dd', Periodos[3].FechaF );

      SQL.Add('  SUM(CASE WHEN FDI_FECHAOPERACION BETWEEN ' + QuotedStr(F1) + ' AND ' + QuotedStr(F2) + ' THEN');
      SQL.Add('            CASE WHEN FDI_TIPOOPERACION = 11 THEN FDI_CANTIDAD ');
      SQL.Add('                 WHEN FDI_TIPOOPERACION = 12 THEN FDI_CANTIDAD * -1');
      SQL.Add('            END ELSE 0.00');
      SQL.Add('       END) AS P3,');
    end
    else
      SQL.Add('  0.00 AS P3,');

    if (cantP >= 4) then
    begin
      DateTimeToString( F1, 'yyyy-mm-dd', Periodos[4].FechaI );
      DateTimeToString( F2, 'yyyy-mm-dd', Periodos[4].FechaF );

      SQL.Add('  SUM(CASE WHEN FDI_FECHAOPERACION BETWEEN ' + QuotedStr(F1) + ' AND ' + QuotedStr(F2) + ' THEN');
      SQL.Add('            CASE WHEN FDI_TIPOOPERACION = 11 THEN FDI_CANTIDAD ');
      SQL.Add('                 WHEN FDI_TIPOOPERACION = 12 THEN FDI_CANTIDAD * -1');
      SQL.Add('            END ELSE 0.00');
      SQL.Add('       END) AS P4,');
    end
    else
      SQL.Add('  0.00 AS P4,');

    if (cantP >= 5) then
    begin
      DateTimeToString( F1, 'yyyy-mm-dd', Periodos[5].FechaI );
      DateTimeToString( F2, 'yyyy-mm-dd', Periodos[5].FechaF );

      SQL.Add('  SUM(CASE WHEN FDI_FECHAOPERACION BETWEEN ' + QuotedStr(F1) + ' AND ' + QuotedStr(F2) + ' THEN');
      SQL.Add('            CASE WHEN FDI_TIPOOPERACION = 11 THEN FDI_CANTIDAD ');
      SQL.Add('                 WHEN FDI_TIPOOPERACION = 12 THEN FDI_CANTIDAD * -1');
      SQL.Add('            END ELSE 0.00');
      SQL.Add('       END) AS P5,');
    end
    else
      SQL.Add('  0.00 AS P5,');

    if (cantP >= 6) then
    begin
      DateTimeToString( F1, 'yyyy-mm-dd', Periodos[6].FechaI );
      DateTimeToString( F2, 'yyyy-mm-dd', Periodos[6].FechaF );

      SQL.Add('  SUM(CASE WHEN FDI_FECHAOPERACION BETWEEN ' + QuotedStr(F1) + ' AND ' + QuotedStr(F2) + ' THEN');
      SQL.Add('            CASE WHEN FDI_TIPOOPERACION = 11 THEN FDI_CANTIDAD ');
      SQL.Add('                 WHEN FDI_TIPOOPERACION = 12 THEN FDI_CANTIDAD * -1');
      SQL.Add('            END ELSE 0.00');
      SQL.Add('       END) AS P6,');
    end
    else
      SQL.Add('  0.00 AS P6,');

    if chkData.Checked = True then
    begin
      DateTimeToString( F1, 'yyyy-mm-dd', Periodos[7].FechaI );
      DateTimeToString( F2, 'yyyy-mm-dd', Periodos[7].FechaF );

      SQL.Add('  SUM(CASE WHEN FDI_FECHAOPERACION BETWEEN ' + QuotedStr(F1) + ' AND ' + QuotedStr(F2) + ' THEN');
      SQL.Add('            CASE WHEN FDI_TIPOOPERACION = 11 THEN FDI_CANTIDAD ');
      SQL.Add('                 WHEN FDI_TIPOOPERACION = 12 THEN FDI_CANTIDAD * -1');
      SQL.Add('            END ELSE 0.00');
      SQL.Add('       END) AS DATA');
    end
    else
      SQL.Add('0.00  AS DATA');

    //SQL.Add('FROM "' + rutaData + '\SDETALLEVENTA"');
    SQL.Add('FROM "' + rutaTemp + '\SDETALLEVENTA"');
    
    SQL.Add('WHERE FDI_TIPOOPERACION IN (11,12)');
    SQL.Add('AND FDI_STATUS = 1');
    SQL.Add('AND FDI_FECHAOPERACION BETWEEN :Fecha1 AND :Fecha2 ');

    SQL.Add('GROUP BY FDI_CODIGO');

    ParamByName('Fecha1').AsDate := dtpFechaIniCom.Date; //Periodos[7].FechaI; //wwDBDateTimePicker1.MinDate;

    //if chkData.Checked = True then
      ParamByName('Fecha2').AsDate := Periodos[7].FechaF;
    //else
    //  ParamByName('Fecha2').AsDate := wwDBDateTimePicker1.MaxDate;

    MEMO1.Lines.Add( sql.Text);
    ExecSQL;
    Close;

  end;
end;


procedure TfMainReport.insertTablaTMP_VtaDe(tabla : string; rutaDatos: string; fechaI, fechaF : TDate);
begin
  with DM.SQL_Insert do
  begin
    Close;
    Active := False;
    SQL.Clear;
    Memo1.Lines.Add('================== Insertando Detalle Venta ==================');
    SQL.Add('INSERT INTO ' + tabla + '(FVD_CODIGO, FVD_DEPOSITO, FVD_CANTIDAD, FVD_MTOBRUTO, ');
    SQL.Add('                          FVD_DESCUENTO, FVD_MTONETO, FVD_IVA, FVD_COSTO, ');
    SQL.Add('                          FVD_UTILIDADM, FVD_UTILIDADP)' );

    SQL.Add('SELECT FDI_CODIGO,');
    SQL.Add('   FDI_DEPOSITOSOURCE AS DEPOSITO,');
    SQL.Add('SUM(CASE WHEN FDI_TIPOOPERACION = 11 THEN FDI_CANTIDAD ' +
            '         WHEN FDI_TIPOOPERACION = 12 THEN FDI_CANTIDAD * -1 ' +
            '    END) AS CANTIDAD,');

    //Calcular Columna de MONTO BRUTO Aplicando compracion de Moneda USD - VES
    SQL.Add('SUM(CASE WHEN FDI_MONEDA = 1 THEN');
    SQL.Add('         CASE WHEN FDI_TIPOOPERACION = 11 THEN (FDI_CANTIDAD * FDI_PRECIOSINDESCUENTO)');
    SQL.Add('              WHEN FDI_TIPOOPERACION = 12 THEN (FDI_CANTIDAD * FDI_PRECIOSINDESCUENTO) * -1');
    SQL.Add('         END / FTI_FACTORREFERENCIA');
    SQL.Add('         WHEN FDI_MONEDA = 2 THEN');
    SQL.Add('         CASE WHEN FDI_TIPOOPERACION = 11 THEN (FDI_CANTIDAD * FDI_PRECIOSINDESCUENTO) ');
    SQL.Add('              WHEN FDI_TIPOOPERACION = 12 THEN (FDI_CANTIDAD * FDI_PRECIOSINDESCUENTO) * -1 ');
    SQL.Add('         END  END) AS [MONTO BRUTO],');

    //Calcular Columna de DESCUENTOS Aplicando compracion de Moneda USD - VES
    SQL.Add('SUM(CASE WHEN FDI_MONEDA = 1 THEN');
    SQL.Add('         CASE WHEN FDI_TIPOOPERACION = 11 THEN ((((FDI_PRECIOCONDESCUENTO * (FDI_PORCENTDESCUENTO1/100)) + ');
    SQL.Add('                                               (FDI_PRECIOCONDESCUENTO * (1-(FDI_PORCENTDESCUENTO1/100))) * ');
    SQL.Add('                                               (FDI_PORCENTDESCUENTO2/100)) + FDI_DESCUENTOPARCIAL) * ');
    SQL.Add('                                                FDI_CANTIDAD) ');
    SQL.Add('              WHEN FDI_TIPOOPERACION = 12 THEN ((((FDI_PRECIOCONDESCUENTO * (FDI_PORCENTDESCUENTO1/100)) + ');
    SQL.Add('                                              (FDI_PRECIOCONDESCUENTO * (1-(FDI_PORCENTDESCUENTO1/100))) * ');
    SQL.Add('                                               (FDI_PORCENTDESCUENTO2/100)) + FDI_DESCUENTOPARCIAL) * ');
    SQL.Add('                                                FDI_CANTIDAD) * -1 END / FTI_FACTORREFERENCIA');
    SQL.Add('         WHEN FDI_MONEDA = 2 THEN');
    SQL.Add('         CASE WHEN FDI_TIPOOPERACION = 11 THEN ((((FDI_PRECIOCONDESCUENTO * (FDI_PORCENTDESCUENTO1/100)) + ');
    SQL.Add('                                               (FDI_PRECIOCONDESCUENTO * (1-(FDI_PORCENTDESCUENTO1/100))) * ');
    SQL.Add('                                               (FDI_PORCENTDESCUENTO2/100)) + FDI_DESCUENTOPARCIAL) * ');
    SQL.Add('                                                FDI_CANTIDAD) ');
    SQL.Add('              WHEN FDI_TIPOOPERACION = 12 THEN ((((FDI_PRECIOCONDESCUENTO * (FDI_PORCENTDESCUENTO1/100)) + ');
    SQL.Add('                                              (FDI_PRECIOCONDESCUENTO * (1-(FDI_PORCENTDESCUENTO1/100))) * ');
    SQL.Add('                                               (FDI_PORCENTDESCUENTO2/100)) + FDI_DESCUENTOPARCIAL) * ');
    SQL.Add('                                                FDI_CANTIDAD) * -1 ');
    SQL.Add('    END END) AS [DESCUENTOS],');

    //Calcular Columna de MONTO NETO Aplicando compracion de Moneda USD - VES
    SQL.Add('SUM(CASE WHEN FDI_MONEDA = 1 THEN ');
    SQL.Add('     CASE WHEN FDI_TIPOOPERACION = 11 THEN (FDI_PRECIOBASECOMISION * FDI_CANTIDAD) ');
    SQL.Add('          WHEN FDI_TIPOOPERACION = 12 THEN (FDI_PRECIOBASECOMISION * FDI_CANTIDAD) * -1 ');
    SQL.Add('     END / FTI_FACTORREFERENCIA ');
    SQL.Add('     WHEN FDI_MONEDA = 2 THEN ');
    SQL.Add('     CASE WHEN FDI_TIPOOPERACION = 11 THEN (FDI_PRECIOBASECOMISION * FDI_CANTIDAD) ');
    SQL.Add('          WHEN FDI_TIPOOPERACION = 12 THEN (FDI_PRECIOBASECOMISION * FDI_CANTIDAD) * -1 ');
    SQL.Add('     END  END) AS [MONTO NETO], ');

    //Calcular Columna de IVA Aplicando compracion de Moneda USD - VES
    SQL.Add('SUM(CASE WHEN FDI_MONEDA = 1 THEN ');
    SQL.Add('     CASE WHEN FDI_TIPOOPERACION = 11 THEN (FDI_PRECIOBASECOMISION * FDI_CANTIDAD * (FDI_IMPUESTO1/100)) ');
    SQL.Add('          WHEN FDI_TIPOOPERACION = 12 THEN (FDI_PRECIOBASECOMISION * FDI_CANTIDAD * (FDI_IMPUESTO1/100)) * -1 ');
    SQL.Add('     END / FTI_FACTORREFERENCIA ');
    SQL.Add('     WHEN FDI_MONEDA = 2 THEN ');
    SQL.Add('     CASE WHEN FDI_TIPOOPERACION = 11 THEN (FDI_PRECIOBASECOMISION * FDI_CANTIDAD * (FDI_IMPUESTO1/100)) ');
    SQL.Add('          WHEN FDI_TIPOOPERACION = 12 THEN (FDI_PRECIOBASECOMISION * FDI_CANTIDAD * (FDI_IMPUESTO1/100)) * -1 ');
    SQL.Add('     END END) AS [I.V.A.],');

    //Calcular Columna de COSTOS Aplicando compracion de Moneda USD - VES
    SQL.Add('SUM(CASE WHEN FDI_MONEDA = 1 THEN ');
    SQL.Add('     CASE WHEN FDI_TIPOOPERACION = 11 THEN (FDI_CANTIDAD * FDI_COSTODEVENTAS) ');
    SQL.Add('          WHEN FDI_TIPOOPERACION = 12 THEN (FDI_CANTIDAD * FDI_COSTODEVENTAS) * -1 ');
    SQL.Add('     END / FTI_FACTORREFERENCIA ');
    SQL.Add('     WHEN FDI_MONEDA = 2 THEN ');
    SQL.Add('     CASE WHEN FDI_TIPOOPERACION = 11 THEN (FDI_CANTIDAD * FDI_COSTODEVENTAS) ');
    SQL.Add('          WHEN FDI_TIPOOPERACION = 12 THEN (FDI_CANTIDAD * FDI_COSTODEVENTAS) * -1 ');
    SQL.Add('     END  END) AS COSTOS, ');

     //Calcular Columna de UTILIDAD Aplicando compracion de Moneda USD - VES
    SQL.Add('SUM(CASE WHEN FDI_MONEDA = 1 THEN');
    SQL.Add('     CASE WHEN FDI_TIPOOPERACION = 11 THEN ((FDI_PRECIOBASECOMISION * FDI_CANTIDAD) -');
    SQL.Add('                                           (FDI_CANTIDAD * FDI_COSTODEVENTAS))');
    SQL.Add('          WHEN FDI_TIPOOPERACION = 12 THEN ((FDI_PRECIOBASECOMISION * FDI_CANTIDAD) - ');
    SQL.Add('                                           (FDI_CANTIDAD * FDI_COSTODEVENTAS)) * -1 ');
    SQL.Add('     END / FTI_FACTORREFERENCIA ');
    SQL.Add('     WHEN FDI_MONEDA = 2 THEN ');
    SQL.Add('     CASE WHEN FDI_TIPOOPERACION = 11 THEN ((FDI_PRECIOBASECOMISION * FDI_CANTIDAD) - ');
    SQL.Add('                                           (FDI_CANTIDAD * FDI_COSTODEVENTAS)) ');
    SQL.Add('          WHEN FDI_TIPOOPERACION = 12 THEN ((FDI_PRECIOBASECOMISION * FDI_CANTIDAD) - ');
    SQL.Add('                                           (FDI_CANTIDAD * FDI_COSTODEVENTAS)) * -1 ');
    SQL.Add('     END END) AS [UTILIDAD USD],');

    SQL.Add('0.00 AS [UTILIDAD %] ');

    SQL.Add('FROM       "' + rutaDatos + '\SDETALLEVENTA"');
    SQL.Add('INNER JOIN "' + rutaDatos + '\SOPERACIONINV"' + ' ON FDI_OPERACION_AUTOINCREMENT = FTI_AUTOINCREMENT');

    SQL.Add('WHERE FDI_TIPOOPERACION IN (11,12) ');
    SQL.Add('  AND FDI_STATUS = 1');
    SQL.Add('  AND FDI_FECHAOPERACION BETWEEN :F1 AND :F2 ');

    if chkVendedor.Checked and (cbVendedores.ItemIndex > 0)  then
    begin
      SQL.Add('AND FDI_VENDEDORASIGNADO = :VendedorID');
      ParamByName('VendedorID').AsString := QuotedStr(vendedor);
    end;

    if chkDepartamento.Checked then
    begin
      SQL.Add('AND FDI_DEPOSITOSOURCE = :Deposito ');
      ParamByName('Deposito').AsInteger := deposito;
    end;

    SQL.Add('GROUP BY FDI_CODIGO');

    ParamByName('F1').AsDate := fechaI; //dtpFechaIni.Date;
    ParamByName('F2').AsDate := fechaF; //dtpFechaFin.Date;

    Memo1.Lines.Add(SQL.Text);
    Memo1.Lines.Add('Fecha Ini : ' + DateToStr(fechaI));
    Memo1.Lines.Add('Fecha Fin : ' + DateToStr(fechaF));
    ExecSQL;
    Close;

  end;

end;


procedure TfMainReport.spbCalcularReportClick(Sender: TObject);
begin
  if CardPanel1.ActiveCardIndex  = 1 then
  begin
    if (dtpFechaIni.Date < EncodeDate(1990,1,1)) and (dtpFechaFin.Date < EncodeDate(1990,1,1)) then
      Exit;

    if chkVendedor.Checked and (cbVendedores.ItemIndex < 0) then
      Exit;

      calcularReporte(tipoReport);
  end
  else
    calcularReporte(tipoReport);
end;


procedure TfMainReport.calcularOtrasColumnasCompra;
var
  cantP : Integer;
begin
  cantP := StrToInt(lblCantPeriodos.Caption);

  with DM.SQL_Final do
  begin
    Close;
    Active := False;
    SQL.Clear;

    SQL.Add('');
    SQL.Add('SELECT  CODIGO, REFERENCIA, [REF. PROV.], [DETALLE CATEGORIA], ');
    SQL.Add('   [DETALLE SUB CAT.], [CATEGORIA], [SUB CAT.], [DESCRIPCION DEL PRODUCTO], ');

    //*******************************************************************************************
    // Si el usuario esta en la lista de Exclusion se eliminan 3 columnas 2 de Costos y 1 Utilidad
    if (Pos(IntToStr(userIndex), reportComEx) > 0)  then
      SQL.Add('   MARCA, MODELO, [PRECIO], ')
    else
      SQL.Add('   MARCA, MODELO, [COSTO PROM.], [COSTO ACTUAL], [PRECIO], [UTILIDAD %], ');

    SQL.Add('   ALMACEN, TIENDA, MEZZANINA, CCERAMICO, CONSTRUCTOR, [TOT. DISP. VTA.],');   //hasta columna 18

    SQL.Add('CASE WHEN ([VTA. PROM. MES] > 0.00) AND (ALMACEN >= 0.00) AND (TIENDA <> 0.00) THEN ');
    SQL.Add('          CAST(ROUND((([VTA. PROM. MES] / 30) * 8),0) AS VARCHAR(14))' );

    SQL.Add('     WHEN ([VTA. PROM. MES] > 1.00) AND (ALMACEN >= 1.00) AND (TIENDA = 0.00) THEN ');
    SQL.Add('          CAST(ROUND((([VTA. PROM. MES] / 30) * 8),0) AS VARCHAR(14))' );

    SQL.Add('     WHEN ([VTA. PROM. MES] > 0.00) AND (ALMACEN = 0.00) AND (TIENDA = 0.00) THEN ');
    SQL.Add(QuotedStr('Reponer - Inactivar'));

    SQL.Add('     WHEN ([VTA. PROM. MES] = 0.00) AND (ALMACEN >= 1.00) AND (TIENDA = 0.00) THEN ');
    SQL.Add(QuotedStr('Sin Venta - Enviar'));

    SQL.Add('     WHEN ([VTA. PROM. MES] > 0.00) AND (ALMACEN = 0.00) AND (TIENDA = 0.00) THEN ');
    SQL.Add(QuotedStr('Reponer - Inactivar'));
    SQL.Add('ELSE ' + QuotedStr('0') + ' END AS [MIN REQ. TIENDA], ');

    //CALCULAR COLUMNA MINIMO REQUERIDO EN TIENDA		//19
    //SQL.Add('0.00 AS [MIN REQ. TIENDA 19],  ');

    SQL.Add('    INSUMOS, DEFECTOS,	[OC. ALMACEN], [OC. TIENDA],');
    SQL.Add('    [COMPRA PROV.], [COMPRA ULT. FECHA],	[COMPRA ULT. CANT.], [RECEP. PROV.],');
    SQL.Add('    [RECEP. ULT. FECHA],	[RECEP. ULT. CANT.], [PROV. ASIGNADO], [FECHA CREACION],');
    SQL.Add('    UNIDAD, CAPACIDAD,	');

   //CALCULAR AQUI LOS MESES DE VENTAS DEL REPORTE
    SQL.Add('[' + periodos[1].Periodo + '] ');

    if (cantP >= 2) then
      SQL.Add(', [' + periodos[2].Periodo + '] ');

    if (cantP >= 3) then
      SQL.Add(', [' + periodos[3].Periodo + '] ');

    if (cantP >= 4) then
      SQL.Add(', [' + periodos[4].Periodo + '] ');

    if (cantP >= 5) then
      SQL.Add(', [' + periodos[5].Periodo + '] ');

    if (cantP = 6) then
      SQL.Add(', [' + periodos[6].Periodo + '] ');

    if chkData.Checked = True then
      SQL.Add(', [' + periodos[7].Periodo + '], ');

    SQL.Add('[VTA. PROM. MES], ');

    //calcular columna 43 Mes Inventario
    SQL.Add('CASE WHEN ([TOT. DISP. VTA.] > 0.00) AND ([VTA. PROM. MES] = 0.00) THEN 12.00 ' +
            '     WHEN ([TOT. DISP. VTA.] > 0.00) AND ([VTA. PROM. MES] > 0.00) THEN ([TOT. DISP. VTA.] / [VTA. PROM. MES]) ' +
            'ELSE 0.00 END AS [MES INVENT.] ');


    //0.00 AS [MES INVENT. 43] ');

    SQL.Add('FROM "' + rutaTemp + '\' + tablaReport + '"');

    Memo1.Lines.Add('*******************************************************');
    Memo1.Lines.Add('CALCULANDO NUEVOS CAMPOS PARA EXPORTAR');
    Memo1.Lines.Add(SQL.Text);

    Open;
  end;

end;


procedure TfMainReport.spbExportExcelClick(Sender: TObject);
begin
  spbCalcularReport.Enabled := False;
  spbExportExcel.Enabled    := False;
  lblExport.Caption         := 'Espere... Generando Exportaci�n de Datos';

  {}
  if tipoReport = 1  then
    calcularOtrasColumnasCompra
  else
    with DM.SQL_Final do
    begin
      Close;
      Active := False;
      SQL.Clear;

      SQL.Add('SELECT * FROM "' + rutaTemp + '\' + tablaReport + '"');
      Open;
    end;

  if DM.SQL_Final.RecordCount > 0 then
  begin
    ExportToExcel(DM.SQL_Final);
  end
  else
    MessageBox(0, 'Archivo sin informaci�n', 'Warning', MB_OK);

  lblExport.Caption         := '';
  spbCalcularReport.Enabled := True;
  DM.SQL_Final.Close;
end;


procedure TfMainReport.spbExportTxtClick(Sender: TObject);
begin
  spbCalcularReport.Enabled := False;
  spbExportTxt.Enabled      := False;
  lblExport.Caption         := 'Espere... Generando Exportaci�n de Datos';

  if tipoReport = 1  then
    calcularOtrasColumnasCompra
  else
    with DM.SQL_Final do
    begin
      Close;
      Active := False;
      SQL.Clear;

      SQL.Add('SELECT * FROM "' + rutaTemp + '\' + tablaReport + '"');
      Open;
    end;

  if DM.SQL_Final.RecordCount > 0 then
  begin
    ExportToTxt(DM.SQL_Final);
  end
  else
    MessageBox(0, 'Archivo sin informaci�n', 'Warning', MB_OK);

  lblExport.Caption         := '';
  spbCalcularReport.Enabled := True;
  DM.SQL_Final.Close;
end;

{
****************************************************************************************************
    UNIENDO TODOS LAS CONSULTAS EN UN SOLO REPORTE
****************************************************************************************************
}

procedure TfMainReport.consultaFinalCompras;
var
  cantP : Integer;

begin
  cantP := StrToInt(lblCantPeriodos.Caption);

  with DM.SQL_Final do
  begin
    Close;
    Active := False;
    SQL.Clear;

    SQL.Add('SELECT FI_CODIGO         AS CODIGO, ');                        //01
    SQL.Add('   FI_REFERENCIA         AS REFERENCIA ,');                    //02
    SQL.Add('   ZZCAMPO_001           AS [REF. PROV.], ');                  //03
    SQL.Add('   FD_DESCRIPCION        AS [DETALLE CATEGORIA],');            //04
    SQL.Add('   FDS_DESCRIPCION       AS [DETALLE SUB CAT.],');             //05
    SQL.Add('   FI_CATEGORIA          AS [CATEGORIA],');                    //06
    SQL.Add('   FI_SUBCATEGORIA       AS [SUB CAT.],');                     //07
    SQL.Add('   FI_DESCRIPCION        AS [DESCRIPCION DEL PRODUCTO], ');    //08

    SQL.Add('   FMA_DESCRIPCION       AS MARCA,');                          //09
    SQL.Add('   FI_MODELO             AS MODELO,');                         //10
    SQL.Add('   FIC_COSTOPROMEDIOEXTRANJERO AS [COSTO PROM.], ');           //11
    SQL.Add('   FIC_COSTOACTEXTRANJERO      AS [COSTO ACTUAL], ');          //12

    SQL.Add('   CASE WHEN (FIC_IMP01EXENTO = 1 AND FIC_IMP01MONTO = 0) THEN FIC_P01PRECIOTOTALEXT ');
    SQL.Add('           ELSE FIC_P01PRECIOTOTALEXT * (1 + (FIC_IMP01MONTO / 100)) ');
    SQL.Add('   END AS [PRECIO], ');                                        //13
    SQL.Add('   COALESCE(ROUND((((FIC_P01PRECIOTOTALEXT - FIC_COSTOPROMEDIOEXTRANJERO) ' +
            '    / FIC_P01PRECIOTOTALEXT) * 100),2),0.00) AS [UTILIDAD %], ');   //14

    SQL.Add('   IFNULL(FID_ALMACEN   THEN 0.00 ELSE FID_ALMACEN)   AS ALMACEN, ');  //15
    SQL.Add('   IFNULL(FID_TIENDA    THEN 0.00 ELSE FID_TIENDA)    AS TIENDA, ');   //16
    SQL.Add('   IFNULL(FID_MEZZANINA THEN 0.00 ELSE FID_MEZZANINA) AS MEZZANINA, ');//17
    SQL.Add('   IFNULL(FID_CCERAMICO THEN 0.00 ELSE FID_CCERAMICO) AS CCERAMICO, ');     //22
    SQL.Add('   IFNULL(FID_CONSTRUCT THEN 0.00 ELSE FID_CONSTRUCT) AS CONSTRUCTOR, ');   //23

    SQL.Add('   (IFNULL(FID_ALMACEN   THEN 0.00 ELSE FID_ALMACEN)  + ' +
            '    IFNULL(FID_TIENDA    THEN 0.00 ELSE FID_TIENDA)   + ' +
            '    IFNULL(FID_MEZZANINA THEN 0.00 ELSE FID_MEZZANINA) + ' +
            '    IFNULL(FID_CCERAMICO THEN 0.00 ELSE FID_CCERAMICO) + ' +
            '    IFNULL(FID_CONSTRUCT THEN 0.00 ELSE FID_CONSTRUCT) ) AS [TOT. DISP. VTA.], ');  //18

    //AQUI VA EL CALCULO DE DOS COLUMNAS MAS //19

    SQL.Add('   IFNULL(FID_INSUMOS   THEN 0.00 ELSE FID_INSUMOS)   AS INSUMOS, ');        //20
    SQL.Add('   IFNULL(FID_DEFECTOS  THEN 0.00 ELSE FID_DEFECTOS)  AS DEFECTOS, ');       //21
    SQL.Add('   IFNULL(FID_OCALMACEN THEN 0.00 ELSE FID_OCALMACEN)  AS [OC. ALMACEN], ');  //24
    SQL.Add('   IFNULL(FID_OCTIENDA  THEN 0.00 ELSE FID_OCTIENDA)   AS [OC. TIENDA], ');   //25

    SQL.Add('   FIP_NOMBREPROV  AS [COMPRA PROV.], ');         //26
    SQL.Add('   FIP_FECHA       AS [COMPRA ULT. FECHA], ');    //27
    SQL.Add('   FIP_CANTIDAD    AS [COMPRA ULT. CANT.], ');    //28
    //SQL.Add('   FIP_COSTOCOMPRA AS [COMPRA COSTO], ');

    SQL.Add('   FNE_NOMBREPROV  AS [RECEP. PROV.], ');        //29
    SQL.Add('   FNE_FECHA       AS [RECEP. ULT. FECHA], ');   //30
    SQL.Add('   FNE_CANTIDAD    AS [RECEP. ULT. CANT.], ');   //31

    //SQL.Add('   FI_PROVEEDORCOMPRANAC AS [PROV. CODIGO],');
    SQL.Add('   FP_DESCRIPCION        AS [PROV. ASIGNADO], '); //32

    SQL.Add('   FI_CREACION           AS [FECHA CREACION],');  //33
    SQL.Add('   FI_UNIDAD             AS UNIDAD,');            //34
    SQL.Add('   FI_CAPACIDAD          AS CAPACIDAD,   ');      //35


    SQL.Add('   IFNULL(FVA_PERIODO1 THEN 0.00 ELSE FVA_PERIODO1)    AS [' + periodos[1].Periodo + '], ');

    if (cantP >= 2) then
      SQL.Add('   IFNULL(FVA_PERIODO2 THEN 0.00 ELSE FVA_PERIODO2)    AS [' + periodos[2].Periodo + '], ');

    if (cantP >= 3) then
      SQL.Add('   IFNULL(FVA_PERIODO3 THEN 0.00 ELSE FVA_PERIODO3)    AS [' + periodos[3].Periodo + '], ');

    if (cantP >= 4) then
      SQL.Add('   IFNULL(FVA_PERIODO4 THEN 0.00 ELSE FVA_PERIODO4)    AS [' + periodos[4].Periodo + '], ');

    if (cantP >= 5) then
      SQL.Add('   IFNULL(FVA_PERIODO5 THEN 0.00 ELSE FVA_PERIODO5)    AS [' + periodos[5].Periodo + '], ');

    if (cantP = 6) then
      SQL.Add('   IFNULL(FVA_PERIODO6 THEN 0.00 ELSE FVA_PERIODO6)    AS [' + periodos[6].Periodo + '], ');

    if chkData.Checked = True then
      SQL.Add('   IFNULL(FVA_PERIODODATA THEN 0.00 ELSE FVA_PERIODODATA)    AS [' + periodos[7].Periodo + '], ');

    //AQUI SE CALCULA EL PROMEDIO SEGUN LA CANTIDAD DE MESES DEL REPORTE
    case cantP of
      1: SQL.Add(' IFNULL(FVA_PERIODO1 THEN 0.00 ELSE FVA_PERIODO1) AS [VTA. PROM. MES] ');

      2: SQL.Add(' (IFNULL(FVA_PERIODO1 THEN 0.00 ELSE FVA_PERIODO1) + ' +
                 ' IFNULL(FVA_PERIODO2 THEN 0.00 ELSE FVA_PERIODO2)) / 2 AS [VTA. PROM. MES] ' );

      3: SQL.Add(' (IFNULL(FVA_PERIODO1 THEN 0.00 ELSE FVA_PERIODO1) + ' +
                 ' IFNULL(FVA_PERIODO2 THEN 0.00 ELSE FVA_PERIODO2) + ' +
                 ' IFNULL(FVA_PERIODO3 THEN 0.00 ELSE FVA_PERIODO3)) / 3 AS [VTA. PROM. MES] ' );

      4: SQL.Add(' (IFNULL(FVA_PERIODO1 THEN 0.00 ELSE FVA_PERIODO1) + ' +
                 ' IFNULL(FVA_PERIODO2 THEN 0.00 ELSE FVA_PERIODO2) + ' +
                 ' IFNULL(FVA_PERIODO3 THEN 0.00 ELSE FVA_PERIODO3) + ' +
                 ' IFNULL(FVA_PERIODO4 THEN 0.00 ELSE FVA_PERIODO4)) / 4 AS [VTA. PROM. MES] ' );

      5: SQL.Add(' (IFNULL(FVA_PERIODO1 THEN 0.00 ELSE FVA_PERIODO1) + ' +
                 ' IFNULL(FVA_PERIODO2 THEN 0.00 ELSE FVA_PERIODO2) + ' +
                 ' IFNULL(FVA_PERIODO3 THEN 0.00 ELSE FVA_PERIODO3) + ' +
                 ' IFNULL(FVA_PERIODO4 THEN 0.00 ELSE FVA_PERIODO4) + ' +
                 ' IFNULL(FVA_PERIODO5 THEN 0.00 ELSE FVA_PERIODO5)) / 5 AS [VTA. PROM. MES] ' );

      6: SQL.Add(' (IFNULL(FVA_PERIODO1 THEN 0.00 ELSE FVA_PERIODO1) + ' +
                 ' IFNULL(FVA_PERIODO2 THEN 0.00 ELSE FVA_PERIODO2) + ' +
                 ' IFNULL(FVA_PERIODO3 THEN 0.00 ELSE FVA_PERIODO3) + ' +
                 ' IFNULL(FVA_PERIODO4 THEN 0.00 ELSE FVA_PERIODO4) + ' +
                 ' IFNULL(FVA_PERIODO5 THEN 0.00 ELSE FVA_PERIODO5) + ' +
                 ' IFNULL(FVA_PERIODO6 THEN 0.00 ELSE FVA_PERIODO6)) / 6 AS [VTA. PROM. MES] ' );
    end;

    SQL.Add('INTO "' + rutaTemp + '\' + tablaReport + '"' );

    SQL.Add('FROM "' + rutaTemp + '\' + tablasBD[1] + '"' );
    SQL.Add('LEFT JOIN "' + rutaData + '\A2InvCostosPrecios"' + ' ON FI_CODIGO             = FIC_CODEITEM');
    SQL.Add('LEFT JOIN "' + rutaTemp + '\' + tablasBD[3] + '" ON FI_CATEGORIA          = FD_CODIGO');
    SQL.Add('LEFT JOIN "' + rutaTemp + '\' + tablasBD[4] + '" ON FI_SUBCATEGORIA       = FDS_CODIGO');
    SQL.Add('LEFT JOIN "' + rutaTemp + '\' + tablasBD[2] + '" ON FI_PROVEEDORCOMPRANAC = FP_CODIGO');
    SQL.Add('LEFT JOIN "' + rutaTemp + '\' + tablasBD[5] + '" ON FI_MARCA              = FMA_CODIGO');
    SQL.Add('LEFT JOIN "' + rutaTemp + '\' + tablasBD[7] + '" ON FI_CODIGO             = FIP_CODIGO');
    SQL.Add('LEFT JOIN "' + rutaTemp + '\' + tablasBD[8] + '" ON FI_CODIGO             = FNE_CODIGO');
    SQL.Add('LEFT JOIN "' + rutaTemp + '\' + tablasBD[9] + '" ON FI_CODIGO             = FID_CODIGO');
    SQL.Add('LEFT JOIN "' + rutaTemp + '\' + tablasBD[10] + '" ON FI_CODIGO             = FVA_CODIGO');

    Memo1.Lines.Add('ULTIMA CONSULTA, AGRUPANDO TODAS LAS TABLAS');
    Memo1.Lines.Add(SQL.Text);
    Open;
    close;

  end;
end;



procedure TfMainReport.consultaFinalVentas;
begin
  with DM.SQL_Final do
  begin
    Close;
    Active := False;
    SQL.Clear;

    Memo1.Lines.Add('ULTIMA CONSULTA, MOVIMIENTO DE VENTAS DEL PERIODO');
    SQL.Add('SELECT ');
    SQL.Add('   FD_DESCRIPCION     AS [CATEGORIA DESCRIPCION],');
    SQL.Add('   FDS_DESCRIPCION    AS [SUB CAT. DESCRIPCION],');

    SQL.Add('   FI_CATEGORIA       AS [CATEGORIA COD.],');
    SQL.Add('   FI_SUBCATEGORIA    AS [SUB CAT. COD.],');


    SQL.Add('   FVD_DEPOSITO       AS [DEPOSITO COD], ');
    SQL.Add('   d.FD_DESCRIPCION   AS [DEPOSITO DESCRIPCION], ');

    SQL.Add('   FVD_CODIGO         AS [PRODUCTO COD.], ');
    SQL.Add('   FI_DESCRIPCION     AS [PRODUCTO DESRIPCION], ');

    SQL.Add('   SUM(FVD_CANTIDAD)       AS CANTIDAD, ');
    SQL.Add('   SUM(FVD_MTOBRUTO)       AS [MONTO BRUTO],');
    SQL.Add('   SUM(FVD_DESCUENTO)      AS [DESCUENTOS],');
    SQL.Add('   SUM(FVD_MTONETO)        AS [MONTO NETO],');
    SQL.Add('   SUM(FVD_IVA)            AS [I.V.A.],');
    SQL.Add('   SUM(FVD_COSTO)          AS [COSTO],');
    SQL.Add('   SUM(FVD_UTILIDADM)      AS [UTILIDAD],');
    SQL.Add('   (SUM(FVD_UTILIDADM) / SUM(FVD_MTONETO)) * 100     AS [UTILIDAD %]');

    SQL.Add('INTO "' + rutaTemp + '\' + tablaReport + '"' );
    SQL.Add('FROM "' + rutaTemp + '\' + tablasBD[11] + '"' );
    SQL.Add('LEFT  JOIN "' + rutaTemp + '\' + tablasBD[1] + '" ON FVD_CODIGO      = FI_CODIGO');
    SQL.Add('LEFT  JOIN "' + rutaTemp + '\' + tablasBD[3] + '" ON FI_CATEGORIA    = FD_CODIGO');
    SQL.Add('LEFT  JOIN "' + rutaTemp + '\' + tablasBD[4] + '" ON FI_SUBCATEGORIA = FDS_CODIGO');
    SQL.Add('INNER JOIN "' + rutaTemp + '\' + tablasBD[6] + '" d ON FVD_DEPOSITO  = d.FD_CODIGO');
    SQL.Add('GROUP BY [PRODUCTO COD.]');

    if chkDepartamento.Checked then
    begin
      if chkDeposito.Checked then
      begin
        SQL.Add('WHERE FI_CATEGORIA = :Departamento');
        SQL.Add('  AND FVD_DEPOSITO = :Deposito');
        ParamByName('Departamento').AsString  := dpto;
        ParamByName('Deposito').AsInteger     := deposito;
        Memo1.Lines.Add('**** Deposito y Departamento Activo');
      end
      else
      begin
        SQL.Add('WHERE FI_CATEGORIA = :Departamento');
        ParamByName('Departamento').AsString := dpto;
        Memo1.Lines.Add('**** Solo el Departamento est� Activo');
      end;
    end;


    if (chkDeposito.Checked) and (chkDepartamento.Checked = False) then
    begin
        SQL.Add('WHERE FVD_DEPOSITO = :Deposito');
        ParamByName('Deposito').AsInteger := deposito;
        Memo1.Lines.Add('**** Solo el Deposito est� Activo');
    end;

    Memo1.Lines.Add(SQL.Text);


    Open;
    close;
  end;

end;


procedure TfMainReport.ExportToExcel(DBQuery: TDBISAMQuery);
var
  ExcelApp    : OleVariant;
  Workbook    : OleVariant;
  Worksheet   : OleVariant;
  TablaExpor  : OleVariant;
  Column, Row : Integer;
  FieldTypes  : array of TFieldType;
  FieldNames  : array of string;
  DataArray   : Variant;
  respuesta,
  LastRow     : Integer;

Begin
  ExcelApp := CreateOleObject('Excel.Application');
  try
    ExcelApp.Visible        := False; // Ocultar la ventana de Excel
    ExcelApp.ScreenUpdating := False; // Desactivar la actualizaci�n de pantalla
    Workbook                := ExcelApp.Workbooks.Add;
    Worksheet               := Workbook.Worksheets[1];
    Worksheet.Name          := 'Datos Exportados';

    // Inicializar arreglos para nombres de campos y tipos de campos
    SetLength(FieldNames, DBQuery.FieldCount);
    SetLength(FieldTypes, DBQuery.FieldCount);

    // Configurar la tabla en la hoja de c�lculo
    // Establecer los encabezados de columna y almacenar tipos de datos
    for Column := 0 to DBQuery.FieldCount - 1 do
    begin
      FieldNames[Column]                            := DBQuery.Fields[Column].FieldName;
      FieldTypes[Column]                            := DBQuery.Fields[Column].DataType;
      Worksheet.Cells[10, Column + 2].NumberFormat  := '@';
      Worksheet.Cells[10, Column + 2].Value         := FieldNames[Column];
    end;

    // Formatear las columnas antes de exportar los datos
    for Column := 0 to DBQuery.FieldCount - 1 do
    begin
      case FieldTypes[Column] of
        ftString:
        begin
          // Aplicar formato de texto a la columna
          if DBQuery.Fields[Column].FieldName = 'MIN REQ. TIENDA' then
            Worksheet.Columns[Column + 2].NumberFormat := '0'
          else
            Worksheet.Columns[Column + 2].NumberFormat := '@';
        end;

        ftInteger:
          Worksheet.Columns[Column + 2].NumberFormat := '0'; // Formato num�rico
        ftFloat, ftCurrency:
          Worksheet.Columns[Column + 2].NumberFormat := '#.##0,00'; // Formato num�rico
        ftDate, ftTime, ftDateTime:
          Worksheet.Columns[Column + 2].NumberFormat := 'dd/mm/yyyy'; // Formato de fecha
      end;
    end;

    // Preparar el rango para los datos
    DBQuery.First;
    DataArray := VarArrayCreate([0, DBQuery.RecordCount - 1, 0, DBQuery.FieldCount - 1], varVariant);

    // Exportar los datos
    Row := 0; // 0 Comenzar en la fila 0 (�ndice de matriz)
    while not DBQuery.Eof do
    begin
      for Column := 0 to DBQuery.FieldCount - 1 do
      begin
        case FieldTypes[Column] of
          ftString:
            DataArray[Row, Column] := DBQuery.Fields[Column].AsString;
          ftInteger:
            DataArray[Row, Column] := DBQuery.Fields[Column].AsVariant;
          ftFloat, ftCurrency:
            DataArray[Row, Column] := DBQuery.Fields[Column].AsVariant;
          ftDate, ftTime, ftDateTime:
          begin
            if DBQuery.Fields[Column].AsDateTime > EncodeDate(1950,1,1)  then
              DataArray[Row, Column] := VarAsType(DBQuery.Fields[Column].AsDateTime, varDate);
          end;
        else
          DataArray[Row, Column] := Null;
        end;
      end;
      Inc(Row);
      DBQuery.Next;
    end;

    // Escribir datos en Excel de una sola vez  a2
    Worksheet.Range['B11'].Resize[DBQuery.RecordCount, DBQuery.FieldCount].Value := DataArray;

    // Crear una tabla en Excel                                        a1
    TablaExpor             := Worksheet.ListObjects.Add(1, Worksheet.Range['B10'].Resize[DBQuery.RecordCount + 1, DBQuery.FieldCount], 0);
    TablaExpor.Name        := 'DatosExportados';
    TablaExpor.TableStyle  := 'TableStyleMedium9'; // Estilo de tabla predefinido

    // Ajustar el ancho de las columnas
    Worksheet.Columns.AutoFit;

    // Mostrar mensaje de �xito
    // Configurar la columna A con ancho 1
    Worksheet.Columns[1].ColumnWidth          := 1;

    // Ocultar l�neas de cuadr�cula
    ExcelApp.ActiveWindow.DisplayGridlines    := False;

    // Formatear las celdas B2 hasta B6
    Worksheet.Cells[2, 2].Value               := 'KSA HOME CENTER, C.A.';
    Worksheet.Cells[2, 2].Font.Bold           := True;
    Worksheet.Cells[2, 2].Font.Size           := 18;
    Worksheet.Cells[2, 2].HorizontalAlignment := -4131; // Alinear a la izquierda (-4131)

    Worksheet.Cells[3, 2].Font.Size           := 10;
    Worksheet.Cells[3, 2].Font.Name           := 'Arial';
    Worksheet.Cells[5, 2].Font.Size           := 10;
    Worksheet.Cells[5, 2].Font.Name           := 'Arial';
    Worksheet.Cells[6, 2].Font.Size           := 10;
    Worksheet.Cells[6, 2].Font.Name           := 'Arial';

    // Formatear la celda B3
    if tipoReport = 1 then
      Worksheet.Cells[3, 2].Value   := 'ANALISIS DE COMPRAS REPOSICION INVENTARIO'
    else
      Worksheet.Cells[3, 2].Value   := 'MOVIMIENTO DE UNIDADES VENDIDAS';

    // Formatear la celda B5 con la fecha del sistema
    if tipoReport = 1 then
    begin
      Worksheet.Cells[5, 2].Value := 'DESDE : ' + FormatDateTime('dd/mm/yyyy', dtpFechaIniCom.Date);
      Worksheet.Cells[6, 2].Value := 'HASTA : ' + FormatDateTime('dd/mm/yyyy', Periodos[nPeriodo].FechaF );
    end
    else
    begin
      Worksheet.Cells[5, 2].Value := 'DESDE : ' + FormatDateTime('dd/mm/yyyy', dtpFechaIni.Date);
      Worksheet.Cells[6, 2].Value := 'HASTA : ' + FormatDateTime('dd/mm/yyyy', dtpFechaFin.Date);

      // Usar un bucle for para establecer subtotales
      try
        var nombreColumna: string; // Declaraci�n de la variable dentro del bloque try
        var rangeColumna: string; // Declaraci�n de la variable dentro del bloque try
        TablaExpor.ShowTotals := True;
        for Column := 10 to 16 do
        begin
          // Obtener el nombre de la columna de la tabla
          nombreColumna := TablaExpor.HeaderRowRange.Cells[1, Column-1].Value;
          //rangeColumna := Format('R%dC%d:R%dC%d', [11, Column, DBQuery.RecordCount + 10, Column]);
          // Verificar que el nombre de la columna no est� vac�o o sea inv�lido
          if VarIsNull(nombreColumna) or (Trim(nombreColumna) = '') then
            raise Exception.CreateFmt('Nombre de columna no v�lido en la columna %d', [Column]);

          // Aplicar la f�rmula SUBTOTALES a la fila de totales en la columna correspondiente
          Worksheet.Cells[DBQuery.RecordCount + 11, Column ].Formula   :=
            Format('='+'SUBTOTALES(109,[%s])', [nombreColumna]);
        end;
      except
        on E: Exception do
        begin
          // Manejo de errores: mostrar mensaje de advertencia o registrar el error
          MessageDlg('Error al generar la f�rmula de subtotales: ' + E.Message, mtWarning, [mbOK], 0);
        end;
      end;
    end;

    respuesta := MessageDlg('Exportaci�n completada. ' + #13#10 + 'Verifique el archivo de Excel.',
                             TMsgDlgType.mtInformation, [TMsgDlgBtn.mbOK], 0);


  finally
    // Mostrar la aplicaci�n de Excel al usuario
    ExcelApp.Visible        := True;
    ExcelApp.ScreenUpdating := True; // Reactivar la actualizaci�n de pantalla
    ExcelApp                := Unassigned;
  end;
end;


procedure TfMainReport.ExportToTxt(DBQuery: TDBISAMQuery);
var
  Delimiter     : string;
  SaveDialog    : TFileSaveDialog;
  TxtFile       : TextFile;
  Column        : Integer;
  Line, FileName: string;
begin
  // Establecer delimitador (ejemplo: tabulaci�n)
  Delimiter := #9;
  // Crear el di�logo para seleccionar la ubicaci�n y nombre del archivo
  SaveDialog := TFileSaveDialog.Create(Self);
  try
    SaveDialog.DefaultExtension           := 'txt';
    SaveDialog.FileTypes.Add.DisplayName  := 'Archivo de Texto';
    SaveDialog.FileTypes.Add.FileMask     := '*.txt';
    SaveDialog.FileName                   := 'DatosExportados.txt';
    if SaveDialog.Execute then
    begin
      FileName := SaveDialog.FileName;
      // Crear el archivo de texto
      AssignFile(TxtFile, FileName);
      try
        Rewrite(TxtFile); // Abre el archivo para escritura
        try
          // Escribir los encabezados
          Line := '';
          for Column := 0 to DBQuery.FieldCount - 1 do
          begin
            Line := Line + DBQuery.Fields[Column].FieldName;
            if Column < DBQuery.FieldCount - 1 then
              Line := Line + Delimiter;
          end;
          Writeln(TxtFile, Line);
          // Escribir los datos de la consulta
          DBQuery.First;
          while not DBQuery.Eof do
          begin
            Line := '';
            for Column := 0 to DBQuery.FieldCount - 1 do
            begin
              Line := Line + DBQuery.Fields[Column].AsString;
              if Column < DBQuery.FieldCount - 1 then
                Line := Line + Delimiter;
            end;
            Writeln(TxtFile, Line);
            DBQuery.Next;
          end;
          // Mostrar mensaje de �xito
          MessageDlg('Exportaci�n a archivo de texto completada. ' + #13#10 +
                     'Verifique el archivo: ' + FileName,
                     mtInformation, [mbOK], 0);
        except
          on E: Exception do
          begin
            // Manejo de cualquier error durante la escritura
            MessageDlg('Error al exportar los datos: ' + E.Message, mtError, [mbOK], 0);
          end;
        end;
      finally
        CloseFile(TxtFile); // Asegurarse de cerrar el archivo incluso si ocurre un error
      end;
    end;
  finally
    SaveDialog.Free; // Asegurarse de liberar el di�logo
  end;
end;


{procedure TfMainReport.ExportToExcel_Version(DBQuery: TDBISAMQuery);
var
  ExcelApp    : OleVariant;
  Workbook    : OleVariant;
  Worksheet   : OleVariant;
  Column, Row : Integer;
  FieldTypes  : array of TFieldType;
  FieldNames  : array of string;
  DataArray   : Variant;
  respuesta   : Integer;

begin
  ExcelApp := CreateOleObject('Excel.Application');
  try
    ExcelApp.Visible        := False; // Ocultar la ventana de Excel
    ExcelApp.ScreenUpdating := False; // Desactivar la actualizaci�n de pantalla

    // Crear un nuevo libro de trabajo
    Workbook        := ExcelApp.Workbooks.Add;
    Worksheet       := Workbook.Worksheets[1];
    Worksheet.Name  := 'Datos Exportados';

    // Inicializar arreglos para nombres de campos y tipos de campos
    SetLength(FieldNames, DBQuery.FieldCount);
    SetLength(FieldTypes, DBQuery.FieldCount);

    // Configurar la tabla en la hoja de c�lculo
    // Establecer los encabezados de columna y almacenar tipos de datos
    for Column := 0 to DBQuery.FieldCount - 1 do
    begin
      FieldNames[Column]                          := DBQuery.Fields[Column].FieldName;
      FieldTypes[Column]                          := DBQuery.Fields[Column].DataType;
      Worksheet.Cells[1, Column + 1].NumberFormat := '@';
      Worksheet.Cells[1, Column + 1].Value        := FieldNames[Column];
    end;

    // Formatear las columnas antes de exportar los datos
    for Column := 0 to DBQuery.FieldCount - 1 do
    begin
      case FieldTypes[Column] of
        ftString:
          // Aplicar formato de texto a la columna
          Worksheet.Columns[Column + 1].NumberFormat := '@';
        ftInteger:
          Worksheet.Columns[Column + 1].NumberFormat := '0'; // Formato num�rico
        ftFloat, ftCurrency:
          Worksheet.Columns[Column + 1].NumberFormat := '0,00'; // Formato num�rico
        ftDate, ftTime, ftDateTime:
          Worksheet.Columns[Column + 1].NumberFormat := 'dd/mm/yyyy'; // Formato de fecha
      end;
    end;

    // Preparar el rango para los datos
    DBQuery.First;
    DataArray := VarArrayCreate([0, DBQuery.RecordCount - 1, 0, DBQuery.FieldCount - 1], varVariant);

    // Exportar los datos
    Row := 0; // Comenzar en la fila 0 (�ndice de matriz)
    while not DBQuery.Eof do
    begin
      for Column := 0 to DBQuery.FieldCount - 1 do
      begin
        case FieldTypes[Column] of
          ftString:
            DataArray[Row, Column] := DBQuery.Fields[Column].AsString;
          ftInteger:
            DataArray[Row, Column] := DBQuery.Fields[Column].AsVariant;
          ftFloat, ftCurrency:
            DataArray[Row, Column] := DBQuery.Fields[Column].AsVariant;
          ftDate, ftTime, ftDateTime:
            begin
              if DBQuery.Fields[Column].AsDateTime > EncodeDate(1950,1,1) then
                DataArray[Row, Column] := VarAsType(DBQuery.Fields[Column].AsDateTime, varDate);
            end;
          else
            DataArray[Row, Column] := Null;
        end;
      end;
      Inc(Row);
      DBQuery.Next;
    end;

    // Escribir datos en Excel de una sola vez
    Worksheet.Range['A2'].Resize[DBQuery.RecordCount, DBQuery.FieldCount].Value := DataArray;

    // Si la versi�n de Excel es mayor o igual a 2003, usar tablas
    if ExcelApp.Version >= 11 then
    begin
      // Crear una tabla en Excel para versiones compatibles
      Worksheet.ListObjects.Add(1, Worksheet.Range['A1'].Resize[DBQuery.RecordCount + 1, DBQuery.FieldCount], 0);
    end
    else
    begin
      // Para Excel 97 o versiones m�s antiguas, ajustar bordes manualmente
      Worksheet.Range['A1'].Resize[DBQuery.RecordCount + 1, DBQuery.FieldCount].Borders.Weight := 2; // Grosor medio de bordes
    end;

    // Ajustar el ancho de las columnas
    Worksheet.Columns.AutoFit;

    // Mostrar mensaje de �xito
    respuesta := MessageDlg('Exportaci�n completada. ' + #13#10 + 'Verifique el archivo de Excel.',
                             TMsgDlgType.mtInformation, [TMsgDlgBtn.mbOK], 0);
  finally
    // Mostrar la aplicaci�n de Excel al usuario
    ExcelApp.Visible        := True;
    ExcelApp.ScreenUpdating := True; // Reactivar la actualizaci�n de pantalla
    ExcelApp                := Unassigned;
  end;

end; }

function TfMainReport.usuarioTieneAcceso: Boolean;
var
  IniFile             : TIniFile;
  //Report01, Report02  : string;
  UserIndexStr        : string;
begin
  Result        := False; // Inicializa como falso, ya que estamos buscando permiso
  //archivoINI    := ExtractFilePath(ParamStr(0)) + 'config.ini';
  UserIndexStr  := IntToStr(userIndex);
  IniFile       := TIniFile.Create(archivoINI);
  try
    //*Report01 := IniFile.ReadString('REPORT', 'REPORT01', '');
    //Report02 := IniFile.ReadString('REPORT', 'REPORT02', '');
    // Verifica si el UserIndex est� en Report01 o Report02
    if (Pos(UserIndexStr, reportComAc) > 0) or (Pos(UserIndexStr, reportVtaAc) > 0) then
    begin
      if (Pos(UserIndexStr, reportComAc) > 0) then
        MainMenu1.Items[1].Items[0].Enabled := True;      //Menu Reportes -> Compras

      if (Pos(UserIndexStr, reportVtaAc) > 0) then
        MainMenu1.Items[1].Items[1].Enabled := True;

      Result := True; // El usuario tiene acceso
    end;
  finally
    IniFile.Free;
  end;

end;


procedure TfMainReport.dtpFechaDataFinChange(Sender: TObject);
begin
  periodos[7].Periodo := mesesPeriodo[MonthOf(dtpFechaDataFin.Date)] + '-' +
                         Format('%.2d', [DayOf(dtpFechaDataFin.Date)]) ;  //'DATA';
  Periodos[7].FechaI  := dtpFechaDataIni.Date;
  Periodos[7].FechaF  := dtpFechaDataFin.Date;
end;


procedure TfMainReport.dtpFechaIniComChange(Sender: TObject);
begin
  if (dtpFechaIniCom.Date <> 0) and (not VarIsNull(dtpFechaIniCom.Date)) then
  begin
    calcularPeriodos;
    spbCalcularReport.Enabled := True;
    spbExportExcel.Enabled    := False;
  end
  else
  begin
    // Si la fecha es nula o vac�a, deshabilitar botones y mostrar un mensaje de advertencia
    spbCalcularReport.Enabled := False;
    spbExportExcel.Enabled    := False;
    ShowMessage('Por favor, seleccione una fecha v�lida.');
  end;


end;


{ TVendedores }

constructor TVendedores.CreateVendedores(const AVendedorID, AVendedorNa: string);
begin
  inherited Create;
  FVendedorID := AVendedorID;
  FVendedorNa := AVendedorNa;
end;

end.
