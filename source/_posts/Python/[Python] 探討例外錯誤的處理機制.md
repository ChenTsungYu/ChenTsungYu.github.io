---
title: "[Python] 探討例外錯誤的處理機制"
catalog: true
date: 2019/08/12 20:23:10
tags: Python
categories: Backend
toc: true
---
<!-- toc -->
# 前言
寫程式有時候會發生一些錯誤，程式就會立即停止->立即出現error mesaage。
避免因為使用者輸入的問題或設定的問題造成程式被迫中斷，或產生不可預期的狀況，有些例外錯誤必須在某些特定的情況下才會發生，為了能夠更有效應付這種錯誤，可以使用例外處理來解決。
<!--more--> 
# 一般處理
**Try-except statement**，一般情況下，Python在做錯誤處理機制使用`try ... except`來捕捉錯誤訊息，並在此錯誤發生時，執行後續的程式碼。**如果要針對不同錯誤訊息做個別處理，可以繼續增加except指令**
## 捕捉特定錯誤訊息
可以針對Python某個類型的錯誤訊息進行捕捉，程式結構大概是：
```python=
try:
    # 想要執行的程式
except (例外錯誤類型1, 例外錯誤類型2, …) as 例外物件:
    # 發生例外錯誤時要執行的程式碼
except (例外錯誤類型3, 例外錯誤類型4, …) as 例外物件:
    # code
# 可依需求增加
```
## 捕捉任何錯誤訊息
`except`支援多種錯誤，若不指定任何錯誤類型的話只需要寫`except`，即可捕捉所有錯誤類型，只要有錯誤訊息發生，就會執行`except`後續的程式碼。
>值得一提的事:`try`只會捕捉第一個錯誤,假設`try`裡有2行程式碼, 2行都有錯誤, 第一行被捕捉到以後, 就會跳到`except`, 並不會兩個錯誤都被找出來.
```python=
try:
    # 想要執行的程式
except:
    # 發生例外錯誤時要執行的程式碼
```
### 範例
```python=
a = 100
b = 0
print(a/b)
```
執行上述這段程式碼會跳出`ZeroDivisionError`的錯誤訊息，如果要捕捉此錯誤，並印出"分母不可為0"訊息，可以把程式碼改成:
```python=
a = 100
b = 0
try:
    print(a/b)
except ZeroDivisionError as error:
    print("分母不可為0, 系統錯誤訊息為:", error)

# 結果
# 分母不可為0, 系統錯誤訊息為: division by zero
```
![](https://i.imgur.com/XpNf6Qs.png)


# 進階處理
除了一般處理外，也可依照自己需求增加`else ....  finally ...`的方法做近一步處理。程式結構會是:
```python=
try:
    # code
except (例外錯誤) as 例外物件:
    # code
else:
    # without errror
   
finally:
    # program still run here if there are errors
    
```
`else`指的是當try指令內的程式順利執行完畢，且沒有發生任何錯誤時才執行，而`finally`後的指令則是無論有無錯誤訊息，仍須進行該指令下的程式碼，最常見的地方用於開檔/讀檔時，使用`open()`方法，即使有錯誤產生，仍須正常關閉檔案。

## 範例
以`open()`方法開啟檔案為例
```python=
f = open("./123.txt", "r")
print("--------是否有執行到這裏")
words = f.read()
print("--------是否有執行到這裏")
print(words)
print("--------是否有執行到這裏")
f.close()
print("--------正常關閉")
```
若無此檔案存在，則會拋出一個`FileNotFoundError`的錯誤資訊，這時程式會因錯誤而中斷，無法往下執行(後續的訊息都未被印出來)。
![](https://i.imgur.com/p7hMz7x.png)

# 參考文章
[[Python初學起步走-Day15] - 例外處理](https://ithelp.ithome.com.tw/articles/10160048)

[例外處理的語法](https://sites.google.com/site/ezpythoncolorcourse/exceptionhandlinggrammar)