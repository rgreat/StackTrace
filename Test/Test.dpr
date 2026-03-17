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
