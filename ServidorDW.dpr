program ServidorDW;

uses
  Vcl.Forms,
  UServidorRest in 'UServidorRest.pas' {FServidor},
  UDataModuloServidorRest in 'UDataModuloServidorRest.pas' {DataModuleServidorRestFull: TDataModule},
  URecurso in 'URecurso.pas',
  URESTDWDataBase1ConexaoArquivo in 'URESTDWDataBase1ConexaoArquivo.pas',
  UCliente in 'D:\MaxSystem Test\MaxSystemERP\maxsystem\Control\UCliente.pas',
  UCCategoria in 'D:\MaxSystem Test\MaxSystemERP\maxsystem\Control\UCCategoria.pas',
  UConfig in 'D:\MaxSystem Test\MaxSystemERP\maxsystem\Control\UConfig.pas',
  UPedidos in 'UPedidos.pas',
  UConfigIni in 'UConfigIni.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFServidor, FServidor);
  Application.Run;
end.
