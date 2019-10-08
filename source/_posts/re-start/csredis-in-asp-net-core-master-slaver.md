---
title: csredis-in-asp.net core理论实战-主从配置、哨兵模式
date: 2019-07-06 21:09:07
tags:
- Redis
- ASP.NET Core
category:
- .NET Core
---

# csredis     
- GitHub  https://github.com/2881099/csredis

看了github上的开源项目,上面真的只是单纯的使用文档，可能对于我这种人（菜鸟）就不太友好，

我知道他对标的是ServiceStack.Redis， 一开始csredis只支持. net 版本，但原作者没有继续维护，作者使用 . net core重写后，逐渐演化的一个. net core 版本的redis 驱动，

使用这个类库可以方便的地在 c#中访问redis数据库，官方介绍 
## 低门槛、高性能，和分区高级玩法的redis-cli SDK；

我呢，就照着官方文档写一些示例，大佬就别看了，只是集成方案与学习笔记。

- https://github.com/luoyunchong/dotnetcore-examples/blob/master/dotnet-core-redis/

<!-- more -->

在学习之前，看到README.md上的内容不免陷入沉思，好多关键字我都不懂是什么意思，所以还是从理论入手，搜索资料，整合出入门资料，往后再讲在asp .net core中集成与使用的示例。


## 哨兵模式
 * Redis哨兵（Sentinel）模式 https://www.jianshu.com/p/06ab9daf921d 

**先在本地搭建好主从redis服务，我本地win10，已安装好一个redis,部署在6379端口上、先把这些文档看看。**

### 下载
windows安装绿色版Redis 
- https://blog.csdn.net/ml863606/article/details/87456239

## 主从配置(Windows版)
本地Redis主从配置(Windows版)，从github上下载zip压缩包，解压后，复制二份文件夹至某一目录，配置二个从Redis服务器，可参考如下
- https://www.cnblogs.com/cang12138/p/9132288.html#_label0

### 简单教程
D:\services\Redis-x64-3.2.100目录 其实有 “Windows Service Documentation.docx ”，上面说的很清楚，这里只说最简单的配置多个服务的方式，使用文本编辑器打开redis.windows-service.conf文件，可修改启用端口。
```
port 6380
```
cmd 到D:\services\Redis-x64-3.2.100-1，一定要管理员运行
```
#安装服务
redis-server --service-install redis.windows-service.conf  --service-name redis6380
#开启服务
net start redis6380  
```
如果无法开启服务redis6380，就删除此服务，再次执行，见下方参考命令 删除服务。

本地安装成了三个reids,他们运行在不同的端口，三个哨兵。
服务类型 | IP|port
---|---|---
master Redis服务|localhost|6379
slave Redis服务器 |localhost|6380
slave Redis服务器 |localhost|6381
sentinel|localhost|26381
sentinel|localhost|26379
sentinel|localhost|26380

```
slaveof $host $port 作用是设置主从库，在redis-cli命令中执行，即可将此redis设置为host下port端口的从库，$开头的为参数 

slaveof no one #取消同步

也可在windows-server.conf文件中配置
```

6379那个redis是使用msi安装包安装的，所以redis-cli是可以在任意文件夹位置执行的，如未配置，请在D:\service\Redis-x64-3.2.100-1目录下执行这些命令。

```
C:\Users\Computer>redis-cli -p 6380
127.0.0.1:6381> slaveof 127.0.0.1 6379
OK
ctrl+c退出命令行状态。
C:\Users\Computer>redis-cli -p 6381
127.0.0.1:6381> slaveof 127.0.0.1 6379
OK
```

另开一个终端 
```
C:\Users\Computer>redis-cli -p 6379
127.0.0.1:6379> set a 1233
OK
127.0.0.1:6379> get a
"1233"
```

原本的终端得到a的值是"1233"，已经被同步过来了。
```
127.0.0.1:6381> get a
"1233"
```

### 参考命令

右击电脑 ->管理->服务和应用程序 ->服务->可选择服务名进行管理。
~~~
#开启服务
net start redis6380  
#关闭服务
net stop redis6380  
#删除服务：当服务不正常时可根据名称删除
sc delete redis6380  
~~~
以管理员权限cmd到目录D:\services\Redis-x64-3.2.100中，可使用如下命令。
* Installing the Service：--service-install
```
redis-server --service-install redis.windows-service.conf --loglevel verbose
redis-server --service-install redis.windows.conf  --service-name redis6380
```
* Uninstalling the Service：--service-uninstall
```
redis-server --service-uninstall
```
* Starting the Service:--service-start
```
redis-server --service-start
```
* Stopping the Service:--service-stop
```
redis-server --service-stop
```
* Naming the Service: --service-name name
```
redis-server --service-install --service-name redisService1 --port 10001
```
* set port :--port 10001

