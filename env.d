module env;
private import std.string;
private import std.stdio;
/**
 * 環境変数
 * License: Public License
 */

extern(C){
  char* getenv(char* name);
  version(Windows){
    int putenv(char* envstring);
  }else{
    int setenv(char* name,char* value);
    int unsetenv(char* name);
  }
}

///現在のプロセスの環境変数に関するクラス
class Env{
  ///環境変数を取得します。
  static char[] get(char[] name){
    return .toString(getenv(.toStringz(name)));
  }
  ///環境変数を設定します。
  static int set(char[] name,char[] value){
    version(Windows){
      return putenv(.toStringz(name~"="~value));
    }else{
      return setenv(.toStringz(name),.toStringz(value));
    }
  }
  ///環境変数を削除します。
  static int unset(char[] name){
    version(Windows){
      return putenv(.toStringz(name~"="));
    }else{
      return unsetenv(.toStringz(name));
    }
  }
}
