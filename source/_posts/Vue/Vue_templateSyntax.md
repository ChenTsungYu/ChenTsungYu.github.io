---
title: '[Vue.js] 模版語法'
catalog: true
date: 2019/07/16 21:50:17
tags: Vue
categories: Frontend
toc: true
---
<!-- toc -->
# 前言
筆記一下Vue的模板語法
### 模板語法 
Mustache: { {variable} }  只能用於單行語句 e.g. if-else，且雙大括號會將數據解析為一般文字

**由於Hexo解析"雙大括號"會發生錯誤，所以文章涉及"雙大括號"都會以`{ {} }`表示**
<!--more--> 
* 指令監聽DOM事件，並改變 data內的資料，
若傳入多個參數時，事件名稱需加上 $ 
* 陣列更新
append、unshift，注意陣列是返回原陣列，或是新陣列。
<Note> 
若改變原陣列，可使頁面更新。
若不改變原陣列，建一新陣列，則無法使頁面刷新。

## methods:
表示調用函數，呼叫函式需添加 "()"

## computed: 
計算屬性，亦可呼叫函數，但不須添加 "()"

## watch:



##  計算屬性 vs 方法
屬性的相關內容不持續變動時，建議使用computed，只在相關響應式依賴發生改變時它們才會重新求值，只要屬性的相關內容還沒有發生改變，多次訪問計算屬性會立即返回之前的計算結果，而不必再次執行函數。

## 表單輸入綁定
v-model 進行雙向數據綁定，輸入內容的同時，同步將數據更新到頁面上，重要修飾符:
.lazy
.number
.trim
## 資料渲染 v-text、v-html、`{ {} }`
透過模板語法直接將指令寫在html中
### `{ {} }` 使用{}將掛載的物件內容顯示出來
```htmlmixed=
 <div id="app">
    { { message } }
  </div>
```
```javascript=
var app = new Vue({
  el: '#app',
  data: {
    message: 'Hello Vue!'
  }
})
```
## `v-text`更新元素的`textContent`
```htmlmixed=
<div id="app">
    <p v-text="title"></p>
</div>
```
```javascript=
var app = new Vue({
  el: '#app',
  data: {
    title: "<h1>模板指令</h1>",
  }
})//  <h1>模板指令</h1>
```
## `v-html`更新元素的`innerHTML`
文字內容會套用html標籤的特性 
```htmlmixed=
<div id="app">
    <p v-text="title"></p>
</div>
```
```javascript=
var app = new Vue({
  el: '#app',
  data: {
    title: "<h1>模板指令</h1>",
  }
})// 模板指令
```
## 控制顯示、隱藏 `v-if` 、 `v-show`
**差別:**
若不顯示的話
`v-if` 則不進行渲染
`v-show` 元素始終會被渲染並保留在DOM中。v-show只是簡單地切換元素的CSS屬性display。
```htmlmixed=
<p class="show" v-if="isShow">模組的顯示、隱藏</p>

<p class="show" v-show="isShow">模組的顯示、隱藏</p>
```
```javascript=
var app = new Vue({
  el: '#app',
  data: {
    isShow: false,
  }
})
```
## 渲染循環列表 v-for
似for.. in 的JS方法，可用於陣列或物件，**良好的習慣是添加key屬性**，**key的作用主要是為了高效的更新虛擬DOM**，因為是根據key值去判斷某個值是否修改,如果修改,則重新渲染這一項,否則重複使用之前的元素;

```htmlmixed=
<ul>
    <li v-for="item in arr">
    { { item } }<!--調用item-->
    </li>
</ul>
```
```javascript=
var app = new Vue({
  el: '#app',
  data: {
    arr: ["1、html", "2、CSS", "3、JavaScript"],
  }
})
```
## 事件綁定v-on
事件綁定 v-on:event，搭配**method方法**，**event** 表示點擊後所觸發的事件
可用簡寫: ` @ ` 代替 ` v-on: `
```htmlmixed=
<div class="show" v-on:click="speak"></div>
<!-- 與上方相同   -->
<div class="show" @click="speak"></div>
```
```javascript=
var app = new Vue({
  el: '#app',
  methods: { // 方法
     speak: function() {
         alert("hello");
        }
    }
})
```
## 屬性綁定`v-bind`
v-bind: 綁定
綁定的目標為`標籤屬性`，為一物件，往後只需要修改變數的值即可，`<標籤 v-bind:屬性名="要绑定Vue物件的data內的屬性名"></標籤>`
由於v-bind使用非常頻繁，所以Vue提供了簡單的寫法，簡寫:  **:**  代替`v-bind:`

