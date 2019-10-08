---
title: ABP代码生成器
date: 2019-06-12 14:40:26
tags: ABP 代码生成器
description: 基于 DotNET Core、RazorPage，借鉴SmartCode，完成ABP的代码生成器。
category:
- ABP
---


### ABP代码生成器
基于 DotNET Core、RazorPage，借鉴SmartCode，完成ABP的代码生成器。
github地址如下：
* https://github.com/i542873057/SJNScaffolding

### 代码生成器计划

- 1、中文转英文字段，自动起名字，主要关键字段转换。
- 2、主分表代码生成
- 3、下拉代码自动生成，勾选
- 4、代码生成器部署到某一服务器中，生成后可下载生成后的代码，复制至项目中即可。
    - 文档：[csdn/部署至linux.md](https://blog.csdn.net/q710777720/article/details/91358307) 、[github/docs/部署至linux.md](https://github.com/i542873057/SJNScaffolding/blob/master/docs/%E9%83%A8%E7%BD%B2%E8%87%B3linux.md)
    - 项目部署地址 :[http://47.106.80.39](http://47.106.80.39)、[http://www.dotnetcore.xin/](http://www.dotnetcore.xin/)

CodeLF帮程序员起变量名的网站:[https://unbug.github.io/codelf/](https://unbug.github.io/codelf/)

----------

**这里主要介绍的是SJNScaffolding.RazorPage新项目的使用，他使用了. NET Core下的Microsoft.AspNetCore.Mvc.Razor类库，对于熟悉razor语法的开发者来说是非常容易的。**

## 使用方法
准备一个这样格式的数据字典

<fancybox>![avatar](https://github.com/i542873057/SJNScaffolding/raw/master/Img/2.png)</fancybox>

运行程序，然后首先来到配置界面，这里可以配置你要生成的表名，以及项目名称等，配置完成之后点击**保存配置**

<fancybox>![avatar](https://github.com/i542873057/SJNScaffolding/raw/master/Img/3.png)</fancybox>

表结构设置：在这里将你需要生成的字段从数据字典里面复制进来如图：
  注意：ID，IsDeleted，DeleterUserId，DeletionTime等字段是ABP自动生成的字段这里不必复制进来
  
<fancybox>![avatar](https://github.com/i542873057/SJNScaffolding/raw/master/Img/4.png)</fancybox>

字段复制进来后点击导入字段，生成如下图列表，自行确定每个字段是否需要后点击*生成代码*
<fancybox>![avatar](https://github.com/i542873057/SJNScaffolding/raw/master/Img/5.png)</fancybox>
代码生成之后会在对应的目录下面生成对应的文件，只需要手动添加到项目中即可使用（这里还有待改进）

<fancybox>![avatar](https://github.com/i542873057/SJNScaffolding/raw/master/Img/6.png)</fancybox>