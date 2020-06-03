---
title:  '[JavaScript] Date& Timer'
catalog: true
date: 2019/07/13 13:45:01
tags: JavaScript
categories: Frontend
---
<!-- toc -->
# 前言
定時器和倒數計時器所用到: ``Date()``、 `setTimeout()`和`setInterval()`這幾個方法來完成，算是蠻常用到的。

![](https://cdn-images-1.medium.com/max/2000/1*D_Iq3Q1yIBbnMO3hxxtNSQ.jpeg)
## `Date()`

`Date()`是JavaScript 原生的時間方法，它以國際標準時間(UTC)1970年1月1日00:00:00作為時間起點，**單位為毫秒**。
<!--more--> 
### 取得當前時間的方法:

可以作為一般函數直接呼叫，回傳當前時間
```javascript=
console.log(Date()); // Mon May 13 2019 09:32:21 GMT+0800 (台北標準時間)
```
> 即使帶有參數，Date作為普通函數使用時，返回的還是當前時間

```javascript=
console.log(Date(2019,5,13));  // Mon May 13 2019 09:32:21 GMT+0800 (台北標準時間
```
### new 方法
透過new 方法賦值給一變數，透過變數取得當前時間， **返回的是字串**。
```javascript=
var nowTime = new Date();

console.log(nowTime); // Mon May 13 2019 09:32:21 GMT+0800 (台北標準時間)
```
> `Date()`方法可接受多種格式參數，回傳一個該參數對應的時間

```javascript=
    // 参数為時間零點開始計算的毫秒数
    var nowTime = new Date(1378218728000)

    console.log(nowTime); // Tue Sep 03 2013 22:32:08 GMT+0800 (CST)
    
    // 参数為日期字串
    var nowTime = new Date('January 6, 2013');

    console.log(nowTime); // Sun Jan 06 2013 00:00:00 GMT+0800 (台北標準時間)
    
    // 参数為多個整数值，
    // 代表年、月、日、小時、分鐘、秒、毫秒
    var nowTime = new Date(2013, 0, 1, 0, 0, 0, 0)

    console.log(nowTime); // Tue Jan 01 2013 00:00:00 GMT+0800 (CST)
```
Date方法使用函數的參數，有幾點要注意:
> 只要是能被Date.parse()解析的字串，都可以當作參數

以下返回的都是同一個時間。
```javascript=
new Date('2019-5-13')
new Date('2019/5/13')
new Date('05/13/2019')
new Date('2019-May-13')
new Date('May, 15, 2019')
new Date('May 15, 2019')
new Date('May, 15, 2019')
new Date('May 15, 2019')
new Date('15 May 2019')
new Date('15, May, 2019')
// Mon May15 2019 09:32:21 GMT+0800
```

> 參數為年、月、日等多個整數時，年和月是不能省略的，其他參數都可以省略的。也就是說，至少需要兩個參數，因為如果只使用“年”這一個參數，Date會將誤為毫秒數。

下面程式碼中，2013被解釋為毫秒數，而不是年份
```javascript=
    new Date(2013)
    // Thu Jan 01 1970 08:00:02 GMT+0800
```
下面範例返回的都是2013年1月1日零點
```javascript=
    new Date(2013, 0)
    // Tue Jan 01 2013 00:00:00 GMT+0800 (CST)
    new Date(2013, 0, 1)
    // Tue Jan 01 2013 00:00:00 GMT+0800 (CST)
    new Date(2013, 0, 1, 0)
    // Tue Jan 01 2013 00:00:00 GMT+0800 (CST)
    new Date(2013, 0, 1, 0, 0, 0, 0)
    // Tue Jan 01 2013 00:00:00 GMT+0800 (CST)
```
重要的參數取值範圍，需特別注意**月份計算的起始點是0**
> 年：使用四位數年份，比如2000。如果寫成兩位數或個位數，則加上1900，即10代表1910年。如果是負數，表示公元前。
> 月：0表示一月，依次類推，11表示12月。
> 日：1到31。
> 小時：0到23。
> 分鐘：0到59。
> 秒：0到59
> 毫秒：0到999

### 參數如果超出了正常範圍，會被自動換算
```javascript=
    new Date(2013, 15)
    // Tue Apr 01 2014 00:00:00 GMT+0800 

    new Date(2013, 0, 0)
    // Mon Dec 31 2012 00:00:00 GMT+0800
    //   日期設為0，表上個月的最後一天

    參數還可以使用負數，表示扣去的時間
    new Date(2013, -1)
    // Sat Dec 01 2012 00:00:00 GMT+0800 

    new Date(2013, 0, -1)
    // Sun Dec 30 2012 00:00:00 GMT+0800 
```
## `get()`
除上述方法，還可以透過一系列get*方法，獲取特定時間， 且返回的都是**整數**:
> `getTime()`：返回當前時間距離1970年1月1日00:00:00的毫秒數
> `getDate()`：返回當前時間對應每個月的幾號（從1開始）。
> `getDay()`：返回星期幾，星期日為0，星期一為1，以此類推。
> `getFullYear()`：返回四位的年份。
> `getMonth()`：返回月份（0表示1月，11表示12月）。
>` getHours()`：返回小時（0-23）。
>` getMilliseconds()`：返回毫秒（0-999）。
> `getMinutes()`：返回分鐘（0-59）。
>` getSeconds()`：返回秒（0-59）。

範例:
```javascript=
<iframe src="https://medium.com/media/b98d1fb2ab2415601ae8fd733e890dde" frameborder=0></iframe>
```
## 時間設置的方法

### `set()`

一系列set*方法，用來設置當前時間。
> `setDate(date)`：設置當前時間對應的每個月的幾號（1-31），返回改變後時間(毫秒)。
> `setFullYear(year)`：設置四位年份。
> `setHours(hour)`：設置小時（0-23）。
> `setMilliseconds()`：設置毫秒（0-999）。
> `setMinutes(min)`：設置分鐘（0-59）。
> `setMonth(month)`：設置月份（0-11）。
> `setSeconds(sec)`：設置秒（0-59）。
> `setTime(milliseconds)`：設置毫秒時間。
# Timer
JavaScript提供定時的方法，可以設置定時器。

## `setTimeout()`
`setTimeout()`用來指定某個函數或某段code在多少毫秒之後執行。
`var timer = setTimeout(function|code, delay);`
> `setTimeout()`函數接受兩個參數，第一個參數function|code是將要延遲執行的函數名稱或一段code，第二個參數delay是延遲執行的毫秒數。 第二個參數如果省略，則默認為0。
```javascript=
    function test() {
      console.log(2);
    }
    
    setTimeout(test, 3000);   // 3秒後執行，輸出2
```
### ` clearTimeout()`
取消`setTimeout()`設的定時器。
### `setInterval()`
`setInterval()`函數的用法與setTimeout()完全一致，差別在於`setInterval()`可以無限次的設置定時器執行。
```javascript=
var timer = setInterval(function|code, delay)
```
### `clearInterval()`
取消`setInterval()`設的定時器。

>`setInterval()`可以無限次的設置定時器，所以`setInterval()`有重複設置的問題。
```html=
<iframe src="https://medium.com/media/d515060fcf7a2e27e7d7b4c74e49227c" frameborder=0></iframe>
```
上述的code會遇到點擊兩次`start`鈕時，`index+1`的時間會加快，點stop鈕無法停止的狀況。

解決辦法是設置if條件判斷:
```html=
<iframe src="https://medium.com/media/b04f24f869d003a1dd15a0dcc7acfa1d" frameborder=0></iframe>
```
將停止時鐘的函數在後面添加`timer=null`，表時鐘狀態為關閉，並且在點擊事件函數內的時鐘設置，多添加`if`條件判斷，確定時鐘狀態為`null`才能開啟時鐘，解決重複設置的問題。
## 實作一個倒數計時器
```html=
<iframe src="https://medium.com/media/c8c8068fc7c9b32c16d657964c6133a8" frameborder=0></iframe>
```
透過取得當前時間，以及設置結束時間兩者之間的差距，配合`setInterval()`來完成。
![](https://cdn-images-1.medium.com/max/2000/1*C7DYY7jUJJlwf_j5FVeJ1A.png)
[參考來源](https://wangdoc.com/javascript/async/timer.html#%E5%AE%9E%E4%BE%8B%EF%BC%9Adebounce-%E5%87%BD%E6%95%B0)1

[參考來源](https://wangdoc.com/javascript/stdlib/date.html)2
