unit UPedidos;

interface
uses
  Data.DB, SysUtils, Forms, Vcl.Dialogs, FireDAC.Comp.Client,Classes;
type
  TVenda = class
  private

    FQry    : TFDQuery;
    FITEMS  : TStringList;

    FDATAVENDA: TDateTime;
    FdFORMAPAGAMENTO: string;
    FVALORVENDA: Double;
    FDESCRICAOVENDA: string;

    // itens venda
    FFIDPRODUTO: Integer;
    FFIDVENDA: Integer;
    FFQUANTIDADE: Integer;
    FVENDA_IDTIPOCOBRANCA: string;
    FFITENS_MESA: Integer;
    FFITENS_VENDA_IDCOMPLEMENTO: Integer;
    FFITENS_IDGRUPO: Integer;
    FPEDIDOSTATUS: string;
    FPEDIDOPESSOAS: Integer;
    FPEDIDOS_IDMESA: Integer;
    FIDPEDIDO: Integer;
    FIDTENS_MESA: Integer;
    FITENS_IDPEDIDOS: Integer;
    FITENS_IDCOMPLEMENTOS: Integer;
    FIDITENS_COMPLEMENTOS: Integer;
    FIDCAIXA: Integer;
    FITENS_VENDA_OBSERVACAO: String;
    FFPEDIDOSTATUS: String;
    FFIDMESA: String;

    procedure SetDATAVENDA(const Value: TDateTime);
    procedure SetDESCRICAOVENDA(const Value: string);
    procedure SetFIDPRODUTO(const Value: Integer);
    procedure SetFIDVENDA(const Value: Integer);
    procedure SetFITENS_IDGRUPO(const Value: Integer);
    procedure SetFITENS_MESA(const Value: Integer);
    procedure SetFITENS_VENDA_IDCOMPLEMENTO(const Value: Integer);
    procedure SetFORMAPAGAMENTO(const Value: string);
    procedure SetFQUANTIDADE(const Value: Integer);
    procedure SetIDITENS_COMPLEMENTOS(const Value: Integer);
    procedure SetIDPEDIDO(const Value: Integer);
    procedure SetIDTENS_MESA(const Value: Integer);
    procedure SetITENS_IDCOMPLEMENTOS(const Value: Integer);
    procedure SetITENS_IDPEDIDOS(const Value: Integer);
    procedure SetPEDIDOPESSOAS(const Value: Integer);
    procedure SetPEDIDOS_IDMESA(const Value: Integer);
    procedure SetPEDIDOSTATUS(const Value: string);
    procedure SetVALORVENDA(const Value: Double);
    procedure SetVENDA_IDTIPOCOBRANCA(const Value: string);
    procedure SetIDCAIXA(const Value: Integer);
    procedure SetITENS_VENDA_OBSERVACAO(const Value: String);
    procedure SetFPEDIDOSTATUS(const Value: String);
    procedure SetFIDMESA(const Value: String);


    public

    constructor Create(aQry: TFDQuery);
    property ITENS_VENDA_IDCOMPLEMENTO : Integer read FFITENS_VENDA_IDCOMPLEMENTO write SetFITENS_VENDA_IDCOMPLEMENTO;
    property FIDVENDA: Integer read FFIDVENDA write SetFIDVENDA;
    property FQUANTIDADE: Integer read FFQUANTIDADE write SetFQUANTIDADE;
    property FIDPRODUTO: Integer read FFIDPRODUTO write SetFIDPRODUTO;
    property VALORVENDA: Double read FVALORVENDA write SetVALORVENDA;
    property DATAVENDA: TDateTime read FDATAVENDA write SetDATAVENDA;
    property DESCRICAOVENDA: string read FDESCRICAOVENDA write SetDESCRICAOVENDA;
    property FORMAPAGAMENTO: string read FdFORMAPAGAMENTO write SetFORMAPAGAMENTO;
    property VENDA_IDTIPOCOBRANCA: string read FVENDA_IDTIPOCOBRANCA write SetVENDA_IDTIPOCOBRANCA;
    property FITENS_MESA : Integer read FFITENS_MESA write SetFITENS_MESA;
    property FITENS_IDGRUPO : Integer read FFITENS_IDGRUPO write SetFITENS_IDGRUPO;

    property PEDIDOSTATUS : string read FPEDIDOSTATUS write SetPEDIDOSTATUS;
    property PEDIDOPESSOAS :  Integer read FPEDIDOPESSOAS write SetPEDIDOPESSOAS;
    property PEDIDOS_IDMESA : Integer read FPEDIDOS_IDMESA write SetPEDIDOS_IDMESA;
    property IDPEDIDO : Integer read FIDPEDIDO write SetIDPEDIDO;
    property IDTENS_MESA : Integer read FIDTENS_MESA write SetIDTENS_MESA;

    property IDITENS_COMPLEMENTOS : Integer read FIDITENS_COMPLEMENTOS write SetIDITENS_COMPLEMENTOS;
    property ITENS_IDCOMPLEMENTOS : Integer read FITENS_IDCOMPLEMENTOS write SetITENS_IDCOMPLEMENTOS;
    property ITENS_IDPEDIDOS : Integer read FITENS_IDPEDIDOS write SetITENS_IDPEDIDOS;
    property IDCAIXA : Integer  read FIDCAIXA write SetIDCAIXA;
    property ITENS_VENDA_OBSERVACAO : String read FITENS_VENDA_OBSERVACAO write SetITENS_VENDA_OBSERVACAO;
    property FIDMESA : String   read FFIDMESA write SetFIDMESA;

    procedure ItensVenda;
    procedure Gravar_ItensComplementos;
    procedure Movimentacoes;
    procedure Venda;
    procedure PedidosMesa;
    procedure BuscaPedido;
    procedure Itens_Mesa;
    function  GetIdPedido  : Integer;

  end;

