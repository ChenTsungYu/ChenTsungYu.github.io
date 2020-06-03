---
title:  '[JavaScript] ES6 Syntax'
catalog: true
date: 2019/07/29 13:45:01
tags: JavaScript
categories: Frontend

---
<!-- toc -->
# 前言
筆記一下這陣子學的一些 ES6 語法
## template literal（模版字串）
模板字符串使用反引號(``)來代替普通字符串中的用雙引號和單引號。模板字符串可以包含特定語法（${expression}）的佔位符。--[MDN](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/template_strings)

使用模版字串可以讓 code 用更優雅的方式來表示，以下做比較。
<!--more--> 
傳統字串拼接

```javascript
const name = "Bob";
const lastName = "sanders";
const age = 25;
const arr = document.querySelector("#test");

const dialog =
  "My name is " + name + "" + lastName + ". And I'm " + age + " years old";
```

模版字串寫法，省略許多 " + " 號，**\${}**內可放入變數

```javascript
    const dialog = My name is ${name} ${lastName}.And I'm ${age} years old;
```

除此之外，還可以套用標籤，可以

```javascript
arr.innerHTML = `<h1> My name is ${name} </h1>`; // 輸出 具<h1>標籤特性的文字
```

## Destructure(解構)

ES6 允許按照一定規則，從陣列和物件(object)中提取值，對變數進行賦值，這被稱作解構。範例參考來源: [MDN](https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Operators/Destructuring_assignment)

### 陣列的解構賦值

> 可以從陣列中提取值，按照對應位置，對變數賦值。

```javascript
ES5
    let a = 1;
    let b = 2;
    let c = 3;**

   ES6
    let [a, b, c] = [1, 2, 3];

    // 變數聲明並賦值時的解構
   var foo = ["one", "two", "three"];

    var [one, two, three] = foo;
    console.log(one, two, three); // "one"
```

#### 對陣列使用嵌套的方式進行解構

```javascript
let [foo, [[bar], baz]] = [1, [[2], 3]];
console.log(foo, bar, baz); // 1 2 3
```

#### 忽略某些返回值

```javascript
let [, , third] = ["foo", "bar", "baz"];
console.log(third); // "baz"

let [x, , y] = [1, 2, 3];
console.log(x, y); // 1 3
```

#### 解析一個從函數返回的陣列

```javascript
function f() {
  return [1, 2];
}

var a, b;
[a, b] = f();
console.log(a, b); // 1 2
```

#### 交換變數

```javascript
var a = 1;
var b = 3;

[a, b] = [b, a];
console.log(a, b); // 3 1
```

> 當解構一個陣列時，可以使用剩餘模式，將陣列剩餘部分賦值給一個變數

```javascript
let [head, …tail] = [1, 2, 3, 4];
console.log(head) // 1
console.log(tail) // [2, 3, 4]
```

#### <Note>

如果解構不成功，變數的值就等於 undefined

```javascript
let { foo } = { bar: "baz" };
console.log(foo); // undefined
```

### 物件的解構賦值

除了上述的陣列，還可以解構物件
起手式

```javascript
let { foo, bar } = { foo: "aaa", bar: "bbb" };
console.log(foo); // "aaa"
console.log(bar); // "bbb"
```

> 通過解構，無需聲明即可賦值一個變數

```javascript
({ a, b } = { a: 1, b: 2 });
console.log(a, b); // 1 2

// 如同
var { a, b } = { a: 1, b: 2 };
```

> 從一個對像中提取變數並賦值給和物件屬性名不同的新的變數名

```javascript
let o = { p: 42, q: true };
let { p, q } = o;

console.log(p, q); // 42 true
```

> 物件可賦值給另一物件相同的屬性名

```javascript
const person = {
  name: "Tom",
  lastName: "Chen",
  age: 25
};

// ES5
const name = person.name;

const lastName = person.lastName;

// ES6
const { name: firstName, age: old } = person;

console.log(firstName, old); // Tom 25
```

> 默認值: 物件的變數可以先賦予默認值。當要提取的物件沒有對應的屬性，變數就被賦予默認值。

```javascript
var { a = 10, b = 5 } = { a: 3 };

console.log(a); // 3
console.log(b); // 5

// 也可以給新的變量命名並提供默認值
var { a: aa = 10, b: bb = 5 } = { a: 3 };

console.log(aaㄝ, bb); // 3  5
```

### <note>

物件的解構與陣列有一個重要的不同:

> 陣列的元素是按次序排列的，變數的取值由它的位置決定；而物件的屬性沒有次序，變數必須與屬性同名，才能取到正確的值。

### 物件可作為函數參數傳入同個屬性名的值

```javascript
    const person = {
      name: "Tom",
      lastName:"Chen",
      age:25
    }

    function sayName({*name*, *lastName*}) {
       console.log(name, lastName);  // Tom Chen
    }

    sayName(person);
```

> 以函數回傳一個物件，將屬性名賦值給另一個物件相同的屬性名

```javascript
function getPerson() {
  return {
    name1: "Bob",
    lastName: "Chen",
    age: 21
  };
}

const { name1, age1 } = getPerson();
console.log(name1, age1); //  Bob 21
```

## Arrow function(箭頭函式)

ES6 允許使用**箭頭(=>)**定義函數，箭頭函數省略了 ES5 的 function 這個關鍵字，讓 code 更簡潔。

> 參數如果只有一個可以省略小括號。函數執行的 code 執行只有一行可省略 return

