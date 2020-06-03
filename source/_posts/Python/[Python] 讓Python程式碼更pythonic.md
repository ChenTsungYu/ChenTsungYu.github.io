---
title: "[Python] 讓Python程式碼更Pythonic"
catalog: true
date: 2020/01/01 20:23:10
tags: Python
categories: Backend
---
<!-- toc -->
# 前言
之前跟朋友一起討論程式時，有時覺得寫的程式碼太多行，想辦法盡量寫得精簡一些，於是開始找網路上各個大神的寫法，沒查還好，一查天為驚人，藉此機會筆記一下，之後可以回過頭來檢視一下自己寫的程式碼品質。
<!--more--> 
# 兩個變數的值進行交換
```python= 
# worst case
temp = a
a = b
b = temp

# best case
a,b = b,a
```

# 鏈式比較
```python=
a = 3
b = 1 
# worst case
b >= 1 and b <= a and a < 10 #True 

# best case
1 <= b <= a < 10  #True
```
# 真值測試
```python=
name = 'Tim'
langs = ['AS3', 'Lua', 'C']
info = {'name': 'Tim', 'sex': 'Male', 'age':23 }    
 
# worst case
if name != '' and len(langs) > 0 and info != {}:
    print('All True!') #All True!

# best case
if name and langs and info:
    print('All True!')  #All True!
```
>對於任意目標變數，直接判斷其真假，無需寫判斷條件，這樣既能保證正確性，又能減少程式碼的量。 **要訣: 記住False條件**


| True | False |
| -------- | -------- | 
| 任意非空字串  | 空的字串 ''  | 
| 任意非數字0   | 數字0  | 
| 任意非空容器   | 空的容器 [] () {} set()  | 
| 其他任意非False   | None  | 

## 字串反轉
```python=
name = 'Tim'
langs = ['AS3', 'Lua', 'C']
info = {'name': 'Tim', 'sex': 'Male', 'age':23 }    
 
# worst case
for x in range(len(string)-1,-1,-1):
        newstring += string[x]
print(newstring) # nohtyp

# best case
string = "python"
print(string[::-1]) # nohtyp
```

## 字串、列表(list)合併
```python=
strList = ["Python", "is", "good"]  

# worst case

res = ''
for s in strList:
    res += s + ' '
print(res) #Python is good 

# best case
res =  ' '.join(strList) 

print(res) #Python is good
```
## List Comprehension
網路上有很多優雅的寫法，可點擊[此網站](https://www.programiz.com/python-programming/list-comprehension)參考。
### 表達式
在list內做for loop時前面先宣告一個表達式(expression)
```python=
# Add three to all list members.
a = [3, 4, 5]
b = a          

# worst case
for i in range(len(a)):
    a[i] += 3             # b[i] also changes

# best case
a = [i + 3 for i in a]
b = a[:]  #  copy a list
print(a, b) # [6, 7, 8] [6, 7, 8]
```

### 比較兩個List
```python=
# worst case
cashier_5 = []
for item in cart_1:
    if item in cart_2:
        cashier_5.append(item)
print(cashier_5) # [8, 58, 88]

# best case
cashier_5 = [item for item in cart_1 if item in cart_2]
print(cashier_5) # [8, 58, 88]
```

### 表達式&單一條件判斷
在list內做for loop時，除了可以前面先宣告一個表達式(expression)之外，還可以在後方添加條件判斷
```python=
strList = ["Python", "is", "good"]

# worst case
l = []
for x in range(10):
    if x % 3 == 0:
        l.append(x*x) 
print(l) #  [0, 9, 36, 81]

# best case
l = [x*x for x in range(10) if x % 3 == 0]
print(l) # [0, 9, 36, 81]
```

### 表達式&單一條件判斷&嵌入多個條件判斷
```python=
num_list = [y for y in range(100) if y % 2 == 0 if y % 5 == 0]
print(num_list)
```

### 迴圈嵌套
```python=

# worst 
transposed = []
matrix = [[1, 2, 3, 4], [4, 5, 6, 8]]

for i in range(len(matrix[0])):
    transposed_row = []

    for row in matrix:
        transposed_row.append(row[i])
    transposed.append(transposed_row)

print(transposed)

# [[1, 4], [2, 5], [3, 6]]

# best
matrix = [[1, 2], [3,4], [5,6], [7,8]]
transpose = [[row[i] for row in matrix] for i in range(2)]
print (transpose) # [[1, 3, 5, 7], [2, 4, 6, 8]]
```

## if-else 簡寫
```python=
# worst case
if 'a'=='a':
    x=True
else :
    x=False
print(x) # True
# best case
x=True if 'a'=='a' else False 
print(x) # True
```

## Dictionary
```python=

# worst case
dict_squares = {}
for i in range(6):
    dict_squares[i] = i**2
print(dict_squares) # {0: 0, 1: 1, 2: 4, 3: 9, 4: 16, 5: 25}

# best case
dict_squares = {i: i**2 for i in range(6)}
print(dict_squares) # {0: 0, 1: 1, 2: 4, 3: 9, 4: 16, 5: 25}
```

# 讀取檔案
以讀檔案的模式開啟一個檔案物件，可用Python內建的`open("檔名", '操作模式的符號')`函式。
```python=
# Bad practice
try:
   f = open("test.txt",encoding = 'utf-8')
   a = f.read()
   print(a)
finally:
   f.close()
# Best practice
with open("test.txt",encoding = 'utf-8') as f:
    print(f.read())

```


# 參考文章
[The Hitchhiker’s Guide to Python](https://docs.python-guide.org/writing/style/)