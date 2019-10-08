---
title: 日常命令行记录
date: 2019-05-15 14:41:21
description: 平常使用到的命令行记录
tags: .NET Core
category:
- 命令行
---

windows 查看具体某一端口 是否被占用
```
netstat -ano | findstr "5000"
```

npm 包安装，运行项目
```
npm install
npm run serve
npm run build
```


.ef code first 生成数据库，迁移数据库
.net framework  /.net core code first 
```
Add-Migration "name"
Update-Database 
Update-Database  -Force
Update-Database  -Verbose
```


dotnet core cil
```
dotnet watch run

```

windows 运行 打开我的电脑等图标
```
rundll32.exe shell32.dll,Control_RunDLL desk.cpl,,0

```

redis 密码配置
```
安装目录下的winodws-serve.conf
requirepass 123qwe    #此处注意，行前不能有空格

重启redis服务、cmd进入安装目录下执行，验证密码是否配置成功
redis-cli.exe -h 127.0.0.1 -p 6379 -a 123qwe

```

IDEA 快捷键
```
Ctrl+Alt+L   格式化代码
Ctrl+Shfit+F 全局查询
```

Vscode
```
ALT+SHIFT+F  格式化代码
```


Windows server 2016激活
```
DISM /online /Set-Edition:ServerDatacenter /ProductKey:CB7KF-BWN84-R7R2Y-793K2-8XDDG /AcceptEula

```


idea配置激活地址
```
http://idea.merle.com.cn
```

VS2019激活码

```
Visual Studio 2019 Enterprise:BF8Y8-GN2QH-T84XB-QVY3B-RC4DF

Visual Studio 2019 Professional:NYWVH-HT4XC-R2WYW-9Y3CM-X4V3Y

```
