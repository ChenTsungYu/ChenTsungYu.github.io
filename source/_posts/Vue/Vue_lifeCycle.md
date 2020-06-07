---
title: '[Vue.js] Lifecycle Hooks'
catalog: true
date: 2019/07/17 21:50:17
subtitle: "Basic Concept"
tags: [Vue]
categories: Frontend
toc: true
---
<!-- toc -->

# [Vue生命週期](https://vuejs.org/v2/api/index.html#Options-Lifecycle-Hooks)
>每個 Vue 實體被創建之前，會經過一系列初始化的過程，同時會呼叫這些生命週期的掛鉤(hook)，我們可以在這些掛鉤上做額外的處理
<!--more--> 
## 流程
建立Vue物件 -> 初始化Vue資料 -> 編譯模板 -> 掛載DOM -> 更新數據 -> 渲染數據(mounted) -> 卸載數據。
圖片源: 官方文件
![官方](https://i.imgur.com/Nwormmf.png)
說明(**紅框表鉤子函數**):

### 細節
1. `new Vue()`: 在main.js檔有`new Vue()`這段code，即建立Vue的實例。
2. Init Event & Lifecycle: Vue內部初始化事件。
3. `beforeCreate`: 在實例初始化之後，數據觀測(data) 和event/watcher 事件配置之前被調用。
 
4. `Init injecttions&reactivity`: 初始化data、method
5. `created`:此時發起ajax請求，資料 `$data` 已可取得，但 `$el` 屬性還未被建立 
6. 先判斷是否有`el`選項，再判斷是否有`template`選項，接著準備生成html。
7. `beforeMount`: 此時尚未生成html到頁面上(還看不到頁面效果) 
8. `Create vm.$el`: 此階段做替換操作，將渲染好的html替換el屬性，也就是DOM的替換操作
9. `Mounted`: 此時完成掛載，即`$el` 被建立，只會執行一次

>後續掛載點會時時監控數據變化，若監測到數據變化，就會去更新DOM，做監聽操作，當中會執行兩個鉤子函數。

10. `beforeUpdate`：在更新DOM之前，資料變化時被呼叫，頁面此時尚改變，這裡適合在更新之前訪問現有的DOM，如手動移除已添加的事件監聽器。
11. `activated`：如果有設定 keep-alive，這個hook會被呼叫
12. `deactivated`：停用 keep-alive時被呼叫。
14. `updated`:更新數據完成
15. `beforeDestroy`：在銷毀之前，調用此函數，但此時尚未銷毀，實體還可使用。
16. `destroyed`：實體銷毀，所有綁定、監聽事件被移除。

### Note
所有的生命週期鉤子自動綁定this上下文到實例中，因此你可以訪問數據，對屬性和方法進行運算。這代表不能使用**箭頭函數**來定義一個生命週期方法 (例如created: () => this.fetchTodos())
