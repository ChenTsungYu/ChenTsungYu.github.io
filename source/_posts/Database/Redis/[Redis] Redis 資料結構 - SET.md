---
title: "[Redis] Redis 資料結構 - SET"
catalog: true
date: 2022/01/08 20:23:10
tags: [Redis]
categories: Backend
toc: true
---
<!-- toc -->

# 前言
![](https://upload.wikimedia.org/wikipedia/en/thumb/6/6b/Redis_Logo.svg/200px-Redis_Logo.svg.png)

昨日的[文章](https://chentsungyu.github.io/2022/01/07/Database/Redis/%5BRedis%5D%20Redis%20%E8%B3%87%E6%96%99%E7%B5%90%E6%A7%8B%20-%20Hash/)討論到 Redis 儲存物件用的資料結構 - **Hash**，本篇接著探討 Redis 的另一個資料結構 - **SET**

<!-- more -->

# 什麼是 SET？
`SET` 是 Redis 裡 string 的集合，故有`無序`、`唯一(不重複)`等特點， Redis 有支援多個 Set 之間取交集，差集，聯集的操作

## SADD && SMEMBERS
[Ref: SADD](https://redis.io/commands/sadd/)、[Ref: SMEMBERS](https://redis.io/commands/smembers/)

`SADD` 添加新的值至指定的 key set，`SMEMBERS` 查詢指定的 key set 裡所有的值

**語法：**
```
SADD key member [member ...]

SMEMBERS key
```

**範例：**
```
> SADD members "Bob" "Allan" "Jack"

Output:
(integer) 3

> SMEMBERS members

Output:
1) "Jack"
2) "Allan"
3) "Bob"
```

## SISMEMBER
[Ref: SISMEMBER](https://redis.io/commands/sismember/)

用於檢查某個值是否存在指定的 key set 裡。

回傳值為 1 表**存在**; 為 0 則表**不存在**

**語法：**
```
SISMEMBER key member
```

**範例：**
沿用 SADD 範例資料
```
> SISMEMBER members Jack

Output:
(integer) 1

> SISMEMBER members Tom

Output:
(integer) 0
```

## SCARD
[Ref: SCARD](https://redis.io/commands/scard/)

計算指定的 key set 裡的 element 數量，回傳值為計算後的結果

**語法：**
```
SCARD key
```

**範例：**
沿用 SADD 範例資料
```
> SCARD members

Output:
(integer) 3
```

## SMOVE
[Ref: SMOVE](https://redis.io/commands/smove/)

將某個 key set 裡的元素移到另一個指定的 key set 裡，回傳值為 1 表該元素成功移至指定的 key set 裡，反之若回傳值為 0 則表示該元素不在來源 key set or 未執行

> **Note:**
> 這是具有原子性(Atomic) 的操作

**語法：**
```
SMOVE source destination member
```
- `source`：移出元素的來源 set key
- `destination`: 移入元素的目標 set key
- `member`：要搬動的元素

**範例：**
新增兩個 key set，分別是 `sourcememeb`, `destinmemeb`
```
> SADD sourcememeb "A" "B" "C"

> SADD destinmemeb "D" "E"
```
將 `sourcememeb` 裡的 "B" 元素移動至 `destinmemeb` 裡面
```
> SMOVE sourcememeb destinmemeb "B"

Output:
(integer) 1

> SMEMBERS destinmemeb

Output:
1) "B"
2) "E"
3) "D"
```

## SPOP
[Ref: SPOP](https://redis.io/commands/spop/)
從指定的 key set 隨機移除一個 or 多個元素

**語法：**
```
SPOP key [count]
```
- `[count]`: 指定移除的數量，屬於可選(Optional)參數

> **Note**
> 除非有在 `SPOP` 指令後面加上參數指定數量，預設情況下會是移除一個元素

**範例：**
指定移除 popsets 裡的兩個元素
```
SADD popsets "one" "two" "three" "four"
(integer) 4

> SPOP popsets 2

Output:
1) "two"
2) "four"
```

## SREM
[Ref: SREM](https://redis.io/commands/srem/)

用於移除一個 or 多個指定的元素，回傳值為移除的元素數量。若 key set 不存在 or key 裡的元素皆不存在，則回傳值為 0

**語法：**
```
SREM key member [member ...]
```

**範例：**
指定 "two" "three" 兩個元素於 popsets 裡移除 
```
> SADD popsets "one" "two" "three" "four"

> SREM popsets "two" "three"

Output:
(integer) 2

SMEMBERS popsets

Output:
1) "one"
2) "four"
```

## SDIFF && SDIFFSTORE
[Ref: SDIFF](https://redis.io/commands/sdiff/)、[Ref: SDIFFSTORE](https://redis.io/commands/sdiffstore/)

`SDIFF` 可取得多個 set 間的 **差集**，而 `SDIFFSTORE` 則是取得差集後存放至指定的新 key set。

**語法：**
```
SDIFF key [key ...]

SDIFFSTORE destination key [key ...]
```

**範例描述：**
key1 = {a,b,c,d}
key2 = {c}
key3 = {a,c,e}

取得 key1 key2 key3 三者的差集 {b,d}

**範例1：** `SDIFF`
回傳值為： 差集裡的所有 elements
```
> SADD key1 a b c d

> SADD key2 c

> SADD key3 a c e

# 取差集
> SDIFF key1 key2 key3

Output:
1) "b"
2) "d"
```

**範例2：** `SDIFFSTORE`
沿用 `SDIFF` 的範例資料，回傳值為：差集裡的 element 數量，並將回傳值放進新的 key set 裡面
```
> SDIFFSTORE new_key key1 key2 key3
(integer) 2

> SMEMBERS new_key

Output:
1) "b"
2) "d"
```

## SINTER & SINTERSTORE
[Ref: SINTER](https://redis.io/commands/sinter/)、[Ref: SINTERSTORE](https://redis.io/commands/sinterstore/)

概念與 **SDIFF** && **SDIFFSTORE** 兩者類似。
`SINTER` 可取得多個 set 間的 **交集** ，而 `SINTERSTORE` 則是取得交集後存放至指定的新 key set。

**語法：**
```
SINTER key [key ...]

SINTERSTORE destination key [key ...]
```

沿用 **SDIFF** && **SDIFFSTORE** 的範例資料：
key1 = {a,b,c,d}
key2 = {c}
key3 = {a,c,e}

取得 key1 key2 key3 三者的差集 {c}


**範例1：** `SINTER`
```
> SINTER key1 key2 key3

Output
1) "c"
```

**範例2：** `SDIFFSTORE`
將回傳值放進新的 key set 裡面
```
> SINTERSTORE new_inter_key key1 key2 key3
(integer) 1

> SMEMBERS new_inter_key
1) "c"
```

## SUNION & SUNIONSTORE
[Ref: SUNION](https://redis.io/commands/sunion/)、[Ref: SUNIONSTORE](https://redis.io/commands/sunionstore/)

`SUNION`: 取得所有集合裡的元素; `SUNIONSTORE` 將所有取得的元素放入新的 key set

**語法：**
```
SUNION key [key ...]

SUNIONSTORE destination key [key ...]
```

沿用 **SDIFF** && **SDIFFSTORE** 的範例資料：
key1 = {a,b,c,d}
key2 = {c}
key3 = {a,c,e}

取得所有 key1, key2, key3 集合: {a,b,c,d,e}

**範例: SUNION**
```
> SUNION key1 key2 key3

Output:
1) "a"
2) "b"
3) "e"
4) "d"
5) "c"
```

**範例: SUNIONSTORE**
```
> SUNIONSTORE unkey  key1 key2 key3
(integer) 5

> SMEMBERS unkey

Output:
1) "a"
2) "b"
3) "e"
4) "d"
5) "c"
```

# 總結
前述列出了多個常見 Redis `SET` 的指令，透過範例了解如何變動 SET 裡的資料，進階一點還可以對多個 SETS 之間取差集、聯集等。

下篇來討論一下與 `SET` 擁有相似特點，但又不同的 `Sorted Sets` 吧！

# Reference
- [An introduction to Redis data types and abstractions](https://redis.io/topics/data-types-intro)