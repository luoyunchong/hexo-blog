---
title: .NET Core下集成七牛云下的对象存储
date: 2019-7-28 18:43:22
# top: 近期更新
tags:
- 对象存储
category:
- .NET Core
---

## 七牛云对象存储

.NET Core下集成 七牛云下的对象存储

## 开源地址
[https://github.com/luoyunchong/dotnetcore-examples/tree/master/asp.net-core-qiniu](https://github.com/luoyunchong/dotnetcore-examples/tree/master/asp.net-core-qiniu)

<!-- more -->

## 集成类库
|基础类库集成方案|开源地址|文档|说明|
|---|---|---|---|
|[Qiniu云对象存储](https://github.com/luoyunchong/dotnetcore-examples/tree/master/dotnet-core-efcore)|[.net](https://github.com/qiniu/csharp-sdk)/[.net core](https://github.com/Hello-Mango/MQiniu.Core)|[c# sdk](https://developer.qiniu.com/kodo/sdk/1237/csharp)|由于官网未支持. net core，所以 大家看[社区版解决方案](https://github.com/Hello-Mango/MQiniu.Core)|

## 前提
* 本地windows 10,安装 .net core 2.2+
* Linux 服务器 Ubuntu Server 16+
* 服务器安装了Docker
* 本地xftp、xshell（这二个分别是windows传文件至linux，执行命令行。）
## 准备
在七牛云中自行注册后，在个人中心，密钥管理，生成自己的密钥（https://portal.qiniu.com/user/key）
v* AK，SK分别代表：AccessKey/SecretKey
* Bucket中的vant-ui，是创建对象存储时起的名字
* PrefixPath中的值，随意字符串，前缀地址。
* Host为：融合 CDN 测试域名,可自行绑定自己的域名，否则只有三十天免费使用时长。
## appsettings.json配置项
```
  "Qiniu": {
    "AK": "eUH1O-ft66S4XM2GIK7FGmj7czuYkcAyNGDAc-wq",
    "SK": "4dOi1daSr2-YgofhAfWb8JaLrbgozCmgD6AUmmM9",
    "Bucket": "vant-ui",
    "PrefixPath": "ui",
    "Host": "http://pu5vnz60k.bkt.clouddn.com/"
  }
```
## 安装包

```
Install-Package MQiniu.Core 
```
## 代码解读
配置swagger的过程就不说了，创建QiniuController
```
  /// <summary>
/// 七牛云上传服务
/// </summary>
[Route("api/[controller]")]
[ApiController]
public class QiniuController : ControllerBase
{
    private readonly IConfiguration _configuration;

    public QiniuController(IConfiguration configuration)
    {
        _configuration = configuration;
    }

    /// <summary>
    /// 根据后台配置项，得到请求七牛云的token值，前台也可根据此token值上传至七牛云服务
    /// </summary>
    /// <returns></returns>
    [HttpGet("access_token")]
    public string GetAccessToken()
    {
        Mac mac = new Mac(_configuration["Qiniu:AK"], _configuration["Qiniu:SK"]);
        PutPolicy putPolicy = new PutPolicy { Scope = _configuration["Qiniu:Bucket"] };
        return Auth.CreateUploadToken(mac, putPolicy.ToJsonString());
    }

    /// <summary>
    /// 上传文件至七牛云,code为200，代表上传成功,其他代表不成功
    /// </summary>
    /// <param name="file">单个文件</param>
    /// <returns>new { code = 200, data ="七牛云文件地址，包括http://....mm.png", msg = "上传成功" };</returns>
    [HttpPost("upload")]
    public dynamic Upload(IFormFile file)
    {
        if (file.Length == 0)
        {
            return new { code = 1, msg = "文件为空" };
        }

        FormUploader upload = new FormUploader(new Config()
        {
            Zone = Zone.ZONE_CN_South,//华南 
            UseHttps = true
        });

        var fileName = ContentDispositionHeaderValue
            .Parse(file.ContentDisposition)
            .FileName.Trim();

        string qiniuName = _configuration["Qiniu:PrefixPath"] + "/" + DateTime.Now.ToString("yyyyMMddHHmmssffffff") + fileName;
        Stream stream = file.OpenReadStream();
        HttpResult result = upload.UploadStream(stream, qiniuName, GetAccessToken(), null);

        if (result.Code == 200)
        {
            return new { code = 200, data = _configuration["Qiniu:Host"] + qiniuName, msg = "上传成功" };
        }

        return new { code = 1, msg = "上传失败" };
    }
}

```


Upload方法中，Zone.ZONE_CN_South，代表华南，所以创建对象存储时要注意，请选择与此相同的位置（华南），或根据实际情况修改Zone所在地区的枚举值即可。
```
FormUploader upload = new FormUploader(new Config()
{
    Zone = Zone.ZONE_CN_South,//华南 
    UseHttps = true
});

```

## 发布至Linux下的Docker
双击 publish.bat，生成的文件夹为如下：

<fancybox>![](https://ae01.alicdn.com/kf/Hb55f140a2c614cc5a3f98ec62e2f00b2B.jpg)</fancybox>

修改项目名为qiniu-web，复制 至linux服务器中，（xftp工具）
<fancybox>[![image](https://upload-images.jianshu.io/upload_images/2001974-48771e9fce281262.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)](https://ae01.alicdn.com/kf/Heb3f16360c6b4cf1b5b4eeaa90f02969r.jpg)</fancybox>

使用xshell远程登录后，进入root权限。
```bash
root@VM-37-104-ubuntu:/home/ubuntu/# sudo su
root@VM-37-104-ubuntu:/home/ubuntu/# cd qiniu-web
```
前置条件，在ubuntu上安装好了docker。并且正常运行。

-d 代表后台运行，此时将对外显露5000端口运行，5000是运行后，docker对外的端口，80是这个服务对外的端口，其中Dockerfile 存在语句EXPOSE 80

```bash
docker build -t igeekfan/qiniu .     #生成images
docker run -d -p 5000:80 igeekfan/qiniu  # 生成 container 并运行在5000端口
```
此时打开 浏览器， ip+端口5000即可访问服务，请加/swagger。

本项目已部署至服务器 [http://122.152.192.161:5000/swagger/index.html](http://122.152.192.161:5000/swagger/index.html)

## 重新部署
*　删除启动后的容器。先stop，再删除镜像，id是第一列，输入前面几个字符即可。
```
root@VM-37-104-ubuntu:/home/ubuntu/qiniu-web# docker ps
CONTAINER ID        IMAGE                 COMMAND                  CREATED             STATUS              PORTS                    NAMES
b2c6f61637d4        igeekfan/qiniu        "dotnet Qiniu.Web.dll"   3 minutes ago       Up 3 minutes        0.0.0.0:5000->80/tcp     compassionate_williamson
0a5e0deb3b2e        portainer/portainer   "/portainer"             7 weeks ago         Up 3 days           0.0.0.0:9000->9000/tcp   prtainer
root@VM-37-104-ubuntu:/home/ubuntu/qiniu-web# docker stop b2c
b2c
root@VM-37-104-ubuntu:/home/ubuntu/qiniu-web# docker rm b2c
b2c
```

- 删除之前的镜像

```
docker rmi igeekfan/qiniu  #删除igeekfan/qiniu镜像
```
想要重新部署则再走上面部署即可。

### 参考如下命令
[https://blog.igeekfan.cn/2019/06/10/back-end/Docker-nginx-Learn/](https://blog.igeekfan.cn/2019/06/10/back-end/Docker-nginx-Learn/)
```
docker images  # 查看所有镜像
docker ps -a #所有正在运行的容器Container

docker stop 容器id #终止容器
docker rmi 镜像id/镜像名称  #删除镜像
docker rm 容器id   #删除容器
```

##  运行结果
<fancybox>![](https://ae01.alicdn.com/kf/H2d84f03351814b1b90739be2477f0a05Q.jpg)</fancybox>


## 参考

- .NET Core版本七牛云SDK使用[https://www.cnblogs.com/OMango/p/8447480.html](https://www.cnblogs.com/OMango/p/8447480.html)
- .NET Core部署至Linux 下的Docker [http://blog.igeekfan.cn/2019/06/09/dotnetcore/ASP.NET-Core-Deploy-To-Docker-Ubuntu/](http://blog.igeekfan.cn/2019/06/09/dotnetcore/ASP.NET-Core-Deploy-To-Docker-Ubuntu/)


<RightMenu />