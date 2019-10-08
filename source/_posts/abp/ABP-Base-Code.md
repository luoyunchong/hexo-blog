---
title: ABP源码解析
date: 2019-01-09 14:40:26
tags: ABP
description: 旧项目使用ABP框架时，对基础的ABP源码、框架、架构的简单介绍
category:
- ABP
---

## 2.Abp简介
 *ABP是“ASP.NET Boilerplate Project (ASP.NET样板项目)”的简称。**
ASP.NET Boilerplate是一个用最佳实践和流行技术开发现代WEB应用程序的新起点，它旨在成为一个通用的WEB应用程序框架和项目模板。

### 框架
ABP是基于最新的ASP.NET CORE，ASP.NET MVC和Web API技术的应用程序框架。并使用流行的框架和库，它提供了便于使用的授权，依赖注入，验证，异常处理，本地化，日志记录，缓存等常用功能。

### 架构
ABP实现了多层架构（领域层，应用层，基础设施层和表示层），以及领域驱动设计（实体，存储库，领域服务，应用程序服务，DTO等）。还实现和提供了良好的基础设施来实现最佳实践，如依赖注入。

### 模板
ABP轻松地为您的项目创建启动模板。它默认包括最常用的框架和库。还允许您选择单页（Angularjs）或多页架构，EntityFramework或NHibernate作为ORM。
访问官网，了解更多。

* 用户接口层（Presentation）：提供一个界面，实现用户交互操作。
* 应用 层（Application):进行展现层与领域层之间的协调，协调业务对象来执行特定的应用 程序的任务。不包含业务逻辑。
* 领域层（Domain)：包括业务对象和业务规则，这是应用程序的核心层。
* 基础设计层：（Infrastructure）:提供通用技术来支持更高的层。仓储可通过ORM来实现数据库的交互

## ABP基础原则：

	 应用层不包含业务逻辑
	 领域服务处理业务逻辑
	 应用服务(AppLIcationService)VS领域服务（Manager)


## 在什么情况下应使用领域服务

	 执行某个具体的业务操作。
	 领域对象的转换
	 以多个领域对象为输入，返回一个值对象

* [参考此文档](https://www.cnblogs.com/sheng-jie/p/6943213.html)

![image](https://upload-images.jianshu.io/upload_images/2799767-550ec13d4df50f8f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

 > 总结：
 1. 领域服务和应用服务的区别在于只有领域服务才处理业务逻辑。应用服务作为领域服务的消费方，是很薄的一层。
 2. 过度使用领域服务会导致贫血领域模型（即所有的业务逻辑都位于领域服务中，而不是实体和值对象中）。

 ### 领域服务（Domain Service）
 > 摘要： 当处理的业务规则跨越两个（及以上）实体时，应该写在 领域服务方法里

 ### 领域事件 (Domain Event)
> 领域事件用来定义特定于领域的事件，领域服务与实体一起实现了不属于单个实体的业务规则
