---
title: "[Python] 檔案讀寫"
catalog: true
date: 2019/08/10 20:23:10
tags: Python
categories: Backend
---
<!-- toc -->
# 前言
本篇紀錄Python在開檔/讀檔的操作方法，並以`.txt`檔為範例。

# 開啟檔案
選定要處理得目標檔案，建立檔案物件(file object)，若檔案不存在，`open()`函式就會拋出一個`FileNotFoundError`的錯誤訊息。
`f = open(檔名, "操作模式", encoding="編碼方式")`
<!--more--> 
Python 提供多個開啟檔案的模式，紀錄幾個常用的開檔模式：
>`"r"` => 唯讀模式(預設情況)：只能從指定的檔案讀取資料，不能對此檔案內容進行更改。若指定檔案不存在，會產生 `FileNotFoundError`的例外錯誤。
`"w"` => (覆寫模式）：進行檔案的寫入，會在開啟的位置直接覆蓋掉原本的檔案。若指定的檔案路徑/名稱不存在，會自動新增一個新檔案。
`"a"` => (續寫模式）：在此模式下開啟檔案要進行寫入時，會從原本的檔案最後面為起始點繼續寫入。
`"r+"` => 檔案存在的情況下讀取舊資料並寫入(始於游標所在位置)
`"w+"` => 清空檔案內容，可再讀出新寫入的東西(檔案可不存在，會自動新增)

## 範例
```python=
f = open('./test.txt', 'r')
```

# 關閉檔案 
在程式當中開啟了檔案以後，如果要停止對於這個檔案的更動或寫入，可以將檔案關閉，使用`close()`方法進行關閉。
範例
```python=
f.close()
```

# 讀取檔案
成功開啟檔案以後，再來要讀取檔案當中的資料。Python在file object 當中提供了幾種從檔案讀取資料的方法:
## `file.read()`
`file.read(size)`，若有設定`size`的值，會讀到指定的字節數量，若沒有設定則會讀取整個檔案。

### 範例：
上方為
```python=
f = open("./sample.txt", "r")
words = f.read(5)
print(words)
f.close()

# 回傳結果
# This is python example.
# python is fun.

# =======   設定size    ================
f = open("./sample.txt", "r")
words = f.read(5)
print(words)
f.close()

# 回傳結果
# This
```
## `file.readline()`
讀取檔案中的整行內容，但一次只讀取一行，包含`\n`字元，若檔案內容包含了多行的資料，我們就必須呼叫`f.readline()` 多次。
```python=
f = open("./sample.txt", "r")
first = f.readline()
second = f.readline()
print(second, first, sep = "\n")
f.close()
# 回傳結果
# python is fun.
# This is python example
```

## `file.readlines()`
逐行讀取檔案所有內容，回傳一個list資料結構，並且在每一行文字最後面會加上一個`\n`。
```python=
f = open("./sample.txt", "r")

lines = f.readlines()
print(lines)
f.close()

# 回傳結果
# ['This is python example.\n', 'python is fun.']
```

# 寫入檔案
將`open()`函數內的讀檔模式改為`"w"`，並使用`file.write()`，相對於剛才提到的`f.read()`，語法:
```python=
f.write("string") 
```
寫入檔案，並回傳寫入的string長度。
## 範例
```python=
f = open("./sample.txt", "w", encoding="utf-8")
words = f.write("This is a new line be written")
print(words)
f.close()
# 29
```
## 寫入多行
若不想要每輸出一段東西就執行一次 `f.write(sequence)`，可以使用`file.writelines()`，一次寫入多行。
> ### `sequence`參數為**list**或是**tuple**等這類的資料型態
### 範例
```python=
f = open("./sample.txt", "w", encoding="utf-8")
seq = ["測試第一行\n","測試第二行"]
words = f.writelines(seq)
print(words)
f.close()
```
### 輸出結果
![](https://i.imgur.com/VRRM86W.png)


# 讀寫檔案的錯誤處理
使用`with open（）as`讀寫檔案，最剛開始開啟檔案時，或檔案不存在，Python會拋出`FileNotFoundError`這類的錯誤訊息。
>由於檔案讀寫時都有可能產生錯誤，若錯誤發生，後面的`f.close()`就不會被執行。為了保證無論是否出錯都能正確地關閉檔案，我們可以使用`try ... finally`來完成。
>
>**`finally`表示當錯誤發生時，`finally`後續的程式碼繼續執行**
## 範例
```python=
try:
    f = open('./sample.txt', 'r')
    print(f.read())
finally:
    if f:
        f.close()
```
如果每次都這麼寫會顯得過於冗長，`with ...`方法可以自動呼叫`close()`方法
### 範例
```python=
with open('./sample.txt', 'r') as f:
    print(f.read())
```
透過`with`方法定義`f`為變數名稱，同時又不需要寫`try ... finally`來確保檔案正常關閉。

# 參考
[python 使用 with open（） as 讀寫檔案](https://www.itread01.com/content/1549615343.html)