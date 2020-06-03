---
title: "[Python] 物件導向入門"
catalog: true
date: 2020/01/03 20:23:10
tags: [Python, OOP]
categories: Backend
---
<!-- toc -->
# 什麼是物件導向？
將現實生活中的人、事、時、地、物進行資料抽象化。
類別，是具有相同屬性(Attribute)和功能(Method)的物件抽象集合，類別中包含資料的屬性、方法(也可以稱作行為)，將這些類別對應到真實生活中的人、事、時、地、物時稱作"實例化"，可以說這些對應的實際實體為實際案例(簡稱"實例")，也作"物件"。
<!--more--> 
白話一點就是: "類別" 只是將真實世界的人、事、時、地、物做分類的"概念"，需對應真實世界中的實例才具意義或是資料處理的價值，類別底下會有多個物件(多個實例)。

不同物件會有不同屬性值，如: 以學生為類別(Class)名，學生A這個物件有兩個屬性，屬性名為姓名、學號，而屬性值為A、01;另一個學生B的物件則屬性值分別為B、02。由於雖然源自同一類別(學生)，但物件各自獨立，屬性值也跟著獨立，彼此互不影響。

# 好處是什麼?
* 容易擴展:
如上面的例子，建立一個名為學生的類別，底下可以一直增加不同的學生，他們都有自己的屬性參數。
* 可重複使用: 
同一個物件、類別可以重複進行呼叫，減少撰寫重複的程式碼
* 模組化
可將系統細分然後分配給不同團隊來進行工作

## 強調重點
>一個物件（Object）可以包含屬性（Attribute）與方法（Method），而class的概念是屬性集合，並非所有物。

## 物件導向具有三大特性:

- 多型:

    表示不同物件可以執行相同動作，但要透過它們自己的實作來執行。　如果子類別要完全實作父類別的成員，父類別則將該成員宣告為虛擬(virtual)。子類別可以使用override的方式，將自己的實作取代掉父類別的實作。

- 封裝:

    每個物件都包含本身操作所需要的資訊，這個特性稱之為封裝，因此物件不需依賴其他物件來完成自己的操作。　那封裝的好處有哪些？

    1. 良好的封裝能減少模組間的耦合。
    2. 類別內部的實作可以自由修改。
    3. 類別有明確的對外接口，讓外部進行呼叫。
- 繼承(像是親屬的垂直關係):

    賦予物件重複使用和擴充的能力，父類別的資源可以透過子類別做擴充和重複使用。

    繼承能定義出父類別與子類別，其中子類別繼承父類別所有的特性，且子類別還能定義新的特性。繼承有幾個重點：

    1. 子類別可拓展父類別沒有的屬性和方法
    2. 子類別能重寫父類別的方法


概略了解物件導向後就可進行實作。


# 實作

* 宣告類別: Python使用`class`語法來定義類別，通常會用首字大寫（Capitalized）的單字為類別命名
* `def __init__(self):` 代表宣告時會自動執行的函式，常用來定義該類別的物件屬性，`self`為必要之參數。
* 類別中定義方法採用`def`進行**方法宣告**
* 訪問類別內的物件屬性使用`類別名.屬性名`的方式

```python=
class Student: # 定義類別屬性名，進行類別宣告
    major = "CSE" # 定義 static variabl
    def __init__(self, rollNumber, name):
        self.rolNo = rollNumber
        self.name = name

student1 = Student(1, "Tom")
student2 = Student(2, "Ken")
# 取得屬性名對應的屬性值 
print(student1.name, student2.name) #  Tom Ken

# 訪問Class內的static variabl
print(Student.major, student1.major, student2.major) # CSE CSE CSE

```
上述範例宣告一個名為Student的類別(class)，並建立其屬性，先傳入不同的參數，在賦值給student1、student2，最後再透過`.`訪問屬性值。

## 我們還可以在Class 內定義另一個Class
```python=
class Car:
    def __init__(self, make, year):
        self.make = make
        self.year = year
    class Egine:
        def __init__(self, number):
            self.number = number
        def start(self):
            return "Egine Start!"

car1 = Car("BMW", 2017)
egine = car1.Egine("MHP-9778")
print(egine.start(), egine.number, car1.make, car1.year)
# Egine Start! MHP-9778 BMW 2017
```
上面範例建立一個Car類別，底下除了定義物件屬性外，另建立一個新類別Egine，並在Egine下定義其屬性名及方法。
`car1 = Car("BMW", 2017)`建立BMW物件，在BMW下`car1.Egine("MHP-9778")`建立編號為MHP-9778的Egine物件，`egine.start()`用來呼叫Egine定義好的方法。

## 我們也可以更改物件屬性

例子:
```python=
class NewStudent:
    def __init__(self, sid = 123, name="Tom"):
        self.id = sid
        self.name = name
    def display(self):
        return self.id, self.name

news1 = NewStudent()
print(news1.id, news1.name) # 123 Tom
news1.id = 345
print(news1.id, news1.name) # 345 Tom
```

## 資訊隱藏(information hiding)
物件屬性有時如果變數不希望或不該隨意給外部程式更改，只需在屬性前加上連續兩個底線。
### 資訊隱藏後: 在屬性名前面加上 __ 

```python=
class NewStudent:
    def __init__(self, sid = 123, name="Tom"):
        self.__id = sid
        self.__name = name
    def display(self):
        return self.__id, self.__name


# 無法直接訪問屬性值
print(news1.id, news1.name)
# 'NewStudent' object has no attribute 'id'
print(news1.__id, news1.__name) 
# AttributeError: 'NewStudent' object has no attribute '__id'

```
但也並非完全無法更改，只是需要其他方式，例如method方法訪問屬性值，或是透過 "_" 的方式進行直接訪問
```python=
# method 訪問屬性值
print(news1.display()) # (123, 'Tom') 

# 透過 "_" 的方式進行直接訪問
print(news1._NewStudent__id, news1._NewStudent__name)  # 123 Tom
```
## 回顧重點:
* Python使用`class`語法來定義類別，通常會用首字大寫（Capitalized）的單字為類別命名
* `def __init__(self):` 代表宣告時會自動執行的函式，常用來定義該類別的物件屬性，`self`為必要之參數。
* 類別中定義方法採用`def`進行方法宣告
* 訪問類別內的物件屬性使用`類別名.屬性名`的方式
* 物件屬性有時如果變數不希望或不該隨意給外部程式更改，只需在屬性前加上連續兩個底線`__`。


## 參考文章
* [物件導向與封裝](http://kaiching.org/pydoing/py-guide/unit-10-object-oriented-programming-and-encapsulation.html)
* [Name mangling](https://aji.tw/python%E4%BD%A0%E5%88%B0%E5%BA%95%E6%98%AF%E5%9C%A8__%E5%BA%95%E7%B7%9A__%E4%BB%80%E9%BA%BC%E5%95%A6/)
* [Class 官方文件說明](https://docs.python.org/3/tutorial/classes.html#private-variables)
* [淺談 Python 的特殊方法 (Special Method Names) (1)](http://blog.castman.net/%E6%95%99%E5%AD%B8/2018/05/08/python-special-names-1.html)
* [物件導向程式設計 (OOP) 基礎觀念](http://glj8989332.blogspot.com/2017/11/design-pattern-oop.html)
* [Python的類別(Class)...基本篇](https://medium.com/@weilihmen/%E9%97%9C%E6%96%BCpython%E7%9A%84%E9%A1%9E%E5%88%A5-class-%E5%9F%BA%E6%9C%AC%E7%AF%87-5468812c58f2)
* [繼承](https://openhome.cc/Gossip/Python/Inheritance.html)