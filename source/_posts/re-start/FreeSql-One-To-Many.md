---
title: FreeSql取多表数据
date: 2019-10-12 14:43:22
tags:
  - FreeSql
category:
  - 重新出发
---

## FreeSql 取多表数据

以文章随笔与分类为例。

1. 表结构
   部分字段如下，其他省略，为了展示一对多关联，一个分类下可以有多个文章。一个文章属于一个分类。
   <!-- more -->

#### blog_article （随笔表）

| 字段        | 类型          | 备注    |
| ----------- | ------------- | ------- |
| id          | int           |
| classify_id | int           | 分类 id |
| title       | varchar(50)   | 标题    |
| content     | varchar(4000) | 正文    |

#### blog_classify （随笔分类专栏）

| 字段         | 类型        | 备注   |
| ------------ | ----------- | ------ |
| id           | int         |
| ClassifyName | varchar(50) | 分类名 |

其中 FullAduitEntity，Entity，在[开源项目](https://github.com/luoyunchong/lin-cms-dotnetcore)中,可以自行搜索，其中就是 ABP 中的创建时间、是否删除等字段

#### Article.cs

```
  [Table(Name = "blog_article")]
    public class Article : FullAduitEntity
    {
        /// <summary>
        /// 文章所在分类专栏Id
        /// </summary>
        public int? ClassifyId { get; set; }

        public Classify Classify { get; set; }
        /// <summary>
        /// 标题
        /// </summary>
        [Column(DbType = "varchar(200)")]
        public string Title { get; set; }
        /// <summary>
        /// 正文
        /// </summary>
        [Column(DbType = "text")]
        public string Content { get; set; }
    }
```

#### Classify.cs

```
    [Table(Name = "blog_classify")]
   public class Classify:FullAduitEntity
    {
        public string ClassifyName { get; set; }
        public List<Article> Articles { get; set; }
    }
```

## 使用现有的导航属性

1. 属性 Classify 为 null

```
List<Article> articles1 = _articleRepository
                        .Select
                        .ToList();
```

2.属性 Classify 会有值
我们在前台取数据，也可以直接循环取 Classify 中的属性

```
List<Article>articles2=  _articleRepository
    .Select
    .Include(r => r.Classify)
    .ToList();
```

假如，后台有一些字段要想过滤掉，可使用 AutoMapper，传给前台使用 Dto,过滤创建时间，修改时间等审核日志

创建 ArticleDto

```
   public class ArticleDto : Entity
    {
        /// <summary>
        /// 类别Id
        /// </summary>
        public int? ClassifyId { get; set; }
        /// <summary>
        /// 类别名称
        /// </summary>
        public string ClassifyName { get; set; }
        public string Content { get; set; }
        public string Title { get; set; }
    }
```

3、配合 IMapper，转换为 ArticleDto

```
List<ArticleDto> articles3 = _articleRepository
            .Select
            .ToList(r=>new
            {
                r.Classify,
                Article=r
            }).Select(r=>
            {
                ArticleDto articleDto=_mapper.Map<ArticleDto>(r.Article);
                articleDto.ClassifyName = r.Classify.ClassifyName;
                return articleDto;
            }).ToList();
```

4. 同样是使用 IMapper 转换，但这里 Include 进去了，用法稍微有点区别。

文档介绍 Include"贪婪加载导航属性，如果查询中已经使用了 a.Parent.Parent 类似表达式，则可以无需此操作。。

这里说的查询使用了 a.Parent.Parent,是指上面的 3 中，ToList 中的

```
  .ToList(r=>new
        {
            r.Classify,
            Article=r
        })
```

r.Classify，会生成 Join 功能。如果不想 ToList 去选择需要的数据，可直接使用 Include 把需要关联的数据取出。在后面再使用 Linq 的 Select 把数据转换下，后面要注意 r.Classify 可能为 null，需要?.取。因为 ClassifyId 非必填项。

```
List<ArticleDto> articles4 = _articleRepository
    .Select
    .Include(r => r.Classify)
    .ToList().Select(r =>
    {
        ArticleDto articleDto = _mapper.Map<ArticleDto>(r);
        articleDto.ClassifyName = r.Classify?.ClassifyName;
        return articleDto;
    }).ToList();

```

## 直接 Join

5. 不使用关联属性获取文章专栏，这时候类 Article 中的 Classify 属性和 Classify 表中的 List\<Article>可删除，

```
List<ArticleDto> articleDtos = _articleRepository
            .Select
            .From<Classify>((a, b) =>a.LeftJoin(r => r.ClassifyId == b.Id)
            ).ToList((s, a) => new
            {
                Article = s,
                a.ClassifyName
            })
            .Select(r =>
            {
                ArticleDto articleDto = _mapper.Map<ArticleDto>(r.Article);
                articleDto.ClassifyName = r.ClassifyName;
                return articleDto;
            }).ToList();
```

### 使用 SQL 直接获取文章及其分类名称

6.SQL 需要自己增加 is_deleted 判断。

```
List<ArticleDto> t9 = _freeSql.Ado.Query<ArticleDto>($@"
                SELECT a.*,b.item_name as classifyName
                FROM blog_article a
                LEFT JOIN base_item b
                on a.classify_id=b.id where a.is_deleted=0"
);
```

### 总结

以上取出的数据行数都是一样的。  
一对多。

1. 写 SQL，很简单。
2. 使用 ORM 的 Join，再配合 Mapper 就变得复杂了。
3. 使用导航属性，取关联数据，一个 InClude 就解决问题了
4. 使用导航属性，取关联数据，然后再配合 Mapper，基本就要看你的 Linq、AutoMapper 的水平了。哈哈。

比如上面把 Article 类中的 Classify 中的某一个值取出转换成 ArticleDto 中的 ClassifyName
