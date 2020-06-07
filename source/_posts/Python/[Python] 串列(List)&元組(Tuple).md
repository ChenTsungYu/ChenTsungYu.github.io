---
title: "[Python] 串列(List)&元組(Tuple)"
catalog: true
date: 2019/08/02 20:23:10
tags: Python
categories: Backend
toc: true
---
<!-- toc -->
# 前言
串列是夠提供儲存資料的記憶體空間，Python中的串列(List)類似其他程式語言中的陣列(Array)，是一個有順序性的元素集合，若要可根據`list`中的實際內容或是該元素在`list`中的位置用索引值(index)進行查找。
<!--more--> 
# 串列(List)
## 建立空串列
```python=
arr = []
```
## 給定初始值得串列
```python=
arr = [1, 2, 3, 4]
```
## 串列內元素的資料型態可以相同或不同，甚至可以是串列
```python=
list1 = [1, 2, 3, 4, 5]          #元素皆整數
list2 = ["hey", "hello", "hi"]  #元素皆字串
list3 = [3, "hey", True]        #包含不同資料型態
list4 = ["Tom", 180, 65, "student", ['Go', 'Python']] # list內也可以放入串列
```

> * ### 注意索引值是從0開始計

### 索引值不可超出串列範圍，否則會產生錯誤
```python=
list3 = [3, "hey", True]  
print(list3[5])
# list index out of range
```
> #### 負索引值也同樣不可超出串列範圍

# 取得串列長度
使用`len()`方法，回傳該串列的長度，得知串列內包含多少元素。

# 取得`list`內的元素
## 範圍取值
若想要取得一連串某個範圍的值，使用方法跟切片相似(`Slice`)，結構如下:
```python=
my_list[start:end:sep]
```
其中:
* `start`: 開始索引的位置，預設的索引位置為第一個
* `end`: 結束索引的位置，預設的索引位置為最後一個
* `sep`: 索引的間隔，預設為`1`

### 範圍取值更多的應用
若範圍取值的`start`被省略，Python會自動選取預設的索引位置 **(第一個;`index=0`)** ，而範圍取值的`end`被省略，則自動選取預設的索引位置 **(最後一個;`index=-1`)**。

> ### 取出來的值只會包含開頭，不會包含結束的`index`

## 取得最後一個元素
若想要取得`list`中的最後一個元素，`index`值輸入`-1`。以此類推，若要選擇倒數第二個位置的元素，`index`值則填入`-2`。
```python=
list3 = [3, "hey", True]  
print(list3[-1]) # True
```
## 複製串列
省略`start`及`end`兩個索引值，只留一個冒號在中括號中，如`[:]`就可以複製整個串列。
```python=
arr=[1,3,5] # 建立一個arr串列
arr1=arr[:] # 將arr串列複製到arr1串列
print(arr1) # 印出arr1串列： [1,3,5]
```

### 重複n次
`list1 * n`方法，符號使用`*`，次數為`n`。
```python=
arr = ['tom', 'jean', 'hank']
arr1 = arr * 2
print(arr1)
# ['tom', 'jean', 'hank', 'tom', 'jean', 'hank']
```

## 印出切片的串列
```python=
numbs=[1,2,3,4,5]
for num in numbs[1:3] : # 印出numbs串列中索引值為1和2的元素
    print(num)
# 2
# 3
```

## 多維串列內元素的存取
使用多個中括號`[]`組合來完成。如:`my_list[index][index]`
```python=
list4 = ["Tom", 180, 65, "student", ['Go', 'Python']] 
print(list4[4]) # ['Go', 'Python']
print(list4[4][0]) # Go
```

## 增加元素
### `append()`
使用`append()` 方法將新元素增加到`list`最後面。
```python=
arr = ['hi', 'hello', 'hey']
arr.append('ya')
print(arr)  # ['hi', 'hello', 'hey', 'ya']
```

### `insert()` 
指定所增加元素的位置，使用`insert()` 方法，結構會是:`myList.insert(index, element)`。
* `index`: 表插入位置
* `element`: 表放入的元素
```python=
arr = ['hi', 'hello', 'hey']
arr.insert(1, "ya")
print(arr)  # ['hi', 'ya', 'hello', 'hey']
```

