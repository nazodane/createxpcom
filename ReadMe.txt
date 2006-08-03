**必要な物
GeckoSDK
uuidgen(linuxならapt-get install uuidgenで、WindowsならPlatform SDKにある。)
**使い方の例
ExampleというAPIを作るとします。
exをprefixと決めます。
WindowsではPlatform SDKのbinにパスを通しておいてください。(set PATH=%PATH%;c:\Program Files\Microsoft Platform SDK\Bin)
1.インターフェースファイルを作る
    ./createinterface ex Example
    とするとexIExample.idlが作成されるのでexIExample.idlにAPIの仕様を書いてください。

2.ソースを作る
    export GECKO_SDK_PATH=/usr/local/src/mozilla/dist/sdk
    ./createsource ex Example
    とするとexExample.hとexExample.cppが作成されますので、ソースを改変してください。
    なおexExample.hも書き換える必要があります。

3.ビルドに必要なファイルを作る
    export GECKO_SDK_PATH=/usr/local/src/mozilla/dist/sdk
    ./createbuild ex Example
    とするとexIExample.hとexIExample.xpiとexExampleModule.cppが作成されます。
