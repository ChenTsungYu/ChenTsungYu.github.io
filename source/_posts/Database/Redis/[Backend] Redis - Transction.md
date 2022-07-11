---
title: "[Redis] Redis - Transaction"
catalog: true
date: 2022/01/11 13:23:10
tags: [Redis]
categories: Backend
toc: true
---
<!-- toc -->

# 前言
![](/images/Redis-Logo.png)

為確保資料的正確性， Redis 也提供了類似於關聯式資料庫的 Transaction 機制，但 Redis 提供的 Transaction 有一些相異之處 e.g. 不支援 rollback，本篇文章紀錄 Redis Transaction 的概念與使用方式。

<!-- more -->
# Transaction
Redis Transaction 允許一次執行多條指令(批次操作)，Transaction 在運作時主要會圍繞在 `MULTI`, `EXEC`, `DISCARD` and `WATCH` 這四個指令，以下是 Transaction 幾個重點：

- 進行批次操作的流程中，在發送 `EXEC` 指令 **前** 會先被序列化且放在 Queue 裡按順序等待執行
- Transaction 擁有原子性 (Atomicity)：只有兩種狀態：**全部都執行** 或 **一個都不執行** 。
  如： client 端在執行 `EXEC` 指令前發生連線中斷導致無法正常，則不會執行任何操作 或是 client 端在執行 `EXEC` 指令前輸入錯誤的指令(e.g 語法) 也不會執行任何操作。
  一旦 Client 端發送 `EXEC` 指令後，所有的指令通通會被執行，即使之後 Client 端斷線也沒關係，因為 Redis 已經記錄所有要執行的指令
- 有別於傳統的關聯式資料庫，Redis 不支援 rollback 機制(減少對 Redis 效能影響)
- Redis Transaction 具有隔離性 (Isolation)：指的是同一筆資料，保障不會被兩個 Transaction 同時更改，產生競爭條件(Race Condition)，一個 Transaction 完成之前，**其它 client 端送出的各種操作指令都不能被執行**，保證了隔離性。 

## 應用
Transaction 的隔離性可以確保資料不會在同一時間被多個人進行改動，確保資料正確性。

**舉格生活例子：**

甲乙兩人同時查詢同班火車同個座位，兩人都發現後訂購此座位，甲先完成付款，乙後續也完成付款，會造成甲拿到座位而乙付了錢沒有拿到座位。

加入 Transaction 機制變成甲先完成交易，乙需等甲完成交易後得知座位數量再進行交易。

## 用法
`MULTI` 指令建立一個 Transaction，收到 "OK" 的提示後可開始輸入其他要執行的指令放入 Transaction，最後再執行 `EXEC`。

**範例1:**
執行兩次 set 分別建立 bank1, bank2 兩個 key
```shell=
> MULTI
OK
> set bank1 5000
QUEUED
> set bank2 6000
QUEUED
> exec
1) OK
2) OK
```
接續 `MULTI` 後輸入的兩個 `SET` 指令得到的結果為 QUEUED 表該指令已被序列化且放在 Queue 裡按順序等待執行，最後從 `EXEC` 收到 2 個 "OK" 表放在 Queue 裡的兩個 `SET` 指令被成功執行！

接著看另一個例子，如果發生 Transaction 裡的指令有錯誤的情形 e.g. 指令拼錯， Redis 會偵查到這個錯誤，並將先前已放入 QUEUE 裡的指令都捨棄掉。 

**範例2:**
將範例 1 的 bank1, bank2 的值都加上 100，其中對 bank2 下的指令語法是錯誤的 
```
> multi
OK
> incrby bank1 100
QUEUED
> incrbyy bank2 100
(error) ERR unknown command `incrbyy`, with args beginning with: `bank2`, `100`,
> exec
(error) EXECABORT Transaction discarded because of previous errors.
```
由於 `incrby` 是拼錯的指令，Redis 跳出 **"(error) ERR unknown command `incrbyy`, with args beginning with: `bank2`, `100`,"** 的錯誤提示，最終執行 `EXEC` 時也提示 `EXECABORT Transaction discarded` 

最後透過 `MGET` 檢查 bank1, bank2 是否有變動： 
```
MGET bank1 bank2
1) "5000"
2) "6000"
```
從結果來看剛才 Transaction 裡下的指令沒有對 bank1, bank2 做任何變動，證明只要有`一個以上`的指令在 執行`EXEC` **前** 被 Redis 偵測出來，其他的指令即便是沒問題的也會被捨棄掉，保持執行前的狀況

## Transaction 裡的錯誤
實務上可能發生 Redis 沒辦法事先於 QUEUE 裡偵查到這類的錯誤，如`EXEC` 執行 **之後** 才引發錯誤，表示 Transaction 裡等待被執行的指令套用錯誤的使用情境。 

常見例子：針對 Lists 操作的指令，目標 key 的資料類型卻是 String 

