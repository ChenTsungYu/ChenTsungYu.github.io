---
title: "[Redis] 提高 Redis 執行效率的方法 - Pipeline"
catalog: true
date: 2022/01/15 13:23:10
tags: [Redis]
categories: Backend
toc: true
---
<!-- toc -->

# 前言
![](/images/Redis-Logo.png)

過去在使用 Redis 指令時，都是一條一條指令發送給 Redis ，每條指令都會經過 **發送指令 -> Redis server 接收指令 -> 處理資料 -> 回傳結果** 的流程，這樣一來一回花費的時間稱作 **round-trip time (簡稱RTT)**，在傳送過程中還需考量網路每次建立連線耗時與延遲問題。

若同時有多條指令要處理時，RTT 就會拉長，為縮短多個指令在同時間排隊分別執行造成的效能問題，Redis 提供 **Pipeline** 的機制，讓多個指令在**同時間執行且不需相互等待**，一次回傳所執行完的結果。 

既然 Pipeline 對於效能提升有幫助，來了解一下 Redis Pipeline 的概念及使用上要注意的項目吧！

<!-- more -->
# Pipeline
如前言所描述，在未使用 Pipeline 之前，是多條指令依序去分批對 Redis 發送指令，從發送指令到收到執行結果，整個過程的等待時間會變長，引入 Pipeline 機制，可讓多個指令一次發送給 Redis server，Pipeline 實現的原理是採用 `Queue` 的方式，以先進先出的方式確保資料的順序性，最後執行 `exec` 指令將 Queue 裡所有的指令一次發送給 Redis。

**依序發送(未使用 Pipeline)**

