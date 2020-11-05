unit Complementos;

interface
uses
  Data.DB, SysUtils, Forms, Vcl.Dialogs, FireDAC.Comp.Client,System.Generics.Collections;

  Type
    TComplementos = Class

      private

        FQry: TFDQuery;
        FITENS_IDCOMPLEMENTOS: Integer;
        FIDITENS_COMPLEMENTOS: Integer;
        FITENS_IDPEDIDOS: Integer;
        FIDMESAS: String;

        procedure SetIDITENS_COMPLEMENTOS(const Value: Integer);
        procedure SetITENS_IDCOMPLEMENTOS(const Value: Integer);
        procedure SetITENS_IDPEDIDOS(const Value: Integer);
        procedure SetIDMESAS(const Value: String);

      public

        constructor Create(aQry : TFDQuery);
        property IDITENS_COMPLEMENTOS : Integer read FIDITENS_COMPLEMENTOS write SetIDITENS_COMPLEMENTOS;
        property ITENS_IDCOMPLEMENTOS : Integer read FITENS_IDCOMPLEMENTOS write SetITENS_IDCOMPLEMENTOS;
        property ITENS_IDPEDIDOS : Integer read FITENS_IDPEDIDOS write SetITENS_IDPEDIDOS;
        property IDMESAS : String read FIDMESAS write SetIDMESAS;

        procedure Gravar_ItensComplementos;
       
    End;

implementation

{ TComplementos }

constructor TComplementos.Create(aQry: TFDQuery);
begin
  FQry := aQry;
end;

procedure TComplementos.Gravar_ItensComplementos;
var
itens_venda : String;
begin
  try

//    FQry.Close;
//    FQry.SQL.Clear;
//    FQry.SQL.Add('SELECT * FROM ITENS_VENDA');
//    FQry.SQL.Add('LEFT JOIN pedidos ON itens_venda.itens_idpedido = PEDIDOS.IDPEDIDOS');
//    FQry.SQL.Add('WHERE PEDIDOS.PEDIDOS_STATUS =:status');
//    FQry.SQL.Add('AND PEDIDOS.PEDIDOS_IDMESA =:id');
//    FQry.ParamByName('status').AsString := 'ABERTO';
//    FQry.ParamByName('id').AsString := IDMESAS;
//    FQry.Open();
//
//    if(FQry.RecordCount > 0)then
//    begin
//      itens_venda := FQry.FieldByName('IDITENS_VENDA').AsString;
//    end;

    FQry.Close;
    FQry.SQL.Clear;
    FQry.SQL.Add('INSERT INTO ITENS_COMPLEMENTO');
    FQry.SQL.Add('(ITENS_IDCOMPLEMENTO , ITENS_IDPEDIDOS,POST_TYPE,ITENS_IDITENS_VENDA)');
    FQry.SQL.Add('VALUES(:ITENS_IDCOMPLEMENTO ,:ITENS_IDPEDIDOS,:POST_TYPE,:ITENS_IDITENS_VENDA)');
//    if(itens_venda <> '') then
//    begin
//      FQry.ParamByName('ITENS_IDITENS_VENDA').AsString := itens_venda;
//    end;
    FQry.ParamByName('ITENS_IDCOMPLEMENTO').AsInteger := FITENS_IDCOMPLEMENTOS;
    FQry.ParamByName('ITENS_IDPEDIDOS').AsInteger := FITENS_IDPEDIDOS;
    FQry.ParamByName('POST_TYPE').AsInteger := 0;
    FQry.ExecSQL;

  except on E: Exception do
    raise Exception.Create('  Error no Cadastro de ItensComplementos! ' + E.Message);
  end;
end;

procedure TComplementos.SetIDITENS_COMPLEMENTOS(const Value: Integer);
begin
  FIDITENS_COMPLEMENTOS := Value;
end;

procedure TComplementos.SetIDMESAS(const Value: String);
begin
  FIDMESAS := Value;
end;

procedure TComplementos.SetITENS_IDCOMPLEMENTOS(const Value: Integer);
begin
  FITENS_IDCOMPLEMENTOS := Value;
end;

procedure TComplementos.SetITENS_IDPEDIDOS(const Value: Integer);
begin
  FITENS_IDPEDIDOS := Value;
end;

end.
