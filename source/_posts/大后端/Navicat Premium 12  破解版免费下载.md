---
title: Navicat Premium 12  破解版免费下载
date: 2018-06-02 23:21:22
tags:
- MySQL
- Navicat Premium 12
category:
- MySQL
---

#### Navicat Premium 12 破解版免费下载

下载链接如下：[百度网盘地址](https://pan.baidu.com/s/1ENh-ZVZg8GI_DBk26BtM-Q) 密码：mi2p
里面也有readm.txt，是一个很简单的说明

由于本地安装的Mysql版本较高，版本为8.0.11,Navicat Premium 12  连接不上，会报错

> [navicat连接MySQL8.0出现2059错误](https://blog.csdn.net/qq_29932025/article/details/80045716)

最重要的就是这么一行代码就行了

        ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password';
        
##### 上面那行以mysql_native_password的加密规则更新了用户的密码 

password 对应的字符串改成你原本的密码就行了。具体原因就是如上个博客所说，mysql8.0版本以后的密码规则有变更，旧的连接工具必须升级新的驱动才可解决此问题，但，升级后，就要提示只有14天使用权限。所以，将加密规则改成mysql_native_password 即可。

<!-- more -->