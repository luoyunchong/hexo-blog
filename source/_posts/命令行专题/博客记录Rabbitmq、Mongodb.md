---
title: 博客记录Rabbitmq、Mongodb
date: 2019-05-8 14:41:21
tags: Rabbitmq Mongodb
---


### Rabbitmq
> 服务开启后，管理地址：http://localhost:15672/ 
* 帐号：guest 密码 : guest

rabbitmq安装后，web管理端口http://localhost:15672/ 无法访问的解决

1.
[https://blog.csdn.net/sxf359/article/details/78239382](https://blog.csdn.net/sxf359/article/details/78239382)


2.
![示例](https://note.youdao.com/yws/api/personal/file/7FA20220D5454DF9B0788B33E3A41FED?method=download&shareKey=c2e5f279b574304e3bd777a75a4e3045)

3. 此命令执行要先定位到rabbitmq的安装目录下的sbin文件夹下。
~~~
 rabbitmq-plugins enable rabbitmq_management
~~~


### Mongodb 

* 删除服务
~~~ bash
sc delete mongodb
~~~


