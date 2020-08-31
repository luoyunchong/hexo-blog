---
title: lin-cms-dotnetcore功能模块的设计
date: 2020-6-23 12:44:22
tags:
- 开源
- .NET Core
- lin-cms
category:
- lin-cms-dotnetcore
---
# lin-cms-dotnetcore功能模块的设计

先来回答以下问题。可拉到最下面查看预览图。

## 1.什么是cms？
Content Management System，内容管理系统。

## 2.dotnetcore是什么？
.NET Core，是由Microsoft开发，目前在.NET Foundation(一个非营利的开源组织)下进行管理，采用宽松的MIT协议，可构建各种软件，包括Web应用程序、移动应用程序、桌面应用程序、云服务、微服务、API、游戏和物联网应用程序。
<!-- more -->
## 3.lin-cms 是什么？
Lin-CMS 是林间有风团队经过大量项目实践所提炼出的一套内容管理系统框架。Lin-CMS 可以有效的帮助开发者提高 CMS 的开发效率,

Lin的定位在于实现一套 CMS的解决方案,管理系统的基础框架,提供了不同的后端，不同的前端实现，后端也支持不同的数据库，是一套前后端完整的解决方案

目前官方团队维护 lin-cms-vue,lin-cms-spring-boot,lin-cms-koa,lin-cms-flask 社区维护了 lin-cms-tp5,lin-cms-react,lin-cms-dotnetcore，即已支持vue,react二种前端框架，java,nodejs,python,php,c#等五种后端语言。

