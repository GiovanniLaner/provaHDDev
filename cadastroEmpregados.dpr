program cadastroEmpregados;

uses
  Vcl.Forms,
  projetoTelaCadastro in 'projetoTelaCadastro.pas' {frmPrincipal};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.
