unit LinuxStackTrace;

interface

uses
 System.SysUtils,
 System.IOUtils,
 System.StrUtils,
 System.SyncObjs,
 System.Classes,
 Posix.Base,
 lnfodwrf;

procedure StackTraceEnable;
procedure StackTraceDisable;

implementation

function backtrace(buffer: PPointer; size: integer): integer; cdecl; external libc;

type
 TCallStack = record
  Count: integer;
  Stack: array [0..15] of Pointer;
 end;
 PCallStack = ^TCallStack;

function HookedGetExceptionStackInfo(P: PExceptionRecord): Pointer;
var
 CallStack: PCallStack;
 i: integer;
 StackTraceText : string;
begin
 { Return call stack }
 Result := nil;
 if MatchStr(Exception(P.ExceptObject).ClassName, ['EUniSessionException', 'EIdSocketError',
  'EIdConnClosedGracefully', 'EIdOSSLAcceptError', 'EResetByPeer', 'EIdHTTPErrorParsingCommand',
  'EIdOSSLUnderlyingCryptoError', 'EDULPeerRequestedRelease', 'ESocketMinus2', 'EDULException',
  'EAbort', 'ESynapseError', 'EFOpenError', 'EDICOMParseError', 'EDIMSEException', 'EDULOther',
  'EDULPDUExamineError', 'EDULPresentationContextRejected', 'EDULAssociastionReject',
  'EDIMSEProtocolFSMViolation', 'ESendTimeout', 'ESocketBindError', 'EFlushBufferError',
  'EDULPeerAbortedAssociation', 'ECouldNotBindSocket', 'EErrorParsing', 'EDULSocketError',
  'EDICOMCondError', 'EIdReadTimeout']) then
  Exit;

 { Allocate a PCallStack record large enough to hold entries }
 GetMem(CallStack, SizeOf(TCallStack));

 { Use backtrace API to retrieve call stack }
 CallStack.Count := backtrace(@CallStack.Stack, Length(CallStack.Stack));

// with Exception(P.ExceptObject) do
  StackTraceText := DateTimeToStr(Now) + sLineBreak +
                    Exception(P.ExceptObject).ClassName + ' ' +
                    Exception(P.ExceptObject).Message + sLineBreak;

  for i := 0 to CallStack.Count - 1 do
    StackTraceText := StackTraceText + string(DwarfBackTraceStr(CallStack.Stack[i])) + sLineBreak;

 FreeMem(CallStack);
end;

function GetExceptionStackInfo(P: PExceptionRecord): Pointer;
var
  CallStack : PCallStack;
  Trace     : String;
  i,Sz      : Integer;
begin
  Result := nil;
  if MatchStr(Exception(P.ExceptObject).ClassName, ['EUniSessionException', 'EIdSocketError',
    'EIdConnClosedGracefully', 'EIdOSSLAcceptError', 'EResetByPeer', 'EIdHTTPErrorParsingCommand',
    'EIdOSSLUnderlyingCryptoError', 'EDULPeerRequestedRelease', 'ESocketMinus2', 'EDULException',
    'EAbort', 'ESynapseError', 'EFOpenError', 'EDICOMParseError', 'EDIMSEException', 'EDULOther',
    'EDULPDUExamineError', 'EDULPresentationContextRejected', 'EDULAssociastionReject',
    'EDIMSEProtocolFSMViolation', 'ESendTimeout', 'ESocketBindError', 'EFlushBufferError',
    'EDULPeerAbortedAssociation', 'ECouldNotBindSocket', 'EErrorParsing', 'EDULSocketError',
    'EDICOMCondError', 'EIdReadTimeout']) then
    Exit;

 { Allocate a PCallStack record large enough to hold entries }
  GetMem(CallStack, SizeOf(TCallStack));
  try
    { Use backtrace API to retrieve call stack }
    CallStack.Count := backtrace(@CallStack.Stack, Length(CallStack.Stack));

    Trace := '';
    for i := 5 to CallStack.Count - 1 do
      Trace := Trace + string(DwarfBackTraceStr(CallStack.Stack[i])) + sLineBreak;

  finally
    FreeMem(CallStack);
  end;

  if Trace<>'' then begin
    Sz:=(Length(Trace)+1)*SizeOf(Char);
    GetMem(Result, Sz);
    Move(Pointer(Trace)^,Result^,Sz);
  end else begin
    Result:=nil;
  end;
end;

function GetStackInfoString(Info: Pointer): string;
begin
  if Assigned(Info) then begin
    Result:=PChar(Info);
    var S:=TStringList.Create;
    try
      S.Text:=Result;
      for var i:=S.Count-1 downto 0 do begin
        if Pos(' line ',S[i])=0 then S.Delete(i);
      end;
      Result:=S.Text;
    finally
      S.Free;
    end;
  end else begin
    Result:='';
  end;
end;

procedure CleanUpStackInfo(Info: Pointer);
begin
  if(Assigned(Info)) then
    FreeMem(Info);
end;

procedure StackTraceEnable;
begin
  Exception.GetExceptionStackInfoProc := GetExceptionStackInfo;
  Exception.GetStackInfoStringProc := GetStackInfoString;
  Exception.CleanUpStackInfoProc := CleanUpStackInfo;
end;

procedure StackTraceDisable;
begin
  Exception.GetExceptionStackInfoProc := nil;
  Exception.GetStackInfoStringProc := nil;
  Exception.CleanUpStackInfoProc := nil;
end;

end.