implementation

{ TVenda }

procedure TVenda.BuscaPedido;
begin
  try
    FQry.Close;
    FQry.SQL.Clear;
    FQry.SQL.Add('SELECT MAX(PEDIDOS.idpedidos) FROM PEDIDOS');       //MAX(PEDIDOS.idpedidos)
    FQry.Active := True;
    FIDPEDIDO := FQry.Fields[0].AsInteger;
  except on E: Exception do
  end;
end;

constructor TVenda.Create(aQry: TFDQuery);
begin
  FQry := aQry;
end;

function TVenda.GetIdPedido: Integer;
begin
  Result := FIDPEDIDO;
end;

procedure TVenda.Gravar_ItensComplementos;
var
itens_venda : String;
begin
  try

    FQry.Close;
    FQry.SQL.Clear;
    FQry.SQL.Add('INSERT INTO ITENS_COMPLEMENTO');
    FQry.SQL.Add('(ITENS_IDCOMPLEMENTO , ITENS_IDPEDIDOS,POST_TYPE)');
    FQry.SQL.Add('VALUES(:ITENS_IDCOMPLEMENTO ,:ITENS_IDPEDIDOS,:POST_TYPE)');
    FQry.ParamByName('ITENS_IDCOMPLEMENTO').AsInteger := FITENS_IDCOMPLEMENTOS;
    FQry.ParamByName('ITENS_IDPEDIDOS').AsInteger := FITENS_IDPEDIDOS;
    FQry.ParamByName('POST_TYPE').AsInteger := 0;
    FQry.ExecSQL;

  except on E: Exception do
    raise Exception.Create('  Error no Cadastro de ItensComplementos! ' + E.Message);
  end;
end;

