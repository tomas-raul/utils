unit uCmdLine;
{$mode objfpc}{$H+}
interface
uses
  Classes,
  SysUtils;

// this class will be used for checking params, saving help and etc in near future
type

{ tConsoleApplication }

 tConsoleApplication =
     class
     private
     protected
     public
     published
     end;

var Console : tConsoleApplication;

// descriptions is not used in this moment, in near future will be used for help generation

// test for boolean command line option like -h or -help
function getOptionB(const option_to_test: string; const option_to_test_long : string = ''; const desc : string = ''; const default : boolean = false): boolean;

// return integer param or 0 as default
function getOptionI(const option_to_test: string; const option_to_test_long : string = ''; const desc : string = ''; const default : integer = 0): Integer;

// return string parameter
function getOptionS(const option_to_test: string; const option_to_test_long : string = ''; const desc : string = ''; const default : string = ''): string;

// return last parameter as string f.e.: aaa.exe -h aaa.log - this return aaa.log
function getFinalS(const name, desc, default : string) : String;

function getHelpString : string;

implementation

uses StringUtils, math;

type tOption =
     record
       short_name,
       long_name,
       description,
       default_value : string;
       lastParam : boolean;
       with_param_type : byte;
     end;
     tOptions = array of tOption;

var options : tOptions;

procedure AddOption(const short_name, long_name, description, defaultvalue : string; const with_param_type : byte = 0; const last_param : boolean = false);
var opt : tOption;
    i : integer;
begin
   if length(options) > 0 then
   for i := low(options) to high(options) do
   begin
      if (options[i].short_name = short_name) and (options[i].long_name = long_name) then
        Exit;
   end;
   opt.short_name:= short_name;
   opt.long_name:= long_name;
   opt.description:= description;
   opt.default_value:= defaultvalue;
   opt.lastParam:=last_param;
   opt.with_param_type:= with_param_type;
   SetLength(options,length(options)+1);
   options[high(options)] := opt;
end;

var cfg_file_options : array of string;

function getOptionB(const option_to_test: string; const option_to_test_long: string; const desc: string; const default : boolean): boolean;
var pi : byte;
    ott, ottl, p : string;
begin
   AddOption(option_to_test,option_to_test_long,desc,ifThen(default,'YES','no'),1);
   result := default;
   ott := '-' + lowercase(option_to_test);
   ottl := '-' + lowercase(option_to_test_long);
   for pi := 1 to ParamCount do
   begin
      p := lowercase(paramstr(pi));
      if ((ott <> '-') and (p = ott)) or ((ottl <> '-') and (p = ottl)) then
       Exit(not default);
   end;
   if length(cfg_file_options) > 0 then
   for pi := low(cfg_file_options) to high(cfg_file_options) do
   begin
      p := lowercase(cfg_file_options[pi]);
      if ((ott <> '-') and (p = ott)) or ((ottl <> '--') and (p = ottl)) then
      begin
         Exit(not default);
      end;
   end;
end;

function getOptionI(const option_to_test: string; const option_to_test_long: string; const desc: string; const default: integer): Integer;
begin
   AddOption(option_to_test,option_to_test_long,desc,IntToStr(default),2);
   result := strtointdef(getOptionS(option_to_test,option_to_test_long,desc,IntToStr(default)),default);
end;

function getOptionS(const option_to_test: string; const option_to_test_long: string; const desc : string; const default: string): string;
var pi : byte;
    ott, ottl, p, s : string;
begin
   AddOption(option_to_test,option_to_test_long,desc,default,3);
   result := default;
   ott := '-' + lowercase(option_to_test);
   ottl := '--' + lowercase(option_to_test_long);
   for pi := 1 to ParamCount do
   begin
      p := lowercase(paramstr(pi));
      if ((ott <> '-') and (p = ott)) or ((ottl <> '--') and (p = ottl)) then
      begin
         Exit(paramstr(pi+1));
      end;
   end;
   if length(cfg_file_options) > 0 then
   for pi := low(cfg_file_options) to high(cfg_file_options) do
   begin
      p := lowercase(cfg_file_options[pi]);
      if ((ott <> '-') and (p = ott)) or ((ottl <> '--') and (p = ottl)) then
      begin
         Exit(cfg_file_options[pi+1]);
      end;
   end;
end;

function getFinalS(const name, desc, default : string): String;
begin
   AddOption('',name,desc,default,3,true);
   result := Paramstr(Paramcount);
end;

function getHelpString: string;
var i, max_len_short_name, max_len_long_name : integer;
    res, sn, ln, p : string;
    opt : tOption;
begin
   res := '';
   if length(options) = 0 then Exit('');

   max_len_short_name := 0;
   max_len_long_name := 0;
   for i := low(options) to high(options) do
   begin
      max_len_short_name := max( max_len_short_name,length(options[i].short_name));
      max_len_long_name := max( max_len_long_name,length(options[i].long_name));
   end;
   for i := low(options) to high(options) do
   begin
      opt := options[i];
      if opt.with_param_type <> 0 then
      begin
         p := '<';
         case opt.with_param_type of
           1: p += 'bool';
           2: p += 'int';
           3: p += 'string';
         end;
         p += '>';

      end else
       p := '';
      sn := ForceStringLength(opt.short_name, max_len_short_name);
      ln := ForceStringLength(opt.long_name, max_len_long_name);
      if opt.lastParam then
      begin
         res += ' ' + ifThen(opt.long_name <> '','<'+opt.long_name+'>','') +
                ifThen(opt.default_value <> '','    default : ' + opt.default_value,'') +
                LineEnding;
      end else
      begin
      res += ' ' + ifThen(opt.short_name <> '','-' + sn,'') +
             ifThen((opt.short_name <> '') and (opt.long_name <> ''),' ' + cOR + ' ','') +
             ifThen(opt.long_name <> '','--' + ln,'') +
             ifThen(p <> '','     parameter ' + ForceStringLength(p,8)+ LineEnding ,'')+
             ifThen(opt.default_value <> '',LineEnding+'     default : ' + opt.default_value,'') +
             LineEnding;
      end;
//      res += LineEnding;

      if opt.description <> '' then
      res += '     description : ' + opt.description + LineEnding;
      res += LineEnding + LineEnding;
   end;
   result := res;
end;

procedure tryLoadConfig;
var cfn : string;
    fs : tFileStream;
    ss : tStringStream;
    cfg : string;
    pcfg : pchar;
    option : string;

begin
  cfn := getOptionS('','configuration-file','file with configuration','');
  if (cfn <> '') and FileExists(cfn) then
  begin
     fs := tFileStream.Create(cfn,fmOpenRead);
     ss := tStringStream.Create('');
     ss.CopyFrom(fs,fs.Size);
     ss.Position:=0;
     cfg := ss.DataString;
     fs.Free;
     ss.free;

     while cfg <> '' do
     begin
        if cfg[1] = '"' then
        begin
           pcfg := pchar(cfg);
           option := trim(AnsiExtractQuotedStr(pcfg,'"'));
           cfg := string(pcfg);
        end else
        begin
           option := fetch(cfg,' ');
        end;
        setLength(cfg_file_options,length(cfg_file_options)+1);
        cfg_file_options[high(cfg_file_options)] := option;
     end;
  end;
end;

initialization
{$IFDEF CONSOLE}
//   Console := tConsoleApplication.Create; - for future use
   tryLoadConfig();

{$ENDIF}
finalization
{$IFDEF CONSOLE}
//   Console.Free; - for future use
{$ENDIF}
end.

