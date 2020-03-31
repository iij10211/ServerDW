unit UServidorRest;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, uDWAbout, uRESTDWBase,
  Vcl.ExtCtrls, Vcl.Buttons, Vcl.Menus, System.ImageList, Vcl.ImgList,
  Vcl.Imaging.GIFImg,Configuracoes, UConfigIni;

type
  TFServidor = class(TForm)
    Button1: TButton;
    edt_PortaDW: TEdit;
    edt_UserDW: TEdit;
    edt_PasswordDW: TEdit;
    Button2: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    labConexao: TLabel;
    labDBConfig: TLabel;
    edt_PortaDB: TEdit;
    edt_UsuarioDB: TEdit;
    edt_PasswordDB: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    edt_Database: TEdit;
    Label7: TLabel;
    lSeguro: TLabel;
    OpenDialog1: TOpenDialog;
    edt_HostDB: TEdit;
    Label8: TLabel;
    TrayIcon1: TTrayIcon;
    PopupMenu1: TPopupMenu;
    Sair1: TMenuItem;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Button3: TButton;
    RESTServicePooler1: TRESTServicePooler;
    RESTDWServiceNotification1: TRESTDWServiceNotification;
    idcaixa: TLabel;

    procedure Button1Click(Sender: TObject);
    procedure IniciarServidor;
    procedure PararServidor;
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Sair1Click(Sender: TObject);
    procedure TrayIcon1DblClick(Sender: TObject);
    procedure Minimizar;
    procedure Button3Click(Sender: TObject);

  private
    FConfigIni: TConfigIni;
    procedure GetParametros;
    procedure SetParametros;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FServidor: TFServidor;

implementation

uses
UDataModuloServidorRest, URecurso;

{$R *.dfm}

procedure TFServidor.Button1Click(Sender: TObject);
var
  recurso: TRecurso;
begin
  recurso := TRecurso.Create;
  try
    IniciarServidor;
    recurso.Desabilitar(FServidor);
  finally
    recurso.Free;
  end;
end;

procedure TFServidor.Button2Click(Sender: TObject);
var
  recurso: TRecurso;
begin
  recurso := TRecurso.Create;
  try
    PararServidor;
    recurso.Habilitar(FServidor);
  finally
    recurso.Free;
  end;
end;

procedure TFServidor.Button3Click(Sender: TObject);
var
  bdcaminho: string;
begin
  OpenDialog1.Filter := 'FDB DB (*.fdb)|*.FDB';
  if OpenDialog1.Execute then
  begin
    bdcaminho := OpenDialog1.FileName;
    edt_Database.Text := Trim(bdcaminho);
  end;
end;

procedure TFServidor.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Minimizar;
end;

procedure TFServidor.FormCreate(Sender: TObject);
begin
  RESTServicePooler1.ServerMethodClass := TDataModuleServidorRestFull;

  FConfigIni := TConfigIni.Create;
  FConfigIni.ReadIni;
  GetParametros;
end;

procedure TFServidor.SetParametros;
begin
  FConfigIni.PortaServ   := Trim(edt_PortaDW.Text);
  FConfigIni.UsuarioServ := Trim(edt_UserDW.Text);
  FConfigIni.SenhaServ   := Trim(edt_PasswordDW.Text);
  FConfigIni.PortBD      := StrToInt(edt_PortaDB.Text);
  FConfigIni.UsuarioBD   := Trim(edt_UsuarioDB.Text);
  FConfigIni.PasswordBD  := Trim(edt_PasswordDB.Text);
  FConfigIni.CaminhoBD   := Trim(edt_Database.Text);
  FConfigIni.HostBD      := Trim(edt_HostDB.Text);

  FConfigIni.WriteIni;
end;

procedure TFServidor.IniciarServidor;
begin
  SetParametros;

  if Not RESTServicePooler1.Active then
  begin
    RESTServicePooler1.ServerParams.UserName := Trim(edt_UserDW.Text);
    RESTServicePooler1.ServerParams.Password := Trim(edt_PasswordDW.Text);
    RESTServicePooler1.ServicePort           := StrToInt(edt_PortaDW.Text);
    RESTServicePooler1.Active                := True;

    if RESTServicePooler1.Active = True then
    begin
      lSeguro.Caption := ' SERVIDOR CONECTADO! ';
    end;
  end;
  Minimizar;
end;

procedure TFServidor.Minimizar;
var
recurso : TRecurso;
begin
  try
    TrayIcon1.Visible := True;
    FServidor.Hide;
    recurso := TRecurso.Create;
    recurso.Desabilitar(FServidor);
    TrayIcon1.BalloonHint := ' SERVIDOR EM OPERA��O! ';
    TrayIcon1.BalloonFlags := bfInfo;
    TrayIcon1.ShowBalloonHint;
  finally
    recurso.Free;
  end;
end;

procedure TFServidor.PararServidor;
begin
  if RESTServicePooler1.Active then
  begin
    RESTServicePooler1.Active := false;
    lSeguro.Caption := ' SERVIDOR PARADO ';
  end;
end;

procedure TFServidor.Sair1Click(Sender: TObject);
begin
  FServidor := nil;
end;

procedure TFServidor.GetParametros;
begin
  edt_PortaDW.Text    := FConfigIni.PortaServ;
  edt_UserDW.Text     := FConfigIni.UsuarioServ;
  edt_PasswordDW.Text := FConfigIni.SenhaServ;

  edt_PortaDB.Text    := IntToStr(FConfigIni.PortBD);
  edt_UsuarioDB.Text  := FConfigIni.UsuarioBD;
  edt_PasswordDB.Text := FConfigIni.PasswordBD;
  edt_Database.Text   := Trim(FConfigIni.CaminhoBD);
  edt_HostDB.Text     := FConfigIni.HostBD;
end;

procedure TFServidor.TrayIcon1DblClick(Sender: TObject);
begin
  TrayIcon1.Visible := false;
  FServidor.Show;
end;

end.
