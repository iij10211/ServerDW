unit UPedidos;

interface

uses
  Data.DB, SysUtils, Forms, Vcl.Dialogs, uRESTDWPoolerDB,
  URESTDWDataBase1ConexaoArquivo;

type
  TVenda = class

  private

    FrestSql: TRESTDWClientSQL;
    FrestDataBase: TURESTDWDataBaseConection;
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

  public

    property FIDCAIXA: Integer read FFIDCAIXA write SetFIDCAIXA;
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
    constructor Create;

  end;

implementation


{ TVenda }

constructor TVenda.Create;
begin
  FrestSql := TRESTDWClientSQL.Create(nil);
  FrestDataBase := TURESTDWDataBaseConection.Create;
  FrestDataBase.ConetaServidor;
  FrestSql.BinaryRequest := True;
  FrestSql.DataBase := FrestDataBase.RESTDWDataBase1;
end;

procedure TVenda.ItensVenda;
var
  verror: string;
begin

  try

    FrestSql.Close;
    FrestSql.SQL.Clear;
    FrestSql.SQL.Add('SELECT MAX(vendas.IDVENDAS) AS ID FROM VENDAS');
    FrestSql.Active := True;
    FIDVENDA := FrestSql.FieldByName('ID').AsInteger;

    FrestSql.Close;
    FrestSql.SQL.Clear;
    FrestSql.SQL.Add('INSERT INTO ITENS_VENDA');
    FrestSql.SQL.Add('( VENDAS_IDVENDAS , ITENS_IDPRODUTO , ITENS_VENDA_QUANTIDADE , ITENS_VENDA_IDMESA )');
    FrestSql.SQL.Add('VALUES( :VENDAS_IDVENDAS , :ITENS_IDPRODUTO , :ITENS_VENDA_QUANTIDADE , :ITENS_VENDA_IDMESA)');

    if IntToStr(FIDVENDA) <> '' then
    begin
      FrestSql.ParamByName('VENDAS_IDVENDAS').AsInteger := FIDVENDA;
      FrestSql.ParamByName('ITENS_IDPRODUTO').AsInteger := FFIDPRODUTO;
      FrestSql.ParamByName('ITENS_VENDA_QUANTIDADE').AsInteger := FQUANTIDADE;
      FrestSql.ParamByName('ITENS_VENDA_IDMESA').AsInteger := FITENS_MESA;
      FrestSql.ExecSQL(verror);
    end;

    FrestSql.Close;
    FrestSql.SQL.Clear;
    FrestSql.SQL.Add('UPDATE MESA SET MESA.MESA_STATUS =:STATUS WHERE MESA.IDMESA = :IDMESA');
    FrestSql.ParamByName('IDMESA').AsInteger := FITENS_MESA;
    FrestSql.ParamByName('STATUS').AsInteger := 1;
    FrestSql.ExecSQL(verror);

    FrestSql.Close;
    FrestSql.SQL.Clear;
    FrestSql.SQL.Add('UPDATE ESTOQUE SET ESTOQUE.ESTOQUEMAX = ESTOQUE.ESTOQUEMAX - :QUANT WHERE ESTOQUE.PRODUTO_IDPRODUTO = :IDPRO');
    FrestSql.ParamByName('QUANT').AsInteger := FQUANTIDADE;
    FrestSql.ParamByName('IDPRO').AsInteger := FFIDPRODUTO;
    FrestSql.ExecSQL(verror);

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
var
  verror: string;
begin

  try

    FrestSql.Close;
    FrestSql.SQL.Clear;
    FrestSql.SQL.Add('SELECT MAX(CAIXA.idcaixa) AS ID FROM CAIXA');
    FrestSql.Active := True;
    FIDCAIXA := FrestSql.FieldByName('ID').AsInteger;

    FrestSql.Close;
    FrestSql.SQL.Clear;
    FrestSql.SQL.Add('INSERT INTO MOVIMENTACOES');
    FrestSql.SQL.Add('( ENTRADA_MOVIMENTACOES , MOVIMENTACOES_IDVENDAS , MOVIMENTACOES_IDCAIXA , DATA_MOVIMENTACOES)');
    FrestSql.SQL.Add('VALUES(:ENTRADA_MOVIMENTACOES , :MOVIMENTACOES_IDVENDAS , :MOVIMENTACOES_IDCAIXA , :DATA_MOVIMENTACOES)');

    if (IntToStr(FIDVENDA) <> '') AND (IntToStr(FIDCAIXA) <> '') then
    begin
      FrestSql.ParamByName('MOVIMENTACOES_IDVENDAS').AsInteger := FIDVENDA;
      FrestSql.ParamByName('MOVIMENTACOES_IDCAIXA').AsInteger  := FIDCAIXA;
      FrestSql.ParamByName('ENTRADA_MOVIMENTACOES').AsString := 'E';
      FrestSql.ParamByName('DATA_MOVIMENTACOES').AsDateTime := StrToDateTime(FormatDateTime('DD/MM/YYYY', Now));
      FrestSql.ExecSQL(verror);
    end;

  except
    on E: Exception do
      raise Exception.Create(' Error no Cadastro de Movimentacoes! ');
  end;
end;

procedure TVenda.Venda;
var
  verror: string;
begin
  try
    FrestSql.Close;
    FrestSql.SQL.Clear;
    FrestSql.SQL.Add('INSERT INTO VENDAS');
    FrestSql.SQL.Add('( VENDAS_VALOR_VENDA , DATAVENDA , DESCRICAOVENDA , VENDAFORMAPAGAMENTO)');
    FrestSql.SQL.Add('VALUES( :VENDAS_VALOR_VENDA , :DATAVENDA , :DESCRICAOVENDA , :VENDAFORMAPAGAMENTO)');
    FrestSql.ParamByName('VENDAS_VALOR_VENDA').AsFloat :=FVALORVENDA;
    FrestSql.ParamByName('DATAVENDA').AsDateTime :=StrToDateTime(FormatDateTime('dd/mm/yyyy', Now));
    FrestSql.ParamByName('DESCRICAOVENDA').AsString :=FDESCRICAOVENDA;
    FrestSql.ParamByName('VENDAFORMAPAGAMENTO').AsString:= FdFORMAPAGAMENTO;
    FrestSql.ExecSQL(verror);
 except on E: Exception do
    raise Exception.Create(' Error no Cadastro de Vendas! ');
  end;
end;

end.