procedure TVenda.ItensVenda;
var
itensvenda : TStringList;
i : Integer;
begin
  try
    FQry.Close;
    FQry.SQL.Clear;
    FQry.SQL.Add('select gen_id(gen_vendas_id, 0) from rdb$database');
    FQry.Active := True;
    FIDVENDA := FQry.Fields[0].AsInteger;

    FQry.Close;
    FQry.SQL.Clear;
    FQry.SQL.Add('INSERT INTO ITENS_VENDA');
    FQry.SQL.Add('(itens_venda.vendas_idvendas, itens_venda.itens_idproduto,itens_venda.itens_venda_quantidade,itens_venda.itens_venda_idmesa,itens_venda.itens_idpedido,ITENS_MESA_IDPEDIDO,POST_TYPE,ITENS_VENDA_OBSERVACAO)');
    FQry.SQL.Add('VALUES(:vendas_idvendas, :itens_idproduto,:itens_venda_quantidade,:itens_venda_idmesa,:itens_idpedido,:ITENS_MESA_IDPEDIDO,:POST_TYPE,:ITENS_VENDA_OBSERVACAO)'); //ITENS_VENDA_IDCOMPLEMENTO

    FQry.ParamByName('vendas_idvendas').AsInteger := FIDVENDA;
    FQry.ParamByName('itens_idproduto').AsInteger := FFIDPRODUTO;
    FQry.ParamByName('itens_venda_quantidade').AsInteger := FQUANTIDADE;
    FQry.ParamByName('itens_venda_idmesa').AsInteger := FITENS_MESA;
    FQry.ParamByName('itens_idpedido').AsInteger := FIDPEDIDO;
    FQry.ParamByName('ITENS_VENDA_OBSERVACAO').AsString := FITENS_VENDA_OBSERVACAO;
//    FQry.ParamByName('ITENS_MESA_IDPEDIDO').AsInteger := FIDTENS_MESA;
    FQry.ParamByName('POST_TYPE').AsInteger := 1;
    FQry.ExecSQL;

    FQry.Close;
    FQry.SQL.Clear;
    FQry.SQL.Add('UPDATE MESAS SET MESAS.MESAS_STATUS =:STATUS WHERE MESAS.IDMESAS = :IDMESA');
    FQry.ParamByName('IDMESA').AsInteger := FITENS_MESA;
    FQry.ParamByName('STATUS').AsInteger := 1;
    FQry.ExecSQL;

    FQry.Close;
    FQry.SQL.Clear;
    FQry.SQL.Add('UPDATE ESTOQUE SET ESTOQUE.ESTOQUEMAX = ESTOQUE.ESTOQUEMAX - :QUANT WHERE ESTOQUE.PRODUTO_IDPRODUTO = :IDPRO');
    FQry.ParamByName('QUANT').AsInteger := FQUANTIDADE;
    FQry.ParamByName('IDPRO').AsInteger := FFIDPRODUTO;
    FQry.ExecSQL;
  except
    on E: Exception do
      raise Exception.Create(' Error no Cadastro de Itens Vendas! ');
  end;
end;

procedure TVenda.Itens_Mesa;
begin
  try

    FQry.Close;
    FQry.SQL.Clear;
    FQry.SQL.Add('INSERT INTO ITENS_MESA');
    FQry.SQL.Add('(IDITENS_MESA)VALUES(:IDITENS_MESA)');
    FQry.ParamByName('IDITENS_MESA').AsInteger := FIDTENS_MESA;
    FQry.ExecSQL;

  except on E: Exception do
    raise Exception.Create('Error' + E.Message);
  end;
end;

procedure TVenda.Movimentacoes;
begin
  try
    FQry.Close;
    FQry.SQL.Clear;
    FQry.SQL.Add('select gen_id(gen_caixa_id, 0) from rdb$database');
    FQry.Active := True;
    FIDCAIXA := FQry.Fields[0].AsInteger;

    FQry.Close;
    FQry.SQL.Clear;
    FQry.SQL.Add('INSERT INTO MOVIMENTACOES');
    FQry.SQL.Add('( ENTRADA_MOVIMENTACOES , MOVIMENTACOES_IDVENDAS , MOVIMENTACOES_IDCAIXA , DATA_MOVIMENTACOES)');
    FQry.SQL.Add('VALUES(:ENTRADA_MOVIMENTACOES , :MOVIMENTACOES_IDVENDAS , :MOVIMENTACOES_IDCAIXA , :DATA_MOVIMENTACOES)');

    FQry.ParamByName('MOVIMENTACOES_IDVENDAS').AsInteger := FIDVENDA;
    FQry.ParamByName('MOVIMENTACOES_IDCAIXA').AsInteger  := FIDCAIXA;
    FQry.ParamByName('ENTRADA_MOVIMENTACOES').AsString := 'E';
    FQry.ParamByName('DATA_MOVIMENTACOES').AsDateTime := StrToDateTime(FormatDateTime('DD/MM/YYYY', Now));
    FQry.ExecSQL;
  except
    on E: Exception do
      raise Exception.Create(' Error no Inserir os Dados de Movimentacoes! ');
  end;
