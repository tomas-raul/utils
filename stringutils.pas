unit StringUtils;

{$mode objfpc}{$H+}

interface

uses
  Classes,
  SysUtils;

const cOR = 'or';

function IfThen( const a : boolean; const b,c : string) : string;
function IfThenByte( const a : boolean; const b,c : byte) : byte;
function IfThenBoolean( const a : boolean; const b,c : boolean) : boolean;
function IfThenInt( const a : boolean; const b,c : integer) : integer;

function fetch(var str : string; const delim : string) : string;
function ForceStringLength(const str : string; const len : integer) : string;

implementation

uses strutils;

function IfThen(const a: boolean; const b, c: string): string;
begin
   if a then Exit(b) else Exit(c);
end;

function IfThenByte(const a: boolean; const b, c: byte): byte;
begin
   if a then Exit(b) else Exit(c);
end;

function IfThenBoolean(const a: boolean; const b, c: boolean): boolean;
begin
   if a then Exit(b) else Exit(c);
end;

function IfThenInt(const a: boolean; const b, c: integer): integer;
begin
   if a then Exit(b) else Exit(c);
end;

function fetch(var str: string; const delim: string): string;
var i : integer;
begin
   i := pos(delim,str);
   if i > 0 then
   begin
      result := copy(str,1,i-1);
      str := copy(str,i + length(delim),length(str));
   end else
   begin
     result := str;
     str := '';
   end;

end;

function ForceStringLength(const str: string; const len: integer): string;
begin
   result := copy(str,1,len);
   result := result + dupestring(' ',len-length(result));
end;


end.

