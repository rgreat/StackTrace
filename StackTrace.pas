unit StackTrace;

interface

{$IFDEF DEBUG}

uses
{$IFDEF MSWINDOWS}
  JCLDebug;
{$ELSE}
  LinuxStackTrace;
{$ENDIF}

{$ENDIF}

implementation

{$IFDEF DEBUG}

  procedure StackTraceEnable;
  begin
  {$IFDEF MSWINDOWS}
    JclExceptionStacktraceOptions:=[];
    JclStackTrackingOptions:=[stStack];
    JCLDebug.SetupExceptionProcs;
  {$ELSE}
    LinuxStackTrace.StackTraceEnable;
  {$ENDIF}
  end;

  procedure StackTraceDisable;
  begin
  {$IFDEF MSWINDOWS}
    JCLDebug.ResetExceptionProcs;
  {$ELSE}
    LinuxStackTrace.StackTraceDisable;
  {$ENDIF}
  end;

{$ENDIF}

initialization
{$IFDEF MSWINDOWS}
  {$IFDEF DEBUG}
    StackTraceEnable;
  {$ELSE}
  {$IFOPT D+}
    StackTraceEnable;
  {$ENDIF}
  {$ENDIF}
{$ENDIF}

end.
