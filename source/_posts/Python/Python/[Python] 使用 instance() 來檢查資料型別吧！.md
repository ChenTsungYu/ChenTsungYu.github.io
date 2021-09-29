---
title: "[Python] 使用 instance() 來檢查資料型別吧！"
catalog: true
date: 2021/06/30 20:23:10
tags: Python
categories: Backend
toc: true
---

# 前言
先前使用 Python 測試物件、變數是否為指定的『類別』或『資料型態』 時(e.g. `int`、`float`、`bool`、`str`、`list` ......)，都是使用 `type()` 方法，但其實 Python 有提供 `isinstance()` 函式，此法是較好的作法，不僅執行速度較快，也適用於自己建立的 Class 物件繼承(`type()` 不考慮物件繼承，若為繼承類別的物件不會判斷與父類是相同類別)數，來看看他有哪些特性與用法吧！
<!--more-->

# 如何在 Python 中使用 isinstance() 函數
## 語法
`isinstance()` 函數需傳入兩個必要參數，若檢查的結果相符，回傳結果為 `True`，反之為 `False`
- `object`: 此參數傳入指定的 **類別(Class)** or **變數**
- `classinfo`: 此參數傳入指定類別(Class)名稱或變數型別，另外支援以`tuple`形式傳遞多個類別 or 資料型別的值

### 語法規則：
```
isinstance(object, classinfo)
```
### 範例1 - 檢查變數的型別
檢查 numb 這項變數的型別是否為 `str`(字串)
```python=
word= "hello"
result = isinstance(word, str)
print(result)
if result:
    print("Y")
else:
    print("N")
```
output:
```
True
Y
```
由輸出結果可知，透過 `isinstance()` 函式對  word 變數做型別檢查是否為 `string`，回傳結果為 `True` 表類型相符。

`isinstance()` 函式亦能對其他 Pyhton 內建的型別(e.g. )進行檢查，以下列出幾個範例
```python=
# 檢查 numb 是否為 int
numb = 10
print(isinstance(number, int))
# output True

print(isinstance(number, float)) 
# output False

PI = 3.14
# 檢查 PI 是否為 float
print(isinstance(PI, float))
# Output True

# Check if (1 + 2j) is an instance of complex
complex_num = 1 + 2j
print(isinstance(complex_num, complex))
# Output True

# Check if names is an instance of class list
names_list = ["Tom", "Jack", "Jason"]
print(isinstance(names_list, list))
# Output True

people = {"Tom": 80, "Jack": 70, "Jason": 90}
print(isinstance(people, dict))
# Output True

names_tuple = ("Emma", "Jackson", 'Amy')
print(isinstance(names_tuple, tuple))
# Output True

numbs = {1, 2, 3, 4}
print(isinstance(numbs, set))
# Output True
```

> ### 注意：
> 若將 `isinstance()` 與任何帶有 `None` 的變數或物件一起使用時，回傳結果為 `False`

```python=
none_var = None
# 空字串非 None 值
empty_str = ''
print(isinstance(none_var, float)) # False
print(isinstance(empty_str, str)) # True
```

### 範例2 - 檢查類別(Class)
除了針對變數做型別檢查外，亦可對類別檢查
```python=
class Animal:
    def __init__(self, name, age):
        self.name = name
        self.age = age

class Student:
    def __init__(self, name, degree):
        self.name = name
        self.degree = degree

ani = Animal("Amy", 3)
stud = Student("Tom", "master")

# 檢查 stud 是否為 Student 類別
print(isinstance(ani, Animal)) # True

# 檢查 stud 是否為 Student 類別
print(isinstance(stud, Student)) # False
```
### 範例3 - 檢查變數的多個型別
前述第一個範例只有針對單一型別做檢查，`isinstance()` 提供一次檢查多個型別的功能，參數可以`tuple` 形式一次帶入多個資料型別。例如我們想確認該變數是否為數值時，可能同時包含 `int`, `float` 兩種型別，以下作為範例
```python=
def is_number(numb):
    if isinstance(numb, (int, float)):
        print(f'變數 {numb} 為數值型別的實例')
    else:
        print(f'變數 {numb} 非數值型別的實例')

n1 = 80
is_number(n1)
# 變數 80 為數值型別的實例

n2 = 55.70
is_number(n2)
# 變數 55.7 為數值型別的實例

n3 = '20'
is_number(n3)
# 變數 20 非數值型別的實例
```

### 範例4 - 檢查類別繼承(Class Inheritance)
`isinstance` 函式也可針對物件導向的類別(Class)繼承(如子類別的物件也是父類別的一種類型)做檢查，若 `instance()` 的 `classinfo` 參數是目標類別的父類別，則回傳 `True` ，反之為 `False`，來看個例子:
```python=
class Vehicle(object):
    def __init__(self, category):
        self.category = category

    def display(self):
        print("Vehicle: ", self.category)

class Car(Vehicle):
    def __init__(self, category, color):
        self.category = category
        self.color = color  # 顏色屬性

    def display(self):
        print("Category: ", self.category, "color: ", self.color)


obj = Car("car", "red")

print(isinstance(obj, Car)) # Output True
print(isinstance(obj, Vehicle)) # Output True
```

## 比較 type() 與 isinstance() 兩者的速度
- `type()`
```python=
python3  -m timeit -s "variable = 'test'" "type(variable) is str"
```
> output: 5000000 loops, best of 5: 43.7 nsec per loop

- `isinstance()`
```python=
python3  -m timeit -s "variable = 'test'" "isinstance(variable, str)"
```
> output: 10000000 loops, best of 5: 35.5 nsec per loop

分別執行上述兩者針對同一變數是否為字串時的比對時，執行速度是 `isinstance()` 較佳。

# 總結
`isinstance` 通常是比較類型的首選。藉由上面幾個範例可知，它不僅更快，同時考慮繼承，下次若要對資料做型別檢查時，就優先考慮 `isinstance` 這個函式吧～

# Reference
- [Python isinstance() function explained with examples](https://pynative.com/python-isinstance-explained-with-examples/#h-how-to-use-isinstance-function-in-python)
- [type() vs. isinstance()](https://switowski.com/blog/type-vs-isinstance)