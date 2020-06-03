---
title: "[Go] Slice(切片)"
catalog: true
date: 2020/01/09 20:23:10
tags: Go
categories: Backend
---
<!-- toc -->
# 前言
`Slice`是在一個陣列中的一個區段，與陣列一樣，`slice` 可透過索引的方式存取，同時也具有長度。但與陣列不同的是，**`slice` 長度是可以改變的**，若只想處理陣列中某片區域可以使用`slice`。
<!--more--> 
> * `slice` 在中括號`[]`之間沒有表示長度的數字
> * `slice` 底層實際上還是個陣列
> * 參考的預設值都是`nil`
> * slice 唯一可以用 `==` 比較的對象為`nil`，儲存`slice`參考的變數也無法進行`==` 比較

# 建立`slice`

## 內建的`make()`方法
建立一個長度為3的`slice`，傳回 slice 的reference(參考)，下方範例表示slic1、slic1會是個參考，型態為`[]int`，參考至同一個。`slice` 實例。
```go=
package main

import "fmt"

func main() {
    slic1 := make([]int, 3)
    slic2 := slic1 // 將slic1儲存的位址值，指定給slic2，slic2 操作的對象，與 slic1 操作的對象是相同的
    fmt.Println(slic1) // [0 0 0]
    fmt.Println(slic2) // [0 0 0]
    slic1[0] = 1
    fmt.Println(slic1) // [1 0 0]
    fmt.Println(slic2) // [1 0 0]
    slic2[1] = 2
    fmt.Println(slic1) // [1 2 0]
    fmt.Println(slic2) // [1 2 0]
}
```

## 分別指定容量與長度
上個範例使用`make([]int, 3)` 方法建立`slice`時，只指定了長度為 3，而**容量預設與長度相同**。
Go可以分別指定長度及容量，語法結構是`make([]type, len, cap)`，`type`表示`slice`內的元素型態，`len`表長度，`cap`表容量。
### 範例
```go=
package main

import "fmt"

func main() {
    slice := make([]int, 3, 5)
    fmt.Println(slice)       // [0 0 0]
    fmt.Println(len(slice))  // 3
    fmt.Println(cap(slice))  // 5
}
```


## 已知`slice`的值下建立`slice`
使用`[low : high]`進行索引，`low`為起始點，`high`為終點(`slice`不包含這個結束點的索引值)。
### 範例
```go=
arr := [5]float64{1,2,3,4,5}
slice := arr[0:5]
```

>* 可以忽略`low`、`high`其中之一，亦可同時忽略`low`、`high`兩者。
>* `arr[0:]` 等同`arr[0:len(arr)]`
>* `arr[:5]` 等同`[0:5]`
>* `arr[:]` 等同`arr[0:len(arr)]`

### 初始特定索引處的值
#### 範例
索引值`0`、`1`、`2` 被初始為 `10`、`20`、`30`，之後指定索引值`5`的地方為`50`，索引值`10`的地方為`100`，其餘未指定之處初始值為`int`的預設值 `0`。
```go=
package main

import "fmt"

func main() {
slice := []int{10, 20, 30, 5: 50, 10: 100}
// 回傳 [10 20 30 0 0 50 0 0 0 0 100]
fmt.Println(slice)
}
```

# `slice` 的長度
和陣列相同，採用`len()`方法，回傳`slice`長度。

# `slice` 操作方法

## `append()`
若要在既有的`slice`下添加元素，可用`append()`方法，會傳回一個`slice`的參考
```go=
func main() {
    slice1 := []int{1, 2, 3}
    slice2 := append(slice1, 4, 5, 6, 7)
    fmt.Println(slice1, slice2) // [1 2 3] [1 2 3 4 5 6 7]
}
```
上面的範例是將`slice1`的內容添加`4, 5, 6, 7`共4個元素到`slice2`裡。

## `copy()`
使用`copy()`方法，將一個`slice`的內容，複製到另一個`slice`。
```go=
func main() {
    slice1 := []int{1, 2, 3}
    slice2 := make([]int, 2)
    fmt.Println(copy(slice2, slice1)) // 2 => 回傳複製的個數
    fmt.Println(slice1, slice2) // [1 2 3] [1 2]
}
```
上面的範例是將`slice1`的內容複製到`slice2`，但因`slice2`在建立時空間(cap)只能容納兩個元素，所以只複製`slice1`的前兩個元素。

> ### 複製時，目標`slice`的容量(cap)必須足夠，否則會發生 `cap out of range`的錯誤訊息

# `Array`與`Slice`差別
* 陣列(Array)本身的位址是固定的，無法改變;切片(Slice)本身儲存的位址值是可以改變。
* `slice` 無法進行`==`比較，`array`可以

# 參考

[底層為陣列的 slice](https://openhome.cc/Gossip/Go/Slice.html)

[Slice](http://golang-zhtw.netdpi.net/06-arrays-slices-and-maps/06-02-slices)

[30天就Go(12)：資料結構 - Slice](https://ithelp.ithome.com.tw/articles/10187994)