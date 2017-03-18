unit uCmdLine;
{$mode objfpc}{$H+}
interface
uses
  Classes,
  SysUtils;

// this class will be used for checking params, saving help and etc in near future
type tConsoleApplication =
     class
     private
     protected
     public
     published
     end;

var Console : tConsoleApplication;

// descriptions is not used in this moment, in near future will be used for help generation

// test for boolean command line option like -h or -help
function hasOptionB(const option_to_test: string; const option_to_test_long : string = ''; const desc : string = ''): boolean;

// return integer param or 0 as default
function getOptionI(const option_to_test: string; const option_to_test_long : string = ''; const desc : string = ''): Integer;

// return string parameter
function getOptionS(const option_to_test: string; const option_to_test_long : string = ''; const desc : string = ''): string;

// return last parameter as string f.e.: aaa.exe -h aaa.log - this return aaa.log
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

