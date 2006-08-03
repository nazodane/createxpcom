private import std.string;
private import std.stdio;
private import std.process;
private import std.file;
private import common;

///interfaceを作る
///uuidgenにパスを通しとけ。
int main(char[][] args){
  if(args.length<3){
    writef("Usage: ./createxpcom prefix name\n");
    return 0;
  }
  Args* tmp=getArgs(args);
  char[] uuid=generateUUID();
  write(tmp.interfaceName~".idl",`#include "nsISupports.idl"
[scriptable, uuid(`~uuid~`)]
interface `~tmp.interfaceName~` : nsISupports
{
  ///Some Method is here
};
`);
  return 0;
}
