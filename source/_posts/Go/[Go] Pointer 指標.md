---
title: "[Go] Pointer (指標)"
catalog: true
date: 2020/01/13 20:23:10
tags: Go
categories: Backend
toc: true
---

<!-- toc -->
# 什麼是指標？
指標是以變數的形式來存另一個變數的記憶體位址。一般情況下，不會直接使用指標的值，而會透過指標間接操作另一個值。
<!--more-->
```go
n := 2

// 參考變數 n 的記憶體位置
nPtr := &n

// 印出記憶體位址
fmt.Println(nPtr)
```

# 指標宣告
語法結構：
```go
// A pointer of type T
var p *T
```
說明： 型別 `T` 是指標指向的變數的型別， `T` 可替換成其他資料型別
```go
// A pointer of type int
var p *int
```
上述範例表 `p` 指標只能儲存 `int` 類型的變數記憶體位址。
## 指標的零值：
不管指向的型別為何，任何未初始化的指標都會是 `nil` → 指標的**零值**為 `nil` 
```go
var p *int
var s *string
fmt.Println("p = ", p) // p =  <nil>
fmt.Println("s = ", s) // s =  <nil>
```
# 指標初始化
```go
var x = 10
var y *int = &x

// 由於編譯器可推斷出指標變數的型別，所以可省略上面範例中指標 y 的型別宣告(*int)：
var y = &x

fmt.Println("Value stored in variable x = ", x) // 10
fmt.Println("Address of variable x = ", &x)     // 0xc000012078
fmt.Println("Value stored in variable p = ", y) //  0xc000012078
```
# 解參考指標
解參考又作間接取值，只要於指標前面加個 `*` 符號，可存取存在指標所指向變數中的值。
```go
var x = 10
var y = &x

fmt.Println("y = ", *y) // 10
```
## 修改指標設定存在變數中的值
解參考除了前述的間接取值的用途外，亦可對其做修改
```go
var x = 10
var y = &x

fmt.Println("y before assigned a new value = ", *y) // 10
*y = 20
fmt.Println("y after assigned a new value = ", *y) // 20
```
# new() 函數建立指標
透過 `new()` 函數將型別作為參數，配置足夠的記憶體來裝該型別的值，**回傳指向該型別的指標**
```go
z := new(int) // 指標接收 int 型別的參數
*z = 10000

fmt.Println("z and *z: ", z, *z) // 0xc000116020 10000
```
# 指標指向指標
指標除了能指向任何型別的變數外，亦可指向另一個指標
```go
a := 1
b := &a
c := &b

fmt.Println("a: ", a)             // 	a:  1
fmt.Println("address of a: ", &a) // address of a:  0xc0000ac038

fmt.Println("b: ", b)             // b:  0xc0000ac038
fmt.Println("address of b: ", &b) // 	address of b:  0xc0000b0020

fmt.Println("c: ", c) //	c:  0xc0000b0020

// 將指標的指標進行解參考
fmt.Println("*c: ", *c) /* *c:  0xc0000ac038 */
fmt.Println("**c: ", **c) /* 	**c:  1  */
```
### >  注意：Go 沒有指標運算，但可進行比較