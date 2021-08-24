unit OutraThreadU;

interface
uses
  {SafeMessageThreadU,}
  System.Classes,
  Winapi.Windows;

type
  TOutraThread = class({TSafeMessage}TThread)
  private
    m_nMainThreadID : Cardinal;
    procedure MessageLoop;
    procedure MessageHandler(MsgRec : TMsg);
  public
    constructor Create(nMainThreadID: Cardinal); overload;
    destructor Destroy; override;
    procedure Execute; override;
  end;

implementation

uses
  ConstantsU,
  Horse,
  MainU,
  System.SysUtils;

constructor TOutraThread.Create(nMainThreadID: Cardinal);
begin
  inherited Create(True{, nil});
  m_nMainThreadID := nMainThreadID;
end;

destructor TOutraThread.Destroy;
begin
  inherited;
end;

procedure TOutraThread.Execute;
begin
  MessageLoop;
end;

procedure TOutraThread.MessageLoop;
var
  MsgRec : TMsg;
begin
  while (not Terminated) and (GetMessage(MsgRec, 0, 0, 0)) do
    begin
      try
        TranslateMessage(MsgRec);
        MessageHandler(MsgRec);
        DispatchMessage(MsgRec);
      except
        on E : Exception do
          raise Exception.Create('TOutraThread.MessageLoop: '+IntToStr(MsgRec.message)+' : '+E.ClassName+' : '+E.Message);
      end;
    end;
end;

//{$DEFINE  OPTION1}
procedure TOutraThread.MessageHandler(MsgRec : TMsg);
var
  Res : THorseResponse;
begin
  try
    if (MsgRec.message = c_nPingMsgID) then
      begin
        {$IFDEF  OPTION1}
        // opcao 1: responder direto aqui
        Res := THorseResponse(MsgRec.lParam);
        Res.Send('pong');
        {$ELSE}
        // opcao 2: enviar para thread principal
        {Safe}PostThreadMessage(m_nMainThreadID, c_nPingMsgID, WParam(MsgRec.lParam), LParam(PChar('pong')))
        {$ENDIF}
      end;
  except
    on E : Exception do
      raise Exception.Create('TOutraThread.MessageHandler: '+IntToStr(MsgRec.message)+' : '+E.ClassName+' : '+E.Message);
  end;
end;

end.
