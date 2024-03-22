## 使用前须知：本仓库只更新版本文件，至于unidbg-fetch-qsign本体已经停止更新，新的版本文件有概率被检测导致封号或无法使用，请谨慎使用，如果可以请尽量使用旧的版本

![Cover](https://github.com/CikeyQi/unidbg-fetch-qsign-shell/assets/61369914/d6f08c4e-0788-41f8-8b70-32ed490cb56b)

# unidbg-fetch-qsign-shell

使用 [unidbg-fetch-qsign 1.1.9](https://github.com/fuqiuluo/unidbg-fetch-qsign/releases/tag/1.1.9) ，适合各大主流Linux版本，提供两种部署方案，最大程度兼容

Windows平台请移步 [unidbg-fetch-qsign-gui](https://github.com/CikeyQi/unidbg-fetch-qsign-gui) <br>

</div>

## 如何启动

- 将以下命令复制粘贴到 Linux 控制台中点击回车，按照提示操作即可

``` shell
bash <(curl -L https://sourl.cn/UT4an4)
```

- <details>
  <summary>选择systemd部署流程示例</summary>
  
  ```shell
  [root@localhost ~]# bash <(curl -L https://sourl.cn/UT4an4)
    % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                   Dload  Upload   Total   Spent    Left  Speed
  100   421  100   421    0     0   1604      0 --:--:-- --:--:-- --:--:--  1600
  100  9179  100  9179    0     0   4394      0  0:00:02  0:00:02 --:--:-- 10723
  请选择使用 systemd 或 Docker 进行管理
  1. systemd管理（官方推荐）
  2. Docker管理
  请输入数字以选择管理方式: 1
  当前系统中存在 systemd 服务
  正在下载并检查所需软件包，请稍等...
  已安装 unzip 工具，跳过安装
  已安装 Java 环境，跳过安装
  正在下载 unidbg-fetch-qsign，请稍等...
  下载 unidbg-fetch-qsign 完成，开始解压...
  正在下载 qsign_operations 脚本，请稍等...
  下载 qsign_operations 脚本成功，5 秒钟后启动...
  请选择 0 开始配置Qsign服务，若配置错误或需要修改请重新运行脚本并选择 启动qsign_operations.sh 
  请选择操作:
  0. 创建或更新 qsign 配置
  1. 重启 qsign
  2. 停止 qsign
  3. 启动 qsign
  4. 设置开机启动
  5. 禁用开机启动
  6. 查看运行状态
  7. 重载 qsign 服务
  8. 查看最近日志
  9. 查询内存和PID
  10. 导出运行日志
  11. 设置别名(qsign)
  请输入数字选项: 0
  
  JAVA_HOME 环境变量未找到，将查找可能的 JDK 安装目录。
  JDK is installed at: /usr/lib/jvm/jre-openjdk
  输入执行版本(比如 8.9.76) : 8.9.96
  创建 systemd 服务 /etc/systemd/system/qsign.service 成功。
  qsign 已启动.
  [root@localhost ~]# curl http://127.0.0.1:8080
  {
      "code": 0,
      "msg": "IAA 云天明 章北海",
      "data": {
          "version": "1.1.9",
          "protocol": {
              "qua": "V1_AND_SQ_8.9.96_5050_HDBM_T",
              "version": "8.9.96",
              "code": "5050",
              "package_name": "com.tencent.mobileqq"
          }
      }
  }
  ```

  </details>

- <details>
  <summary>使用Docker部署流程示例</summary>

  ```shell
  [root@localhost ~]# bash <(curl -L https://sourl.cn/UT4an4)
    % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                   Dload  Upload   Total   Spent    Left  Speed
  100   421  100   421    0     0   1537      0 --:--:-- --:--:-- --:--:--  1542
  100  9179  100  9179    0     0   5197      0  0:00:01  0:00:01 --:--:-- 10348
  请选择使用 systemd 或 Docker 进行管理
  1. systemd管理（官方推荐）
  2. Docker管理
  请输入数字以选择管理方式: 2
  已安装 Docker 环境，跳过安装
  Docker 已启动，跳过启动
  正在拉取 unidbg-fetch-qsign-docker 镜像...
  Using default tag: latest
  latest: Pulling from cikeyqi/unidbg-fetch-qsign-docker
  1efc276f4ff9: Pull complete 
  a2f2f93da482: Pull complete 
  12cca292b13c: Pull complete 
  d73cf48caaac: Pull complete 
  77de508cf504: Pull complete 
  22991f054630: Pull complete 
  19d6514ba1c1: Pull complete 
  Digest: sha256:097b6cc79ddcf6c329d9258307f4734407032dc7363d92267d5bcb9312f63e43
  Status: Downloaded newer image for cikeyqi/unidbg-fetch-qsign-docker:latest
  docker.io/cikeyqi/unidbg-fetch-qsign-docker:latest
  镜像拉取完成
  请输入容器名称(默认随机): qsign
  请输入TXLIB_VERSION(默认8.9.96):   
  请输入签名服务端口号(默认8080): 
  =========================
  容器名称: qsign
  TXLIB_VERSION: 8.9.96
  =========================
  请确认以上信息是否正确？[Y/n] Y
  正在启动容器，请稍等...
  2a5d896696f66a80dd11e1f3efb65d9418871d70ece987c44017839763fccd6e
  容器启动完成
  =========================
  签名服务已启动
  签名版本: 8.9.96
  公网地址: http://127.0.0.1:8080
  内网地址: http://127.0.0.1:8080
  =========================
  unidbg-fetch-qsign-docker 安装完成
  [root@localhost ~]# curl http://127.0.0.1:8080
  {
      "code": 0,
      "msg": "IAA 云天明 章北海",
      "data": {
          "version": "1.2.1",
          "protocol": {
              "qua": "V1_AND_SQ_8.9.96_5050_HDBM_T",
              "version": "8.9.96",
              "code": "5050",
              "package_name": "com.tencent.mobileqq"
          },
          "pid": 7
      }
  }
  ```

  </details>

- 使用期间遇到启动脚本问题可以加群与我们反馈：**551081559**（关于qsign本体的问题我们无法解决）

## 搭建好不会用？

- 用都不会用，杂鱼\~❤杂鱼\~\~❤要喂饭到嘴边吗？真拿你没办法呢~❤
- [点我打开喂饭教程](https://github.com/CikeyQi/unidbg-fetch-qsign-shell/issues/11)

## 致谢

- unidbg-fetch-qsign项目：[unidbg-fetch-qsign](https://github.com/fuqiuluo/unidbg-fetch-qsign)

## 免责声明

- 本仓库代码仅供学习参考，用于便捷性启动，如有侵权，请联系删除
