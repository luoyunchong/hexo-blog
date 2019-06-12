---
title:  Visual Studio如何增加版权信息
date: 2019-06-12 00:56:03
tags:
- .NET 
- Visual Studio
category:
- Visual Studio
---

## [Visual Studio如何增加版权信息](https://www.cnblogs.com/allenxt/p/8472979.html)

> 怎么实现，上面链接里的文章应该已经很清楚了，记录一下本地的版权情况。

+  我本地vs2017安装位置的如下：**E:\Program Files (x86)\Microsoft Visual Studio\2017\Enterprise\Common7\IDE\ItemTemplates\CSharp\Code\2052\Class**

		/*
		 * CLR版本:          $clrversion$
		 * 命名空间名称/文件名:    $rootnamespace$/$safeitemname$
		 * 作    者：天上有木月
		 * 创建时间：$time$
		 * 邮箱：igeekfan@foxmail.com
		 * 文件功能描述： 
		 * 
		 * 修改人： 
		 * 时间：
		 * 修改说明：
		 */

参数 | 描述
---|---
clrversion|当前系统CLR版本号
GUID [1-10]|生成全局唯一标识符,可以生成10个 (例如:guid1)
itemname|打开添加新建项时输入的文件名称
machinename|当前机器的名称(如:pc1)
registeredorganization|注册的组织名
rootnamespace|命名空间名
safeitemname|保存的文件名
time|当前系统时间,格式:DD/MM/YYYY 00:00:00.
userdomain|用户所在的域
username|当前系统用户名
year|当前系统时间 YYY