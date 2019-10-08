---
title: FreeSql配合仓储实现软删除
date: 2019-10-6 12:43:22
tags:
- FreeSql
category:
- 重新出发
---

## FreeSql
> 前段时间使用FreeSql作为ORM，写了一个简单的CMS，在这里总结一下其中的使用心得。

<!-- more -->

### 仓储配合全局过滤器
#### 1. 统一的删除标志
如：数据库字段 bool IsDeleted,代表删除标志。

需要配合仓储可实现，统一的删除标志，不需要加where(r=>r.deleted==false)，取数据时，自动过滤数据。

接口 ISoftDeleteAduitEntity.cs
```
    public interface ISoftDeleteAduitEntity
    {
        bool IsDeleted { get; set; }
        long? DeleteUserId { get; set; }
        DateTime? DeleteTime { get; set; }
    }

```

ConfigureServices通过配置服务，增加全局过滤器，第二个参数,可指定仓储所在的程序集（一个dll,一个项目就是一个程序集（一般一个解决方案下有多个项目，如果仓储写在多个地方，我们可以，把要扫描的程序集写在第二个参数上。））
```
services.AddFreeRepository(filter =>
{
    filter.Apply<ISoftDeleteAduitEntity>("SoftDelete", a => a.IsDeleted == false);
}, GetType().Assembly, typeof(AuditBaseRepository<>).Assembly);
```

GetType().Assembly 当前项目所在程序集。
typeof(AuditBaseRepository<>).Assembly，为AuditBaseRepository<T>所在程序集，（LinCms.Zero.dll）

#### 2.统一的删除时间，删除人

上文，关于配置删除标志，我们注入其提供好的仓储，会过滤掉isdeleted属性为true的值。

```
  public class UserService : IUserSevice
    {
        private readonly BaseRepository<LinUser> _userRepository;
        public UserService(BaseRepository<LinUser> userRepository)
        {
            _userRepository = userRepository;
        }

        public List<LinUser> GetUserList()
        {
            List<LinUser> users = _userRepository.Select.ToList();
            return users;
        }
}
```

那么，我们删除一个用户时，怎么增加删除时间，删除人呢。

```
public void Delete(int id)
{
    _userRepository.Delete(r => r.Id == id);
}
```
这样能删除，但删除人，删除时间并没有加上去。


这里我们注入AuditBaseRepository<LinUser>，重写父类Delete方法。
```
private readonly AuditBaseRepository<LinUser> _userRepository;
public UserService(AuditBaseRepository<LinUser> userRepository)
{
    _userRepository = userRepository;
}

public void Delete(int id)
{
    _userRepository.Delete(r => r.Id == id);
}

```

由于父类并非Virtual类型，这里通过new关键字重写 int Delete(Expression<Func<T, bool>> predicate)方法
```
public new int Delete(Expression<Func<T, bool>> predicate)
{
    if (typeof(ISoftDeleteAduitEntity).IsAssignableFrom(typeof(T)))
    {
        List<T> items = Orm.Select<T>().Where(predicate).ToList();
        return Orm.Update<T>(items)
            .Set(a => (a as ISoftDeleteAduitEntity).IsDeleted, true)
            .Set(a => (a as ISoftDeleteAduitEntity).DeleteUserId, _currentUser.Id)
            .Set(a => (a as ISoftDeleteAduitEntity).DeleteTime, DateTime.Now)
            .ExecuteAffrows();
    }

    return base.Delete(predicate);
}

```
全部重写删除操作，请参考[https://github.com/luoyunchong/lin-cms-dotnetcore/blob/master/src/LinCms.Zero/Repositories/AuditBaseRepository.cs](https://github.com/luoyunchong/lin-cms-dotnetcore/blob/master/src/LinCms.Zero/Repositories/AuditBaseRepository.cs)
这样固然能实现，但好像包含大量as，IsAssignableFrom（判断T是否继承了ISoftDeleteAduitEntity).