---
title: 'Webhook VS. WebSocket'
catalog: true
date: 2020/05/18
tags: Internet
categories: Internet
toc: true
---
<!-- toc -->
# 前言
本文紀錄常見的兩種API形式：Webhook、WebSocket
<!--more--> 
# 比較
Webhook、WebSocket兩者最大的差別在於一個是主動型，另一個為被動型，來近一步討論兩者的差別。
## Webhook
屬於被動型的API，藉由事件去觸發API。舉下圖範例來說
![](https://i.imgur.com/FbAKiNa.png)
假設開發一個Linebot，使用者對機器人輸入文字，這些文字資料透過Line平台到Bot Application，這過程中產生一個**事件(Event)**，Bot Application會處理這段資料，再回應給Line 平台，最後送回給使用者，透過事件去trigger。

## WebSocket
屬於主動型的API，最具代表性的生活案例就是聊天室，有朋友主動發訊息給自己時，會自動把新訊息在自己的頁面做更新，而不是等自己主動去刷新網站頁面才能收到對方的訊息。
以常見的 **Client-Server** 架構來說，會長的像下方圖示
![](https://i.imgur.com/U3Xxudd.png) [圖片源](https://www.pubnub.com/blog/websockets-vs-rest-api-understanding-the-difference/)
WebSocket其實是網路協定的一種，有別於一般常見的http或 https採用 **輪詢(Polling)** 的方式。


輪詢: 讓 Client 端每隔一段時間就自動送出一個 HTTP Request 給 Server，獲取最新的資料

WebSocket 協定只需透過一次連結便能保持連線，不必再透過一直發送 Request 來與 Server 互動！

HTTP 回傳資訊後就會關閉 TCP 的API，而 WebSocket 會一直開著，只需透過一次連結便能保持連線，如同一個通道一般，只要通道保持開啟且暢通的狀態，就可以允許 Server 和 Client 端進行**雙向溝通**，不必再透過一直發送 Request 與Server 進行互動，直到通道關閉為止(例如：關閉網頁)，而這樣的特性有利於實作具即時的功能(e.g. 聊天室)。

# 參閱
* [differences between webhook and websocket](https://stackoverflow.com/questions/23172760/differences-between-webhook-and-websocket)
* [HTTP and Websockets: Understanding the capabilities of today’s web communication technologies](https://medium.com/platform-engineer/web-api-design-35df8167460)
* [WebSocket 通訊協定簡介：比較 Polling、Long-Polling 與 Streaming 的運作原理](https://blog.gtwang.org/web-development/websocket-protocol/)