查看redis 版本、redis-cli版本
```
PS D:\service\Redis-x64-3.2.100-1> redis-server -v
Redis server v=3.2.100 sha=00000000:0 malloc=jemalloc-3.6.0 bits=64 build=dd26f1f93c5130ee
PS D:\service\Redis-x64-3.2.100-1> redis-cli -v
redis-cli 3.2.100
```

### 哨兵配置
哨兵模式是Redis提供的一个命令，独立进程，独立运行，哨兵的作用是为了实现对redis服务器状态的监控，保证服务的可用性，实现故障切换，无须人为干预。

1.配置项

这个是通过 .msi文件安装的redis，与.zip解压后启动的服务无区别。打开E:\Program Files\Redis\sentinel.conf，没有就创建此文件，另外二个redis，只用改port对应的值，改成26739、26740，配置内容如下：
```conf
#当前Sentinel服务运行的端口
port 26381
# 3s内mymaster无响应，则认为mymaster宕机了
sentinel monitor mymaster 127.0.0.1 6379 2
#如果10秒后,mysater仍没启动过来，则启动failover
sentinel down-after-milliseconds mymaster 3000
# 执行故障转移时， 最多有1个从服务器同时对新的主服务器进行同步
sentinel failover-timeout mymaster 10000
```

**配置监听的主服务器，这里sentinel monitor代表监控，mymaster代表服务器的名称，可以自定义，127.0.0.1代表监控的主服务器，6379代表端口，2代表只有两个或两个以上的哨兵认为主服务器不可用的时候，才会进行failover操作。**

2. 启动哨兵

前提redis服务已启动。
```PowerShell
PS E:\Program Files\Redis> .\redis-server.exe .\sentinel.conf --sentinel
                _._                                                  
           _.-``__ ''-._                                             
      _.-``    `.  `_.  ''-._           Redis 3.2.100 (00000000/0) 64 bit
  .-`` .-```.  ```\/    _.,_ ''-._                                   
 (    '      ,       .-`  | `,    )     Running in sentinel mode
 |`-._`-...-` __...-.``-._|'` _.-'|     Port: 26381
 |    `-._   `._    /     _.-'    |     PID: 22452
  `-._    `-._  `-./  _.-'    _.-'                                   
 |`-._`-._    `-.__.-'    _.-'_.-'|                                  
 |    `-._`-._        _.-'_.-'    |           http://redis.io        
  `-._    `-._`-.__.-'_.-'    _.-'                                   
 |`-._`-._    `-.__.-'    _.-'_.-'|                                  
 |    `-._`-._        _.-'_.-'    |                                  
  `-._    `-._`-.__.-'_.-'    _.-'                                   
      `-._    `-.__.-'    _.-'                                       
          `-._        _.-'                                           
              `-.__.-'                                               

[22452] 07 Jul 11:47:00.111 # Sentinel ID is fc076362c0a5cc71d3c72f71c00a15b2726b2bf8
[22452] 07 Jul 11:47:00.111 # +monitor master mymaster 127.0.0.1 6379 quorum 2
[22452] 07 Jul 11:47:00.114 * +slave slave 127.0.0.1:6381 127.0.0.1 6381 @ mymaster 127.0.0.1 6379
```

因为windows下不支持守护进程(一种可在后台运行的程序)，这样命令行一关闭，哨兵也停止了（Windows does not support daemonize. Start Redis as service），在windows下叫服务（service）,是可以后台一直运行的。

3. 在windows下以服务的形式启动哨兵

管理员运行
```PowerShell
E:\Program Files\Redis>redis-server --service-install --service-name sentinel sentinel.conf --sentinel

D:\service\Redis-x64-3.2.100-1>redis-server --service-install --service-name sentinel-1 sentinel.conf --sentinel
[20700] 07 Jul 12:01:21.297 # Granting read/write access to 'NT AUTHORITY\NetworkService' on: "D:\service\Redis-x64-3.2.100-1" "D:\service\Redis-x64-3.2.100-1\"
[20700] 07 Jul 12:01:21.300 # Redis successfully installed as a service.

D:\service\Redis-x64-3.2.100-2>redis-server --service-install --service-name sentinel-2 sentinel.conf --sentinel
[15772] 07 Jul 12:01:33.942 # Granting read/write access to 'NT AUTHORITY\NetworkService' on: "D:\service\Redis-x64-3.2.100-2" "D:\service\Redis-x64-3.2.100-2\"
[15772] 07 Jul 12:01:33.944 # Redis successfully installed as a service.
```

此时D:\\service\\Redis-x64-3.2.100-1\\sentinel.conf，哨兵运行在26379端口 ,生成哨兵ID（Sentinel ID）
```
sentinel myid a2e75eedaf161357fe03df490a14b4158ad3ba88
```

