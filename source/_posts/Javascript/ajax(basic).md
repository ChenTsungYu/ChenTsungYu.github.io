---
title: '[JavaScript] Ajax'
catalog: true
date: 2019/07/14 17:23:10
tags: [JavaScript]
catagories: [JavaScript]
toc: true
---
<!-- toc -->

筆記Ajax前，要先理解網站的主從架構：**客戶端和服務器端**

**客戶端(Client-side)**： 指訪客的電腦和瀏覽器

**伺服器端(Server-side):** 回應客戶端請求為伺服器端

舉個例子，今天當使用者用瀏覽器連線上你的 ISP (網路供應商 e.g. 中華電信)造訪網站(對網站提出請求)，將網站伺服器上的資料及程式碼下載到本地端(使用者電腦)，並在瀏覽器上做呈現。
<!--more--> 
下面畫張圖表做說明:

![](https://cdn-images-1.medium.com/max/2000/1*OsTQPteXu29VzIWQhv4MgQ.png)

好，現在知道造訪網頁的過程中會發生什麼事情之後，要了解要如何跟Server拿資料，發送Request。

用Javascript寫網頁的時候，可以發現Javascript是***一行一行執行***，這樣的特性稱作”**同步**”。
> 同步的意思是Javascript執行到某一行的時候，會等這行執行完畢，才執行到下一行，確保執行順序。

換句話說，當今天Javascript發出一個Request時，會等待Response回來，在回來之前，Javascript引擎是不會做任何動作的！

問題來了，牽涉到網路操作時，當網路上有多個請求，如果還是維持同步的方式執行程式碼，要接收到上一個Response才能送出下一個Request

可以預期到變得非常耗時間，不穩定的操作就需要用到”非同步”的方式。

### **非同步是什麼意思呢？**

就是執行完之後就不管它了，不等結果回來就繼續執行下一行。

舉個例子：

今天要去一間小吃店吃飯，點完餐後在菜單上寫下自己所在的桌號，將菜單交給櫃台(發送請求)讓老闆知道你坐哪一桌，點餐完畢不需要站在店門口等餐點做好(不用等Response)，可以回到自己位置做自己的事(發出其他Request)，老闆自動把做好的餐點送過來(Response回來)。

最後我們就需要透過ajax操作來達到非同步的目的！

## 什麼是 Ajax？

全名是「**Asynchronous JavaScript and XML**」, 翻譯：Javascript對XML(註)的異步請求操作。

重點在於＂Asynchronous＂這個字，實現＂非同步＂的操作獲取數據內容。

另外，server端傳輸90%會是JSON格式的檔案，下面程式碼會用JSON檔做例子（點此[連結](https://www.json.cn/wiki.html)參考解釋JSON）

我們可以透過 **透過XMLHttpRequest**遠端撈別人的資料。

過程:

1. 打開瀏覽器 -> 創建對象: XMLHttpRequest()

2. 輸入網址 -> open()方法

open()需帶入3個參數:

a. 方法(method): get/post

b. url

c. async(異步)

3.enter(發送request) -> send()

4.接收數據 request.onreadystatechange = function（）

參數：是傳遞給服務器的具體數據，例如登入的帳號密碼；

常用請求方式: get/post

### get請求：

在請求URL(網址)後面以＂?＂的形式跟上發給服務器的參數，多個參數之間用&隔開

? 後面跟的是要傳給server的參數

& 參數之間的間隔

### post 請求：

發給服務器的參數全部放在請求體中（URL 中看不到）

【注：post 傳遞的數據量沒有顯示，具體得看服務器的處理能力】

#### [Http請求報文](http://laichuanfeng.com/reading/parts-of-http-message/)分3部分

1.請求行 2.請求頭 3.請求體

*readystate屬性:

Ajax請求返回的數據即存放在該屬性之下(返回字串)

0: 初始化,還沒調用open()方法

1: 載入,已調用send()方法,正在發送request

2: 載入完成,send()方法完成,已收到全部response(響應內容)

3. 解析,正在解析response(從server端返回的數據)

4.完成,response響應內容解析完成,可在client端調用

### status: server狀態(http的狀態碼):

可從開發者工具觀看

![](https://cdn-images-1.medium.com/max/2720/1*1ZBcR0v4sGJE69XykLKFWA.png)

1開頭: 消息類

2開頭: 成功類

3開頭: 重定向類

4開頭: (client端)請求錯誤類 ex: 404

5開頭: 伺服器(server)錯誤類

以下程式碼進行操作說明：

```javascript=
<script>
        document.onclick = function () { // 點擊網頁發起ajax請求

            // 創建請求對象  向XMLHttpRequest 撈資料
            var request = new XMLHttpRequest() 

            // 設置請求 
            request.open('GET', 'JSON1.json', true) // True表異步操作

            request.send() // 發送請求

            // onreadystatechange (當readystate改變時觸發)
            request.onreadystatechange = function () {
                    // response解析完成
                if (request.readyState == 4) { 
                         // 請求到數據
                    if (request.status == 200) { 
                            // 200 -> success
                        document.write(request.response)

                        // 數據轉為json對象(object) -> json數據解析
                        var jsonData = JSON.parse(request.response)

                        // 獲取key(people) 內的陣列
                        var people = jsonData.people
                        
                        // 渲染
                        var oUl = document.createElement('ul')
                        for (var i = 0; i < people.length; i++) {
                                
                            var oLi = document.createElement('li')
                            
                            // 對每個people下的object找對應的key(firstName)進行渲染
                            oLi.innerHTML = people[i].firstName;
                            oUl.appendChild(oLi)
                        }
                            document.body.appendChild(oUl)
                    }
                }
            }
        }
    </script>
```
##### 資料格式為:
```javascript=
{
  "people" : [
    {
      "email" : "aaaa",
      "firstName" : "Brett",
      "lastName" : "McLaughlin"
    },
    {
      "email" : "bbbb",
      "firstName" : "Jason",
      "lastName" : "Hunter"
    },
    {
      "email" : "cccc",
      "firstName" : "Elliotte",
      "lastName" : "Harold"
    }
  ]
}
```

輸出結果如下圖：

![](https://cdn-images-1.medium.com/max/2724/1*Pq6_3-9KCVFoa3-wMNJzHg.png)

## Same Origin Policy

但是如果將原本的JSON1的檔案改成串接到別人網站的連結時：

![](https://cdn-images-1.medium.com/max/2720/1*DLq8LnHYrpTIjLtzVRy8GA.png)

wtf…. 瀏覽器立馬報錯。 為什麼會有這個錯誤呢？

瀏覽器因為安全性的考量，有一個東西叫做[同源政策](https://developer.mozilla.org/zh-TW/docs/Web/JavaScript/Same_origin_policy_for_JavaScript)，Same-origin policy。

現在這個網站的網站「不同源」的時候，瀏覽器一樣會發 Request，但是會把 Response 給擋下來，JavaScript 拿到並且傳回錯誤。

不同源是什麼意思？？？簡言之，只要是網域（ Domain） 不一樣就是不同源，網址開頭http和https也不同源，端口號(port)不一樣也不同源。[相關的解決方案](https://blog.gtwang.org/web-development/chrome-configuration-for-access-control-allow-origin/)


＊註：XML為儲存網頁數據的結構

參考資料：

[http://www.cnblogs.com/SanMaoSpace/archive/2013/06/15/3137180.html](http://www.cnblogs.com/SanMaoSpace/archive/2013/06/15/3137180.html)

[http://huli.logdown.com/posts/2223581-ajax-and-cors](http://huli.logdown.com/posts/2223581-ajax-and-cors)
