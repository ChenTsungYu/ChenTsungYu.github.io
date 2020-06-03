---
title: "[JavaScript] Function"
catalog: true
date: 2019/07/22 13:45:01
tags: JavaScript
categories: Frontend
---
<!-- toc -->
# 前言
函數是重複呼叫的程式區塊，還能接受輸入的參數，不同的參數會返回不同的值，如果運用的當，可以讓程式變得簡潔且彈性。

## 函數定義(Function Definition)

JavaScript 有三種定義函數的方式

    1.函數宣告
    2.函數表達式
    3.用 new 建構函式
<!--more--> 
## 函數宣告( Function Declaration)

function宣告的區塊就是一個函數。function後面是函數名，函數名後面是()，裡面是傳入函數的參數。函數體放在`{}`裡面。並透過函數名()進行呼叫。
```javascript
function hello() {
  console.log('Hi')
}
//函數呼叫
hello() // Hi
```
## 函數表達式( Function Expression)

採用**賦值**給變數的方式，又稱作**匿名函數。**

```javascript
var hi = function hello() {
  console.log('Hi')
}
//匿名函數的呼叫
hi() // Hi 
```

採用函數表達式聲明函數時，function後面不帶有函數名。但加上函數名，該函數名**只在函數體內部**有效，在函數體外部無效。

```javascript
var print = function x(){
  console.log(typeof x);
};
x // ReferenceError: x is not defined
print() // function
```

## 用 new 建構函式

透過new的語法建立一個函數，不過這個較少人使用。

```javascript
var pluse = new Function(
  'x','y',
  'return x + y'
);
// 等同于
function pluse(x, y) {
  return x + y;
}
```

### <note>

如果同一個函數被多次聲明，後面的聲明就會覆蓋前面的聲明。

```javascript
var print = function x(){
  console.log(typeof x);
};
x // ReferenceError: x is not defined
print() // function
```
## arguments

剛才上述的例子可以發現，呼叫函數內放的參數(10,20)稱作**實際參數(簡稱實參)**，而function區塊內的參數(a,b)稱作**形式參數(簡稱形參)。實參**會被放入一個叫**arguments**的object裡面。

