unit uFSplash;

interface

uses
  //Mios
  Data.DB, dbisamtb,
  //
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.Imaging.jpeg, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.WinXPanels, System.ImageList,
  Vcl.ImgList, Vcl.Buttons, Vcl.VirtualImageList, Vcl.BaseImageCollection, Vcl.ImageCollection;

type
  TfSplash = class(TForm)
    Image1            : TImage;
    Label1            : TLabel;
    edPassword1       : TEdit;
    Label2            : TLabel;
    lblNombreUsuario  : TLabel;
    CardPanel1        : TCardPanel;
    Card1             : TCard;
    Label4            : TLabel;
    Label5            : TLabel;
    Label7            : TLabel;
    Label9            : TLabel;
    ImageList1        : TImageList;
    spbMostrar        : TSpeedButton;
    Timer1            : TTimer;
    ImageCollection1  : TImageCollection;
    VirtualImageList1 : TVirtualImageList;
    edUser            : TEdit;
    edPassword        : TEdit;
    Label3            : TLabel;

    procedure Image1Click(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure spbMostrarMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure spbMostrarMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Timer1Timer(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure edUserKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure edPasswordKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
    procedure CenterTextInEdit(edit: TEdit; padding: Integer);
    procedure validarUsuario;
    function userExist(userName : string) : Boolean;
    function descifrarClave(pass: string): string;

  public
    { Public declarations }

    userPass  : string;

  end;

var
  fSplash     : TfSplash;
  posicionX   : Integer;
  posicionY   : Integer;
  claveAcceso : string;
  fechaActual : TDate;
  fechaTope   : TDate;

  userName, userPass0, userPass1 : string;

implementation

uses
 u_MainReporte, u_DM;


{$R *.dfm}

procedure TfSplash.CenterTextInEdit(edit: TEdit; padding: Integer);
  var
  bmp   : TBitmap;
  shape : TShape;
  h     : Integer;
begin
  bmp := TBitmap.Create;
  try
    bmp.Canvas.Font.Assign(edit.Font);
    h := bmp.Canvas.TextExtent('Some characters: A�BCDEgjpqy!"$&/|,').cy;
  finally
    bmp.Free;
  end;
  shape             := TShape.Create(nil);
  shape.Parent      := edit.Parent;
  shape.Brush.Color := edit.Color;
  shape.Pen.Color   := clWhite;
  shape.Left        := edit.Left;
  shape.Top         := edit.Top;
  shape.Width       := edit.Width;
  shape.Height      := edit.Height;

  edit.BorderStyle  := bsNone;
  edit.Left         := edit.Left + padding;
  edit.Width        := edit.Width - 2 * padding;
  edit.Top          := edit.Top + padding + (edit.Height - h - 2 * padding) div 2;
  edit.Height       := h;

end;


procedure TfSplash.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;


procedure TfSplash.FormCreate(Sender: TObject);
var
  F1, F2, F3: Word;
begin
  fechaActual := Now;
  DecodeDate(fechaActual, F1, F2, F3);
  CenterTextInEdit(edPassword, 5); // Ejemplo con un TEdit llamado Edit1
  CenterTextInEdit(edUser, 5); // Ejemplo con un TEdit llamado Edit1
  
end;


procedure TfSplash.FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key=VK_ESCAPE then
  begin
    //Application.Terminate;
    Close;
  end;
end;


procedure TfSplash.FormShow(Sender: TObject);
begin
  edUser.SetFocus;
end;


procedure TfSplash.Image1Click(Sender: TObject);
begin
  validarUsuario;

end;


procedure TfSplash.Image1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  posicionX := X;
  posicionY := Y;
end;


procedure TfSplash.spbMostrarMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin

  edPassword.PasswordChar := #0;
end;


procedure TfSplash.spbMostrarMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  edPassword.PasswordChar := '*';
end;


procedure TfSplash.Timer1Timer(Sender: TObject);
begin
  fSplash.Close;
end;


function TfSplash.userExist(userName : string) : Boolean;
begin
  Result := False;
  with TDBISAMTable.Create(Self) do
  try
    DatabaseName  := u_DM.DM.a2DATA.DatabaseName;
    TableName     := 'SUsuarios';
    Open;

    // Buscar el usuario por su nombre
    if Locate('NOMBRE', AnsiUpperCase(Username), []) then
    begin
      userPass0 := FieldByName('CLAVE').AsString;
      fMainReport.userIndex := FieldByName('CODE').AsInteger;
      fMainReport.userName  := edUser.Text;

      Result    := True;
    end;
  finally
    Free;
  end;

end;



function TfSplash.descifrarClave(pass: string): string;
var
  largoCadena, I, J, indxPos: Integer;
  letra, claveNueva         : string;
const
  posicion: array[1..7] of Integer = (9, 2, 8, 1, 7, 1, 1);

begin
  indxPos     := 1;
  largoCadena := Length(pass);

  for I := 1 to largoCadena do
  begin
    letra := Chr(ord(pass[I]) + posicion[indxPos]);

    if (I mod 7) = 0 then
      indxPos := 1
    else
      indxPos := indxPos + 1;

    claveNueva := claveNueva + letra;
  end;

  Result := claveNueva;

end;


procedure TfSplash.edPasswordKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then  // Verifica si la tecla presionada es Enter
  begin
    Key := 0;  // Evita el sonido de "ding" de Windows
    Perform(WM_NEXTDLGCTL, 1, 0);  // Mueve el foco al siguiente control
  end;
end;


procedure TfSplash.edUserKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then  // Verifica si la tecla presionada es Enter
  begin
    Key := 0;  // Evita el sonido de "ding" de Windows
    Perform(WM_NEXTDLGCTL, 0, 0);  // Mueve el foco al siguiente control
  end;
end;


procedure TfSplash.validarUsuario;
begin
  fMainReport.accesoPermitido := False;

  if edUser.Text = '' then
  begin
    MessageBox(0, 'Usuario no registrado o clave incorrecta. ', 'Warning', MB_OK);
    Exit;
  end;

  if edPassword.Text = '' then
  begin
    MessageBox(0, 'Usuario no registrado o clave incorrecta. ', 'Warning', MB_OK);
    Exit;
  end;

  if (not userExist(edUser.Text)) then
  begin
    MessageBox(0, 'Usuario no registrado o clave incorrecta. ', 'Warning', MB_OK);
    Exit;
  end;

  userPass1 := descifrarClave(edPassword.Text);

  if userPass0 <> userPass1 then
  begin
    MessageBox(0, 'Usuario no registrado o clave incorrecta. ', 'Warning', MB_OK);
    Exit;
  end;

  fMainReport.accesoPermitido := True;
  fSplash.Close;

end;

end.