![](https://i.imgur.com/bKlANy4.png)

如上圖所示，有四條指令依序對 Redis 進行發送，整體花費的時間是四條指令來回花費時間的加總。

**批次發送(使用 Pipeline)**

![](https://i.imgur.com/T3bx5ey.png)

上圖用咖啡色 Pipeline 包起來的所有指令會一次發送給 Redis，只有一次發送的來回時間，相較前面批次的做法花更少的時間，也意味著能夠縮短系統回應時間。

除了 RTT 之外，Pipeline 也提高了 Redis server 中每秒可以執行的指令數量。

這是因為在未使用 Pipeline 一條發送指令的情況下 I/O 成本會很高，這牽涉到系統呼叫 `read()` and `write()` 的轉換，頻繁的 context switch 對 server 會是很大的負擔。

**舉例:**
未使用 Pipeline 的情形下發送 10 條指令，系統呼叫發生 10 次 context switch，若於 Pipeline 裡面將 10 條指令一次發送，只會發生一次 context switch

### 注意
1. **單個 Pipeline 大小:**
   儘管 Pipeline 能有效降低 RTT，減少 I/O 次數，若 client 端使用 Pipeline 將大量指令以類似群組的方式，一次發送給 Redis server，會**消耗大量的記憶體**(群組裡的指令越多，消耗的記憶體資源越大)，同時會增加 client 端的等待時間，及造成一定程度的延遲。
   因此仍須注意 Pipeline **容量不可過大**，過大時盡可能**採用多個 Pipeline 分次發送**，減少單次 Pipeline 的大小(受限於server的記憶體大小)。
   **舉例: 比較2萬條指令不同的發送方式**
   一次性發送和分兩次發送(每次發1萬條指令，讀完資料收到回應後再發另外1萬條指令)。對 client 端來說速度是差不多，但是對 server 端來說，記憶體佔用卻差了1萬條指令回應的大小。
2. 適用於執行連續且**無相依性**的指令(不需仰賴前一個指令的回傳結果)
3. **不擁有原子性(Atomic)**:    
    發送的多條指令裡面可能部分成功，一部分失敗; Pipeline 在 server 上是非阻塞的，意味者若有來自其他 client 發送的 pipeline 不會被阻止，產生交錯執行的狀況。
    
    (如下圖所示，圖片取自 Thomas Hunter 的[簡報](https://www.slideshare.net/RedisLabs/atomicity-in-redis-thomas-hunter))

![](https://i.imgur.com/lwsOef5.png)


## 使用時機
- 需要減少網路延遲，提升效能
- 需要發送多條指令給 Redis，且指令之間沒有相依性(不需等待上個指令的結果)，一次獲得所有結果
- **可靠性要求較低**的需求，允許一定比例的失敗(可後續補償) e.g. 大量發送簡訊

## 與 Transactions(multi) 的差異
`multi` 用於開啟 Transactions。 Transaction 裡多條指令會按照先後順序被放進一個 Queue 裡，最後執行 `EXEC` 指令完成 Transaction。

**兩者差別:**
- **請求次數不同**： `multi` 需要每個指令都發送一次請求給 server 端，Pipeline 則是最後一次性發送給 server 端，請求次數相較 `multi` 少
- **原子性(Atomic)**: Pipeline 不保證原子性，Pipeline 中發送的每條指令都會被 server 立即執行，若執行失敗，將會在回應裡面得到對應得錯誤資訊； Transactions 擁有原子性，不會發生與其他 client 發送指令交互執行的情況(如下圖所示)

![](https://i.imgur.com/0EWIE93.png)

## 範例
Redis 提供各個熱門程式語言函式庫，下方提供 Python 的範例，使用 `redis-py` 這個[官方](https://github.com/redis/redis-py)支援的函示庫。

下方範例會先建立名為 product 的範例資料，裡面包含不同的 t-shirt 樣式，目標是要將範例資料透過 `hset` 的方式寫入 Redis 裡面。

範例的資料結構如下:

![](https://i.imgur.com/I3K9ZSr.png)

**提示:** 保持介面乾淨可以善用下方箭頭收起程式碼區塊
```json=
{
  "shirt:1": {
    "color": "black",
    "price": 49.99,
    "style": "fitted",
    "quantity": 5,
    "nPurchased": 0
  },
  "shirt:2": {
    "color": "maroon",
    "price": 60,
    "style": "Office Shirt",
    "quantity": "6",
    "nPurchased": 0
  },
  "shirt:3": {
    "color": "Pink",
    "price": 79.99,
    "style": "Over Shirt",
    "quantity": "3",
    "nPurchased": 0
  }
}
```

Python code 範例
```python=
# 引入 redis-py 
import redis
import time

# ======= 建立範例資料 =======
product = [
    {
        "color": "black",
        "price": 49.99,
        "style": "fitted",
        "quantity": 5,
        "nPurchased": 0,

    },

    {
        "color": "maroon",
        "price": 60,
        "style": "Office Shirt",
        "quantity": "6",
        "nPurchased": 0,
    },

    {
        "color": "Pink",
        "price": 79.99,
        "style": "Over Shirt",
        "quantity": "3",
        "nPurchased": 0,
    }

]
shirts = dict()
id = 1
for i in product:
    key = f"shirt:{id}"
    shirts[key] = i
    id += 1

print(shirts)

# ======= 建立 Redis Connection Pool =======
pool = redis.ConnectionPool(host='127.0.0.1', decode_responses=True, db=0)

r = redis.StrictRedis(connection_pool=pool)

starttime = time.time()

# ======= 建立 Redis Pipeline，將多條 hset 指令放入 Pipeline 裡等待執行 =======
with r.pipeline(transaction=False) as pipe:
    for s_id, shirt in shirts.items():
        for field, value in shirt.items():
            pipe.hset(s_id, field, value)
    pipe.execute()

output = f'It took {time.time() - starttime} seconds to work.'
print(output)
```

上方範例呼叫函式庫 `redis-py` 裡的 `pipeline()`，將每條 `hset` 指令放入 Pipeline 裡等待最後 `execute()` 呼叫時一次送出。

最後透過 [Redis Desktop Manager](https://resp.app/en/) 這類的視覺化介面工具可以看到被寫入的 t-shirt 資料！

![](https://i.imgur.com/qNFiDdl.png)

另外也可以嘗試不使用 Pipeline 的做法，比較兩者所花費時間。

# 總結
本篇文章討論了 Pipeline 概念、好處、使用時機以及使用上要注意的地方，除此之外也和 Transactions 比較差異，最後實際用程式語言演練一次範例。

# Reference
- [Redis pipelining](https://redis.io/docs/manual/pipelining/)
- [Atomicity In Redis: Thomas Hunter](https://www.slideshare.net/RedisLabs/atomicity-in-redis-thomas-hunter)
- [Redis: Pipelining, Transactions and Lua Scripts](https://rafaeleyng.github.io/redis-pipelining-transactions-and-lua-scripts)
- [Redis uses pipeline to speed up query speed](https://developpaper.com/redis-uses-pipeline-to-speed-up-query-speed/)