也生成了如下内容，能监控到从slave服务6380的redis、slave6381的redis,也能监控到其他的哨兵，分别运行在26380、26381端口
```
# Generated by CONFIG REWRITE
dir "D:\\service\\Redis-x64-3.2.100-1"
sentinel config-epoch mymaster 0
sentinel leader-epoch mymaster 0
sentinel known-slave mymaster 127.0.0.1 6380
sentinel known-slave mymaster 127.0.0.1 6381
sentinel known-sentinel mymaster 127.0.0.1 26380 a2e75eedaf161357fe03df490a14b4158ad3ba88
sentinel known-sentinel mymaster 127.0.0.1 26381 fc076362c0a5cc71d3c72f71c00a15b2726b2bf8
sentinel current-epoch 0

```

在主master redis中查看redis当前信息
```PS
PS E:\Program Files\Redis> redis-cli -p 6379
127.0.0.1:6379> info replication
# Replication
role:master
connected_slaves:2
slave0:ip=127.0.0.1,port=6381,state=online,offset=141627,lag=1
slave1:ip=127.0.0.1,port=6380,state=online,offset=141627,lag=0
...
```

ctrl+c退出，查看redis6380信息
```
PS E:\Program Files\Redis> redis-cli -p 6380
127.0.0.1:6380> info replication
# Replication
role:slave
master_host:127.0.0.1
master_port:6379
master_link_status:up
master_last_io_seconds_ago:1
master_sync_in_progress:0
slave_repl_offset:161451
slave_priority:100
slave_read_only:1
connected_slaves:0
...
```
### 高可用测试

#### 1.主服务器Master 挂掉
停止 6379服务
```
C:\WINDOWS\system32>redis-cli -p 6379
127.0.0.1:6379> shutdown
not connected> 
或
C:\WINDOWS\system32>net stop redis
```

6379中sentinel_log.log,可见，当6379redis服务挂 了后，此日志表明，redis在failover后错误重试，switch-master切换为6380

```log
[240] 07 Jul 12:16:15.015 # +sdown master mymaster 127.0.0.1 6379
[240] 07 Jul 12:16:15.086 # +odown master mymaster 127.0.0.1 6379 #quorum 2/2
[240] 07 Jul 12:16:15.086 # +new-epoch 1
[240] 07 Jul 12:16:15.086 # +try-failover master mymaster 127.0.0.1 6379
[240] 07 Jul 12:16:15.088 # +vote-for-leader 207bd9abfe9283e32b6e0de3635e126bfdbba3b4 1
[240] 07 Jul 12:16:15.090 # a2e75eedaf161357fe03df490a14b4158ad3ba88 voted for 207bd9abfe9283e32b6e0de3635e126bfdbba3b4 1
[240] 07 Jul 12:16:15.091 # 14c6428bae2afc1d92b5159b0788dbba753ee85b voted for 207bd9abfe9283e32b6e0de3635e126bfdbba3b4 1
[240] 07 Jul 12:16:15.188 # +elected-leader master mymaster 127.0.0.1 6379
[240] 07 Jul 12:16:15.188 # +failover-state-select-slave master mymaster 127.0.0.1 6379
[240] 07 Jul 12:16:15.255 # +selected-slave slave 127.0.0.1:6380 127.0.0.1 6380 @ mymaster 127.0.0.1 6379
[240] 07 Jul 12:16:15.255 * +failover-state-send-slaveof-noone slave 127.0.0.1:6380 127.0.0.1 6380 @ mymaster 127.0.0.1 6379
[240] 07 Jul 12:16:15.338 * +failover-state-wait-promotion slave 127.0.0.1:6380 127.0.0.1 6380 @ mymaster 127.0.0.1 6379
[240] 07 Jul 12:16:15.718 # +promoted-slave slave 127.0.0.1:6380 127.0.0.1 6380 @ mymaster 127.0.0.1 6379
[240] 07 Jul 12:16:15.718 # +failover-state-reconf-slaves master mymaster 127.0.0.1 6379
[240] 07 Jul 12:16:15.800 * +slave-reconf-sent slave 127.0.0.1:6381 127.0.0.1 6381 @ mymaster 127.0.0.1 6379
[240] 07 Jul 12:16:16.217 # -odown master mymaster 127.0.0.1 6379
[240] 07 Jul 12:16:16.757 * +slave-reconf-inprog slave 127.0.0.1:6381 127.0.0.1 6381 @ mymaster 127.0.0.1 6379
[240] 07 Jul 12:16:16.758 * +slave-reconf-done slave 127.0.0.1:6381 127.0.0.1 6381 @ mymaster 127.0.0.1 6379
[240] 07 Jul 12:16:16.834 # +failover-end master mymaster 127.0.0.1 6379
[240] 07 Jul 12:16:16.834 # +switch-master mymaster 127.0.0.1 6379 127.0.0.1 6380
[240] 07 Jul 12:16:16.835 * +slave slave 127.0.0.1:6381 127.0.0.1 6381 @ mymaster 127.0.0.1 6380
[240] 07 Jul 12:16:16.835 * +slave slave 127.0.0.1:6379 127.0.0.1 6379 @ mymaster 127.0.0.1 6380
[240] 07 Jul 12:16:19.853 # +sdown slave 127.0.0.1:6379 127.0.0.1 6379 @ mymaster 127.0.0.1 6380
```