```javascript
var f = v => v;

// 等同
var f = function(v) {
  return v;
};
```

> 如果箭頭函數**不需要參數**或**需要多個參數**，就使用一個圓括號代表參數部分。

```javascript
var f = () => 5;
// 等同
var f = function() {
  return 5;
};

var sum = (num1, num2) => num1 + num2;
// 等同
var sum = function(num1, num2) {
  return num1 + num2;
};
```

> 如果箭頭函數直接返回一個**object(物件)**，必須在對像外面加上`{}`大括號

     參數為一物件時

    const obj = () => ({ name: "bob", age: 25 });

    const person = obj();

    console.log(person);  {name: "bob", age: 25}

    [Top](#6bb4) [template literal](#b48d) [Destructure](#14e7) [Arrow function](#ade1) [rest&spread operator](#c6e9) [bottom](#1fdc)

## rest operator(其餘運算子)&spread operator(展開運算子)

在 ES6 中，新增了一個 “…” 的關鍵字， “…” 的關鍵字依據使用時機點的不同而功能有所不同，主要分為: rest operator(其餘運算子)&spread operator(展開運算子)

### 摘要

- 兩個運算子符號都是三個點(…)
- 都是在陣列值運算
- 一個是展開陣列中的值，一個是集合其餘的值成為陣列

### spread operator(展開運算子)

把一個陣列展開成個別的值，就是把原先陣列內的值一個一個拆解。展開運算子有幾個特性:

> 淺層複製: 陣列與物件相同都有著傳參考的特性。若把陣列賦予到另一個值上，修改其中一個另一個也會跟著變動(連帶責任 XD)。

#### 傳統方法
```javascript
    const random = ["txt1", "text2"];
    const more = random;
    more[0] = "new";

    console.log(random);  ["new", "text2"] // 改變原始陣列
    console.log(more);  ["new", "text2"]
```
###展開運算子寫法:
```javascript
    const numbers = [1, 2, 3, 4];

    const value = [...numbers];

    console.log(value);  [1, 2, 3, 4]

    value.push(5);

    console.log(numbers);    [1, 2, 3, 4]  // 不改變原始陣列

    console.log(value);  [1, 2, 3, 4, 5]
```

### 類陣列轉成純陣列
JavaScript 中有許多披著陣列的外皮，但卻不能使用陣列方法處理的類陣列。
```javascript
const list = document.querySelectorAll(".list-item");
console.log(list); // NodeList(3) [li.list-item, li.list-item.special, li.list-item]

const special = list.filter(item => item.classList.contains("special")); // NodeList(3) 無法用陣列處理
console.log(special); // list.filter is not a function
```
### 使用展開運算子將類陣列轉成純陣列
```javascript
const list = [...document.querySelectorAll(".list-item")];
console.log(list); //  [li.list-item, li.list-item.special, li.list-item]

// 過濾出有special這個 class名稱的元素
const special = list.filter(item => item.classList.contains("special"));

console.log(special); // [li.list-item.special]
```
### 合併陣列
傳統兩個陣列合併用 `concat()`
```javascript
// 合併陣列  傳統寫法
const names = ["John", "Peter", "Bob"];
const moreName = ["Susy", ...names];

const namesAll = names.concat(moreName);

console.log(even); // ["John", "Peter", "Bob", "Ken", "Susy", "John", "Peter", "Bob"]
```
### 展開運算子可以有一樣的效果，code 的可讀性更高
```javascript
const names = ["John", "Peter", "Bob"];
const moreName = ["Susy", ...names];
const namesAll1 = [...names, ...moreName];

console.log(namesAll1); // ["John", "Peter", "Bob", Susy","John", "Peter", "Bob"]
```
### 轉變字串為單字串的陣列
```javascript
    const letters = "hello there";
    const arr = […letters];
    console.log(arr);  ['h', 'e', 'l', 'l', 'o', ' ', 't', 'h', 'e', 'r', 'e']
```
### 可以用來把某個陣列展開，然後傳入函式作為傳入參數值
```javascript
function add(num1, num2, num3, num4) {
        let result = num1 + num2 + num3 + num4;
        return result;
      }

// const result = add(numbers);  // 1,2,3,4 undefined undefined undefined
// 把陣列中的元素取出並相加
const result = add(...numbers); // 10
console.log(result);
```
### 其餘運算子（rest operator）
其餘運算字會把輸入函式中的參數值變成陣列的形式，Function 接受的參數數量不固定，可在參數前面加上” … ”，並使用陣列的方法(`forEach`、`map`、`reduce`) 。
```javascript
function sum(...args) {
      console.log(args); // (5) [1, 2, 3, 4, 5]

        let result = args
          .filter(item => item > 3)
          .reduce((acc, curr) => {
            acc += curr;
            return acc;
        }, 0);
    console.log(result); 
}
sum(1, 2, 3, 4, 5); // 9
```
> 如果 function 有先定義別的參數，就會將傳入的參數值先給定義好的參數，剩下的就全部填入其餘參數。
```javascript
function restArr(x, y, ...others) {
  console.log("x",x);  // x： 1
  console.log("y",y);  // y： 2
  console.log("others",others);  // others： [3, 4, 5]
}

restArr(1, 2, 3, 4, 5);
```
### <note>
其餘參數必須是函式內參數的「最後一個」。如果放在其餘的參數前，就會產生錯誤。
參考來源: [ECMAScript 6 入門](http://es6.ruanyifeng.com/) 、 [MDN](https://developer.mozilla.org/zh-CN/)