來看範例:
```javascript
function sum(a, b) {
  console.log(arguments); //  儲存實參[10,20] 
  console.log(a,b); // 10 20
  console.log(arguments[0],arguments[1]); // 10 20
  arguments[0] = 100; // 100   將100賦值給arguments[0]，取代10
  console.log(a,b); // 100 20
  console.log(arguments[0],arguments[1]); // 100 20
        
  console.log(arguments.length);//  2    獲得arguments的長度
}
sum(10,20);
```
![](https://cdn-images-1.medium.com/max/2000/1*qw9pdRR1FZV0CcbpK1lUPg.png)

上面例子可知sum()函數被呼叫後傳入10,20兩個實參，並存在arguments內，可以透過arguments[index]來獲得裡面的參數(index表索引值)。另外也知道可以透過**=**的方式進行賦值，且透過length獲得長度。

假設今天**實參個數>形參個數，多餘的實參**會仍然被放入**arguments**的裡面。
```javascript
 //  實參 > 形參個數時，多的會存在arguments
function sum(a, b) {
 console.log(arguments); //  儲存實參[10,20,30,40,50]
 console.log(a, b); // 10 20
 console.log(arguments.length); //  5   arguments的長度
}
sum(10, 20,30,40,50); 
```
![](https://cdn-images-1.medium.com/max/2000/1*nGDspr9HVj8ngak9HqrFLQ.png)

上面例子可知當**實參個數>形參個數，多餘的還是會被存放，arguments總長度為5**

### <note>

arguments雖然看起來像array，但他還是一個object， array專有的方法， 不能在arguments上直接使用。

如果要讓arguments使用array方法，真正的解決方法是將arguments轉為真正的array。下面是兩種常用的轉換方法：slice方法和逐一填入新array。[參考來源](https://wangdoc.com/javascript/types/function.html#%E5%87%BD%E6%95%B0%E7%9A%84%E5%A3%B0%E6%98%8E)

```javascript
var args = Array.prototype.slice.call(arguments);

// 或者
var args = [];
for (var i = 0; i < arguments.length; i++) {
  args.push(arguments[i]);
}
 ```

## return

將返回結果回傳到函數呼叫的地方，下面做個範例:

```javascript
function sum(a, b) {
   return a + b;
}

var h = sum(10, 20); // 回傳 a + b到此處，並賦值給 h
console.log(h); // 30
 ```

上面範例所得回傳結果賦值給h，h=30。

另外，要注意的地方是: **return 之後的程式不會執行**

![](https://cdn-images-1.medium.com/max/2000/1*g8fATlFwJ3sceZOrOWAp5g.png)
```javascript
 // return 之後的code不會執行
function sum(a, b) {
  console.log("return之前"); 
  return a + b;
  console.log("如果看到我代表有執行return之後的code"); // 無顯示
}

var h = sum(10, 20); 
console.log(h); // 30
```

## 提升（Hoisting）

在執行任何程式碼前， JavaScript將定義的變數(variables)和函數(function)存放在記憶體內， 看起來是單純地將變數和函式宣告，移動到程式的區塊頂端，但實際位置和程式碼中完全一樣，這樣的動作**只有先儲存宣告，尚未賦值**。 先比較兩個例子:

```javascript
function catName(name) {
  console.log("My cat's name is " + name);
}
catName("Tigger"); // 輸出結果: "My cat's name is Tigger"
```

```javascript
catName("Chloe"); // "My cat's name is Chloe"

function catName(name) {
  console.log("My cat's name is " + name); 
}
```

即使我們函式的程式碼之前就先呼叫它，程式碼仍然可以運作，

**但是，如果採用賦值定義函數，JavaScript就會報錯。**
```javascript
f();   // TypeError: undefined is not a function
var f = function (){};  
```
上面的程式等同於下面的形式:

```javascript
var f;
f();
f = function () {};
```
上面程式第二行，呼叫f的時候，f只是被宣告了，但還沒有被賦值，等於undefined，所以會報錯。

如果同時採用function命令和賦值語句聲明同一個函數，最後總是採用賦值語句的定義。
> 只有宣告會提升,賦值不會(變數預設值被設為undefined )
> 所有JS的變數, 預設值為undefined 
> undefined 為一個JS內建的特殊值,並非字串,表示該變數尚未被設定(賦值)

如果同時採用function宣告和賦值同一個函數，一律採用賦值定義的function。
```javascript
var f = function () {
  console.log('1');
}

function f() {
  console.log('2');
}

f() // 1
```
例子主要參考[MDN](https://developer.mozilla.org/zh-TW/docs/Glossary/Hoisting)

### 函數內部的變數提升

與全局作用域一樣，函數作用域內部也會產生“Hoisting”現象。var宣告的變數，不管在什麼位置，變數宣告都會被提升到函數作用域的頂部，看個例子:

```javascript
function foo(x) {
  if (x = 100) {
    var tmp = x * 2;
  }
}

// 等同下方
function foo(x) {
  var tmp;
  if (x = 100) {
    tmp = x * 2;
  };
}
```
## scope(函數作用域)

為變數存在的範圍， 在ES5 規範裡面，JavaScript 只有兩種作用域：一種是全局(global)作用域(簡稱全域)，所有地方都可以讀取；另一種是函數作用域，變數只在函數內部存在。ES6 又新增了塊級作用域，之後另外記錄成一篇。
> 簡單來說: 不在function內就稱為全域!

另外，變數在**函數外**所宣告稱作**全域變數**，**在函數內**稱作**區域變數**，不過先決條件是要在宣告var的情況下。紀錄一下區域變數和變數會遇到的情況。
> 全域變數可在函數內讀取

```javascript
var v = 1;
function f() {
  console.log(v);
}

f() // 1
```
>  函數內的區域變數無法從函數外部讀取

```javascript
function f(){
  var v = 1;
}
v // ReferenceError: v is not defined
```

> 函數內部定義的變數，會在該作用域內覆蓋同名的全域變數。

```javascript
var v = 1;
function f() {
  var v = 2;
  console.log(v);
}
f(); // 2
console.log(v); // 1
```

> 對於var來說，區域變數只能在函數內部宣告，在其他區塊中宣告一律都是全域變數。
```javascript
if (true) {
  var x = 5;
}
console.log(x);  // 5
```

函數本身也是一個值，有自己的作用域。它的作用域與變數一樣，就是其宣告時所在的作用域，**與其運行時所在的作用域無關**。
換句話說:  **函數執行時所在的作用域，是定義時的作用域，而不是呼叫時所在的作用域**
 ```javascript
var a = 1;
var b = function () {
  console.log(a);
};

function f() {
  var a = 2;
  b();
}

f() // 1  // 非 2
```
上面的例子，函數b是在函數f的外部聲明的，所以它的作用域綁定在函數外層，區域變數a不會到函數f內取值，所以輸出1，而不是2。若將var a = 1刪除，就會得到Uncaught ReferenceError: a is not defined的錯誤回報。

再一個例子:
```javascript
var x = function () {
  console.log(a);
};

function y(f) {
  var a = 2;
  f();
}

y(x)  // ReferenceError: a is not defined
```
上面例子將函數x作為參數，傳入函數y。但函數x是在函數y外宣告，作用域綁定於函數外層，因此找不到函數y的內部變數a，導致報錯。
> 函數內宣告的函數，作用域綁定函數內部
```javascript
function foo() {
  var x = 1;
  function bar() {
    console.log(x);
  }
  return bar;
}

var x = 2;
var f = foo();
f() // 1
```
上面例子，函數foo內部宣告一個函數bar，bar的作用域綁定foo。當我們在foo外部取出bar執行時，變數x指向的是foo內部的x，而不是foo外部的x。
> 兩個以上 function 都有作用域，但不同區域的同命變數實際上是不同的。
即使同名變數被宣告多次，但彼此之間沒有關係，都是獨立的變數。
```javascript
var scope = "全域";
function value1() {
  var scope = "區域1";
  return scope;
}
function value2() {
  var scope = "區域2";
  return scope;
}
console.log(value1()); //區域1
console.log(value2()); //區域2
console.log(scope); //全域
```
若無var宣告

```javascript
scope = '全域';
function getValue() {
    scope = '區域';
    return scope;
}
console.log(getValue()); //區域
console.log(scope); //區域
```
作用域還牽涉閉包(Closure)的問題，之後找時間研究做成一篇筆記。

