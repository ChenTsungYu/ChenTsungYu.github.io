---
title: "[Go] Go基礎"
catalog: true
date: 2020/01/07 20:23:10
tags: Go
categories: Backend
---
<!-- toc -->
# 前言
本篇用於記錄Go一些基礎的概念，包含變數類型、迴圈及條件運算等
# 變數宣告
Go是一種靜態類型的語言，是強型別語言。因為型別都是固定的，就算不先宣告型別，也必須要有初始值，讓編譯器來判斷這個變數的預設值是什麼型別。
<!--more--> 

>## Go宣告型別是放在變數之後

## 一般宣告
### 範例:
定義一個名為`a`的變數，若資料型別是`int`的話，預設值為**0**
```go=
var a int
```
或是直接賦值給他
```go=
var a = 1
```
## 短語法
Go也可以使用`:=`的方式，用更簡短的語法來定義變數
```go=
package main

import "fmt"

func main() {
	var i, j int = 1, 2
	k := 3
	c, python, java := true, false, "no!"

	fmt.Println(i, j, k, c, python, java)
}
```
>## `:=`結構不能使用在函式外。

## 合適的使用時機
一般來說，短語法適合的使用時機有三個:
* 已知變數的初始值
* 讓程式更簡潔
* 用於重複宣告

### 範例
```go=
// 變數初始值未知

// best
var number int
// worst
number := 0

// 變數初始值已知

// best
width, height := 100, 50
// worst
var width, height int = 100, 50

// 用於重複宣告

// best
width, color := 70, "red"

// worst
width = 70
color := "red"
```

## 宣告多個變數
```go=
var a,b,c int
var a,b,c int = 1,2,3
var a,b,c = 1,2,3
```

## 括弧式宣告 
只要重複的宣告方式，都可以用`()`包起來
```go=
var (
  name = "Tom"
  c, d = 3, 4
)
```

## 宣告常數
首字不一定要大寫，但為了強調其重要性，大多還是採大寫。
```go=
const PI = 3.14
```
>常數不能使用 `:=` 短語法定義

