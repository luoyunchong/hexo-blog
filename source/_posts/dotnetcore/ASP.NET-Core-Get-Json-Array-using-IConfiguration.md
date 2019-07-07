---
title: ASP.NET-Core-Get-Json-Array-using-IConfiguration
date: 2019-07-07 21:09:07
tags:
- ASP.NET Core
category:
- .NET Core
---
### ASP .NET Core Get Json Array using IConfiguration

In appsettings.json

```
{
      "MyArray": [
          "str1",
          "str2",
          "str3"
      ]
}
```

In Startup.cs


```
public void ConfigureServices(IServiceCollection services)
{
     services.AddSingleton<IConfiguration>(Configuration);
}
```

In HomeController


```
public class HomeController : Controller
{
    private readonly IConfiguration _config;
    public HomeController(IConfiguration config)
    {
        this._config = config;
    }

    public IActionResult Index()
    {
        return Json(_config.GetSection("MyArray").AsEnumerable());
    }
}
```


If you want to pick value of first item then you should do like this

```
var item0 = _config.GetSection("MyArray:0");
```

If you want to pick value of entire array then you should do like this-
```
IConfigurationSection myArraySection = _config.GetSection("MyArray");
var itemArray = myArraySection.AsEnumerable();
```

or  like 
```
var myArray = _config.GetSection("MyArray").Get<string[]>();
```


### 相关链接
* https://stackoverflow.com/questions/41329108/asp-net-core-get-json-array-using-iconfiguration
* Options pattern in ASP .NET Core https://docs.microsoft.com/en-us/aspnet/core/fundamentals/configuration/options?view=aspnetcore-2.1