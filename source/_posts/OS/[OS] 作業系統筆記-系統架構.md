---
title: "[OS] 作業系統筆記-電腦系統架構"
catalog: true
date: 2020/03/19
tags: [OS] 
categories: OS
toc: true
---
<!--toc-->
# 前言
本篇用於紀錄這學期修作業系統的筆記，會先從基本概念開始。
<!--more-->
# 什麼是作業系統?
可以從兩個面向來討論
## 系統
### 為資源分配者(Resource Allocator)
* 如何有效利用資源(CPU、Memory)
* 如何解決資源利用的衝突
### 監控User Program的運行
User端可能會有一些不當行為的操作，如: 不小心刪除系統檔，此時就需要作業系統來替我們把關，例如透過管理使用權限來決定是否有權做某個重要檔案的讀寫，甚至刪除。
## 使用者
可以看作電腦使用者(User)與電腦硬體(Hardware)之間的溝通橋樑，並提供一個讓User Program易於執行的環境

# 作業系統做什麼
## 主要功能分為下列三項:
- 資源的管理
- 工作的管理
- 讓使用者使用方便

## 電腦系統大致上可分為四個單元
- 硬體(hardware)
- 作業系統(OS)
- 應用程式(application program)
- 使用者(user)

![](https://i.imgur.com/mVJEwOh.png)
每個device controller皆有自己的local buffer還有registers。
* register: 用來儲存指令、變數的值
* local buffer: 用於暫存資料，傳送至Memory進行讀取


## 系統內運行的工作分兩種
- I/O Bound Job
    - 需要大量的I/O運作時間，對於CPU計算時間的需求量較少。 
    * 效能好壞是取決於I/O Device的速度
- CPU Bound Job
    - 需要大量的CPU計算的運作時間，對於I/O的需求量較少。
    * 效能好壞是取決於CPU的速度

# 電腦系統的架構種類
## Single-Processor Systems
一台電腦只有單一顆CPU
## Multiprocessor Systems
一台電腦有多顆CPU可以處理執行的程式(Process)，又作parallel systems(平行系統) or tightly coupled systems(緊密耦合系統)
## 特點
- 共享相同的記憶體空間、I/O Device、Bus
- 多個CPU之間的溝通(指Data交換)，大部份是採**Share Memory**技術

## 優點
- 穩定度高
- 處理效率較佳

## 種類
Multiprocessor Systems分兩種種類:
- Symmetric Multiprocessing: 對稱式多元處理
- Asymmetric Multiprocessing: 非對稱式多元處理

### Symmetric Multiprocessing
每個Processor都有相同的工作(功能)，當某一個Processor壞了，該Processor上未完成的工作可以轉移到其它的Processor繼續執行。好處: 系統不會整個Crash
### Asymmetric Multiprocessing
每個(或某群) Processor 各自負責不同的工作(功能)，其中有一個Processor負責控制、協調及分配Process到其它的Processors去運作，這個負責指揮的Processor稱作**Master**。
Asymmetric類似Master/Slave，除了MasterProcessor外，其餘的Processors稱為Slave Processor。

# 補充
## Bootstrap program
當電腦開機時，電腦顯示載入資訊的畫面，此時是正在檢查環境資源，Bootstrap program並非放置在硬碟，而是燒錄在Bios上。
## 什麼是Bios?
[Ref](https://www.blackhole.com.tw/Dr82.htm)
從按下電源開關開始，到可以開始操作電腦為止，這中間電腦自動執行一連串的動作

開機大致分為五個過程階段，每個階段循序漸進，必需完成這些程序，電腦才能正常運作。五個階段如下 :
- 初始階段（Initial Phase）
- 開機載入階段（Boot Loader Phase）
- 核心載入階段（Kernel Load Phase）
- 核心初始化階段（Kernel Initiation Phase）
- 登錄階段（Logon Phase）

> #### BIOS 為初始階段過程的執行者

BIOS 的全稱為 " Basic Input/Output System "，從字義上來解釋就是 : 基本的輸入及輸出系統。也就是說這個微系統控制著電腦的基本輸出及輸入裝置。開機時第一個啟動的程序就是 BIOS，必須先跑完 BIOS 這個程序，電腦才能繼續開機載入階段的後續動作。

在電腦的主機板上都會有 BIOS 晶片，而上面提到的BIOS就是寫在這個晶片中的程式。
## 程式(Program)
指的是一段**靜態且可以被執行的指令集**，簡單來說就是一個檔案(file)啦。
## Process(行程)
正在執行中的程式(Program)，也就是正在執行，已經載入到記憶體執行的程式碼。
## Interrupt(中斷)
CPU收到來自硬體或軟體發出的訊號(或稱事件; event)，進行相對應的處理。
![](https://i.imgur.com/KaNvYlq.png)
上圖可以發現平時CPU主要在處理使用者端的程式，當I/O Device發出訊號，要求CPU暫時中斷來處理這個訊號時，就會發生中斷(Interrupt)。
> 軟體的中斷又作**trap**

### 優點：
相對於忙碌等待(busy waiting)、輪詢(polling)有更好的效率，因為不需要額外的資源去確認是否有事件要處理，使用中斷可以專心於正在處理的事件，不需要時也可以進入休眠狀態節省資源，亦可實現分時多工。
### Interrupt 的處理流程
**Setps**
  1. 暫停目前process 之執行。
  2. 保存此process 當時執行狀況。
  3. OS 會根據Interrupt ID 查尋Interrupt vector。
  4. 取得ISR（Interrupt Service Routine）的起始位址。
  5. ISR 執行。
  6. ISR 執行完成，回到原先中斷前的執行。


### 作業系統的開機過程
按下開關(power on) -> Program Counter(程式計數器命令CPU run起來) -> Bootloader(載入Kernel，做初始動作) -> Disk -> Main Memory

### 記憶體的儲存單元比較
廣泛來分的話主要分
1. Register(暫存器)：用來暫時存放資料、指令的地方
2. Cache(快取)：將CPU運算的部份結果先放置於快取記憶體裡，待CPU要繼續運算時，能夠快速地讀取
3. Main Memory(主記憶體): CPU執行程式時暫存資料的地方，會讀取、寫入記憶體，Main Memory大小會影響CPU處理的速度
4. Disk(硬碟)
![](https://i.imgur.com/jfWcqM3.png)
[Ref](https://www.inside.com.tw/article/9595-dram)
> ### Register、Cache位於CPU內部進行管理

更細部的討論看[這篇](https://sites.google.com/site/nutncsie10412/ge-ren-jian-jie/ji-yi-ti)
## Process同時執行的方式
* Concurrent(並行)
    * 在單一時間點只有一個Process在執行!! 所強調的是一段執行時間內，有多Process同時執行，而非單一時間點。
    * 單一顆CPU即可做到。
    * 範例: Multiprogramming System
* Parallel(平行)
    * 在單一時間點有很多的Process在執行!!
    * 需多顆CPU方可做到。
    * 範例:Multiprocessing System, Distributed System



# 參考
* [陳士杰-作業系統(Operating Systems) (Operating Systems)](http://debussy.im.nuu.edu.tw/sjchen/OS/97Spring/Ch_1.pdf)