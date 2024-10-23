unit u_DM;

interface

uses
  System.SysUtils, System.Classes, Data.DB, dbisamtb;

type
  TDM = class(TDataModule)
    a2DATA  : TDBISAMDatabase;
    t_User  : TDBISAMTable;
    SQL_User: TDBISAMQuery;
    SQL_Drop: TDBISAMQuery;
    SQL_Insert: TDBISAMQuery;
    SQl_Final: TDBISAMQuery;
    SQL_Vendedor: TDBISAMQuery;
    SQL_Dpto: TDBISAMQuery;
    SQL_Depositos: TDBISAMQuery;

  private
    { Private declarations }

  public
    { Public declarations }
  end;

var
  DM: TDM;

implementation

{$R *.dfm}


end.
