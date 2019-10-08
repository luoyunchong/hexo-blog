---
title: Node.js 构建成树形结构
date: 2017-01-10 14:10:47
tags:
- Node.js
category: 
- 大后端
---

> Node.js 下生成递归的树形结构

如何将数据库取取的数组形式的数据转换成前端需要的树形格式呢，此demo借助DFS 深度优先搜索
1. var tree=new treeNode中是最关键的，根据pid为0，循环得到所有父节点为0的数据，将其放入treelist集合中，在这个过程中，顺带，把其子节点也构建好.
2. 在getDFSTree(data, data[i].id) 这一行代码中，将data[i].id作为下一个pid，继续循环找到其节点的子节点，其作为chilldren的属性，挂载在上一个父节点上。

<!-- more -->

```
function treeNode(id, pid, text, children) {
    this.id = id;
    this.pid = pid;
    this.text = text;
    this.children = children;
}

//测试数据
var data = [
 { 'id': 1, 'pid': 0, 'text': '主节点' },
 { 'id': 2, 'pid': 1, 'text': '第二层,id2' }, 
 { 'id': 3, 'pid': 1, 'text': '第二层,id3' }, 
 { 'id': 4, 'pid': 3, 'text': '第三层,id4' }
];

function getDFSTree(data, pid) {
    var treelist = [];
    for (var i = 0; i < data.length; i++) {
        if (data[i].pid == pid) {
			var tree = new treeNode(data[i].id, 
									data[i].pid, 
									data[i].text, 
									getDFSTree(data, data[i].id));
            treelist.push(tree)
        }
    }
    return treelist;
}
//exports.getDFSTree= getDFSTree;
//调用 
var tree = getDFSTree(data, 0);
console.log(tree[0].children)
```

> 递归删除子节点

如何删除树形结构的数据时，我们如何删除节点和他的子节点呢。此demo，不太友好。说下思路。现在让我实现这样的功能，就是另一个思路。在这里说二个方法
1. 得到所有节点数据，然后，在内存在找到所有的子节点，将其push到一个数组中，然后删除时使用 where id in(1,2,3,4)  
2. 第二种，直接写一个sql,得到所有子节点，然后删除。

#### 第一种实现-递归
具体实现：在内存中找到节点的所有子节点，其中results为数据中所有的节点数据。IsActive为是否启用，这边并不太大作用，仅是数据库用到的软删除。

数据格式为 
```
[
	{'FunctionID':1,'ParentID ':0,'IsActive':1},
	{'FunctionID':2,'ParentID ':1,'IsActive':1},
	{'FunctionID':3,'ParentID ':1,'IsActive':1},
	{'FunctionID':4,'ParentID ':2,'IsActive':1},
	{'FunctionID':5,'ParentID ':2,'IsActive':1},
	{'FunctionID':6,'ParentID ':3,'IsActive':1}
]
```
递归代码实现
```
var treeFuncID = [];
treeFuncID.push({
     'FunctionID': data.FunctionID
 });

 //得到子节点的所有functionid
  function getMultiTreeID(FunctionID) {
      var querydata = {
          'ParentID': FunctionID,
          'IsActive': 1
      }
      var data = [];
    
      for (var j in results) {
          if (results[j].ParentID == FunctionID) {
              data.push({ 'FunctionID': results[j].FunctionID });
          }
      }
      if (data != undefined && data.length > 0) {
          for (var i in data) {
              getMultiTreeID(data[i].FunctionID);
              treeFuncID.push({
                  'FunctionID': data[i].FunctionID
              });

          }
      }
  }//DFS查找功能点数据，将其push到treeFunctID数组中
  getMultiTreeID(data.FunctionID);//同步
        
```

#### 第二种实现-MsSQL版本
Summaries  为表名 IsDeleted为软删除字段	

```
//可以根据父节点得到所有子节点数据
string sql = @"
         WITH TEMP AS 
         (
         SELECT Id,Name,PId
                 FROM 
                 HbAssess.dbo.Summaries  
                 WHERE 
                 PId = @pId AND IsDeleted='false'
             UNION ALL 
                 SELECT a.Id,a.Name,a.PId
                 FROM 
 TEMP  JOIN HbAssess.dbo.Summaries a ON TEMP.Id= a.PId AND a.IsDeleted='false'
         )  
         SELECT Id,Name as 'Text',PId as ParentId FROM TEMP ";

```

#### 第二种实现-MySQL 5.6+
re_menu为表名
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