---
title: csredis-in-asp.net core理论实战-使用示例
date: 2019-07-07 21:09:07
tags:
- Redis
- ASP.NET Core
category:
- 重新出发
---

## csredis GitHub
* https://github.com/2881099/csredis
## 示例源码
https://github.com/luoyunchong/dotnetcore-examples/tree/master/dotnet-core-redis
## 前提
* 安装并配置好redis服务，可用。
* vs2017或vs2019或vscode
* .net core 2.2+ sdk

创建一个. NET Core WebAPI项目

想执行 . NET Core CLI命令行，要cd到csproj同级目录中
```
dotnet add package CSRedisCore
#mvc分布式缓存注入
dotnet add package Caching.CSRedis
```
或
程序包管理控制台(Package Manager)中运行，选择你的项目
```
Install-Package CSRedisCore
Install-Package Caching.CSRedis
```

### 普通模式
1. appsettings.json配置项

```
{
  "CsRedisConfig": {
    "DefaultConnectString": "127.0.0.1:6379,password=,defaultDatabase=0,prefix=csredis-default-"
  }
}
```

2. Startup.cs中配置如下
```
public void ConfigureServices(IServiceCollection services)
{
    // eg 1.单个redis实现 普通模式
    //CSRedisClient csredis = new CSRedisClient("127.0.0.1:6379,password=,defaultDatabase=csredis,prefix=csredis-example");
   //eg 2.单个redis，使用appsettings.json中的配置项
    IConfigurationSection configurationSection = Configuration.GetSection("CsRedisConfig:DefaultConnectString");
    CSRedisClient csredis = new CSRedisClient(configurationSection.Value);

    //初始化 RedisHelper
    RedisHelper.Initialization(csredis);
    //注册mvc分布式缓存
    services.AddSingleton<IDistributedCache>(new CSRedisCache(RedisHelper.Instance));

    ...其他代码
   
}
```
3. ValuesController.cs

通过静态方法调用，键为test1 ,value为前台传来的值，缓存60s

获取值Get方法， test1作为键，返回值给前台。60s后再获取，将无法得到值。
```
// POST api/values
[HttpPost]
public void Post([FromBody] string value)
{
    RedisHelper.Set("test1", value, 60);
}

// GET api/values
[HttpGet]
public ActionResult<string> Get()
{
    return RedisHelper.Get("test1");
}

```
### 普通模式-控制台
```
   class Program
    {
        static void Main(string[] args)
        {
            var csredis = new CSRedis.CSRedisClient("127.0.0.1:6379,password=,defaultDatabase=CsRedis,prefix=CsRedis_ConSole_Example");
            RedisHelper.Initialization(csredis);

            RedisHelper.Set("test1", "123123", 60);
            string result = RedisHelper.Get("test1");
            Console.WriteLine("key:test1,value:" + result);

            Console.ReadKey();
        }
    }
```

### 哨兵模式
前提
* 了解哨兵模式的作用
* 并有一个可用的主（master）redis服务,二个从（slaver）服务，有三个哨兵监控。

1. appsettings.json配置项
```
{
  "CsRedisConfig": {
    "SentinelConnectString": "mymaster,password=,prefix=csredis-example-",
    "Sentinel": [
      "127.0.0.1:26379",
      "127.0.0.1:26380",
      "127.0.0.1:26381"
    ]
  }
}

```
2. Startup.cs中配置如下
```
public void ConfigureServices(IServiceCollection services)
{
    //eg.3 使用appsettings.json,哨兵模式
    IConfigurationSection configurationSection = Configuration.GetSection("CsRedisConfig:SentinelConnectString");

    string[] sentinelValues = Configuration.GetSection("CsRedisConfig:Sentinel").Get<string[]>();

    CSRedisClient csredis = new CSRedisClient(configurationSection.Value, sentinelValues);

    //初始化 RedisHelper
    RedisHelper.Initialization(csredis);
    //注册mvc分布式缓存
    services.AddSingleton<IDistributedCache>(new CSRedisCache(RedisHelper.Instance));

    ...其他代码
}

```
3. 使用缓存时与普通模式相同，不过关闭某一个redis服务，服务依旧可用，不过如果redis处于切换cluster过程，将会有短暂的失败，不过一会就会恢复。    


## 相关文章
* .NET Core开发者的福音之玩转Redis的又一傻瓜式神器推荐 https://www.cnblogs.com/yilezhu/p/9947905.html
* 【由浅至深】redis 实现发布订阅的几种方式 https://www.cnblogs.com/kellynic/p/9952386.html
* 深入剖析Redis系列(四) - Redis数据结构与全局命令概述 https://juejin.im/post/5bb01064e51d453eb93d8028

RedisHelper 与redis-cli命令行保持一致的api，会使用redis相关命令，即会使用RedisHelper方法


### 配合redis-cli命令行
```
  static void Main()
    {
        CSRedisClient csredis = new CSRedisClient("127.0.0.1:6379,password=,defaultDatabase=CsRedis,prefix=CsRedis_ConSole_Example");
        RedisHelper.Initialization(csredis);
    
        Test();
        Console.ReadKey();
    }

    static void Test()
    {
     //1.set key value [ex seconds] [px milliseconds] [nx|xx]
    //setex key seconds value #设定键的值，并指定此键值对应的 有效时间。
    //setnx key value  #键必须 不存在，才可以设置成功。如果键已经存在，返回 0。
    RedisHelper.Set("redis-key", "just a string value", 50);//setex "redis-key" 50 "just a string value"

    RedisHelper.Set("redis-key-class",DateTime.Now, 30);

    //1.1.2. 获取值
    //get key
    //如果要获取的 键不存在，则返回 nil（空）。
    string redisValue = RedisHelper.Get("redis-key");
    Console.WriteLine($"setex redis-key 50 just a string value ,RedisHelper.Get()得到值如下：{redisValue}");
    DateTime now = RedisHelper.Get<DateTime>("redis-key-class");
    Console.WriteLine($"setex redis-key-class DateTime.Now,RedisHelper.Get()值如下{now}");

    //1.1.3. 批量设置值
    //mset key value [key value ...]
    RedisHelper.MSet("a", "1", "b", "2", "c", "3","d","4");//等价于mset a 1 b 2 c 3 d 4


    //1.1.4. 批量获取值
    //mget key [key ...]

    string[] mgetValues = RedisHelper.MGet<string>("a", "b", "c","d");
    Console.WriteLine($"mset a 1 b 2 c 3 d 4, RedisHelper.MGet()得到的值是");
    foreach (var mgetValue in mgetValues)
    {
        Console.Write($"{mgetValue}、");
    }
    Console.WriteLine();

    //1.1.5. 计数
    //incr key
    //incr 命令用于对值做 自增操作

    //自增指定数字
    long incr = RedisHelper.IncrBy("key");
    Console.WriteLine($"incr key, incr得到的值是{incr}");
    //设置自增数字的增量值
    incr = RedisHelper.IncrBy("key",2);
    Console.WriteLine($"再次incrby key 2, incr得到的值是{incr}");

    incr = RedisHelper.IncrBy("key", -2);
    Console.WriteLine($"再次decrby key -2, incr得到的值是{incr}");

    //exists key
    bool isExistsKey = RedisHelper.Exists("new-key");
    Console.WriteLine($"exists key ,value：{isExistsKey}");

    double incrByFloat=RedisHelper.IncrByFloat("key-float", 0.1);
    Console.WriteLine($"incrbyfloat key-float 0.1,value：{incrByFloat}");
    }
```