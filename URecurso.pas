unit URecurso;

interface
uses Vcl.Forms,Vcl.StdCtrls,Vcl.Mask,System.SysUtils,Vcl.Graphics,Vcl.ComCtrls;
type
  TRecurso = class

    public

      constructor Create;
      destructor Destroy; override;

      function LimparEdit(Form: TForm)  : TForm;
      function LimparEditAdv(Form :TForm) : TForm;
      function DesbabilitarAdvEdit(Form: TForm) : TForm;
      function Habilitar(Form: TForm)   : TForm;
      function Desabilitar(Form: TForm) : TForm;
      function MensagemNovo(letra : TLabel) : TLabel;
      function MensagemEditar(letra : TLabel)   : TLabel;
      function MensagemExcluir(letra : TLabel)  : TLabel;
      function MensagemBranco(letra : TLabel)   : TLabel;
      function LetraMaiscula(Form : TForm) : TForm;
      function RemoveAcento(aText : string) : string;
      function DesabilitarScroolBox(Form : TForm) : TForm;
//      function DesabilitarTab(Tab : TAdvTabSheet) : TAdvTabSheet;
      function Modo(Letra : TLabel) : TLabel;
      function SetValorZero(form:TForm) : TForm;
      function DesabilitarBox(Form : TForm) : TForm;

  end;

implementation

{ TRecurso }

constructor TRecurso.Create;
begin

end;

function TRecurso.Desabilitar(Form: TForm): TForm;
var
i : integer;
begin
  for i := 0 to Form.ComponentCount -1 do
  begin

    if Form.Components[i] is TEdit then
    begin
      TEdit(Form.Components[i]).Enabled := false;
    end;

    if Form.Components[i] is TDateTimePicker then
    begin
      TDateTimePicker(Form.Components[i]).Enabled := false;
    end;

    if Form.Components[i] is TMaskEdit then
    begin
      TMaskEdit(Form.Components[i]).Enabled := false;
    end;

    if Form.Components[i] is TMemo then
    begin
      TMemo(Form.Components[i]).Enabled := false;
    end;

    if Form.Components[i] is TComboBox then
    begin
      TComboBox(Form.Components[i]).Enabled := false;
    end;

  end;
  Result := Form;
end;

function TRecurso.DesabilitarBox(Form: TForm): TForm;
var
i : integer;
begin
  for i := 0 to Form.ComponentCount -1 do
  begin

    if Form.Components[i] is TScrollBox then
    begin
      TScrollBox(Form.Components[i]).Visible := False;
    end;
  end;
  Result := Form;
end;

function TRecurso.DesabilitarScroolBox(Form: TForm): TForm;
var
i : integer;
begin
  for i := 0 to Form.ComponentCount -1 do
  begin

//    if Form.Components[i] is TAdvScrollBox then
//    begin
//      TAdvScrollBox(Form.Components[i]).Visible := False;
//    end;
  end;
  Result := Form;
end;

//function TRecurso.DesabilitarTab(Tab: TAdvTabSheet): TAdvTabSheet;
//var
//i : Integer;
//begin
//  for i := 0 to Tab.ComponentCount -1 do
//  begin
//    if Tab.Components[i] is TAdvTabSheet then
//    begin
//      TAdvTabSheet(Tab.Components[i]).Enabled := False;
//    end;
//  end;
//end;

function TRecurso.DesbabilitarAdvEdit(Form: TForm): TForm;
var
i : integer;
begin

  for i := 0 to Form.ComponentCount -1 do
  begin

//    if Form.Components[i] is TAdvEdit then
//    begin
//      TAdvEdit(Form.Components[i]).Enabled := false;
//    end;

    if Form.Components[i] is TDateTimePicker then
    begin
      TDateTimePicker(Form.Components[i]).Enabled := false;
    end;

    if Form.Components[i] is TMaskEdit then
    begin
      TMaskEdit(Form.Components[i]).Enabled := false;
    end;

    if Form.Components[i] is TMemo then
    begin
      TMemo(Form.Components[i]).Enabled := false;
    end;

    if Form.Components[i] is TComboBox then
    begin
      TComboBox(Form.Components[i]).Enabled := false;
    end;

  end;
  Result := Form;

end;

destructor TRecurso.Destroy;
begin
  inherited;
end;

