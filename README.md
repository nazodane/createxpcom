# Create XPCOM
*This utilities may be outdated.*

## 必要な物
* gdc 5 (linuxならapt-get install gdc-5)
* thunderbird-dev (linuxならapt-get install thunderbird-dev)
* uuidgen (linuxならapt-get install uuid-runtimeで、WindowsならPlatform SDKにある。)

## 使い方の例
ExampleというAPIを作るとします。
exをprefixと決めます。
WindowsではPlatform SDKのbinにパスを通しておいてください。(set PATH=%PATH%;c:\Program Files\Microsoft Platform SDK\Bin)

1.インターフェースファイルを作る
    ./createinterface ex Example
    とするとexIExample.idlが作成されるのでexIExample.idlにAPIの仕様を書いてください。

2.ソースを作る
    ./createsource ex Example
    とするとexExample.hとexExample.cppが作成されますので、ソースを改変してください。
    なおexExample.hも書き換える必要があります。

3.ビルドに必要なファイルを作る
    ./createdist ex Example
    とするとexIExample.hとexIExample.xptとexExampleModule.cppが作成されます。
