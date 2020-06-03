---
title: "[Python] 字典-Dictionary"
catalog: true
date: 2019/08/03 20:23:10
tags: Python
categories: Backend
---
<!-- toc -->
# 前言
每一個元素都由**鍵(key)和值(value)組成的鍵值對**物件，結構為`{key: value}`，鍵和值之間是用**冒號 `:`** 來分隔，鍵-值對之間是用**逗號`,`** 做分隔。
<!--more--> 
# 創建字典
方式有兩種:
* 使用大刮號 `{}`
* 使用內建函數 `dict()`

```python=
# ======= 大括號{}方法建立     ======
student_1 = {'name': 'Tom',
           'birth': 1997,
           'ID': '1234567'}
# ======= dic()方法建立     ======
student_2 = dict(name='Jack',
               birth=1985, 
               ID='46383')
# ==========================
student_3 = {'name': 'Amy',
           'birth': 2002,
           'ID': '1938098'}

# ====== 取得對應的 value ========
print(student_1['name'])     
print(student_2['birth'])     
print(student_3['ID']) 
"""
結果:
Tom
1985
1938098
"""
```
> * 字典裡的`value`可以是任何的資料型態，例如: 字串、list、物件等等。但 `key` 必須是唯一且不可變的。
> * dictionary 沒有順序性

## 回傳錯誤的訊息
### 預設
如果輸入了一個不存在的 `key`，則會回傳`KeyError`的錯誤訊息。
```python=
print(student_3["hi"]) 
```
### 替換錯誤訊息
若要避免上述情形的話，可以使用`get()`來取值，此時會回傳`None`，而不會回傳錯誤訊息了。
```python=
print(student_3.get("hi")) # hi
```
### 自訂錯誤訊息
若不希望回傳`None`，想自訂`None`訊息的話，可在括號內設定自己想要的`None訊息。
```python=
print(student_3.get("hi", "不存在哦！")) # 不存在哦！
```
# 新增&更新
存取值的方法來新增或是更動某一組鍵值對(`key-value`)。
```python=
student_1 = {'name': 'Tom',
           'birth': 1997,
           'ID': '1234567'}
           
student_1["age"] = 20 # 新增age的鍵值對
student_1["ID"] = 787878 # 更新ID的鍵值對
print(student_1)

# {'name': 'Tom', 'birth': 1997, 'ID': 787878, 'age': 20}
```
## 更新多筆資料
可以使用`update(dic)`方法，`dic`替換成要新增的字典。
```python=
student_1 = {'name': 'Tom',
           'birth': 1997,
           'ID': '1234567'}
dic = {
    "age": 30,
    "gender": "male",
    "city": "高雄"
}
student_1.update(dic)
print(student_1)
```
# 刪除
刪除一筆元素，有兩種方法:
## `del`
```python=
student_1 = {'name': 'Tom',
           'birth': 1997,
           'ID': '1234567'}
del student_1["birth"]
print(student_1)
# {'name': 'Tom', 'ID': '1234567'}
```

## `pop`
回傳刪掉的值，且**不改變原始字典的資料**。

# 計算鍵值對的個數
用`len()`方法
```python=
student_1 = {'name': 'Tom',
           'birth': 1997,
           'ID': '1234567'}
print(len(student_1))
# 3
```
# 印出字典裡所有的`key`
```python=
print(student_1.keys())

# dict_keys(['name', 'birth', 'ID'])
```
# 印出字典裡所有的`value`
```python=
print(student_1.values())

# dict_values(['Tom', 1997, '1234567'])
```
# 印出字典裡的所有`key、`value`
```python=
print(student_1.items())
# dict_items([('name', 'Tom'), ('birth', 1997), ('ID', '1234567')])
```

# 檢查指定的`key`是否存在於字典內
使用`in`這個運算元判定`key`是否存在於字典中，若存在則回傳`True`，反之則回傳`False`
```python=
print("ddf" in student_1)
print("birth" in student_1)

# False
# True
```

# 判斷兩個字典是否為同一個物件
利用`is`運算子，可以判斷兩個字典是否為相同的物件。
```python=
student_1 = {'name': 'Tom',
           'birth': 1997,
           'ID': '1234567'}
           
student_2 = dict(name='Jack',
               birth=1985, 
               ID='46383')

print(student_1 is student_1)
print(student_1 is student_2)

"""
True
False
"""
```
# for loop應用
```python=
dict_squares = {i: i**2 for i in range(6)}
print(dict_squares)
# {0: 0, 1: 1, 2: 4, 3: 9, 4: 16, 5: 25}
```

# 參考
[DAY 08 字典應用](https://ithelp.ithome.com.tw/articles/10202396)
[Python 初學第九講 — 字典](https://medium.com/ccclub/ccclub-python-for-beginners-tutorial-533b8d8d96f3)