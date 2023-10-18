unit GimenesD.ADO.Model.Base;

interface

uses
  Data.DB,
  Data.Win.ADODB,
  SysUtils,
  Math,
  RTTI,
  StrUtils,
  Classes;

type
  TObjetoBase = class(TObject)
  private
    Conexao: TADOConnection;

    procedure Editar();
    procedure Inserir();
    function PrepararQuery(): TADOQuery;      
    function FormarFiltro(ACodigo: String = ''): String;
    function SelecionarValorPorTipo(AClassName: String; AValor: TValue): String;
  protected
    CampoCodigo: String;
    CamposNaoInserir: TStringList;
    
    function RetornarCodigo(): TValue;
    procedure DeterminarCampoCodigo(); virtual; abstract;
  public
    property Codigo: TValue read RetornarCodigo;
  
    procedure Gravar();
    procedure Excluir();

    constructor Create(AConexao: TADOConnection; ACodigo: String = ''); overload;
  end;

implementation

{ TObjetoBase }

constructor TObjetoBase.Create(AConexao: TADOConnection; ACodigo: String);
var
  QrySelecionar: TADOQuery;
  Contexto:      TRttiContext;
  Tipo:          TRttiType;
  Propriedade:   TRttiProperty;
begin
  inherited Create();
  Self.CamposNaoInserir := TStringList.Create();
  Self.CamposNaoInserir.AddStrings(['Codigo', 'CampoCodigo']);
  Self.DeterminarCampoCodigo();
  Self.Conexao := AConexao;

  if ACodigo <> '' then
  begin
    Tipo := Contexto.GetType(Self.ClassType.ClassInfo);
    QrySelecionar := Self.PrepararQuery();
    QrySelecionar.SQL.Clear();
    QrySelecionar.SQL.Add('SELECT * FROM ' + (Self.ClassType.ClassName).Substring(1));
    QrySelecionar.SQL.Add('WHERE ' + Self.FormarFiltro(ACodigo));
    QrySelecionar.Open();

    if QrySelecionar.RecordCount > 0 then
    begin
      for Propriedade in Tipo.GetProperties do
      begin
        if Propriedade.IsWritable then
        begin
          Propriedade.SetValue(Self, TValue.FromVariant(QrySelecionar.FieldByName(Propriedade.Name).Value));
        end;
      end;
    end;
  end;
end;

procedure TObjetoBase.Editar;
var
  QryObjeto:   TADOQuery;
  Contexto:    TRttiContext;
  Tipo:        TRttiType;
  Propriedade: TRttiProperty;
  Mock, Cont:  Integer;
  Valor:       String;
begin      
  Tipo := Contexto.GetType(Self.ClassType.ClassInfo);
  
  QryObjeto := Self.PrepararQuery();
  QryObjeto.SQL.Clear();
  QryObjeto.SQL.Add('UPDATE ' + (Self.ClassType.ClassName).Substring(1));
  QryObjeto.SQL.Add('SET ');

  Cont := 0;
  for Propriedade in Tipo.GetProperties() do
  begin  
    if (Propriedade.Name = Self.CampoCodigo) or (Self.CamposNaoInserir.Find(Propriedade.Name, Mock)) or (not Propriedade.IsWritable) then
    begin
      Continue;
    end;
    
    Valor := Self.SelecionarValorPorTipo(Propriedade.PropertyType.ToString, Propriedade.GetValue(Self));
    QryObjeto.SQL.Add(IfThen(Cont > 0, ',' + Propriedade.Name + ' = ' + Valor, Propriedade.Name + ' = ' + Valor));
    Inc(Cont)
  end; 
  QryObjeto.SQL.Add('WHERE ' + Self.FormarFiltro());
  
  QryObjeto.ExecSQL();
end;

procedure TObjetoBase.Excluir;
var
  QryObjeto: TADOQuery;
