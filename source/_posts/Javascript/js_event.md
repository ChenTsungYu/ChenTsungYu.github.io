---
title: "[JavaScript] Event"
catalog: true
date: 2019/07/23 13:45:01
tags: JavaScript
categories: Frontend
---
<!-- toc -->
# 前言
這篇筆記關於Javascript事件操作的觀念。
JavaScript 是一個事件驅動 (Event-driven) 的程式語言。
# 什麼是事件驅動?
就是當瀏覽器載入網頁，開始讀取文檔(document)後，雖然馬上會讀取 JS事件相關的程式碼，但需等到「事件」被觸發(滑鼠點擊、按下鍵盤)後，才會再執行相應程式。
<!--more--> 
## Event Flow(事件流程)

一個事件發生後，會在子元素和父元素之間傳遞。傳遞分成三階段。我們可以觀察一下網頁元素接收事件的順序。
> 第一階段：從根結點window傳導到目標節點（上層傳到底層），稱為"捕獲階段"（capture phase）。
> 第二階段：在目標節點上觸發，稱為"目標階段"（target phase）。
> 第三階段：從目標節點傳導回window節點(從底層傳回上層），稱為"冒泡階段"（bubbling phase）。

## addEventListener() 事件監聽

用於綁定事件的監聽函數，可以利用addEventListener()來進行DOM的事件操作， 用於在當前節點或對象上面。
> .addEventListener(type, listener[, useCapture]);

這個方法中可傳入3個參數:

type：事件名稱，有區分大小寫。

listener：監聽函數。事件發生時，會呼叫該監聽函數。

useCapture：Boolean值，true: 事件捕獲 ; false: 事件冒泡。

## Event Propagation(事件冒泡)

當一個元素接收到事件後,會將接收到的事件往上傳給父元素,一直傳到頂端的根節點(document)。

來看個例子:

今天有3個不同顏色及大小的方格分別為紅(view1)、藍(view2)、紫(view3)，點擊view3(被包在最裡面)時，view2和view1和document也會同時被觸發。

![](https://cdn-images-1.medium.com/max/2000/1*1GJbh6Yz-hnrU8nhweWyfg.png)

示意圖:

![](https://cdn-images-1.medium.com/max/2000/1*6hbD3RSn01oncVVonIcznw.png)

觀察觸發的順序，可以發現由觸發事件節點由內而外，來比較一下相對於它的「事件捕獲」。

## Event Capturing(事件捕獲)

相對於「事件冒泡」，「事件捕獲」是從最外層，一層一層內方向傳遞事件，和「事件冒泡」相反。再使用一次剛剛的圖作範例XD

![](https://cdn-images-1.medium.com/max/2000/1*NhPPG0FKGDoNtr7Wo47TCQ.png)

實作的話可以用下方的程式碼:
```javascript
// HTML
<div id="view1">
     <div id="view2">
         <div id="view3">
         </div>
     </div>
</div>

// JS
oView1.addEventListener('click', function () {
  console.log('view1 --- 事件捕獲')          
}, true)
oView2.addEventListener('click', function () {
  console.log('view2 --- 事件捕獲')
}, true)
oView3.addEventListener('click', function () {
  console.log('view3 --- 事件捕獲')
}, true)
       // ---------------
oView1.addEventListener('click', function () {
  console.log('view1 --- 事件冒泡')
}, false)
oView2.addEventListener('click', function () {
  console.log('view2 --- 事件冒泡')
}, false)
oView3.addEventListener('click', function () {
  console.log('view3 --- 事件冒泡')
}, false)
```
點擊**view3**獲得的結果會是

![](https://cdn-images-1.medium.com/max/2000/1*1H-NyLd-F1Haoo9tXp4jQg.png)

## 事件傳遞流程

事件一開始從文檔的根節點流向目標對象(捕獲階段)，然後在目標對向上被觸發(目標階段)，之後再回到文檔的根節點。

![](https://cdn-images-1.medium.com/max/2000/1*n0kTZWKl13HFHXYAQwVmsQ.png)

### 如果今天不想要將事件傳遞到所有的父元素節點，那要如何阻止事件冒泡呢? 程式碼如下:
> 非IE: stopPropagation() ; IE: ev.cancelBubble = true;
> 兼容寫法: ev.stopPropagation ? ev.stopPropagation() : ev.cancelBubble = true;

我們可以在監聽事件的函數傳入一個ev做參數，作為事件來源。回到剛才例子，假設只想要讓事件從頂層傳遞到view2的話，可以在view2的事件監聽處打上上面那段程式碼。範例如下:

```javascript
// HTML
<div id="view1">
     <div id="view2">
         <div id="view3">
         </div>
     </div>
</div>

// JS
oView1.addEventListener('click', function () {
console.log('view1 --- 事件捕獲')
}, true)
oView2.addEventListener('click', function (ev) { 
  // 阻止事件冒泡
  ev.stopPropagation ? ev.stopPropagation() : ev.cancelBubble = true;
  console.log('view2 --- 事件捕獲')
}, true)
oView3.addEventListener('click', function () {
  console.log('view3 --- 事件捕獲')
}, true)
        //------------------------------
oView1.addEventListener('click', function () {
  console.log('view1 --- 事件冒泡')
}, false)
oView2.addEventListener('click', function () {
  console.log('view2 --- 事件冒泡')
}, false)
oView3.addEventListener('click', function () {
  console.log('view3 --- 事件冒泡')
}, false)
```

![所得結果](https://cdn-images-1.medium.com/max/2000/1*bbJKGqfIrZflUI_qfyw8Bg.png)所得結果

事件捕獲與冒泡都同樣適用。

## preventDefault 取消預設行為

可以取消HTML元素的預設行為 ，如 `<a>` 連結，或表單submit 等等， 如果我們需要在這些元素上綁定事件，但又不想要觸發它的預設行為，那**取消它們的預設行為**就是很重要的一件事。範例:有一個通往 yahoo連結 `<a>`:
```javascript
    <a id="link" href="https://tw.yahoo.com/">Google</a>
````

假設點擊這個 `<a>`時，我希望瀏覽器執行 `console.log('yahoo!')`; 那可以先註冊 click 事件
```javascript
    var link = document.querySelector('#link');
      
    link.addEventListener('click', function (e) { console.log('yahoo!'); }, false);
```

結果會發現，即便我們為了`<a>` 去註冊了 click 事件，但是當我點擊這個 link 的時候，瀏覽器依然會把我帶去 yahoo的網頁。

如果這時候，我希望執行的是` console.log('yahoo!')`; 而不是直接把我帶去 yahoo的網站，那麼可以怎麼做？

這時候可以利用 event 物件提供的 event.preventDefault() ：
```javascript
    var link = document.querySelector('#link');  

    // 在 evend function 加上 e.preventDefault(); link.addEventListener('click', function (e) { 
      e.preventDefault();   console.log('yahoo!');
     }, false);
```
再點擊 link 一次，你會發現瀏覽器預設的跳轉頁面的行為不見了，` console.log('yahoo!');` 也可順利執行。
> JavaScript 的 addEventListener() 裡，最後面加上 return false 也會有同樣的效果。
> 在 jQuery 的addEventListener() 裡最後加上 return false 來得到preventDefault() 與 stopPropagation() 的效果是沒問題的。

### 事件(event)對象:

當一個事件發生時,和當前對象發生的相關信息,都會臨時保存在這個對象中

### 事件源:

觸發該事件的來源節點，以下為兼容不同瀏覽器的寫法:
> IE: srcElement屬性
> firefox target屬性
> google/safari: srcElement、target都有

例子:
```javascript
// HTML
<input type="text" placeholder="帳號" id="user"><br />


 // JS
var oUser = $('user')
oUser.onkeydown = function (ev) {
// 按下哪個鍵? // 事件來源
ev = event || ev
  // 查找按下的鍵對應的code
console.log(ev.keyCode); // Enter對應的code是13 ; tab是9
}
```
使用keydown事件來觸發，我們可以傳入ev這個參數做**事件源，**根據使用者在鍵盤上輸入的鍵所輸出的數值，來確定使用者按下哪個鍵，例如輸入**enter，**輸出的數值就是**13，tab**鍵則是**9。**

舉個應用:
```javascript
// HTML
<div id="test"></div>

 // JS
var oTest = $('test')

oTest.onclick = function (ev) {
//  事件對象
ev = window.event || ev  // 事件源(滑鼠點擊位置)

// 滑鼠相對於'瀏覽器' 頁面的位置 -> client
alert(ev.clientX); // 水平方向(X軸)
alert(ev.clientY); // 垂直方向

// 滑鼠相對於'事件源'的位置 -> offset
alert(ev.offsetX); // 水平方向(X軸)
alert(ev.offsetY); // 垂直方向
}
```
![](https://cdn-images-1.medium.com/max/2000/1*WcdWuzKnXBmQr48VU5i9Wg.png)

點擊上面的紫色方形可以取得滑鼠相對於**瀏覽器**、**事件源**的位置。

## 元素節點的事件屬性

除addEventListener()方法外，元素節點的事件屬性，同樣可以指定監聽函數。
```javascript
    div.onclick = function (event) {
      console.log('觸發事件');
    }
```
### <note>
> “元素節點的事件屬性”的缺點:
> 同一個事件只能定義一個監聽函數。如果定義兩次onclick屬性，後一次定義會覆蓋前一次。
> 使用這個方法指定的監聽函數，也是只會在冒泡階段觸發
> EventTarget.addEventListener是比較推薦的指定監聽函數的方法，優點：
> 同一個事件可以添加多個監聽函數。
> 能夠指定在哪個階段（捕獲階段還是冒泡階段）觸發監聽函數。

## this 的指向

若是想要對「觸發事件的元素」做某些事時，可以使用this方法來達成。
```javascript
// HTML
// <button id="btn">點擊</button>

 // JS
var btn = document.getElementById('btn');

btn.addEventListener(
  'click',
  function (e) {
    console.log(this.id);  // 點擊按鈕以後輸出btn
  },
  false
);
```
    
