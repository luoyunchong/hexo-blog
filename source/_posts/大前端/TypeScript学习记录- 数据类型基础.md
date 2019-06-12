---
title: TypeScript学习记录- 数据类型基础
date: 2019-06-12 14:27:54
tags: TypeScript
---
# TS 学习笔记记录

相关文档
- [TypeScript 入门教程-xcatliu](https://ts.xcatliu.com/)
- [JavaScript高级程序设计（第三版）pdf的下载地址](https://blog.csdn.net/gao531162436/article/details/79087456)
-  [JS 函数式编程指南](https://llh911001.gitbooks.io/mostly-adequate-guide-chinese/content/?q=)
-  [Typescript教程_Typescript视频教程 ts入门实战视频教程](https://www.bilibili.com/video/av38379328/?p=1)

## 原始数据类型 
原始数据类型包括布尔值、数值、字符串、null、undefined、Symbol。

* 定义一个布尔值
~~~
let isOk:boolean =false;
~~~
* 定义一个数值
~~~
let literal:number=10;
~~~

* 定义 字符串
~~~
let name:string="luo";
~~~

* 空值
~~~
 function alertName(name:string):void{
	alert("my name is "+name);
}
~~~
* null 和undefined
~~~
let u: undefined = undefined;
let n: null = null;
~~~

void 与null和undefined不同点在于，null和undefined是所有类型的子类型，null和undefined可赋值给他的父类型。

## 任意值

*   任意值类型
~~~
 let name:any="1234";
 name = 111;
~~~

如果是 any 类型，则允许被赋值为任意类型。

* 未声明类型的变量
变量如果在声明的时候，未指定其类型，那么它会被识别为任意值类型：不管后来有没有被赋值，都会推断成any类型。
~~~
let st;
st="1111";
st=111;
~~~

##  类型推断
 当定义变量时，未指定明确的类型时，TS会根据类型推论的规则推断出这个变量的类型

~~~
let myFav=“This is a string!";
~~~
等价于
~~~
let myFav:string="This is a string!";
~~~

## 联合类型
表示取值可以为多种类型中的一种。
 
* let 变量名:变量类型|变量类型;使用  **|** 分隔数据类型。
~~~
let myFavoriteNumber:string|number;
myFavoriteNumber = 'seven';
myFavoriteNumber = 7;
~~~
 
 * 访问联合类型属性或方法。
 要注意只有当TypeScript不确定一个联合类型的变量到底是哪个类型时，只能访问联合属性中共有的属性或方法
~~~
function getLength(something: string | number): number {
    return something.length;
}

// index.ts(2,22): error TS2339: Property 'length' does not exist on type 'string | number'.
//   Property 'length' does not exist on type 'number'.
~~~
报错原因是无法知道参数是string 还是number，number类型没有length属性，所以异常。

~~~
let myFavoriteNumber: string | number;
myFavoriteNumber = 'seven';
console.log(myFavoriteNumber.length); // 5
myFavoriteNumber = 7;
console.log(myFavoriteNumber.length); // 编译时报错

// index.ts(5,30): error TS2339: Property 'length' does not exist on type 'number'.
~~~
只有console.log(myFavoriteNumber.length); // 编译时报错，第二行中 myFavoriteNumber 被推断成 **string**，所以 访问**length**时无异常，第四行 其被推断成 **number**,访问**length**会异常。


## 对象的类型-接口
接口是一种规范，他定义了一个事物的基础属性，规则。
* 定义接口
```
interface Person {
    readonly id:number;
    name: string;
    age?: number;
    [propName: string]:any;
}
```
id 前加 **readonly** 表示该字段为只读属性，只有第一次给对象 **Person**赋值时 **id** 必须有值，后面无法给此值赋值。
age后面加 **?** 表示该属性为可选属性。定义变量时可为空，
[propName: string]  任意属性 ,定义属性值 为 **string** 类型的值。**当定义任意属性后，确定的属性和可选属性必须为这个类型的子集**

## 数组类型
* 「类型 + 方括号」来表示数组
~~~
let fibonacci: number[] = [1, 1, 2, 3, 5];
let fibonacci: (number | string)[] = [1, '1', 2, 3, 5];
// any 表示数组中可出现任意类型,也可使用默认的类型推断。去掉类型 any[]
let list: any[] = ['Xcat Liu', 25, { website: 'http://xcatliu.com' }];
~~~

* 数组泛型
~~~
Array<elemType> 来表示数组

let fibonacci: Array<number> = [1, 1, 2, 3, 5];
~~~

* 使用接口实现数组

~~~
interface NumberArray {
    [index: number]: number;
}
let fibonacci: NumberArray = [1, 1, 2, 3, 5];
~~~

* 类数组 
内置对象 IArguments 
~~~
function sum() {
    let args: IArguments = arguments;
}
~~~

## 函数的类型
 * 函数声明
~~~
function sum(x: number, y: number): number {
    return x + y;
}
~~~
* 函数表达式

~~~
let mySum=function(x:number,y:number):number{
	return x+y;
}
~~~
mySum其实未指定类型，而是通过类型推断实现的，手动指定mySum的类型
~~~
let mySum:(x:number,y:number)=>number=function(x:number,y:number):number{
	return x+y;
}
~~~
在TyepScript中  **=>** 表示函数的定义，**左边是输入类型，右边是输出类型**

[ES6中的箭头函数相关介绍](http://es6.ruanyifeng.com/#docs/function#%E7%AE%AD%E5%A4%B4%E5%87%BD%E6%95%B0)

* 使用接口定义函数类型

~~~
interface searchFunc{
	(source:string,subString:string):boolean;
}
let mySearch:searchFunc;

mySearch=function(source:string,subString:string):boolean{
    return source.search(subString) !== -1;
}
~~~
* 可选参数、参数默认值
使用 **？** 表示可选择的参数，有默认值的参数为可选参数，但不受 **「可选参数必须接在必需参数后面」的限制了**
可选参数必须接在必需参数后面。换句话说，可选参数后面不允许再出现必须参数了

~~~
function buildName(firstName: string='Tom', lastName?: string) {
    if (lastName) {
        return firstName + ' ' + lastName;
    } else {
        return firstName;
    }
}
let tomcat = buildName('Tom', 'Cat');
let tom = buildName('Tom');
~~~

## 类型断言
断言，不是类型转换，无法将一个联合类型转换成一个不存在的类型是不可以的。
~~~
//定义类型:<类型>值
let something: string | number="1234";
let str=<string>something;//这是正确的，可以将联合类型转换成一个更加具体的类型
let bol=<boolearn>something;//异常，Type 'string | number' cannot be converted to type 'boolean'
~~~