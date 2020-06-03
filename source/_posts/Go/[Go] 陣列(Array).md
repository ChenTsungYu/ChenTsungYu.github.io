---
title: "[Go] 陣列(Array)"
catalog: true
date: 2020/01/08 20:23:10
tags: Go
categories: Backend
---
<!-- toc -->
# 前言
陣列是一個有著編號的序列(索引值0為開頭)，陣列裡的每個元素都有相同的單一型別，元素的型態及個數決定了陣列的型態。
<!--more--> 
# 宣告
宣告陣列時，在`[]`內放入元素個數，並且宣告元素的資料型態，索引值由`0`開始。
如:宣告一個放3個integer的陣列(容器)
```go=
var arr [3]int
```
也可在上述範例放入`{}`，必須採**短語法的方式**。
```go=
arr := [5]int{0, 1, 2}
```
>如果賦值的數量比陣列大小還少，會自動給予初值，就是從編號`0`開始填。
![](https://i.imgur.com/gYaAxpz.png)

>也可以使用`...`，或者給予一個空陣列，只寫`[]`，讓編譯器自動判斷數量
```go=
arr := [...]int{1, 2, 3, 4, 5}
fmt.Println(arr) // [1 2 3 4 5]
// 或是
arr := []int{1, 2, 3, 4, 5}
fmt.Println(arr) // [1 2 3 4 5]
```
### 分行宣告
有時陣列可能會太長而無法用一行來表示，可以用下面的方式來分行:
```go=
x := [5]float64{ 
    1, 
    2, 
    3, 
    4, 
    5,
}
```



>如果宣告的元素數量超過`[]`中指定的數量，那麼會有`out of bounds`的編譯錯誤。

### 錯誤宣告
若採用一般宣告的方式，會報錯。
```go=
var arr [5]int{0,1,2}
```
![](https://i.imgur.com/wIwYYxE.png)

# 檢視長度
使用`len()`檢視陣列長度(或做容器大小)
```go=
var arr [5]int{0,1,2}
fmt.Println(len(arr)) // 5
```

## 指定元素
### 指定某個位置的值
可針對某個位置的元素進行賦值
```go=
package main

import "fmt"

func main() {
	var arr [5]int
	arr[1] = 100
	fmt.Println(arr) // [0 100 0 0 0]
}
```
### 搭配`for` loop
```go=
var arr [10]int
for i := 0; i < 10; i++ {
    arr[i] = i
}
fmt.Println(arr) // [0 1 2 3 4 5 6 7 8 9]
```

### `for range`
除了一般方法，也可以用`for index, value range`
```go=
var total float64
x := [5]float64{98, 93, 77, 82, 83}
for index, value := range x {
    fmt.Println(index)
    total += value
}

fmt.Println(total / float64(len(x)))
```
### 比較簡潔的方式
若`for`不需要索引的情況下，可以採用`_`避免因為定義`index`卻未使用，導致編譯器報錯的問題。
```go=
var total float64
x := [5]float64{98, 93, 77, 82, 83}
for _, value := range x {
    total += value
}
fmt.Println(total / float64(len(x)))
```
> `_`為Go中的`blank identifier`

# 陣列的比較
要比較不同陣列長度與陣列內的元素，需要型態相同才可以做比較，如果將 `[5]int` 與 `[10]int` 做比較，編譯器編譯時會發生 `mismatched types` 的錯誤訊息，而指定陣列給另一陣列時，也必須是相同型態的陣列。

# 巢狀陣列
如果想要做一個多維陣列，可以使用巢狀陣列來完成。
如: 建立一個2X2的陣列
```go=
package main

import "fmt"

func main() {
    var arr [2][2]int
    fmt.Println(arr)   // [[0 0] [0 0]]
}
```

# 參考
[身為複合值的陣列](https://openhome.cc/Gossip/Go/Array.html)