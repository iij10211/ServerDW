unit UPedidos;

interface

uses
  Data.DB, SysUtils, Forms, Vcl.Dialogs, FireDAC.Comp.Client;

type
  TVenda = class
  private
    FQry: TFDQuery;

    FDATAVENDA: TDateTime;
    FdFORMAPAGAMENTO: string;
    FVALORVENDA: Double;
    FDESCRICAOVENDA: string;

    // itens venda
    FFIDPRODUTO: Integer;
    FFIDVENDA: Integer;
    FFQUANTIDADE: Integer;
    FFIDCAIXA: Integer;
    FVENDA_IDTIPOCOBRANCA: string;
    FFITENS_MESA: Integer;
    FFITENS_VENDA_IDCOMPLEMENTO: Integer;
    // itens venda

    procedure SetDATAVENDA(const Value: TDateTime);
    procedure SetDESCRICAOVENDA(const Value: string);
    procedure SetFIDPRODUTO(const Value: Integer);
    procedure SetFIDVENDA(const Value: Integer);
    procedure SetFORMAPAGAMENTO(const Value: string);
    procedure SetVALORVENDA(const Value: Double);
    procedure SetFQUANTIDADE(const Value: Integer);
    procedure SetFIDCAIXA(const Value: Integer);
    procedure SetVENDA_IDTIPOCOBRANCA(const Value: string);
    procedure SetFITENS_MESA(const Value: Integer);
    procedure SetFITENS_VENDA_IDCOMPLEMENTO(const Value: Integer);

  public
    constructor Create(aQry: TFDQuery);

    property FIDCAIXA: Integer read FFIDCAIXA write SetFIDCAIXA;
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
  
    procedure Venda;
    procedure ItensVenda;
    procedure Movimentacoes;

  end;

implementation

{ TVenda }

constructor TVenda.Create(aQry: TFDQuery);
begin
  FQry := aQry;
end;

procedure TVenda.ItensVenda;
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
    FQry.SQL.Add('( VENDAS_IDVENDAS , ITENS_IDPRODUTO , ITENS_VENDA_QUANTIDADE , ITENS_VENDA_IDMESA  )');
    FQry.SQL.Add('VALUES( :VENDAS_IDVENDAS , :ITENS_IDPRODUTO , :ITENS_VENDA_QUANTIDADE , :ITENS_VENDA_IDMESA  )'); //ITENS_VENDA_IDCOMPLEMENTO

    FQry.ParamByName('VENDAS_IDVENDAS').AsInteger := FIDVENDA;
    FQry.ParamByName('ITENS_IDPRODUTO').AsInteger := FFIDPRODUTO;
    FQry.ParamByName('ITENS_VENDA_QUANTIDADE').AsInteger := FQUANTIDADE;
    FQry.ParamByName('ITENS_VENDA_IDMESA').AsInteger := FITENS_MESA;
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

procedure TVenda.SetDATAVENDA(const Value: TDateTime);
begin
  FDATAVENDA := Value;
end;

procedure TVenda.SetDESCRICAOVENDA(const Value: string);
begin
  FDESCRICAOVENDA := Value;
end;

procedure TVenda.SetFIDCAIXA(const Value: Integer);
begin
  FFIDCAIXA := Value;
end;

procedure TVenda.SetFIDPRODUTO(const Value: Integer);
begin
  FFIDPRODUTO := Value;
end;

procedure TVenda.SetFIDVENDA(const Value: Integer);
begin
  FFIDVENDA := Value;
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

procedure TVenda.SetFQUANTIDADE(const Value: Integer);
begin
  FFQUANTIDADE := Value;
end;

procedure TVenda.SetVALORVENDA(const Value: Double);
begin
  FVALORVENDA := Value;
end;

procedure TVenda.SetVENDA_IDTIPOCOBRANCA(const Value: string);
begin
  FVENDA_IDTIPOCOBRANCA := Value;
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

procedure TVenda.Venda;
begin
  try
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
 except on E: Exception do
    raise Exception.Create(' Error no Cadastro de Vendas! ');
  end;
end;

end.
