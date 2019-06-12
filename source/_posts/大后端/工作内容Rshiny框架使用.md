---
title:  工作内容Rshiny框架使用
date: 2018-12-26 00:56:03
tags:
- Rshiny
category:
- 大后端
---



## shiny Server学习记录-网络计算
* [http://218.94.144.229:8098/NetworkEntropy/]( http://218.94.144.229:8098/NetworkEntropy/)  用户名 admin 密码 123qwe
* shiny api文档[http://shiny.rstudio.com/reference/shiny/latest/](http://shiny.rstudio.com/reference/shiny/latest/)
* shiny github [https://github.com/rstudio/shiny](https://github.com/rstudio/shiny)
* Shiny Server配置 https://blog.csdn.net/wendaomudong_l2d4/article/details/75105440
* R shiny基础教程 [https://blog.csdn.net/u014801157/article/category/5690387](https://blog.csdn.net/u014801157/article/category/5690387)
* windows下无法正常安装某个类库时,Windows 下R软件如何安装GO.db程序包[https://blog.csdn.net/hhl_csdn/article/details/51933673?tdsourcetag=s_pctim_aiomsg](https://blog.csdn.net/hhl_csdn/article/details/51933673?tdsourcetag=s_pctim_aiomsg)



* 内网是在浏览器下输入 http://:3838/APP_NAME/即可 


一些重要的命令

### 先复制shiny包自带样例到目录下
~~~
cp -r /usr/lib64/R/library/shiny/examples/* /srv/shiny-server/   
~~~

shiny server 服务设置状态
~~~
#查看状态
sudo systemctl status shiny-server
#开启
sudo systemctl start shiny-server
#停止
sudo systemctl stop shiny-server
#重启
sudo systemctl restart shiny-server
~~~

1) 配置文件位置：/etc/shiny-server/shiny-server.conf 
2) 报错时查看日志[服务器运行日志] 
/var/log/shiny-server.log 
3) shiny运行日志[类似R的运行日志] 
/var/log/shiny-server


**当无法安装某些包时可使用下面的代码进行安装**：

~~~
source("http://bioconductor.org/biocLite.R")
biocLite("包名")
~~~


> R 3.3.3  R语言执行需要安装的程序包
> 
> 以管理员权限运行Rgui,并指定包安装的位置，防止安装到其他目录
~~~bash
.libPaths("C:/Program Files/R/R-3.3.3/library")
~~~

~~~
install.packages('pillar')

install.packages("ClustOfVar")
install.packages("psych")
install.packages("GPArotation")
install.packages("stringr")
install.packages("readxl")
install.packages("ca")
## 这个包可能也不正常
install.packages("arulesViz")


## 这些包无法正常安装
install.packages("arules") 
install.packages("lavaan")
~~~


### 中医网络分析模块
~~~
    biocLite('GO.db')
    biocLite('org.Hs.eg.db')
    biocLite('clusterProfiler')

    biocLite('WGCNA')

    intsall.packages('WGCNA')
~~~



2018-12-26
可以不阻塞当前运行的程序
* shiny 异步 编程 [https://rstudio.github.io/promises/articles/intro.html](https://rstudio.github.io/promises/articles/intro.html)

