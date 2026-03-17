# StackTrace
Crossplatform Stack Trace for Delphi

For Windows uses JCLDebug.

For Linux uses ported Free Pascal stacktrace.

Usage: 
```pascal
program Test;

{$APPTYPE CONSOLE}

{$R *.res}


uses StackTrace, Classes, SysUtils;

begin
  try
    WriteLn('Start');

    raise Exception.Create('Test Error');
  except
    on E: Exception do begin
      WriteLn('Exception: '+E.Message);
      WriteLn('StackTrace: '#13#10+E.StackTrace);
    end;
  end;

  ReadLn;
end.
```
Result:
```
Start
Exception: Test Error
StackTrace:
[00A08049] Test.Test (Line 14, "Test.dpr")
```
