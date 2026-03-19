# StackTrace
**Crossplatform Stack Trace for Delphi**

For **Windows** uses **JCLDebug**.

For **Linux** uses ported **Free Pascal** stacktrace.

Usage: 
```pascal
program Test;

{$APPTYPE CONSOLE}

{$R *.res}

uses StackTrace, Classes, SysUtils;

procedure ErrorTest;
begin
  raise Exception.Create('Test Error');
end;

begin
  try
    WriteLn('Start');

    ErrorTest;
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
Exception: Test Error
StackTrace:
[00AF2F29] Test.ErrorTest (Line 12, "Test.dpr")
[00AFA00B] Test.Test (Line 18, "Test.dpr")
```
