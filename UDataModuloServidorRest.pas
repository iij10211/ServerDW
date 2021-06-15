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
  uDWConsts, uRESTDWServerContext, Datasnap.DBClient, uConfigIni,
  FireDAC.Stan.StorageJSON, Vcl.ExtCtrls;

type
    TDataModuleServidorRestFull = class(TServerMethodDataModule)
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    FDPhysFBDriverLink1: TFDPhysFBDriverLink;
    FDConnection1: TFDConnection;
    DWServerEvents1: TDWServerEvents;
    qrGeral: TFDQuery;
    FDStanStorageBinLink1: TFDStanStorageBinLink;
    VQuery: TFDQuery;
    VQueryComplemento: TFDQuery;
    FDStanStorageJSONLink1: TFDStanStorageJSONLink;
    VqueryVendas: TFDQuery;
    ClientDataSet1: TClientDataSet;
    ClientDataSet1idmesa: TIntegerField;
    Timer1: TTimer;
    RESTDWPoolerDB1: TRESTDWPoolerDB;
    RESTDWDriverFD1: TRESTDWDriverFD;

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
    procedure DWServerEvents1EventsvendasReplyEventByType(var Params: TDWParams;
      var Result: string; const RequestType: TRequestType;
      var StatusCode: Integer; RequestHeader: TStringList);
    procedure DWServerEvents1Eventsitens_mesaReplyEventByType(
      var Params: TDWParams; var Result: string;
      const RequestType: TRequestType; var StatusCode: Integer;
      RequestHeader: TStringList);
    procedure DWServerEvents1EventspratosReplyEventByType(var Params: TDWParams;
      var Result: string; const RequestType: TRequestType;
      var StatusCode: Integer; RequestHeader: TStringList);
    procedure DWServerEvents1Eventspratos_complementosReplyEventByType(
      var Params: TDWParams; var Result: string;
      const RequestType: TRequestType; var StatusCode: Integer;
      RequestHeader: TStringList);
    procedure DWServerEvents1Eventsitens_mesa_complementosReplyEventByType(
      var Params: TDWParams; var Result: string;
      const RequestType: TRequestType; var StatusCode: Integer;
      RequestHeader: TStringList);
    procedure DWServerEvents1Eventsfechar_caixaReplyEventByType(
      var Params: TDWParams; var Result: string;
      const RequestType: TRequestType; var StatusCode: Integer;
      RequestHeader: TStringList);
    procedure DWServerEvents1Eventspedido_cozinhaReplyEventByType(
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
      else
      begin
        Result := '[{"Resposta":"N�o H� Categorias"}]';
      end;
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
        VQuery.SQL.Add('SELECT IDGRUPO,GRUPO_DESCRICAO FROM GRUPO');
        VQuery.SQL.Add('WHERE GRUPO.GRUPO_TIPO_COMANDA  = :id');
        VQuery.ParamByName('id').AsString := Params.ItemsString['idcategoria_restaurant'].AsString;
        VQuery.Open();
        if VQuery.RecordCount > 0 then
        begin
          VjsonValue.LoadFromDataset('', VQuery, VjsonValue.Encoded,Params.JsonMode);
          Result := VjsonValue.ToJSON;
        end
        else
        begin
          Result := '[{"Resposta":"N�o H� Categoria"}]';
        end;
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
        VQuery.SQL.Add('LEFT JOIN GRUPO ON PRODUTO.PRODUTO_IDGRUPO = GRUPO.IDGRUPO');
        VQuery.SQL.Add('WHERE PRODUTO.PRODUTO_IDGRUPO = :id');
        VQuery.ParamByName('id').AsString := Params.ItemsString['comanda_produtoid'].AsString;
        VQuery.Open();
        if VQuery.RecordCount > 0 then
        begin
          VjsonValue.LoadFromDataset('', VQuery, VjsonValue.Encoded,Params.JsonMode);
          Result := VjsonValue.ToJSON;
        end
        else
        begin
          Result := '[{"Resposta":"N�o H� Produtos"}]';
        end;
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
  complemento : TVenda;
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
          VQuery.SQL.Add('SELECT * FROM COMPLEMENTO');
          VQuery.SQL.Add('LEFT JOIN GRUPO ON COMPLEMENTO.complemento_idgrupo = GRUPO.idgrupo');
          VQuery.SQL.Add('where COMPLEMENTO.complemento_idgrupo =:ID ');
          VQuery.ParamByName('ID').AsString := Params.ItemsString['idcomplementos'].AsString;
          VQuery.Open();
          if VQuery.RecordCount > 0 then
          begin
            VjsonValue.LoadFromDataset('', VQuery, VjsonValue.Encoded,Params.JsonMode);
            Result := VjsonValue.ToJSON;
          end
          else
          begin
            Result := '[{"Resposta":"N�o H� Complementos"}]';
          end;
        end;
      except on E: Exception do
        raise Exception.Create(' N�o foi Possivel Localizar ' + E.Message);
      end;
    end;
    rtPost:
    begin
      if (Params.ItemsString['UNDEFINED'] <> nil) then
      begin
        Vjsonobjeto := TJSONObject.ParseJSONValue( Params.ItemsString['UNDEFINED'].AsString ) as TJSONObject;
        complemento := TVenda.Create(qrGeral);
        complemento.ITENS_IDCOMPLEMENTOS := Vjsonobjeto.GetValue<Integer>('ITENS_IDCOMPLEMENTO');
        complemento.ITENS_IDPEDIDOS      := Vjsonobjeto.GetValue<Integer>('ITENS_IDPEDIDOS');
        complemento.Gravar_ItensComplementos;
        Result := '[{"Resposta":" Pedido Gravado Com Sucess"}]';
      end;
    end;
  end;
end;

procedure TDataModuleServidorRestFull.DWServerEvents1Eventsfechar_caixaReplyEventByType(
  var Params: TDWParams; var Result: string; const RequestType: TRequestType;
  var StatusCode: Integer; RequestHeader: TStringList);
  var
  Vjsonobjeto : TJSONObject;
  pedido : TVenda;
  VjsonValue: uDWJSONObject.TJSONValue;
begin
  pedido := TVenda.Create(qrGeral);
  case RequestType of
    rtPost:
    begin
      Vjsonobjeto := TJSONObject.ParseJSONValue( Params.ItemsString['UNDEFINED'].AsString ) as TJSONObject;
      try
        try
          pedido.PEDIDOS_IDMESA := Vjsonobjeto.GetValue<Integer>('IDMESA');
          pedido.Atualizar_Pedido;
          Result := '[{"Resposta":" Pedido Gravado Com Sucess"}]';
        except on E: Exception do
          raise Exception.Create('Erro ao Atualizar!');
        end;
      finally
        pedido.Free;
      end;
    end;
  end;
end;

procedure TDataModuleServidorRestFull.DWServerEvents1Eventsitens_mesaReplyEventByType(
  var Params: TDWParams; var Result: string; const RequestType: TRequestType;
  var StatusCode: Integer; RequestHeader: TStringList);
  var
  Vjsonobjeto : TJSONObject;
  VjsonValue: uDWJSONObject.TJSONValue;
  jsonresposta : String;
  valorjsonprato : String;
  valorjsoncomplemento : String;
begin
   case RequestType of
    rtGet:
    begin
      VjsonValue := uDWJSONObject.TJSONValue.Create;
      Vjsonobjeto:= TJSONObject.Create;
      try
        if (Params.ItemsString['idmesas'].AsString <> '') then
        begin

          VQuery.Close;
          VQuery.SQL.Clear;
          VQuery.SQL.Add('SELECT iditens_venda,descricao_produto,itens_venda_quantidade,precovenda_produto ,itens_venda.POST_TYPE ,itens_venda.itens_venda_observacao from itens_venda');
          VQuery.SQL.Add('LEFT JOIN produto ON idproduto = itens_idproduto');
          VQuery.SQL.Add('LEFT JOIN pedidos ON idpedidos = itens_idpedido');
          VQuery.SQL.Add('LEFT JOIN vendas  ON vendas_idvendas = idvendas');
          VQuery.SQL.Add('WHERE itens_venda_idmesa =:ID');
          VQuery.SQL.Add('AND pedidos_status =:status');
          VQuery.ParamByName('ID').AsString := Params.ItemsString['idmesas'].AsString;
          VQuery.ParamByName('status').AsString := 'ABERTO';
          VQuery.Open();

          if(VQuery.RecordCount > 0) then
          begin
            VjsonValue.LoadFromDataset('', VQuery, VjsonValue.Encoded,Params.JsonMode);
            valorjsonprato := VjsonValue.ToJSON;
            Result := valorjsonprato;
          end
          else
          begin
            Result := '[{"Resposta":"N�o H� ItensMesa"}]';
          end;
        end;
      except on E: Exception do
        raise Exception.Create(' N�o foi Possivel Localizar Mesa! ' + E.Message);
      end;
    end;
   end;
end;

procedure TDataModuleServidorRestFull.DWServerEvents1Eventsitens_mesa_complementosReplyEventByType(
  var Params: TDWParams; var Result: string; const RequestType: TRequestType;
  var StatusCode: Integer; RequestHeader: TStringList);
 var
  Vjsonobjeto : TJSONObject;
  VjsonValue: uDWJSONObject.TJSONValue;
  jsonresposta : String;
  valorjsoncomplemento : String;
begin
  case RequestType of
    rtGet:
    begin
      VjsonValue := uDWJSONObject.TJSONValue.Create;
      Vjsonobjeto:= TJSONObject.Create;
      try
        if (Params.ItemsString['idmesas'].AsString <> '') then
        begin
          VQueryComplemento.Close;
          VQueryComplemento.SQL.Clear;
          VQueryComplemento.SQL.Add('SELECT DISTINCT ITENS_IDITENS_VENDA,iditens_complemento,itens_idpedidos,itens_idcomplemento,complemento_descricao,complemento_valor,itens_complemento.POST_TYPE FROM itens_complemento');
          VQueryComplemento.SQL.Add('INNER JOIN complemento ON idcomplemento = itens_idcomplemento');
          VQueryComplemento.SQL.Add('INNER JOIN pedidos ON itens_idpedidos = idpedidos');
          VQueryComplemento.SQL.Add('INNER JOIN ITENS_VENDA on itens_idpedido = itens_idpedidos');
          VQueryComplemento.SQL.Add('WHERE pedidos_idmesa =:ID');
          VQueryComplemento.SQL.Add('AND pedidos_status =:status');
          VQueryComplemento.ParamByName('ID').AsString := Params.ItemsString['idmesas'].AsString;
          VQueryComplemento.ParamByName('status').AsString := 'ABERTO';
          VQueryComplemento.Open();

          if(VQueryComplemento.RecordCount > 0) then
          begin
            VjsonValue.LoadFromDataset('complementos', VQueryComplemento, VjsonValue.Encoded,Params.JsonMode);
            valorjsoncomplemento := VjsonValue.ToJSON;
            Result := valorjsoncomplemento;
          end
          else
          begin
            Result := '[{"Resposta":"N�o H� ItensMesa"}]';
          end;
        end;
      except on E: Exception do
        raise Exception.Create(' N�o foi Possivel Localizar Mesa! ' + E.Message);
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
        Vjsonobjeto := TJSONObject.ParseJSONValue( Params.ItemsString['UNDEFINED'].AsString ) as TJSONObject;
        try
          try
            pedido.FIDPRODUTO     :=  Vjsonobjeto.GetValue<Integer>('IDPRODUTO');
            pedido.FQUANTIDADE    :=  Vjsonobjeto.GetValue<Integer>('QUANTIDADE_PRODUTO');
            pedido.FITENS_MESA    :=  Vjsonobjeto.GetValue<Integer>('IDMESA');
            pedido.FITENS_IDGRUPO :=  Vjsonobjeto.GetValue<Integer>('ITENS_IDGRUPO');
            pedido.IDPEDIDO       :=  Vjsonobjeto.GetValue<Integer>('ITENS_IDPEDIDO');
            pedido.ITENS_VENDA_OBSERVACAO := Vjsonobjeto.GetValue<String>('ITENS_VENDA_OBSERVACAO');
            pedido.ItensVenda;
            Result := '[{"Resposta":" Pedido Gravado Com Sucess"}]';
          except on E: Exception do
            raise Exception.Create(' Erro ao Inserir os Dados! ' + E.Message);
          end;
        finally
         // pedido.Free;
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
       VQuery.SQL.Add('SELECT * FROM MESAS');
       VQuery.Open();
        if VQuery.RecordCount > 0 then
        begin
          VjsonValue.LoadFromDataset('', VQuery, VjsonValue.Encoded,Params.JsonMode);
          Result := VjsonValue.ToJSON;
        end
        else
        begin
          Result := '[{"Resposta":"N�o H� Mesas"}]';
        end;
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
  VjsonValue: uDWJSONObject.TJSONValue;
  Vjsonobjeto : TJSONObject;
  pedido : TVenda;
begin
   pedido := TVenda.Create(qrGeral);
   VjsonValue := uDWJSONObject.TJSONValue.Create;
  case RequestType of
    rtGet:
    begin
      qrGeral.Close;
      qrGeral.SQL.Clear;
      qrGeral.SQL.Add('SELECT MAX(PEDIDOS.idpedidos) FROM PEDIDOS');       //MAX(PEDIDOS.idpedidos)
      qrGeral.Active := True;
      VjsonValue.LoadFromDataset('', qrGeral, VjsonValue.Encoded,Params.JsonMode);
      Result := VjsonValue.ToJSON;
    end;
    rtPost:
    begin
      if Params.ItemsString['UNDEFINED'] <> nil then
      begin
        Vjsonobjeto := TJSONObject.ParseJSONValue(Params.ItemsString['UNDEFINED'].AsString) as TJSONObject;
        try
          try

            pedido.PEDIDOSTATUS   := Vjsonobjeto.GetValue<String>('PEDIDOS_STATUS');
            pedido.PEDIDOPESSOAS  := Vjsonobjeto.GetValue<Integer>('PEDIDOS_PESSOAS');
            pedido.PEDIDOS_IDMESA := Vjsonobjeto.GetValue<Integer>('PEDIDOS_IDMESA');
            pedido.PedidosMesa;
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

procedure TDataModuleServidorRestFull.DWServerEvents1Eventspedido_cozinhaReplyEventByType(
  var Params: TDWParams; var Result: string; const RequestType: TRequestType;
  var StatusCode: Integer; RequestHeader: TStringList);
  var
  Vjsonobjeto : TJSONObject;
  VjsonValue: uDWJSONObject.TJSONValue;
  idmesa : String;
begin
  case RequestType of
    rtGet:
    begin
      VjsonValue := uDWJSONObject.TJSONValue.Create;
      Vjsonobjeto:= TJSONObject.Create;
      try

        VQuery.Close;
        VQuery.SQL.Clear;
        VQuery.SQL.Add('SELECT * FROM MESAS');
        VQuery.SQL.Add('WHERE MESAS.MESAS_STATUS =:status');
        VQuery.ParamByName('status').AsInteger := 1;
        VQuery.Open();

        if(VQuery.RecordCount > 0) then
        begin
          VjsonValue.LoadFromDataset('', VQuery, VjsonValue.Encoded,Params.JsonMode);
          Result := VjsonValue.ToJSON;
        end
        else
        begin
          Result := '[{"Resposta":"N�o H� Pedidos Registrados!"}]';
        end;

       except on E: Exception do
        raise Exception.Create(' Error ao Buscar Pedido! ' + E.Message);
      end;
    end;
  end;
end;

procedure TDataModuleServidorRestFull.DWServerEvents1EventspratosReplyEventByType(
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
      Vjsonobjeto:= TJSONObject.Create;
      try
        if (Params.ItemsString['idmesas'].AsString <> '') then
        begin
          VQuery.Close;
          VQuery.SQL.Clear;
          VQuery.SQL.Add('SELECT itens_venda.iditens_venda,itens_venda.vendas_idvendas,PRODUTO.nome_produto,produto.precovenda_produto FROM itens_venda');
          VQuery.SQL.Add('LEFT JOIN MESAS ON itens_venda.itens_venda_idmesa = MESAS.idmesas');
          VQuery.SQL.Add('LEFT JOIN PRODUTO ON itens_venda.itens_idproduto  = PRODUTO.idproduto');
          VQuery.SQL.Add('LEFT JOIN PEDIDOS ON itens_venda.itens_idpedido   = PEDIDOS.idpedidos');
          VQuery.SQL.Add('WHERE PEDIDOS.pedidos_idmesa =:ID');
          VQuery.SQL.Add('AND PEDIDOS.pedidos_status =:status');
          VQuery.ParamByName('ID').AsString := Params.ItemsString['idmesas'].AsString;
          VQuery.ParamByName('status').AsString := 'ABERTO';
          VQuery.Open();
          if(VQuery.RecordCount > 0) then
          begin
            VjsonValue.LoadFromDataset('', VQuery, VjsonValue.Encoded,Params.JsonMode);
            Result := VjsonValue.ToJSON;
          end
          else
          begin
            Result := '[{"Resposta":"N�o H� Pratos Registrados!"}]';
          end;
        end;
      except on E: Exception do
        raise Exception.Create(' Error ao Buscar ' + E.Message);
      end;
    end;
  end;
end;

procedure TDataModuleServidorRestFull.DWServerEvents1Eventspratos_complementosReplyEventByType(
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
      Vjsonobjeto:= TJSONObject.Create;
      try
        if (Params.ItemsString['idmesas'].AsString <> '') then
        begin
          VQuery.Close;
          VQuery.SQL.Clear;
          VQuery.SQL.Add('SELECT DISTINCT itens_complemento.iditens_complemento,itens_venda.itens_venda_quantidade,complemento.complemento_descricao,complemento.complemento_valor FROM itens_complemento');
          VQuery.SQL.Add('LEFT JOIN complemento ON idcomplemento = itens_idcomplemento');
          VQuery.SQL.Add('LEFT JOIN pedidos ON itens_idpedidos = idpedidos');
          VQuery.SQL.Add('LEFT JOIN ITENS_VENDA on itens_idpedido = itens_idpedidos');
          VQuery.SQL.Add('WHERE PEDIDOS.pedidos_idmesa =:ID');
          VQuery.SQL.Add('AND PEDIDOS.pedidos_status =:status');
          VQuery.ParamByName('ID').AsString := Params.ItemsString['idmesas'].AsString;
          VQuery.ParamByName('status').AsString := 'ABERTO';
          VQuery.Open();
          if(VQuery.RecordCount > 0) then
          begin
            VjsonValue.LoadFromDataset('', VQuery, VjsonValue.Encoded,Params.JsonMode);
            Result := VjsonValue.ToJSON;
          end
          else
          begin
            Result := '[{"Resposta":"N�o H� Pratos Registrados!"}]';
          end;
        end;
      except on E: Exception do
        raise Exception.Create('Error ao Buscar ' + E.Message);
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

procedure TDataModuleServidorRestFull.DWServerEvents1EventsvendasReplyEventByType(
  var Params: TDWParams; var Result: string; const RequestType: TRequestType;
  var StatusCode: Integer; RequestHeader: TStringList);
  var
  VjsonValue: uDWJSONObject.TJSONValue;
  Vjsonobjeto : TJSONObject;
  pedido : TVenda;
  idmesas : String;
begin
   pedido := TVenda.Create(VqueryVendas);
   VjsonValue := uDWJSONObject.TJSONValue.Create;
   case RequestType of
     rtPost:
     begin
      if Params.ItemsString['UNDEFINED'] <> nil then
      begin
        Vjsonobjeto := TJSONObject.ParseJSONValue(Params.ItemsString['UNDEFINED'].AsString) as TJSONObject;
        try
          pedido.VALORVENDA     := Vjsonobjeto.GetValue<Double>('VENDAS_VALOR_VENDA');
          pedido.DATAVENDA      := StrToDateTime(FormatDateTime('dd/mm/yyyy', Now));
          pedido.DESCRICAOVENDA := Vjsonobjeto.GetValue<String>('VENDAS_DESCRICAO_VENDA');
          pedido.FORMAPAGAMENTO := '1';
          pedido.PEDIDOSTATUS   := Vjsonobjeto.GetValue<String>('FPEDIDOSTATUS');
          pedido.FIDMESA        := Vjsonobjeto.GetValue<String>('IDMESA');
          pedido.Venda;
          Result := '[{"Resposta":" Pedido Gravado Com Sucess"}]';
        finally
          pedido.Free;
        end;
      end;
     end;
   end;
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
