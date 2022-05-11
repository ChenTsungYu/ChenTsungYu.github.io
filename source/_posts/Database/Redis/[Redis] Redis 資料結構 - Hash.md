---
title: "[Redis] Redis 資料結構 - Hash"
catalog: true
date: 2022/01/07 20:23:10
tags: [Redis]
categories: Backend
toc: true
---
<!-- toc -->

# 前言
![](https://upload.wikimedia.org/wikipedia/en/thumb/6/6b/Redis_Logo.svg/200px-Redis_Logo.svg.png)

[上一篇](https://chentsungyu.github.io/2022/01/06/Database/Redis/%5BRedis%5D%20Redis%20%E8%B3%87%E6%96%99%E7%B5%90%E6%A7%8B%20-%20Lists/)探討了 Redis Lists 資料結構，本篇將紀錄 Redis 儲存物件用的資料結構 - **Hash**

<!-- more -->

# 什麼是 Hash？
屬於 field-value 集合，適合用於儲存**物件**，與 `string` 不同的點在於 Hash 可以是**多個 field - value** 成對存在

## HSET && HGET && HGETALL && HSETNX
[Ref: HSET](https://redis.io/commands/hset/)、[Ref: HGET](https://redis.io/commands/hget/)、[Ref: HGETALL](https://redis.io/commands/hgetall/)

`HSET` 用於設置 hash，若指定的 field 已存在於 Redis，原有的 field 會被覆寫掉。而 `HGET` 則是取出指定的 hash field 對應的值。

`HGETALL` 則是取得指定的 hash 下所有 field-value

使用 `HSETNX`，只有在該 field 不存在指定的 hash 時才可以設置(回傳值為 1)，反之則不影響原來的 field 對應的 value (回傳值為 0)

**語法：**
`HSET`
```
HSET key field value [ field value ...]
```

`HGET`
```
HGET key field 
```

`HSETNX`
```
HSETNX key field value
```

`HGETALL`
```
HGETALL key
```


**範例：**
建立名為 student 的 hash，同時給定 name, gender, age 這些 field 對應的值
```
HSET student name "Bob" gender male age 22
```

取得 student name 的值
```
HGET student name

Output:
"Bob"
```

取得 student 這個 hash 下的所有 field - value 對
```
HGETALL student

Output:
1) "name"
2) "Bob"
3) "gender"
4) "male"
5) "age"
6) "22"
```

使用 `HSETNX` 對 student 新增名為 hobby 的 field
```
HSETNX student hobby tennis

# 查看 HSETNX 執行後的結果
HVALS student

Output:
1) "Bob"
2) "male"
3) "22"
4) "tennis"
```

再執行一次 `HSETNX` 對 student 新增同個名為 hobby 的 field，由於 hobby 這個 field 先前已存在 student 裡面，故回傳值為 0，且 hobby 還是保持原本的值
```
HSETNX student hobby basketball

(integer) 0
```

## HMGET
[Ref: HMGET](https://redis.io/commands/hmget/)

相較於 `HEGT` 只能指定一個 field，`HMGET` 允許一次指定多個 field，取得對應的 value。 若指定的 field 已存在於 Redis，原有的 field 會被覆寫掉; 不存在 Redis 裡時，回傳值為 `nil`

**語法：**
```
HMGET key field [field ...]
```

**範例：**
延續上個 hash 範例的 student，這次同時指定 name, age 兩個 field 的值
```
HSET student name "Bob" gender male age 22

HMGET student name age

Output:
1) "Bob"
2) "22"
```

field 不存在 Redis 裡時，回傳值為 `nil`。
```
HMGET student name age test

Output:
1) "Bob"
2) "22"
3) (nil)
```
上方範例中 test 為原本不存於 student 的 field，故回傳值為 `nil`

## HVALS && HKEYS
[Ref: HVALS](https://redis.io/commands/hvals/)、[Ref: HKEYS](https://redis.io/commands/hkeys/)

`HVALS`用於取得指定的 Hash 底下所有的 **value**，而 `HKEYS` 則是取得指定的 Hash 底下所有的 **key**

**語法：**
```
HVALS key

HKEYS key
```

**範例：**
延續上個 hash 範例的 student，取得 student 下的所有 values
```
HVALS student

Output:
1) "Bob"
2) "male"
3) "22"
```

取得 student 下的所有 keys
```
HKEYS student

Output:
1) "name"
2) "gender"
3) "age"
```

## HEXISTS
[Ref: HEXISTS](https://redis.io/commands/hexists/)

用於檢查指定的 field 是否存在指定的 key 裡面。

- 回傳值為 **1**：該 field 存在指定的 key 裡面
- 回傳值為 **0**：該 field 不存在指定的 key 裡面 or key 本身就不存在 Redis

**語法：**
```
HEXISTS key field
```

**範例：**
延續 student 的範例，分別檢查 name, test 這兩個 field 是否存在
```
HEXISTS student name

Output:
(integer) 1


HEXISTS student test

Output:
(integer) 0
```

## HDEL
[Ref: HDEL](https://redis.io/commands/hdel/)

於目標 hash 中刪除一個至多個指定的 field

**語法：**
```
HDEL key field [field ...]
```

**範例：**
除除 student 裡的 hobby, age 這兩個 field 
```
HDEL student hobby age

Output:
(integer) 2

HKEYS student

Output:
1) "name"
2) "gender"
```

# 總結
OK! 透過前面的指令和範例了解如何對 `Hash` key 裡的 field 取值、修改、查詢及刪除，下一篇會進入到 Redis 資料結構 - `SET`

# Reference
- [An introduction to Redis data types and abstractions](https://redis.io/topics/data-types-intro)