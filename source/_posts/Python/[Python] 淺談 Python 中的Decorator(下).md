---
title: "[Python] 淺談 Python 中的Decorator(下)"
catalog: true
date: 2020/02/07 20:23:10
tags: [Python]
categories: Backend
toc: true
---
<!-- toc -->
# 前言
![](https://i.imgur.com/sVmDi2B.jpg)
上一篇有提到Decorator初階的概念，這篇再來更深入探討Decorator有哪些做法吧！
<!--more-->
# 範例
先來兩個範例，註解的地方是執行順序
## Function-based
```python=
# Decorator Function Sample
def logged(func):
    print('scope of logged') # 2 進入logged scope
    print("Entering function name is: {}".format(func.__name__)) # 3 
    def with_logging(*args, **kwargs):
        print('scope of with_logging') # 6
        print("Entering function name is: {}".format(func.__name__)) # 7
        print("arg:",*args) # 8
        print("kwarg:",**kwargs) # 9 
        result = func(*args, **kwargs) 
        print("Exited", func.__name__) # 11
        return result
    print('exit') # 4
    return with_logging
 
print('start using decorator') # 1
@logged # 呼叫logged
def test(k):
   print("excute k: {}".format(k)) # 10
   return k
 
print('excute') # 5
print(test(10)) # 12
```
輸出:
![](https://i.imgur.com/1BUNiFd.png)

## Class-based
```python=
# Decorator Class Sample
class decorator(object):
 
    def __init__(self, f):
        print('enter init')
        self.f = f
        print('exit init')

    def __call__(self, *args, **kwargs):
        print("Entering", self.f.__name__)
        r = self.f(*args, **kwargs)
        print("Exited", self.f.__name__)
        return r
 
print('start decorator ')
 
@decorator
def hello(k):
    print('inside hello')
    return("k is: " + k)
 
print('excute')
print(hello('say hello!'))
```
印出結果:
![](https://i.imgur.com/xgIqtVR.png)

執行完上述兩個範例程式碼，大概可以了解使用`Class-based`、`Function-based`兩者使用Decorator的差別以及執行順序。

接著來細分Decorator種類有哪幾種吧！

# Decorator種類
* 不帶參數的function decorator
* 帶有參數的function decorator
* 不帶參數的class decorator
* 帶有參數的class decorator

## 不帶參數的function decorator
```python=
# 不帶參數的 Decorator Function
def decorator(f):
    print("excute  \"{}\"  decorate".format(f.__name__))
    def print_df(*args, **kargs):
        print("print_df before call")
        result = f(*args, **kargs) # 呼叫 hello()，並將回傳值傳遞給result
        print("print_df after call")
        print("印出回傳值: {}".format(result)) 
        return result
    return print_df
 
@decorator
def hello():
    print("say hello.")
    return "hello"

hello()
```
印出結果:
![](https://i.imgur.com/j3FATKl.png)

## 帶有參數的function decorator
```python=
# 帶有參數的 Decorator Function
def parseDecorator(param1, param2):
    print("excute 'parseDecorator'") # 解析parseDecorator內的參數
    def decorator(f):
        print("excute  \"{}\"  decorate".format(f.__name__))
        def print_df(*args, **kargs):
            print("params are: '{}', '{}' ".format(param1, param2))
            print("print_df before call")
            result = f(*args, **kargs) # 呼叫 hello()，並將回傳值傳遞給result
            print("print_df after call")
            print("印出回傳值: {}".format(result)) 
            return result
        return print_df
    return decorator
 
@parseDecorator("param1", "param2")
def hello():
    print("say hello.")
    return "hello"

hello()
```
印出結果:
![](https://i.imgur.com/pUeLuHk.png)

## 比較有無參數的function decorator
藉由上述兩個例子觀察差異，帶有參數的decorator需在decorator外層再包一層function，而最外層稱作`parseDecorator`的function是用來**解析decorator所傳遞的參數**，`parseDecorator`的下一層`decorator(f)`是主要要修飾的函式，跟不帶參數的decorator作用發訪相同。

> ### 簡單來說就是將無參數的function decorator，外面再包一層function，用來傳遞參數。

## 不帶參數的class decorator
```python=
# 沒有參數的 Decorator Class
class decorator():
    def __init__(self, f): # 對參數、函式進行初始化
        self.f = f
    
    def __call__(self, *args, **kargs):
        print("person1 before call")
        result = self.f() # 呼叫 person1()獲得回傳值，並將回傳值assign給result
        print("result: {}".format(result)) # 印出回傳值
        print("person1 after call")
    
@decorator
def person1():
    print("I'm person1")
    return "person1"

person1()
```
輸出結果：
![](https://i.imgur.com/yq7odza.png)


## 帶有參數的class decorator
```python=
# 有參數的 Decorator Class
class decorateFruitClass(object):
    def __init__(self, fruit, amount):
        self.fruit = fruit
        self.amount = amount
 
    def __call__(self, f):
        def buy(*args, **kargs):
            print("%s %s before call" % (self.amount, self.fruit))
            result = f(*args, **kargs)
            print("%s %s after call" % (self.amount, self.fruit))
            return result
        return buy
 
@decorateFruitClass('guava', 10)
def person1():
    print("I'm  person1.")

@decorateFruitClass('banana', 20)
def person2():
    print("I'm  person2.")

person1()
print('-------')
person2()
```
輸出結果：
![](https://i.imgur.com/sdNDPFt.png)

# Decorator 的有序性
如果decorators多層的話，執行的順序可能會和一般的想法不太一樣。
```python=
def walk(func):
    print("walking outside")
    def warp_1():
        print("walking inside")
        print("Now use function '{}'".format(func.__name__))
        func() # call warp_2()
    return warp_1 # call warp_1()


def jump(func):
    print("jumping outside")
    def warp_2():
        print("jumping inside")
        print("Now use function '{}'".format(func.__name__))
        print(func()) # call student()
    return warp_2 #  傳出warp_2給@walk

@walk
@jump
def student():
    print("I'm a student")
    return "student"

student()
```
執行結果
![](https://i.imgur.com/VBVwZW2.png)

上圖的執行順序是，先呼叫`@jump`後傳出新function(傳出`warp_2`)給往上一層的`@walk`，再`walk(func)`中依序執行`warp_1()`，最後呼叫`warp_2()`。

> 遇到多層decorators時，邏輯處理採用 **"遞迴(recursive)"** 的方式，也就是說，原則上會**先合併「最靠近」的decorator**，再傳出新的function給往上面一層的decorator


本篇紀錄Python中不同類型的Decorator，透過實際範例能夠更了解不同類型的Decorator是如何去運行！

# 參閱

* [Python進階技巧 (3) — 神奇又美好的 Decorator](https://medium.com/citycoddee/python%E9%80%B2%E9%9A%8E%E6%8A%80%E5%B7%A7-3-%E7%A5%9E%E5%A5%87%E5%8F%88%E7%BE%8E%E5%A5%BD%E7%9A%84-decorator-%E5%97%B7%E5%97%9A-6559edc87bc0)
* [Python Decorator 四種寫法範例 Code](http://ot-note.logdown.com/posts/67571/-decorator-with-without-arguments-in-function-class-form)
* [[Python] 對Python 裝飾器的理解心得](https://www.cnblogs.com/ifantastic/archive/2012/12/09/2809325.html)
