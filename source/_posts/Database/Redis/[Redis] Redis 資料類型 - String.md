---
title: "[Redis] Redis 資料結構 - String"
catalog: true
date: 2022/01/05 20:23:10
tags: [Redis]
categories: Backend
toc: true
---
<!-- toc -->

# 前言
![](https://upload.wikimedia.org/wikipedia/en/thumb/6/6b/Redis_Logo.svg/200px-Redis_Logo.svg.png)

Redis 是熱門且開源的資料庫，以記憶體為主(in-memory)進行資料存取，並以鍵值 (key-value) 的形式存放資料庫內。

由於資料是基於記憶體進行讀寫，記憶體讀取的速度較一般硬碟來得快！故廣泛地被運用於大型系統裡做資料快取，加快整體系統效能，不僅有助於提高系統回應的速度，同時能減少後端關聯式資料庫的工作量(畢竟前端的 Redis 就已經可以應付使用者送來的請求)。

Redis 本身提供多種資料結構，如: Strings, List, Set, Hash, Sorted Set 等。

## 常見服務應用:
- **快取**：借助記憶體高效能讀取的快取方式，減少硬碟 I/O 的延遲時間，在大型的分散式系統裡幾乎是後端快取的首選。
- **流量 & 速率限制**：有些搶票系統為避免短時間流量暴增，會在系統裡面採用 Redis 做統計，讓網站或線上服務可以視流量狀況作自動化的調整。
- **排行榜功能**：常見於電商、遊戲裡的排行榜活動，藉由 Redis 高效讀取資料的優勢達成近乎即時更新資料，實現即時排名的功能，後續有篇關於 `Sorted Set` 的文章會討論到！

了解 Redis 常見的用途後，接著進入本篇討論重點: Redis 資料結構 - **Strings** 

<!-- more -->

# 什麼是 Strings？
[STRING](https://redis.io/commands/set)

**Strings** 是 Redis 最基礎的儲存型態，一個鍵(key)對一個值(value)，可存放任何形式的資料 e.g. JPEG 圖片或已序列化的物件等，官方提示最大可以儲存 **512 MB** 的資料量

接著來看常見的幾個 Redis 支援對 String 的操作吧！

## SET
[SET STRING](https://redis.io/commands/set)

`SET` 指令後方的必填項目分別是 key 名稱、key 的值，成功新增時會回傳 `OK`，規則如下：
```
SET key value [EX seconds|PX milliseconds|EXAT unix-time-seconds|PXAT unix-time-milliseconds|KEEPTTL] [NX|XX] [GET]
```
### 範例 - 新增一個 key & value:
新增名為 `test` 的 key 且值為 `test key`
```
// set 指令新增
set test "test key"
```
取得 key 對應的值: `get <key_name> `
```
// 取得 test key 的值
get test

// 回傳
"test key"
```

> 若 set 指令指定的 key 已存在，則會 **覆寫** 掉原本的 key 值

### Options for Set
Set 指令後面可以添加額外的參數達成不同的需求，擷取幾個常用的:
- `EX`(in seconds): 設置 key 的存續時間(**TTL**)，到期後自動從 redis 刪除(回傳 `nil`)，單位以 `秒` 計算。常見用法： 儲存 user 登入的 session
- `NX`: 指定的 key 只有原本不存在 redis 時才可設置，若 key 已存在則回傳 `nil`
- `XX`: 指定的 key 只有已存在 redis 時才可設置，若 key 不存在則回傳 `nil`

**Sample**
查看當前擁有的 key：
```
keys *
```
**Output:**
```
1) "test2"
2) "jsondata"
3) "test"
4) "test1"
5) "test3"
```
![](https://i.imgur.com/RS7nLfc.png)

接著於 `Set` 指令後方加上個別參數做比較。

範例：**設置新 key 名為 test4，且值為 4**
- `EX`:
設置 exkey 並給定 TTL 為 5 秒
```
set exkey "test ex key" EX 5
```
![](https://i.imgur.com/xrPZnn7.png)
5 秒之後自動從 Redis 刪除
- `NX`:
```shell=
sample 1:
set test1 4 nx

sample 2:
set test4 4 nx
```
回傳結果為 `(nil)` 表不符合指令裡的 `XX` 參數條件，反之則成立
![](https://i.imgur.com/lzanrFJ.png)
- `XX`:
```shell=
sample 1:
set test4 4 xx

sample 2:
set test1 4 xx
```
回傳結果為 `(nil)` 表不符合指令裡的 `XX` 參數條件，反之則成立
![](https://i.imgur.com/ZEKnUJI.png)

## APPEND
如果 key 已經存在並且是字串(string)，想在該 key 的值後面添加新的字串可用 `APPEND` 指令完成，該指令的回傳值為: 更新後的字串總長度

**範例:**
設置一個名為 greeting 的 key，其當前值為 `"Hello"`
```
set greeting Hello

get greeting
```

透過 `APPEND` 指令添加新的值 `" World"` 到 greeting 裡
```
APPEND greeting " World"

get greeting
```

**Output:**
```
"Hello World"
```
![](https://i.imgur.com/8BO2VI9.png)
回傳值的字串總長度為: 11

## INCR && INCRBY
若想將存於 key 裡的數字做加法，可透過 `INCR` 或是 `INCRBY` 指令完成。 [Ref: INCR](https://redis.io/commands/incr/)、[Ref: INCRBY](https://redis.io/commands/incrby/)

`INCR` 與 `INCRBY` 兩者差異在於：
- `INCR` 每次增加的值為 **1**
- `INCRBY` 可指定增加的值

若是 key 原本不存在於 Redis 而執行 `INCR` 與 `INCRBY` 指令， 指令執行前，Redis 會生成 key 之後給定預設值為 `0`，再執行 `INCR` 與 `INCRBY` 指令。

`INCR` 語法如下:
```
incr <key>
```

下方範例會看到原不存於 Redis 的 testkey，執行 `INCR` 指令後得到的結果為 `1`

![](https://i.imgur.com/f1cZdUb.png)

這是因為 Redis 先產生 `testkey` 並給該 key 的值為 `0`，接著再進行`INCR` 指令對 testkey +1 。

`INCRBY` 也是類似的概念，語法如下:
```
incrby <key> <increment>
```
其中 `<increment>` 為想要增加的值

範例： 將名為 score 的 key 值加 3

![](https://i.imgur.com/z6UymTN.png)
原 score 值為 2，執行 `incrby score 3` 指令後，得到的結果為 `(integer) 5`

> **注意:**
> 由於 Redis 沒有專用的數值型別，所以存在 Redis 裡的字串是以 10 為底的 64 位元形式做處理。
> 
> Note: this is a string operation because Redis does not have a dedicated integer type. The string stored at the key is interpreted as a base-10 64 bit signed integer to execute the operation.

## DECR && DECRBY
[Ref: DECR](https://redis.io/commands/decr/)、[Ref: DECRBY](https://redis.io/commands/decrby/)

與 `INCR` && `INCRBY` 相似，運算方式由加法改為減法，使用方法相同。

## MSET
[Ref: MSET](https://redis.io/commands/mset/)

前述 `SET` 指令皆是針對單一個 key 做設置，若想要一次設置多個 key，可用 `MSET` 來達成。

**語法：**
```
MSET key value [ key value ...]
```


**範例：**
同時建立 key1, key2 兩個 key 並給值 "Hello", "World"
```
MSET key1 "Hello" key2 "World"
```

透過 MGET 同時取得 key1, key2 兩個 key 的值
```
> MGET key1 key2

> Output
1) "Hello"
2) "World"
```
![](https://i.imgur.com/JCN8z03.png)


> **注意:**
> `MSET` 具有關連式資料庫的 **原子性(Atomicity)**，其中一個 key 改動失敗時整個操作就會宣告失敗，故同個操作裡面涉及多個 key 改動時，不會發生只有一部分的 key 變動的情形。
> 
> **Note:** MSET is atomic, so all given keys are set at once. It is not possible for clients to see that some of the keys were updated while others are unchanged.

## MSETNX
[Ref: MSETNX](https://redis.io/commands/msetnx/)

`MSETNX` 是 `MSET` 與前述 `NX` 的結合，表 `MSETNX` 指定的 key 只能是原本不存在 Redis 裡的情況下才能建立。

若 `MSETNX` 指定的 key 皆不存在 Redis 時，回傳值為 `(integer) 1`，反之，只要有一個以上指定的 key 已經存於 Redis 時，回傳值為 `(integer) 0` 

**語法：**
```
MSETNX key value [ key value ...]
```

**範例：**
```
MSETNX key3 "k3" key4 "k4"
```
key3, key4 原不存在 Redis 裡，執行 `MSETNX` 後回傳結果為 `(integer) 1`，若再重複執行一次則會得到 `(integer) 0` 的結果

![](https://i.imgur.com/iiYTiEl.png)

若嘗試用 key5 替代 key3 同時保留 key4 執行 `MSETNX`，由於 key4 先前已存在 Redis，故回傳結果一樣是 `(integer) 0` 
![](https://i.imgur.com/in8eQlN.png)

用 GET 檢查 key5 可發現 key5 沒有被寫入 Redis 裡面，證明剛剛提到 `MSET` 具有原子性
![](https://i.imgur.com/rADq3zr.png)

## GETRANGE
[Ref: GETRANGE](https://redis.io/commands/getrange/)
從 key 裡提取某段字串，可用 `GETRANGE` 來完成。

**語法：**
```
GETRANGE key <start> <end>
```
- `<start>` 起始位置(從0開始)
- `<end>` 終點位置(-1 表字串的末端)

**範例：**
提取 range key 裡所有的值
```
SET range hello

GETRANGE range 0 -1
```
![](https://i.imgur.com/0FmOxFE.png)

**其他範例:**
```
> GETRANGE range 0 3

> Output
> "hell"


> GETRANGE range -3 -1

> Output
> "llo"

> GETRANGE range 0 1000

> Output
> "hell0"
```

## SETEX
[Ref: SETEX](https://redis.io/commands/setex/)

用於設置具有時效性的 key

**語法:**
```
SETEX key seconds value
```
設置 exkey 並給定 TTL 為 5 秒
```shell=
setex exkey 5 "test ex key"
```
![](https://i.imgur.com/qDooeqz.png)
5 秒之後自動從 Redis 刪除

## SETRANGE
[Ref: SETRANGE](https://redis.io/commands/setrange/)

用於覆寫被指定的 key 內容，該指令會從指定的偏移量開始，覆寫整個值

**語法：**
```
SETRANGE key <offset> <value>
```
- `<offset>` 表偏移量

**範例：**
設置 k1 的值為 "hello world!"
```
SET k1 "hello world!"
```
目標是將後面的 world 替換成 Redis，故於偏移量設定為 **6** (w 開頭的位置)
```
setrange k1 6 Redis
```

**Output:**
```
"hello Redis!"
```
![](https://i.imgur.com/bHSdz74.png)

## STRLEN
[Ref: STRLEN](https://redis.io/commands/strlen/)

計算存於 key 裡的值的長度，回傳結果為該字串的總長度

**語法：**
```
STRLEN key
```

![](https://i.imgur.com/LZplz7j.png)

# 總結
前面探討了幾個 Redis 裡常見對 String 的操作，以及不同情境下可使用的方式，下篇將討論 Redis 資料結構 - List

# Reference
- [An introduction to Redis data types and abstractions](https://redis.io/topics/data-types-intro)