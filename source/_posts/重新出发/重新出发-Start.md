---
title: 重新出发-Start
date: 2019-6-17 15:19:22
tags:
- .NET Core
category:
- 重新出发
---

## 重新出发
还有几天大学就毕业了，我在大学期间，在学校跟着老师一起做了一些项目，用到的技术是 asyui+ **.net** framework4.x+sql server 2008+ef 5+vs2012，框架是旧三层架构，没有批量操作和事务，编辑操作时，也极易出错。

后来升级架构，用了一段时间layui+vue.js（非单页面）+abp (.net frameowork)+mysql 5.7+ef 6+vs2017，后来由于人少，还是换成了easyui 1.51 insdep  版本

我自己也了解到了一些新的技术,如vue.js的SPA,跨平台的 **.net core**，容器化的docker,负载均衡的nginx，只是帮别人做的一些小项目，用到了vue和 **.net core**，其他的就没有实际上线的经验，每次使用时，总是去查询相应的博客、官网，没有系统的学习文档，所以让我觉得这些基础没有打好，所以我打算重新学习一次。系统地整理出相应的知识点，打好基础。


目前用到的一些技术栈、架构风格、开发工具如下

vue.js(SPA)+**.net core**2.2(JWT+EF Core)+Mysql 5.6+ docker+nginx+ubuntu+vs2019（vscode)

## .net core 可学习的框架，社区等
0. awesome-dotnet 关于 **.net core** 的优秀项目应该都能在这找到 [https://github.com/quozd/awesome-dotnet/](https://github.com/quozd/awesome-dotnet/)
1. abp vnext ，可参考[https://cn.abp.io/documents/abp/latest/Index](https://cn.abp.io/documents/abp/latest/Index)，我觉得它的特点是：分层更细，但复杂度更大，不过有着完善的文档与社区，架构风格统一，对于每个模块都有着相应的风格指导，另外如官网所说，他的“主要目标是提供一个便捷的基础设施来创建微服务解决方案”（目前还处于0.18待Release版本，2019-6-17）
2. surging 专注与 **.net core**下的微服务引擎的解决方案，（1.0于19年初发布，以我的水平，没有良好的入门文档，我还需要继续学习才能使用。）
3. .NET Core Community  国内的开源组织，有着优秀的基于.net core 的开源项目，大家可以去学习学习
[https://github.com/dotnetcore](https://github.com/dotnetcore)
4. csredis对标的是stackExchange.Redis，大家都说stackExchange.redis有的时候会超时（Timeout Bug），好像一直没有解决(项目全部使用异常可解决)，[https://github.com/2881099/csredis](https://github.com/2881099/csredis)
5. FreeSql是 **.net 、.net core**的最方便的 ORM,     [https://github.com/2881099/FreeSql](https://github.com/2881099/FreeSql)（我还没用，但做这个项目的大佬一直推荐，我相信一定不错）也是做csredis的作者
6. 

## 小技巧：
1. 如果你想找什么资料，去github搜索可以使用 ```awesome``` + *关键字*
~~~
awesome vue
~~~


## 技术学习

1.前端相应的知识点
- es6
- webpack
- vue.js
- vuex
- vue-router
- typescript
- 



2. 后端技术栈
- nginx
- linux 如：ubuntu
- docker
- c# 如: .net core 、asp **.net core**
- java 如: spring boot




 我的github还没什么特别有价值的东西， [https://github.com/luoyunchong](https://github.com/luoyunchong)
 
 - 一个博客，.NET 版本，[http://igeekfan.cn/](http://igeekfan.cn/)
 - 一个ABP的代码生成器，使用 **.NET Core2.2**、Razor Pages、RazorEngine的cshtml的模板，配置生成相应的代码 [http://www.dotnetcore.xin/](http://www.dotnetcore.xin/)
 - 基于abp (.NET版本)的前端js、结合easyui的前端js，可打包成bower，之前为了统一不同项目下的前端基础类库。 [https://luoyunchong.github.io/staticfiles/](https://luoyunchong.github.io/staticfiles/)
 - 基于 ABP vNext  的MicroserviceDemo、增加了iview的SPA界面， 实现前后端分离的用户角色授权管理功能 
 - 一个使用hexo的博客,采用Material X主题，docs分支为博客源文件，发布github Pages [https://luoyunchong.github.io/hexo-blog/](https://luoyunchong.github.io/hexo-blog/)
 - 一个基于 ASP **.NET Core 2.2** 的基础集成方案 [https://github.com/luoyunchong/BasicTemplate](https://github.com/luoyunchong/BasicTemplate)
    *  JWT集成
    *  EF实现事务一致性
    *  统一的创建人、创建时间、删除人、删除时间，软删除
    *  集成 EF Core Mysql版本
    *  AutoMapper集成 
