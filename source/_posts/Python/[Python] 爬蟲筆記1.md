---
title: "[Python] 爬蟲筆記1-基本概念"
catalog: true
date: 2019/09/01 20:23:10
tags: [Python, WebScraping]
categories: Backend
toc: true
---
<!-- toc -->
## 前言
這學期因為專題需要用到網路爬蟲進行實作，所以將學習到的知識做一篇紀錄，之後忘記可以回來複習一下。
## 什麼是爬蟲?
根據維基百科定義:
>也叫網路蜘蛛（spider），是一種用來自動瀏覽全球資訊網的網路機器人。其目的一般為編纂網路索引。
>網路搜尋引擎等站點通過爬蟲軟體更新自身的網站內容或其對其他網站的索引。網路爬蟲可以將自己所存取的頁面儲存下來，以便搜尋引擎事後生成索引供用戶搜尋。

簡單來說就是對網站進行資料擷取，可以透過它自動蒐集我們所想要的資料，將資料進行分析或是再利用，這樣的技術在資料科學領域算是幾乎需具備的技能。
<!--more--> 
## 為何選擇Python?
* 工具多元
* 容易上手
* 學習資源多

## 有哪些可用的工具?
Python工具非常多，內建的函式庫包含`urllib`或是第三方套件如:`requests`、`seleium`等強大易上手工具。
本篇會先紀錄`urllib`、`requests`這兩個常用在爬取靜態網站的工具。

## `urllib`
是Python內建的函式庫，只要安裝python就可以直接使用了，不需額外安裝。

```python=
import urllib

url = urllib.request.urlopen('https://www.google.com')
print(url.read())
```
上面那段程式碼會進行網頁解析，但若是遇到網站有反爬蟲機制就會回報錯誤，例如下段程式碼:
```python=
url = urllib.request.urlopen('https://group.i-fit.com.tw/?route=buy&id=1&in=')
print(url.read())
```
結果:
![](https://i.imgur.com/RIpO5ZW.png)
有些網站為防止這種非正常的訪問，會設反爬蟲機制，驗證請求中的**UserAgent**。這時就必須設置一個header，加入UserAgent即可。
```python=
import urllib
from urllib.request import Request, urlopen

url = Request('https://group.i-fit.com.tw/?route=buy&id=1&in=', headers={'User-Agent': 'Mozilla/5.0'})
webpage = urlopen(url).read()
print(webpage)
```

這時候就可以正常進行訪問，後續進行網頁解析時我們可以透過`bs4`這個套件協助我們`parse`網頁結構。
```python=
from bs4 import BeautifulSoup
from urllib.request import Request, urlopen

url = Request('https://group.i-fit.com.tw/?route=buy&id=1&in=', headers={'User-Agent': 'Mozilla/5.0'})
webpage = urlopen(url).read()
sp = BeautifulSoup(webpage, "html.parser")
print(sp)
```

## 繞過反爬蟲的方法
有些網站不喜歡讓外部使用者擷取網站資料，會採用一些反爬蟲機制，要繞過這些機制可以採用幾個手段:
* UserAgent
>因為爬蟲是機器人，為了要偽裝成如真人一般造訪網站，透過設置**UserAgent**來達成真人訪問網站的效果。

* 限制訪問頻率
>有些網站無法進行短時間內頻繁的請求，在一定時間內對網站發出超過特定次數的請求會封鎖IP，可以設定訪問時間的間隔為一個隨機值，例如間隔0~5秒隨機發出請求。

## `requests`
是第三方套件，非python中內建，在使用它的時候就需要先安裝，執行`pip install requests`；`requests`功能非常強大，它比`urllib`更加方便快速。
範例，使用`get`方法進行網站請求:
```python=
import requests

header={'User-Agent': 'Mozilla/5.0'}
page = requests.get("https://group.i-fit.com.tw/?route=buy&id=1&in=", headers= header)

print(page) # <Response [200]>

print(page.text) # 解析網頁 -> 以Unicode進行編碼
```
上面的範例程式碼裡面`print(page)`會回傳一個`<Response [200]>`的response物件，`page.text`會以**Unicode**的形式進行編碼。

## 幾個爬蟲要點
* 選定目標網址
* 分析目標網站的HTML網頁結構
* Devtools觀察request訊息
* 擷取目標資料

### 選定目標網址
選定目標網站。
![](https://i.imgur.com/9CcWhYN.png)

## 分析目標網站的HTML網頁結構
向目標網址發送HTTP請求封包，伺服器會回應HTML網頁原始碼，我們要定位網頁資料。
![](https://i.imgur.com/srrecXg.png)

### Devtools觀察request訊息
打開Devtools的Network，觀察**request header**，裡面有許多重要的訊息，幫助我們在爬蟲時能夠快速了解網站訊息，決定採用何種擷取資料的方法。
![](https://i.imgur.com/AxqnNbd.png)


### 擷取目標資料
將擷取下來的資料儲存成特定格式，常見如:
* JSON
* CSV
* XLSX
* SQL

>這篇主要紀錄爬蟲的目的、注意要點，下篇會紀錄我目前常用的方法。







