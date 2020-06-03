---
title: 'Proxy'
catalog: true
date: 2019/07/14 16:23:10
tags: Proxy
categories: Internet
---
<!-- toc -->
# 什麼是Proxy?
根據維基百科的定義:

**代理(**Proxy）也稱**網路代理**，是一種特殊的網路服務，允許一個[網路終端](https://zh.wikipedia.org/w/index.php?title=%E7%BD%91%E7%BB%9C%E7%BB%88%E7%AB%AF&action=edit&redlink=1)（一般為[用戶端](https://zh.wikipedia.org/wiki/%E5%AE%A2%E6%88%B7%E7%AB%AF)）通過這個服務與另一個[網路終端](https://zh.wikipedia.org/w/index.php?title=%E7%BD%91%E7%BB%9C%E7%BB%88%E7%AB%AF&action=edit&redlink=1)（一般為[伺服器](https://zh.wikipedia.org/wiki/%E6%9C%8D%E5%8A%A1%E5%99%A8)）進行非直接的連接。一些[閘道器](https://zh.wikipedia.org/wiki/%E7%BD%91%E5%85%B3)、[路由器](https://zh.wikipedia.org/wiki/%E8%B7%AF%E7%94%B1%E5%99%A8)等網路裝置具備網路代理功能。一般認為代理服務有利於保障網路終端的隱私或安全，防止攻擊。
<!--more--> 
上述一段冗長的字，自己是這樣理解 :
> 一種具有重要的電腦安全功能，也是特殊的網路服務，允許客戶端透過它和另一個網路服務進行非直接的連線。

舉個例子:

今天我幫家裡的父母跑腿，例如匯款， 因為我不是『申請者本人』而是『代理人』的角色，因此有時候會需要秀出一些證件，才能完成代辦事項。

將場景換至網路上面代理伺服器 (Proxy Server) 時:

當用戶端有網路的資料要求時，Proxy 會幫用戶去向目的地取得用戶所需要的資料。

這個詞最早應是出現在網路的防火牆功能中。可以用來保護網路的安全，在內部網路與外部網路之間建立一道像牆般的保護，所有的資料進出都必需經過這道牆。

## Proxy 有那些好處 ?

### 減少單點對外的網路頻寬，降低網路負載量:

假設今天要造訪一個網站， 在正常的網路流程中，當使用者的瀏覽器看到 **www.xxxx.com.tw**的網域時，會向DNS尋找**www.xxxx.com.tw**所對應的IP，當DNS傳回對應的 IP後，瀏覽器會再對真正的伺服器索取資料，但如果網路塞車、網站的機器配備不好、網站的專線不夠快等不良的因素通通加在一起後，你要連接的網站就會變的很慢。

透過 Proxy Server ，可以把造訪的網頁資料暫存在一個位置，下次訪問該網站時可以直接從Proxy Server儲存的空間中(硬碟)進行**資料快取( Cache)，不必再向網路要資料。**

### 以較短的路徑取得網路資料，加快上網速度:

可以指定 網路服務供應商(ISP) 提供的代理伺服器連接到國外，通常 ISP 提供的 Proxy 具有較大的對外頻寬，所以在對國外網站的資料取得上會比自己的主機連線到國外快多了。

### 提供防火牆內部的電腦連上網路

Proxy Server可以用來「**代替**」外部網路的電腦連接私有網路（內部網路）的網頁伺服器， 將內部網路內網頁伺服器的內容儲存在代理伺服器的記憶體，讓外部網路的電腦由代理伺服器的記憶體中讀取資料，而不直接由私有網路的網頁伺服器讀取。

簡單實作 Proxy設定(Chrome版本):

先到網頁右上角的工具點選符號為3個點的選項後點選 **"設定"**

![](https://cdn-images-1.medium.com/max/2000/1*VbGCdpbVOdWkfNf3TO3qSw.png)

![往下滾動至系統的地方](https://cdn-images-1.medium.com/max/2000/1*mX0PBrkSZ07rT5mLss_Ofg.png)*往下滾動至系統的地方*

![點選開啟Proxy設定](https://cdn-images-1.medium.com/max/2000/1*rMcuqqoi166ukfyxiBlCPA.png)*點選開啟Proxy設定*

![就可以開始進行相關設定啦~](https://cdn-images-1.medium.com/max/2000/1*vCvHcGBlsO3yfvdVkpIAVA.png)*就可以開始進行相關設定啦~*

更多Proxy 相關設定可以參考鳥哥[這篇文章](http://linux.vbird.org/linux_server/0420squid.php#theory_things)。

## Proxy Server 如何運作 ?

Proxy Server 接受使用者的 request 之後會先檢查自己的 Server 上有沒有一份 Client 端要的資料，代理 Client 端到訪問的目的地去截取資料，一份給 Client 端，Proxy Server 內部也存放一份，下一個Client 端使用者來做 request 時，Proxy Server 便會一樣先在 Server 中檢查看看，檢查與目的端的資料是否相符，若相符則由 Proxy Server 直接給要求的 Client 端即可。

不過，" 向目的地再 check 一次 " 這樣的動作，一開始在想: 不是會浪費時間嗎? 不過這是必要的，雖然要去的目的地的資料在 Proxy Server 上存放了一份，但是否是最新的是無法得知的，必需做比對，比對的時間不會長。例如: 新聞這類的網站，是隨時都在更新的，但是比對後相同的部分就不需要再向目的網站進行存取。

![](https://cdn-images-1.medium.com/max/2000/1*Ef93QY8-VGgQW00GLtAGJg.png)

參考資料:
[**鳥哥的 Linux 私房菜 -- 代理伺服器的設定： squid**
*透過 squid 來進行代理伺服器 (proxy) 的設定輔助區網的 www 瀏覽控制！*linux.vbird.org](http://linux.vbird.org/linux_server/0420squid.php#theory_things)
[**什麼是Proxy?**
*常常會聽到別人說，你的 Browser 要設 Proxy Server，這樣你上網的速度會比較快？到底什麼是 Proxy Server，他在Internet 裡扮演什麼樣的角色？*www.ithome.com.tw](https://www.ithome.com.tw/node/5006)
[**Proxy 伺服器是什麼？如何應用？ - StockFeel 股感**
*代理伺服器（Proxy server） 代理伺服器是一種防火牆成員，也是一種「應用閘道器（Application…*www.stockfeel.com.tw](https://www.stockfeel.com.tw/proxy-%E4%BC%BA%E6%9C%8D%E5%99%A8%E6%98%AF%E4%BB%80%E9%BA%BC%EF%BC%9F%E5%A6%82%E4%BD%95%E6%87%89%E7%94%A8%EF%BC%9F/)
[**Proxy 是什麼東東 ?**
*傳統的 Proxy Server 是底下的機器先向 Proxy Server 做 request ，若 Server 中沒有就直接由 Server向目的地截取資料。這對大都數的 Proxy Server…*macgyver.info.fju.edu.tw](http://macgyver.info.fju.edu.tw/docs/whatisproxy.html)

以上為今日筆記。
