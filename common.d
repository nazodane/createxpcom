module common;
/**
 * XPCOMの引数を取り扱う。
 */
private{
  import std.string;
  import std.stdio;
  import env;
  import std.process;
  import std.file;
  import std.path;
  import std.array;
  import std.ascii;
}

version(Windows){
  const string tmpPath;
  static this(){
    tmpPath=Env.get("TEMP");
  }
}else{
  const string tmpPath="/tmp";
}

string generateUUID(){
  synchronized{
    system("uuidgen > "~tmpPath~dirSeparator~"uuid.xpcom");
    return (cast(string)read(tmpPath~dirSeparator~"uuid.xpcom")).replace(""~newline,"");
  }
}

struct Args{
  string prefix;
  string name;
  string interfaceName(){
    return prefix~"I"~name;
  }
  string moduleName(){
    return prefix~name;
  }
  string macroName(){
    return toUpper(prefix)~"_"~toUpper(name);
  }
}

class InvalidArgsException:Exception{
  this(string msg){
    super("InvalidArgsException: "~msg);
  }
}

Args* getArgs(string[] args){
  assert(args.length>=3);
  Args* re=new Args;
  re.prefix=args[1];
  re.name=args[2];
  if(re.prefix.length>=4){
    throw new InvalidArgsException("prefix is too long");
  }
  foreach(char i;re.prefix){
    bool flag=false;
    foreach(char c;lowercase){
      if(i==c){
        flag=true;
        break;
      }
    }
    if(!flag){
      throw new InvalidArgsException("prefix has uppercase or not Ascii character");
    }
  }
  if(re.name.length<=1){
    throw new InvalidArgsException("name is too short");
  }
  bool flag=false;
  foreach(char c;uppercase){
    if(re.name[0]==c){
      flag=true;
    }
  }
  if(!flag){
    throw new InvalidArgsException("first character of name is not uppercase");
  }
  return re;
}

class NoGeckoSDKPathException:Exception{
  this(string msg){
    super("NoGeckoSDKPathException: "~msg);
  }
}

private string idlPath;
private string binPath;

string getIDLPath(){
  setGeckoSDKPath();
  return idlPath;
}

bool isFirst=true;
void setGeckoSDKPath(){
  if(!isFirst)return;
  idlPath=Env.get("IDL_PATH");
  binPath=Env.get("BIN_PATH");
  if(Env.get("GECKO_SDK_PATH") != ""){
    if(binPath==""){
      binPath=Env.get("GECKO_SDK_PATH")~dirSeparator~"bin";
    }
    if(idlPath==""){
      idlPath=Env.get("GECKO_SDK_PATH")~dirSeparator~"idl";
    }
    Env.set("PATH",binPath~dirSeparator~Env.get("PATH"));
  } else
  idlPath = "/usr/share/idl/thunderbird/";

  isFirst = false;
}
