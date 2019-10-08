---
title: 为什么我们要使用DTO
date: 2019-8-23 11:19:22
author: 天上有木月
description: 一个完整的业务是通过领域实体（对象）domain建立的，而DTO是根据UI的需求来设计的。
cover: true
category:
- 重新出发
---

### 基础结构解释
- UI-表现层-与控制器打交道（UI向Controller 传递数据时使用DTO(数据传输对象)）
- Service-应用服务层
- Domain 领域对象
- DTO 数据传输对象，一般只包含基础的Get,Set功能，也会包含一些数据验证，如必填项，大小，自定义规则等。

一个完整的业务是通过领域实体（对象）domain建立的，而DTO是根据UI的需求来设计的。

1. 比如：Customer领域对象可能会包含一些诸如FirstName, LastName, Email, Address等信息。但如果UI上不打算显示Address的信息，那么CustomerDTO中也无需包含这个 Address的数据。

2. 比如：User表设计字段如下：Id,UserName,Password,RegisterTime。注册时，那这个接口的参数应该只有UserName,Password，因为RegisterTime是后台赋值的，Id是数据库自动生成的。即设计一个RegisterDto,只包含UserName,Password二个字段，作为注册接口的参数。不然，那二个参数对于开发前端的人来说是无意义的，因为传递也没有效果。所以不应该暴露给前端使用。

以上即领域对象来实现业务，DTO只注重数据。

UI->Controller（通过 DTO完成数据传输，表单验证）->Service(操作Domain，完成业务服务)。
DTO->Domain，在C#中可使用一些类库，快速将二个类相互转换。[良好的设计什么要使用DTO，集成 AutoMapper](https://www.jianshu.com/p/46770bef1f09)

>标题：为什么我们要使用DTO
> 作者：天上有木月
> 出处：[https://www.cnblogs.com/igeekfan/p/11400900.html](https://www.cnblogs.com/igeekfan/p/11400900.html)
> 版权：本站使用「署名 4.0 国际」创作共享协议，转载请在文章明显位置注明作者及出处。