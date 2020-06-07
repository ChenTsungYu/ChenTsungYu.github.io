---
title: "[JavaScript] DOM 操作"
catalog: true
date: 2019/07/21 13:45:01
tags: [JavaScript]
categories: [Frontend]
toc: true
---
<!-- toc -->
# 前言
這篇筆記先做一部分的 DOM 基礎操作，後續再慢慢補。

### BOM (Browser Object Model；瀏覽器物件模型)

是瀏覽器所有功能的核心，與網頁的內容無關。

早期各家瀏覽器廠商幾乎各自在自家瀏覽器上實作功能，沒有同一規範，非常混亂。後來 W3C 把各家瀏覽器都有實作的部分，進行整合納入 HTML5 的標準中，也就是 BOM 。
<!--more--> 
![[來源](http://mirlab.org/jang/books/javascript/domProp.asp?title=6-1%20DOM%20%AA%BA%A9%CA%BD%E8)](https://cdn-images-1.medium.com/max/2000/1*gy7ulJV3rMMzbHGOzpRv_w.gif)
[來源](http://mirlab.org/jang/books/javascript/domProp.asp?title=6-1%20DOM%20%AA%BA%A9%CA%BD%E8)

> BOM 的核心是 window 物件。

在瀏覽器裡的 window 物件提供兩個功能:

> ECMAScript 標準裡的「全域物件」 (Global Object)
> JavaScript 用來與瀏覽器溝通的窗口

更詳細的解釋保留在[這篇好文](https://ithelp.ithome.com.tw/articles/10191666)。

### DOM(文件物件模型；Document Object Model）

是 HTML、XML 和 SVG 文件的程式介面(API)。它提供了一個文件（樹）的結構化表示法，並定義讓程式可以存取並改變文件架構、風格和內容的方法。DOM 提供了文件以擁有屬性與函式的節點與物件組成的結構化表示---[MDN](https://developer.mozilla.org/zh-TW/docs/Web/API/Document_Object_Model)解釋。

另外，DOM 樹是由一個一個節點所構成，最上層的節點做 document， HTML 裡面每個元素、屬性都代表著其中一個節點。

> DOM 的 document 其實也是 window 物件的子物件之一，window 是 BOM 物件，而非 js 物件

![](https://cdn-images-1.medium.com/max/2000/1*LA6AXbzvC0IQ_d2H8v3NCw.gif)

DOM 標準被分成 3 個不同的部分組成：

- 核心 DOM — 對所有文檔類型標準模型

- XML DOM — 為 XML 文檔標準模型

- HTML DOM — 為 HTML 文檔的標準模式

### 除了根節點，其他節點都有三種層級關係:

> 父節點關係（parentNode): 該節點的上層節點
> 子節點關係(childNode): 該節點的下層節點
> 同級節點關係（sibling）: 與該節點同層的節點

### 節點通常分成以下幾種:

    Document:

    這份文件，也就是這份 HTML 檔的開頭，所有的一切都會從 Document 開始往下執行。

    DocumentType：doctype標籤（如<!DOCTYPE html>）

    Element:

    指文件內的各個標籤，因此像是 <div>、<p> 等等各種 HTML Tag 都是被歸類在 Element 裡面。

    Text:

    標籤包起來的文字，例: <h1>Hello World</h1> 中， Hello World 被 <h1> 標籤包起來，因此 Hello World 就是此標籤的 Text

    Attribute

    Attribute 就是指各個標籤內的相關屬性，如<a>標籤的href。

    Comment：註釋

    DocumentFragment：文檔片段

### 節點屬性有 3 種:

1.nodeType

2.nodeName( 屬性含有某個節點的名稱)

3.nodeValue

### nodeType

nodeType 屬性返回一個整數值，表示節點的類型。

不同節點有不同的 nodeType 屬性值:

    元素節點（element）：1

    屬性節點（attr）：2

    文本節點（text）：3

    文檔節點（document）：9

    註釋節點（Comment）：8

### nodeName

nodeName 屬性返回節點的名稱。

不同節點的 nodeName 返回的屬性值如下

    元素節點(element)：大寫標籤名

    屬性節點(attr): 屬性名稱(非大寫)

    文本節點(text)：#text

    文檔節點(document)：#document

    註釋節點（Comment）：#comment

### nodeValue

nodeValue 屬性返回一個字串，表當前節點本身文本值。

> 只有文本節點（text）、註釋節點（comment）和屬性節點（attr）有文本值， 其他類型的節點一律返回 null

    元素節點(element)：null

    屬性節點(attr): 屬性值

    文本節點(text)：文本內容

    文檔節點(document)：null

    註釋節點(Comment)：#comment

範例:

```javascript
// 元素節點
var oBox = $('box');

alert(oBox.nodeName); // DIV  // 注意大寫
alert(oBox.nodeType); // 1
alert(oBox.nodeValue); // null

// 屬性節點
var att = oBox.attributes[0]; // 獲取節點屬性
alert(att.nodeName); // id  // 注意小寫
alert(att.nodeType); // 2
alert(att.nodeValue); // box
})

<body>
    <div id="box">
        hello
    </div>
</body>
```

### textContent

> textContent 屬性返回當前節點和它的所有子節點的文本內容。
> textContent 屬性自動忽略當前節點內部的 HTML 標籤，返回所有文本內容。
> 在插入文本時，會將<p>標籤解釋為文本，而不會當作標籤處理。
```javascript
// HTML 
// <div id="divA">This is <span>some</span> text</div>

document.getElementById('divA').textContent
// This is some text
```
### firstChild

firstChild 屬性返回當前節點的第一個子節點，如果當前節點沒有子節點，則返回 null。

```javascript
// HTML
<p id="p1"><span>First span</span></p>

var p1 = document.getElementById('p1');
p1.firstChild.nodeName // "SPAN"
```

firstChild 返回的除了元素節點，還可能是文本節點或註釋節點。

```javascript
// HTML
<p id="p1">
  <span>First span</span>
</p>

var p1 = document.getElementById('p1');
p1.firstChild.nodeName // "#text"
```

### lastChild

lastChild 屬性返回當前節點的最後一個子節點，如果當前節點沒有子節點，則返回 null。用法與 firstChild 屬性相同。

## DOM 基本操作

> document.getElementById(‘idName’)

找尋 DOM 中符合此 id 名稱的元素，並回傳對應的元素， 這個方法只能在 document上使用，不能在其他元素節點上使用。。

> document.getElementsBytagName(‘tag’)

找尋 DOM 中符合此 tag 名稱的所有元素，並回傳對應的元素集合(HTMLCollection )，為 HTMLCollection 。

> document.getElementsByClassName(‘className’)

找尋 DOM 中符合此 class 名稱的所有元素，並回傳相對應的 element 集合，為 HTMLCollection 。

> document.querySelector(‘selector’)

document.querySelector 方法接受一個 CSS 選擇器作為參數，返回匹配該選擇器的元素節點。如果有多個節點滿足匹配條件，則返回第一個匹配的節點。如果沒有發現匹配的節點，則返回 null。

另外， querySelector 也可以用來選擇下一層的元素

```javascript
// HTML
<h1 id="titleId" class="titleClass"><b>123</b></h1>

// querySelector
document.querySelector('.titleClass b');  // 123
```

> document.querySelectorAll(‘selector’)

document.querySelectorAll 方法與 querySelector 用法類似，區別是返回一個 NodeList 集合，包含所有匹配給定選擇器的節點。

這兩個方法都支持複雜的 CSS 選擇器。

```javascript
// 選擇 data-foo-bar 屬性為 someval 的元素
document.querySelectorAll('[data-foo-bar="someval"]');

// 同時選擇 div，a，script 三個元素
document.querySelectorAll('DIV, A, SCRIPT');
```
### querySelector和getElementsByClassName 的比較

```javascript
// HTML
<ul class="view">
      <li>第一</li>
      <li>第二</li>
      <li>第三</li>
</ul>

// JS
var text =  document.querySelector(".view");
var text1 = document.getElementsByClassName('view');
var text2 = document.getElementsByTagName('h1');

console.log(text1);
console.log(text2); 
console.log(text);   
```

![](https://cdn-images-1.medium.com/max/2000/1*ydAvB7IqS3iZGM4T05dEWA.png)

上圖可知 getElementByTagName 和 getElementsByClassName 都是返回一個類似陣列的元素集合。

querySelector 系列的是 Static(靜態)的 node list，而 getElementsBy\*系列的返回的是一個 Live(動態) Node List。
```javascript
// Demo 1
var ul = document.querySelectorAll('ul')[0],
    lis = ul.querySelectorAll("li");
for(var i = 0; i < lis.length ; i++){
    ul.appendChild(document.createElement("li"));
}

// Demo 2
var ul = document.getElementsByTagName('ul')[0], 
    lis = ul.getElementsByTagName("li"); 
for(var i = 0; i < lis.length ; i++){
    ul.appendChild(document.createElement("li")); 
}
```
Demo 2 中的 lis 是一個動態的 Node List，每一次調用 list 都會重新對 document 進行查詢，導致無限循環的問題。
Demo 1 中的 lis 是一個靜態的 Node List，是一個 li 集合，對 document 的任何操作都不會對其產生影響。

### createElement()創建元素節點

如果需要修改內容或是設定屬性還需要用其他 DOM 操作，如:textContent、setAttribute。

```javascript
// 創建元素節點
var oTitle = document.createElement('h1')
oTitle.textContent = '你好' // 你好

// 添加元素到介面中: appendChild()
document.body.appendChild(oTitle);
```
### 用createElement 與 innerHTML 寫入文檔的比較:
    `createElement`:
    1.不會把原本的em所取代。
    2.方法：組完字串後,將語法傳入html進行渲染
    3.優點：效能較好
    4.缺點：資安風險，易引起腳本注入攻擊。

    `innerHTML`:
    1.會先將原有的內容全部刪除後再做新增
    2.方法：以DOM節點來處理
    3.優點：安全性較高
    4.缺點：效能較差

### getAttribute() 獲取節點屬性值

getAttribute()只返回字符串， 不會返回其他類型的值。

```javascript
// HTML
<div id="box" class="section" data-index="0" data-isShow="true">
   Test Statement
</div>

// 自定義屬性
oBox.tab = 10
// 獲取節點屬性
alert(oBox.tab)  // 10

// 獲取節點屬性的值
var att = oBox.attributes; // 獲取到: id="box" class="section" data-index="0" data-isShow="true"
alert(att['class'].nodeValue)  // section
alert(att['id'].nodeValue)  // box

// 獲取節點屬性:  getAttribute()
alert(oBox.getAttribute('data-index'))  // 0
```
### setAttribute() 創建屬性

.setAttribute()用於為當前元素節點新增屬性。如果同名屬性已存在，則相當於編輯已存在的屬性。

 > setAttribute(“屬性名稱”, “屬性內容”)

```javascript
var b = document.querySelector('button');
b.setAttribute('name', 'myButton');
```
### removeAttribute() 刪除屬性

.removeAttribute()移除指定屬性。
```javascript
// old HTML 
// <div id="div1" align="left" width="200px">
    document.getElementById('div1').removeAttribute('align');

// now HTML
// <div id="div1" width="200px">
```

### [來源](https://wangdoc.com/javascript/dom/node.html#nodeprototypefirstchild%EF%BC%8Cnodeprototypelastchild)1 [來源](https://ithelp.ithome.com.tw/articles/10191666)2 [W3C](https://www.w3schools.com/js/js_htmldom.asp)
