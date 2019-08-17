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
  uDWConsts, uRESTDWServerContext;

type

    TDataModuleServidorRestFull = class(TServerMethodDataModule)
    FDGUIxWaitCursor1: TFDGUIxWaitCursor;
    FDPhysFBDriverLink1: TFDPhysFBDriverLink;
    FDConnection1: TFDConnection;
    DWServerEvents1: TDWServerEvents;
    VQuery: TFDQuery;
    RESTDWPoolerDB1: TRESTDWPoolerDB;
    RESTDWDriverFD1: TRESTDWDriverFD;
    FDStanStorageBinLink1: TFDStanStorageBinLink;

    procedure ArquivoConfiguracao;
    procedure ConfigurarConexao;
    procedure LerArquivo;

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
   
  private

    FFCaminhoBD: string;
    FFPortBD: Integer;
    FFPasswordBD: string;
    FFSenhaServ: string;
    FFHostBD: string;
    FFUsuarioBD: string;
    FFUsuarioServ: string;
    FFPortaServ: string;

    procedure SetFCaminhoBD(const Value: string);
    procedure SetFHostBD(const Value: string);
    procedure SetFPasswordBD(const Value: string);
    procedure SetFPortaServ(const Value: string);
    procedure SetFPortBD(const Value: Integer);
    procedure SetFSenhaServ(const Value: string);
    procedure SetFUsuarioBD(const Value: string);
    procedure SetFUsuarioServ(const Value: string);

    { Private declarations }
  public

    property FCaminhoBD: string read FFCaminhoBD write SetFCaminhoBD;
    property FUsuarioBD: string read FFUsuarioBD write SetFUsuarioBD;
    property FPasswordBD: string read FFPasswordBD write SetFPasswordBD;
    property FHostBD: string read FFHostBD write SetFHostBD;
    property FPortBD: Integer read FFPortBD write SetFPortBD;
    property FPortaServ: string read FFPortaServ write SetFPortaServ;
    property FUsuarioServ: string read FFUsuarioServ write SetFUsuarioServ;
    property FSenhaServ: string read FFSenhaServ write SetFSenhaServ;

    { Public declarations }
  end;

var
  DataModuleServidorRestFull: TDataModuleServidorRestFull;

implementation
uses UServidorRest,UCliente,UCCategoria;

{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}

procedure TDataModuleServidorRestFull.ArquivoConfiguracao;
var
  arquivoIni: TIniFile;
begin

  if not DirectoryExists('C:\MaxSystemConfig') then
  begin
    ForceDirectories('C:\MaxSystemConfig');
  end;
  if not FileExists('C:\MaxSystemConfig\ConfiguracaoRemota.ini') then
  begin
    arquivoIni := TIniFile.Create('C:\MaxSystemConfig\ConfiguracaoRemota.ini');
    try
      arquivoIni.WriteString('config', 'Driver', 'FB');
      arquivoIni.WriteString('config', 'Caminho', Trim(FFCaminhoBD));
      arquivoIni.WriteString('config', 'User', FUsuarioBD);
      arquivoIni.WriteString('config', 'Key', FFPasswordBD);
      arquivoIni.WriteString('config', 'Server', FHostBD);
      arquivoIni.WriteString('config', 'Port', IntToStr(FPortBD));
      arquivoIni.WriteString('config', 'UserSv', FUsuarioServ);
      arquivoIni.WriteString('config', 'KeySv', FSenhaServ);
      arquivoIni.WriteString('config', 'PortSv', FPortaServ);
    finally
      arquivoIni.Free;
    end;
  end;
end;

procedure TDataModuleServidorRestFull.ConfigurarConexao;
var
arquivoIni: TIniFile;
begin
  ArquivoConfiguracao;
  if FileExists('C:\MaxSystemConfig\ConfiguracaoRemota.ini') then
  begin
    arquivoIni := TIniFile.Create('C:\MaxSystemConfig\ConfiguracaoRemota.ini');
    try
      try
        FDConnection1.Params.DriverID := arquivoIni.ReadString('config','Driver', '');
        FDConnection1.Params.Database := arquivoIni.ReadString('config','Caminho', '');
        FDConnection1.Params.UserName := arquivoIni.ReadString('config','User', '');
        FDConnection1.Params.Password := arquivoIni.ReadString('config','Key', '');
        FDConnection1.Params.Values['Server'] := arquivoIni.ReadString('config','Server', '');
        if FDConnection1.Connected = false then
        begin
          FDConnection1.Connected := true;
        end;
      except
        on E: Exception do
        raise Exception.Create(' Erro ao conectar a DataBase ' + E.Message);
      end;
    finally
      FDConnection1.Connected := false;
      arquivoIni.Free;
    end;
  end;
end;

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
    Result := '{"reply":"Não Existe!:"}';
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
        raise Exception.Create(' Não foi Possivel Localizar ' + E.Message);
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
                categoria.Id              := Vjsonobjeto.GetValue<string>('IDCATEGORIA');
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

