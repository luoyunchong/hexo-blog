---
title: 记一次.NET 与R语言交互
date: 2018-07-03 00:50:27
tags:
- ABP
- .NET Framework
- R.NET
category: 
- .NET Framework
---

项目主要使用.NET相关技术，最近因为项目中要将写好的R语言的代码，直接通过.NET调用，得到计算结果，遇到了这么多的坑，在此记下一些过程，文档太少，英文不好！！！
> 使用的类库是  RDotNet   ,开源地址：[R.NET](https://github.com/jmp75/rdotnet)
> 他有官网的：[对R.NET的一些介绍](https://jmp75.github.io/rdotnet/) ，这个可能需要翻墙。

<!-- more -->

我找了很多博客，在CSDN上的代码，基本都是重复的，也没有太多的介绍，一般情况都是官网直接翻译下来的，遇到一些问题时，根本查不到是什么原因。
那么，遇到问题，怎么办？
1、看官网，里面有一些示例的链接：[这个相当于示例代码库](https://github.com/jmp75/rdotnet-onboarding)
2、看github上，开源地址的Issue，看不懂英语，也要看，有些问题，看完你就会懂了。


R.NET是什么？

  我的理解，R语言就像是SQL语言，用于数据计算，数据处理。R.Net这个类库就类似ADO.NET的技术，帮助我们实现.NET程序访问R语言代码，R.NET就相当于一个驱动程序。当然，严格意义上，我也不知道RDotNet是不是这样子，看他介绍，应该是起一R引擎。。。。（不懂.jpg）

使用RDotNet的步骤：
1、首先，你要看懂一些简单的R程序，就像，你不懂sql 语句，你怎么写ADO.NETt程序一样
（安装R的环境，不要装最新的3.5版本，因为，R.NET并没有做到最新的版本，看他的github就知道了，我本地装的3.3.3，一点问题都没有。如果你安装3.5版本，会一直报一个空指针异常，反正我被坑了。）
2、将我上面所说的示例代码库下载下来，从最简单的代码开始看起。
### 如下为开发过程中可能出现的问题！

* 而我遇到什么样的问题呢？ 我是如何解决的？
* 还有哪些问题需要解决？
* 这个类库还有哪些问题不能解决，他有哪些缺点？

回答上面的问题.
#### 1.我遇到的问题。
1）、安装过新的R环境3.5导致一直报错，一点思路都没有。
如何解决：看github的issue，看到有人提的问题，大意是指。R.NET不能支持到最新的R语言版本。
2）、一个简单的程序，在控制台上执行，是OK的。然而在ASP.NET MVC程序上一直不成功。
如何解决：第一步：先把R的环境变量配置好，类似JDK的环境变量配置 
找到自己的R语言位置，将32位和64位的环境都配置至path中 
```
	;C:\Program Files\R\R-3.3.3\bin\i386;C:\Program Files\R\R-3.3.3\bin\x64;
```
第二步，如何还有问题的话：比如一直报StackOverflowException的异常，建议你看他的issue:[这个是他们的讨论](https://github.com/jmp75/rdotnet/issues/74)
原本我也遇到这个问题，但R的版本用了3.3,就没这个错了。
3）、当R的引擎正常结束后，调用 dispose后，下次调用 就会报错，那就不调用 dispose方法吧。
那个作者说：There can only be one R engine in a process, and R itself is largely not thread-safe.


#### 2.还有哪些问题需要解决？
1)   以**管理员权限**运行Rgui,并指定包安装的位置，防止安装到其他目录
此命令设置当前包安装的位置，
~~~
.libPaths("C:/Program Files/R/R-3.3.3/library")
~~~
此命令查看当前包会安装的位置
~~~
.libPaths()
~~~
2) 如果有些包无法正常安装，如果能找到那个包，可直接复制其至目录C:/Program Files/R/R-3.3.3/library
3) 运行和发布后的代码都应运行在64位机子及平台上。

####  3.这个类库还有哪些问题不能解决，他有哪些缺点？
1) 不能兼容所有的R版本，目前只兼容到R3.3.3。
2) 如下代码在本机windows10 专业版 中文版电脑上运行会乱码
~~~
 CharacterVector datFname = engine.CreateCharacter("我是中文");
~~~
 我研究下代码，是这个类中的方法有问题InternalString  下的方法 StringFromNativeUtf8
 ~~~
        /// <summary>
        /// Convert utf8 to string
        /// </summary>
        /// <param name="utf8">utf8 to convert</param>

        public static string StringFromNativeUtf8(IntPtr utf8)
        {
            int len = 0;
            while (Marshal.ReadByte(utf8, len) != 0) ++len;
            byte[] buffer = new byte[len];
            Marshal.Copy(utf8, buffer, 0, buffer.Length);
            return Encoding.UTF8.GetString(buffer);
        }
 ~~~