```htmlmixed=
<img src="angry_25.jpg" v-bind:src="imgName" alt=""   style="width: 200px; height: 200px;"/>

<!--兩者相同-->

<img src="angry_25.jpg" :src="imgName" alt="" style="width: 200px; height: 200px;"/>
```
```javascript=
var app = new Vue({
  el: '#app',
  data: {
    imgName: "angry_18.jpg", // 圖片名稱
  }
})
```
## `樣式`綁定` v-bind `
Vue專門加強了class和style的屬性的綁定。可以有複雜的物件綁定、陣列綁定樣式。
```htmlmixed=
<div class="view" v-bind:class="{active:isActive}">
{ {message1} }
 </div>
 <!--
 <div class="view"> 樣式綁定 </div>
 -->
```
```javascript=
// isActive為真， 即 添加class名稱給該div
// isActive為假，不 添加class名稱給該div
var app = new Vue({
  el: '#app',
  data: {
    message1: '樣式綁定',
    isActive:false
  }
})
```
## 雙向數據綁定 `v-model`
上面的例子基本都是**單向**的js物件向HTML進行綁定，Vue提供了一個新的指令：`v-model`**進行雙向數據的綁定。**
```htmlmixed=
<div id="app">
 <input type="text" v-model="title">
 <p>{ {title} }</p>
 </div>
```
```javascript=
// 雙向數據綁定
const app = new Vue({
    el: "#app",
    data: {
    title: "Vue入門"
     }
});
```

#### 原理:
輸入框input(v-model)內發生改變，會同時去改變 **title屬性**

## Vue組件中重要選項

### data數據
代表vue物件的數據，創建的Vue物件中的**data屬性就是用來綁定數據到HTML的**，Vue框架會自動監視data裡面的數據變化，自動更新數據到HTML標籤上去。
```htmlmixed=
<div id="app">
    { { message } }
</div>
```
```javascript=
var app = new Vue({
    el: '#app',
    data: {  // data數據選項
      message: 'Hello Vue!'
    }
 })
```
### methods方法
代表vue物件的方法，不過要注意的是**這個方法自動綁定`this`**
```htmlmixed=
<div id="app">
    <div class="test" @click="run"></div>

    <div class="test" @click="speak"></div>
</div>
```
```javascript=
var app = new Vue({
    el: '#app',
    methods: { // 方法選項
     run: function() {
        alert("button1");
       },
     speak: function() {
        alert("button2");
      },
     add: function() {
         // 訪問data(數據選項)中的內容
         this.i++;
         console.log(this.i); 
    }
 })
```
### computed計算屬性
**計算屬性，屬性可以是一個方法**
在計算屬性中定義的函數裡面可以直接使用`this`。
**注意:**
採用`return`回傳值到`{ {expression} }`中
```htmlmixed=
<div id="app">
     <div class="test" @click="add">
        { { strFn } }
     </div>
</div>
```
```javascript=
computed: {
 // 計算屬性(方法)
 strFn: function() {
  if (this.i <= 5) {
     return "多點幾次";
    } else if (this.i <= 10) {
     return "再多點幾次";
    } else if (this.i <= 15) {
     return "再比之前多點幾次";
    } else if (this.i <= 20) {
     return "目前點很多次";
    }
}
```
## watch監聽選項
設定物件的**監聽方法**，用於監聽數據變化，針對**data內的屬性**進行監聽，不過不適合用於複雜的計算邏輯。
```htmlmixed=
<div id="app">
     <div class="test" @click="add">
        { { strFn } }
     </div>
</div>
```
```javascript=
const app = new Vue({
    el: "#app",
    data: {
        i:0
     },methods: { // 方法選項
         add: function() {
         // 訪問data(數據選項)中的內容
         this.i++;
         console.log(this.i); 
    },
    watch: { // 監聽屬性
         // 針對data內的屬性進行監聽
         // 傳入兩個參數，分別為新的值和舊的值
        i: function(newValue, oldValue) {
            console.log(newValue, oldValue);
        }
    }
});
```










