module env;
private import std.string;
private import std.stdio;
/**
 * 環境変数
 * License: Public License
 */

extern(C){
  immutable(char)* getenv(immutable(char)* name);
  version(Windows){
    int putenv(immutable(char)* envstring);
  }else{
    int setenv(immutable(char)* name,immutable(char)* value);
    int unsetenv(immutable(char)* name);
  }
}

///現在のプロセスの環境変数に関するクラス
class Env{
  ///環境変数を取得します。
  static string get(string name){
    return fromStringz(getenv(.toStringz(name)));
  }
  ///環境変数を設定します。
  static int set(string name,string value){
    version(Windows){
      return putenv(.toStringz(name~"="~value));
    }else{
      return setenv(.toStringz(name),.toStringz(value));
    }
  }
  ///環境変数を削除します。
  static int unset(string name){
    version(Windows){
      return putenv(.toStringz(name~"="));
    }else{
      return unsetenv(.toStringz(name));
    }
  }
}
