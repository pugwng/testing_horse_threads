program App;

uses
  Vcl.Forms,
  AppForm in 'AppForm.pas' {Form1},
  MainU in 'MainU.pas',
  OutraThreadU in 'OutraThreadU.pas',
  ConstantsU in 'ConstantsU.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
