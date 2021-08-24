unit MainU;

interface

uses
  {SafeMessageThreadU,}
  System.Classes,
  Winapi.Windows,
  OutraThreadU;

type

  TMain = class({TSafeMessage}TThread)
  private
    m_OutraThread : TOutraThread;
    procedure MessageLoop;
    procedure MessageHandler(MsgRec : TMsg);
  public
    constructor Create;
    destructor Destroy; override;
    procedure Execute; override;
    procedure Stop;
  end;

implementation

uses
  ConstantsU,
  Horse,
  System.SysUtils;

var
  API : THorse;

constructor TMain.Create;
begin
  inherited Create(True{, nil});
end;

destructor TMain.Destroy;
begin
  inherited;
end;

procedure TMain.Execute;
begin
  API := THorse.Create;
  m_OutraThread := TOutraThread.Create(ThreadID);
  API.Get('/ping',
      procedure(Req: THorseRequest; Res: THorseResponse; Next: TProc)
      begin
        {Safe}PostThreadMessage(m_OutraThread.ThreadID, c_nPingMsgID, WParam(Req), LParam(Res));
        //Res.Send('pong');
      end)
    ;
  API.Listen(9000);
  m_OutraThread.Start;
  MessageLoop;
end;

procedure TMain.Stop;
begin
  API.StopListen;
end;

procedure TMain.MessageLoop;
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
          raise Exception.Create('TMain.MessageLoop: '+IntToStr(MsgRec.message)+' : '+E.ClassName+' : '+E.Message);
      end;
    end;
end;

procedure TMain.MessageHandler(MsgRec : TMsg);
var
  Res : THorseResponse;
begin
  try
    if (MsgRec.message = c_nPingMsgID) then
      begin
        Res := THorseResponse(MsgRec.wParam);
        Res.Send(string(PChar(MsgRec.lParam)));
      end;
  except
    on E : Exception do
      raise Exception.Create('TMain.MessageHandler: '+IntToStr(MsgRec.message)+' : '+E.ClassName+' : '+E.Message);
  end;
end;

end.
