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
}

version(Windows){
  const char[] tmpPath;
  static this(){
    tmpPath=Env.get("TEMP");
  }
}else{
  const char[] tmpPath="/tmp";
}

char[] generateUUID(){
  synchronized{
    system("uuidgen > "~tmpPath~sep~"uuid.xpcom");
    return (cast(char[])read(tmpPath~sep~"uuid.xpcom")).replace(linesep,"");
  }
}

struct Args{
  char[] prefix;
  char[] name;
  char[] interfaceName(){
    return prefix~"I"~name;
  }
  char[] moduleName(){
    return prefix~name;
  }
  char[] macroName(){
    return toupper(prefix)~"_"~toupper(name);
  }
}

class InvalidArgsException:Exception{
  this(char[] msg){
    super("InvalidArgsException: "~msg);
  }
}

Args* getArgs(char[][] args){
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
  this(char[] msg){
    super("NoGeckoSDKPathException: "~msg);
  }
}

private char[] idlPath;
private char[] binPath;

char[] getIDLPath(){
  setGeckoSDKPath();
  return idlPath;
}

bool isFirst=true;
void setGeckoSDKPath(){
  if(!isFirst)return;
  idlPath=Env.get("IDL_PATH");
  binPath=Env.get("BIN_PATH");
  if(Env.get("GECKO_SDK_PATH")){
    if(binPath==""){
      binPath=Env.get("GECKO_SDK_PATH")~sep~"bin";
    }
    if(idlPath==""){
      idlPath=Env.get("GECKO_SDK_PATH")~sep~"idl";
    }
    Env.set("PATH",binPath~pathsep~Env.get("PATH"));
  }
}