6380redis 服务 日志,当6379服务挂了后，6380成为主节点，其他节点(6379、6381)成为从节点，此时打开D:\service\Redis-x64-3.2.100-1\redis.windows-service.conf，之前配置的slaveof 127.0.0.1 6379已经没有了。
```
[9404] 07 Jul 12:16:15.037 # +sdown master mymaster 127.0.0.1 6379
[9404] 07 Jul 12:16:15.089 # +new-epoch 1
[9404] 07 Jul 12:16:15.090 # +vote-for-leader 207bd9abfe9283e32b6e0de3635e126bfdbba3b4 1
[9404] 07 Jul 12:16:15.104 # +odown master mymaster 127.0.0.1 6379 #quorum 3/2
[9404] 07 Jul 12:16:15.104 # Next failover delay: I will not start a failover before Sun Jul 07 12:16:35 2019
[9404] 07 Jul 12:16:15.801 # +config-update-from sentinel 207bd9abfe9283e32b6e0de3635e126bfdbba3b4 127.0.0.1 26381 @ mymaster 127.0.0.1 6379
[9404] 07 Jul 12:16:15.801 # +switch-master mymaster 127.0.0.1 6379 127.0.0.1 6380
[9404] 07 Jul 12:16:15.802 * +slave slave 127.0.0.1:6381 127.0.0.1 6381 @ mymaster 127.0.0.1 6380
[9404] 07 Jul 12:16:15.802 * +slave slave 127.0.0.1:6379 127.0.0.1 6379 @ mymaster 127.0.0.1 6380
[9404] 07 Jul 12:16:18.812 # +sdown slave 127.0.0.1:6379 127.0.0.1 6379 @ mymaster 127.0.0.1 6380
```

此时查看 6380的信息,可以看到此时只有一个slave在线,其配置为127.0.0.1的6381端口，
```
redis-cli -p 6380
127.0.0.1:6380> info replication
role:master
connected_slaves:1
slave0:ip=127.0.0.1,port=6381,state=online,offset=119281,lag=1
master_repl_offset:119547
...
```
#### 2.6379服务再次启动

当6379的服务启动后，6379的服务将成为6380的从服务器slave，再次通过 redis-cli -p 端口， 输入 info replication查看对应服务的节点信息
```
PS E:\Program Files\Redis> redis-server --service-start
或
C:\WINDOWS\system32>net start redis

PS E:\Program Files\Redis> redis-cli -p 6380
127.0.0.1:6380> info replication
# Replication
role:master
connected_slaves:2
slave0:ip=127.0.0.1,port=6379,state=online,offset=339593,lag=1
slave1:ip=127.0.0.1,port=6381,state=online,offset=339593,lag=1
...
```

#### 3.slave 6381关闭
此时查看6380的info，可见此时只有一个从节点6379
```
C:\WINDOWS\system32>net stop redis6381
role:master
connected_slaves:1

PS E:\Program Files\Redis> redis-cli -p 6380
127.0.0.1:6380> info replication
role:master
connected_slaves:1
slave0:ip=127.0.0.1,port=6379,state=online,offset=329392,lag=1
master_repl_offset:329525
...
```


### 相关链接
 <!--* Redis哨兵（Sentinel）模式 https://www.jianshu.com/p/06ab9daf921d -->
 <!--* windows安装绿色版Redis - https://blog.csdn.net/ml863606/article/details/87456239-->
 <!--* 主从配置(Windows版) https://www.cnblogs.com/cang12138/p/9132288.html#_label0-->
 <!--* csredis https://github.com/2881099/csredis-->
 * Cross-platform GUI management tool for Redis https://github.com/uglide/RedisDesktopManager
 * Redis in Windows的3.x版本  https://github.com/MicrosoftArchive/redis
 * Redis in Windows的4.x版本 https://github.com/tporadowski/redis
 * Redis in linux https://github.com/antirez/redis
 * Redis高可用集群-哨兵模式（Redis-Sentinel）搭建配置教程【Windows环境】 https://aflyun.blog.csdn.net/article/details/79430105
 
### linux版Redis主从搭建
建议大家看这个文章，我一开始参考了其他的，写完windows版，才看到这个链接，关于**深入剖析Redis系列**
* https://juejin.im/post/5b76e732f265da4376203849