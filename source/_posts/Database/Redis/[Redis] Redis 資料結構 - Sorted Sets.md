---
title: "[Redis] Redis 資料結構 - Sorted Sets"
catalog: true
date: 2022/01/09 8:23:10
tags: [Redis]
categories: Backend
toc: true
---
<!-- toc -->

# 前言
![](https://upload.wikimedia.org/wikipedia/en/thumb/6/6b/Redis_Logo.svg/200px-Redis_Logo.svg.png)

上篇談到 Redis 的 **SET** 資料結構，本篇會探討擁有與 **SET** 相似特性的 **Sorted Sets**！相比較兩者之間的差異及用途。

<!-- more -->

# 什麼是 Sorted Sets？
[Ref: Sorted Sets](https://redis.io/docs/manual/data-types/#sorted-sets)
`Sorted Sets` 是 Redis 裡其中一種資料結構，類似於 Set 與 Hash 的混合型。

> 除了擁有 Set 的 唯一(不重複)的特性之外，`Sorted Sets` 裡的元素是 **有序的**! 
> `Sorted Sets` 裡每個 element 都會對應的一個浮點數的值，這個值稱作 `score`，以 `score` 的值由低到高進行排序

藉由 `Sorted Sets` **按順序存放**的特性，可以快速地新增、刪除、修改裡面的 element

- `XX`: 只更新已經存在的元素，不增加新元素
- `NX`: 與 `XX` 相反，只增加新元素。不更新已存在的元素。
- `LT`: 只有當新的 score 值 **低** 於當前 score 時才更新現有元素，仍可增加新元素
- `GT`: 只有當新的 score 值 **高** 於當前 score 時才更新現有元素，仍可增加新元素
- `CH`: `CH` 是 changed 的縮寫，用於添加、修改元素
- `INCR`: 用於增加被指定的 element 的 `score` 


> 注意: `GT`, `LT`,`NX`  三者是**互斥**的

## ZADD
[ZADD](https://redis.io/commands/zadd/)

將 element 添加至指定的 key 裡面，預設情況下 `ZADD` 指定的 `key` 不存在 Redis 時會自動建一個新的。

使用上指令和 `Set` 相似，只要把開頭的 `S` 改成 `Z`，`ZADD` 本身也提供一些參數，可根據使用情境在指令裡加入這些參數。

**語法：**
```
ZADD key [ NX | XX] [ GT | LT] [CH] [INCR] score member [ score member ...]
```

**範例：**
建立一個 students 的 `Sorted Sets`
```
> ZADD students 1 Rob 2 John 3 Smith
(integer) 3
```

透過 `ZRANGE` 將 students 裡的元素從頭至尾(0,-1)取出來
```
> ZRANGE students 0 -1

Output:
1) "Rob"
2) "John"
3) "Smith"
```

於 `ZRANGE` 後方加上 WITHSCORES 的參數可以連同 element 對應的 `score` 一同取出
```
> ZRANGE students 0 -1 WITHSCORES

Output:
1) "Rob"
2) "1"
3) "John"
4) "2"
5) "Smith"
6) "3"
```

**範例： 加上 CH 參數**
加上`CH` 於指定的 key 裡添加新元素，`Sorted Set` 會根據指定 score 的大小對 element 做排序

```
> ZADD students CH 0 Alex 2 Ted
(integer) 2

> ZRANGE students 0 -1 WITHSCORES

Output:
1) "Alex"
2) "0"
3) "Rob"
4) "1"
5) "John"
6) "2"
7) "Ted"
8) "2"
9) "Smith"
10) "3"
11) "Tom"
12) "4"
```
**範例： 加上 INCR 參數**
將 Rob 的 `score` 的值加 2

```
> ZADD students INCR 2 Rob
"3"

> ZRANGE students 0 -1 WITHSCORES

Output:
1) "Alex"
2) "0"
3) "John"
4) "2"
5) "Ted"
6) "2"
7) "Rob"
8) "3"
9) "Smith"
10) "3"
11) "Tom"
12) "4"
13) "Tommy"
14) "4"
```

從結果可觀察到，Rob 因為 `score` 增加至 3，順序變成 Ted (`score` 為2) 之後(上個範例還在 Ted 之前)

## ZRANGE
[ZRANGE](https://redis.io/commands/zrange/)
查詢 `sorted set` 裡指定範圍的元素，查詢的方式包含: 按 index(索引;或稱排名 - rank)、按 `score` 、按 字典順序(lexicographical order)


**語法：**
```
ZRANGE key min max [ BYSCORE | BYLEX] [REV] [LIMIT offset count] [WITHSCORES]
```

- `BYSCORE`: 藉由 `score` 作為指定範圍篩選 elements
- `BYLEX`: 按照 **字母** 範圍篩選，`-` 表起始字母; `+` 表尾端字母。 `(` 符號表 **排除**; `[` 表 **包含**
- `REV`: 表顛倒排序，元素改為從最高分到最低分進行排序
- `LIMIT`: 指定偏移的數量

**範例： 查詢 score 為於 1~3 的所有 elements**
於指令裡加上參數 `BYSCORE` 即可篩選出指定範圍的所有 elements
```
ZRANGE students 1 3 BYSCORE WITHSCORES

Output:
1) "John"
2) "2"
3) "Ted"
4) "2"
5) "Rob"
6) "3"
7) "Smith"
8) "3"
```

**範例： 以 BYLEX 為條件篩選出所有 elements**
可用 `-` 表起始字母; `+` 表尾端字母篩選 key 裡的元素 
```
> ZRANGE students - + BYLEX
1) "Alex"
2) "John"
3) "Ted"
```

**範例： 以 BYLEX 搭配特殊符號篩選 elements**
前面提到 `(` 符號表 **排除**; `[` 表 **包含**

可以利用特殊符號 `(` 搭配 BYLEX 的方式來過濾出指定的 elements。

如：篩選值為 非 Alex 及 Ted 的元素
```
> ZRANGE students (Alex (Ted BYLEX

Output:
1) "John"
```
於指令裡加上 `(Alex (Ted BYLEX` 的篩選條件，我們就可以過濾掉 Alex, Ted 這兩個元素。

同理，可以用特殊符號 `[` 作為納入篩選範圍的條件

如：篩選值為 非 Alex 且包含 Ted 的所有元素
```
> ZRANGE students (Alex [Ted BYLEX

Output:
1) "John"
2) "Ted"
```

## ZREM
[ZREM](https://redis.io/commands/zrem/)
移除指定的 `Sorted Set` key 裡一個 or 多個 element

**語法：**
```
ZREM key member [member ...]
```

**範例：**
移除 Rob
```
> ZREM students Rob
(integer) 1

> ZRANGE students 0 -1 WITHSCORES

Output:
1) "Alex"
2) "0"
3) "John"
4) "2"
5) "Ted"
6) "2"
7) "Smith"
8) "3"
9) "Tom"
10) "4"
11) "Tommy"
12) "4"
```

## ZSCORE
[ZSCORE](https://redis.io/commands/zscore/)

回傳指定 element 對應的 score

**語法：**
```
ZSCORE key member
```

**範例：**
```
> ZSCORE students John

Output:
"2"
```

## ZCOUNT & ZLEXCOUNT
[ZCOUNT](https://redis.io/commands/zcount/)、[ZLEXCOUNT](https://redis.io/commands/zcount/)

`ZCOUNT` 根據 `score` 計算 `sorted set` key 裡的所有元素數量; `ZLEXCOUNT` 根據 

> `ZLEXCOUNT` 一樣適用前述提到的規則:
> 
> `-` 表起始字母; `+` 表尾端字母篩選 key 裡的元素; `(` 符號表 **排除**; `[` 表 **包含**

**語法：**
```
ZCOUNT key min max

ZLEXCOUNT key min max
```

其中 ` min`, `max` 這兩個參數表指定的**最大**和**最小**值，若想要計算整個 key 裡的所有元素數量則是分別加上: `-inf`, `+inf`

**範例：**
計算 students 所有元素數量

```
> ZCOUNT students  -inf +inf
(integer) 6
```



## ZREMRANGEBYLEX
[ZREMRANGEBYLEX](https://redis.io/commands/zremrangebylex/)

透過 `BYLEX` 的規則移除指定的 element

### `BYLEX` 的規則：
> - 表起始字母; + 表尾端字母篩選 key 裡的元素; ( 符號表 排除; [ 表 包含

**語法：**
```
ZREMRANGEBYLEX key min max
```

**範例：**
移除從 Alex 至 Ted 的所有元素
```
> ZRANGE students - + BYLEX
1) "Alex"
2) "John"
3) "Ted"

> ZREMRANGEBYLEX students [Alex [Ted
(integer) 3
> ZRANGE students 0 -1
(empty array)
```


## ZPOPMAX
[ZPOPMAX](https://redis.io/commands/zpopmax/)

移除並回傳最高 score 的元素

**語法：**
```
ZPOPMAX key [count]
```
- count: 移除的數量，大於 1 的話會由 score 最高至次高的element 開始移除

**範例： 未指定數量**
```
> ZRANGE students 0 -1 WITHSCORES
 1) "Alex"
 2) "0"
 3) "John"
 4) "2"
 5) "Ted"
 6) "2"
 7) "Smith"
 8) "3"
 9) "Tom"
10) "4"
11) "Tommy"
12) "4"


> ZPOPMAX students

Output:
1) "Tommy"
2) "4"
```

**範例： 指定數量**
```
> ZPOPMAX students 2
1) "Tom"
2) "4"
3) "Smith"
4) "3"
```

# 常見的案例
- 線上遊戲的積分排行榜:
  善用 `ZADD` 指令可以在每次玩家提交遊戲積分時，於 Redis 內更新該名玩家的積分，依積分高低用 `ZRANGE` 做排序，列出即時積分排名。
- 商城的熱銷排行榜 

# 總結
看完了本篇開頭對 `Sorted Set` 的解釋，以及透過範例實際操作更能了解與 `Set` 之間的差異，藉由 `Sorted Set` 的有序性，在實際應用上提供更多的用途！

# Reference
- [An introduction to Redis data types and abstractions](https://redis.io/topics/data-types-intro)