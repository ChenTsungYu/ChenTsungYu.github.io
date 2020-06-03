---
title: "[Python] 字串處理"
catalog: true
date: 2019/08/01 20:23:10
tags: Python
categories: Backend
---
<!-- toc -->
# 前言
本篇紀錄經常用到的字串處理方法, 而這些方法已經可以滿足大部分字串處理的需求。
# 字串(string)
Python的字串有單引號`''`或雙引號`""`的形式，
>* 若字串中本身就包含單引號或是雙引號，可以使用另一種引號以利區別
>* 如果在字串資料中遇到相同引號時，則需使用跳脫(escape)字元: `\`做跳脫處理，避免被誤判為字串的結束點。
<!--more--> 
## 範例
若要寫入`I'm`這類型的縮寫文字，為了避免被誤判為字串的結束點，可以採用兩種方法:
### 方法一: 跳脫字元
```python=
name = 'I\'m Tom.'
print(name)
```

### 方法二: 改用另一形式的引號
```python=
name = "I'm Tom."
print(name)
```

# 建立字串
以下三個都是建立空字串的方法，當然也可以給定初始值
```python=
# 建立空字串
str1 = str()
str2 = ''
str3 = ""

# 給定初始值
init_str = "hello"
```

# 字串的處理

## 字串拼接
兩個字串作相加`+`運算，資料串接起來。
```python=
str1 = "Hello, "
str2 = " my name is Tom"
print(str1 + str2)
```

## 重複印出字串
透過乘法`*`可以重覆字串的內容。
```python=
x = 'Hello'
print(x*3) # HelloHelloHello
```
~~是在哈囉?~~

## 計算字串長度
`len()`函式取得字串的長度並回傳。
```python=
str = "Python"
print(len(str))
```

## 字串擷取
利用中括號`[起始索引值:結束索引值]`可以取出字串需要的部份內容，字串的索引值(index)是從**0**開始，若要取最後一個字可以用 **-1**。
```python=
str = "Python"
print(str[4]) # 表是從index=0~4
# "o"

print(str[-1]) # "n"
```

## 字串分割
`split("分割符號")`的方法以`()`內的分割符號作為分割依據，回傳`list`的資料結構。
> ### split()預設以空白作為分割依據，回傳所有單字
```python=
str1 = 'My name is Tom.'
str2 = '123.456.789'
str3 = 'MMS-231-HIA-Hel988'

list1 = str1.split(' ')
print(list1)

list2 = str2.split('.')
print(list2)

list3 = str3.split('-')
print(list3)

"""
['My', 'name', 'is', 'Tom.']
['123', '456', '789']
['MMS', '231', 'HIA', 'Hel988']
"""
```
## 翻轉字串
Python在處理reverse string非常厲害，只需要一行程式碼即可搞定。也可以呼叫`reverse()`這個函式。
```python=
sss = 'abcdefg'
sss = sss[::-1]
print(sss) 

# 此法也可以
sss.reverse()
```
>上面為**slice方法(又稱切片)**，結構說明: [起始點:終點:間隔值]

## 格式化
* 大小寫轉換
```python=
s = "Hello"
s.upper()      #全部字元轉成大寫
s.lower()      #全部字元轉成小寫
s.title()      #首字轉成大寫
s.capitalize   #每個字詞的首字轉成大寫
s.swapacase    #將大小寫顛倒
```
* 新增和刪除空格
```python=
space="      abc     "  
space.strip()       #刪除前後的空格
space.rstrip()      #刪除右邊的空格
space.lstrip()      #刪除左邊的空格
     
numb="1112233111"
numb.strip("1")     #刪除特定字元
     
space = "this is the space"
space.center(30)      #產生一定數量的空格，並中心對齊一個給定的字串
space.ljust(30)       #產生一定長度的空格並左對齊
space.rjust(30)       #產生一定長度的空格並右對齊
"123".rjust(10,"0")  #能以任意字元填充空格
"123".zfill(10)      #在左邊填充一定數量的0
```
* `format()`格式化
在既有的字串中加入`{}`，放入被`format()`格式化後的值。
```python=
pi=3.14
"The value of pi is {}".format(pi)      #串格式化後的值
"""First letter: {0}. Last letter: {1}.""" .format('A', 'Z')
#{}中設定數字代表要插入的參數的索引
"""First letter: {first}. Last letter: {last}.""" .format(last='Z', first='A')
#若{}中包括了一個字串，則可以名稱指定要插入的值
"pi = {0:.3f}".format(pi)
#數字的插入，0代表要插入的參數的索引，:代表後面要跟著格式化的程式碼，.3f代表需要的精度資訊，小數點後保留3位小數的浮點數
```

## 查找字串
```python=
stat = 'Today is not my day'
stat.find('Today')      #查詢字串在字串中出現的索引，若搜尋不到子字串，會回傳-1
stat.index('Today')     #查詢字串在字串中出現的索引，若搜尋不到子字串，會回傳ValueError
stat.rfind('Today')     #從尾部往前查詢子字串在字串中出現的索引
    
stat.endswith('day')         #檢查字串最後一個字串
stat.startswith('Today')      #檢查字串首個字串
```
## 替換字串
`replace('舊字串','新字串')`方法做新/舊字串的替換。
```python=
stat.replace('brown','red') 
```

## 型別轉換
一個值從一種型態轉變為另外一種型態。
### 範例: 將一個字串 (str) 轉為整數
```python=
stringNum = "155"
intNum = int(stringNum)
print(stringNum)
print(intNum)
print(type(stringNum))
print(type(intNum))

# 結果
'''
55
55
<<class 'str'>
<<class 'int'>

'''
```

### 範例: 將一個數值轉為字串 (str)
可用`str(數值)`的方法將數值轉為字串。
```python=
intNum = 155
stringNum = str(stringNum)

print(type(stringNum))
print(type(intNum))
```

## 測試字串
* `isupper()`: 若字串為大寫字母組成, 就回傳`True`
* `islower()`: 若字串為小寫字母組成, 就回傳`True`
* `isspace()`: 若字串為空白字元組成, 就回傳`True`
* `isalnum()`: 若字串為字母和數字組成, 就回傳`True`
* `isalpha()`: 若字串為字母組成, 就回傳`True`
* `isdigit()`: 若字串為數字組成, 就回傳`True`
* `isidentifier()`: 若字串為識別字, 就回傳`True`


# 參考文章
[[Python]B13─字串處理(string processing)](https://ithelp.ithome.com.tw/articles/10211290)
[[Python] 字串處理](https://wenyuangg.github.io/posts/python3/python-string.html)