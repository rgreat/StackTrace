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