### `extend()`
`extend()` 方法可以一次加入很多個值或將某個`list`中的元素加到另一個`list`。
```python=
arr = ['hi', 'hello', 'hey']
arr1 = [1, 2, 2]
arr.extend(arr1)
print(arr) # ['hi', 'hello', 'hey', 1, 2, 2]
```

> ### 注意：如果是要一次添加多個元素，不能使用`insert()`或`append()`方法。

#### 範例(採用`append()`增加)
```python=
arr = ['hi', 'hello', 'hey']
arr1 = [1, 2, 2]
arr.append(arr1)
print(arr) # ['hi', 'hello', 'hey', [1, 2, 2]]
```

#### 範例(採用`insert()`增加)
```python=
arr = ['hi', 'hello', 'hey']
arr1 = [1, 2, 2]
arr.insert(2,arr1)
print(arr) # ['hi', 'hello', [1, 2, 2], 'hey']
```
上述範例會發現若採用`apppend()`或是`insert()`方法一次新增`list`中的所有元素，會發生直接把`list`放入另一個`list`的情形。
簡單來說，前兩者是以整個`list` 的資料型態被塞入，而不是以元素的形式被加入。

## `List`合併
Python在合併串列上提供一個簡單的方法: `+`，與字串拼接用法相同，將多個串列用`+`進行合併。
```python=
num = [23, 4, 53, 5 ,35, 6]
strArr = ["hi", "hello", "hey"]

# [23, 4, 53, 5, 35, 6, 'hi', 'hello', 'hey']
```

## 移除元素
### `remove()`
如果不確定或不在意元素在`list`中的位置，可以使用`remove()`**根據指定的值來刪除元素**。
```python=
arr = ['hi', 'hello', 'hey']
arr.remove("hello")
print(arr) # ['hi', 'hey']
```
### `pop()`
藉由索引值位置來指定刪除的元素，且**會回傳被刪除的值**。結構為`myList.pop(index)`
> 若`pop`內省略`index`值的話，預設為刪除最後一個元素，
```python=
# ==== 刪除索引值為0的元素 =======
arr = ['hi', 'hello', 'hey']
word = arr.pop(0)
print(arr) # ['hello', 'hey']
print(word) # hi

# ==== 預設為刪除最後一個元素 =======
arr = ['hi', 'hello', 'hey']
word = arr.pop()
print(arr) # ['hi', 'hello']
print(word) # hey
```

### `del`
**刪除指定位置元素**，使用`del`方法可以刪除一個元素，當元素刪除之後，位於它後面的元素會自動往前填補空出來的位置。
```python=
arr = ['hi', 'hello', 'hey']
del arr[1]
print(arr)
```

## 排序
使用`sort()`方法對`list`內的元素進行排序，預設情況下，字串會照字母順序排列、數字則會是遞增排列。
### 字母順序排列
```python=
arr = ['tom', 'jean', 'hank']
word = arr.sort() 
print(arr) # ['hank', 'jean', 'tom']
```
### 數字遞增排列
```python=
num = [23, 4, 53, 5 ,35, 6]
num.sort()
print(num) # [4, 5, 6, 23, 35, 53]
```
> ### `sort()`方法會改變原始`list`

### 不改變原始`list`的方法複製一個排序過的`list`
若想要保存完整的原始資料，但同時又需要有被排序過的資料。可以使用`sorted`方法。
```python=
num = [23, 4, 53, 5 ,35, 6]
newNum = sorted(num)
print(num) # [23, 4, 53, 5, 35, 6]
print(newNum) # [4, 5, 6, 23, 35, 53]
```

### 排序反轉
數字遞減排列、或是依照字母順序的反向排列。
```python=
num = [23, 4, 53, 5 ,35, 6]
num.sort()
print(num) # [4, 5, 6, 23, 35, 53]
```
### 括號中`()`可以設定排序的條件
在原本的`sort()`內加上參數`reverse=True`即可。
```python=
num = [23, 4, 53, 5 ,35, 6]
num.sort(reverse=True)
print(num) # [53, 35, 23, 6, 5, 4]
```

