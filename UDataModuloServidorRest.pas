unit UDataModuloServidorRest;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB,
  FireDAC.Phys.FBDef, FireDAC.VCLUI.Wait, uRESTDWPoolerDB, uDWAbout,
  uRestDWDriverFD, FireDAC.Phys.IBBase, FireDAC.Comp.UI, Data.DB,
  FireDAC.Comp.Client, uDWDatamodule, IniFiles, Dialogs, uRESTDWServerEvents,
  uDWJSONObject, uDWJSONTools, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.Comp.DataSet, uDWConstsData, FireDAC.DApt,
  FireDAC.Phys.IB, FireDAC.Phys.IBDef, FireDAC.Stan.StorageBin,System.JSON,
  uDWConsts, uRESTDWServerContext, Datasnap.DBClient, uConfigIni;

type
    TDataModuleServidorRestFull = class(TServerMethodDataModule)
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    FDPhysFBDriverLink1: TFDPhysFBDriverLink;
    FDConnection1: TFDConnection;
    DWServerEvents1: TDWServerEvents;
    qrGeral: TFDQuery;
    RESTDWPoolerDB1: TRESTDWPoolerDB;
    RESTDWDriverFD1: TRESTDWDriverFD;
    FDStanStorageBinLink1: TFDStanStorageBinLink;
    VQuery: TFDQuery;

    procedure ServerMethodDataModuleCreate(Sender: TObject);
    procedure DWServerEvents1EventssomarReplyEvent(var Params: TDWParams; var Result: string);
    procedure DWServerEvents1EventsbuscaReplyEvent(var Params: TDWParams; var Result: string);
    procedure DWServerEvents1EventsusuarioReplyEvent(var Params: TDWParams; var Result: string);
    procedure DWServerEvents1EventsclienteReplyEventByType(
      var Params: TDWParams; var Result: string;
      const RequestType: TRequestType; var StatusCode: Integer;
      RequestHeader: TStringList);
    procedure DWServerEvents1EventscategoriaReplyEventByType(
      var Params: TDWParams; var Result: string;
      const RequestType: TRequestType; var StatusCode: Integer;
      RequestHeader: TStringList);
    procedure DWServerEvents1EventsmesasReplyEventByType(var Params: TDWParams;
      var Result: string; const RequestType: TRequestType;
      var StatusCode: Integer; RequestHeader: TStringList);
    procedure DWServerEvents1Eventscategoria_restauranteReplyEventByType(
      var Params: TDWParams; var Result: string;
      const RequestType: TRequestType; var StatusCode: Integer;
      RequestHeader: TStringList);
    procedure DWServerEvents1Eventscomanda_produtosReplyEventByType(
      var Params: TDWParams; var Result: string;
      const RequestType: TRequestType; var StatusCode: Integer;
      RequestHeader: TStringList);
    procedure DWServerEvents1EventspedidosReplyEventByType(
      var Params: TDWParams; var Result: string;
      const RequestType: TRequestType; var StatusCode: Integer;
      RequestHeader: TStringList);
    procedure DWServerEvents1Eventsitens_pedidosReplyEventByType(
      var Params: TDWParams; var Result: string;
      const RequestType: TRequestType; var StatusCode: Integer;
      RequestHeader: TStringList);
    procedure ServerMethodDataModuleDestroy(Sender: TObject);
    procedure DWServerEvents1EventscomplementosReplyEventByType(
      var Params: TDWParams; var Result: string;
      const RequestType: TRequestType; var StatusCode: Integer;
      RequestHeader: TStringList);

  private
    FConfigIni: TConfigIni;
    procedure SetConexao;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DataModuleServidorRestFull: TDataModuleServidorRestFull;

implementation

uses
  UServidorRest,UCCategoria,UConfig,UPedidos,Usuario,Complementos;

{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}

procedure TDataModuleServidorRestFull.DWServerEvents1EventsbuscaReplyEvent
  (var Params: TDWParams; var Result: string);
