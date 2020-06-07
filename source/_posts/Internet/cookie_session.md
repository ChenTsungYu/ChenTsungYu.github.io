---
title: 'Session與Cookie差別'
catalog: true
date: 2019/07/14 19:23:10
tags: Session Cookie
categories: Internet
toc: true
---
<!-- toc -->
# 前言
其實這個疑問之前就存在很久，就去查資料了解一下，作為今天筆記對象，在記錄2者差異之前，要先了解為何需要這兩者，他們解決了什麼樣的問題?
# 什麼是http？
http本身是個**無狀態( Stateless)**的協議，可以在Client與Server兩端進行溝通，但是無法紀錄網路上的行為。一般而言，今天如果要登入一個網站，每次訪問該網站時，就需要將登入帳密再輸入一次， 或是現在頁面上的資料填到一半，不小心把網頁關掉，重開頁面只好再重新輸入一次，使用起來會非常不便。Cookie和Session因此誕生，解決無紀錄狀態的問題。
<!--more--> 
## Cookie

他不只是一塊小餅乾，而是一段由Server送給**使用者瀏覽器的一小塊資料(文檔)**。
**瀏覽器會儲存它**並且在瀏覽器下一次發送要求的時候將它送回原本送來的伺服器。
> Cookie就是用來繞開HTTP的無狀態性的「額外手段」之一

基本上，它是用來**區分兩個要求是來自同一個瀏覽器** — 以此去保持使用者的登入狀態。例如，它提供了保存狀態資訊的功能，來幫助HTTP這個無法紀錄狀態的通訊協定。

用實例說明的話就是我們平常逛網拍，要購買商品時都要登入會員資料，進入到登入介面，我們可以透過Cookie的方式紀錄之前輸入的帳號密碼，省去每次都要重新打帳密的不便， 只要Cookie尚未到期，瀏覽器會傳送該Cookie給伺服器作驗證憑據。這樣的方式已經解決大部分的問題。

由於這個Cookie設定值是儲存在使用者的電腦裡，我們可透過瀏覽器來檢測這個設定值是否儲存。操作如下:

開啟瀏覽器，輸入要查看網址，再點網址列前方的圖示，接著就會看到Cookie

![](https://cdn-images-1.medium.com/max/2248/1*bPGr0j4kg8RKhbuSEUQZrg.png)

點一下，進入後在允許的頁籤中，就會看到目前所儲存的Cooke值有那些。

![](https://cdn-images-1.medium.com/max/2000/1*D7rwKWO7RHry8fKxybcZFw.png)

點一下展開後，就可看到每個Cookie所記錄的值與內容，之後若找不到Cookie時，可以嘗試從這邊找看看。

![](https://cdn-images-1.medium.com/max/2000/1*V08tsI3kjrUuRt7WfJKptQ.png)

實作原理: client 端的程式在一旦填寫的資料有變動時，就把該資訊寫入 cookie。

**Cookie 由瀏覽器處理，具有兩個特性：**
> 特定網域：只針對原本的 網域(domain) 起作用。舉例: 在 *.myExample.com 存入的 cookie，不會出現在 *.not-myExample.com
> 有生命期限: 到了所設定的生命期限之後會失效。
> **在向該 domain 的 server 發送請求時，也會被一併帶進去該請求中**。

## **這麼好用的東西當然也有缺點**

cookie 雖然很方便，但是使用cookie 有一個很大的弊端，**cookie 中的所有數據在Client端就可以被修改**，數據非常容易被偽造，那麼一些重要的數據就不能存放在cookie 中了，而且**如果cookie中數據字段太多會影響傳輸效率**。為了解決這些問題，就產生了session，session 中的數據是保留在Server端。

## Session

Session 負責紀錄在 server端上的使用者訊息，會在一個用戶完成身分認證後，存下所需的用戶資料，接著產生一組對應的 **ID**，存入 cookie 後傳回用戶端。 Session泛指有始有終的系列動作/消息，好比會話一般。

試想 Cookie是一張領餐的號碼牌，而Session是一張數位會員卡， 記錄你的點餐號碼，還可以紀錄你的餐點細節，消費記錄和點餐喜好。，解決Cookie遺失的問題。

若今天替某個Client端的Request建一個Session的時候，Server會先檢查這個Client端的Request裡是否有包含了Session標識(Session id)，如果已包含一個Session id，表示這個發起Request的Client端是已經存放過的id，Server就按照Session id，把這個Session找出來使用。但如果Client端請求不包含Session id，，則表示他是新臉孔，那Server端就為此Client端創建一個Session，並生成一個Session id，並Response給Client端保存。

### 小結:

* session：帳號登錄驗證過後，Server端所發的識別證

* cookie：是瀏覽器**存放資料的地方**，可以存放seesion之類的資料

參考連結:
[**[不是工程師] 會員系統用Session還是Cookie? 你知道其實他們常常混在一起嗎？**
*「帥哥~你的早餐好了」，五分鐘概述網路界的記憶大神-Session*progressbar.tw](https://progressbar.tw/posts/92)
[**[不是工程師] Cookie 是文檔還是餅乾？簡述HTTP網頁紀錄會員資訊的一大功臣。**
*從淘寶到Airbnb，為何他們總能知道我們是誰呢？*progressbar.tw](https://progressbar.tw/posts/91)
[**介紹 Session 及 Cookie 兩者的差別說明**
*這幾年 SPA（Single Page App）當道，造就一個現象就是 Server-side 及 Client-side 壁壘分明。如果你是 Client-side 的開發者，可能沒什麼機會自己架一個 web…*blog.hellojcc.tw](https://blog.hellojcc.tw/2016/01/12/introduce-session-and-cookie/)
[**[爬蟲] 背景知識 " I try | MarsW**
*WWW(World Wide Web、Web) 是一個由許多通過網際網路存取而互相連結的 hypertext documents (常用HTML) 組成的系統。 而一個獨立的 WWW 頁面，我們...*tech-marsw.logdown.com](http://tech-marsw.logdown.com/blog/2015/03/15/crawler-basic-knowledge/)
