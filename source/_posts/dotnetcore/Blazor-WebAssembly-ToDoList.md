
---
title: ASP.NET Core Blazor WebAssembly实现一个简单的TODO List
date: 2020-06-06 20:09:07
tags:
- ASP.NET Core
- Blazor
- WebAssembly
category:
- .NET Core
---


## 基于blazor实现的一个简单的TODO List

最近看到一些大佬都开始关注blazor，我也想学习一下。做了一个小的demo，todolist，仅是一个小示例，参考此vue项目的实现[http://www.jq22.com/code1339](http://www.jq22.com/code1339)

<!-- more -->
先看实现的效果图

[![](https://pic.downk.cc/item/5edb68bec2a9a83be5a8ef20.gif)](https://pic.downk.cc/item/5edb68bec2a9a83be5a8ef20.gif)

不BB,直接可以去看
### 源码与预览地址

- 示例地址 [http://baimocore.cn:8081/](http://baimocore.cn:8081/)
- 源码地址 [https://github.com/luoyunchong/dotnetcore-examples/tree/master/blazor/BlazorAppTodoList](https://github.com/luoyunchong/dotnetcore-examples/tree/master/blazor/BlazorAppTodoList)




### 源码介绍

我们这里删除了默认的一些源码。只保留最简单的结构,在Pages/Index.razor中。

@code代码结构中写如下内容

1. 创建一个类，里面包含 id,label,isdone三个属性值。

```
public class TodoItem
{
    public TodoItem () { }
    public TodoItem (int id, string label, bool isDone)
    {
        Id = id;
        Label = label;
        IsDone = isDone;
    }
    public int Id { get; set; }
    public string Label { get; set; }
    public bool IsDone { get; set; }
}
```


2. 我们可以通过override重写初始化，并给Todos设置一些数据。
```
private IList<TodoItem> Todos;
private int id = 0;
protected override void OnInitialized ()
{
    Todos = new List<TodoItem> ()
    {
        new TodoItem (++id, "Learn Blazor", false),
        new TodoItem (++id, "Code a todo list", false),
        new TodoItem (++id, "Learn something else", false)
    };
}
```


展示还有多少未完成的任务 

```
<h1>
        Todo List(@Todos.Count(todo => !todo.IsDone))
        <span>Get things done, one item at a time.</span>
</h1>
```
当任务没有时，我们展示默认效果，提示用户无任务
```
<p class="emptylist" style="display: @(Todos.Count()>0?"none":"");">Your todo list is empty.</p>
```

新增一个任务
```
<form name="newform">
    <label for="newitem">Add to the todo list</label>
    <input type="text" name="newitem" id="newitem" @bind-value="Label">
    <button type="button" @onclick="AddItem">Add item</button>
</form>
```
这里我们用了一个Label变量，一个onclick事件。
```
private string Label;

private void AddItem()
{
    if (!string.IsNullOrWhiteSpace(Label))
    {
        Todos.Add (new TodoItem { Id = ++id, Label = Label });
        Label = string.Empty;
    }
    this.SortByStatus();
}
```

**this.SortByStatus**
因为我们这里还实现一个功能，就是当勾选（当任务完成时，我们将他移到最下面）

```
<div class="togglebutton-wrapper@(IsActive==true?" togglebutton-checked":"")">
    <label for="todosort">
        <span class="togglebutton-Label">Move done items at the end?</span>
        <span class="tooglebutton-box"></span>
    </label>
    <input type="checkbox" name="todosort" id="todosort" value="@IsActive" @onchange="ActiveChanged">
</div>
```

一个IsActive的变量，用于指示当前checkbox的样式，是否开启已完成的任务移动到最下面。当勾选时，改变IsActive的值。并调用排序的功能。

```
private bool IsActive = false;
private void ActiveChanged()
{
    this.IsActive = !this.IsActive;
    this.SortByStatus();
}
private void SortByStatus()
{
    if (this.IsActive)
    {
        Todos = Todos.OrderBy(r => r.IsDone).ThenByDescending(r => r.Id).ToList();
    }
    else
    {
        Todos = Todos.OrderByDescending(r => r.Id).ToList();
    }
}
```

对于列表的展示我们使用如下ul li @for实现
```
<ul>
    @foreach (var item in Todos)
    {
        <li stagger="5000" class="@(item.IsDone?"done":"")">
            <span class="label">@item.Label</span>
            <div class="actions">
                <button class="btn-picto" type="button"
                        @onclick="@((e)=> {MarkAsDoneOrUndone(item);})"
                        title="@(item.IsDone ? "Undone" :"Done")"
                        aria-label="@(item.IsDone ? "Undone" :"Done")">
                    <i aria-hidden="true" class="material-icons">@(item.IsDone ? "check_box" : "check_box_outline_blank")</i>
                </button>
                <button class="btn-picto" type="button"
                        @onclick="@((e)=> { DeleteItemFromList(item); })"
                        aria-Label="Delete" title="Delete">
                    <i aria-hidden="true" class="material-icons">delete</i>
                </button>
            </div>
        </li>
    }
</ul>
```
循环Todos，然后，根据item.IsDone，改变li的样式，从而实现一个中划线的功能，二个按钮的功能，一个是勾选任务表示此任务已完成，另一个是删除此任务。同理，我们仍然通过IsDone来标识完成任务的图标，标题等。

- 任务设置已完成/设置为未完成： @onclick调用方法MarkAsDoneOrUndone，并将当前的一行记录item传给方法，需要使用一个匿名函数调用@code中的方法,将isDone取相反的值，并重新排序。

```
private void MarkAsDoneOrUndone(TodoItem item)
{
    item.IsDone = !item.IsDone;
    this.SortByStatus();
}
```
- 删除一个任务，同理，使用匿名函数，DeleteItemFromList直接通过IList的方法Remove删除一个对象，并排序。
```
private void DeleteItemFromList(TodoItem item)
{
    Todos.Remove(item);
    this.SortByStatus();
}
```

当然，我们可以 在ul，外包裹一层,根据Count判断有没有任务，从而显示这个列表。

```   
<div style="display: @(Todos.Count()>0?"":"none");"><ul>xxx</ul></div>
```

其他的样式与图标，请看最上面的源码wwwroot/css目录获取。

### deploy(部署)

- 有兴趣的可以看官网 [https://docs.microsoft.com/en-us/aspnet/core/host-and-deploy/blazor/?view=aspnetcore-3.1&tabs=visual-studio](https://docs.microsoft.com/en-us/aspnet/core/host-and-deploy/blazor/?view=aspnetcore-3.1&tabs=visual-studio)

在项目根目录执行如下命令

```
dotnet publish -c Release
```

我们就能得到一个发布包，他的位置在 **（BlazorAppTodoList\bin\Release\netstandard2.1\publish）** ，我们把他复制到服务器上，这里我放到/var/www/todolilst目录中。


它相当于一个静态文件，你可以将他部署到任何一个web服务器上。

这里我们把他放到nginx中，并在目录/etc/nginx/conf.d/ 新建一个文件 todolist.conf，然后放入如下内容。

```
 server {
        listen 8081;

        location / {
            root /var/www/todolist/wwwroot;
            try_files $uri $uri/ /index.html =404;
        }
}
```

记得在etc/nginx/nginx.conf中配置gzip压缩。


```
gzip  on;
gzip_min_length 5k; #gzip压缩最小文件大小，超出进行压缩（自行调节）
gzip_buffers 4 16k; #buffer 不用修改
gzip_comp_level 8; #压缩级别:1-10，数字越大压缩的越好，时间也越长
gzip_types text/plain application/x-javascript application/javascript text/css application/xml text/javascript application/x-httpd-php image/jpeg image/gif image/png application/octet-stream; #  压缩文件类型 
gzip_vary on; # 和http头有关系，加个vary头，给代理服务器用的，有的浏览器支持压缩，有的不支持，所以避免浪费不支持的也压缩，所以根据客户端的HTTP头来判断，是否需要压缩
```

我遇到dll，wasm，后缀的文件压缩无效。因为gzip_types ，没有配置他们的Content-Type。我们在浏览器中找到响应头**Content-Type: application/octet-stream**


最后执行
```
nginx -t
nginx -s reload
```

### 打开网站看效果

#### [http://baimocore.cn:8081](http://baimocore.cn:8081)