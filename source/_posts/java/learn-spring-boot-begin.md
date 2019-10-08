---
title: 学习spring-boot
date: 2019-08-26 11:09:07
tags:
- spring-boot
category:
- Java
---

## springboot 

- annotation注解

1. @RestController=@Controller+@ResponseBody是在RESTful Web服务中，基于sprinboot 2.0首选方法。

<!-- more -->
## 多环境配置
在spring-boot中使用多环境配置，可自已定义application-{name}.properties
- 生产环境（application-prod.properties）
- 开发环境（application-dev.properties）

在application.properties文件中指定此值为
spring.profiles.active=dev,则会加载application-dev.properties文件中的配置项。
在发布和本地运行测试时，只需要修改此值即可。

更佳的方式，将此值设置为一个变量spring.profiles.active=@profiles.active@

pom.xml中配置如下
```
<!-- 在maven中添加如下配置 -->
<profiles>
    <profile>
        <!-- 测试环境 -->
        <id>dev</id>
        <properties>
            <profiles.active>dev</profiles.active>
        </properties>
    </profile>
    <profile>
        <!-- 生产环境 -->
        <id>prod</id>
        <properties>
            <profiles.active>prod</profiles.active>
        </properties>
    </profile>
</profiles>
```
在控制台上,则可通过-P指定参数，此prod与<id>prod</id>相同，
```
mvn clean package -Pprod 
```

## 将spring-boot 项目 部署至ubuntu上
- 安装jdk8，并验证安装是否正常
```
root@ubuntu:/home/java# sudo apt-get install openjdk-8-jdk  
root@ubuntu:/home/java# java -version
openjdk version "1.8.0_222"
OpenJDK Runtime Environment (build 1.8.0_222-8u222-b10-1ubuntu1~16.04.1-b10)
OpenJDK 64-Bit Server VM (build 25.222-b10, mixed mode)
```

以生产环境生成jar包
1. -Pprod 指定pom.xml文件中的profiles.active的值为prod，即prod
2. -Dmaven.test.skip=true 排除测试代码后进行打包
```
mvn clean package -Pprod -Dmaven.test.skip=true
```

使用xftp上传.jar压缩名
- 部署运行命令
```
nohup java -jar secrets-0.0.1-SNAPSHOT.jar &
```

- 查看日志
```
tail -500f nohup.out
```

第二次发布时，需要先杀死上次运行的进程
```
a.捕获上一个版本程序的进程 ps -ef|grep secrets-0.0.1-SNAPSHOT.jar

b.杀死对应的进程 kill+进程号

c.启动程序 nohup java -jar secrets-0.0.1-SNAPSHOT.jar &

d.退出 ctrl + c

e.查看日志 tail -500f nohup.out
```

## 拦截器中判断控制器中是否包含某个注解

用于在控制器及方法是否需要登录

UserLoginToken可用于方法、控制器上

```
@Target({ElementType.METHOD, ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
public @interface UserLoginToken {
    boolean required() default true;
}
```

```

public class AuthenticationInterceptor implements HandlerInterceptor {
    @Override
    public boolean preHandle(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Object object) throws Exception {
        // 如果不是映射到方法直接通过
        if(!(object instanceof HandlerMethod)){
            return true;
        }
        HandlerMethod handlerMethod=(HandlerMethod)object;
        Method method=handlerMethod.getMethod();

        //检查有没有需要登录的注解
        if (method.getDeclaringClass().isAnnotationPresent(UserLoginToken.class)||method.isAnnotationPresent(UserLoginToken.class)) {
            UserLoginToken userLoginToken = method.getAnnotation(UserLoginToken.class);
            UserLoginToken classLoginToken=method.getDeclaringClass().getAnnotation(UserLoginToken.class);

            if ((userLoginToken!=null&&userLoginToken.required())||(classLoginToken!=null&&classLoginToken.required())) {
               
                return true;
            }
        }
        return true;
    }
}
```

验证此方法上的控制器是否包含UserLoginToken注解，
```
method.getDeclaringClass().isAnnotationPresent(UserLoginToken.class)
```
验证此方法上是否包含UserLoginToken注解
```
method.isAnnotationPresent(UserLoginToken.class)
```

此控制器下的方法都需要登录
```
@UserLoginToken
@RestController
@RequestMapping("/safebox")
public class SafeBoxController {
    @Autowired
    private SafeBoxRepository safeBoxRepository;
    @Autowired
    protected Mapper dozerMapper;

    @GetMapping
    public List<SafeBox> getSafeBoxs(String title,String userName,@CurrentUserAnno CurrentUser user){
        int addUserId=user.getId();
        return safeBoxRepository.selectSafeBoxs(addUserId,title,userName);
    }
    。。。其他方法
}
```


## 参考资料

- [SpringMVC拦截器中获得Controller方法名和注解信息（用于验证权限）](https://blog.csdn.net/howroad/article/details/80220320)
- [IntelliJ IDEA 无法热加载自动更新](https://blog.csdn.net/t0404/article/details/80449716