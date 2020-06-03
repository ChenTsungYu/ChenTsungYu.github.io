---
title: '[物件導向] 入門'
catalog: true
date: 2019/07/14 23:51:53
subtitle: "Basic Concept"
tags: OOP
categories: Frontend
---
<!-- toc -->
# 何謂物件導向?
## Def: 在控制程式時，以"物件"來包裝所有的邏輯跟操作

#### 假設情境:
將問題描述為物件，有兩個人分別為A、B，A要將香蕉拿給B，故物件有A、B、香蕉，物件也有屬性和行為，如A、B和香蕉的屬性為年齡、名字和價格，行為則為打招呼、走路和剝皮。
![](https://i.imgur.com/pEN2Hii.png)
以程式來看的話就會如上圖，A、B都是"實體"，並屬於"人"這個類別，今天A與B打招呼(A.打招呼())，A給B香蕉(A.給予(B,香蕉)，給予的動作傳入B和香蕉作為參數)，B去呼叫香蕉.剝皮()，最後B把香蕉吃掉(B.吃(香蕉))。
<!--more--> 
### 思考邏輯
根據類別產生物件，也就是先定義類別(人的概念)，在以人為基礎產生A、B兩物件，定義完類別及物件之後，再來執行操作方法，如呼叫A、B的物件屬性或方法來進行互動

### 類別(class) 
一個抽象概念，定義一件事物的抽象特點，包含事物的屬性和操作行為，無實體(**Instance**)概念。

### 物件(Object)
物件是類別的實例，也看的到、摸的到，屬於動態，狀態會隨時改變，但架構與行為不會改變。

### 案例: 票務系統
有一張票作為一物件，其中票的屬性就包含相關的票務資訊，如票種、價格、手續費等。另外票的方法指的是如何操作這張票(物件)，如購票、退票等等。

來看例子:
#### 一般寫法 
```javascript=
////  ticket的屬性
let ticket_price = 100;
let ticket_type = "student";
const ticket_discount = 0.3;
const ticket_fee = 30;

// ticket的方法
Function get_ticket_price(price, type,discount,fee){
    Return ticket_price * ticket_discount + ticket_fee 
}
Function get_ticket_description(price,type,discount, fee){
    console.log(“這張票是”+type+”票 有”+discount*10+”的折扣跟”+fee+”的⼿續費”)
}
```
#### 進階寫法(將物件進行打包)
```javascript=
////  ticket的屬性
var ticket = {
    price = 100,
    type = "student",
    discount = 0.3,
    fee = 30
}

// ticket的方法
Function get_ticket_price(ticket){
    Return ticket.price * ticket.discount + ticket.fee 
}
Function get_ticket_description(ticket){
    console.log(“這張票是”+ticket.type+”票 有”+ticket.discount*10+”的折扣跟”+ticket.fee+”的⼿續費”)
}
```

#### 物件導向寫法
開始著手實作之前，需先確定幾件事:
* 物件有哪些屬性
* 物件有哪些可⽤⽅法 
* 如何「產⽣」這個物件
確定完成後我們會先定義"類別"，再根據類別產生物件。
```javascript=
// 類別開頭通常都會設大寫
    var Ticket = function(初始值){ 
    this.屬性 = 初始值,
    this.方法 = function(){
      // 當中可用this.屬性或this.方法
      ....      
    }
}
```
**物件導向範例**

```javascript=
    var Ticket = function(init_price, init_discount){ 
    this.price = init_price 
    this.type = “student” 
    this.discount = init_discount 
    this.fee = 30 
    
    // ticket的方法
    this.get_price = function(){
         return this.price * this.discount + this.fee;
    }
    this.get_description = function(){
         console.log("這張票是"+this.type+"票 有" + this.discount*10 + "折扣共" + this.get_price() +"元");
    }
}    
```
上述範例中，class類別為Ticket，傳入兩個初始化參數(票價、折扣)，再做物件屬性的初始化設定。get_price、get_description分別做為取得票價及詳細資訊的方法。其中，this是參照物件本體的資訊。

定義好類別及物件之後，就可以開始產生物件。
#### 產生物件
```javascript=
    // 傳入票價、折扣
    var myTick = new Ticket(500,0.7)
    console.log(myTick.price); // 500
    console.log(myTick.type); // student
    console.log(myTick.get_price()); // 380
```

### 好處:
如果這物件是其他開發者建立的，我們不須管物件內複雜的邏輯，只需傳需要的參數給物件即可獲得想要的結果，這樣的方法稱作**封裝**,程式碼較直觀，且容易理解。

## 物件導向有幾個重要的特性:
* 封裝
* 繼承
* 多型
這篇只有先筆記**封裝及繼承的部分**
### 封裝(Encapsulation)
將物件屬性及複雜的操作邏輯包覆在class內，也就是將物件內部資料隱藏起來。按照前面的票務的例子，我們只需傳入特定的值，即可取得票價，不須了解票價如何做計算。

### 原型繼承(Inheritance)
雖然有了物件之後變得簡單易用，但是今天有多個物件要透過函數操作方法時，函數是獨立存在於各個物件，彼此無法共用。舉例來說，今天今天有三個人(物件)要互相打招呼，執行sayhello()這個function，會說出hello,某某某...，若要把sayhello()統一改為Hi,某某某...的話，要每個物件做修改會變得相當耗時。若要解決函數無法共用的問題，我們可以使用**prototype(原型)**，達成統一管理函數的目的，來看個例子:
```javascript=
    var Ticket = function(初始值){ 
        this.屬性 = 初始值
        this.方法....
    }
    
    //  原型繼承
    Ticket.prototype.方法 = function(){
        this.屬性
        this.方法....
    }
```
將某些要呼叫的方法放進prototype裡的東西**不會被複製進物件**，物件會有參考點連到prototype，找不到調用的屬性或方法時會往上找。來看下面的圖示:
![](https://i.imgur.com/BE4ioK0.png)
上圖中的Prototype獨立存在外面，假設產生A、B、C三個物件時，並不會有原型的function，若想在其中一個物件呼叫function時，發現該物件沒有被呼叫的function，便會往上找，找該物件的prototype，就找到呼叫的function。
**<注意>**
在prototype內一樣可以使用this.屬性或this.方法。

### 繼承-在類別之間的延續
在javascript內所指的繼承是指**類別**之間的繼承，
程式碼實作繼承的步驟:
1. 建立時呼叫類別: 初始化母類別屬性
2. 為子類別新增繼承prototype: 讓子類別可使用母類別的方法
3. 將建構函數指向自己: 將物件建構的函數指向最底層類別

#### 建立時呼叫類別: Parent.call(this,其他引數)
```javascript=
var Creature = function(...){
    this.attr = ...
}

var Dog = function(...){
    Creature.call(this, ....)
    this.attr = ...
}
```
#### 為子類別新增繼承prototype: Child.prototype = Object.create(Parent.prototype)
```javascript=
Dog.prototype = Object.create(Creature.prototype)
```
上述的`Object.create()`所代表的是建立一個空物件(**Dog.prototype**)，但是將該物件的上游連接到給定的Prototype。
![](https://i.imgur.com/MwLip1B.png)

#### 將建構函數指向自己
```javascript=
Child.prototye.constructor = Child.constructor
```
需要執行這個步驟的原因是，今天在定義類別(class)時，都會定義一個新的function，若只有建立一個空物件(Object.create.create)，funtion會往上游尋找constructor，也就是定義所產生的function，找不到時會繼續往上游找，以下圖為例，最終變成找生物的prototype來初始化物件。
![](https://i.imgur.com/gUuET1a.png)
所以將建構函數指向自己時就會變成狗產生的函數(建構子)等於自己的產生函數，避免往上游回溯到生物的產生函數
```javascript=
Dog.prototye.constructor = Dog.constructor
```

Codepen範例:
[Worker](https://codepen.io/chentsungyu/pen/qzGmNV?editors=1112)