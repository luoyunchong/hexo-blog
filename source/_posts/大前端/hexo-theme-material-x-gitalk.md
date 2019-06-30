---
title: hexo-theme-material-x+gitalk
date: 2019-06-25 13:57:09
tags: 
- hexo
- material-x
- gitalk
category: hexo
---

### hexo-theme-material-x +gitalk 实现评论系统集成
关于hexo 中使用Material-x为主题时，增加评论系统 gitalk

* material-x 主题  https://xaoxuu.com/wiki/material-x/third-party-services/index.html
* gitalk开源地址 https://github.com/gitalk/gitalk

<!-- more -->

根目录的配置项
~~~yml
gitalk: 要使用哪个请复制到根目录配置文件！
  clientID: 你的clientID
  clientSecret: 你的clientSecret
  repo: 你的repo名  #这个直接就是仓储名
  owner: 你的GitHub名
  admin: [] 至少填写你的GitHub名
~~~

clientID和clientSecret如何得到：
1. 先要有github账号， 点击 New OAuth App（后面这个链接）： https://github.com/settings/applications/new
2. 填写信息：
Application name 随便填，
Homepage URL 和 Authorization callback URL 都写你的 网址，我的是：https://luoyunchong.github.io

生成后，就会有clientID和clientSecret

> 参考我的配置项

https://github.com/luoyunchong/hexo-blog/blob/docs/_config.yml


~~~
gitalk: 
  clientID: 70ba179c7cf0f158ad7d
  clientSecret: 76bea5d6863b98331709de2d6220bf439426d957
  repo: hexo-blog
  owner: luoyunchong
  admin: [luoyunchong]
~~~

这个repo一定要是仓储名，而不是仓储地址，不然，会一直返回404 NOT FOUND



* 报错出现 Error: Validation Failed.
[https://github.com/gitalk/gitalk/issues/102](https://github.com/gitalk/gitalk/issues/102)
总结主要的原因是
> 由于label太长导致的无法评论,label的长度上限是50个字符，所以文章名有些长的都会生成label失败,也就没办法评论了.

解决办法 ：文章名经URL编码后转MD5，然后再生成label，MD5值是固定长度的。引用md5的js,然后，给location.pathname使用md5加密

我使用的material-x，打开themes/material-x/layout/_partial/scripts.ejs文件，修改成如下内容
~~~javascript
  <script src="https://cdn.bootcss.com/blueimp-md5/2.10.0/js/md5.min.js"></script>
  <script type="text/javascript">
    var gitalk = new Gitalk({
      clientID: "<%- config.gitalk.clientID %>",
      clientSecret: "<%- config.gitalk.clientSecret %>",
      repo: "<%- config.gitalk.repo %>",
      owner: "<%- config.gitalk.owner %>",
      admin: "<%- config.gitalk.admin %>",
      <% if(page.gitalk && page.gitalk.id) { %>
        id: "<%= page.gitalk.id %>",
      <% } else { %>
        id: md5(location.pathname),      // Ensure uniqueness and length less than 50
      <% } %>
      distractionFreeMode: false  // Facebook-like distraction free mode
    });
    gitalk.render('gitalk-container');
  </script>
~~~
最重要的是引用

~~~
  <script src="https://cdn.bootcss.com/blueimp-md5/2.10.0/js/md5.min.js"></script> 
~~~
和
~~~
id: md5(location.pathname)
~~~

* 当浏览到一个不存在的地址时，会跳转至404，然后，由于没有给404增加gitalk设置id，所以会出现多个404NOT FOUND issues，所以在404.md中增加如下配置 （“/404”为任意唯一字符串值）
~~~
gitalk:
  id: /404
~~~

完整title
~~~
---
layout: page
title: 404 Not Found
body: [article, comments]
meta:
  header: false
  footer: false
sidebar: false
valine:
  path: /404.html
  placeholder: 请留言告诉我您要访问哪个页面找不到了
---

# <center>**404 Not Found**</center>

<br>

# <center>很抱歉，您访问的页面不存在</center>

<center>可能是输入地址有误或该地址已被删除</center>

<br>
<br>
~~~