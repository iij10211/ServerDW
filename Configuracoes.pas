unit Configuracoes;

interface
type
  TConfiguracoesServer = Class

  private

    FPortBD: String;
    FPasswordBD: String;
    FSenhaServ: String;
    FHostBD: String;
    FUsuarioBD: STring;
    FUsuarioServ: String;
    FPortaServ: String;
    FCaminhoBD: String;

    procedure SetCaminhoBD(const Value: String);
    procedure SetHostBD(const Value: String);
    procedure SetPasswordBD(const Value: String);
    procedure SetPortaServ(const Value: String);
    procedure SetPortBD(const Value: String);
    procedure SetSenhaServ(const Value: String);
    procedure SetUsuarioBD(const Value: STring);
    procedure SetUsuarioServ(const Value: String);

  public

    property PortaServ : String read FPortaServ write SetPortaServ;
    property UsuarioServ : String read FUsuarioServ write SetUsuarioServ;
    property SenhaServ : String read FSenhaServ write SetSenhaServ;

    property PortBD : String read FPortBD write SetPortBD;
    property UsuarioBD : STring read FUsuarioBD write SetUsuarioBD;
    property PasswordBD : String read FPasswordBD write SetPasswordBD;
    property CaminhoBD : String read FCaminhoBD write SetCaminhoBD;
    property HostBD : String read FHostBD write SetHostBD;

    constructor Create;


  End;

implementation

{ TConfiguracoesServer }

constructor TConfiguracoesServer.Create;
begin

end;

procedure TConfiguracoesServer.SetCaminhoBD(const Value: String);
begin
  FCaminhoBD := Value;
end;

procedure TConfiguracoesServer.SetHostBD(const Value: String);
begin
  FHostBD := Value;
end;

procedure TConfiguracoesServer.SetPasswordBD(const Value: String);
begin
  FPasswordBD := Value;
end;

procedure TConfiguracoesServer.SetPortaServ(const Value: String);
begin
  FPortaServ := Value;
end;

procedure TConfiguracoesServer.SetPortBD(const Value: String);
begin
  FPortBD := Value;
end;

procedure TConfiguracoesServer.SetSenhaServ(const Value: String);
begin
  FSenhaServ := Value;
end;

procedure TConfiguracoesServer.SetUsuarioBD(const Value: STring);
begin
  FUsuarioBD := Value;
end;

procedure TConfiguracoesServer.SetUsuarioServ(const Value: String);
begin
  FUsuarioServ := Value;
end;

end.