end;

procedure TVenda.PedidosMesa;
begin
  try
    FQry.Close;
    FQry.SQL.Clear;
    FQry.SQL.Add('INSERT INTO pedidos');
    FQry.SQL.Add('(pedidos.pedidos_status , pedidos.pedidos_pessoas , PEDIDOS_IDMESA , PEDIDOS_DATA)');
    FQry.SQL.Add('values(:pedidos_status , :pedidos_pessoas , :PEDIDOS_IDMESA , :PEDIDOS_DATA)');
    FQry.ParamByName('pedidos_status').AsString   := FPEDIDOSTATUS;
    FQry.ParamByName('pedidos_pessoas').AsInteger := FPEDIDOPESSOAS;
    FQry.ParamByName('PEDIDOS_IDMESA').AsInteger  := FPEDIDOS_IDMESA;
    FQry.ParamByName('PEDIDOS_DATA').AsDateTime   := StrToDateTime(FormatDateTime('dd/mm/yyyy', Now));
    FQry.ExecSQL;
  except on E: Exception do
    raise Exception.Create(' Error no Inserir os Dados na Mesa! ');
  end;
end;

procedure TVenda.SetDATAVENDA(const Value: TDateTime);
begin
  FDATAVENDA := Value;
end;

procedure TVenda.SetDESCRICAOVENDA(const Value: string);
begin
  FDESCRICAOVENDA := Value;
end;

procedure TVenda.SetFIDMESA(const Value: String);
begin
  FFIDMESA := Value;
end;

procedure TVenda.SetFIDPRODUTO(const Value: Integer);
begin
  FFIDPRODUTO := Value;
end;

procedure TVenda.SetFIDVENDA(const Value: Integer);
begin
  FFIDVENDA := Value;
end;

procedure TVenda.SetFITENS_IDGRUPO(const Value: Integer);
begin
  FFITENS_IDGRUPO := Value;
end;

procedure TVenda.SetFITENS_MESA(const Value: Integer);
begin
  FFITENS_MESA := Value;
end;

procedure TVenda.SetFITENS_VENDA_IDCOMPLEMENTO(const Value: Integer);
begin
  FFITENS_VENDA_IDCOMPLEMENTO := Value;
end;

procedure TVenda.SetFORMAPAGAMENTO(const Value: string);
begin
  FdFORMAPAGAMENTO := Value;
end;

procedure TVenda.SetFPEDIDOSTATUS(const Value: String);
begin
  FFPEDIDOSTATUS := Value;
end;

procedure TVenda.SetFQUANTIDADE(const Value: Integer);
begin
  FFQUANTIDADE := Value;
end;

procedure TVenda.SetIDCAIXA(const Value: Integer);
begin
  FIDCAIXA := Value;
end;

procedure TVenda.SetIDITENS_COMPLEMENTOS(const Value: Integer);
begin
  FIDITENS_COMPLEMENTOS := Value;
end;

procedure TVenda.SetIDPEDIDO(const Value: Integer);
begin
  FIDPEDIDO := Value;
end;

procedure TVenda.SetIDTENS_MESA(const Value: Integer);
begin
  FIDTENS_MESA := Value;
end;

procedure TVenda.SetITENS_IDCOMPLEMENTOS(const Value: Integer);
begin
  FITENS_IDCOMPLEMENTOS := Value;
end;

procedure TVenda.SetITENS_IDPEDIDOS(const Value: Integer);
begin
  FITENS_IDPEDIDOS := Value;
