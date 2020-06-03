---
title: "[ELK] Elasticsearch"
catalog: true
date: 2020/05/23
tags: [DevOps, ELK, w3HexSchool]
categories: [DevOps]
toc: true
---

> 鼠年全馬鐵人挑戰 - WEEK 16

<!--toc-->
# 前言
繼續上一篇的ELK筆記，本篇主要近一步筆記ELK中的Elasticsearch
<!--more-->
# Elasticesearch 
Elasticesearch是一個基於RESTful API的架構設計，使用者所有的操作都可以透過HTTP Method如：`GET/POST/PUT/DELETE`來完成。
可以簡單的把它定義成**分散式叢集架構的非關聯式資料庫**，回顧一下上一篇所提到的幾個重要名詞，可以簡單對照資料庫
* node : server
* index : database
* type : table
* fields : columns
* documents : rows

## API幾個重要行為
* index： 針對整個`document`，既可以新增又可以更新；
* create：只是新增操作，可以用PUT指定ID，或POST不指定ID；
* update：指的是**部分更新**，官方只是說用POST，請求body裡用script或doc裡包含`document`要更新的部分；
* delete和read：就是發`delete`和`get`這兩種HTTP Method了

# 常用的指令
進入Kibana的管理介面中，左側的導覽列找到一個名為`Dev Tools`的鈕，點擊之後就可以開始下指令囉！
## 查看cluster狀態
如果想查看cluster的當前狀態，可以在Kibana的管理介面執行下方指令
```bash=
GET _cluster/health
```
會回傳一個JSON格式的資料
![](https://i.imgur.com/JlrLJmx.png)
更多cluster health可參考[官方文件](https://www.elastic.co/guide/en/elasticsearch/reference/current/cluster-health.html#cluster-health)
或是執行下方指令可以查看整個cluster的狀態
```bash=
GET _cluster/state
```
![](https://i.imgur.com/fg001vM.png)

## 查看node狀態
如果想查看node的狀態
```bash=
GET _cat/nodes?v
```
![](https://i.imgur.com/IIZlH6F.png)
在預設情況下只會有一個Node
更多用法可以參考官方文件: [Nodes info API](https://www.elastic.co/guide/en/elasticsearch/reference/current/cluster-nodes-info.html)、[cat nodes API](https://www.elastic.co/guide/en/elasticsearch/reference/current/cat-nodes.html#cat-nodes)
## 查看Indice的相關訊息
```bash=
GET _cat/indices?v
```
![](https://i.imgur.com/hnZcWqV.png)
### 上圖中的欄位細節
* `health`: 代表資料點的健康狀態，`red`表資料有缺損無法使用;`yellow` 表資料只有一份沒有`shard`，若單一結點壞損無法進行回復;`green`表資料有 `shard` 的備援若單點損壞依然可以正常運行檢索
* `status` : 是否啟用
* `index` : `index` 檢索名稱
* `uuid` : 唯一識別 key
* `pri` : 主要 `shards` 數量
* `rep` : 副本 `shards` 數量
* `docs.count` : `index` 下總紀錄筆數
* `docs.deleted` : 資料被異動的次數
* `store.size` : 儲存主要資料所佔用的空間
* `pri.store.size` : 儲存副本所佔空間

剛才上述的指令都是在Kibana介面上去操作，不過其實也可以透過cURL的方式來取得回傳資料
![](https://i.imgur.com/Iasfyfc.png)
到該行指令右邊有個板手的icon，點擊後會跳出下拉式選單，選擇**Copy cURL**，接著開啟終端機，貼上剛剛的cURL
![](https://i.imgur.com/5xB69M5.png)

# 其他補充
## `shards`
Elasticsearch可以把一個完整的`Index`分成多個切片(slice)，每個切片(slice)稱作`shard`，好處是可以把一個大的`Index`拆分成多個，分布到不同的Node(節點)上，構成分布式搜尋，加快處理速度，透過水平擴展(horizontally scale)增加資料儲存的總量。
![](https://i.imgur.com/NyM43Pt.png)

### 不過需要注意的是:
* 切分多個`shard`是在`Index`的層級上運作。也就是說，slice的數量只能在`Index`創建前指定，如果`Index`創建後不能更改。 
* 每個`shard`可看作是一個獨立的`Index`

### `shard`分兩種類型
* `Primary shard`: 每個Document都存在一個`Primary shard`。搜尋`document`時，會先在`Primary shard`上加上索引值，然後在此`shard`的所有副本(`replicas`)上加上索引值。索引(`Index`)可以包含一個或多個`Primary shard`（預設值為5）。建好`Index`後，便無法更改`Index`中的`Primary shard`數量。
* `Replica shard`: 每個`Primary shard`可擁有零到多個`Replica shard`。有兩個目的： 增加系統Crash的容忍度;如果`Primary shard`故障，可以將`Replica shard`變更為`Primary shard`。預設情況下，每個`Primary shard`都有一個`Replica shard`，但可以在現有`Index`上動態修改`Replica shard`數量

## `replicas`
代表`Index`副本，白話一點就是備份，而Elasticsearch可以建立多個`Index`的副本，Elasticsearch預設就會啟用`replicas`
值得注意的是：**replica的數量是可以動態修改的**。
假設一種情況，若今天在其中一台Node server壞掉時，啟用備份的資料，用最快的速度還原原始資料，這是一種在災難復原上常用的手段。
副本的作用一是提高系統的容錯性，當個某個Node或某個Shard損壞或遺失時可以從副本中恢復。二是提高Elasticsearch的查詢效率，Elasticsearch會自動對搜尋要求進行負載平衡。
### `replicas`相關運作
* 在`Index`層級進行配置。在建立`Index`時，可選擇每個`shard`可作需要多少個`replica`
* `replicas`是根據`Index`中的`shard`複製的，複製出新的`replica shard`
* 被複製的`shard`被稱作**primary shard**
* `primary shard`和`replica shard`的集合稱作**replication group**

來看張範例架構圖
![](https://i.imgur.com/ZRfEb44.png)
上面的架構圖將一個`Index`分割出兩個`primary shards`，分別做兩個`replica shard`，而`primary shards`與其衍生出來的`replica shards`形成一個**replication group**，故此`Index`涵蓋兩組**replication group**
接著來看`replica shard`是如何設計來做資料還原
![](https://i.imgur.com/xgiAzVa.png)
上圖可知，`replica shard`不會被放在原始的`primary shard`，而是放在不同個`Node`裡面，如`primary shard A`在`Node A`其產生的兩個`replica shards`放在`Node B`，故`Node A`有天突然無法運作時，`Node B`中至少還有一個`replica shards`可以做資料還原。


# 參閱
* [Elasticsearch中的一些重要概念](https://juejin.im/post/5dfab512e51d455802162b70)
