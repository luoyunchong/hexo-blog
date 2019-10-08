---
title: Git的使用学习
date: 2019-06-25 13:58:06
tags: Git
category: 日常问题
---


- git 默认不区分文件名大小写,配置git大小写敏感

~~~bash
git config core.ignorecase false
~~~


## 关于github下载太慢

* 查ip https://www.ipaddress.com/ 

改此文件 C:\Windows\System32\drivers\etc\hosts
```
219.76.4.4 github-cloud.s3.amazonaws.com
192.30.xx.xx github.com
151.101.xx.xx github.global.ssl.fastly.net
151.101.184.133 raw.githubusercontent.com
```

cmd 刷新dns
```
ipconfig /flushdns
```

## .ssh 生成
- [https://help.github.com/en/articles/connecting-to-github-with-ssh](https://help.github.com/en/articles/connecting-to-github-with-ssh)

生成后用vscode打开公钥id_rsa.pub文件，把公钥中的文本复制到github中的ssh key，title随便起。
## .ssh 默认生成目录

```
C:\Users\计算机名\.ssh
```

我的.ssh目录位置
```
C:\Users\Computer\.ssh
```