---
title: "[Go] Slice(切片)"
catalog: true
date: 2020/01/09 20:23:10
tags: Go
categories: Backend
toc: true
---
<!-- toc -->
# 前言
`Slice`是在一個陣列中的一個區段，與陣列一樣，`slice` 可透過索引的方式存取，同時也具有長度。但與陣列不同的是，**`slice` 長度是可以改變的**，若只想處理陣列中某片區域可以使用`slice`。
<!--more--> 
> * `slice` 在中括號`[]`之間沒有表示長度的數字
> * `slice` 底層實際上還是個陣列
> * 參考的預設值都是`nil`
> * slice 唯一可以用 `==` 比較的對象為`nil`，儲存`slice`參考的變數也無法進行`==` 比較

# Slice 基礎用法
## 宣告 slice
slice宣告方法有兩種：
1. 像array一樣宣告, 不須指定 slice 大小
2. 使用內建函數make

### 像 array 一樣宣告
```go=
a := []int{1, 2, 3, 4, 5}
fmt.Println(len(a))  //5
fmt.Println(cap(b))  //5
```
### 使用內建函數 make
除了上述方法外， Golang 提供了一個名為 `make()` 的函數來建立 slice。 它分配 **長度**與**給定容量相同的底層陣列**，並返回參考該陣列的 slice。
#### 語法結構:
```go=
make([]T, len, cap)
```
參數說明：
- `T`: 該 slice 存放的資料類型 
- `len`: 該 slice 的長度
- `cap`: 該 slice 的容量，此參數是`非必要`的。若省略，則預設為**指定的長度**

#### 範例:
有指定 slice 的容量：
```go=
func main() {
    s := make([]int, 5, 10)

    fmt.Println(s)       // [0 0 0 0 0]
    fmt.Println(len(s))  // 5
    fmt.Println(cap(s))  // 10
}
```
沒有指定 slice 的容量：
```go=
func main() {
    s := make([]int, 5)

    fmt.Println(s)       // [0 0 0 0 0]
    fmt.Println(len(s))  // 5
    fmt.Println(cap(s))  // 5
}
```
## Slice 的零值
slice 的零值為 `nil`。帶有零值的 slice 沒有任何底層陣列，且`長度和容量為 0`
```go=
var slice []int

// zero value of a slice is nil
fmt.Println("slice == nil?", slice == nil) // true

fmt.Printf("slice = %v, len = %d, cap = %d\n", slice, len(slice), cap(slice)) // slice = [], len = 0, cap = 0
    
var games []string
game := []string{}

fmt.Printf("games == nil?   : %t\n", games == nil) // true
fmt.Printf("game == nil?   : %t\n", game == nil)   // false
fmt.Printf("game == nil?   : %t\n", game) // []
```

## 常見用法
### re-slicing 重新切片
使用冒號間隔兩個參數，此方式可擷取 slice 特定範圍的值。
#### 語法結構
```go=
slice[start:end]
```
#### 說明
- `start`: 起始位置，預設值為 `0`
- `end`: 終點，預設值為該 slice 的長度(`len(slice)`)

需要注意的是:
- `[start:end]` 取出的範圍是 `start` 到 `end - 1` 的範圍
- `start`, `end` 值可不給，如: `[:]` 

```go=
x := []int{1, 2, 3, 4, 5}
y := x[:]  
fmt.Println("y: ", y) // y:  [1 2 3 4 5]
y = x[:2]
fmt.Println("y: ", y) // y:  [1 2]
y = x[2:]  
fmt.Println("y: ", y) // y:  [3 4 5]
y[2] = 0  
fmt.Println("y: ", y) // y:  [3 4 0]
fmt.Println("x: ", x) // x:  [1 2 3 4 0]
```

> #### 重新切片後的 slice 底層陣列不變，僅改變指標位址

觀察到上述重新切片後的 slice 底層陣列不變的情況後，若不想兩個 slice 共用同一個陣列，則要使用另一個內建函數 `copy()`

