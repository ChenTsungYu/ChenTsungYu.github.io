---
title: '[Vue.js] Basic'
catalog: true
date: 2019/07/14 21:50:17
tags: Vue
categories: Frontend
---
<!-- toc -->
# 什麼是Vue?
Vue 是一個前端框架(framework)，他的出現目的是為了更有組織性且簡化Web開發。在這之前其實有其他的框架，如Google所支持的Angular，或是Facebook所開發的React框架，不過Vue在社群的活絡程度不遜於前面兩者，是有潛力的一套framework。
**模板語法是** Vue 的主要特色，同時有雙向數據綁定的功能，採用MVVM的結構。
<!--more--> 
### 為何選Vue?
主要原因是簡單好上手，會基本的html、css、JavaScript就可以進行學習，再來是Vue需載入的檔案小，使用 Virtual DOM加快載入速度，網站載入不須花太多時間，。


### Vue主要分成三部分組成
-   Vue 模板
-   Vue 實例
-   Vue 組件

**模板:**
v-if、v-show、v-for....

**實例:**
data、methods、computed

**元件:**
Vue有元件的概念，將網頁上的區塊拆成一個個的元件(或叫組件)，最後將這些元件組合成一個網頁，就好比拼拼圖一般。

**個別詳細內容會記錄在下篇**

## 模板(Template)語法

Vue.js 使用基於HTML的模板語法，允許開發者使用聲明式將DOM綁定Vue實例的數據。Vue 將模板編譯成虛擬DOM，再渲染函數，Vue 能夠智能地計算出最少需要重新渲染多少組件，並把DOM 操作次數減到最少。

### 雙向綁定

雙向是指：HTML標籤數據綁定到Vue物件，另外反方向數據也是綁定的。Vue物件的改變會直接影響到HTML的標籤的變化，而且標籤的變化也會反過來影響Vue物件內屬性的變化，**改變是即時性的**。

## MVVM
![來源](https://i.imgur.com/DIFX23u.png)

由Model,View,ViewModel 三部分構成
### Model 層
代表資料模型，Model中定義資料修改和操作邏輯，簡單來說，我們獲取到的資料是一個JavaScript 的物件，透過Directives指令對DOM進行封裝。
### View 
代表UI組件，當資料發生改變時，對DOM進行監聽(DOM Listener)操作，從而回去修改**Model**的資料。

### ViewModel
是一個同步View 和Model的物件，可以將資料模型轉化成UI介面。

View 和Model 之間並沒有直接的聯繫，而是通過ViewModel做連結，Model 和ViewModel 彼此是雙向互動，同步工作完全是自動， 因此View 資料的變化會同步到Model中，而Model資料的變化也會立即反應到View 上。

## Virtual DOM
因為每次操作DOM的時候，頁面都必須要載入一次，使用者才能看到最新的頁面效果，但當有大量的 DOM 節點需要替換或更新的時候，這時網站載入效能的差距就會越來越明顯。

Virtual DOM透過以 JavaScript 物件模擬特定的 DOM tree結構，他會自動地去幫你處理這些瑣碎的事，再來他會去計算上一次 Virtual DOM 跟這一次的差異，兩者進行比較，最後把差異的部分處理後輸出到頁面的DOM上。
### <note>
Vue 採用的是**宣告式(聲明式)**的渲染。

如:
```JavaScript=
// 建立一個vue物件 (內部採JSON格式)
 const app = new Vue({
 el: "#app", // Vue 物件的掛載點
 // data 為存取的資料
 data: { // 可自行定義屬性名稱
 message:"hello",
 error: "error"
}

});

```
----

## Vue組件
![](https://i.imgur.com/1BjAZyJ.png)

一個組件由三個部分組成:
* html
* css
* js

#### 三者透過 webpack 進行打包，編譯成對應的檔案。
![](https://i.imgur.com/s132i1T.png)


## 安裝Vue:
1. 透過CDN
2. 透過npm
3. 通過Vue-cli腳手架

### 透過CDN
從[官方](https://cn.vuejs.org/v2/guide/installation.html)載入CDN到`<script>`標籤。

### 透過npm
`$ npm install vue`


### 透過腳手架[Vue-cli](https://link.jianshu.com/?t=https://github.com/vuejs/vue-cli)方法

在cmd切換到目標目錄，輸入 `npm install -g vue-cli`(3.x前版本)
下載官方版本   `vue init webpack`
執行`npm run dev`
詳細查閱這篇[教學](https://www.jianshu.com/p/611f638ed990)


[其他教學文](http://bluezyz.com/index.php/archives/111/)

# Vue CLI
Vue CLI 是一個基於Vue.js 進行快速開發的完整系統，
好處:
* 方便創建項目
* 部署方便
* 功能豐富
* 程式碼修改完畢後及時更新，直接預覽效果，不須手動更新
* 可單元測試

## [安裝操作](https://cli.vuejs.org/zh/guide/installation.html)
官方寫的很明確，唯一要注意的是，`npm install -g @vue/cl
`是安裝Vue3.0之後的版本


## [創建一個項目](https://cli.vuejs.org/zh/guide/creating-a-project.html#vue-create)

* vue create
選擇default使用官方設定的模板
* 使用圖形化界面(UI)

## 實作:
1. 在目標資料夾執行命令列`vue create qsyj`，建一名稱為qsyj的專案。
2. 到專案資料夾找index.html、main.js兩個檔案。
3. index.html檔內`<div id="app"></div>`為掛載點
4. main.js檔內 分別導入兩組件
![](https://i.imgur.com/n7qn7fp.png)
由上圖說明App組件從App.vue檔導入，並建一名為Vue的新物件，掛載在 **#app上**，對應至index.html檔的app掛載點。

### App.vue
專案的組件，組件由三部分組成:
* template: html     
* script: JavaScript
* style: CSS 

## 組件基本操作步驟:
1. 導入組件
2. 註冊組件
3. 使用組件

![](https://i.imgur.com/ZjrJ0Oo.png)

### 專案資料夾底下文件說明
* src: 放置組件&數據文件
* assets: 放置靜態文件
* component: 放置組件
好的開發方式: 先在component下建立新的資料夾，再新增對應組件。

### 移動端字體大小的解決方案:
透過rem依照畫面調整根元素字體大小，如根元素大小為16px，1rem = 16px，2rem = 32px.....
![](https://i.imgur.com/dDgRaDB.png)

### Vue Router
官方的路由管理器，安裝方式參考[官方](https://router.vuejs.org/installation.html#direct-download-cdn)。
[Vue Router官方文件(zh)](https://router.vuejs.org/zh/)
[Vue Router官方文件(en)](https://router.vuejs.org)
 
好用的UI library for Vue:
* Vant