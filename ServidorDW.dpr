program ServidorDW;

uses
  Vcl.Forms,
  UServidorRest in 'UServidorRest.pas' {FServidor},
  UDataModuloServidorRest in 'UDataModuloServidorRest.pas' {DataModuleServidorRestFull: TDataModule},
  URecurso in 'URecurso.pas',
  URESTDWDataBase1ConexaoArquivo in 'URESTDWDataBase1ConexaoArquivo.pas',
  Configuracoes in 'Configuracoes.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFServidor, FServidor);
  Application.Run;
end.
