---
title: ASP.NET Core 部署至Ubuntu
date: 2019-06-09 00:54:15
tags:
- ASP.NET Core
- Ubuntu
category:
- .NET Core
---
* 关于ABP代码 生成器的使用介绍 https://blog.csdn.net/q710777720/article/details/91358450

将自定义-ABP代码生成器，使用. NET Core下的Razor模板引擎，配合RazorPage界面，可自定义cshtml模板，开源地址： [https://github.com/i542873057/SJNScaffolding](https://github.com/i542873057/SJNScaffolding) 部署至ubuntu、Docker的记录
> 相关技术 .NET Core2.2+Docker+Nginx+Supervisor 

<!-- more -->

## 部署至ubuntu下

可参考 [https://www.cnblogs.com/linezero/p/aspnetcoreubuntu.html](https://www.cnblogs.com/linezero/p/aspnetcoreubuntu.html)

需要安装 .NET Core 2.2，直接看官网

[https://dotnet.microsoft.com/download/linux-package-manager/ubuntu18-04/sdk-current](https://dotnet.microsoft.com/download/linux-package-manager/ubuntu18-04/sdk-current)
### 发布
使用VS2017或VS2019,右击SJNScaffolding.RazorPage->发布->配置后，如下图所示，点击保存后，生成发布包。

![Deploy-Settingsb6cfb.png](https://miao.su/images/2019/06/09/Deploy-Settingsb6cfb.png)

将生成的这个文件夹内容，使用xftp上传至linux的某一文件夹中。
使用以下命令运行
~~~
cd /home/admin/SJNScaffolding # 先cd的项目目录 
dotnet SJNScaffolding.RazorPage.dll #启动web项目，默认应该是http://localhost:5000
~~~
参考下图

<fancybox>![https://miao.su/images/2019/06/09/5NOPVXLDV0IMA_QO7cdd8d.png](https://miao.su/images/2019/06/09/5NOPVXLDV0IMA_QO7cdd8d.png)</fancybox>

ip:端口是无法访问到的，
命令行中执行，下面这行命令，是正常的，但只能服务器访问，外网无法访问。
~~~
wget http://localhost:5000
~~~

### 需要使用nginx反向代理
~~~
sudo apt-get install nginx
~~~

安装好以后，定位到 /etc/nginx/sites-available/default 文件。更改server 节点如下
~~~
server {
    listen 80;
    location / {
        proxy_pass http://localhost:5000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection keep-alive;
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}
~~~

然后重新启动 Nginx
~~~
sudo service nginx restart 
#sudo nginx -s reload　  #也可以使用这条命令重新加载配置项
~~~
 
### Supervisor 守护进程
此时使用ctrl+c会退出项目运行状态，无法关闭shell,可使用**Supervisor**，目的是上的是服务器开机时即启动服务器上的发布的 ASP .NET Core Web项目


[ASP.NET Core Linux下为 dotnet 创建守护进程（必备知识）
前言](https://www.cnblogs.com/savorboard/p/dotnetcore-supervisor.html)

[结合Nginx将asp net core部署在Linux(Ubuntu)上[基于微软官方文档翻译并补充]](https://www.jianshu.com/p/f6d2203807ab)

[Ubuntu 18.04 安装部署Net Core、Nginx全过程](https://www.cnblogs.com/xyfy/p/9881855.html)

~~~
sudo apt-get install supervisor  # 安装 守护进程 supervisor
cd /etc/supervisor/conf.d/     # 进入配置目录 
vim SJNScaffolding.conf        # 新建 一个配置文件 ，只要以 .conf结尾即可。
~~~

在文件SJNScaffolding.conf中配置如下内容，
~~~
[program:SJNScaffolding]
command=dotnet /home/admin/SJNScaffolding.RazorPage/SJNScaffolding.RazorPage.dll
directory=/home/admin/SJNScaffolding.RazorPage
environment=ASPNETCORE__ENVIRONMENT=Production
user=www-data
stopsignal=INT
autostart=true
autorestart=true 
startsecs=1
stderr_logfile=/var/log/SJNScaffolding.RazorPage.err.log 
stdout_logfile=/var/log/SJNScaffolding.RazorPage.out.log 

~~~
有相应注释的，conf不能有注释，虽然没有任何异常，但无法启动服务。
~~~
[program:HelloWebApp]
command=dotnet HelloWebApp.dll  #要执行的命令
directory=/home/yxd/Workspace/publish #命令执行的目录
environment=ASPNETCORE__ENVIRONMENT=Production #环境变量
user=www-data  #进程执行的用户身份
stopsignal=INT
autostart=true #是否自动启动
autorestart=true #是否自动重启
startsecs=1 #自动重启间隔
stderr_logfile=/var/log/HelloWebApp.err.log #标准错误日志
stdout_logfile=/var/log/HelloWebApp.out.log #标准输出日志
~~~

重启守护进程
~~~
sudo /etc/init.d/supervisor restart #或 sudo service supervisor restart
#或
# 暂停服务supervisor，启动服务supervisor
sudo service supervisor stop
sudo service supervisor start
#查看日志
tail -f  /var/log/SJNScaffolding.RazorPage.out.log 
~~~

设置ubuntu下的supervisor开机 自启动

~~~
vi /etc/rc.local
~~~
在exit 0 之前加入以下命令
~~~
/usr/local/bin/supervisord
~~~

此时打开 浏览器， ip+端口80即可访问服务。