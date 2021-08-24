unit AppForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, MainU, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    btnStart: TButton;
    btnStop: TButton;
    lblPort: TLabel;

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
  private
    m_Server : TMain;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  m_Server := TMain.Create;
  btnStop.Enabled := False;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  m_Server.Free;
end;

procedure TForm1.btnStartClick(Sender: TObject);
begin
  m_Server.Start;
  btnStart.Enabled := False;
  btnStop.Enabled := True;
  lblPort.Caption := 'Port:9000';
end;

procedure TForm1.btnStopClick(Sender: TObject);
begin
  m_Server.Stop;
  btnStart.Enabled := True;
  btnStop.Enabled := False;
end;

end.