var
VjsonValue: uDWJSONObject.TJSONValue;
begin
  if (Params.ItemsString['tabela'].AsString) <> '' then
  begin
    VjsonValue := uDWJSONObject.TJSONValue.Create;
    try
      VQuery.Close;
      VQuery.SQL.Clear;
      VQuery.SQL.Add('SELECT * FROM ' + Params.ItemsString['tabela'].AsString);
      VQuery.Open();
      VjsonValue.LoadFromDataset('', VQuery, VjsonValue.Encoded,Params.JsonMode);
      Result := VjsonValue.ToJSON;
    finally
      if VQuery.Active then
      begin
        VQuery.Close;
        VjsonValue.Free;
      end;
    end;
  end
  else
    Result := '{"reply":"N�o Existe!:"}';
end;

procedure TDataModuleServidorRestFull.DWServerEvents1EventscategoriaReplyEventByType(
  var Params: TDWParams; var Result: string; const RequestType: TRequestType;
  var StatusCode: Integer; RequestHeader: TStringList);
var
Vjsonobjeto : TJSONObject;
categoria   : TCategoria;
VjsonValue: uDWJSONObject.TJSONValue;
begin
  case RequestType of
    rtGet:
    begin
    VjsonValue := uDWJSONObject.TJSONValue.Create;
    try
      VQuery.Close;
      VQuery.SQL.Clear;
      VQuery.SQL.Add('SELECT * FROM CATEGORIA');
      VQuery.SQL.Add('WHERE IDCATEGORIA IS NOT NULL');
      VQuery.SQL.Add('order by categoria.idcategoria');
      VQuery.Open();
      if VQuery.RecordCount > 0 then
      begin
        VjsonValue.LoadFromDataset('', VQuery, VjsonValue.Encoded,Params.JsonMode);
        Result := VjsonValue.ToJSON;
      end
      except on E: Exception do
        raise Exception.Create(' N�o foi Possivel Localizar ' + E.Message);
      end;
    end;

    rtPost:
    begin
      if Params.ItemsString['UNDEFINED'] <> nil then
      begin
        categoria := TCategoria.Create;
        Vjsonobjeto := TJSONObject.ParseJSONValue(Params.ItemsString['UNDEFINED'].AsString) as TJSONObject;
        try
          try
            if (Vjsonobjeto.GetValue<string>('tag') = 'NOVO') then
            begin
              categoria.NomeCategoria   := Vjsonobjeto.GetValue<string>('NOMECATEGORIA');
              categoria.Descricao       := Vjsonobjeto.GetValue<string>('DESCRICAOCATEGORIA');
              categoria.FOBSERVACAO     := Vjsonobjeto.GetValue<string>('CATEGORIA_OBSERVACAO');
              categoria.Novo;
              Result := '[{"Resposta":"Gravado Com Sucess"}]';
            end;

            if (Vjsonobjeto.GetValue<string>('tag') = 'EDITAR') then
            begin
              if Vjsonobjeto.GetValue<string>('IDCATEGORIA') <> '' then
              begin
                categoria.Id              := Vjsonobjeto.GetValue<string>('IDCATEGORIA');
                categoria.NomeCategoria   := Vjsonobjeto.GetValue<string>('NOMECATEGORIA');
                categoria.Descricao       := Vjsonobjeto.GetValue<string>('DESCRICAOCATEGORIA');
                categoria.FOBSERVACAO     := Vjsonobjeto.GetValue<string>('CATEGORIA_OBSERVACAO');
                categoria.Editar;
                Result := '[{"Resposta":"Editado Com Sucess"}]';
              end
            end;

            if (Vjsonobjeto.GetValue<string>('tag') = 'DELETAR') then
            begin
             if Vjsonobjeto.GetValue<string>('IDCATEGORIA') <> '' then
              begin
                categoria.Id := Vjsonobjeto.GetValue<string>('IDCATEGORIA');
                categoria.Deletar;
                Result := '[{"Resposta":"Deletado Com Sucess"}]';
              end;
            end;

          except on E: Exception do
            raise Exception.Create('[{Erro Nesse item ' + E.Message + '}]');
          end;
        finally
          categoria.Free;
        end;
      end;
    end;

    rtDelete:
    begin

    end;
  end;
end;

procedure TDataModuleServidorRestFull.DWServerEvents1Eventscategoria_restauranteReplyEventByType(
  var Params: TDWParams; var Result: string; const RequestType: TRequestType;
  var StatusCode: Integer; RequestHeader: TStringList);
  var
  Vjsonobjeto : TJSONObject;
//  cliente : TCliente;
  categoria   : TCategoria;
  VjsonValue: uDWJSONObject.TJSONValue;
