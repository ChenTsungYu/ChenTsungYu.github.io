---
title: "[OS] 作業系統筆記-Process"
catalog: true
date: 2020/03/21
tags: [OS] 
categories: OS
---
<!--toc-->
# 前言
上篇有稍微提到關於Process的基本概念，本篇要近一步探討Process。
<!--more-->
# 什麼是Process?

中文又作『行程』;簡單來說，Process就是**正在運行中的程式**。也就是說，當在執行的檔案載入記憶體時，程式就成為行程(Process)。

## 一個Process主要包含有：
* Code Section(程式碼、程式區間)
* Data Section(資料區間)
* Stack(儲存暫時性資料)
* processor register
* Program Counter(程式計數器，擺放下一個要執行程式的地址)

## Process VS. Program
來比較一下兩者差別

| Process  | Program |
| -------- | -------- |
| 「主動」儲存在硬碟裡 | 被動的，被存在硬碟中(等待執行) |

## Process的5種狀態
Process會隨著當下的情況改變狀態
![](https://i.imgur.com/EdtfMcT.png)
- new：產生新個Process
- running：運行中的Process
- wating：當有其他事件(Event)發生時，如: 週邊設備的I/O，會進入暫時等待的狀態。 注意：Process此時雖然還在記憶體中，但不在Ready Queue
- ready： 準備好被分配至CPU執行。當I/O事件結束或執行期間被Interrupt都會Process回到ready狀態
- terminated：Process執行結束


Job Queue: 系統中的所有Process所形成的隊伍
Ready Queue: 放在記憶體中多個Process所形成的隊伍，準備隨時可以被分配至CPU內執行

## Process Management
當系統有多個Process時，就要進行管理，而Process Control Block (簡稱PCB)就是用來管理Process。
毎個Process皆有自已的PCB，PCB包含以下資訊：
- Process state:  Process 在哪一個狀態
- Process ID
- Program counter: 指明該Process下一個要執行的指令位址
- CPU registers
- CPU scheduling information：  Process優先順序
- Memory-management information
- Accounting information： 用掉多少CPU的時間、使用CPU的最大時間量
- I/O status information: 尚未完成的I/O Request還有哪些、還在I/O Queue中排隊之Process的編號

## process scheduling (排程)
為了要讓CPU能發揮最大的效益，需要process scheduler來決定  如何分配哪個process能使用CPU
### process scheduler分成三種
- short-term scheduler: 又稱『CPU scheduler』，負責決定記憶體中的哪個process能排進CPU執行，決定的時間極短。
- long-term scheduler:  又稱『job scheduler』，負責決定系統中哪些process能排進記憶體，控制記憶體內process的數量，相較之下有較長的時間可以決定。不過這個過程是單向的，意味著無法從記憶體的Ready
- medium-term scheduler: 保留long-term scheduler功能外，還可以將放在記憶體(Ready Queue)中的Process搬回Disk(Job Queue)，採Swap(交換)的形式

## Context Switching (內容轉換)
CPU在執行時，只能運用一個process，如果切換給另一個Process時，須將舊Process的相關資訊 (e.g.PCB內容) 儲存起來，並載入新Process的相關資訊，此過程稱『Context Switching』。
### 困難點
在Context Switching的過程中，系統做的事是不具有生産力的工作，會浪費系統效能。
### 解法
- 增加Register Set: 因為Context Switching的速度取決的硬體支援程度，所以增加Register數量，盡可能讓每個Process分到一個resgister
- 以Thread來代替Process： 因為毎個Process都有其私有的資訊(PDB)，這些私有資訊會佔用Register。而Threads之間彼此可以共享Memory Space (如：Code Section,Data Section, Open File…)，私有的資訊量不多。所以進行Context Switching時不須對記憶體進行大量存取，可降低Context Switch負擔。

## Scheduling Criteria 
如何衡量Scheduling的效能？
- CPU Utilization (CPU使用率): 在CPU花的所有時間中，真正花在執行Process的時間占比，公式會是: (CPU Use Time) / (CPU Use Time + CPU Idle Time)
- Throughput (產能): 單位時間所能執行完的Process數量
- Waiting Time (等待時間): 從Process待在Ready Queue到被放入CPU執行，這過程中的等待時間
- Turnaround Time(完成時間): 從一個Process到完成工作所耗費的時間 
- Response Time (反應時間): 從Process進入系統，到系統產生第一個回應的時間

# 延伸閱讀
* [Course 4  行程管理](http://debussy.im.nuu.edu.tw/sjchen/OS/97Spring/Ch_4.pdf)
