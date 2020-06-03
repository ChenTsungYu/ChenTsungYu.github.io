---
title: "[Docker] Docker入門"
catalog: true
date: 2020/02/28 17:00:10
tags: [DevOps, Docker]
categories: [DevOps]
---
![](https://i.imgur.com/Etryjfx.gif)
[圖片源](https://tenor.com/view/whale-docker-container-gif-12376852)
<!-- toc -->
# 前言
『Docker』這個名詞近幾年討論熱度非常高，許多大型公司都持續在導入這樣的技術，既然導入docker是趨勢，那總該來了解一下什麼是docker，它帶來哪些正面效益。

![](https://i.imgur.com/yPMwMXp.png)
上圖為Docker近五年在Google搜尋上的變化，整體來說，年年都在攀升。
<!--more-->
# 什麼是Docker?
我滿喜歡網路上某個教學的白話說法:
>Docker is a tool that allows developers, sys-admins etc. to easily deploy their applications in a sandbox (called containers) to run on the host operating system i.e. Linux.  Ref: [A Docker Tutorial for Beginners](https://docker-curriculum.com/)

簡單來說:
>Docker是一種工具，可讓開發者，系統管理員等輕鬆地在沙盒（稱為容器）中部署其應用程序，以在主機操作系統即Linux上運行。

# 為何Docker會出現?
Docker的出現可以先從虛擬化技術的歷史開始追溯，網路興起，建立網站應用需要一台實體機器(這只是其中一個例子)，企業可能會建置自家的實體主機，或定期向主機商租賃。

但是......傳統的虛擬機帶來幾項缺點:
* 硬體(機器)的維護成本: 實體機器是會折舊的RRR，有時候還要考量天災問題。
* 建置機器繁複
* 維護人員需要隨時待命

隨著雲端技術發展起來，實體機器開始走向虛擬化，而虛擬化造成機房的革命，讓機房空間、電力能更有效的利用，以應付不斷成長的業務需求。對於企業來說，不斷買機器建置專屬應用系統所花費的成本是一筆不小的開銷，虛擬化技術是減少成本的一個解方。

一般情況，雲端服務是由實體伺服器(Host)上的虛擬機(VM)所提供。這些應用程式，是在開發者發佈完成後，轉給負責IT維運人員，在VM上運行。

在軟體開發流程裡面，開發測試會需要某些特定環境上運行，傳統的做法是利用虛擬化技術建立一個包含作業系統在內的獨立執行環境(虛擬機器)，例如VirtualBox、VMware。

雖然VM解決實體機器的問題，VM本身也有缺點:
* 耗費許多系統資源：每台虛擬機都需要有自己的操作系統，虛擬機一旦被開啟，預分配給它的資源將全部被佔用
* 佔用不少主機硬碟空間
* 花費許多時間在多個專案之間轉換

## Container(容器)是什麼？
容器(container)是一項虛擬化技術與傳統虛擬化(Virtual Machine)相同，但不同於傳統需要安裝作業系統(OS)，容器技術採共用OS的做法，虛擬化層級從OS的轉為應用程式，讓原本消耗的資源大幅降低，同時也加快執行速度。
### 比較Container 與 VM
![](https://i.imgur.com/UXBK6RM.png)
[圖片源](https://aws.amazon.com/tw/docker/)

## 使用Docker會帶來哪些好處
* 更有效率的利用資源
* 統一環境
* 輕量：容器利用並共享了主機CPU，在系統資源方面比虛擬機更加有效。
* 可移植：可以在本地構建，部署到雲端並在任何地方運行。

# 架構(Docker architecture)
Docker是一個Client-Server架構
![](https://i.imgur.com/2LzHxtx.png)

# 使用Docker必懂相關的名詞
要學習Docker前，必須要先知道下面三個名詞
## Image(映像檔)
Docker Image是用來啟動容器(container)=>實際執行應用程式環境。簡單列點整理:
* 一個唯讀的檔案
* 作為建立Container的模板
* 不同Image可堆疊(如Ubuntu+Postgresql+Application)
* 可用性：
Docker 提供了一個簡單的機制來建立Image或者更新現有的Image，使用者甚至可以直接從遠端儲庫(Docker Hub)下載一個已經做好(別人或自己的)Image來直接使用。
### Image 如何取得?
* 自己寫Dockerfile
* Docker Hub pull下來
* 別台電腦上輸出Docker image，import(匯入)自已的電腦

## Container
容器是從映像檔建立的執行實例。它可以被啟動、開始、停止、刪除。每個容器都是相互隔離的、保證安全的平台。
可以把容器看做是一個簡易版的 Linux 環境（包括root使用者權限、程式空間、使用者空間和網路空間等）和在其中執行的應用程式。

* 用來執行應用程式
* 讀寫模式 (R\W)
* 將軟體執行所需的所有資源進行打包
* 每個Container環境獨立，相互不影響(如兩個不同的container開在8000port不會衝突)
* 一個Image可啟動多個不同的container

## Registry
* Docker Registry為存放Images的地方
Registry分為兩種形式: 公開(Public)和私有(Private) 
* 最大的公開Registry是 **Docker Hub**，存放了大量的images讓使用者pull下來
* 使用者可以在本地端內建立一個私有 Registry

### Repository(倉庫，儲存庫) vs Registry (倉庫註冊伺服器)
兩者稍稍不同，實際上倉庫註冊伺服器(**Registry**)上存放著多個倉庫(**Repository**)，每個倉庫中(**Repository**)又包含了多個Image，每個Image有不同的標籤(tag)
簡單歸納:
* Registry：儲存image的服務，Docker預設Registry 是**Docker Hub**
* Repository：提供不同版本(tag)的相同應用程式或服務

> docker repository 伺服器，像是 GitHub 一樣，Docker Hub 就是 docker 官方提供的 registry

## Dockerfile
是用來描述image的文件。

# 參考教學
[docker入門觀念](https://hackmd.io/@titangene/docker-getting-started-slide?print-pdf#/)
[Docker官方文件](https://docs.docker.com/install/)
[What is a Container?](https://www.docker.com/resources/what-container)
[Docker 入門](https://hackmd.io/vOJ4R4MQQoiq39P3HWkbjA?view)
[淺談虛擬機(VM)與容器(Container)之差異](https://www.inwinstack.com/2017/10/13/vm-container-difference/)

