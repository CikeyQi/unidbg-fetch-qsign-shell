<div align="center">
<img alt="yuhuo" src="https://github.com/CikeyQi/unidbg-fetch-qsign-gui/blob/main/readme/logo.png"/>


# unidbg-fetch-qsign-shell

[1.1.9](https://github.com/fuqiuluo/unidbg-fetch-qsign/releases/tag/1.1.9)を使用し、公式の管理スクリプトを使用して、JDK環境の自動ダウンロードとインストール、ワンクリックでのデプロイを行います。

一部のLinuxの主要バージョンにのみ対応しており、Windowsプラットフォームの場合は[unidbg-fetch-qsign-gui](https://github.com/CikeyQi/unidbg-fetch-qsign-gui)に移動してください。<br>

</div>

## 起動方法

Linuxのターミナルで次のコマンドを入力します。

``` shell
bash <(curl -L https://sourl.cn/y997nz)
```

指示に従って操作を行ってください。

## 設定方法

### Miao-Yunzaiに設定する方法

- configフォルダ内のbot.yamlファイルを見つけます。

- 末尾に次の設定を追加します：sign_api_addr: http://127.0.0.1:8080/sign?key=114514（icqqは0.5.1以上のバージョンを推奨しています）

- configフォルダ内のqq.yamlを見つけて、プロトコルを1または2に変更します（Androidの場合は1、apadの場合は2）。

- 起動に成功します。

- もしこのプロジェクトが役に立った場合は、無料のスターをください。ありがとうございます。

## 致谢

- unidbg-fetch-qsignプロジェクト：[unidbg-fetch-qsign](https://github.com/fuqiuluo/unidbg-fetch-qsign)
