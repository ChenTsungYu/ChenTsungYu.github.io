---
title: "[Redis] Redis 資料結構 - Lists"
catalog: true
date: 2022/01/06 20:23:10
tags: [Redis]
categories: Backend
toc: true
---
<!-- toc -->

# 前言
![](/images/Redis-Logo.png)

延續 [上篇](https://chentsungyu.github.io/2022/01/05/Database/Redis/%5BRedis%5D%20%E8%B3%87%E6%96%99%E9%A1%9E%E5%9E%8B%20-%20String/) 討論到 Redis 基礎的資料結構 - String，本篇要討論另一個資料結構 - **Lists**

<!-- more -->

# 什麼是 Lists？
[Ref: Lists](https://redis.io/docs/manual/data-types/#lists)

Redis 的 `Lists` 為有順序的列表，可於列表的起始或末端添加 or 刪除裡頭的元素

來看看 Redis 對 `Lists` 提供哪些常用的指令吧！

## LPUSH
[Ref: LPUSH](https://redis.io/commands/lpush/)

將元素添加到指定 key 裡的列表的第一個位置，可一次寫入多筆元素。

回傳值: **列表的長度**

**語法：**
```
LPUSH key element [element ...]
```

**範例：**
於 mylist 裡一次寫入三筆元素 a, b, c
```
LPUSH mylist a b c
```
透過 `LRANGE` 將資料列出來
```
LRANGE mylist 0 -1

Output:
1) "c"
2) "b"
3) "a"
```
![](https://i.imgur.com/Citfzgj.png)
結果得知，c 在 `LPUSH` 指令裡面是最尾端，從 `LRANGE` 得出的結果是放在第一位

## LRANGE
[Ref: LRANGE](https://redis.io/commands/lrange/)

**語法：**
```
LRANGE key start stop
```
- `start` 索引的起始位置，預設起始點為 0
- `stop` 索引末端的位置，可用 -1 表示最尾端

> 注意: 超出範圍的索引(Out-of-range indexes)
> 超出範圍的索引不會產生錯誤，若 `start` 大於列表的尾端，則回傳一個的空列表。若 `stop` 超過列表末端的實際索引值，Redis 會將其視為列表的最後一個元素。

**`start` > `end`**
![](https://i.imgur.com/nDhthle.png)

**`stop` 超過列表末端的實際索引值**
![](https://i.imgur.com/vzy9hQU.png)

## RPUSH
[Ref: RPUSH](https://redis.io/commands/rpush/)

將元素添加到指定 key 裡的列表的末端位置，可一次寫入多筆元素。

回傳值: **列表的長度**

**語法：**
```
RPUSH key element [element ...]
```

**範例：**
於 pushlist 裡一次寫入三筆元素 d, e, f
```
RPUSH pushlist d e f
```
透過 `LRANGE` 將資料列出來
```
LRANGE pushlist 0 -1

Output:
1) "d"
2) "e"
3) "f"
```

![](https://i.imgur.com/cuWa3tX.png)

## RPUSHX && LPUSHX
[Ref: LPUSHX](https://redis.io/commands/lpushx/)、[Ref: RPUSHX](https://redis.io/commands/rpushx/)

`RPUSHX` 類似前述的 `RPUSH` 方法，於列表的末端插入一個 or 多個元素，只是 `RPUSHX` 需指定的 key 是已存在 Redis 的情況下才會添加新元素，而 `LPUSHX` 也是一樣的概念。 

回傳值: **列表的長度**

**語法：**
```
# LPUSHX
LPUSHX key element [element ...]

# RPUSHX
RPUSHX key element [element ...]
```

若原始的 key 不存在 Redis, 回傳值為 **0** 
![](https://i.imgur.com/VSdHOjC.png)

反之若 key 存在則會添加元素
```
RPUSHX pushlist a b c

Output:
LRANGE pushlist 0 -1
1) "d"
2) "e"
3) "f"
4) "a"
5) "b"
6) "c"
```
![](https://i.imgur.com/OjFLQZN.png)
```
LPUSHX pushlist 123 456

Output:
LRANGE pushlist 0 -1
1) "456"
2) "123"
3) "d"
4) "e"
5) "f"
6) "a"
7) "b"
8) "c"
```
![](https://i.imgur.com/Q0GjXGU.png)

## RPOP
[Ref: RPOP](https://redis.io/commands/rpop/)、[Ref: LPOP](https://redis.io/commands/lpop/)

- LPOP：刪除並回傳存在 key 的列表裡 **第一個元素**
- RPOP：刪除並回傳存在 key 的列表裡 **最後一個元素**
- 若元素不存在，回傳值為 `(nil)` 
- 可指定移除元素的數量(指定個數超過原有數量時表 **全部移除**)

**語法：**
```
RPOP key [count]
```

`[count]` 為刪除的個數，


**範例1： 移除單一元素**
將 pushlist 裡的最後一個元素 `"c"` 移除
```
# 前述的 pushlist 範例
LRANGE pushlist 0 -1

Output:
1) "456"
2) "123"
3) "d"
4) "e"
5) "f"
6) "a"
7) "b"
8) "c"

# 移除 pushlist 裡的元素
RPOP pushlist

Output:
"c"

# 查看移除元素後的 pushlist
LRANGE pushlist 0 -1
 
Output:
1) "456"
2) "123"
3) "d"
4) "e"
5) "f"
6) "a"
7) "b"
```
![](https://i.imgur.com/PgKTGmo.png)

**範例2： 移除多個元素**
把語法裡的 `count` 參數加進來，指定要移除的元素個數

```
# 前述的 pushlist 範例
LRANGE pushlist 0 -1

Output:
1) "456"
2) "123"
3) "d"
4) "e"
5) "f"
6) "a"
7) "b"

# 指定移除 pushlist 裡最後 3 個元素
RPOP pushlist 3

Output:
1) "b"
2) "a"
3) "f"
```

## LTRIM
[Ref: LTRIM](https://redis.io/commands/ltrim/)

`LTRIM` 用來擷取特定範圍的元素

**語法：**
```
LTRIM key start stop
```
- `start` 以 0 為起始點開始索引的位置
- `stop` 索引的終點，可用 `-1` 表最後一個元素

**範例：**
在 trimlist 裡有三個元素：**"one", "two", "three"**
```
RPUSH trimlist "one" "two" "three"
```

取出 "two", "three" 兩個元素
```
LTRIM trimlist 1 -1

Output
1) "two"
2) "three"
```

![](https://i.imgur.com/3flJjm0.png)

> **Note:** 
> 超出範圍的索引不會產生錯誤如： `start` 大於列表的尾端，或者 `start` > `end`，回傳值是一個 **空列表**（**這會導致 key 被刪除**）。如果 `end` 大於列表的尾端，Redis 會將其視為列表的最後一個元素。

## LSET
[Ref: LSET](https://redis.io/commands/lset/)

指定索引位置所在的元素進行替換

**語法：**
```
LSET key index element
```

**範例：**
於 lset 裡放置三個元素："one", "two", "three"
```
RPUSH lset "one" "two" "three"
```
分別對第0、倒數第2個元素做替換
```
LSET lset 0 "four"

LSET lset -2 "five"

LRANGE lset 0 -1

Output:
1) "four"
2) "five"
3) "three"
```

![](https://i.imgur.com/pT3sx25.png)

## LINDEX
[Ref: LINDEX](https://redis.io/commands/lindex/)

查找指定索引位置所在的元素，回傳找到的元素，若超過 list 索引的位置則回傳 `(nil)`

**語法：**
```
LINDEX key index
```

**範例：**
list 添加三個元素 "one", "two", "three"
```
RPUSH list "one" "two" "three"
```

查找索引位置在 2 的元素
```
LINDEX list 2

Output:
"three"
```

## LINSERT
[Ref: LINSERT](https://redis.io/commands/linsert/)

於列表裡挑出一個元素作為參考點，選擇於參考點的前 or 後添加新元素

**語法：**
```
LINSERT key BEFORE | AFTER pivot element
```
`pivot` 指定作為參考點的元素



**範例：**
```
RPUSH list "one" "two" "three"
```
於元素 "one" 前方插入新的元素 "zero"
```
LINSERT list BEFORE "one" "zero"

LRANGE list 0 -1

Output:
1) "zero"
2) "one"
3) "two"
4) "three"
```

於元素 "three" 後方插入新的元素 "four"
```
LINSERT list AFTER "three" "four"

LRANGE list 0 -1

Output:
1) "zero"
2) "one"
3) "two"
4) "three"
5) "four"
```

若參考點不存在時，回傳值為 **-1**
```
LINSERT list AFTER "djrjtlret" "five"

Output:
(integer) -1
```

若 key 不存在時，回傳值為 **0**

## LLEN
[Ref: LLEN](https://redis.io/commands/llen/)

查找存在 key 的列表的長度。

**語法：**
```
LLEN key
```

## LREM
[Ref: LREM](https://redis.io/commands/lrem/)

用於刪除 key 列表中出現特定次數的指定元素

```
LREM key count element
```
`count` 參數表指定的次數

規則如下：
- count `> 0`: 刪除 key 列表中 **從起始點到終點**出現特定次數的指定元素
- count `< 0`: 刪除列表中 **從終點到起始點** 出現特定次數的指定元素
- count `= 0`: 刪除 **所有** 存於 key 列表中的指定元素


**範例1： 從終點到起始點移除元素**
建立 mylist 列表，列表內的值包含 4 個 "hello", 1 個 "world" 的元素
```
LPUSH mylist "hello" "hello" "world" "hello" "hello"

LRANGE mylist 0 -1

Output:
1) "hello"
2) "hello"
3) "world"
4) "hello"
5) "hello"
```

現在要 mylist 裡從 **終點開始** 移除 **2** 個 **hello** 元素
```
LREM mylist -2 "hello"

LRANGE mylist 0 -1

Output:
1) "hello"
2) "hello"
3) "world"
```
重新查看 mylist 得到新的結果是最後兩個 "hello" 元素已從 Redis 內移除


**範例2： 從起始點到終點移除元素**
建立 fruit 列表，列表內的值包含 3 個 "mango", 1 個 "peach", 1 個 "peach", 1 個 "banana" 和 1 個 grape 的元素
```
RPUSH fruit "mango" "mango" "mango" "peach" "banana" "grape"

LRANGE fruit 0 -1

Output:
1) "mango"
2) "mango"
3) "mango"
4) "peach"
5) "banana"
6) "grape"
```
現在要 fruit 裡從 **起點開始** 移除 **2** 個 **mango** 元素

```
LREM fruit 2 "mango"

LRANGE fruit 0 -1

Output:
1) "mango"
2) "peach"
3) "banana"
4) "grape"
```
重新查看 fruit 得到新的結果是最前面的兩個 “mango” 元素已從 Redis 內移除


**範例3： 移除所有元素**
重複範例二的資料，只是這次將 `count` 設為 **0** 

```
LREM fruit 0  "mango"

LRANGE fruit 0 -1

Output:
1) "peach"
2) "banana"
3) "grape"
```

# 總結
看完前面所有的指令及範例，大概能了解如何在 `Lists` 裡新增、刪除、查詢及修改元素，下一篇紀錄 Redis 儲存物件用的資料結構 - **Hash**

# Reference
- [An introduction to Redis data types and abstractions](https://redis.io/topics/data-types-intro)