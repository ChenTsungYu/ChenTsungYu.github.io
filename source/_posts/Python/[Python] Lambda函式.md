---
title: "[Python] Lambda函式"
catalog: true
date: 2020-01-05 20:23:10
tags: Python
categories: Backend
---
<!-- toc -->
# 前言
一般來說，如果Python要定義一個函式，基本上是使用`def`來定義，而Lambda函式是一種無名函式(anonymous function)，不需給函數名稱，基於追求簡潔的設計原則，內容只能有一則運算式。

> ### Lambda函式的程式碼只能有一行，可以放一個運算式，或是一個單行`if-else`，但不能使用指定運算子，也不可以跑迴圈。

<!--more--> 
## 特點
* 匿名的函式
* 結構簡單、使用頻率過少、節省記憶體
* "用完即丟"，只會用一次
* 運算式的計算結果會自動回傳，不需做`return`


## 實作
語法結構為: `lambda arg1, arg2, …: operation ...`
`arg`帶入目標參數，冒號`:`後方的`operation`則寫入運算式或條件判斷式等，好比一般函式裡的程式碼。
## 範例1
假設今天要寫一個函式判斷傳入的數是否為偶數
### 一般寫法：
```python=
def isEven(n):
    return "yes" if n %2 == 0 else "no"

print(isEven(10))  # yes
print(isEven(5))  # no
```
### Lambda函式:
```python=
f = lambda n : "yes" if n %2 == 0 else "no"
print(f(10))  # yes
print(f(5))  # no
```

## 範例2
```python=
def isEven1(a, b):
    return True if (a+b) % 2 == 0 else False
print(isEven1(2, 3))
```

### Lambda函式:
```python=
f = lambda a, b : True if (a+b) % 2 == 0 else False
print(f(2, 3))
```

## 常搭配的函式
### `filter()`
利用`filter()`函式進行資料篩選。
假設今天要建立篩選不及格成績的lambda函式可採下面的方法。
```python=
scores = [90, 10, 80, 30, 100, 80]

faile = lambda x: True if x < 60 else False
faile_scores = filter(faile, scores)
print([k for k in faile_scores]) # [10, 30]
```

### `map()`
`map()`利用一個指定的函式來處理資料，回傳一組處理過的新資料。
假設今天要調整學生成績，分數55分以上但未滿60分的分數一律以60分採計，作法如下
```python=
scores = [50, 55, 53, 56, 57, 54]
adjust_scores = list(map(lambda score: 60 if 60 > score >= 55 else score, scores ))
print(adjust_scores) # [50, 60, 53, 60, 60, 54]
```

## 參考
[Lambda函式](https://sites.google.com/site/ezpythoncolorcourse/lambdafunction)

[Day16-Lambda函式](https://ithelp.ithome.com.tw/articles/10206801)