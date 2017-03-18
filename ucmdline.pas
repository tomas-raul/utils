unit uCmdLine;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  SysUtils;

type tConsoleApplication =
     class
     private
     protected
     public
     published
     end;

var Console : tConsoleApplication;

function hasOptionB(const option_to_test: string; const option_to_test_long : string = ''; const desc : string = ''): boolean;
function getOptionI(const option_to_test: string; const option_to_test_long : string = ''; const desc : string = ''): Integer;
function getOptionS(const option_to_test: string; const option_to_test_long : string = ''; const desc : string = ''): string;
function getFinalS : String;

implementation

function hasOptionB(const option_to_test: string; const option_to_test_long: string; const desc: string): boolean;
var pi : byte;
    ott, ottl, p : string;
begin
   result := false;
   ott := '-' + lowercase(option_to_test);
   ottl := '-' + lowercase(option_to_test_long);
   for pi := 1 to ParamCount do
   begin
      p := lowercase(paramstr(pi));
      if ((ott <> '-') and (p = ott)) or ((ottl <> '-') and (p = ottl)) then
       Exit(true);
   end;
end;

function getOptionI(const option_to_test: string; const option_to_test_long: string; const desc: string): Integer;
begin
   result := strtointdef(getOptionS(option_to_test,option_to_test_long),0);
end;

function getOptionS(const option_to_test: string; const option_to_test_long: string; const desc: string): string;
var pi : byte;
    ott, ottl, p, s : string;
begin
   result := '';
   ott := '-' + lowercase(option_to_test);
   ottl := '-' + lowercase(option_to_test_long);
   for pi := 1 to ParamCount do
   begin
      p := lowercase(paramstr(pi));
      if ((ott <> '-') and (p = ott)) or ((ottl <> '-') and (p = ottl)) then
      begin
        result := paramstr(pi+1);
      end;
   end;
end;

function getFinalS: String;
begin
   result := Paramstr(Paramcount);
end;

initialization
{$IFDEF CONSOLE}
   Console := tConsoleApplication.Create;
{$ENDIF}
finalization
{$IFDEF CONSOLE}
   Console.Free;
{$ENDIF}
end.

