unit projetoTelaCadastro;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.StdCtrls,
  Vcl.WinXPickers, ZAbstractConnection, ZConnection, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.VCLUI.Wait,
  FireDAC.Phys.MySQLDef, FireDAC.Phys.MySQL, Data.DB, FireDAC.Comp.Client,
  Vcl.Mask, Vcl.DBCtrls, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet, Vcl.Grids, Vcl.DBGrids,System.Types,
  Datasnap.DBClient, Vcl.Buttons;

type
  TfrmPrincipal = class(TForm)
    cadastroEmpregadoDepartamento: TPanel;
    Conexao: TFDConnection;
    FDPhysPgDriverLink1: TFDPhysPgDriverLink;
    dsEmpregados: TDataSource;
    empregados: TFDQuery;
    departamentos: TFDQuery;
    dsDepartamentos: TDataSource;
    empregado_funcao: TFDQuery;
    dsEmpregadoFuncao: TDataSource;
    empregadosid_empregado: TIntegerField;
    empregadoscod_departamento: TIntegerField;
    empregadoscod_emp_funcao: TIntegerField;
    empregadosnm_empregado: TWideStringField;
    empregadosnm_funcao: TWideStringField;
    empregadosdata_admissao: TDateField;
    empregadossalario: TFMTBCDField;
    empregadoscomissao: TFMTBCDField;
    dsEmpregadoPorDepartamento: TDataSource;
    pgcCadastro: TPageControl;
    tsCadastroDepartamento: TTabSheet;
    stNomeCadastroDepartamento: TStaticText;
    stCadastroLocal: TStaticText;
    btnGravarDepartamento: TButton;
    btnCancelarDepartamento: TButton;
    tsCadastroEmpregados: TTabSheet;
    stNomeEmpregado: TStaticText;
    stNomeDepartamento: TStaticText;
    stFuncao: TStaticText;
    stDataAdmissao: TStaticText;
    btnCancelar: TButton;
    btnGravar: TButton;
    stSalario: TStaticText;
    edtNomeEmpregado: TDBEdit;
    edtSalario: TDBEdit;
    edtDataAdmissao: TDBEdit;
    cbDepartamento: TDBLookupComboBox;
    cbFuncao: TDBLookupComboBox;
    tsRelatorio: TTabSheet;
    dbgRelatorio: TDBGrid;
    edtNomeDepartamento: TDBEdit;
    edtNomeLocal: TDBEdit;
    cdsPorDepartamento: TClientDataSet;
    cdsPorDepartamentoid_empregado: TIntegerField;
    cdsPorDepartamentonm_empregado: TStringField;
    cdsPorDepartamentodata_admissao: TDateField;
    cdsPorDepartamentosalario: TFloatField;
    cdsPorDepartamentocomissao: TFloatField;
    cdsPorDepartamentodescricao_funcao: TStringField;
    cdsPorDepartamentonm_departamento: TStringField;
    cdsPorDepartamentolocal: TStringField;
    pnFiltro: TPanel;
    rgFiltro: TRadioGroup;
    edPesquisar: TEdit;
    btnPesquisar: TButton;
    procedure FormCreate(Sender: TObject);
    procedure tsCadastroEmpregadosShow(Sender: TObject);
    procedure tsCadastroDepartamentosShow(Sender: TObject);
    procedure btnGravarClick(Sender: TObject);
    procedure btnCancelarClick(Sender: TObject);
    procedure empregadosdata_admissaoSetText(Sender: TField;
      const Text: string);
    procedure tsRelatorioShow(Sender: TObject);
    procedure btnCancelarDepartamentoClick(Sender: TObject);
    procedure btnGravarDepartamentoClick(Sender: TObject);
    procedure tsCadastroDepartamentoShow(Sender: TObject);
    procedure btnPesquisarClick(Sender: TObject);
  private
    { Private declarations }
    procedure AbrirTabelas;
    procedure ValidarCamposEmpregados;
    procedure ValidarCamposDepartamentos; 
    procedure PreencherEmpregadoPorDepartamento(AberturaInicial: Boolean = True);
    function VerificaConexaoServidor : Boolean;
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.dfm}

