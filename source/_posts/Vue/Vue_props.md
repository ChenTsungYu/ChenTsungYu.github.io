---
title: '[Vue.js] Props - 父子組件間溝通'
catalog: true
date: 2019/07/20 21:50:17
subtitle: "Basic Concept"
tags: Vue
categories: Frontend
---
<!-- toc -->
# 前言
在 Vue中，每個組件都有單獨作用域，是各自獨立的，我們可以通過`prop` 由父組件向子組件傳遞數據，在組件上註冊的一些自定義屬性。當一個值傳遞給一個`prop`屬性的時候，它就變成了那個組件實例的一個屬性。[Ref](https://vuejs.org/v2/guide/components.html)
![](https://i.imgur.com/e2Rbhhg.png)
### 目的:
* 拆分個別的功能，並達到複用效果
* 避免內部元件改變外部元件
* 資料更集中，管理上更便利 
<!--more--> 
### 基礎範例:
Parent
```javascript=
<template>
  <div class="Parent">
    <child msg='parent here'></child>
  </div>
</template>

<script>
import Child from '@/components/Child';

export default {
  components: {
    Child,
  },
  name: 'app',
};
</script>
```
Child
```javascript=
<template>
  <div class="Child">
    <span>Message: { {msg} }</span>
  </div>
</template>

<script>
export default {
  props: {
    msg: 'child here'
  },
};
</script>
```
### camelCase vs. kebab-case 命名使用
HTML 不區分大小寫，而 JavaScript 是嚴格區分大小寫的，使用 HTML 模版時，屬性名稱必須使用以**dash**分隔的kebab-case命名，如範例`msg-parent`的屬性名稱。
```javascript=
<template>
  <div class="Parent">
    <child msg-parent='parent here'></child>
  </div>
</template>
```
若是使用JavaScript中的**字串模版**，則使用**camelCase**寫法，[參考此篇文章](https://www.itread01.com/article/1526520301.html)。
```javascript=
Vue.component('child', {
// 在 JavaScript 中使用 camelCase
props: ['myMessage'],
template: '<span>{ { myMessage } }</span>'
})
```
### 靜態、動態傳遞
兩者的差異在於處理傳遞資料型別，如果沒有使用動態，那就會全部資料型別視為`string`，而動態使用` v-bind `進行屬性綁定（簡寫為`:`），做動態賦值，將來會與 Vue Instance 結合，解析模版會當成 JavaScript 表達式做計算。
```javascript=
// 靜態
<post title="My journey with Vue"></post>

// 動態
<post v-bind:title="post.title"></post>

Vue.component('post', {
  props: ['title'],
  template: '<h3>{ { title } }</h3>'
})
```
### 父子組件溝通原則
![](https://i.imgur.com/iYRpbm4.png)
[圖片來源](https://dotblogs.com.tw/wasichris/2017/03/04/021726)
### 單項數據流
`props`是單項傳遞資料的，只會從**父層傳至子層**，並且`Prop`的值會隨父層更動設定而改變，避免子組件無意修改了父組件資料。
### $emit
若子組件要在資料異動時傳給父組件只能通過自定義事件: 使用`$emit("父組件要接收的參數",要發送的數據)`
### Prop 驗證
可以為props傳遞的資料指定型別。
```javascript=
export default {
  name: "child",
  data() {
      return{  }
  },
  // props: ['title', 'age'],
  props: {
    // 指定對應得類型
    title: String,
    age: Number,
    nick: String,
    nickName: {
      // 設定預設值   若父組件無傳遞值時即採用預設值
      type: String,
      default: "天籟歌手"
    },
    parent: {
      type: String,
      require: true
    },
    friends: {
      // 若預設值為陣列或物件，必須回傳一個function，
      type: Array,      
      default: function() {
        return ["Frank", "Tonny", "Jack"];
      }
    }
  },
  methods: {
    sendTarget() {
      // target 為自定義事件
      this.$emit("target", "流行歌手");
    }
  }
 }  
```
### 訪問子組件實例或子元素
通過**ref**特性為這個子組件賦予一個ID引用，有的時候你仍可能需要在JavaScript裡直接訪問一個子組件，直接做DOM操作。
定義這個ref的組件裡，可以使用
```javascript=
this.$refs.usernameInput
```