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

        procedure SetIDITENS_COMPLEMENTOS(const Value: Integer);
        procedure SetITENS_IDCOMPLEMENTOS(const Value: Integer);

      public

        constructor Create(aQry : TFDQuery);

        property IDITENS_COMPLEMENTOS : Integer read FIDITENS_COMPLEMENTOS write SetIDITENS_COMPLEMENTOS;
        property ITENS_IDCOMPLEMENTOS : Integer read FITENS_IDCOMPLEMENTOS write SetITENS_IDCOMPLEMENTOS;

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
    FQry.SQL.Add('INSERT INTO ITENS_COMPLEMENTOS');
    FQry.SQL.Add('( ITENS_COMPLEMENTOS_DATA , ITENS_IDCOMPLEMENTOS)');
    FQry.SQL.Add('VALUES(:ITENS_COMPLEMENTOS_DATA , :ITENS_IDCOMPLEMENTOS )');

    FQry.ParamByName('ITENS_COMPLEMENTOS_DATA').AsDateTime := StrToDateTime(FormatDateTime('DD/MM/YYYY', Now));
    FQry.ParamByName('ITENS_IDCOMPLEMENTOS').AsInteger := FITENS_IDCOMPLEMENTOS;
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

end.
