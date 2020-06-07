---
title: "[OS] 作業系統筆記-Process間的溝通"
catalog: true
date: 2020/06/07
tags: [OS, w3HexSchool] 
categories: OS
toc: true
---
<!--toc-->
# 前言
[上篇](https://chentsungyu.github.io/2020/03/21/OS/%5BOS%5D%20%E4%BD%9C%E6%A5%AD%E7%B3%BB%E7%B5%B1%E7%AD%86%E8%A8%98-Process/)筆記過Process的狀態及管理，本篇筆記Process間的溝通
<!--more-->

# Process間的溝通
現代作業系統中，通常不會只有一個Process存在於作業系統內，通常有好幾個Processes同時存在並同時執行。
這些執行的Process可以分成兩大類
- independent process(獨立行程)： 該Process無法影響其它Process的執行，同時它也不受其他Process影響，獨立的Process之間不會有任何共享資料。
- cooperating process(合作行程)：該Process能夠影響其它Process，或是受其它Process影響，故Process之間會有共享的資料，需要有進行資訊交換的管道

簡單做個整理：
| independent process | cooperating process |
| -------- | -------- |
| Process之間不會有任何共享的資料| Process之間會有部分共享的資料 |



Process間的溝通需透過IPC(interprocess communication) ，IPC有兩種模式設計:
- Share Memory
- Message Passing

可以用生產者(Producer)跟消費者(Consumer)間的關係來解釋這兩種模式，Producer會產生資料放在有限或是無限的buffer中等Consumer來消費。

Process在傳輸資料時，buffer有三種型態:
- zero capacity：一定要收完之後才能再送，沒有地方給資料排隊。
- bounded capacity：有限度的空間給資料排隊，若是滿了就必須要等。
- unbounded capacity：無限的空間給資料，發送者可以一直送資料。

## Share Memory (共享記憶體)
Process之間共享一部分的記憶體(共享變數;Shared Variables)，透過存取記憶體達到彼此溝通、交換資訊的目的。
shared memory是用**read跟write**資料來完成資訊交換

也可以這麼說: 
producer會把資料放進buffer內(write)，而consumer會去同一個buffer把資料取出來(read)
## Message Passing (訊息傳遞)
Process間會建立連接通道(Communication Link)來溝通，非借助共享變數
過程會是：
- 建立Communication Link
- 互傳訊息 (Message)
- 傳輸完畢，中斷連接通道 (release link)

建立連接通道時，會分做傳送(send)方與接收(receive)方，而通訊(Communication)的方式也分成兩種:
- 直接傳訊息(Direct)
- 間接傳遞(Indirect)

| Direct| Indirect |
| -------- | -------- |
| 建立link用send跟receive來傳送訊息 | 訊息是從 mailbox 裡直接接收(只能共享mailbox資料) |
| 為自動建立 | 每個mailbox都有個獨特的ID |
| 一個Link剛好連接一對Process | 一對process之間，可能存在多條Link|
| 每個行程必須要明確地命名 | 要建立連結，只能是行程共享郵箱 |

間接傳遞的過程中，通訊的同步非常重要，分作兩種形式：
- blocking
  - Blocking send：訊息傳遞出去，Process被Block阻擋，直到對方訊息收到才可再傳送。
  - Blocking receive：不做任何動作，直到訊息送來，再回傳收到的資訊。
- non-blocking
  - Non-blocking send：不管對方有無收到訊息，持續發送訊息給對方。
  - Non-blocking receive：接收者只接收有效訊息，或是沒有訊息。


將兩者的比較做個整理：
| | Share Memory | Message Passing |
| -------- | -------- | -------- |
| 溝通方式  | 共享一部分的記憶體(透過共享變數存取資料) | Process 之間建立Communication Link |
| 共享性  | 共享變數所有process皆可存取 | process間有專屬的Link，不會隨意被其他Process共用 |

## 多個Process間，如何確定是哪個Process接收到訊息？
- 規定在某一時間內，只有一個Process可以接收訊息。
- 由系統決定，是哪個Process接收，再回傳訊息告知是誰收到。

# 延伸閱讀
* [行程間的溝通](http://debussy.im.nuu.edu.tw/sjchen/OS/97Spring/Ch_7.pdf)