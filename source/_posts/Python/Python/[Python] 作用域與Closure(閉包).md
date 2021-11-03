---
title: "[Python] 作用域與Closure(閉包)"
catalog: true
date: 2020/02/26 17:00:00
tags: [Python, w3HexSchool]
categories: Backend
toc: true
---

> 鼠年全馬鐵人挑戰 - WEEK 03

<!-- toc -->
# 前言
前幾篇提到Python中的Decorator，其實隱含許多作用域以及閉包的概念，故另外獨立寫成一篇來近一步討論這兩者。
<!--more-->
# First-class Function(頭等函式)
在了解Closure之前，要先知道Python中的First-class Function是什麼，First-class Function又可以被稱做頭等函數，或是頭等物件(First-class Object)，Python裡的**每個function都是first-class function**。
根據[MDN](https://developer.mozilla.org/en-US/docs/Glossary/First-class_Function)的定義
> A programming language is said to have First-class functions when functions in that language are treated like any other variable. For example, in such a language, a function can be passed as an argument to other functions, can be returned by another function and can be assigned as a value to a variable.


上面這段描述白話來說就是： 
> ### 函數可以被當做參數傳遞、能夠作為函數回傳值、能夠被修改、能夠被賦值給一個變數。
> 這意味著函數可以傳遞可用作參數，如同其他物件（字串、整數、浮點數、list等）一樣

## 範例
### 可被賦值給變數
```python=
def compare(m, n):
    return m if m > n else n

func = compare # assign function物件給func
print(compare)
print(func)
print(compare(10, 20))
print(func(10, 20))
"""
結果
<function compare at 0x112441e60>
<function compare at 0x112441e60>
20
20
"""
```
由上面的範例來看，`compare`函數物件被賦值給變數`func`，print出的結果顯示compare和func指向同一個函數物件。

### 可作為參數傳遞
```python=
def square(x):
    return x * x

def arr(f, items):
    return [f(item) for item in items]

numbers = [1, 2, 3, 4, 5]

total = arr(square, numbers)
print(total)  # [1, 4, 9, 16, 25]
```
由上面的範例來看，函數`square`函數物件被當作`arr`函數的參數傳遞  ，隨後於`arr`中進行陣列處理。

再給個例子：
以 `say_hello`, `be_awesome` 兩個函示做為參數，傳入 `greet_tom` 這項函式裡，接著呼叫該函式
```python=
def say_hello(name):
    return f"Hello {name}"

def be_awesome(name):
    return f"Yo {name}, together we are the awesomest!"


def greet_tom(greeter_func):
    return greeter_func("Tom")

print(greet_tom(say_hello))  # Hello Tom
print(greet_tom(be_awesome))  # Yo Tom, together we are the awesomest!
```
上述範例流程：
 -  兩個函示分別為 `greet_tom` 函示的參數
 - 執行 `greet_tom` 函式後呼叫 `greeter_func` 函式
 - 這時 `say_hello`, `be_awesome` 兩個函示分別代表以 `greeter_func` 的參數形式進行韓式呼叫
 -  `greeter_func`  呼叫時傳入 `Tom` 這個字串型別的參數
 -  最終根據傳入不同的參數(函示)來源，回傳相應的結果

### 可作為函數的回傳值
```python=
# 可作為函數的回傳值
def logger(msg):
    def message():
        print('Log:', msg)
    return message

logWarning = logger('Warning')
logWarning()  # Log: Warning
```
由上面的範例來看，在函數`logger`內部建立函數`message`，函數`message`內使用了`logger`傳入的參數`msg`，最後`logger`將`message`函數作為回傳值，再assign給`logWarning`進行呼叫。

或是另外一個例子:
```python=
def html_tag(tag):
    def wrap_text(text):
        print('<{0}>{1}</{0}>'.format(tag, text, tag))
    return wrap_text

h1 = html_tag('h1')
h1('This is a header')             # <h1>This is a header</h1>
h1('This is a header, too')        # <h1>This is a header, too</h1>

p = html_tag('p')
p('This is the first paragraph')   # <p>This is the first paragraph</p>
p('This is the second paragraph')  # <p>This is the second paragraph</p>
```

# Python Scope(作用域)
有了頭等函式概念之後，再來談談 Python 的作用域。
Python 的作用域(scope)規則規則叫做 **LEGB**，查找時 scope 會循這個規則，順序為 **Local -> Enclosed -> Global -> Built-in**
* **Local**: 於 function 或是 class 內宣告的變數名
* **Enclosed**: 位於巢狀層次的function結構，常用於Closure
* **Global**: 最上層位於模組(module)的全域變數名稱
* **Build**-in: 內建模組(module)的名稱，例如`print`, `abs()`這樣的函式等等

![](https://i.imgur.com/kp3znNc.jpg)
[圖片源](https://data-flair.training/blogs/python-variable-scope/)

[The Python Tutorial](https://docs.python.org/3/tutorial/classes.html#python-scopes-and-namespaces)裡面有更詳細的解釋。
>* the innermost scope, which is searched first, contains the local names
>* the scopes of any enclosing functions, which are searched starting with the nearest enclosing scope, contains non-local, but also non-global names
>* the next-to-last scope contains the current module’s global names
>* the outermost scope (searched last) is the namespace containing built-in names

Python的作用域有許多細節可以討論，為了縮短篇幅和挑幾個重點出來，主要區分為global(全域)、local(區域)變數和Enclosed Scope。
## global(全域)變數
放在function外的變數
```python=
a = "hello a"
def scope1():
    print(a)
    
scope1()
"""
執行結果:
hello a
"""
```
執行`scope1()`，要印出a變數的值時，若在`scope1`內找不到變數a，便會往外找，找到全域中宣告的a變數
## local(區域)變數
在Python裡創建一個function，function內執行的區域稱作「local scope」，而建立區域變數最簡單的方式是於function中給定一個變數。一般來說，全域變數是無法被該function scope內重新定義的變數進行存取。

### 範例
假設有一變數a初始值為`hello a`，想要透過`scope1()`函數對a重新賦值
```python=
a = "hello a"
def scope1():
    a = 1
scope1()
print(a)
"""
執行結果:
hello a
"""
```
上述結果告訴我們，`a = 1`無法對`scope1()`外的a重新賦值。

> 若要讓local scope內的變數讓外部進行存取，可以在目標變數的前面宣告一個`global`

```python=
a = "hello a"
def scope1():
    global a
    a = 1
scope1()
print(a)
"""
執行結果:
1
"""
```
## 特殊情況
在Python中，區域變數或是全域變數，兩者只能「選邊站」，不可以同時指定為區域變數及全域變數。
```python=
a = 5
def scope():
    print(a)
    a = 10

scope()
```
執行上述範例，會得到`UnboundLocalError`的錯誤資訊。
## Enclosed Scope 
依據巢狀層次從內到外搜尋，當搜尋到LEGB的E時，Python會從最近的 enclosing scope 向外找起，那這些enclosing scopes裡的所有變數，稱作**non-local variable**。
```python=
# enclosure
def outer(a):
    b = a
    def inner():
        c = 3
        def inner_inner(b):
            k = b+c
            return b+c
        return inner_inner
    return inner
outcome = outer(5)
ans = outcome()
ans(3) # 6
```
以上述範例來說，`b`是`outer()`的區域變數，`c`是`inner()`的區域變數，由於離`inner()`最近的scope是`outer`所建立的，`b`又是於此scope被宣告，所以`b`是`inner()`的**non-local variable**。

再往下走，以`inner_inner()`來看，`k`為它的**local variable** ，值被assign為`b+c`，這時的`b` 並非被宣告在`outer()`scope裡，而是藉由參數傳遞的，也就是說，`b`屬於**local variable**。反之`c`則是被宣告在`inner()`的scope裡，對`inner_inner()`來說，是屬於**non-local variable**。

# Closure
前面提到很多關於頭等函式及作用域，可以開始進入正題: **Closure**

> 假設有個巢狀函式，最外層的函式把自己內層嵌套另外一個函式，將這個嵌套的函式作為回傳值傳遞出去，便會形成一個**Closure**。

先看一段範例:
```python=
def student():
    height = 170
    weight = 60
    def info():
        print("my height is {}.".format(height))
        print("my weight is {}.".format(weight))
    return info
print(student)
print(student())
students = student()
students()

"""
回傳結果:
<function student at 0x112479440>
<function student.<locals>.info at 0x1124794d0>
my height is 170.
my weight is 60.
"""
```
上面的範例可以觀察出一個奇怪的點，一般情況下，function中內區域變數的生命週期(life cycle)會隨著function執行完畢而結束，但是`print`出來的結果卻還可以讀取到`height`、`weight`兩個屬於`student()`scope的變數。

原因在於`return info`這個地方，`info`這個function趁著`return`的時候**捕捉外層函式裡的變數**，並偷渡進來自己的scope裡面。

> 被捕捉的變數便稱做「captured variable」，帶有captured variable的函式稱為**closur**e。

## 查看Closure
若想知道閉包儲存多少物件，可以印出`__closure__`屬性查看資訊，`__closure__`會是一個唯讀屬性；印出的資料型態是`tuple`。
```python=
def student():
    height = 170
    weight = 60
    def info():
        print("my height is {}.".format(height))
        print("my weight is {}.".format(weight))
    return info

students = student()

print(student.__closure__) # None
print(students.__closure__) # (<cell at 0x112cb1d50: int object at 0x10d522670>, <cell at 0x112cb1d90: int object at 0x10d5218b0>)
print(type(students.__closure__)) # <class 'tuple'>

print(students.__closure__[0].cell_contents) # 170
print(students.__closure__[1].cell_contents) # 60 
```
從上面的範例來看會發現，雖然對`info`來說，有`height`、`weight`兩個**non-local variable**，但因為`info`並未使用它們，所以這時`student.__closure__`的回傳值是`None`。

再往下一步，對`student`進行呼叫，並assign給變數`students`，訪問`__closure__`屬性則會回傳` (<cell at 0x112cb1d50: int object at 0x10d522670>, <cell at 0x112cb1d90: int object at 0x10d5218b0>)`這樣的物件資訊。

若要印出裡面的某個物件的話，如取得物件的值，跟`tuple`取值的方法相同，`[]`填入要索引的位置，如`students.__closure__[0].cell_contents`，回傳`index=0`的值。

## Captured variables 如何賦值
如果要對Captured variables重新賦值的話，
```python=
def student():
    height = 170
    weight = 60
    def info():
        height += 1
        weight -= 1
        print("my height is {}.".format(height))
        print("my weight is {}.".format(weight))
    return info

students = student()
print(students()) # UnboundLocalError
```
執行上述範例後會看到預期不到的錯誤: `UnboundLocalError`。

### 原因
在function scope中，當變數被賦值時，Python會自動將變數設定為**區域變數(local variable)**。
回頭看上面的範例中，`height`、`weight`被重新賦值，兩者在`info`這個function scope判定為區域變數，但兩者找不到相對應的變數名。

在一般情況下，若想在某個function中assign新的值給先前宣告在全域變數(global scope)中的變數時，一樣也會報`UnboundLocalError`錯誤訊息。
```python=
a = 5
def scope():
    a += 10

scope() # UnboundLocalError
```

### 解決方法
宣告`nonlocal`去操作captured variable。
來看範例:
```python=
def student():
    height = 170
    weight = 60
    def info():
        # nonlocal
        nonlocal height
        nonlocal weight
        height += 1
        weight -= 1
        print("my height is {}.".format(height))
        print("my weight is {}.".format(weight))
    return info

students = student()
students()

"""
結果
my height is 171.
my weight is 59.
"""
```
加上`nonlocal height`、`nonlocal weight`後即可正常assign變數了哦！

> captured variable在Python中並非區域或全域變數，所以只能用 `nonlocal`去宣告變數，才能進行其他操作。

## Captured variables具獨立性
```python=
def student():
    height = 170
    weight = 60
    def info():
        # nonlocal
        nonlocal height
        nonlocal weight
        height += 1
        weight -= 1

        print("my height is {}.".format(height))
        print("my weight is {}.".format(weight))
    return info

students1 = student()
students1()
students1()
students1()
print("\n--- students1 比較 students2 ---\n")
students2 = student()
students2()

"""
結果:
my height is 171.
my weight is 59.
my height is 172.
my weight is 58.
my height is 173.
my weight is 57.

--- students1 比較 students2 ---

my height is 171.
my weight is 59.
"""
```
由上述例子可知: 
即使`students1`持續將`height`與`weight`兩個Captured variables加總和遞減，另一個`students2`內的Captured variable完全不受影響，推論兩個closure function彼此獨立。

以上為關於作用域及Closure相關概念，如有錯誤之處，還請指教。

# 參閱
[什麼是first-class function](https://zhuanlan.zhihu.com/p/60754224)

[聊聊 Python Closure](https://medium.com/@dboyliao/%E8%81%8A%E8%81%8A-python-closure-ebd63ff0146f)

[Python進階技巧 (4) — Lambda Function 與 Closure 之謎！](https://medium.com/citycoddee/python%E9%80%B2%E9%9A%8E%E6%8A%80%E5%B7%A7-4-lambda-function-%E8%88%87-closure-%E4%B9%8B%E8%AC%8E-7a385a35e1d8)