## 重複宣告(redeclaration)
在Go的程式設計中，是不允許同一變數宣告兩次，若重新對一變數進行宣告時會出現`name redeclared in this block`的錯誤訊息。
```go=
var name string = "hello"
var name string = "hey"
fmt.Println(name)

// name redeclared in this block
```
![](https://i.imgur.com/qUONi70.png)
### 解決重複宣告的問題
可以採用宣告多個變數，也就是除了重複宣告的變數外，再另外以**短語法**的方式宣告一個(或多個)新變數。
```go=
var name string = "hello"
name, name1 := "hey", "ya~"
fmt.Println(name, name1)
```
![](https://i.imgur.com/AhFUV6x.png)
上圖可以看出`name`變數被重新賦予新的值

若採用`var`的方式進行重複宣告也會報重複宣告的錯誤訊息
```go=
var name string = "hello"
var name, name1 = "hey", "ya~"
fmt.Println(name, name1)
```
![](https://i.imgur.com/NDNPE3s.png)




# 資料型別
Go主要以下幾個型別:
## 字串(String)相關的型別
* `string`:
* `byte`: `uint8`的別名
* `rune` `int32`的別名，將字串以 Unicode切開時所用的型別，代表一個Unicode碼。

## 數字(Number)相關的型別
### 有號整數
`int`(32或64位元)、`int8`、`int16`、`int32`、`int64`
### 無號整數
`uint`(32或64位元)、`uint8`、`uint16`、`uint32`、`uint64`、`uintptr`

### 浮點數
* `float32`: 32位元
* `float64`: 64位元

## 複數
分為實數及虛數兩部分
* `complex64`
* `complex128`
## 類型轉換
### 範例: 數值的轉換
```go=
var i int = 42
var f float64 = float64(i)
var u uint = uint(f)
```
或更簡單的形式：
```go=
i := 42
f := float64(i)
u := uint(f)
```
### 數字轉字串
兩種int類型轉化成string類型的方法，可透過`strconv`這個package完成。
* Itoa方法
* Sprintf方法

```go=
package main
 
import (
	"fmt"
	"strconv"
)
 
var i int = 10
 
func main() {
	// Itoa方法
	str1 := strconv.Itoa(i)
 
	// Sprintf方法
	str2 := fmt.Sprintf("%d", i)

	fmt.Println(str1)
    
	fmt.Println(str2)
}
```
> `%d`表示 Integer


# 初始值
Go在宣告變數時，如果沒有給定該變數初始值，Go會依照宣告變數的資料型態去給予預設的初始值，如:
* `int`: `0`
* `bool`: `false`
* `float64`: `0`
* `string`: `""`
```go=
var (
	init_int     int
	init_float64 float64
	init_bool    bool
	init_string  string
)
fmt.Println(init_int)
fmt.Println(init_float64)
fmt.Println(init_bool)
fmt.Println(init_string)

/*
0
0
false
*/
```

## 不允許已宣告但未被使用的變數
在Go的設計中，不允許已宣告但未被使用的變數，若有前面的情形，會在編譯時跳出`declared and not used`的錯誤訊息。
```go=
var (
    init_int     int
    init_float64 float64
    init_bool    bool
    init_string  string
)
    
fmt.Println(init_float64)
fmt.Println(init_bool)
fmt.Println(init_string)
```
### 結果
`init_int declared and not used`
![](https://i.imgur.com/9DpAai0.png)

## blank identifier
上述宣高未使用的變數，Go在編譯時會跳出錯誤的訊息，若要在編譯時避免該錯誤，可以使用blank identifier，將未使用的變數賦值給`_`。
### 範例
```go=
var (
	init_int     int
	init_float64 float64
	init_bool    bool
	init_string  string
)
_ = init_int // 賦值操作
fmt.Println(init_float64)
fmt.Println(init_bool)
fmt.Println(init_string)

/*
0
false
*/
```

# 函式
`()`內的參數以及回傳值需要宣告型別。
範例
```go=
package main

import "fmt"

func add(x int, y int) int {
	return x + y
}

func main() {
	fmt.Println(add(42, 13))
}
// 返回結果
// 55
```
上述範例為一個`add function`，傳入`x`、`y`兩個資料型別為`int`的參數，回傳`int`的資料型別。

## 縮短同一類型參數的型別宣告
當兩個或多個連續的函式命名參數是同一類型。
範例:
```go=
package main

import "fmt"

func add(x, y int) int {
	return x + y
}

func main() {
	fmt.Println(add(42, 13))
}
// 返回結果
// world hello
```

## 多值返回
函式可以返回任意數量的返回值。
```go=
package main

import "fmt"

func swap(x, y string) (string, string) {
	return y, x
}

func main() {
	a, b := swap("hello", "world")
	fmt.Println(a, b)
}
// 返回結果
// world hello
```

## 命名返回值
如果命名了返回值參數，一個沒有參數的 return 語句，會將當前的值作為返回值返回。
```go=
package main

import "fmt"

func split(sum int) (x, y int) {
	x = sum * 4 / 9
	y = sum - x
	return
}

func main() {
	fmt.Println(split(17))
}
// 返回結果
// 7 10
```
> ### `:=`宣告變數的語法只能在函數內部使用。

# 迴圈(Loop)
Go只有一種循環結構：`for`迴圈。
Go的`for`迴圈沒有`()`
範例:
```go=
package main

import "fmt"

func main() {
	sum := 0
	for i := 0; i < 10; i++ {
		sum += i
	}
	fmt.Println(sum)
}
// 45
```
## 可以讓前置、後置語句為空
```go=
package main

import "fmt"

func main() {
	sum := 1
	for ; sum < 1000; {
		sum += sum
	}
	fmt.Println(sum)
}
// 1024
```

## 同`While`寫法

```go=
package main

import "fmt"

func main() {
	sum := 1
	for sum < 1000 {
		sum += sum
	}
	fmt.Println(sum)
}
// 1024
```
## 無窮迴圈
```go=
package main

func main() {
	for {
	}
}
```
# if-else
`if` 語句除了沒有`( )`

## if 的便捷語句
跟 `for`一樣， `if`可以在條件之前執行一個簡單的陳述式。
>由這個語句定義的變數的作用域僅在 if 範圍之內。

### 範例:
```go=
package main

import (
	"fmt"
	"math"
)

func pow(x, n, lim float64) float64 {
	if v := math.Pow(x, n); v < lim {
		return v
	}
	return lim
}

func main() {
	fmt.Println(
		pow(3, 2, 10),
		pow(3, 3, 20),
	)
}
// 9 20
```

# switch
和大多的程式語言一樣，不過`switch`後方不需接`()`
```go=
package main

import (
	"fmt"
	"runtime"
)

func main() {
	fmt.Print("Go runs on ")
	switch os := runtime.GOOS; os {
	case "darwin":
		fmt.Println("OS X.")
	case "linux":
		fmt.Println("Linux.")
	default:
		// freebsd, openbsd,
		// plan9, windows...
		fmt.Printf("%s.", os)
	}
}
// When's Saturday?
// Too far away.
```
## 沒有條件的`switch`
沒有條件的`switch` 同`switch true`一樣。

```go=
package main

import (
	"fmt"
	"time"
)

func main() {
	t := time.Now()
	switch {
	case t.Hour() < 12:
		fmt.Println("Good morning!")
	case t.Hour() < 17:
		fmt.Println("Good afternoon.")
	default:
		fmt.Println("Good evening.")
	}
}
// Good evening.
```


# 參考
[Golang 官方教學](https://go-tour-zh-tw.appspot.com/list)

[如何編寫Go程式](https://codertw.com/%E7%A8%8B%E5%BC%8F%E8%AA%9E%E8%A8%80/8966/#outline__2_1)

[GOPATH 與工作空間](http://www.admpub.com:8080/build-web-application-with-golang/zh-tw/01.2.md)

[Go 程式設計導論](http://golang-zhtw.netdpi.net/04_variables/04-02-scope)

[Go 語言的資料型別 (Data Type)](https://michaelchen.tech/golang-programming/data-type/#-number-)