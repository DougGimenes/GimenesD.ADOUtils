unit GimenesD.ADO.Controller.Connection;

interface

uses
  Data.DB,
  Data.Win.ADODB,
  SysUtils,
  Math;

type
  TConexao = class(TADOConnection)
  private
    class function NewInstance(): TObject; override;
  public
    class function ObterInstancia(): TConexao;
    function Conectar(AStringDeConexao: String = ''): Boolean;
    function Desconectar(): Boolean;
    class function GerarConexao(AProvider, ABanco, ALogin, ASenha,APath: String): String;
  end;

implementation

{ TConexao }
var
  Conexao : TConexao;

function TConexao.Conectar(AStringDeConexao: String = ''): Boolean;
begin
  if not (AStringDeConexao = '') then
  begin
    Conexao.ConnectionString := AStringDeConexao;
  end;

  Conexao.LoginPrompt := False;

  try
    try
      if not Conexao.Connected then
      begin
        Conexao.Connected := True;
      end;
    except

    end;
  finally
    Result := Conexao.Connected;
  end;
end;

function TConexao.Desconectar: Boolean;
begin
  try
    Conexao.Connected := False;
  finally
    Result := not Conexao.Connected;
  end;
end;

class function TConexao.GerarConexao(AProvider, ABanco, ALogin, ASenha, APath: String): String;
var
  ArqConexao: TextFile;
  StringConexao: String;
begin
  AssignFile(ArqConexao, APath);
  ReWrite(ArqConexao);

  StringConexao := 'Provider=MSOLEDBSQL.1;Persist Security Info=False;' +
                   'User ID=' + ALogin + ';Password=' + ASenha + ';Persist Security Info=True;' +
                   'Initial Catalog=' + ABanco + ';Data Source=' + AProvider + ';';

  for var I := 0 to Floor(StringConexao.Length / 128) do
  begin
    Append(ArqConexao);
    Write(ArqConexao, StringConexao.Substring(I * 128, (I+1) * 128 ));
    CloseFile(ArqConexao);
  end;

  Result := StringConexao;
end;

class function TConexao.NewInstance(): TObject;
begin
  if not Assigned(Conexao) then
  begin
    Conexao := TConexao(inherited NewInstance);
  end;

  Result := Conexao;
end;

class function TConexao.ObterInstancia: TConexao;
begin
  if not Assigned(Conexao) then
  begin
    Conexao := TConexao.Create(nil);
  end;

  Result := Conexao;
end;

end.