end;

procedure TVenda.SetITENS_VENDA_OBSERVACAO(const Value: String);
begin
  FITENS_VENDA_OBSERVACAO := Value;
end;

procedure TVenda.SetPEDIDOPESSOAS(const Value: Integer);
begin
  FPEDIDOPESSOAS := Value;
end;

procedure TVenda.SetPEDIDOSTATUS(const Value: string);
begin
  FPEDIDOSTATUS := Value;
end;

procedure TVenda.SetPEDIDOS_IDMESA(const Value: Integer);
begin
  FPEDIDOS_IDMESA := Value;
end;

procedure TVenda.SetVALORVENDA(const Value: Double);
begin
  FVALORVENDA := Value;
end;

procedure TVenda.SetVENDA_IDTIPOCOBRANCA(const Value: string);
begin
  FVENDA_IDTIPOCOBRANCA := Value;
end;

procedure Tvenda.Venda;
var
idvenda :Integer;
valorvenda : Double;
begin
 try
    idvenda := 0;
    valorvenda := 0.00;
    if(FPEDIDOSTATUS = 'EM CONSUMO')then
    begin

      FQry.Close;
      FQry.SQL.Clear;
      FQry.SQL.Add('SELECT * FROM VENDAS');
      FQry.SQL.Add('LEFT JOIN ITENS_VENDA ON VENDAS.idvendas = itens_venda.vendas_idvendas');
      FQry.SQL.Add('LEFT JOIN PEDIDOS ON itens_venda.itens_idpedido = PEDIDOS.idpedidos');
      FQry.SQL.Add('WHERE itens_venda.itens_venda_idmesa =:idmesa');
      FQry.SQL.Add('AND PEDIDOS.pedidos_status =:status');
      FQry.ParamByName('idmesa').AsString := FIDMESA;
      FQry.ParamByName('status').AsString := 'ABERTO';
      FQry.Active := True;

      if(FQry.RecordCount > 0) then
      begin
        valorvenda := FQry.FieldByName('VENDAS_VALOR_VENDA').AsFloat;
        idvenda    := FQry.FieldByName('VENDAS_IDVENDAS').AsInteger;

        FQry.Close;
        FQry.SQL.Clear;
        FQry.SQL.Add('UPDATE VENDAS SET VENDAS.VENDAS_VALOR_VENDA =:VALOR');
        FQry.SQL.Add('WHERE VENDAS.IDVENDAS =:id');
        FQry.ParamByName('id').AsInteger  := idvenda;
        FQry.ParamByName('VALOR').AsFloat := valorvenda + FVALORVENDA;
        FQry.ExecSQL;
      end;
    end
    else if(FPEDIDOSTATUS = 'OCUPADA')then
    begin
      FQry.Close;
      FQry.SQL.Clear;
      FQry.SQL.Add('INSERT INTO VENDAS');
      FQry.SQL.Add('( VENDAS_VALOR_VENDA , VENDAS_DTVENDAS , VENDAS_DESCRICAO_VENDA , VENDAS_IDFORMA_PAGAMENTO)');
      FQry.SQL.Add('VALUES( :VENDAS_VALOR_VENDA , :VENDAS_DTVENDAS , :VENDAS_DESCRICAO_VENDA , :VENDAS_IDFORMA_PAGAMENTO)');

      FQry.ParamByName('VENDAS_VALOR_VENDA').AsFloat := FVALORVENDA;
      FQry.ParamByName('VENDAS_DTVENDAS').AsDateTime := StrToDateTime(FormatDateTime('dd/mm/yyyy', Now));
      FQry.ParamByName('VENDAS_DESCRICAO_VENDA').AsString := FDESCRICAOVENDA;
      FQry.ParamByName('VENDAS_IDFORMA_PAGAMENTO').AsString:= FdFORMAPAGAMENTO;
      FQry.ExecSQL;
    end;
 except on E: Exception do
    raise Exception.Create(' Error no Cadastro de Vendas! ');
  end;
end;

end.