begin
  QryObjeto := Self.PrepararQuery();
  QryObjeto.SQL.Clear();
  QryObjeto.SQL.Add('DELETE FROM ' + (Self.ClassType.ClassName).Substring(1));
  QryObjeto.SQL.Add('WHERE CODIGO = ' + Self.FormarFiltro());
  QryObjeto.ExecSQL();
end;

function TObjetoBase.FormarFiltro(ACodigo: String): String;
var
  Contexto:    TRttiContext;
  Tipo:        TRttiType;
  Propriedade: TRttiProperty;
  Valor:       String;
begin
  Tipo := Contexto.GetType(Self.ClassType.ClassInfo);
  if ACodigo = '' then
  begin
    for Propriedade in Tipo.GetProperties() do
    begin
      if Propriedade.Name = Self.CampoCodigo then
      begin
        Valor := Self.SelecionarValorPorTipo(Propriedade.PropertyType.ToString, Propriedade.GetValue(Self));
      end;
    end;

    Result := Self.CampoCodigo + ' = ' + Valor;
  end
  else
  begin
    Result := Self.CampoCodigo + ' = ' + ACodigo;
  end;
end;

procedure TObjetoBase.Gravar;
begin
  if Self.Codigo.AsString <> '' then
  begin
    Self.Editar();
  end
  else
  begin
    Self.Inserir();
  end;
end;

procedure TObjetoBase.Inserir;
var
  QryObjeto:   TADOQuery;
  Contexto:    TRttiContext;
  Tipo:        TRttiType;
  Propriedade: TRttiProperty;
  Cont, Mock:  Integer;
  Valor:       String;
begin
  Tipo := Contexto.GetType(Self.ClassType.ClassInfo);
  
  QryObjeto := Self.PrepararQuery();
  QryObjeto.SQL.Clear();
  QryObjeto.SQL.Add('INSERT INTO ' + (Self.ClassType.ClassName).Substring(1));
  QryObjeto.SQL.Add('(');

  Cont := 0;
  for Propriedade in Tipo.GetProperties() do
  begin
    if (Propriedade.IsWritable) and (not Self.CamposNaoInserir.Find(Propriedade.Name, Mock)) then
    begin
      QryObjeto.SQL.Add(IfThen(Cont > 0, ',' + Propriedade.Name, Propriedade.Name));
      Inc(Cont);
    end;
  end;
  QryObjeto.SQL.Add(')');
  
  QryObjeto.SQL.Add('VALUES (');
  Cont := 0;
  for Propriedade in Tipo.GetProperties() do
  begin
    if (Propriedade.IsWritable) and (not (Self.CamposNaoInserir.Find(Propriedade.Name, Mock))) then
    begin
      Valor := Self.SelecionarValorPorTipo(Propriedade.PropertyType.ToString, Propriedade.GetValue(Self));
      QryObjeto.SQL.Add(IfThen(Cont > 0, ',' + Valor, Valor));
      Inc(Cont);
    end;
  end; 
  QryObjeto.SQL.Add(')');
  
  QryObjeto.ExecSQL();
end;

function TObjetoBase.PrepararQuery: TADOQuery;
begin
  Result := TADOQuery.Create(nil);
  Result.Connection := Self.Conexao;
end;

function TObjetoBase.RetornarCodigo: TValue;
var
  Contexto:    TRttiContext;
  Tipo:        TRttiType;
  Propriedade: TRttiProperty;
begin
  Tipo := Contexto.GetType(Self.ClassType.ClassInfo);
  for Propriedade in Tipo.GetProperties() do
  begin
    if Propriedade.Name = Self.CampoCodigo then
    begin
      Result := Propriedade.GetValue(Self);    
      Exit;
    end;
  end;
end;

function TObjetoBase.SelecionarValorPorTipo(AClassName: String; AValor: TValue): String;
begin
  if UpperCase(AClassName) = 'STRING' then
  begin
    Result := QuotedStr(AValor.AsString());
  end
  else if UpperCase(AClassName) = 'BOOLEAN' then
  begin
    Result := IntToStr(Ord(AValor.AsBoolean));
  end
  else
  begin
    Result := AValor.AsString;
  end;
end;

end.
