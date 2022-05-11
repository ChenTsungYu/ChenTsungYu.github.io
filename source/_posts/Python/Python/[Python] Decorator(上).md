---
title: "[Python] 淺談 Python 中的Decorator (上)"
catalog: true
date: 2020/02/05 20:23:10
tags: [Python]
categories: Backend
toc: true
---
<!-- toc -->
# 前言
之前專題寫Linebot時用Flask串接Linebot的SDK，一開始只是照個官方給的 Sample Code 去架設Linebot，後來深入研究Sample Code後一直不太理解裡面`@`的意涵，利用空檔撰寫這篇文章，加深對 Decorator 的觀念。

Decorator 中文翻作 **裝飾器**，裝飾 Python 中的 **class 和 function**，它其實是 Python 的一種語法糖(簡化寫法)，不僅能使程式碼重複利用，將程式碼化繁為簡，更易於擴充，故被廣泛實作在套件上，而辨識 Decorator 的方法就是 Decorator 名稱前面會以`@`做開頭。
如下圖的 `@app`:
![](https://i.imgur.com/yf93Dxu.png)

> Decorator背後牽涉到兩個很重要的觀念 - **閉包(Closure)** 以及**頭等函式 (First-class Function)**， 相關討論記錄在[這篇筆記](https://chentsungyu.github.io/2020/02/26/Python/Python/%5BPython%5D%20%E4%BD%9C%E7%94%A8%E5%9F%9F%E8%88%87Closure(%E9%96%89%E5%8C%85)/)

本文主要著重探討 Decorator 的概念。
<!--more-->

# 實作
## Smaple Code (Decorator)
來看簡單範例:
```python
def print_my_name(name):
    print("My name is %s" %(name()))

@print_my_name
def my_name():
    return "Tom"
    
# My name is Tom
```
執行上面的範例結果，可以發現函式看起來好像沒有東西被呼叫，卻自動被執行?
那如果改成呼叫`my_name()`函式的話會出現錯誤情形。
```python
def print_my_name(name):
    print("My name is %s" %(name()))

@print_my_name
def my_name():
    return "Tom"
    
my_name()
```
![](https://i.imgur.com/IA4ABWZ.png)

如果呼叫 `my_name()` 的話就報 `TypeError: 'NoneType' object is not callable` 的錯誤訊息

### 還原Sample Code (不加Decorator)
上述有使用`@`做簡化的範例程式碼，如果要還原成不加Decorator的話:
```python=
def print_my_name(name):
    print("My name is %s" %(name()))
    return name

def my_name():
    return "Tom"

name = print_my_name(my_name)
```
![](https://i.imgur.com/Xn8Ub9i.png)
由上述例子可知:
> ###  function也可作為參數傳遞並執行。

前後比較有無Decorator的範例發現，有Decorator的程式碼省略掉`name = print_my_name(my_name)`，不必多寫。
透過範例，可以把它簡單理解為:

> ### 對一個函式進行打包的動作，後續可重複呼叫打包過的函式。
> 利用function可作參數傳入的特性，將`my_name()`作為參數傳入`print_my_name(name)`中(做為decorator)。

### 原因
`name = print_my_name(my_name)` 表示把`my_name`這個 function傳入`print_my_name`做處理，再把 `print_my_name(my_name)` 的回傳值assign給變數`name`。

一開始的`my_name`是function，但是因為重新賦值的關係，`my_name()` 已經不是一個function，而是與 `print_my_name(my_name)`的回傳值連結在一起。

```python=
print(my_name)
# None
```
因為`print_my_name`沒有指定回傳的值，python會預設`return None`，最後執行`print(my_name)`時就會得到`None`的結果。

![](https://i.imgur.com/8wqbvym.png)

### 解決方法
針對剛才加入Decorator範例中，呼叫`my_name()`報錯問題，只需在加上`@`的函式裡面做`return`，回傳由外部傳入的參數即可！
```python=
def print_my_name(name):
    print("My name is %s" %(name()))
    return name 

@print_my_name
def my_name():
    return "Tom"
```
![](https://i.imgur.com/No9YUto.png)

或是單純不想印出錯誤訊息的話可以在呼叫函式時刪除`()`
```python=
def print_my_name(name):
    print("My name is %s" %(name()))

@print_my_name
def my_name():
    return "Tom"
    
my_name
```
![](https://i.imgur.com/sR4AFSz.png)


### 分析函數
舉剛才未使用Decorator範例，若印出`name`的話:
```python=
def print_my_name(name):
    print("My name is %s" %(name()))
    return name

def my_name():
    return "Tom"

name = print_my_name(my_name)
print(name)
```
![](https://i.imgur.com/I7ap4aY.png)
> #### 回傳值會是一個**function物件**。
若要執行function物件的內容，需改成`print_my_name(my_name)()`，因為`print_my_name(my_name)`只會`return function`自己，必須在後面加上`()`來呼叫。

```python=
def print_my_name(name):
    print("My name is %s" %(name()))
    return name

def my_name():
    return "Tom"

name = print_my_name(my_name)()
```
![](https://i.imgur.com/Iio2cVm.png)


以上是目前整理Python裝飾器(Decorator)初步的用法，其實裝飾器的寫法總共有四種，更多Python Decorator的進階用法留待下一篇。

如果觀念上有不正確或是文章內容有錯誤之處還請看過文章的人指教！

# 參閱
* [Advanced Uses of Python Decorators](https://www.codementor.io/@sheena/advanced-use-python-decorators-class-function-du107nxsv)
* [Python Decorator 入門教學](https://blog.techbridge.cc/2018/06/15/python-decorator-%E5%85%A5%E9%96%80%E6%95%99%E5%AD%B8/)
* [Python進階技巧 (3) — 神奇又美好的 Decorator](https://medium.com/citycoddee/python%E9%80%B2%E9%9A%8E%E6%8A%80%E5%B7%A7-3-%E7%A5%9E%E5%A5%87%E5%8F%88%E7%BE%8E%E5%A5%BD%E7%9A%84-decorator-%E5%97%B7%E5%97%9A-6559edc87bc0)
* [萬惡的 Python Decorator 究竟是什麼？](https://www.hansshih.com/post/85896158975/%E8%90%AC%E6%83%A1%E7%9A%84-python-decorator-%E7%A9%B6%E7%AB%9F%E6%98%AF%E4%BB%80%E9%BA%BC)