我在我本地调试源码时，发现，如果包含中文时，采用Encoding.Default.GetString(buffer);转换，这里就可以正常转换，但这样子，就只支持中文和英文了。而且，好像在测试过程中，改成Default后，如下方法中包含中文，反而乱码了。
~~~
       string[] rownames = engine.GetSymbol("rownames").AsCharacter().ToArray();
~~~
 所以我准备直接用最简单的方式 ，判断buffer的编码，如果不为UTF8,Convert为UTF8，然后返回，否则，这里就需要多此一举，因为，在测试过程发现，判断UTF8，不准确，明明不是UTF8，还是返回了UTF8，所以在这里需要判断，转换后的数据是否包含中文，如果包含，则直接返回，否则要从Default（根据系统的编码决定），转换为UTF8，就能返回中文 。
 ~~~
        /// <summary>
        /// Convert utf8 to string
        /// </summary>
        /// <param name="utf8">utf8 to convert</param>

        public static string StringFromNativeUtf8(IntPtr utf8)
        {
            int len = 0;
            while (Marshal.ReadByte(utf8, len) != 0) ++len;
            byte[] buffer = new byte[len];
            Marshal.Copy(utf8, buffer, 0, buffer.Length);
            Encoding encoding = GetType(buffer);
            if (encoding.Equals(Encoding.UTF8))
            {
                string r = Encoding.UTF8.GetString(buffer);
                if (System.Text.RegularExpressions.Regex.IsMatch(r, @"[\u4e00-\u9fbb]+$"))
                {
                    return r;
                }
                else
                {
                    byte[] newBuffer = Encoding.Convert(Encoding.Default, Encoding.UTF8, buffer);
                    return Encoding.UTF8.GetString(newBuffer);
                }
            }
            else
            {
                byte[] newBuffer = Encoding.Convert(encoding, Encoding.UTF8, buffer);
                return Encoding.UTF8.GetString(newBuffer);
            }
        }
~~~
**代码已放到github**
> 由于该 [R.NET类库 ](https://github.com/jmp75/rdotnet)长期未维护，还是有很多BUG，所以我fork了一份，以便解决部分简单BUG问题， [github开源地址](https://github.com/luoyunchong/rdotnet)



### 相关博客介绍
* [用C#调用R语言开发.NET MVC Web服务](https://blog.csdn.net/clearskychan/article/details/53431535) 此文章中介绍了.NET启动控制台调用R代码，这个思路非常好，一开始对R语言了解甚少，所以还是使用R.NET来实现.NET与R语言的交互，反而耗时耗力。
* [一键运行R脚本](https://blog.csdn.net/wzgl__wh/article/details/77099903) 这个文章让我了解到Rscript.exe这个程序的作用，以及执行方式。
+ [c#调用R语言（原创翻译）](https://blog.csdn.net/guoer9973/article/details/45953471)

由于开发过程中，有个R程序运行时间非常长，最长可达2小时，所以只能以后台任务方式执行，但 RDotNET，一次只能运行一个，不执行完，其他的程序在WEB项目下无法正常运行，看了上面的文章，有了思路 ：使用.NET的进程Process起一个cmd命令，类似 java配置好环境变量后可使用java,javac命令一样，配置到Path中后，可直接在cmd中使用如下命令
~~~bash
Rscript.exe "某目录下\test.R"  agruments 
~~~
其中R程序包要有双引号   多个参数使用空格分隔 ，如下为.NET下使用Process启动cmd命令，并执行Rscript.exe 命令启动R引擎，让其后台运行，运行结束后，才会往后执行。
~~~
    public void Execute()
        {
            List<string> arguments = new List<string>
            {
                参数
            };

            Process cmd = new Process
            {
                StartInfo =
                {
                    FileName = @"Rscript.exe",
                    WorkingDirectory = AppFolders.RSourceCodeFolder,//.R代码的位置 "E:\svn\CHNMed\CHNMed.Web\DataUsers\RSourceCode"
                    UseShellExecute = false,
                    RedirectStandardOutput = true,
                    RedirectStandardError = true,
                    Arguments = " Test.r " + string.Join(" ", arguments),
                    CreateNoWindow = true,//不显示程序窗口
                }
            };
            cmd.Start();//启动程序
            var output = cmd.StandardOutput.ReadToEnd();
            var error = cmd.StandardError.ReadToEnd();
            cmd.WaitForExit();//等待控制台程序执行完成
			cmd.Close();//关闭该进程
            Logger.InfoFormat($"参数：{output}出错信息:{error}");
        }

~~~