**範例3:**
替換 範例2 對 bank2 下的指令，改為 `ZADD`。
```
> incrby bank1 100
QUEUED
> zadd bank2 1 100
QUEUED
> exec
1) (integer) 5100
2) (error) WRONGTYPE Operation against a key holding the wrong kind of value


> MGET bank1 bank2
1) "5100"
2) "6000"
```

由於 bank2 資料類型是 string，`ZADD` 則是操作 sortedset 類型，相異類型的指令操作無法在放入 QUEUE 時且執行 `EXEC` 之前被 Redis 偵測出錯誤。

若將`ZADD` 的執行順序與 `INCRBY` 對調也會得到一樣的結果
```
> multi
OK
> zadd bank2 1 100
QUEUED
> incrby bank1 100
QUEUED
> exec
1) (error) WRONGTYPE Operation against a key holding the wrong kind of value
2) (integer) 5200

> MGET bank1 bank2
1) "5200"
2) "6000"
```

相較於前面範例 2 指令的語法錯誤，範例 3 的類型錯誤讓 Transaction 依舊正常執行，但是透過 `MGET` 查詢 bank1, bank2 的結果會發現 bank1 已經被 `incrby` 改動，表示這類 只有在執行 `EXEC`後 ，跑完整個 Transaction 才發生的錯誤，除了錯誤的那個指令之外，其他指令仍能對資料進行改動。

> ### 截自[官方文件](https://redis.io/docs/manual/transactions/#errors-inside-a-transaction)的描述：
> It's important to note that even when a command fails, all the other commands in the queue are processed – Redis will not stop the processing of commands.

## DISCARD
執行 `DISCARD` 指令時，會放棄 Transactions，同時 QUEUE 裡面的所有指令會被清空，並退出整個狀態：

**範例4**
新增 bank3, bank4 兩個 key
```
mset bank3 1000 bank4 2000
```

個別對上面兩個 key 的值在 Transactions 裡執行 `set` 增加 100，接著加上 `DISCARD` 
```
> multi
OK
> incrby bank3 100
QUEUED
> incrby bank4 100
QUEUED
> discard
OK
> MGET bank3 bank4
1) "1000"
2) "2000"
```
透過 `MGET` 得知 bank3, bank4 因為 `DISCARD` 捨棄原有的 `incrby` ，而沒有任何變動

如果是加上 `DISCARD` 後再執行 `EXEC` 則會得到錯誤提示： `ERR EXEC without MULTI`。

## WATCH
前面討論了 Redis 的 Transaction 概念和操作流程，本節會討論 Redis Watch 指令及在 Transaction 中的角色。

`WATCH` 提供一個名為 check-and-set (CAS) 的機制給 Transaction，用於偵測指定的 key 是否在 Transaction 執行之前發生變動， 是 `EXEC` 指令的執行條件，也就是說，若 `WATCH` 指定的 key 有發生改動，整個 Transaction 就會被終止，並回傳 null 值。


**範例1：**
對 bank1 下 `WATCH` 指令監測，再對該 key 做改動，最後於 Transaction 中對 bank1 再做一次改動

```
> WATCH bank1
OK
> incrby bank1 100
(integer) 5200
> multi
OK
> incrby bank1 100
QUEUED
> exec
(nil)
```
在 Transaction 之前對 bank1 下`WATCH`，最後執行 `EXEC` 時回傳 `(nil)` 讓整個 Transaction 終止。

**範例2：**
延伸範例1的方式，這次改成在自己的電腦上開兩個終端機視窗，左邊視窗先執行 `watch` 監控 bank1 是否有被改動，接著於右方視窗下指令 `incrby bank1 200` ，模擬其他的 user 將 bank1 的值加上 200。
![](https://i.imgur.com/48sYD1P.png)
再回到左方視窗執行 `multi` 開啟 Transaction 後輸入指令 `incrby bank1 300`  將 bank1 的值加上 300，執行 `EXEC` 後得到回傳結果為 `(nil)`。

從這個範例可以了解 watched key 在另一個 Client 端進行改動後，確保了沒有競爭條件(Race Condition)時才能正確執行。

若想消除針對 Transaction 的 watched key 可執行 `UNWATCH` 的指令終止。

> ### Note
> 由於 `WATCH` 只有當被監控的 key 被修改後阻止之後 **一個 Transaction** 執行，不能保證其他 Client 端不修改這個 key，故一般情況下需要 `EXEC` 執行失敗後重新執行整個函數。

# 小結
本篇討論 Transaction 在 Redis 的重要概念以及`MULTI`, `EXEC`, `DISCARD` and `WATCH` 這四個指令，有效地管理 Transaction 執行，才能保證資料完整性。

# Ref
- [4.4 Redis transactions | Chapter 4: Keeping data safe and ensuring performance](https://redis.com/ebook/part-2-core-concepts/chapter-4-keeping-data-safe-and-ensuring-performance/4-4-redis-transactions/)
- [Redis - Transaction](https://redis.io/docs/manual/transactions/)