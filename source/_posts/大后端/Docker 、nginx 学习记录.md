---
title: Docker 、nginx 学习记录
date: 2019-06-10 01:00:22
# description: Docker for windows 下安装 问题，Docker相关文档，Docker 命令行等，nginx相关命令行
tags:
- nginx
- Docker
category:
- 学习记录
---


## Docker 学习记录

Docker Desktop 在windows 10下安装正常，Hyper-V也正常安装，但Hyper-V下无法打开虚拟交换机管理器，提示“尝试检索虚拟交换列表时出错”，也无法快速创建虚拟机，提示“xx异常”。事件查看器->Windows日志->系统中，Hyper-V-VmSwitch 一直提示 类似"VMSwitch driver due to error"

* [Hyper-V管理器无法打开虚拟交换机管理，别人的方法，但无济于事](https://www.cnblogs.com/GeDiao/p/7975667.html)

别人都是说去在windows功能上打开Hyper-v即可，而我开启了一直不行，我这个主要是Hyper-V问题，导致Docker服务一直无法正常启动。微软的论坛也找了，没人能解决，说重装系统？这只能终极解决方案。下面这个链接，我也回答了一下。
* [hyperv 无法打开虚拟交换机管理器，报错“尝试检索虚拟交换机列表时出错](https://social.msdn.microsoft.com/Forums/healthvault/zh-CN/cf5c267b-1ca0-40dd-9959-5ecb3475a06c/hyperv?forum=window10app)

**后来找到解决办法，在设置-更新和安全-Windows预览体验计划，先去官网申请，申请后，升级系统，他会帮我修复Hyper-V.**

<!-- more -->

## Docker 相关文档
[Docker最全教程——从理论到实战(一)](https://www.cnblogs.com/codelove/p/10030439.html)

[八个Docker的真实应用场景]( http://dockone.io/article/126)

[docker pull很慢解决办法、配置阿里镜像](https://blog.csdn.net/julien71/article/details/79760919)

[ASP.NET Core开发Docker部署](https://www.cnblogs.com/zxtceq/p/7403953.html)

Docker 中的三个概念，镜像（Image)、容器（Container)、仓库（Repository）

一个Image可有多个Container，我们可以把Image发布至Dokcer提供的仓库中，提供给他人使用。


## Dockerfile 文件规则

~~~

~~~

## Docker  命令行  
* Command-Line Interfaces [https://docs.docker.com/engine/reference/run/](https://docs.docker.com/engine/reference/run/)
~~~
docker images  # 查看所有镜像

docker ps -a #所有正在运行的容器Container
docker ps -l #最后启动的容器

docker rm 容器id   #删除容器
ocker rm $(docker ps -q -a) #一次性删除所有的容器

docker rmi 镜像id/镜像名称  #删除镜像
docker rmi $(docker images -q) #一次性删除所有的镜像。

docker build -t igeekfan/demo .  #运行构建命令,构建Docker 镜像。 

docker run 镜像 #运行
docker run -it -p 5000:80 igeekfan/demo
#5000是运行后，docker对外的端口，80是这个服务对外的端口，其中Dockerfile 存在语句EXPOSE 80
docker run -d -p 5000:80 igeekfan/demo 
-d 参数后台运行

docker start 容器id
docker restart 容器id
docker stop 容器id #终止容器。
docker logs $CONTAINER_ID ##在container外面查看它的输出 
docker attach $CONTAINER_ID ##连接上容器实时查看：

docker pull microsoft/dotnet  #单独安装某一镜像

docker save 镜像id > 文件 #持久化镜像
docker load < 文件
~~~
我们如果想将Docker 放置到其他机器运行，很简单。
~~~
#直接保存镜像，然后复制镜像到其他机器，然后使用docker 命令load 既可。

docker save igeekfan/demo > demo.tar

#然后加载命令

docker load < demo.tar
~~~

## nginx 相关命令

Ubuntu 进入root 权限，不用每次加sudo
~~~
sudo su 
#然后输入root 密码
~~~

配置nginx
~~~
vim /etc/nginx/nginx.conf
~~~

nginx 验证配置是否成功
~~~
nginx -t 
~~~

重新加载nginx配置项
~~~
nginx -s reload
~~~

状态、重启、停止、启动
~~~
service nginx status 
service nginx restart
service nginx stop 
service nginx start
~~~


- [Ubuntu18.04更换镜像源](https://blog.csdn.net/jasonzhoujx/article/details/80360459)

## nginx配置二级域名

在Ubuntu服务器上安装好nginx，实现不同静态或动态页面服务，可配置自定义二级域名
* 可参考 [nginx配置二级域名](https://cloud.tencent.com/developer/article/1183138)

我是使用的[腾讯云
](https://cloud.tencent.com/redirect.php?redirect=1042&cps_key=01a3c9a5a3ce578801cd6f805c09b701&from=console)，有需要可以使用。域名注册的过程就不BB了，假设前提，你有一个备案好的域名。
云产品->域名解析->选择一个域名（列表页选择解析）->添加记录（依次从在表格上填写，如下图所示，可点击查看大图）

<fancybox>

![](https://miao.su/images/2019/06/25/RSF6QBO9P646IV17eef5c.png)

</fancybox>

远程连接服务器后，增加相应的配置项，我们使用nginx实现域名的配置，安装nginx(也不详细说明)，这时候，（/var/www/html）会有一个.html,就是一个欢迎使用nginx的页面。

下面的功能，是模拟二个服务，一个是
- http://122.152.192.161:81 ->这个是nginx安装后的默认欢迎页面。
- http://122.152.192.161:82 ->这个是我使用[hexo](https://github.com/luoyunchong/hexo-blog)做的静态博客，（可以随便使用一个静态页面index.html，以供测试，root参数配置相应的目录）

81端口

<fancybox>

![image51555.png](https://miao.su/images/2019/06/25/image51555.png)

</fancybox>

82端口

<fancybox>

![imagec5d3e.png](https://miao.su/images/2019/06/25/imagec5d3e.png)

</fancybox>

~~~bash

cd /etc/nginx/sites-enabled
vim defult
~~~

~~~
server {
        listen 81;
        listen [::]:81;

        root /var/www/html;
        index index.html index.nginx-debian.html;
        charset utf-8;
        location / {
             try_files $uri $uri/ =404;
        }
}

server {
        listen 82;
        charset utf-8;
        root /var/www/html/hexo-blog;
        index index.html index.htm index.nginx-debian.html;
        location  / {
                try_files $uri $uri/ =404;
        }
}
~~~

因为/etc/nginx/nginx.conf把conf.d文件夹中所有以.conf后缀的都包含进去作为配置项了。
~~~bash
cd /etc/nginx/conf.d
vim docs.conf  #所以这个docs只要以.conf后缀即可，“docs"可自定义值。
~~~

~~~
server {  
    listen 80;
    server_name docs.igeekfan.cn;

    location / {
        proxy_set_header   X-Real-IP $remote_addr;
        proxy_set_header   Host      $http_host;
        proxy_pass         http://0.0.0.0:81;
    }
}
~~~

~~~
#ESC然后:wq退出，保存，
vim blog.conf   #再新建一个文件夹，配置博客
~~~

~~~
server {
    listen 80;
    server_name blog.igeekfan.cn;

    location / {
        proxy_set_header   X-Real-IP $remote_addr;
        proxy_set_header   Host      $http_host;
        proxy_pass         http://0.0.0.0:82;
    }

}
~~~

然后,加载配置项
~~~
nginx -s reload
~~~

效果图 81端口，转发到 docs.igeekfan.cn

<fancybox>

![Y_XRRQRZJZXJ5N96919c.png](https://miao.su/images/2019/06/25/Y_XRRQRZJZXJ5N96919c.png)

</fancybox>

效果图 82端口,转发到 blog.igeekfan.cn

<fancybox>

![imagedfa93.png](https://miao.su/images/2019/06/25/imagedfa93.png)

</fancybox>