function TRecurso.Habilitar(Form: TForm): TForm;
var
i : integer;
begin
  for i := 0 to Form.ComponentCount -1 do
  begin

    if Form.Components[i] is TEdit then
    begin
      TEdit(Form.Components[i]).Enabled := true;
    end;

    if Form.Components[i] is TDateTimePicker then
    begin
      TDateTimePicker(Form.Components[i]).Enabled := true;
    end;

    if Form.Components[i] is TMaskEdit then
    begin
      TMaskEdit(Form.Components[i]).Enabled := true;
    end;

    if Form.Components[i] is TMemo then
    begin
      TMemo(Form.Components[i]).Enabled := true;
    end;

    if Form.Components[i] is TComboBox then
    begin
      TComboBox(Form.Components[i]).Enabled := true;
    end;

  end;
  Result := Form;
end;

function TRecurso.LetraMaiscula(Form: TForm): TForm;
var
i : integer;
begin
  for i := 0 to Form.ComponentCount -1 do
  begin

    if Form.Components[i] is TEdit then
    begin
      TEdit(Form.Components[i]).CharCase := ecUpperCase;
    end;

    if Form.Components[i] is TMaskEdit then
    begin
      TMaskEdit(Form.Components[i]).CharCase := ecUpperCase;
    end;

    if Form.Components[i] is TMemo then
    begin
      TMemo(Form.Components[i]).CharCase := ecUpperCase;
    end;

  end;
  Result := Form;
end;

function TRecurso.LimparEdit(Form: TForm) : TForm;
var
i : integer;
begin
  for i := 0 to Form.ComponentCount -1 do
  begin

    if Form.Components[i] is TEdit then
    begin
      TEdit(Form.Components[i]).Text := '';
    end;

    if Form.Components[i] is TMaskEdit then
    begin
      TMaskEdit(Form.Components[i]).Text := '';
    end;

    if Form.Components[i] is TMemo then
    begin
      TMemo(Form.Components[i]).Lines.Text := '';
    end;
//
//    if Form.Components[i] is TAdvEdit then
//    begin
//      TAdvEdit(Form.Components[i]).Text := '';
//    end;

  end;
  Result := Form;
end;

function TRecurso.LimparEditAdv(Form: TForm): TForm;
var
i : integer;
begin
  for i := 0 to Form.ComponentCount -1 do
  begin
//   if Form.Components[i] is TAdvEdit then
//    begin
//      TAdvEdit(Form.Components[i]).Text := '';
//    end;
  end;
  Result := Form;
end;

function TRecurso.MensagemBranco(letra: TLabel): TLabel;
begin
  letra.Caption := '';
  Result := letra;
end;

function TRecurso.MensagemEditar(letra: TLabel): TLabel;
begin
  letra.Caption := 'EDITAR';
  Result := letra;
end;

function TRecurso.MensagemExcluir(letra: TLabel): TLabel;
begin
  letra.Caption := 'DELETAR';
  Result := letra;
end;

function TRecurso.MensagemNovo(letra: TLabel): TLabel;
begin
  letra.Caption := 'NOVO';
  Result := letra;
end;

function TRecurso.Modo(Letra: TLabel): TLabel;
begin
  if (Letra.Caption = 'NOVO') OR (Letra.Caption = 'EDITAR') OR (Letra.Caption = 'DELETAR') then
  begin
    raise Exception.Create(' Programa est· no Modo ' + Letra.Caption + '!' + ' Click Cancelar para Fechar! ');
  end
  else
    Exit;
end;

function TRecurso.RemoveAcento(aText: string): string;
const
  ComAcento = '‡‚ÍÙ˚„ı·ÈÌÛ˙Á¸Ò˝¿¬ ‘€√’¡…Õ”⁄«‹—›';
  SemAcento = 'aaeouaoaeioucunyAAEOUAOAEIOUCUNY';
var
  x: Cardinal;
begin;
  for x := 1 to Length(aText) do
  try
    if (Pos(aText[x], ComAcento) <> 0) then
      aText[x] := SemAcento[ Pos(aText[x], ComAcento) ];
  except on E: Exception do
    raise Exception.Create('Erro a Remover Acento!');
  end;
  Result := UpperCase(aText);
end;

function TRecurso.SetValorZero(form: TForm): TForm;
var
i : Integer;
begin

  for i := 0 to Form.ComponentCount -1 do
  begin
    if Form.Components[i] is TEdit then
    begin
      TEdit(Form.Components[i]).Text := '0,00';
    end;
  end;
end;



end.