### lin-cms-vue（官方）
- [https://github.com/TaleLin/lin-cms-vue](https://github.com/TaleLin/lin-cms-vue)
- 🔆 Vue+ElementUI构建的CMS开发框架，
- 林间有风团队经过大量项目实践所提炼出的一套内容管理系统框架
- 内置了 CMS 中最为常见的需求：用户管理、权限管理、日志系统等

### lin-cms-koa（官方）
- python
- [https://github.com/TaleLin/lin-cms-koa](https://github.com/TaleLin/lin-cms-koa)
- 🌀使用Node.JS KOA构建的CMS开发框架

### lin-cms-flask（官方）
- node.js
- [https://github.com/TaleLin/lin-cms-flask](https://github.com/TaleLin/lin-cms-flask)
- 🎀A simple and practical CMS implememted by flask 

### lin-cms-spring-boot(官方) 
- java
- [https://github.com/TaleLin/lin-cms-spring-boot](https://github.com/TaleLin/lin-cms-spring-boot)
- 🔨 基于SpringBoot的CMS/DMS/管理系统开发框架
### lin-cms-tp5（社区）
- php 被官方fork。
- [https://github.com/TaleLin/lin-cms-tp5](https://github.com/TaleLin/lin-cms-tp5)
- 🐘 A simple and practical CMS implememted by ThinkPHP 5.1
### lin-cms-react(社区)
- [https://github.com/Bongkai/lin-cms-react](https://github.com/Bongkai/lin-cms-react)
- 🔆 React+Antd构建的CMS开发框架

### lin-cms-dotnetcore(社区)
- C#
- 😃A simple and practical CMS implemented by .NET Core 3.1 一个简单实用、基于.NET Core
- [https://github.com/luoyunchong/lin-cms-dotnetcore](https://github.com/luoyunchong/lin-cms-dotnetcore)
- .NET Core 3.1实现的CMS；前后端分离、Docker部署、OAtuh2授权登录、自动化部署DevOps、GitHub  Action同步至Gitee
##  4.lin-cms-dotnetcore有哪些特点？

基于.NET Core3.1实现的LIN-CMS-VUE后端API，并增加了博客模块。目前实现简约的权限管理系统、基础字典项管理、随笔专栏，评论点赞、关注用户、技术频道（标签分类）、消息通知，标签等仿掘金模块。

## 功能模块的设计

### 基础权限模块
- 用户信息：邮件、用户名（唯一）、昵称、头像、分组、是否激活、手机号、是否是Admin、个性签名
    - [x] 注册/登录
    - [x] 上传头像
    - [x] 修改个人密码
    - [x] 用户基本信息修改
    - [x] 用户增删改，配置分组
- 绑定第三方账号
    - [x] GitHub登录
    - [x] QQ 登录
    - [ ] Gitee登录
-  分组信息：是否静态分组（无法删除，无法修改分组编码）、名称可以修改
    - [x] 分组增删改
    - [x] 分组配置权限
- 文件管理
    - [x] 本地文件上传
    - [x] 七牛云存储
    - [x] 文件去重，秒传
- 系统日志：请求方法、路径、http返回码、时间、用户昵称、用户id、访问哪个权限、 日志信息
    - [x] 记录系统请求的日志
    - [ ] 异常日志
- 设置管理：name(键）,value(值),provider_name(提供名),provider_key（提供者值）
    - [x] 设置新增修改删除
    - [x] 所有设置
    
比如存某用户选择的是markdown还是富文本。
```
name="Article.Editor",
value="markdown" 或 "富文本"，
provider_name为"User",
provider_key为用户Id
```
或存储七牛云的某一个配置
```
name="Qiniu.AK",
value="asfadsfadf23rft66S4XM2GIK7FxfqefauYkcAyNGDAc" ，
provider_name为"Qiniu"或自己定义的字符串
provider_key为空
```
 

### cms 管理员维护模块

- [x] 标签管理：名称、图片，是否启用/禁用，排序、文章数量、用户关注数量。
    - [x] 标签增删改
    - [x] 标签列表，禁用
    - [x] 校正文章数量
- [x] 技术频道：封面图、名称、是否启用/禁用、排序、编码、备注描述、下属标签.一个技术频道对应多个标签
    - [x] 技术频道增删改
    - [x] 列表、禁用
- [x] 随笔管理：
   - [x] 审核随笔/拉黑
   - [x] 管理员删除随笔
- [x] 评论管理
   - [x] 后台审核通过/拉黑
   - [x] 管理员删除评论
- [x] 字典类别管理:编码，名称，排序
    - [x] 增删改查
- [x] 字典管理：：编码，名称，排序，类别：如随笔类型（原创、转载、翻译）
    - [x] 增删改查

### cms 用户端模块 
- 技术频道
    - [x] 首页展示技术频道
    - [x] 选择技术频道后，可再根据标签查询文章
- 分类专栏管理:发布随笔时可选择单个分类。
    - [x] 分类增删改(随笔数量、图片、名称、排序)
    - [x] 分类列表，仅查看、编辑自己创建的分类专栏
- 标签：统计每个标签下多少个文章、多少人关注
    - [x] 标签列表
    - [x] 无限加载
    - [x] 最新/最热 根据标签名称模糊查询
    - [x] 已关注的标签
    - [x] 热门标签
- 随笔
   - [x] 支持markdown，增删改（仅自己的随笔）,修正分类专栏中的随笔数量
   - [x] 支持富文本编辑随笔
   - [x] 列表无限加载，按标签查询随笔
   - [x] 点赞随笔
   - 随笔详情页
        - [x] 支持目录导航（滚动时，固定至顶部位置），展示字数统计、预计阅读时长；
        - [x] 作者介绍：头像，昵称，签名，随笔数；
        - [x] 展示文章类型：原创、转载、翻译
        - [ ]  相关文章
        - [ ]  推荐文章
- 评论
   - [ ] 用户关闭评论时，无法对随笔进行评论
   - [ ] 评论随笔(内容支持超链接、emoji)
   - [x] 删除自己的评论
   - [x] 点赞评论
   - [x] 回复评论
-  关注
   - [x] 关注/取消关注用户
   - [x] 关注/取消关注标签
   - [x] 我关注的用户发随笔
- 个人主页
    - 随笔
        - [x] 用户专栏分类展示
        - [x] 最新发布的随笔
    - 关注
        - [x] 关注的用户
        - [x] 粉丝
        - [x] 关注的标签
- 设置
    - 个人主页设置
        - [x] 个人资料更新
    - 安全设置
        - [x] 密码修改：快速登录的账号，初次设置时可留空
    - 博客设置
        - [x] 编辑器设置，(可切换markdown/富文本)
        - [x] 代码风格配置（tango、native、monokai、github、solarized-light、vs）
- 消息
    - [x] 评论：点赞评论、评论随笔、回复评论
    - [x] 喜欢和赞：点赞随笔、点赞评论
    - [x] 关注，谁谁关注了你
### 脑图分享

[http://naotu.baidu.com/file/6532431a2e1f0c37c93c5ffd1dd5b49c?token=87690a9bc64fbae1](http://naotu.baidu.com/file/6532431a2e1f0c37c93c5ffd1dd5b49c?token=87690a9bc64fbae1)

### 分组
 分为三种
 
 ```
id  name        info
1	Admin	    系统管理员
2	CmsAdmin	内容管理员
3	User	    普通用户
 ```
 
### 审计日志
大多数表存在如下8个字段，用于记录行的变化状态，is_deleted为软删除，执行删除操作时，将其状态置为true，默认实体类继承 **FullAduitEntity**  即可拥有以下8个字段。该设计参考ABP中的实现。FullAduitEntity为泛型，默认id为long类型，FullAduitEntity\<Guid\>,即可改变主键类型，默认LinUser表主键long，保持**create_user_id**,**delete_user_id**,**update_user_id**都与LinUser的主键相同
```

id	                bigint
create_user_id  	bigint
create_time	        datetime
is_deleted	        bit
delete_user_id  	bigint
delete_time	        datetime
update_user_id	    bigint
update_time	        datetime


```


### 相关技术
- 数据库相关：ORM:[FreeSql](https://github.com/2881099/FreeSql)+DataBase:MySQL5.6
- ASP.NET Core3.1+WebAPI+RESTful
- 简化对象映射：[AutoMapper](https://automapper.org/)
- 身份认证框架：[IdentityServer4](https://github.com/IdentityServer/IdentityServer4)
- Json Web令牌:JWT
- 文档API：Swagger([Swashbuckle.AspNetCore](https://github.com/domaindrivendev/Swashbuckle.AspNetCore))
- 序列化：Newtonsoft.Json
- 测试框架：Xunit
- 日志 [Serilog](https://github.com/serilog/serilog-aspnetcore)
- 依赖注入服务[AutoFac](https://github.com/autofac/Autofac.Extensions.DependencyInjection)
- 通用扩展方法 Z.ExtensionMethods
- 云存储：七牛云 [MQiniu.Core](https://github.com/Hello-Mango/MQiniu.Core)
- 分布式事务、EventBus：[DotNeteCore.CAP](https://github.com/dotnetcore/CAP)
- GitHub第三方授权登录[AspNet.Security.OAuth.GitHub](https://github.com/aspnet-contrib/AspNet.Security.OAuth.Providers)
- QQ第三方授权登录[AspNet.Security.OAuth.QQ](https://github.com/aspnet-contrib/AspNet.Security.OAuth.Providers)
- [Docker](https://docs.docker.com/)
- [Azure DevOps](https://dev.azure.com/)
- 健康检查[AspNetCore.HealthChecks.UI.Client](https://github.com/xabaril/AspNetCore.Diagnostics.HealthChecks)
- [GitHub Action同步至Gitee](https://help.github.com/en/actions)

### 分层结构（Layers）
- framework
   - IGeekfan.CAP.MySql：为CAP实现了配合FreeSql的事务一致性扩展
- identityserver4
   - LinCms.IdentityServer4:使用id4授权登录
- src
  - LinCms.Web：接口API（ASP.NET Core)
  - LinCms.Application:应用服务
  - LinCms.Application.Contracts:DTO,数据传输对象，应用服务接口
  - LinCms.Infrastructure:基础设施，数据库持久性的操作
  - LinCms.Core:该应用的核心，实体类，通用操作类，AOP扩展，分页对象，基础依赖对象接口，时间扩展方法，当前用户信息，异常类，值对象
  - LinCms.Plugins 使用单项目实现某个业务的扩展，不需要主要项目结构，可暂时忽略。
- test
  - LinCms.Test:对仓储，应用服务或工具类进行测试


## 功能特性
- [x] Azure Devops CI/CD构建
- [x] GitHub Action实现 GitHub Gitee代码同步
- [x] [.Net Core结合AspNetCoreRateLimit实现限流](https://www.cnblogs.com/EminemJK/p/12720691.html)
- [x] 方法级别权限控制
- 社交账号管理：支持多种第三社交账号登录，不干涉原用户数据，实现第三方账号管理
- 多语言
- [x] 全局敏感词处理
- 日志记录，方便线上排查错误
- [ ] 支持多种数据库，并测试，
    - [x] Mysql
    - [ ] Postgresql 
    - [ ] Sql Server
    - [ ] SQlite

## 产品设计-评论模块的设计  

下面我们来设计一个评论模块，需要注意的是，一个评论模块也有不同的方式。从展示形式，排序规则，按钮功能设计，操作等方式都有详细的分析设计，大家可以参考who shi pm 中的文章[http://www.woshipm.com/pd/3548139.html](http://www.woshipm.com/pd/3548139.html),这里主要讲解下展式方式中的主题式的应用。


### 1.主题式
相信很多人都刷过抖音，他的评论主题式的强化版。

特点为前三个是热门评论（喜欢最多的评论），将评论分为二级，第一级采用时间倒序，第二级按照时间正序，有助于理解上下文关系。

可以总结为如下功能点

#### 用户操作：
- [x] 评论随笔(内容支持超链接、emoji)
- [x]  点赞评论/取消点赞
- [x]  回复评论
- [x]  删除自己的评论

#### 运营操作：

- [x]  审核通过/拉黑评论
- [x]  删除任何评论
- [x]  拉黑后的显示逻辑。（保留当前区块、显示内容为：该评论因违规被拉黑）
- 删除：（如果是二级评论，直接软删除，如果是一级评论，软删除子评论和当前评论-需要提前提醒用户）

#### 交互设计
- 评论的字数长度（500）、emoji。
- 点赞交互-动画、消息通知/推送
- 评论区域元素，需要有明确可点击的区域，会跳转到哪个地方。

#### 优化
- 精选或者叫置顶评论
- 该文章是否开放评论功能。
- 热门评论（点赞最多的评论）
- 标注哪些评论是作者，标准哪些评论被用户点赞。
- @逻辑，emoji，举报等

### 2 平铺式
特点是不区分子父节点关系，比如现在博客园（大多数的主题），微信朋友圈,github。
不过博客园，github，回复时，可选择引用回复，方便用户理解上下文关系。

### 3.盖楼式

这种方式有点这种感觉 **》>-**,即.net core中间件请求方式。当回复越来越多时，显示的效果就越夸张。一层套一层的显示上下文的关系。下图是网易新闻的评论效果。

![网易](https://pic.downk.cc/item/5ef0e33014195aa5942bc329.png)

## 排行榜见解

排行榜从心理学上分析，主要从四个方面影响着您：**寻找权威 、参与比较 、关注主流 、自我确认。**

如何设计一个简单的排行榜呢。。


在一个博客随笔中，我们设计一个3天、七天（周榜）、30天（月榜）、全部的榜单。以浏览量（权重1）、点赞量（20）、评论量（30)。权重可自己定义。    

1.默认取最新的随笔

前台传create_time时，使用如下sql
```
select * from `blog_article` order by create_time desc;
```
2.传排序方式为最近n天的热榜时。

参数：THREE_DAYS_HOTTEST（三天）、WEEKLY_HOTTEST(七天）、MONTHLY_HOTTEST（一个月）、HOTTEST（全部）

mysql 查询当前日期时间前三天数据
```
select date_sub(now() ,interval 3 day);
```
根据权重查询
```
select * from `blog_article` a 
where a.`create_time`>(select date_sub(now() ,interval 3 day))
order by (a.`view_hits` + a.`likes_quantity` * 20 + a.`comment_quantity` * 30) DESC, a.`create_time` DESC

```

## 更多参考
- [评论区如何设计？](http://www.woshipm.com/pd/3548139.html)
- [万字长文深度分析：产品排行榜的设计和玩法](http://www.woshipm.com/pd/1255548.html)
- [想知道谁是你的最佳用户？基于Redis实现排行榜周期榜与最近N期榜](https://zhuanlan.zhihu.com/p/52322777)


## lin-cms 开源地址分享

- 后端接口 [https://github.com/luoyunchong/lin-cms-dotnetcore](https://github.com/luoyunchong/lin-cms-dotnetcore)
- 管理后台UI [https://github.com/luoyunchong/lin-cms-vue](https://github.com/luoyunchong/lin-cms-vue)
- 前端UI[https://github.com/luoyunchong/lin-cms-vvlog](https://github.com/luoyunchong/lin-cms-vvlog)


## Demo
- 用户端 lin-cms-vvlog [https://vvlog.baimocore.cn](https://vvlog.baimocore.cn) 
  - 普通用户：710277267@qq.com
  - 密码：123qwe

- 管理员 lin-cms-vue [https://cms.baimocore.cn/](https://cms.baimocore.cn)
  - 管理员： admin
  - 密码：123qwe


### 预览图
![](https://img2020.cnblogs.com/blog/1262823/202006/1262823-20200623011318723-525107530.png)
![](https://img2020.cnblogs.com/blog/1262823/202006/1262823-20200623011212613-399587871.png)
![](https://img2020.cnblogs.com/blog/1262823/202006/1262823-20200623011231045-180612565.png)
![](https://img2020.cnblogs.com/blog/1262823/202006/1262823-20200623011246291-1001255923.png)
![](https://img2020.cnblogs.com/blog/1262823/202006/1262823-20200623011451603-1417687390.png)
![](https://img2020.cnblogs.com/blog/1262823/202006/1262823-20200623011508163-498088088.png)
![](https://img2020.cnblogs.com/blog/1262823/202006/1262823-20200623011552356-1444184559.png)
