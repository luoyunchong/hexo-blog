---
title: 好用的前后端类库及安装包整合下载
date: 2019-06-10 01:00:22
description: 记录平常使用的一些前端插件、安装包下载地址、插件、开源库等。
tags:
category:
- 大前端
---

#### 记录平常使用的一些前端插件

 + [wangEditor3](http://www.wangeditor.com/) 基于javascript和css开发的 Web富文本编辑器， 轻量、简洁、易用、开源免费
 + [webuploader](http://fex.baidu.com/webuploader/) 上传控件，flash+H5 兼容IE6+，Andorid 4+，IOS 6+
 +  [docsify.js](https://docsify.js.org/#/)   一个基础markdown的文档生成器，可以写API接口文档。A magical documentation site generator.
 + cropper 头像上传，裁剪，旋转等，blueimp-canvas-to-blob 解决部分浏览器兼容性
 +  [JQuery-EasyUI-insdep](https://www.insdep.com/) 基于Easyui的样式扩展UI，变得更好看，多了许多插件。
 +  jquery-extensions　[源文件下载地址](https://pan.baidu.com/s/1EDYwfHgGcQEA6S5N8-j_jg) 已无人维护，开源地址已经找不到了，该扩展基于easyui1.3.6，在本项目中不可直接引用发布后的压缩文件，必须拆分引用,按照依赖顺序引用该目录下的扩展:bower_components\jquery-extensions\jeasyui-extensions,部分bug已解决，有些扩展在新版本的easyui已经有了，所以在extensions中，有些可删除。
* jquery.jdirk.js 为js扩展了许多通用的方法,extensions-master依赖此js,完整的代码都在extensions-master中
* 
#### 安装包下载

+ redis.msi文件  [安装包](https://pan.baidu.com/s/1Hb0nQCm5gCIJsFi__ppQSw) 缓存使用redis
+ redis-desktop-manager.exe 文件 链接：https://pan.baidu.com/s/1c3ra73E 密码：k81k
+ SQL Server 2012 链接：https://pan.baidu.com/s/1KcJ0nKW-PUcXImXPbb7MJQ 密码：g8av  
+  Visual Studio 2017 直接从官网下载，安装时，只选择ASP.NET和Web开发即可。
+  TortoiseSVN [官网](https://tortoisesvn.net/downloads.html)
+  MYSQL 官网下载即可，选择5.7.22版本
+  Navicat for mysql [百度网盘地址](https://pan.baidu.com/s/1ENh-ZVZg8GI_DBk26BtM-Q) 密码：mi2p

#### 另外vs2017中的插件(可选)
* visualsvn for visual studio 2017
* resharper 

#### staticfiles开源库介绍、通用js

> 维护地址为 http://ip/summary/libs/staticfiles.git
> bower 静态资源地址 http://ip:5678/

* easyui.default-extension.js为easyui增加默认属性，扩展jquery方法
* base.js 大多数项目通用的com对象，
* passwordComplexityHelper.js 让密码也可以在后台配置
* libs 这个文件夹下的js是Abp自带的通用js，改了abp.jquery.js，增加了abp.easyui.js,abp.layer.js，统一的调用接口，可以实现不同的弹框效果

>根目录新建.bowerrc文件，实现自定义bower仓库
~~~
{
    "registry": "http://ip:5678",
    "timeout": 30000
}
~~~
> 在web项目目录执行以下命令
~~~
    bower install staticfiles --save
~~~

### 后端技术
> 后端使用语言为C#,访问数据库技术主要采用EntityFrameWork6,复杂sql可使用dapper，数据库使用SQL server ,可切换成mysql,框架使用的ABP   [官网](http://www.aspnetboilerplate.com/)
* ABP框架有哪些好处，可以参考如下文章[ABP的一些优点](https://www.cnblogs.com/farb/p/ABPIntro.html)
+ 在使用框架时，我们会发现，代码会更加规范，系统也更加稳定，
 
#### ABP 后端已完成的功能
> 后端系统基本功能已经完善,还差一些，如:导入excel,导出excel,工作流。

 * 用户-角色-权限-日志-设置-文件-组织-登录-注册-找回密码-注册邮件激活-短信-双身份登录验证-通用增删改查-集成Dapper-自动迁移-svn提交后自动发布-缓存redis-字典管理-错误处理（跳404，403等）-兼容性差跳下载浏览器页面-不同开发模式下，使用不同的配置
 *
