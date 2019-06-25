---
title: MySQL学习记录
date: 2018-12-02 23:21:22
description: Mysql8.0+使用Navicat Premium 12连接2059错误，通过修改密码规则即可。Docker下的MySQL容器化，根据父菜单id得到所有的子节点，MySQL新建存储过程，ABP中调用存储过程
tags:
- MySQL
- ABP
category:
- MySQL
---



Navicat Premium 12连接MySQL8+时出现2059错误解决方法
~~~
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password';
~~~

##### 上面那行以mysql_native_password的加密规则更新了用户的密码 

password 对应的字符串改成你原本的密码就行了。具体原因就是如上个博客所说，mysql8.0版本以后的密码规则有变更，旧的连接工具必须升级新的驱动才可解决此问题，但，升级后，就要提示只有14天使用权限。所以，将加密规则改成mysql_native_password 即可。
- [Navicat Premium 12连接MySQL8.0出现2059错误](https://blog.csdn.net/qq_29932025/article/details/80045716)

- [ubuntu16.04 安装mysql5.7并设置root远程访问](https://www.jianshu.com/p/73fb45b9da73)

- [Docker最全教程之MySQL容器化 （二十五）](https://mp.weixin.qq.com/s?__biz=MzU0Mzk1OTU2Mg==&mid=2247484623&idx=1&sn=b235bb5222ea3391f66f0be0812df49c&chksm=fb023baacc75b2bc8d45b81b9b99a3343ebc877802840a3963d14fc49ae0eda98651f1a9f86e&mpshare=1&scene=23&srcid=06101AKYKpn48TwJXL7VLQ17#rd)



### 根据父菜单id得到所有的子节点 
MYSQL写法 
```
select id from (
              select t1.id,
              if(find_in_set(parentId, @pids) > 0, @pids := concat(@pids, ',', id), 0) as ischild
              from (
                   select id,parentId from re_menu t where t.status = 1 order by parentId, id
                  ) t1,
                  (select @pids := 要查询的菜单节点 id) t2
             ) t3 where ischild != 0

```


由于@符号与参数冲突，使用存储过程解决
```
CREATE DEFINER=`root`@`localhost` PROCEDURE `OrganizationChildrens`(IN `pid` BIGINT)
BEGIN
 select Id,ParentId,DisplayName as Text from (
              select t1.id,t1.ParentId,t1.DisplayName,
              if(find_in_set(parentId, @pids) > 0, @pids := concat(@pids, ',', id), 0) as ischild
              from (
                   select Id,ParentId,DisplayName from AbpOrganizationUnits t where t.IsDeleted = '0' order by ParentId, id
                  ) t1,
                  (select @pids :=pid) t2
             ) t3 where ischild != 0; 
END
```

ABP框架中调用存储过程
```
        public List<TreeSelectModel> GetChildrens(long? pid)
        {
            string sql = $"call OrganizationChildrens({pid})";

            return _orginazationDapperRepository.Query<TreeSelectModel>(sql).ToList();
        }
```