procedure TDataModuleServidorRestFull.DWServerEvents1EventsclienteReplyEventByType(
  var Params: TDWParams; var Result: string; const RequestType: TRequestType;
  var StatusCode: Integer; RequestHeader: TStringList);
  var
  Vjsonobjeto : TJSONObject;
  cliente : TCliente;
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
            cliente := TCliente.Create;
            Vjsonobjeto := TJSONObject.ParseJSONValue(Params.ItemsString['UNDEFINED'].AsString) as TJSONObject;
            cliente.NOME              := Vjsonobjeto.GetValue<string>('nome');
            cliente.tipopessoa        := Vjsonobjeto.GetValue<string>('tipopessoa');
            cliente.telefone          := Vjsonobjeto.GetValue<string>('telefone');
            cliente.cpf               := Vjsonobjeto.GetValue<string>('cpf');
            cliente.cnpj              := Vjsonobjeto.GetValue<string>('cnpj');
            cliente.email             := Vjsonobjeto.GetValue<string>('email');
            cliente.datanascimento    := Vjsonobjeto.GetValue<string>('datanascimento');
            cliente.CARGO_IDCARGO     := 1;
            cliente.Novo;
          except on E: Exception do
            raise Exception.Create('Erro ao Inserir Dados' + E.Message);
          end;
          Result := '{"Sucess":"Gravado com Sucesso"}';
        finally
          cliente.Free;
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
begin
  user := '';
  password := '';
  resultado := '';

  if ((Params.ItemsString['user'].AsString) <> '') and ((Params.ItemsString['password'].AsString) <> '') then
  begin

    user :=  Params.ItemsString['user'].AsString;
    password := Params.ItemsString['password'].AsString;

    VjsonValue := uDWJSONObject.TJSONValue.Create;
    try
      VQuery.Close;
      VQuery.SQL.Clear;
      VQuery.SQL.Add('SELECT * FROM USUARIO');
      VQuery.SQL.Add('WHERE IDUSUARIO IS NOT NULL');
      if (user <> '') and (password <> '') then
      begin
        VQuery.SQL.Add('AND usuario.nomeusuario =:user And usuario.senhausuario =:password');
        VQuery.ParamByName('user').AsString := user;
        VQuery.ParamByName('password').AsString := password;
      end;
      VQuery.Open();
      if VQuery.RecordCount > 0 then
      begin
        Result := '[{"Resposta":"Sucess"}]';
//        VjsonValue.LoadFromDataset('', VQuery, VjsonValue.Encoded,Params.JsonMode);
//        Result := VjsonValue.ToJSON;
      end
      else
      begin
        Result := '[{"Resposta":"No Sucess"}]';
      end;
    finally
      if VQuery.Active then
      begin
        VQuery.Close;
        VjsonValue.Free;
      end;
    end;
  end
  else
    Result := '{"reply":"Usuario Não Encontrado!:"}';
end;

procedure TDataModuleServidorRestFull.LerArquivo;
var
  arquivoIni: TIniFile;
begin
  if FileExists('C:\MaxSystemConfig\ConfiguracaoRemota.ini') then
  begin
    arquivoIni := TIniFile.Create('C:\MaxSystemConfig\ConfiguracaoRemota.ini');
    try
      FFCaminhoBD := arquivoIni.ReadString('config', 'Caminho', '');
      FUsuarioBD  := arquivoIni.ReadString('config', 'User', '');
      FPasswordBD := arquivoIni.ReadString('config', 'Key', '');
      FFHostBD    := arquivoIni.ReadString('config', 'Server', '');

      FPortaServ  := arquivoIni.ReadString('config', 'Port', '');
      FUsuarioServ:= arquivoIni.ReadString('config', 'UserSv', '');
      FSenhaServ  := arquivoIni.ReadString('config', 'KeySv', '');
      FPortaServ  := arquivoIni.ReadString('config', 'PortSv', '');
    finally
      arquivoIni.Free;
    end;
  end;
end;

procedure TDataModuleServidorRestFull.ServerMethodDataModuleCreate
  (Sender: TObject);
begin
  if FileExists('C:\MaxSystemConfig\ConfiguracaoRemota.ini') then
  begin
    ConfigurarConexao;
  end;
end;

procedure TDataModuleServidorRestFull.SetFCaminhoBD(const Value: string);
begin
  FFCaminhoBD := Value;
end;

procedure TDataModuleServidorRestFull.SetFHostBD(const Value: string);
begin
  FFHostBD := Value;
end;

procedure TDataModuleServidorRestFull.SetFPasswordBD(const Value: string);
begin
  FFPasswordBD := Value;
end;

procedure TDataModuleServidorRestFull.SetFPortaServ(const Value: string);
begin
  FFPortaServ := Value;
end;

procedure TDataModuleServidorRestFull.SetFPortBD(const Value: Integer);
begin
  FFPortBD := Value;
end;

procedure TDataModuleServidorRestFull.SetFSenhaServ(const Value: string);
begin
  FFSenhaServ := Value;
end;

procedure TDataModuleServidorRestFull.SetFUsuarioBD(const Value: string);
begin
  FFUsuarioBD := Value;
end;

procedure TDataModuleServidorRestFull.SetFUsuarioServ(const Value: string);
begin
  FFUsuarioServ := Value;
end;

end.
