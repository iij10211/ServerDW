unit UServidorRest;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, uDWAbout, uRESTDWBase,
  Vcl.ExtCtrls, Vcl.Buttons, Vcl.Menus, System.ImageList, Vcl.ImgList,
  Vcl.Imaging.GIFImg,Configuracoes;

type
  TFServidor = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Button2: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    labConexao: TLabel;
    labDBConfig: TLabel;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Edit7: TEdit;
    Label7: TLabel;
    lSeguro: TLabel;
    OpenDialog1: TOpenDialog;
    Edit8: TEdit;
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
    Edit7.Text := Trim(bdcaminho);
  end;
end;

procedure TFServidor.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Minimizar;
end;

procedure TFServidor.FormCreate(Sender: TObject);
var
  servidor: TDataModuleServidorRestFull;
begin
  servidor := TDataModuleServidorRestFull.Create(nil);
  try
    servidor.LerArquivo;
    Edit1.Text := servidor.FPortaServ;
    Edit2.Text := servidor.FUsuarioServ;
    Edit3.Text := servidor.FSenhaServ;

    Edit4.Text := IntToStr(servidor.FPortBD);
    Edit5.Text := servidor.FUsuarioBD;
    Edit6.Text := servidor.FPasswordBD;
    Edit7.Text := Trim(servidor.FCaminhoBD);
    Edit8.Text := servidor.FHostBD;
  finally
    servidor.Free;
  end;
end;

procedure TFServidor.IniciarServidor;
var
  servidor: TDataModuleServidorRestFull;
begin
  servidor := TDataModuleServidorRestFull.Create(nil);
  try
    servidor.FPortaServ := Trim(Edit1.Text);
    servidor.FUsuarioServ := Trim(Edit2.Text);
    servidor.FSenhaServ := Trim(Edit3.Text);
    servidor.FPortBD := StrToInt(Edit4.Text);
    servidor.FUsuarioBD := Trim(Edit5.Text);
    servidor.FPasswordBD := Trim(Edit6.Text);
    servidor.FCaminhoBD := Trim(Edit7.Text);
    servidor.FHostBD := Trim(Edit8.Text);
    servidor.ArquivoConfiguracao;
    servidor.ServerMethodDataModuleCreate(Self);
  finally
    servidor.Free;
  end;

  RESTServicePooler1.ServerMethodClass := TDataModuleServidorRestFull;

  if Not RESTServicePooler1.Active then
  begin
    RESTServicePooler1.ServerParams.UserName := Trim(Edit2.Text);
    RESTServicePooler1.ServerParams.Password := Trim(Edit3.Text);
    RESTServicePooler1.ServicePort := StrToInt(Edit1.Text);
    RESTServicePooler1.Active := True;
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

procedure TFServidor.TrayIcon1DblClick(Sender: TObject);
begin
  TrayIcon1.Visible := false;
  FServidor.Show;
end;

end.