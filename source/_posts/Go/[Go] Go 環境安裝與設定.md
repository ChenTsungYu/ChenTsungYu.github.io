---
title: "[Go] 環境安裝與設定"
catalog: true
date: 2020/01/06 20:23:10
tags: Go
categories: Backend
---
![](https://i.imgur.com/qD123l8.png)
[圖片源](https://commons.wikimedia.org/wiki/File:Go_gopher_app_engine_color.jpg)
<!-- toc -->
# 前言
本篇用於記錄Go的安裝、環境設定等前置工作。
<!--more--> 
# 安裝Go
Mac OSX的話可以直接從Terminal用Homebrew進行安裝：
```go=
brew install go
```
或是透過[官方下載](https://golang.org/dl/)

Go會在系統內預設一個專屬於放置所有Go專案的資料夾

# 查看相關資訊及設定

## 查看版本
```go=
go version
```

## 查看Go語言的環境變數與使用工具的配置等資訊。
```go=
go env
```
執行指令後可以看到許多相關資訊
![](https://i.imgur.com/Jthwg35.png)

## 查看Go工作目錄
go命令仰賴一個重要的環境變數:`GOPATH`，為Go的工作目錄，集中管理code, package和執行檔，執行下面的指令可以看到目前go的工作目錄
```go=
go env GOPATH
```
或是執行以下方法
```go=
echo $GOPATH
```
![](https://i.imgur.com/YENx6ye.png)

![](https://i.imgur.com/ebZtnhf.png)

```go=
/Users/tsungyuchen/go
```

如果想要在非預設工作區的路徑工作，那麼你需要設定`GOPATH`環境變數指向那個目錄


### GOPATH 路徑問題
![](https://i.imgur.com/PcXbzhv.png)

[解決方法](https://blog.csdn.net/guyan0319/article/details/81909612)

## GOROOT
Golang主程式安裝的位置
![](https://i.imgur.com/DbwDWdy.png)

### 設置的環境變數
如果是`bash`中設置
```=
vim .bash_profile
```
使修改立刻生效
```=
source .bash_profile
```

## 編譯成二元檔
執行`go build`將檔案進compile成二元的執行檔(給機器讀的)

## 執行為執行檔
如:`./main`: 執行名為main 的執行檔


## 查看編譯後的二進制檔案
指令: `ls -l`
![](https://i.imgur.com/3DgOCrX.png)

## Packages
為該檔案的標題，同時也表示該檔案的內容摘要，必須寫在第一行。`package main`代表這個檔案內容標題為main，這是Go內建的規則，在執行`.go`的程式時，一定要執行名稱為main的package，若沒有按照規則，執行程式會出現以下錯誤訊息：
![](https://i.imgur.com/qByYYxn.png)

### 重要觀念:
* Packages: 每個 Go 程式都是由package組成的，為了方便維護，盡量將package名稱和目錄名稱一致
![](https://i.imgur.com/lykanAj.png)[圖片來源](https://go-tour-zh-tw.appspot.com/basics/1)

### 自定義一個package
Go可以自己定義一個package，在主要檔案引入該package時，加入`import`該package的**資料夾名稱**，而自定義的package若要匯出給其他使用，先定義該檔案下的package名稱、函式名稱。
> 若是自定義的檔案名稱，funtion名稱必須要是大寫。
#### 範例:
若今天要自己定義一個package，在src目錄下建立名為add的資料夾名稱，並在其資料夾底下建立`add.go`的檔案，檔案內容如下
`add.go`
```go=
package add // 定義package名

import "fmt"

// function 必須為"大寫"
func Add() { 
	fmt.Println("This is add")
}
```
`main.go`匯入add
```go=
package main

import (
	"add"
	"fmt"
)

func main() {
	fmt.Println("main is here!")
    add.Add() // 呼叫Add()
}
```

* package 有兩種：執行用的package、函式庫的package
![](https://i.imgur.com/qpszDpY.jpg)
### 比較
![](https://i.imgur.com/bM0Qvq4.jpg)
#### 函式庫的package
* 不可被編譯，但可被不同專案引入
* package名可以自訂
* function名可以自訂，但必須要**大寫**

#### 執行用的package
* 用於執行整支程式
* 不可被引入
* 需有名為`main`的package名
* 需有名為`main`的function名

## 匯入模組
`import 套件名稱`

`fmt`為format縮寫的套件名稱，主要用於調整及顯示內容。也可自訂的package名稱。
>## Go預設搜尋package是從src目錄底下開始搜尋

### `import`自定義package時注意的點
* 由於import只能指定資料夾，無法指定檔案
* 同個資料夾底下只能有一個package，如：資料夾底下所有檔案的package名稱都統一是test_package

## 檔案主要執行的函式
若檔案內的package名稱是`main`，則一定要有一個是`main`名稱的`function`作為執行的函式。

若沒有的話，會出現錯誤訊息：
![](https://i.imgur.com/ob0rgJ0.png)

除了main之外，也可自定義其他funcion，但這些function不會主動執行，而是需要在`main function`內進行呼叫。
如下行範例
```go=
package main

import (
	"fmt"
)

func main() {
	fmt.Println("main here!1")
	test()
}

func test() {
	fmt.Println("test here!")
}
```

## 一次執行同個資料夾下多個`.go`檔案
當同個資料夾下有多個`.go`檔案時，在其中一個程式裡面呼叫其他檔案所定義的函式可以不需要`import`該檔案而直接呼叫，並執行
```go=
go run *.go
```

### 範例
假設今天名為test的資料夾下分別有一個`main.go`及`test.go`檔
![](https://i.imgur.com/Jg0IWSa.png)
`test.go`檔內的程式碼:
```go=
package main

import "fmt"

func test() {
	fmt.Println("test here!")
}
```
![](https://i.imgur.com/eOON6Ug.png)
`main.go`檔內的程式碼:
```go=
package main

import (
	"fmt"
)

func main() {
	fmt.Println("main here!")
	test()
}

```
![](https://i.imgur.com/U94nIx4.png)
`main.go`檔內的程式碼在不引入`test.go`檔的情況下執行`go run *.go`時的執行結果:

![](https://i.imgur.com/amSopar.png)
成功呼叫`test.go`檔案裡面的`test()`函式。

>### 但是！！！！

如果單獨執行`main.go`會出現`undefined: test`的錯誤訊息
![](https://i.imgur.com/BYK6ZaX.png)
### 原因：
go在`run`之前會先進行編譯操作，而在此處的編譯它只會以這個`main.go`為準，導致其他幾個引用文件中的方法出現找不到的情況(但採用`go build`的方式又不一樣，go會自動找引用文件並打包)

# 參考
[Golang 官方教學](https://go-tour-zh-tw.appspot.com/list)

[如何編寫Go程式](https://codertw.com/%E7%A8%8B%E5%BC%8F%E8%AA%9E%E8%A8%80/8966/#outline__2_1)

[GOPATH 與工作空間](http://www.admpub.com:8080/build-web-application-with-golang/zh-tw/01.2.md)

[Go 程式設計導論](http://golang-zhtw.netdpi.net/04_variables/04-02-scope)

[Go起步走 - 檔案基本結構](https://motion-express.com/blog/go-file-structure)