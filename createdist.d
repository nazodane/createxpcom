private import std.string;
private import std.stdio;
private import std.process;
private import std.file;
private import env;
private import common;
private import std.path;

///ビルド時の足りない物(xxYyyModule.cppとxxIYyy.xptとxxIYyy.h)を生成します。
int main(string[] args){
  if(args.length<3){
    writef("Usage: ./createdist prefix name\n");
    return 0;
  }
  Args* tmp=getArgs(args);
  string idlPath=getIDLPath();
  system("xpidl -m typelib -I "~idlPath~" "~tmp.interfaceName~".idl");
  system("xpidl -m header -I "~idlPath~" "~tmp.interfaceName~".idl");
  std.file.write(tmp.moduleName~"Module.cpp",`#include "nsIGenericFactory.h"
#include "`~tmp.moduleName~`.h"

NS_GENERIC_FACTORY_CONSTRUCTOR(`~tmp.prefix~tmp.name~`)

static nsModuleComponentInfo components[] =
{
    {
       `~tmp.macroName~`_CLASSNAME, 
       `~tmp.macroName~`_CID,
       `~tmp.macroName~`_CONTRACTID,
       `~tmp.moduleName~`Constructor,
    },
};

NS_IMPL_NSGETMODULE(`~tmp.moduleName~`Module, components)
`);
  return 0;
}
