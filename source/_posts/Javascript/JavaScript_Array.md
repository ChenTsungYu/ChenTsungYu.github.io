---
title:  '[JavaScript] Array'
catalog: true
date: 2019/07/18 13:45:01
tags: JavaScript
categories: Frontend
---
<!-- toc -->
# 前言
JavaScript 的陣列可以看作是一種特別的「物件」，透過 typeof會返回陣列的類型是object。陣列是一組按次序排列的值， 放在裡面的東西稱為元素，每個元素都有其位置，稱為索引，找到索引值，就可以得知該位置元素的值。
* 陣列只能透過 [] 來存取
* 索引值從0開始排序，最後一個索引值為 **array.length-1**

陣列內可以是原始的資料類型、其他陣列、函式等等。
<!--more--> 
## 建立陣列的方式:

### 使用中括號[]
```javascript
var ary1 = []; //建立一個空陣列
var ary2 = [1,2,3]; //有3個元素的陣列，元素型別為number
var ary3 = [1,'a',true]; //陣列可放入不同型別的元素
var arr =[  //陣列中也可以包含陣列，稱作多維陣列
					["湯母","170cm","60kg",123456],
					["湯尼","180cm","80kg",1235456],
					["傑尼","175cm","70kg",456],
					["捷克","176cm","75kg",1256],
				]
var ary5 = [ {x:1,y:2},{x:3,y:4} ]; //陣列中也可以包含物件
```
### 透過 new 關鍵字來建立
```javascript
var a = new Array();

a[0] = "apple";
a[1] = "boy";
a[2] = "cat";
```
![](https://cdn-images-1.medium.com/max/2000/1*9krEIdEijCAnCNdpDr1dow.png)

## 判斷陣列
> 使用Array.isArray( )函式，依回傳true或false來判斷該物件是否為陣列
```javascript
var arr = [1, 2, 3, 4, 5, 6];
var obj = {
    x: 1,
    y: 2
};
console.log(Array.isArray(arr)); //true
console.log(Array.isArray(obj)); //false
```


### 陣列的存取
稱作**陣列實字(Array literal)** 
```javascript
var a = [];

a[0] = "apple";
a[1] = "boy";
a[2] = "cat";
a.length;     // 3
```

### <Note>
陣列與字串的比較:
```javascript
var str = 'Javascript';
console.log(str[1]); //a
console.log(typeof str); //string
console.log(Array.isArray(str)); //false
```
字串在JavaScript中似陣列，每個元素都可視為字元，所以能用中括號[ ]，透過索引值來讀取字串，但**實際類型依舊是string，而不是陣列**。
    
## 陣列方法(method)

### 排序

### sort( )

陣列中sort( )方法，會先將元素轉字串，再依據字串的Unicode編碼進行排序，會改變原陣列。**預設以字串形式去比較(首字比較)， 大寫排在前面** ，如果想不區分大小寫排序，可使用toLowerCase( )方法。

```javascript
// 比較字符串大小
var str1 = 'abcdefd'
var str2 = 'abbffda'
alert(str1 > str2)  // true  // 第3個字符 c>b 所以 str1比較大
```
> 若以數字方式去做sort( )排序，會得出非預期的結果
```javascript
arr = [2, 3, 17, 12, 32, 45, 13]

var temp = arr.sort()
console.log(temp);  // 12,13,17,2,3,32,45
```
> 解決方式: 使用一個比較的函式做為引數，來判斷元素的大小與排列順序
```javascript
arr = [2, 3, 17, 12, 32, 45, 13]
// 排序處理(將str 轉為 int) -> function處理
arr.sort(function(a,b) {
  return a - b  // 回傳值由小到大  //  [2, 3, 12, 13, 17, 32, 45]
  return b - a // 回傳值由大到小 //  [45, 32, 17, 13, 12, 3, 2]
})
console.log(arr);
```

### 特殊排序處理
採`parseInt()`
```javascript
arr1 = ['235px', '123px', '64px', '654px']
arr1.sort(function (a, b) {
  return parseInt(a) - parseInt(b)  // 64px,123px,235px,654px
  return parseInt(b) - parseInt(a)  // 654px,235px,123px,64px
}) 
document.write(arr1)
```

### 亂數排序的陣列
採`Math.random()`

```javascript
var arr2 = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
arr2.sort(function () { // 返回 true 或 false (交換或不交換)
  return Math.random() - 0.5;
  Math.random()為0-1的數  返回true 或 false
})
document.write(arr2) // 9,8,3,2,10,1,5,7,6,4
```

### 將陣列中元素的排列順序倒轉過來
採`reverse()`

```javascript
var ary = ['A', 'B', 'C', 'D'];
console.log(ary.reverse()); //["D", "C", "B", "A"]
console.log(ary); //["D", "C", "B", "A"]
```
### indexOf()

* indexOf(searchValue,fromIndex)

* searchValue: 檢索字串值(必填)

* fromIndex: 起始位置(選填)  默認值為: 0
> 搜尋陣列中是否有符合給定值的元素，若有，就回傳第一個符合元素的索引值；若無，回傳-1。
```javascript
var str4 = 'hello world!!!'  // 空格也須算入
console.log(str4.indexOf('o')); // 查找 'o' 首次出現的位置  // 4
console.log(str4.indexOf('o',5)); // 從第"5"個元素開始查找 'o' 首次出現的位置  // 7 
console.log(str4.indexOf('!!')); // 檢索多個字串 // 11
``` 

### 陣列的尾端添加一個或多個元素，並返回添加新元素後的陣列長度
 `push()`方法，**push()會改變原陣列**
```javascript
var arr1 = [];

arr1.push(1); 
arr1.push("a"); 
arr1.push(true, {});
console.log(arr1.push()); // 4  (陣列長度)
console.log(arr1);   // [1, 'a', true, {}]
```
### 刪除陣列的最後一個元素，並返回該元素。
`pop()`方法
```javascript
var arr = ["a", "b", "c"];

console.log(arr.pop());  // c
console.log(arr); // ["a", "b"]
```
> 對空陣列使用pop()方法，不會報錯，而是返回undefined。
```javascript
[].pop() // undefined
``` 
### 刪除陣列的第一個元素，並返回該元素。
`shift()`方法
```javascript
var a = ['a', 'b', 'c'];

console.log(a.shift());   // 'a'
console.log(a);   // ['b', 'c']
```

### 用於在陣列的第一個位置添加元素，並回傳添加新元素後的陣列長度， 可以接受多個參數。
`unshift()`方法
```javascript
var arr2 = [ 'c', 'd' ];

arr2.unshift('a', 'b') 
console.log(arr2.unshift()); // 4
console.log(arr2); //  ['a', 'b', 'c','d']
```
### 分割
`join()`'方法，( )內的參數表分割符號。若無參數，則以 `,` 做分割符號,並且轉為**string**
```javascript
var a = [1, 2, 3, 4];

a.join(' ') // '1 2 3 4'
a.join(' | ') // "1 | 2 | 3 | 4"
a.join() // "1,2,3,4"
```

如果陣列元素是undefined或null或空值，會被轉成空字串。
```javascript
[undefined, null].join('#') // '#'

['a',, 'b'].join('-') // 'a--b'
```   
### 合併
`concat( )` 方法，將2個以上的陣列與字串合併成新的陣列， 將新陣列元素，添加到原陣列的尾端， 回傳一個新陣列，原陣列不變。
```javascript
// 合併2個
var arr1 = ['a', 'b', 'c'];
var arr2 = ['d', 'e', 'f'];
console.log(arr1.concat(arr2)); //["a", "b", "c", "d", "e", "f"]

// 合併3個
var arr1 = ['a', 'b', 'c'];
var arr2 = ['d', 'e', 'f'];
var arr3 = ['g', 'h', 'i'];
console.log(arr1.concat(arr2, arr3)); //["a", "b", "c", "d", "e", "f", "g", "h", "i"]

// 合併字串、數字與陣列
var arr1 = ['a', 'b', 'c'];
var arr2 = ['d', 'e', 'f'];
var arr3 = ['g', 'h', 'i'];
console.log(arr1.concat(arr2, arr3, 'j', 'k', 1, 2));  //["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", 1, 2]

```
### 提取目標陣列的一部分， 回傳一個新陣列，原陣列不變
`slice()`
* arr.slice(start, end);
```javascript
var a = ["a", "b", "c"];

console.log( a.slice(0)); // ["a", "b", "c"]
console.log( a.slice(1)); //  ["b", "c"]
console.log(a.slice(1, 2)); //  ["b"]
console.log(a.slice(2, 6)); // ["c"]
console.log(a.slice());// ["a", "b", "c"] // 返回原陣列
```

上面例子，`slice()`第一個參數為起始位置（從0開始），第二個參數為終止位置（但該位置的元素本身不包括在內）。如果省略第二個參數，則回傳到原陣列的最後一個元素。
> 如果slice()的參數是負數，則表示倒數的位置，例: -1表示從倒數第一個元素開始
```javascript
var a = ['a', 'b', 'c'];
a.slice(-2) // ["b", "c"]
a.slice(-2, -1) // ["b"]
```
> 如果第一個參數大於等於陣列長度，或者第二個參數小於第一個參數，則回傳空陣列。
```javascript
var a = ['a', 'b', 'c'];
a.slice(4) // []
a.slice(2, 1) // []
```

### 字串的分割，並回傳陣列。
`split()`方法
* `split(sep,lenght)` sep做分割符; length: 指定回傳陣列最大長度

```javascript
'a|b|c'.split('|', 0) // []
'a|b|c'.split('|', 1) // ["a"]
'a|b|c'.split('|', 2) // ["a", "b"]
'a|b|c'.split('|', 3) // ["a", "b", "c"]
'a|b|c'.split('|', 4) // ["a", "b", "c"]

// split方法按照給定規則分割字串，返回一個由分割出來的子字串組成的陣列。
'a|b|c'.split('|') // ["a", "b", "c"]

// 如果分割規則為空字串，則返回陣列的元素是原字串的每一個字元。
'a|b|c'.split('') // ["a", "|", "b", "|", "c"]

// 如果省略參數，則返回陣列的唯一元素就是原字串。
'a|b|c'.split() // ["a|b|c"]

//如果滿足分割規則的兩個部分緊鄰著（即兩個分割符中間沒有其他字串），則返回陣列之中會有一個空字串。
'a||c'.split('|') // ['a', '', 'c']

// 如果滿足分割規則的部分處於字串的開頭或結尾（即它的前面或後面沒有其他字串），則返回陣列的第一個或最後一個成員是一個空字串。
'|b|c'.split('|') // ["", "b", "c"]
'a|b|'.split('|') // ["a", "b", ""]
```
### 顛倒字串方法
1. 轉為陣列 : 用 split('')
2. 陣列反轉
3. 拼接成字符串 : 可用join('')
```javascript
var str1 = '123456'
alert(str1.split('').reverse().join(''))
```

### 刪除原陣列的一部分元素
`splice()`方法，並可以在刪除的位置添加新的陣列元素， 回傳值是被刪除的元素，`splice()`**會改變原陣列**。

 `arr.splice(start, count, addElement1, addElement2, ...);`

> 第一個參數是刪除的起始位置（從0開始），第二個參數是被刪除的元素個數。如果後面還有更多的參數，則表示這些就是要被插入陣列的新元素。

* 從原陣列4號位置開始，刪除了兩個陣列元素。
```javascript
var a = ["a", "b", "c", "d", "e", "f"];

console.log(a.splice(4, 2)); // ["e", "f"]
console.log(a); // ["a", "b", "c", "d"]
```
* 除了刪除元素，還插入了兩個新元素。
```javascript
var a = ["a", "b", "c", "d", "e", "f"];

console.log(a.splice(4, 2, 1, 2)); //  ["e", "f"]  // 回傳被刪除的元素
console.log(a);  //  ["a", "b", "c", "d", 1, 2]
```
> 起始位置如果是負數，就表示從倒數位置開始刪除。
```javascript
    var a = ['a', 'b', 'c', 'd', 'e', 'f'];
    console.log(a.splice(-4, 2)) // ["c", "d"]
    //   從倒數第四個位置c開始刪除兩個元素。
```
> 如果只是單純地插入元素，splice()的第二個參數可以設為0。
```javascript
    var a = [1, 1, 1];
    console.log(a.splice(1, 0, 2)) // []
    console.log(a) // [1, 2, 1, 1]
```    
> 如果只提供第一個參數，等同於將原陣列在指定位置拆分成兩個陣列。
```javascript
    var a = [1, 2, 3, 4];
    console.log(a.splice(2)) // [3, 4]
    console.log(a) // [1, 2]
```
### 陣列的所有元素依次傳入參數函數
`map()`方法，**回傳**每一次的執行結果組成一個新陣列。

```javascript
var arr = [1, 2, 3, 4, 5, 6];

console.log(
   arr.map(function(x) {
      return x * x;
    })
);    // [1, 4, 9, 16, 25, 36]
	 
console.log(arr);  //  [1, 2, 3, 4, 5, 6]  //  不改變原先陣列
```

### `forEach()`

forEach()與map()很相似，也是對陣列的所有元素依次執行參數函數。但是，forEach方法不回傳值，只用來操作元素。

> forEach的用法與map方法一致，參數是一個函數，該函數同樣接受三個參數：當前值(Value)、當前位置(Index)、整個陣列(Array)。

```javascript
var ary = [1, 2, 3, 4, 5, 6];
var sum = 0;
ary.forEach(function(v) {
    sum += v;
 });
console.log(sum); //21
 
// a: 當前值  i: 當前位置(索引值) a: 整個陣列
ary.forEach(function(v, i, a) { 
   a[i] = v + 1;
});
console.log(ary); //[2, 3, 4, 5, 6, 7]  // 改變原始陣列
```

> forEach()無法中斷執行，會將所有元素都跑完。如果希望符合某種條件時就中斷遍歷，要使用for循環。

```javascript
var arr = [1, 2, 3];

for (var i = 0; i < arr.length; i++) {
  if (arr[i] === 2) break;
  console.log(arr[i]);
}
```

> forEach()不會跳過undefined和null，但會跳過空位。
```javascript
ar log = function (n) {
  console.log(n + 1);
};

[1, undefined, 2].forEach(log)
// 2
// NaN
// 3

[1, null, 2].forEach(log)
// 2
// 1
// 3

[1, , 2].forEach(log)
// 2
// 3
```
### <Note>
map( )和forEach()差異:
> map( )對執行參數函數方式跟forEach()一樣，差別在於map( )會回傳新陣列，不會修改原陣列。
> 如果陣列遍歷的目的是為了得到回傳值，那麼使用map()，否則使用forEach()。

### filter()
filter()用於過濾陣列元素， 將元素依序傳入回傳的函數中， 回傳滿足條件(運算結果為true)的元素所組成的一個陣列， 該不會改變原陣列。

```javascript
var test = [1, 2, 3, 4, 5];
test.filter(function(elem) {
  return elem > 3;
});  // [4, 5] // 返回大於3的元素所組成的新陣列
```

> filter()的參數函數可以接受三個參數：當前元素，當前位置和整個陣列
```javascript
    [1, 2, 3, 4, 5].filter(function (elem, index, arr) {
      return index % 2 === 0;
    });
    // [1, 3, 5] //   返回偶數位置的元素組成的新陣列。
```
### some()，every()

回傳一個 boolean值，表示判斷陣列中的元素是否符合某種條件。

兩者都接受三個參數：**當前元素、當前位置和整個陣列**，然後回傳一個**boolean值**。
#### some()方法
只要一個(以上)元素的回傳值是`true`，則整個`some()`的回傳值就是`true`，否則回傳`false`。另外，`some( )`會在第一次遇到運算結果為`true`時，就停止繼續對元素運算
```javascript
    var arr = [1, 2, 3, 4, 5];
    arr.some(function (elem, index, arr) {
      return elem >= 3;
    });  // true
    //   如果陣列arr有一個元素 >= 3，some()就回傳`true`。
```
####  every方法
所有元素的回傳值都是`true`，整個ever()才回傳`true`，否則回傳`false`
```javascript
    var arr = [1, 2, 3, 4, 5];
    arr.every(function (elem, index, arr) {
      return elem >= 3;
    });  // false
    //  陣列arr並非所有元素 >=3， every() 回傳 false。
```

[範例來源](https://ithelp.ithome.com.tw/articles/10204695)

[範例來源](https://wangdoc.com/javascript/stdlib/array.html#foreach)
