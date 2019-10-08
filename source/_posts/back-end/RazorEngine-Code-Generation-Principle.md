---
title:  .NET Framework 下的RazorEngine代码生成原理介绍
date: 2019-06-12 00:56:03
description: 在.NET Framework框架中，将一个cshtml文件中的Razor模板，使用RazorEngine，将数据绑定上去，生成相应的页面文本
tags:
- .NET Framework
- RazorEngine
- 代码生成器
category:
- .NET Framework
---

### RazorEngine模板引擎
在旧版本下[https://github.com/i542873057/SJNScaffolding](https://github.com/i542873057/SJNScaffolding)
> **旧版本中使用RazorEngine模板引擎技术，对于熟悉razor语法的开发者来说是非常容易的。**

### 如何使用Razor实现代码生成器
 
**这里提供最简单的一个栗子**

1. CopyRightTemplate.cshtml模板代码如下
```csharp
@model SJNScaffolding.Models.TemplateModels.CopyRightUserInfo
    //=============================================================
    // 创建人:              @Model.UserName
    // 创建时间:           @Model.CreateTime
    // 邮箱：             @Model.EmailAddress
    //==============================================================
```

2. 对应的实体类
```csharp
    public class CopyRightUserInfo
    {
        public string UserName { get; set; }
        public string EmailAddress { get; set; }
        public DateTime CreateTime { get; set; }
        public string FileRemark { get; set; }
    }
```

3. 对应的test方法
```csharp
        //根据路径。要根据自己实际情况调整
        private const string BasePath = @"..\..\..\SJNScaffolding\";
        [TestMethod]
        public void testCorpyRight()
        {
            var path = BasePath + "Templates\\CopyRightTemplate.cshtml";
            var template = File.ReadAllText(path);

            string content = Engine.Razor.RunCompile(template, "CopyRightTemplate", typeof(CopyRightUserInfo), new CopyRightUserInfo
            {
                CreateTime = DateTime.Now,
                EmailAddress = "710277267@qq.com",
                UserName = "IGeekFan"
            });

        }
```
4. 下断点后运行，content变量    

![SJNScaffolding](https://github.com/i542873057/SJNScaffolding/raw/master/Img/1.png)

**旧版本使用WPF进行开发，对应的项目名为：SJNScaffolding.WPF，已弃用**