procedure TfrmPrincipal.AbrirTabelas;
begin
  departamentos.Close;
  departamentos.SQL.Text := 'select * from departamentos';
  departamentos.Open;

  empregado_funcao.Close;
  empregado_funcao.SQL.Text := 'select * from empregado_funcao';
  empregado_funcao.Open;  

  empregados.Close;
  empregados.SQL.Text := 'select * from empregados';
  empregados.Open;

  PreencherEmpregadoPorDepartamento;
end;

procedure TfrmPrincipal.btnCancelarClick(Sender: TObject);
begin
  empregados.Cancel;
  empregados.Insert;
end;

procedure TfrmPrincipal.btnCancelarDepartamentoClick(Sender: TObject);
begin
  departamentos.Cancel;
  departamentos.Insert;
end;

procedure TfrmPrincipal.btnGravarClick(Sender: TObject);
begin
  ValidarCamposEmpregados;
  
  empregados.Post;  
  empregados.insert;
end;

procedure TfrmPrincipal.btnGravarDepartamentoClick(Sender: TObject);
begin
  ValidarCamposDepartamentos;
  
  departamentos.Post;  
  departamentos.insert;
end;

procedure TfrmPrincipal.btnPesquisarClick(Sender: TObject);
begin
  PreencherEmpregadoPorDepartamento(False);
end;

procedure TfrmPrincipal.empregadosdata_admissaoSetText(Sender: TField;
  const Text: string);
begin
  try
    sender.Value := StrToDate(edtDataAdmissao.Text);
  except
    ShowMessage('Data Inv�lida');
    Exit;
  end;  
end;

procedure TfrmPrincipal.tsCadastroEmpregadosShow(Sender: TObject);
begin
  AbrirTabelas;  
  empregados.Insert;
end;

procedure TfrmPrincipal.tsCadastroDepartamentoShow(Sender: TObject);
begin
  AbrirTabelas;
  departamentos.Insert;
end;

procedure TfrmPrincipal.tsCadastroDepartamentosShow(Sender: TObject);
begin
  AbrirTabelas;
  departamentos.Insert;
end;

procedure TfrmPrincipal.tsRelatorioShow(Sender: TObject);
begin
  AbrirTabelas;
end;

procedure TfrmPrincipal.ValidarCamposEmpregados;
begin
  if edtNomeEmpregado.Text = ''  then
  begin
    ShowMessage('Preencher o campo Nome Empregado.');
    abort;
  end;

  if cbDepartamento.Text = ''  then
  begin
    ShowMessage('Preencher o campo Departamento.');
    abort;
  end;

  if cbFuncao.Text = ''  then
  begin
    ShowMessage('Preencher o campo Fun��o.');
    abort;
  end;
  
  if edtSalario.Text = ''  then
  begin
    ShowMessage('Preencher o campo Sal�rio.');
    abort;
  end;

  if edtDataAdmissao.Text = '  /  /    '  then
  begin
    ShowMessage('Preencher o campo Data Admiss�o.');
    abort;
  end;
end;

procedure TfrmPrincipal.ValidarCamposDepartamentos;
begin
  if edtNomeDepartamento.Text = ''  then
  begin
    ShowMessage('Preencha o nome do departamento.');
    abort;
  end;
  if  edtNomeLocal.Text = ' ' then
  begin
    ShowMessage('Preencha o nome do local.');
    abort;                                                                
  end;
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  if not VerificaConexaoServidor then
  begin
    Application.Terminate;
  end;
  
  pgcCadastro.ActivePage := tsCadastroDepartamento;
end;

procedure TfrmPrincipal. PreencherEmpregadoPorDepartamento(AberturaInicial: Boolean = True);
var
  lQuery: TFDQuery;  
  strSQL: string;