begin
  case RequestType of
    rtGet:
    begin
      VjsonValue := uDWJSONObject.TJSONValue.Create;
    try
      if (Params.ItemsString['idcategoria_restaurant'].AsString) <> '' then
      begin
        VQuery.Close;
        VQuery.SQL.Clear;
        VQuery.SQL.Add('SELECT IDCATEGORIA,NOMECATEGORIA FROM CATEGORIA');
        VQuery.SQL.Add('WHERE CATEGORIA.categoria_tipo_comanda  = :id');
        VQuery.ParamByName('id').AsString := Params.ItemsString['idcategoria_restaurant'].AsString;
        VQuery.Open();
        if VQuery.RecordCount > 0 then
        begin
          VjsonValue.LoadFromDataset('', VQuery, VjsonValue.Encoded,Params.JsonMode);
          Result := VjsonValue.ToJSON;
        end
      end;
      except on E: Exception do
        raise Exception.Create(' N�o foi Possivel Localizar ' + E.Message);
      end;
    end;
    rtPost:
    begin

    end;
  end
end;

procedure TDataModuleServidorRestFull.DWServerEvents1EventsclienteReplyEventByType(
  var Params: TDWParams; var Result: string; const RequestType: TRequestType;
  var StatusCode: Integer; RequestHeader: TStringList);
  var
  Vjsonobjeto : TJSONObject;
//  cliente : TCliente;
begin
   case RequestType of
    rtGet:
    begin

    end;
    rtPost:
    begin
      if Params.ItemsString['UNDEFINED'] <> nil then
      begin
        try
          try
//            cliente := TCliente.Create;
            Vjsonobjeto := TJSONObject.ParseJSONValue(Params.ItemsString['UNDEFINED'].AsString) as TJSONObject;
            if (Vjsonobjeto.GetValue<string>('tag') = 'NOVO') then
            begin
//              cliente.NOME              := Vjsonobjeto.GetValue<string>('NOMECLIENTE');
//              cliente.tipopessoa        := Vjsonobjeto.GetValue<string>('TIPOPESSOA');
//              cliente.telefone          := Vjsonobjeto.GetValue<string>('TELEFONE');
//              cliente.cpf               := Vjsonobjeto.GetValue<string>('CPF');
//              cliente.cnpj              := Vjsonobjeto.GetValue<string>('CNPJ');
//              cliente.email             := Vjsonobjeto.GetValue<string>('EMAIL');
//              cliente.datanascimento    := Vjsonobjeto.GetValue<string>('DTNASCIMENTO');
//              cliente.CARGO_IDCARGO     := 1;
//              cliente.Novo;
              Result := '[{"Resposta":"Gravado Com Sucess"}]';
            end;
          except on E: Exception do
            raise Exception.Create('Erro ao Inserir Dados' + E.Message);
          end;
        finally
//          cliente.Free;
        end;
      end;
    end;
    rtDelete:
    begin

    end;
    rtPut:
    begin

    end;
   end;
end;

procedure TDataModuleServidorRestFull.DWServerEvents1Eventscomanda_produtosReplyEventByType(
  var Params: TDWParams; var Result: string; const RequestType: TRequestType;
  var StatusCode: Integer; RequestHeader: TStringList);
  var
  Vjsonobjeto : TJSONObject;
  Config      : TConfig;
  VjsonValue: uDWJSONObject.TJSONValue;
begin
  case RequestType of
    rtGet:
    begin
      VjsonValue := uDWJSONObject.TJSONValue.Create;
    try
      if (Params.ItemsString['comanda_produtoid'].AsString) <> '' then
      begin
        VQuery.Close;
        VQuery.SQL.Clear;
        VQuery.SQL.Add('SELECT PRODUTO.* FROM PRODUTO');
        VQuery.SQL.Add('LEFT JOIN CATEGORIA ON PRODUTO.categoria_idcategoria = categoria.idcategoria');
        VQuery.SQL.Add('WHERE PRODUTO.categoria_idcategoria = :id');
        VQuery.ParamByName('id').AsString := Params.ItemsString['comanda_produtoid'].AsString;
        VQuery.Open();
        if VQuery.RecordCount > 0 then
        begin
          VjsonValue.LoadFromDataset('', VQuery, VjsonValue.Encoded,Params.JsonMode);
          Result := VjsonValue.ToJSON;
        end
      end;
      except on E: Exception do
        raise Exception.Create(' N�o foi Possivel Localizar ' + E.Message);
      end;
    end;
  end