### 拷貝: copy()
`copy()` 將一個 slice 的內容，複製至另一個 slice (複製 slice 中原始指向的底層陣列至另一個新的 slice ，且新slice 指向新陣列
#### 語法結構
```go=
copy(dst-slice, src-slice)
```
#### 結合 re-slicing 指定要複製的位置
```go=
x := []int{1, 2, 3, 4, 5}
y := []int{6, 7, 8}
copy(y, x[2:])    //  把 x 中從第 2 個數至最後一個數值，複製進 y
fmt.Println("x:", x, "y: ", y) // x: [1 2 3 4 5] y:  [3 4 5]
y[2] = 0
fmt.Println("x:", x, "y: ", y) // x: [1 2 3 4 5] y:  [3 4 0]
```
#### 注意以下情況
- `len(src-slice)` < `len(dst-slice)` 時: 會覆蓋  `dst-slice`的前 `len(src-slice)` 個數
```go=
x := []int{1, 2, 3, 4, 5}
y := []int{6, 7, 8}
copy(x, y)       //  把y複製進x
fmt.Println("x:", x, "y: ", y) // x: [6 7 8 4 5] y:  [6 7 8]
y[2] = 0
fmt.Println("x:", x, "y: ", y) // [1 2]
```
- `len(src-slice)` > `len(dst-slice)` 時: 複製`src-slice` 與 `dst-slice` 等長的值
```go=
x := []int{1, 2, 3, 4, 5}
y := []int{6, 7, 8}
copy(y, x)                     //  把 x 複製進 y
fmt.Println("x:", x, "y: ", y) // x: [1 2 3 4 5] y:  [1 2 3]
y[2] = 0
fmt.Println("x:", x, "y: ", y) // x: [1 2 3 4 5] y:  [1 2 0]
```

### 擴增: append() 
在給定的 slice 尾端擴增的新元素，回傳一個新的 slice

> 若給定的 Slice 無足夠的容量容納這些新元素，則會新配發具有更大容量的底層陣列。原有的 slice 底層陣列中所有元素都會被複製到新陣列內，再添加新元素。
>
> 反之，若給定的 slice 有足夠容量來容納新元素，則使用其底層陣列並將新元素附加到同一陣列中。

#### 語法結構
```go=
append(s []T, x ...T)
```
#### 範例
擴增單一元素
```go=
nums = []int{1, 2, 3}

_ = append(nums, 4)

fmt.Println(nums)   // [1 2 3]

nums = append(nums, 4)

fmt.Println(nums) // [1 2 3 4]
```
#### ellipsis: 將一個 Slice 添加到另一個 slice
使用運算子: `...` 將一個 slice 直接添加至另一 slice
```go=
nums = []int{1, 2, 3}

tens := []int{12, 13}

nums = append(nums, tens...) 

fmt.Println(nums) // [1 2 3 12 13]
```

### slice 中放 slice
我們亦可於 slice 中放另外一個 slice，類似二維的概念
```go=
number := [][]int{
    {1, 2},
    {3, 4},
    {5, 6},
}

fmt.Println("slice number: ", number) // slice number:  [[1 2] [3 4] [5 6]]
fmt.Println("length: ", len(number)) // length:  3
fmt.Println("capacity: ", cap(number)) // capacity:  3
```
### slice literals
可用與迭代陣列相同的方式對 slice 做迭代。
- for-loop 的形式 (without `range`)
```go=
for i := 0; i < len(numb); i++ {
    fmt.Println(numb[i])
}
```
- for-loop 的形式 (with `range`)
```go=
for i, v := range numb {
    fmt.Println(i, v)
}
```

## 需注意之處
### slice 底層有個指標指向一個 array
slice 本身是一個引用型別，底層會有個指標指向一個array
### slice 的長度 == slice 中元素的數量
slice 的長度是 slice 中元素的數量
### slice 為 nil 時，不會於 loop 中的 range 執行
```go=
var games []string

for i, game := range games {
    fmt.Println("nil!!!")
    fmt.Println("game in range: ", game)
}
```
上述範例會發現宣告 games 為 slice 型別後，初始值為 `nil` ，嘗試用迴圈讀取裡面的值，發現沒有印出任何東西，程式仍能夠正常運作。
空的 Slice 值等同於 `nil`，來看下述範例：
```go=
fmt.Println("equal? ", games == nil)
```
執行的結果為 `true`，表兩者同等。

# array v.s slice 差異
## array
- 固定長度，長度在編譯時期(complie time)已經建立
- array 長度`屬於型別`的一部分
- 宣告後無法改變陣列長度
- 宣告 array 內的元素型別為 `int` 且未給值時，array 內的元素值為 `0`
- array 在`長度相同`時可進行比較
- array 在`長度相同`時可進行賦值(assign: `=`)操作

## slice
- 長度可變動
- 長度`不屬於型別`的一部分
- 長度於執行期(runtime)才變動
- 宣告 slice 而未給值時，slice 內的值為 `nil`
- slice 只可對 `nil` 值做比較(比較的對象是 `nil`)
- slice 在元素`型別相同`時即可進行賦值(assign: `=`)操作，跟長度無關

## 範例
```go=
func main() {
    {
        // its length is part of its type
        var nums_arr [5]int // 宣告長度為 5 的空 array
        fmt.Printf("nums array: %#v\n", nums_arr) // [5]int{0, 0, 0, 0, 0}
    }

    {
	// its length is not part of its type
	var nums_slice []int // 宣告長度為 5 的空 slice
	fmt.Printf("nums slice: %#v\n", nums_slice) // []int(nil)
        fmt.Printf("len(nums_slice) : %d\n", len(nums_slice)) // []int(nil)

	// won't work: the slice is nil.
	fmt.Printf("nums_slice[0]: %d\n", nums_slice[0]) // panic: runtime error: index out of range [0] with length 0
	fmt.Printf("nums_slice[1]: %d\n", nums_slice[1]) // panic: runtime error: index out of range [1] with length 0
    }
```

# Ref
- [[Golang] Array v.s. Slice](https://ulahsieh.github.io/Golang-Array-VS-Slice.html)
- [Golang Slice 介紹](https://calvertyang.github.io/2019/11/13/introduction-to-slices-in-golang/)
- [底層為陣列的 slice](https://openhome.cc/Gossip/Go/Slice.html)