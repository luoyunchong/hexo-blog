---
title: lin-cms-dotnetcore的开源之路
date: 2019-10-8 12:44:22
top: 近期更新
tags:
- 开源
- .NET Core
- lin-cms
category:
- lin-cms-dotnetcore
---


## 开源lin-cms-dotnetcore
- 地址：https://github.com/luoyunchong/lin-cms-dotnetcore

1.什么是cms？

Content Management System，内容管理系统。

2.dotnetcore是什么

.NET Core，是由Microsoft开发，目前在.NET Foundation(一个非营利的开源组织)下进行管理，采用宽松的MIT协议，可构建各种软件，包括Web应用程序、移动应用程序、桌面应用程序、云服务、微服务、API、游戏和物联网应用程序。跨平台，支持Linux 
- 更多功能（自定义扩展-模块系统）
<!-- more -->
3.lin-cms 是什么

Lin-CMS 是林间有风团队经过大量项目实践所提炼出的一套内容管理系统框架。Lin-CMS 可以有效的帮助开发者提高 CMS 的开发效率, 需要前端？请访问前端仓库。官方团队产品了解请访问TaleLin

4.lin-cms-dotnetcore有哪些特点？

前后端分离，提供后端接口，更少的依赖，后续将实现模块化安装与卸载。
- 用户管理、分组管理、分组权限管理、日志系统、文件上传等

## 设计如下
#### 字典管理
BaseType 1 对BaseItem多。
如：标签管理，一个文章下可以设置多个标签，原本需要设计表Tag,字段也大抵为Id,Name,Sort及关联表。
我们使用BaseType、BaseItem实现。
BaseType中TypeCode为tag,FullName为标签，id为1时。
BaseItem中BaseTypeId为1，ItemCode为编码,ItemName为标签。ItemCode为不重复的字符串即可。

另Tag与Article的关联表，需要另设计一个表。

当我们要实现文章类别的下拉，原本需要设计一个表ArticleType，有字段,id,name,sort等。
我们可以通过BaseType、BaseItem来实现，从而简化这些基础数据。
BaseType有一条数据，TypeCode为 字符串category、FullName文章类别，BaseItem存多个文章类别(Java、大数据、Python、C#等)，编码不同即可。

1. 表结构

#### base_type （字典类别管理）
字段| 类型|备注
---|---|---|
id | int|
type_code|varchar(50)|类别编码|
full_name|varchar(50)|全称|
sort_code|int|排序码|

#### base_type （字典管理）
字段| 类型|备注
---|---|---|
id | int|
base_type_id|int|类别id(关联base_type的id)|
item_code|varchar(50)|字典编码|
item_name|varchar(50)|字典全称|
sort_code|int|排序码|


## 前端cms
扩展实现一个博客，项目地址：https://github.com/luoyunchong/lin-cms-vue

## 实现功能如下：
- 文章类别管理(编码为Article.Classify的字典值)
- 标签管理(编码为Article.Tag的字典值)
- 留言板(Comment表ArticleId为0)
- 文章管理(Artilce)
   - 点赞
- 评论管理(Comment表ArticleId关联Article)
   - 后台审核
   - 回复评论
   - 删除