end;

procedure TDataModuleServidorRestFull.DWServerEvents1EventscomplementosReplyEventByType(
  var Params: TDWParams; var Result: string; const RequestType: TRequestType;
  var StatusCode: Integer; RequestHeader: TStringList);
  var
  Vjsonobjeto : TJSONObject;
  VjsonValue: uDWJSONObject.TJSONValue;

begin
  case RequestType of
    rtGet:
    begin
      VjsonValue := uDWJSONObject.TJSONValue.Create;
      try
        if (Params.ItemsString['idcomplementos'].AsString <> '') then
        begin
          VQuery.Close;
          VQuery.SQL.Clear;
          VQuery.SQL.Add('SELECT COMPLEMENTOS.* FROM COMPLEMENTOS');
          VQuery.SQL.Add('LEFT JOIN CATEGORIA ON complementos.complementos_idcategoria = CATEGORIA.idcategoria');
          VQuery.SQL.Add('WHERE COMPLEMENTOS.complementos_idcategoria =:ID ');
          VQuery.ParamByName('ID').AsString := Params.ItemsString['idcomplementos'].AsString;
          VQuery.Open();
          if VQuery.RecordCount > 0 then
          begin
            VjsonValue.LoadFromDataset('', VQuery, VjsonValue.Encoded,Params.JsonMode);
            Result := VjsonValue.ToJSON;
          end;
        end;
      except on E: Exception do
        raise Exception.Create(' N�o foi Possivel Localizar ' + E.Message);
      end;
    end;
  end;
end;

procedure TDataModuleServidorRestFull.DWServerEvents1Eventsitens_pedidosReplyEventByType(
  var Params: TDWParams; var Result: string; const RequestType: TRequestType;
  var StatusCode: Integer; RequestHeader: TStringList);
 var
  Vjsonobjeto : TJSONObject;
  pedido : TVenda;
  complementos : TComplementos;
begin
  case RequestType of
    rtGet:
    begin

    end;
    rtPost:
    begin
      if Params.ItemsString['UNDEFINED'] <> nil then
      begin

        pedido := TVenda.Create( qrGeral );
        complementos := TComplementos.Create(qrGeral);

        Vjsonobjeto := TJSONObject.ParseJSONValue( Params.ItemsString['UNDEFINED'].AsString ) as TJSONObject;
        try
          try

            complementos.ITENS_IDCOMPLEMENTOS := Vjsonobjeto.GetValue<Integer>('ITENS_VENDA_IDCOMPLEMENTO');
            complementos.Gravar_ItensComplementos;

            pedido.FIDPRODUTO  :=  Vjsonobjeto.GetValue<Integer>('IDPRODUTO');
            pedido.FQUANTIDADE :=  Vjsonobjeto.GetValue<Integer>('QUANTIDADE_PRODUTO');
            pedido.FITENS_MESA :=  Vjsonobjeto.GetValue<Integer>('IDMESA');
            pedido.ITENS_VENDA_IDCOMPLEMENTO :=


            pedido.ItensVenda;
            pedido.Movimentacoes;
            Result := '[{"Resposta":" Pedido Gravado Com Sucess"}]';

          except on E: Exception do
            raise Exception.Create(' Erro ao Inserir os Dados! ' + E.Message);
          end;
        finally
          pedido.Free;
        end;
      end;
    end;
  end;
end;

procedure TDataModuleServidorRestFull.DWServerEvents1EventsmesasReplyEventByType(
  var Params: TDWParams; var Result: string; const RequestType: TRequestType;
  var StatusCode: Integer; RequestHeader: TStringList);
  var
  Vjsonobjeto : TJSONObject;
  Config      : TConfig;
  VjsonValue: uDWJSONObject.TJSONValue;
begin
  case RequestType of
    rtGet:
    begin
      try
       VjsonValue := uDWJSONObject.TJSONValue.Create;
       VQuery.Close;
       VQuery.SQL.Clear;
       VQuery.SQL.Add('SELECT * FROM MESA');
       VQuery.Open();
        if VQuery.RecordCount > 0 then
        begin
          VjsonValue.LoadFromDataset('', VQuery, VjsonValue.Encoded,Params.JsonMode);
          Result := VjsonValue.ToJSON;
        end
       except on E: Exception do
        raise Exception.Create(' N�o foi Possivel Localizar! ' + E.Message);
      end;
    end;
  end;
