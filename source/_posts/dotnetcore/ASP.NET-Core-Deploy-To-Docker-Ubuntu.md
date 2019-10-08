---
title: ASP.NET Core 部署至Ubuntu下的Docker
date: 2019-06-09 00:54:15
tags:
- ASP.NET Core
- Ubuntu
- Docker
category:
- .NET Core
---
## 使用Docker 方式部署

* 关于ABP代码 生成器的使用介绍 https://blog.csdn.net/q710777720/article/details/91358450

将自定义-ABP代码生成器，使用. NET Core下的Razor模板引擎，配合RazorPage界面，可自定义cshtml模板，开源地址： [https://github.com/i542873057/SJNScaffolding](https://github.com/i542873057/SJNScaffolding) 部署至Docker的记录
> 相关技术 .NET Core2.2+Docker

<!-- more -->


可参考此文档 ：[ASP.NET Core开发Docker部署](https://www.cnblogs.com/zxtceq/p/7403953.html)
~~~
#1.本地安装Docker for Windows后，可使用Docker方式运行
FROM mcr.microsoft.com/dotnet/core/aspnet:2.2-stretch-slim AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/core/sdk:2.2-stretch AS build
WORKDIR /src
COPY ["SJNScaffolding.RazorPage/SJNScaffolding.RazorPage.csproj", "SJNScaffolding.RazorPage/"]
COPY ["SJNScaffolding/SJNScaffolding.csproj", "SJNScaffolding/"]
RUN dotnet restore "SJNScaffolding.RazorPage/SJNScaffolding.RazorPage.csproj"
COPY . .
WORKDIR "/src/SJNScaffolding.RazorPage"
RUN dotnet build "SJNScaffolding.RazorPage.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "SJNScaffolding.RazorPage.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "SJNScaffolding.RazorPage.dll"]

#2. 发布时，使用此Dockerfile配置
#FROM mcr.microsoft.com/dotnet/core/aspnet:2.2-stretch-slim AS base
#COPY . /app
#WORKDIR /app
#EXPOSE 80
#ENTRYPOINT ["dotnet", "SJNScaffolding.RazorPage.dll"]
~~~

把第"2. 发布时，使用此Dockerfile配置“后面的注释展开，上面的全部注释。
[![Dockerfileea151.png](https://miao.su/images/2019/06/09/Dockerfileea151.png)](https://miao.su/image/ftdf5)


右击SJNScaffolding.RazorPage->发布->配置后，如下图所示，点击保存后，生成发布包。

[![Deploy-Settingsb6cfb.png](https://miao.su/images/2019/06/09/Deploy-Settingsb6cfb.png)](https://miao.su/image/ftwvM)

将生成的这个文件夹内容，使用xftp上传至linux的某一文件夹中。

[![PXKF63RUOC5L99LPWe1367.png](https://miao.su/images/2019/06/09/PXKF63RUOC5L99LPWe1367.png)](https://miao.su/image/ftxWU)

具体上传步骤就不说了。

[![MYGE3MZ5BNFJQ6R476cf92.png](https://miao.su/images/2019/06/09/MYGE3MZ5BNFJQ6R476cf92.png)](https://miao.su/image/ftuw8)


前置条件，在ubuntu上安装好了docker。并且正常运行。
    
**-d** 代表后台运行，此时将对外显露5000端口运行，5000是运行后，docker对外的端口，80是这个服务对外的端口，其中Dockerfile 存在语句EXPOSE 80
~~~
cd /home/admin/SJNScaffolding # 先cd的项目目录 
docker build -t igeekfan/sjnscaffolding .     #生成images
docker run -d -p 5000:80 igeekfan/sjnscaffolding  # 生成 container 并运行在5000端口
~~~

此时打开 浏览器， ip+端口5000即可访问服务。