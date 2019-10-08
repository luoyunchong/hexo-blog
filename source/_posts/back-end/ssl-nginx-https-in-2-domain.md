
---
title:  ssl-nginx-https配置二级域名
date: 2019-8-1 17:51:03
tags:
- ubuntu
- nginx
- https
category:
- 大后端
---

## ubuntu下nginx配置二级域名https
通过反向代理转发至后台一个简单 [asp.net core  七牛云文件上传](https://github.com/luoyunchong/dotnetcore-examples/tree/master/asp.net-core-qiniu/Qiniu.Web)项目。


## 前提
- 有自己的域名
- 并配置好域名解析
![](https://ae01.alicdn.com/kf/H8e464efd6fde43c7b1c1ced1e3f9eeb84.jpg)
- 可去腾讯申请[域名型免费版的ssl（DV）](https://buy.cloud.tencent.com/ssl)

<!-- more -->

## 配置项
申请完ssl，把nginx里的二个文件复制到nginx的/etc/nginx目录中。

![](https://ae01.alicdn.com/kf/Hb2fb43a0c6ef469c82dd1fd99c051fa1w.jpg)


![](https://ae01.alicdn.com/kf/H0e2ab0c30412464c94d77b68afe244edT.jpg)

在/etc/nginx/conf.d文件夹新建任意以.conf后缀的文件，
```
server {  
    listen 443;
    server_name docs.igeekfan.cn;
    ssl on; #启用 SSL 功能
    ssl_certificate 1_docs.igeekfan.cn_bundle.crt; #证书文件名称
    ssl_certificate_key 2_docs.igeekfan.cn.key; #私钥文件名称
    ssl_session_timeout 5m;
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2; #请按照这个协议配置
    ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:HIGH:!aNULL:!MD5:!RC4:!DHE; #请按照这个套件配置，配置加密套件，写法遵循 openssl 标准。
    ssl_prefer_server_ciphers on;

    location / {
        proxy_set_header   X-Real-IP $remote_addr;
        proxy_set_header   Host      $http_host;
        proxy_pass         http://0.0.0.0:5000;
    }
}

server {
	listen 80;
	server_name docs.igeekfan.cn; #填写绑定证书的域名
	rewrite ^(.*)$ https://docs.igeekfan.cn/$1 permanent; #把http的域名请求转成https
}

```

## 测试

原本 [122.152.192.161:5000/swagger/index.html](122.152.192.161:5000/swagger/index.html) 即可访问项目 ，
现在可通过域名  [https://docs.igeekfan.cn/swagger/index.html](https://docs.igeekfan.cn/swagger/index.html)

## 参考
- [Nginx 服务器证书安装](https://cloud.tencent.com/document/product/400/35244)