end;

procedure TDataModuleServidorRestFull.DWServerEvents1EventspedidosReplyEventByType(
  var Params: TDWParams; var Result: string; const RequestType: TRequestType;
  var StatusCode: Integer; RequestHeader: TStringList);
  var
  Vjsonobjeto : TJSONObject;
  pedido : TVenda;
begin
  case RequestType of
    rtGet:
    begin

    end;
    rtPost:
    begin
      if Params.ItemsString['UNDEFINED'] <> nil then
      begin
        pedido := TVenda.Create(qrGeral);
        Vjsonobjeto := TJSONObject.ParseJSONValue(Params.ItemsString['UNDEFINED'].AsString) as TJSONObject;
        try
          try

            pedido.VALORVENDA :=  Vjsonobjeto.GetValue<Double>('VENDAS_VALOR_VENDA');
            pedido.DATAVENDA  := StrToDateTime(FormatDateTime('dd/mm/yyyy', Now));
            pedido.DESCRICAOVENDA := Vjsonobjeto.GetValue<String>('DESCRICAOVENDA');
            pedido.FORMAPAGAMENTO := ' DINHEIRO ';
            pedido.Venda;
            Result := '[{"Resposta":" Pedido Gravado Com Sucess"}]';

          except on E: Exception do
            raise Exception.Create(' Erro ao Inserir os Dados! ' + E.Message);
          end;
        finally
          pedido.Free;
        end;
      end;
    end;
  end;
end;

procedure TDataModuleServidorRestFull.DWServerEvents1EventssomarReplyEvent
  (var Params: TDWParams; var Result: string);
begin
  if (Params.ItemsString['valor1'].AsInteger > 0) then
  begin
    Result := IntToStr(Params.ItemsString['valor1'].AsInteger + 80)
  end;
end;

procedure TDataModuleServidorRestFull.DWServerEvents1EventsusuarioReplyEvent(
  var Params: TDWParams; var Result: string);
var
VjsonValue: uDWJSONObject.TJSONValue;
user , password : String;
resultado : string;
usuario : TUsuario;

begin

  user := '';
  password := '';
  resultado := '';

  if ((Params.ItemsString['user'].AsString) <> '') and ((Params.ItemsString['password'].AsString) <> '') then
  begin

    user     :=  Params.ItemsString['user'].AsString;
    password := Params.ItemsString['password'].AsString;
    VjsonValue := uDWJSONObject.TJSONValue.Create;
    usuario := TUsuario.Create(VQuery);


    try
      usuario.usuario := user;
      usuario.senha   := password;
      usuario.Login;

      VjsonValue.LoadFromDataset('', usuario.GetResultado, VjsonValue.Encoded,Params.JsonMode);
      Result := VjsonValue.ToJSON;
    finally
      usuario.Free;
    end;
  end
  else
    Result := '{"reply":"Usuario N�o Encontrado!:"}';
end;

procedure TDataModuleServidorRestFull.ServerMethodDataModuleCreate
  (Sender: TObject);
begin
  FConfigIni := TConfigIni.Create;
  SetConexao;
end;

procedure TDataModuleServidorRestFull.ServerMethodDataModuleDestroy(
  Sender: TObject);
begin
  FreeAndNil(FConfigIni);
end;

procedure TDataModuleServidorRestFull.SetConexao;
begin
  FConfigIni.ReadIni;
  FDConnection1.Params.DriverID         := FConfigIni.DriverID;
  FDConnection1.Params.Database         := FConfigIni.CaminhoBD;
  FDConnection1.Params.UserName         := FConfigIni.UsuarioBD;
  FDConnection1.Params.Password         := FConfigIni.PasswordBD;
  FDConnection1.Params.Values['Server'] := FConfigIni.HostBD;
  FDConnection1.Params.Values['Port']   := IntToStr(FConfigIni.PortBD);
  try
    if not FDConnection1.Connected then
      FDConnection1.Connected := True;
  except
    on E: Exception do
      raise Exception.Create(' Erro ao conectar a DataBase ' + E.Message);
  end;
end;

end.
