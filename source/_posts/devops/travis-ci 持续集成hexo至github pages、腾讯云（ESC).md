---
title: travis-ci 持续集成hexo至Github Pages、腾讯云（ESC)
date: 2019-06-27 10:30:26
tags: 
- travis-cli
- ssl
- Ubuntu
category:
- DevOps
---


## 主要完成的功能
 - hexo博客 master 分支 https://github.com/luoyunchong/hexo-blog
 - 放静态资源 https://github.com/luoyunchong/luoyunchong.github.io 
 - github帮我发布的github Pages https://luoyunchong.github.io
 - 腾讯云服务器 nginx代理的静态资源，和GitHub Pages内容同步 http://blog.igeekfan.cn

 我使用hexo写博客，每次写完博客，推送到hexo-blog的master分支后，想要让他编译生成静态文件后自动发布至一个ESC上的某个目录上（也推送至 luoyunchong.github.io 的主分支、github会把静态资源作为GitHub Pages内容);

<!-- more -->

### 相关技术
- travis-ci
- github、github pages
- 腾讯云(ESC)、nginx、ssl(私钥、公钥)
- hexo 使用markdown写的静态博客

### 参考
- [持续集成服务 Travis CI 教程](http://www.ruanyifeng.com/blog/2017/12/travis_ci_tutorial.html)
- [How to Encrypt/Decrypt SSH Keys for Deployment](https://github.com/dwyl/learn-travis/blob/master/encrypted-ssh-keys-deployment.md)
- [Travis CI 自动化部署博客](https://segmentfault.com/a/1190000011218410)
- [使用Travis自动部署前端页面到阿里云服务器](https://blog.csdn.net/u011350541/article/details/84034141)
- [Linux命令详解之–scp命令](https://www.linuxdaxue.com/linux-command-intro-scp.html)
- [Linux ssh/scp连接时避免输入yes(公钥验证)](https://www.cnblogs.com/imzye/p/5133749.html)
### 备注
这个是shell的多行注释
~~~
:<<!
这里的内容 shell 不会执行
!
~~~
单行注释
~~~
# 注释。。
~~~

**$NAME**

在.travis.yml文件中，以$开头的是环境变量，一些敏感数据为了安全保障，可在travis.org 中的settings中配置Environment Variables

scp 命令用于linux下的跨主机之间的文件和目录复制

在首次连接服务器时，会弹出公钥确认的提示。这会导致某些自动化任务，由于初次连接服务器而导致自动化任务中断，

scp 拷文件可能会提示密码，或者检查key，如

~~~
Are you sure you want to continue connecting (yes/no)
~~~

可在 StrictHostKeyChecking选项，用 -o 参数指定后，则不检查该项。

~~~
scp [可选参数] file_source file_target
#将public目录下的所有文件复制到$DEPLOY_IP下的/var/www/html/hexo-blog目录中。不检查key，
scp -o StrictHostKeyChecking=no -r public/*  ubuntu@$DEPLOY_IP:/var/www/html/hexo-blog/
#可用-i指定私钥。
scp -o  StrictHostKeyChecking=no -i .ssh/id_rsa yourfile user@destinate_ip:/dest_folder
#或将自己的公钥放到目标机的authorized_keys文件里，使自己为目标机的信任机器，实现无密码登录
#这个是在生成ssh key 后，将公钥放到authorized_keys文件中。使用密钥对可以实现不输入密码
cd ~/.ssh
cat id_rsa.pub >> authorized_keys
~~~

### 相关命令行配置
在要发布的服务器ubuntu中运行
scp -r 
~~~
cd ~/.ssh
# create ssh key
ssh-keygen -t rsa -b 4096 -C "TravisCIDeployKey"  #一直回车

#这个是生成ssh key后 命令行显示的内容
#Your identification has been saved in /home/ubuntu/.ssh/id_rsa.
#Your public key has been saved in /home/ubuntu/.ssh/id_rsa.pub.
#The key fingerprint is:
#SHA256:Oy3Kclw+RigPNHZysyW6R0/ZgiykAB4njmQUJIOLNAk luoyunchong@foxmail.com
#The key's randomart image is:
#+---[RSA 2048]----+
#|E+o              |
#|+X .             |
#|X.=              |
#|=o  * = .        |
#| . = B BSo       |
#|  . = * *o.      |
#|     O *+..      |
#|    o.=.=o       |
#|     +o. .       |
#+----[SHA256]-----+

ls
# 可以看到.ssh目录下得到了两个文件：id_rsa（私有秘钥）和id_rsa.pub（公有密钥）
#id_rsa  id_rsa.pub

#append the public key to the list of "authorized keys":
cat id_rsa.pub >> authorized_keys
# ubuntu
sudo apt-get install ruby-full
gem install travis
travis login
#输入github的用户名和密码，登录成功才能travis encrypt-file 
#Username: luoyunchong@foxmail.com
#Password for luoyunchong@foxmail.com: ************
#Successfully logged in as luoyunchong!

# 一开始一直不行，官网介绍没有 -r + GitHub名字/仓库名，用于指定 仓库。
touch .travis.yml && travis encrypt-file ~/.ssh/id_rsa --add -r luoyunchong/hexo-blog    
# 看到下面，生成了id_rsa.enc
#storing result as id_rsa.enc
#storing secure env variables for decryption
#
#Make sure to add id_rsa.enc to the git repository.
#Make sure not to add /home/ubuntu/.ssh/id_rsa to the git repository.
#Commit all changes to your .travis.yml.

# 查看.travis.yml文件
cat .travis.yml
~~~
你会看到如下内容 

~~~
before_install:
- openssl aes-256-cbc -K $encrypted_77965d5bdd4d_key -iv $encrypted_77965d5bdd4d_iv
  -in id_rsa.enc -out ./id_rsa -d # 解密已加密的文件
~~~

### 注意
把id_rsa.enc从服务器下载下来，放到hexo的项目根目录，id_rsa.enc就是私有秘钥加密后的文件，


- www.travis-cli.org （免费,公有仓库）
- www.travis-cli.com （收费，私有仓库，前100个构建是免费的，不知道为啥在github的M aketplace选择免费版时，他还是进的这个链接）

在 www.travis-cli.com 是找不到key和iV，他们自动进入www.travis-cli.org，执行
~~~
travis encrypt-file ~/.ssh/id_rsa --add -r luoyunchong/hexo-blog
~~~
自动把 $encrypted_77965d5bdd4d_key 的值 ，$encrypted_77965d5bdd4d_iv的值加入了cli.org中的环境变量中了，所以我们还是用org的 CI build吧。


hexo 部署至luoyunchong.github.io后，github会自动部署至github Pages
部署到自己的服务器：使用ssh 密钥，远程登录，把发布后的文件复制至服务器指定文件夹，此文件夹使用nginx

### 完整.travis.yml文件配置
~~~

language: node_js
node_js: stable

cache:
    apt: true
    directories:
        - node_modules # 缓存不经常更改的内容

before_install:
- openssl aes-256-cbc -K $encrypted_3f5b9d00fa1f_key -iv $encrypted_3f5b9d00fa1f_iv
  -in id_rsa.enc -out ~/.ssh/id_rsa -d
- chmod 600 ~/.ssh/id_rsa

# S: Build Lifecycle
install:
  - npm install

#before_script:
 # - npm install -g gulp

script:
  - hexo clean  #清除
  - hexo g

addons:
  ssh_known_hosts: $DEPLOY_IP

after_script:
  # - cd ./public
  # - git init
  # - git config user.name "luoyunchong" # 修改name
  # - git config user.email "luoyunchong@foxmail.com" # 修改email
  # - git add .
  # - git commit -m "Travis CI Auto Builder"
  # - git push --force --quiet "https://${GH_TOKEN}@${GH_REF}" master:master # GH_TOKEN是在Travis中配置token的名称 # 一种 
  - git config user.name "luoyunchong" # 修改name
  - git config user.email "luoyunchong@foxmail.com" # 修改email
  - sed -i "s/gh_token/${GH_TOKEN}/g" ./_config.yml # 替换同目录下的_config.yml文件中gh_token字符串为travis后台刚才配置的变量，注意此处sed命令用了双引号。单引号无效！
  - hexo deploy

after_success:
  - pwd
  - scp -o StrictHostKeyChecking=no -r public/*  ubuntu@$DEPLOY_IP:/var/www/html/hexo-blog/

branches:
  only:
    - master
env:
 global:
   - GH_REF: github.com/luoyunchong/luoyunchong.github.io.git


notifications:
  email:
    - luoyunchong@foxmail.com
  on_success: change
  on_failure: always
~~~