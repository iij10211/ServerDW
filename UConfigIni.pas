unit UConfigIni;

interface

uses
  System.SysUtils;

type
  TConfigIni = class
  private
    FCaminhoBD: string;
    FPortBD: Integer;
    FPasswordBD: string;
    FSenhaServ: string;
    FHostBD: string;
    FUsuarioBD: string;
    FUsuarioServ: string;
    FPortaServ: string;
    FDriverID: string;
  public
    constructor Create;
    destructor Destroy; override;

    procedure WriteIni;
    procedure ReadIni;

    property DriverID: string read FDriverID write FDriverID;
    property CaminhoBD: string read FCaminhoBD write FCaminhoBD;
    property UsuarioBD: string read FUsuarioBD write FUsuarioBD;
    property PasswordBD: string read FPasswordBD write FPasswordBD;
    property HostBD: string read FHostBD write FHostBD;
    property PortBD: Integer read FPortBD write FPortBD;
    property PortaServ: string read FPortaServ write FPortaServ;
    property UsuarioServ: string read FUsuarioServ write FUsuarioServ;
    property SenhaServ: string read FSenhaServ write FSenhaServ;
  end;

implementation

uses
  System.IniFiles;

{ TConfigIni }

procedure TConfigIni.WriteIni;
var
  arquivoIni: TIniFile;
begin
  if not DirectoryExists('C:\MaxSystemConfig') then
  begin
    ForceDirectories('C:\MaxSystemConfig');
  end;

  if FileExists('C:\MaxSystemConfig\ConfiguracaoRemota.ini') then
  begin
    arquivoIni := TIniFile.Create('C:\MaxSystemConfig\ConfiguracaoRemota.ini');
    try
      if (FDriverID <> 'FB') then
        FDriverID := 'FB';
      arquivoIni.WriteString('config', 'Driver',  FDriverID);

      arquivoIni.WriteString('config', 'Caminho', Trim(FCaminhoBD));
      arquivoIni.WriteString('config', 'User',    FUsuarioBD);
      arquivoIni.WriteString('config', 'Key',     FPasswordBD);
      arquivoIni.WriteString('config', 'Server',  FHostBD);
      arquivoIni.WriteString('config', 'Port',    IntToStr(FPortBD));
      arquivoIni.WriteString('config', 'UserSv',  FUsuarioServ);
      arquivoIni.WriteString('config', 'KeySv',   FSenhaServ);
      arquivoIni.WriteString('config', 'PortSv',  FPortaServ);
    finally
      arquivoIni.Free;
    end;
  end;
end;

constructor TConfigIni.Create;
begin

end;

destructor TConfigIni.Destroy;
begin

  inherited;
end;

procedure TConfigIni.ReadIni;
var
  arquivoIni: TIniFile;
begin
  if FileExists('C:\MaxSystemConfig\ConfiguracaoRemota.ini') then
  begin
    arquivoIni := TIniFile.Create('C:\MaxSystemConfig\ConfiguracaoRemota.ini');
    try
      FDriverID    := arquivoIni.ReadString('config', 'Driver', 'FB');
      FCaminhoBD   := arquivoIni.ReadString('config', 'Caminho', '');
      FUsuarioBD   := arquivoIni.ReadString('config', 'User', '');
      FPasswordBD  := arquivoIni.ReadString('config', 'Key', '');
      FHostBD      := arquivoIni.ReadString('config', 'Server', '');
      FPortBD      := StrToInt( arquivoIni.ReadString('config', 'Port', '0') );

      FPortaServ   := arquivoIni.ReadString('config', 'PortSv', '');
      FUsuarioServ := arquivoIni.ReadString('config', 'UserSv', '');
      FSenhaServ   := arquivoIni.ReadString('config', 'KeySv', '');
      FPortaServ   := arquivoIni.ReadString('config', 'PortSv', '');
    finally
      arquivoIni.Free;
    end;
  end;
end;

end.