begin
  if not cdsPorDepartamento.Active then
  begin
    cdsPorDepartamento.CreateDataSet;
  end else
  begin
    cdsPorDepartamento.EmptyDataSet;
  end;
  
  strSQL := 'select e.id_empregado, ' +
            'upper(e.nm_empregado) as nm_empregado, ' +
            'e.data_admissao, ' +
            'e.salario, ' +
            'e.comissao, ' +
            'upper(ef.descricao_funcao) as descricao_funcao, ' +
            'upper(d.nm_departamento) as nm_departamento, ' +
            'upper(d.local) as local ' +
            'from empregados e ' + 
            'INNER JOIN empregado_funcao as ef on (e.cod_emp_funcao) = (ef.id_funcao) ' +       
            'INNER JOIN departamentos as d on (e.cod_departamento) = (d.id_departamento) ' + 
            'Where e.nm_empregado ilike :empregado ' +
            'and  ef.descricao_funcao ilike :funcao ' +
            'and d.nm_departamento ilike :departamento';

  lQuery := TFDQuery.Create(nil);
  try
    lQuery.Connection := Conexao;
    lQuery.SQL.Text := strSQL;

    if AberturaInicial then
    begin
      lQuery.ParamByName('empregado').AsString := '%%';
      lQuery.ParamByName('funcao').AsString := '%%';
      lQuery.ParamByName('departamento').AsString := '%%';    
    end else
    begin
      case rgFiltro.ItemIndex of
        0:
          begin      
            lQuery.ParamByName('empregado').AsString := '%' + edPesquisar.Text + '%';    
            lQuery.ParamByName('funcao').AsString := '%%';
            lQuery.ParamByName('departamento').AsString := '%%';
          end;

        1:
          begin
            lQuery.ParamByName('empregado').AsString := '%%';
            lQuery.ParamByName('funcao').AsString := '%' + edPesquisar.Text + '%';
            lQuery.ParamByName('departamento').AsString := '%%';        
          end;

        2:
          begin
            lQuery.ParamByName('empregado').AsString := '%%';
            lQuery.ParamByName('funcao').AsString := '%%';
            lQuery.ParamByName('departamento').AsString := '%' + edPesquisar.Text + '%';
          end;
      end;                                      
    end;
    
    lQuery.Open;
    if not lQuery.IsEmpty then
    begin
      lQuery.First;

      while not lQuery.Eof do
      begin
        cdsPorDepartamento.Append;
        cdsPorDepartamento.FieldByName('id_empregado').AsInteger := lQuery.FieldByName('id_Empregado').AsInteger;
        cdsPorDepartamento.FieldByName('nm_empregado').AsString := lQuery.FieldByName('nm_empregado').AsString;
        cdsPorDepartamento.FieldByName('data_admissao').AsDateTime := lQuery.FieldByName('data_admissao').AsDateTime;
        cdsPorDepartamento.FieldByName('salario').AsFloat := lQuery.FieldByName('salario').AsFloat;
        cdsPorDepartamento.FieldByName('comissao').AsFloat := lQuery.FieldByName('comissao').AsFloat;
        cdsPorDepartamento.FieldByName('descricao_funcao').AsString := lQuery.FieldByName('descricao_funcao').AsString;
        cdsPorDepartamento.FieldByName('nm_departamento').AsString := lQuery.FieldByName('nm_departamento').AsString;
        cdsPorDepartamento.FieldByName('local').AsString := lQuery.FieldByName('local').AsString;
        cdsPorDepartamento.Post;
        lQuery.Next;
      end;
    end; 
  finally
    lQuery.Free;
  end;
end;


function TfrmPrincipal.VerificaConexaoServidor : Boolean;
begin
  Result := True;

  with Conexao do
  begin    
    Params.Values['Server'] := 'localhost';
    Params.Values['Database'] := 'bancoProva';
    Params.Values['User_Name'] := 'postgres';
    Params.Values['Password'] := 'postgres';
    Params.Values['Port'] := '5432';

    Try
      Connected := True;
    Except on E:Exception do
      begin
        ShowMessage('Erro na comunica��o com o banco. Verifique os par�metros de conex�o e tente novamente.');
        Result := False;
      end;
    end;
  end;
end;

end.
