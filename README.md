<div align="center">
<img alt="yuhuo" src="https://github.com/CikeyQi/unidbg-fetch-qsign-gui/blob/main/readme/logo.png"/>


# unidbg-fetch-qsign-shell

使用[unidbg-fetch-qsign 1.1.9](https://github.com/fuqiuluo/unidbg-fetch-qsign/releases/tag/1.1.9)，使用官方管理脚本，自动下载安装JDK环境，一键式部署

仅适用于部分Linux主流版本，Windows平台请移步[unidbg-fetch-qsign-gui](https://github.com/CikeyQi/unidbg-fetch-qsign-gui)<br>

</div>

## 如何启动

在Linux终端中输入

``` shell
bash <(curl -L https://sourl.cn/y997nz)
```

按照提示操作即可

## 使用方法

### 如何配置进Miao-Yunzai

- 在config中找到bot.yaml文件

- 在底部添加：`sign_api_addr: http://127.0.0.1:8080/sign?key=114514`(icqq建议升级到0.5.1版本以上才能自动匹配版本）

- 在config中找到qq.yaml更改协议为1或2（安卓手机或apad）

- 启动成功

- 如果该项目对你有帮助，请给我一个免费的Star，谢谢

## 致谢

- unidbg-fetch-qsign项目：[unidbg-fetch-qsign](https://github.com/fuqiuluo/unidbg-fetch-qsign)
