private import std.string;
private import std.stdio;
private import std.process;
private import std.file;
private import env;
private import common;
private import std.path;

///インターフェースファイルと同じ名前の実装を作成(nzITestならnzTestを作成します。)
int main(char[][] args){
  if(args.length<3){
    writef("Usage: ./createsource prefix name\n");
    return 0;
  }
  Args* tmp=getArgs(args);
  char[] idlPath=getIDLPath();
  char[] uuid=generateUUID();
  char[] data;
  synchronized{
    system("xpidl -m header -e "~tmpPath~sep~"iheader.xpcom -I "~idlPath~" "~tmp.interfaceName~".idl");
    data=cast(char[])read(tmpPath~sep~"iheader.xpcom");
  }
  int i=data.find("/* Header file */");
  if(i==-1)assert(0);
  int i2=data.find("/* Implementation file */");
  if(i2==-1)assert(0);
  write(tmp.moduleName~".h",`#ifndef _`~tmp.macroName~`_H_
#define _`~tmp.macroName~`_H_

#include "`~tmp.interfaceName~`.h"

#define `~tmp.macroName~`_CONTRACTID "@xxx.xxx.jp/xx_ext/xxx;1"
#define `~tmp.macroName~`_CLASSNAME "This is Sample"
#define `~tmp.macroName~`_CID {0x`~uuid[0..8]~`, 0x`~uuid[9..13]~`, 0x`~uuid[14..18]~`, \
    { 0x`~uuid[19..21]~`, 0x`~uuid[21..23]~`, 0x`~uuid[24..26]~`, 0x`~uuid[26..28]~`, 0x`~uuid[28..30]~`, 0x`~uuid[30..32]~`, 0x`~uuid[32..34]~`, 0x`~uuid[34..36]~` }}
`~\n~data[i..i2]~\n~"#endif //_"~tmp.macroName~"_H_\n");
  int i3=data.find("/* End of implementation class template. */");
  if(i3==-1)assert(0);
  write(tmp.moduleName~".cpp",`#include "`~tmp.moduleName~`.h"`~\n~data[i2..i3]);
  return 0;
}
