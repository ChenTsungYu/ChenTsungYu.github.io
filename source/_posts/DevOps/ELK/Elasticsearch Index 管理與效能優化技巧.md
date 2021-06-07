---
title: "[ELK] Elasticsearch Index 管理與效能優化技巧 "
date: 2021-06-06 23:00:53
tags: [DevOps, ELK, Conference]
categories: [Conference]
toc: true
---
# 前言
上週 參與保哥在臉書上發起的直播活動 - **Elasticsearch Index 管理與效能優化技巧**，邀請喬叔(Joe)來跟大家分享自己過去在管理 Elasticsearch 的經驗。

半年多前因工作需要，開始接觸 [Elastic](https://www.elastic.co/) 這家公司的產品，最有名的莫過於搜尋引擎 - **Elasticsearch**，自己花不少時間摸索這項複雜的大型分散式系統上，這過程也因喬叔於三十天鐵人賽撰寫的[喬叔帶你上手Elastic Stack](https://ithelp.ithome.com.tw/users/20129543/ironman/3148) 系列文章中獲益良多(**聽說之後要出書，還不買爆！**)，剛好這次喬叔本人受邀分享，千載難逢的機會怎麼能錯過！

本文主要紀錄喬叔在本次座談分享中所提到的實戰技巧及個人經驗分享，還有加入我自己使用的心得，以下資料主要出自喬叔簡報。
<!--more-->
# Elasticsearch 常見的應用
一般會採用 Elasticsearch 不外乎遇到以下場景:
- 全文檢索、資料比對 (Search Engine)
- 數據觀測 (Obseverability) -> 偏向維運面，包含: Log, Metrics, Open Tracing, Monitoring
- 線上分析處理 (OLAP; Online Analytical Processing)
- 資安解決方案 (SIEM; Security Information and Event Management) 
- 大數據 (Big Data)
- 非關聯式資料庫 (NoSQL Database)

# 常見問題
喬叔在本次分享整理幾個大家最常面臨的問題:
![](https://i.imgur.com/EqbkjuW.jpg)

上述問題可從兩個大面向來探討：
- 基於 Java 開發的 Service，運行於 JVM 上，對於記憶體有最基本的要求，即便是小專案要使用，要運行一個 Elasticsearch Cluster 仍有它的最低要求在。
- 若是遇到資料量大的情況下，優化 Elasticsearch Index 有助於提升資源利用，這與 Elasticsearch 底層運作和 [Schema](https://www.elastic.co/blog/found-elasticsearch-mapping-introduction) 如何 Mapping 有關，這也是本次分享的重點。

# Index 管理分兩大塊
- Index 建立之前
- 資料進入 Elasticsearh 之後

# Index 建立之前
> **在資料進入 Elasticsearh 建立 Index 之前，資料該被如何處理？**

喬叔分享了幾個常見技巧:
- Dynamic Mapping
- Index Template
- Index Alias

## Dynamic Mapping
Dynamic Mapping 意指一筆資料進入 Elasticsearch 做 indexing 時，若該筆資料欄位沒有在 Mapping 事先被定義好，Elasticsearch 會自動根據送進來的資料型別進行判斷，依照預設 or 指定的規則產生新欄位的 Mapping 設定。

### Dynamic Mapping 的資料型別判斷規則
下方表格為 Elasticsearch 對送進來的資料預設判定的規則

| JSON 資料型態 | 判定成 Elasticsearch 的資料型態
| -------- | -------- 
| `null` | 不會產生對應的欄位
| `true` or `false` | `boolean`
| 浮點數     | `float`
| 整數     | `long`
| 物件     | `object`
| 陣列     | 根據陣列內的資料型別決定 -> 補充：精確來說是 `陣列中的第一個非空值`的資料型別
| 字串     | 1. 是否為日期格式 2. 是否為 `double` or `long` 格式 3. 若非上述兩種格式，會直接指派 `text` 型別，搭配 `keyword` 型別的作附加欄位(sub-field)

更多細節可參考[文件](https://www.elastic.co/guide/en/elasticsearch/reference/current/dynamic-field-mapping.html)

**補充: `text` 與 `keyword` 的差異**

> 在 Elasticsearch 中，`text` 用於純文字的處理，而 `keyword` 可針對字串進行排序或是聚合(Aggregation)等進階類型的操作。

上述比較圖表中可觀察到 Elasticsearch 對字串做 Dynamic Mapping 時，若非日期 or `double` or `long` 的格式，預設會給`text` 和 `keyword` 兩種型別的資料欄位，類似用空間來換取未來操作的便利性。

喬叔在這邊建議盡量使用自己預先定義好 mapping 的資料型別，以上述的字串型別為例：

Elasticsearch 預設會給定兩個分別為 `text` 和 `keyword` 兩種型別的欄位，等於是在資料處理上會多做一件事情，若預先定義好特定欄位需要的字串型別(如直接指定`text` 或 `keyword`)，可以節省不必要的空間浪費。

### Dynamic Mapping 的好處
有些場景之下很難預判一定只有哪些欄位，例如：系統的 Log，這時 Dynamic Mapping 的優點就是對送進來的資料做 Mapping 設定，動態地建立欄位。

另外要注意的地方是，在原始資料欄位不存在的情況下，Dynamic Mapping 是由**第一筆送進 Elasticsearch 的資料來做決定**。 

### Dynamic Mapping 的實用技巧
- 以 log 為例，若明確知道字串要如何被處理，只有少數特定欄位會是 `text` 的話，可將預設的字串欄位指定為`keyword`，只對特定欄位宣告為 `text` -> 結合 Dynamic Template 設。定e.g. `strings_as_keywords`，設定細節可參考喬叔的[鐵人賽文章](https://ithelp.ithome.com.tw/articles/10238283)
- 若預設送進 Elasticsearch 的資料非常明確是 `text`，無需用到像是 `Aggregation`, `Sorting` or `Script`等操作，就不必保留 `keyword` 類型的 `sub-field`
- 若資料特性大多的數值欄位帶有小數點，且空間並非為最大考量下，可將數值預設為 `double` or `float` -> 避免一開始進來的資料整數，後續送進 Index 資料卻帶有小數的話就無法寫入 Index 裡(因為在 Elasticsearch 的 Index 一旦做好 Mapping ，即無法修改)，有效減少這類非預期的狀況發生。
- 依統一欄位命名規則，套用資料型態
  - 若值為日期時間 -> 以 `_datetime` 做結尾。 e.g. `create_datetime`, `modify_datetime`
  - 若值為整數 -> 以 `_count` 做結尾。 e.g. `play_count`
  - 將特定形態定義於欄位開頭 -> `long_`, `double_`, `int_` 等等，依照團隊達成的共識定義好命名規則
- 必要的嚴謹，避免意外
  - 小心設定 Dynamic Template，特別是修改 Dynamic Template，可能會遇到 Runtime Error (Indexing 時才會報錯)
  - 關閉 Dynamic Field Mapping: 未事先定義的欄位，進入 Elasticsearch 做 indexing 時
    - dynamic: `false`: 這邊需注意，即便設定為 `false`，仍會存在 index 的 `_source` 裡面，不僅不會被 index 且`搜尋時沒有作用`
    - dynamic: `strict`: **此為較佳的做法**，在 indexing 時遇到未被宣告的欄位直接拋出 `exeception`
  - 關閉 `日期` 和 `數值` 的自動判斷： 避免手誤產生非預期的 Mapping，造成無法修改的狀況
 
## Index Template
一般較好的做法是先依合適的 settings 及 mapping 來設置 Index，但隨著時間增加，資料量也會跟著增長，Index 也應該要隨著時間產生新的，需要透過 Index Template 來有效管理這些動態增長的 Index

### Index Template 的好處
當新的 Index 要被建立時，若符合預先設定好的 Index Template 中的 `index_pattern`，Elasticsearch 會依據 Template 的設定來建立 Index

### Index Template 使用建議
喬叔分享個建議：
- 針對 Index Template 的 `index_pattern` 和 `priority` 來建立結構化的管理方式，e.g. `index_pattern` 設為`logs-xxxx-*` ，這類規則擁有繼承效果，如: `logs-20210101-v1` 與 `logs-20210101-v2` 可套用於同個 Template(pattern 為 `logs-xxxx-*`)
- `version` 一定要給，同時建議將該 Template 的基本描述以及最後更新時間記錄於 `_meta` 之中，以便於維護與管理
- 抽出可共用的設置，變成 **Component Template**，增加重用性，管理起來更容易。
- 善用 `Simulate API` 來驗證 Index Template 產生的結果及影響範圍
- 可多參考官方及他人的 Index Template 設計方式

## Index Alias
透過**別名**來存取一個 or 多個 Index，喬叔提供幾個建議：
- 盡量全面使用 Index Alias 來存取 Index:
  - 若非 **time-series index**，原始 Index 可加入 `_v1` 這類的版本號，Alias 可用原始名稱，如：song alias 指向 `song_v1` 的 Index => 未來要修改或是 reindex 時，較不影響使用端
- 善用 Index Alias 搭配 Filter
  - Filter 在 Elasticsearch 是 Cacheable 的搜尋用法，相較一般的 query，filter 可被 cache，效能也較佳
  - Filter 類似於關連式資料庫的 View
  - 適度將 filter 封裝於 alias 中，降低使用端的複雜化查詢
  - 資料存取範圍的權限管理： 限制使用者**只能存取特定子集合** or **特定時間範圍**的資料，適度搭配 security 權限控管，可避免使用者存取到不應取得的資料，或是一口氣查詢太多的舊資料，對效能產生影響
- 配合 `routing` 來指定資料寫入特定的 shard: Elasticsearch 是一個 Cluster 的架構，一般來說都會設置許多 replicaions，這些 replicaions 可能會分散於多台機器上。
  - 資料在 Indexing 時，會依據 routing value 決定資料要寫入哪個 shard 上面，若有指定 routing value，同樣 routing value 的資料會被計算放到相同的 shard 上，對於 performance 優化與管理資料都有幫助 => e.g. 相同使用者 or 相同地區的資料寫入相同的shard 上，可提升 routing 的 **cache hit rate**
- 配合 Index Management Lifecycle Management (ILM): 使用 ILM 功能來管理會隨時間增長的資料，搭配 Index Alias 來切換寫入 Index 時指定的實體 Index 

# 資料進入 Elasticsearh 之後
寫入 Elasticsearh 之後，要考量的面向變成如何管理保留在 Elasticsearh 的資料
## Segment File 的數量
Elasticsearh 的底層用 Apache Lucene 來建立 Index，建立好的 Index 實際上是寫入硬碟裡面，也就是 Segment File，Segment File 數量多寡 Elasticsearh 有影響，數量越多對 **查詢速度** 和 **硬碟空間** 越不好。
## Shard 的數量
Elasticsearh Shard 的數量多，表資料被切分成很多塊，可放置在不同台機器做處理，這有助於**大量寫入(indexing)** => 有多台機器分擔寫入的工作，故 **Shard 越多，indexing 的速度愈快**，但**查詢成本愈高**，單一 shard 愈大，則 Cluster 的 Rebalance 成本愈高
## Index 的大小
**Index 愈大，查詢效率愈好**(資料都放在同個 Index 裡面)，但是會影響資料移轉的等待時間，如 time-series 資料可能會依據時間移轉至不同的階段(hot -> warm -> cold 等不同階段)
## 資料的新舊程度
新資料通常**使用頻率較高**，會給較好的硬體資源，較舊的資料因為使用頻率較低，可配置較差的硬體資源
## 時間粒度
遇上資料量較大的情形，觀察過往的資料去切分較大的時間粒度，查看匯總結果，如：每天的 log 數量、每天的銷售金額等等

## Index 數量
資源有限，移除過舊的資料，只保留匯總結果

## 資料的安全性
- 妥善規劃存取限制
- 記得備份！

# Index 生命週期管理： Index Lifecycle Management 
大部分存在 Elasticsearch 的資料都是**隨著時間變化的**。
隨著時間增長，如何管理且有效利用保存在 Elasticsearch 的資料顯得格為重要，官方對於**時間序的資料**建議採用熱溫冷架構搭配Index Lifecycle Management 進行管理

## 熱溫冷架構： Hot-Warm-Cold Architecture 
又稱三溫暖架構(?)，官方的 [Blog](https://www.elastic.co/blog/implementing-hot-warm-cold-in-elasticsearch-with-index-lifecycle-management) 有更詳細的解釋，這邊簡單摘要
- **Hot Phase**: 此階段存放**最新的資料**，同時使用機率也最高，所以會負責處理 indexing 的資料，還有頻繁的搜尋請求 => 配置較多的 `primary shard`。
- **Rollover**: 由於資料會隨時間增長，透過 Rollover 的機制，對 Index 進行 Rotate，進而產生新的 Index 來接新的資料，原先的 Index 則會進入下個階段
- **Warm Phase**: 當一份 Index 的資料成長到一定的量 or 已經過了一段時間，則將該資料轉到 Warm 階段，這時的資料是 `read-only` 的，也就是不處理寫入 Index 的請求，只能被搜尋。
- **Cold Phase**: 當一份 Index 資料經歷一段較長的時間，使用頻率較少時，將其轉移到 Cold 階段，並且針對這些資料進行冷凍(Freeze)處理，此時資料會以最節省系統資源的狀態下進行保存，查詢的速度又會比 Warm 階段來得更慢。
- **Delete**: 對不再需要存放於 Elasticsearch 的 index 進行刪除(可設定備份成功後才移除 Index)

## 快照週期管理: Snapshot Lifecycle Management(SLM)
- 可設定任務做定期備份
- 可設定備份的保存時間與數量 -> 確保備份佔用的空間不會無限制增長

# Elasticsearch 相關術語
- **Node**: Elasticsearch 實例(Instance)，可以看成叢集(Cluster)中的一個節點，一個 Node 為一個 process，一般情況下：一台機器執行一個 Elasticsearch 的 process。 補充：官方建議一台機器的 JVM heap size 不超過 32G
- **Cluster**: 表一個叢集，叢集中包含多個節點，節點之間會分工處理、或執行備援任務
- **Index**: 可視為一個資料庫，擁有1~多個 shard (分片)，資料會被分配到這些 shard 中
- **Shard**: 一個 Lucene index 的儲存單位，裡面存有多個 segments，同時也是 Cluster 資料搬移的最小單位
- **Segment**: 實際寫入 Disk 的 Lucene index 的**唯獨檔案**
- **Document**: 指 Elasticsearch 一筆筆的資料

## Elasticsearch 如何保存資料？
![](https://i.imgur.com/Alqjr11.jpg)
上圖源自喬叔簡報，解釋 Elasticsearch 存放資料的整個架構 - [elasticsearch persistence model](https://www.elastic.co/blog/every-shard-deserves-a-home)

從上面分層的架構圖來看，資料寫入 Elasticsearch 時，因 Elasticsearch 透過 Lucene 做 indexing 時，大部分的時間都是保存在記憶體，經過 Refresh 1 秒(預設是1秒)，才能在 Elasticsearch 中查詢到，滿 **30mins or 512mb** 時才會執行 **Flush**，將資料寫到 Disk 裡面。

為避免資料遺失(真正寫入 Disk 而非留在記憶體)，Elasticsearch 會先寫 **Translog**(每 5 秒寫一次) 到 Disk 上。

即便是 Elasticsearch 預設的配置還是有可能發生資料遺失的狀況，所以要設置 replica 才能在發生資料遺失時還原資料。

# Elasticsearch 其他優化方法
## Index 效能優化
- Indexing 大量資料時，善用 bulk request 減少來回 indexing 的次數 => 不過要注意 bulk 一次寫入的資料量過大可能會吃光所有的記憶體
- 善用 multi-thread / multi-worker 做 indexing 
- 調低 or 暫時關閉 `refrersh_interval`
- 指定 routing 方式，減少 thread 數量
- **第一批**資料做 indexing 時，先不設定 replica
- 關閉 java process swapping
- 調高 indexing buffer 大小
- 調整 Translog 的 Flush 設定，減少 Disk I/O

## 搜尋優化
- 善用並將 filter 條件切割，增加 cache 利用率
- 搜尋欄位愈少愈好
- 少用 `join`, `nested`, `regex` 
- 少用 `script`
- 依據 Aggregation 的需求 Pre-index 資料
- 盡量使用 keyword 當 identifier 型態
- 將不會再使用的 index 做強制合併
- 在 query 或 aggregation 需求量較高的環境，安排特定的 cordinating Node
- 控制 replica 數量，不設過多得 replica

# 小結
本次線上直播活動滿滿的乾貨，從 Elasticsearch 的概念、原理到應用方法，這麼多的資訊量實在很難在一時之間消化，這兩週週末花了點時間把分享內容整理到本篇文章，非常感謝喬叔在本次活動分享這麼多寶貴的實戰經驗，之後可以把這些知識慢慢的運用在實際工作上！

# 資源
- [Will 保哥的技術交流中心 - Elasticsearch Index 管理與效能優化技巧](https://www.facebook.com/will.fans/videos/871207100098404)
- [[簡報] 喬叔 Elasticsearch Index 管理技巧與效能優化](https://www.slideshare.net/joe9991/elasticsearch-index-248582029?fbclid=IwAR2J6PcHzmpQr_Y2m5UE7dKn9zoWBUicSfC9zgyXarjpyeNErN7Pd6kmMWM)
- [喬叔教 Elastic - 10 - 管理 Index 的 Best Practices (2/7) - 三溫暖架構 - Hot Warm Cold Architecture](https://ithelp.ithome.com.tw/articles/10243650)