## 反轉
把 `list`內的元素順序反轉可以使用`reverse()`，會照當前的順序進行反轉。
```python=
num = [23, 4, 53, 5 ,35, 6]
num.reverse()
print(num) # [6, 35, 5, 53, 4, 23]
```

## 查找/檢測/計算

### 找極大(`max()`)、min(`sum()`)與計算`list`內元素的總和(`sum()`)
```python=
num = [23, 4, 53, 5 ,35, 6]
print(max(num)) # 53
print(min(num)) # 4 
print(sum(num)) # 126
```

### 查找某個元素在`list`內的索引值
採用`.index(element)`的方法，`element`為要查找的元素，回傳值為該元素的在`list`中的位置(index值)
```python=
arr = ['tom', 'jean', 'hank']
word = arr.index("jean") 
print(word) # 1
```
> 如果輸入的元素並不包含在list裡面的話，會出現`ValueError`


```python=
arr = ['tom', 'jean', 'hank']
word = arr.index("yo")
print(word)

# ValueError: 'yo' is not in list
```

### 檢測某值是否不在串列中：`in`、`not in`
`list`可搭配Python中的運算元`in`判斷目標元素是否在該`list`裡面，回傳值為`True`或`False`的`bool`值。
若運算元為`not in`，判斷後的回傳結果與`in`相反。
```python=
arr = ['tom', 'jean', 'hank']
print("hello" in arr) # False
print("hello" not in arr) # True
```

### 同時取得目標元素值與index值
使用`enumerate()`方法，配合`for` loop進行實作。
```python=
for index, item in enumerate(arr):
    print(index, item)
"""
結果
0 tom
1 jean
2 hank
"""  
```
#### `index`值可以省略，回傳值為`tuple`的資料結構

```python=
for item in enumerate(arr):
    print(item)

"""
結果
(0, 'tom')
(1, 'jean')
(2, 'hank')
"""
```

#### 更改`index`起始值
`enumerate()` 內加上`start`參數並給index值即可。
```python=
for index, item in enumerate(arr, start=1):
    print(index, item)

"""
1 tom
2 jean
3 hank
"""
# ======= 無index ========
for  item in enumerate(arr, start=1):
    print( item)
"""
(1, 'tom')
(2, 'jean')
(3, 'hank')
"""
```
上面的範例將index起始值從預設的`0`改為`1`

## `list`轉換為字串
使用`.join()`方法，格式為`newList = "seperator".join(listName)`，其中`seperator`替換成要隔開的符號。
```python=
arr = ['There', 'are', 'tom', 'jean', 'hank']
newstr = '_'.join(arr)
newstr1 = ' '.join(arr)
print(newstr) # There_are_tom_jean_hank  
print(newstr1) # There are tom jean hank
```

## 把字串分割成`list`
在原有的字串上使用`.split()`做分割，預設以**空白**做分割的符號。
```python=
newstr = "There_are_tom_jean_hank"
newstr1 = newstr.split("_")
print(newstr1) # ['There', 'are', 'tom', 'jean', 'hank']
```

# 元組(Tuple)
`Tuple`就是**不可做修改的`List`**，元組的結構與串列完全相同，差別在於元素個數及元素值皆不能改變，但串列可以。語法結構會是:`元組名 = (元素1, 元素2,.... )`
## 範例
```python=
tuple1 = (1, 2, 3, 4, 5)  #元素皆整數
tuple2 = (0, "Hey", False) #放入不同資料型態
```
若發生`tuple`內的元素被修改會出現`TypeError`的錯誤資訊。
```python=
tuple1[0] = "hello" 
print(tuple1[0]) # TypeError: 'tuple' object does not support item assignment
```
## `Tuple`好處:
* 執行速度比List快: 因為內容不會改變，因此`Tuple`內部結構比`List`簡單，執行速度較快。
* 存於Tuple的資料較為安全: 因為內容不會改變，不會因程式設計疏忽而變更資料內容。

# 參考
[Python 初學第五講 — 串列的基本用法](https://medium.com/ccclub/ccclub-python-for-beginners-tutorial-c15425c12009)
[DAY 04 串列的操作與運用](https://ithelp.ithome.com.tw/articles/10200657)
[Day09-List的進階操作與用法](https://ithelp.ithome.com.tw/articles/10204734)