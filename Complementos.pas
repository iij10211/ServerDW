unit Complementos;

interface
uses
  Data.DB, SysUtils, Forms, Vcl.Dialogs, FireDAC.Comp.Client;

  Type
    TComplementos = Class

      private

        FQry: TFDQuery;
        FITENS_IDCOMPLEMENTOS: Integer;
        FIDITENS_COMPLEMENTOS: Integer;
        FITENS_IDPEDIDOS: Integer;

        procedure SetIDITENS_COMPLEMENTOS(const Value: Integer);
        procedure SetITENS_IDCOMPLEMENTOS(const Value: Integer);
        procedure SetITENS_IDPEDIDOS(const Value: Integer);

      public

        constructor Create(aQry : TFDQuery);
        property IDITENS_COMPLEMENTOS : Integer read FIDITENS_COMPLEMENTOS write SetIDITENS_COMPLEMENTOS;
        property ITENS_IDCOMPLEMENTOS : Integer read FITENS_IDCOMPLEMENTOS write SetITENS_IDCOMPLEMENTOS;
        property ITENS_IDPEDIDOS : Integer read FITENS_IDPEDIDOS write SetITENS_IDPEDIDOS;

        procedure Gravar_ItensComplementos;
       
    End;

implementation

{ TComplementos }

constructor TComplementos.Create(aQry: TFDQuery);
begin
  FQry := aQry;
end;

procedure TComplementos.Gravar_ItensComplementos;
begin
  try

    FQry.Close;
    FQry.SQL.Clear;
    FQry.SQL.Add('INSERT INTO ITENS_COMPLEMENTO');
    FQry.SQL.Add('(ITENS_IDCOMPLEMENTO , ITENS_IDPEDIDOS)');
    FQry.SQL.Add('VALUES(:ITENS_IDCOMPLEMENTO ,:ITENS_IDPEDIDOS)');
    FQry.ParamByName('ITENS_IDCOMPLEMENTO').AsInteger := FITENS_IDCOMPLEMENTOS;
    FQry.ParamByName('ITENS_IDPEDIDOS').AsInteger := FITENS_IDPEDIDOS;
    FQry.ExecSQL;

  except on E: Exception do
    raise Exception.Create('  Error no Cadastro de ItensComplementos! ' + E.Message);
  end;
end;

procedure TComplementos.SetIDITENS_COMPLEMENTOS(const Value: Integer);
begin
  FIDITENS_COMPLEMENTOS := Value;
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
