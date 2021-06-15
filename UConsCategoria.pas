unit UConsCategoria;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Grids, Vcl.DBGrids,Vcl.Mask,
  Vcl.Buttons, PngSpeedButton, AdvObj, BaseGrid, AdvGrid, DBAdvGrid,
  AdvUtil, uDWConstsData, uRESTDWPoolerDB,
  AdvPageControl, Vcl.ComCtrls, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Comp.DataSet, FireDAC.Comp.Client, uDWAbout;

type
  TFConsCategoria = class(TForm)
    DataSource1: TDataSource;
    Panel1: TPanel;
    Label3: TLabel;
    PngSpeedButton2: TPngSpeedButton;
    ComboBox1: TComboBox;
    Panel5: TPanel;
    Panel6: TPanel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    PngSpeedButton6: TPngSpeedButton;
    MaskEdit2: TMaskEdit;
    MaskEdit3: TMaskEdit;
    DBGrid1: TDBGrid;
    RESTDWClientSQL1: TRESTDWClientSQL;
    edtBusca: TEdit;
    cbb2: TComboBox;
    lbl2: TLabel;
    btnFechar2: TPngSpeedButton;
    Panel2: TPanel;
    Label2: TLabel;
    btnEditar: TPngSpeedButton;
    btnExcluir: TPngSpeedButton;
    PngSpeedButton5: TPngSpeedButton;
    PngSpeedButton11: TPngSpeedButton;
    btnCancelar: TPngSpeedButton;
    btnCadastrar: TPngSpeedButton;
    PngSpeedButton1: TPngSpeedButton;
    AdvPageControl1: TAdvPageControl;
    AdvTabSheet1: TAdvTabSheet;
    AdvTabSheet2: TAdvTabSheet;
    Label1: TLabel;
    Label4: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit15: TEdit;
    Label18: TLabel;
    Memo1: TMemo;
    Label8: TLabel;
    RESTDWDataBase1: TRESTDWDataBase;

    procedure Busca;
    procedure MaskEdit1KeyPress(Sender: TObject; var Key: Char);
    procedure DBAdvGrid1DblClick(Sender: TObject);
    procedure PngSpeedButton2Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PngSpeedButton1Click(Sender: TObject);
    procedure Dados;
    procedure PngSpeedButton3Click(Sender: TObject);
    procedure PngSpeedButton4Click(Sender: TObject);
    procedure ComboBox1Change(Sender: TObject);
    procedure DBGrid1DblClick(Sender: TObject);
    procedure btnFechar2Click(Sender: TObject);
    procedure AdvPageControl1Change(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure btnCadastrarClick(Sender: TObject);
    procedure edtBuscaKeyPress(Sender: TObject; var Key: Char);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FConsCategoria: TFConsCategoria;

implementation

{$R *.dfm}

uses URESTDWDataBase1ConexaoArquivo,URecurso,UCCategoria;

procedure TFConsCategoria.AdvPageControl1Change(Sender: TObject);
var
recurso : TRecurso;
begin
  recurso := TRecurso.Create;
  try
    if AdvPageControl1.ActivePage = AdvTabSheet2 then
    begin
      recurso.Desabilitar(FConsCategoria);
    end
    else
      recurso.Habilitar(FConsCategoria);
  finally
    recurso.Free;
    Busca;
  end;
end;

procedure TFConsCategoria.btnCadastrarClick(Sender: TObject);
var
categoria : TCategoria;
recurso   : TRecurso;
begin
  try
    categoria := TCategoria.Create;
    recurso   := TRecurso.Create;
    try

      if Label2.Caption = 'NOVO' then
      begin
        categoria.NomeCategoria := Edit1.Text;
        categoria.Descricao := Edit2.Text;
        categoria.Novo;
        recurso.MensagemBranco(Label2);
        recurso.Desabilitar(FConsCategoria);
      end;

      if Label2.Caption = 'EDITAR' then
      begin
        categoria.Id := Edit15.Text;
        categoria.NomeCategoria := Edit1.Text;
        categoria.Descricao := Edit2.Text;
        categoria.Editar;
        recurso.MensagemBranco(Label2);
        recurso.Desabilitar(FConsCategoria);
      end;

      if Label2.Caption = 'DELETAR' then
      begin
        categoria.Id := Edit15.Text;
        categoria.Deletar;
        recurso.Desabilitar(FConsCategoria);
      end;

    finally
      categoria.Free;
      recurso.Free;
    end;
  except on E: Exception do
    raise Exception.Create(' Erro ao inserir ' + E.Message);
  end;

end;

procedure TFConsCategoria.btnEditarClick(Sender: TObject);
var
recurso : TRecurso;
begin
  recurso := TRecurso.Create;
  try
    recurso.MensagemEditar(Label2);
    AdvPageControl1.ActivePage := AdvTabSheet2;
    recurso.Habilitar(FConsCategoria);
    Edit2.SetFocus;
  finally
    recurso.Free;
  end;
end;

procedure TFConsCategoria.btnExcluirClick(Sender: TObject);
var
recurso : TRecurso;
begin
  recurso := TRecurso.Create;
  try
    recurso.MensagemExcluir(Label2);
    AdvPageControl1.ActivePage := AdvTabSheet2;
    recurso.Habilitar(FConsCategoria);
    Edit2.SetFocus;
  finally
    recurso.Free;
  end;
end;
procedure TFConsCategoria.btnFechar2Click(Sender: TObject);
begin
  FConsCategoria.Close;
end;

procedure TFConsCategoria.Busca;
begin

    FConsCategoria.RESTDWClientSQL1.DataBase := FConsCategoria.RESTDWDataBase1;
    FConsCategoria.RESTDWDataBase1.Active    := True;

    try

      FConsCategoria.RESTDWClientSQL1.Close;
      FConsCategoria.RESTDWClientSQL1.SQL.Clear;
      FConsCategoria.RESTDWClientSQL1.SQL.Add('SELECT * FROM CATEGORIA');
      FConsCategoria.RESTDWClientSQL1.SQL.Add('WHERE IDCATEGORIA IS NOT NULL');

      case ComboBox1.ItemIndex of
        0:
        begin
          if edtBusca.Text <> '' then
          begin
            FConsCategoria.RESTDWClientSQL1.SQL.Add('AND IDCATEGORIA =:IDCATEGORIA');
            FConsCategoria.RESTDWClientSQL1.ParamByName('IDCATEGORIA').AsString := edtBusca.Text;
          end;
        end;

        1:
        begin
          if edtBusca.Text <> '' then
          begin
            FConsCategoria.RESTDWClientSQL1.SQL.Add('AND NOMECATEGORIA Like :NOMECATEGORIA');
            FConsCategoria.RESTDWClientSQL1.ParamByName('NOMECATEGORIA').AsString :=  '%'+edtBusca.Text+'%';
          end;
        end;
  //
        2:
         begin
          if (MaskEdit2.Text <> '') AND (MaskEdit3.Text <> '') then
          begin
            FConsCategoria.RESTDWClientSQL1.SQL.Add('AND DTCADASTROCATEGORIA BETWEEN :dtinicial AND :dtfinal');
            FConsCategoria.RESTDWClientSQL1.ParamByName('dtinicial').AsDate := StrToDate(MaskEdit2.Text);
            FConsCategoria.RESTDWClientSQL1.ParamByName('dtfinal').AsDate := StrToDate(MaskEdit3.Text);
          end;
         end;

      end;
      FConsCategoria.RESTDWClientSQL1.SQL.Add('ORDER BY IDCATEGORIA');
      FConsCategoria.RESTDWClientSQL1.Active := True;
      if FConsCategoria.RESTDWClientSQL1.RecordCount <= 0 then
      begin
        ShowMessage(' Categoria não Encontrada! ');
      end;
    except on E: Exception do
      raise Exception.Create(' Erro ao Fazer a Consulta! ' +E.Message);
    end;
end;

procedure TFConsCategoria.ComboBox1Change(Sender: TObject);
begin
//  if ComboBox1.ItemIndex = 2 then
//  begin
//    Panel6.Visible := True;
//    MaskEdit2.SetFocus;
//  end
//  else
//    Panel6.Visible := False;
end;

procedure TFConsCategoria.Dados;
var
recurso : TRecurso;
begin
  recurso := TRecurso.Create;
  try
    recurso.Desabilitar(FConsCategoria);
    AdvPageControl1.ActivePage := AdvTabSheet2;
    FConsCategoria.Edit15.Text:= FConsCategoria.RESTDWClientSQL1.FieldByName('IDCATEGORIA').AsString;
    FConsCategoria.Edit1.Text := FConsCategoria.RESTDWClientSQL1.FieldByName('NOMECATEGORIA').AsString;
    FConsCategoria.Edit2.Text := FConsCategoria.RESTDWClientSQL1.FieldByName('DESCRICAOCATEGORIA').AsString;
  finally
    recurso.Free;
  end;
end;

procedure TFConsCategoria.DBAdvGrid1DblClick(Sender: TObject);
begin
//  if Assigned(FConsultaProduto) then
//  begin
//    FConsultaProduto.Edit3.Text  := RESTDWClientSQL1.FieldByName('IDCATEGORIA').AsString;
//    FConsultaProduto.Edit10.Text := RESTDWClientSQL1.FieldByName('NOMECATEGORIA').AsString;
//    RESTDWClientSQL1.Close;
//    FConsCategoria.Close;
//  end;
//  if Assigned(FCadastroPlanoContas) then
//  begin
//    FCadastroPlanoContas.Edit3.Text := RESTDWClientSQL1.FieldByName('IDCATEGORIA').AsString;
//    RESTDWClientSQL1.Close;
//    FConsCategoria.Close;
//  end
//  else
//  begin
//    if not Assigned(FConsultaProduto) then
//    begin
//      Dados;
//    end;
//  end;
end;

procedure TFConsCategoria.DBGrid1DblClick(Sender: TObject);
begin
  Dados;
end;

procedure TFConsCategoria.edtBuscaKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Busca;
  end;
end;

procedure TFConsCategoria.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  FConsCategoria := nil;
end;

procedure TFConsCategoria.FormResize(Sender: TObject);
begin
  AdvPageControl1.ActivePage := AdvTabSheet1
end;

procedure TFConsCategoria.MaskEdit1KeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Busca;
  end;
end;
Procedure TFConsCategoria.PngSpeedButton1Click(Sender: TObject);
var
recurso : TRecurso;
begin

  recurso := TRecurso.Create;
  try
    recurso.MensagemNovo(Label2);
    AdvPageControl1.ActivePage := AdvTabSheet2;
    recurso.Habilitar(FConsCategoria);
    recurso.LimparEdit(FConsCategoria);
    Edit1.SetFocus;
  finally
    recurso.Free;
  end;
end;

procedure TFConsCategoria.PngSpeedButton2Click(Sender: TObject);
begin
  Busca;
end;

procedure TFConsCategoria.PngSpeedButton3Click(Sender: TObject);
begin
  Dados;
end;

procedure TFConsCategoria.PngSpeedButton4Click(Sender: TObject);
begin
  Dados;
end;

End.
