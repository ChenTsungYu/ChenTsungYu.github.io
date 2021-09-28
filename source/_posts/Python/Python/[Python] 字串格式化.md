---
title: "[Python] 字串格式化"
catalog: true
date: 2020/01/13 17:00:00
tags: Python
categories: Backend
toc: true
---
<!-- toc -->
# 前言
進行資料處理時，很多時候都需要對數值進行格式化轉為字串做拼接，或是某段字串與變數做串連。Python的字串格式化用於簡化靜態字串和變數的串接，並格式化變數，當然也可以對數值進行格式化成字串，字串格式化的方式有四種:
* 百分比(`%`)
* str.format  => 作法:`'{}'.format()`
* `f`-string(又作formatted string literals)
* 樣板字串(Template String)

`f`-string是Python3.6之後才有的，實際上對比的話`f`-string是三者中(百分比(`%`)與`'{}'.format()`)效能最好的，同時也提高可讀性，建議實際開發時，直接用`f`-string方法取代前兩者哦！

<!--more-->

# 實作

## 百分比(`%`)
為Python最早格式化字串的方法，透過`%`運算符號，將在tuple中的一組變數依照指定的格式化方式輸出。如格式化: 字串(`%s`)、 十進位整數(`%d`)、浮點數(`%f`)等。

### 範例
```python=
print('%d' % 20) # 格式化整數
print('%f' % 1.11)  # 預設保留6位小數
print('%.1f' % 1.11)  # 取1位小數
print('My name is %s'% 'tom') # 格式化字串

"""
20
1.110000
1.1
My name is tom
"""
```

### 缺點
* 不適合多個變數
* 可讀性低

## `'{}'.format()`
相較於第一個格式化方法，`format()`方法更好用，使用大括號`{}`作為特殊字元，放在目標字串的指定位置，`format()`中則放入要拼接的變數、字串或數值。

### 範例: 不指定順序
若`{}`內不指定索引值的話，預設依序從`0`開始，`()`會依照參數填入的順序
```python=
name = "tom"
age = 20
strr = "my name is {} and my age is {}".format(name, age)
strr
```
![](https://i.imgur.com/4qLNTDC.png)

### 範例: 指定順序
當然他也可以指定放入的位置，只要在`{}`內加入索引值(`index`)即可。
```python=
name = "tom"
age = 20
strr = "my name is {1} and my age is {0}".format(name, age)
strr
```
![](https://i.imgur.com/4v21cZz.png)
執行上面的程式碼即可將`name`、`age`兩個變數的位置對調

> str-formatting 除了可以指定格式化變數名稱及它的位置外，亦可調整輸出樣式，只要加入`^`（置中）、`<`（向左對齊）、`>`（向右對齊）等字元。

### 範例: 對齊
```python=
# ========== 向右對齊 =============
print('{:>10}'.format('test')) 

# ========== 向左對齊 =============
print('{:10}'.format('test'))
# 等同
print('{:<10}'.format('test'))

# ============  置中  ===========
print('{:^10}'.format('test'))
```
![](https://i.imgur.com/hpmZOah.png)


或是以`'{:,}'`的方式以逗號分隔數字
```python=
print('{:,}'.format(243554543))
```
![](https://i.imgur.com/4eeUrcP.png)

除了對齊之外，還可以應用在list串列、dic字典及class物件中

### 範例：格式化list串列
```python=
print('The student is {students[1]}'.format(students=['Tom', 'Jack','Amy'])) # The student is Jack
```

### 範例分開字串
可使用`*`方法分開字串
```python=
print('{} {} {} {} {} {}'.format(*'123456')) # 1 2 3 4 5 6
```

### 範例：格式化dic字典
如果要格式化字典，需要在每個物件前面加上`**`，否則會如同下方範例，報`KeyError`錯誤
```python=
print('My age is {age} and gender is {gender}'.format({'age':20}, {'gender': "female"} )) 
# KeyError: 'age'
```
在每個物件前面加上`**`後即可正常執行。
```python=
print('My age is {age} and gender is {gender}'.format(**{'age':20}, **{'gender': "female"} )) 
# My age is 20 and gender is female
```

### 範例：格式化物件中的屬性 
```python=
class Name:
    def __init__(self, name):
        self.name = name
    def __str__(self):
        return 'Name({self.name})'.format(self=self)
print('My name is {0.name}'.format(Name('Tom'))) # My name is Tom
print(Name('Tom')) # Name(Tom)
```

### 缺點
* 當變數太多時，要撰寫的程式碼就會過長

## `f`-string
Python3.6+方可使用，只需要在字串前面加個`f`即可進行格式化，並將`{}`填入目標變數。
把剛剛的範例改寫成f-string的方式
```python=
# f-string
name = "tom"
age = 20
strr = f"my name is {name} and my age is {age}"
strr
```
![](https://i.imgur.com/vmt29CG.png)
會獲得相同結果！

### 可放表達式與呼叫函數
`{}`可以填入表達式或呼叫函數，Python會回傳求出的結果並填入字串內
```python=
print(f'A total number of {100 * 2 + 20}')

print(f'Complex number {(2 + 2j) / (2 - 3j)}')

print(f'convert STUDENT to lower words are {"STUDENT".lower()}')

import math
print(f'The answer is {math.log(math.pi)}')

score = 90
print(f'My score is {score}, so I am  {"good" if score > 80 else "bad"}.') 

"""
回傳結果:
A total number of 220
Complex number (-0.15384615384615388+0.7692307692307692j)
convert STUDENT to lower words are student
The answer is 1.1447298858494002
My score is 90, so I am  good.
"""
```

### 格式化list串列
```python=
students=['Tom', 'Jack','Amy']
print(f'The student is {students[1]}') 

# The student is Jack
```
### 格式化dic字典
```python=
dic = { 'name': "Tom",
        'age':20,
        'gender': "female"
      }
print(f'My name is {dic["name"]}, age is {dic["age"]} and gender is {dic["gender"]}') 

# My name is Tom, age is 20 and gender is female
```

### 巢狀結構
注意: 巢狀結構只能一層
```python=
print(f"Ans: {12.3456789:10.6}") # Ans:      12.3457
value = 12.3456789
print(f"Ans: {value:10.6}") # Ans:      12.3457
width = 10
precision = 6
print(f"Ans: {value:{width}.{precision}}") # Ans:      12.3457
```

### 單雙引號、大括號(`{}`)與跳脫字元
```python=
pens = 3

print(f'I have {pens} pens.') 

print(f'I\thave \t{pens}\t pens.')  # 引入tab 跳脫字元

print(f'I have {pens} {{pens}}.') # 雙大括號 => 如果需要顯示大括號，則應輸入連續兩個大括號{{和}}

txt = f"""My\tage\tis\t{age}"""
print(txt)

"""
結果
I have 3 pens.
I	have 	3	 pens.
I have 3 {pens}.
My	age	is	20
"""
```

f-string大括號內所用的引號不能和大括號外的引號定義的符號相衝突，可依使用情況切換`''`和`""`。
若大括號內外兩個引號相衝突，會報`SyntaxError`錯誤。
```python=
print(f'I am {'Tom'}') # SyntaxError: invalid syntax

print(f'I am {"Tom"}') # I am Tom
```

若`""`和`''`無法滿足需求，可以使用`''' '''`和`""" """`
```python=
print(f"He said {"I'm Tom"}") # SyntaxError: invalid syntax

print(f'He said {"I'm Tom"}') #SyntaxError: invalid syntax

print(f"""He said {"I'm Tom"}""") # I'm Tom

print(f'''He said {"I'm Tom"}''') # I'm Tom
```

#### backslash斜槓(`\`)的使用
**大括號外**的引號可以使用`\`，但**大括號內不能使用`\`** 
```python=
print(f'''He\'ll say {"I'm Tom"}''') # He'll say I'm Tom
print(f'''He'll say {"I\'m Tom"}''') # SyntaxError: f-string expression part cannot include a backslash
```
如果在大括號內使用`\`，會報`SyntaxError`。

#### 解決方式
先將含`\`的字串assign給一變數，再以變數的形式填入`{}`中。
```python=
name = "I\'m Tom"
print(f'''He'll say {name}''') # He'll say I'm Tom
```
上述例子即是把`"I\'m Tom"`這個含有特殊字元的`\`assign給一變數，透過解析變數的方式來避免`SyntaxError`。


### 用於多行字串
```python=
age = 20
gender = "male"

txt = f"""My age is {age} 
 and My 
 gender is {gender}"""

txt
```
![](https://i.imgur.com/ysBq0Sl.png)

f-string採用`{content:format}`來設定字串格式，`content`是替換並填入字符串的內容，可以是變數、表達式(運算子亦可)或函數，`format`是格式設定。預設格式為`{:format}`。

### 讓跳脫字元失效
若要讓跳脫字元失效，在`f`指令前再加上`r`，表示raw(原始字元)
```python=
name = "Tom"
print(rf'My\tname\tis\tTom\thave\t{name}')
```

### 範例： 分割千分位
```python=
num = 1234567890.0987
print(f'num is {num:f}' )
print(f'num is {num:,f}' )

"""
num is 1234567890.098700
num is 1,234,567,890.098700
"""
```


### lambda
大括號內也可放入lambda匿名函式，但lambda匿名函式的`:`會被f-string誤判，為避免誤判的情況，需將lambda函式包在括號`()`內。

未將lambda函式包在括號`()`內
```python=
print(   f"""even ? answer: { lambda n : "Yes" if n %2 == 0 else "No" (10)}"""   )
# SyntaxError
```
將lambda函式包在括號`()`內
```python=
print(   f"""even ? answer: {(lambda n : "Yes" if n %2 == 0 else "No") (10)}"""   )
"""
even ? answer: Yes
"""
```

## 樣板字串(Template String)
* 需要從 Python 內建模組 string 引入`Template`
* 使用`Template()`包住目標字串，並使用錢`$`符號來標示變數
* 樣板字串預設使用錢`$`符號來標示變數
* 替換資料的格式為**dictionary**
* 最後使用`substitute()`來替換變數

來看段範例，改寫自[官方文件](https://docs.python.org/3/library/string.html#template-strings)
```python=
from string import Template
s = Template('$who likes $what')
s.substitute(who='Tom', what='Python')
```
![](https://i.imgur.com/ngHCMzQ.png)

或是
```python=
temp_str = '$who likes $what'
new = Template(temp_str)
dic = {'who': 'Tom', 'what': 'Python'}
new.substitute(dic)
```
![](https://i.imgur.com/QDPLlwo.png)
兩個範例可得相同結果

## 改變預設定義變數的`$`符號
通過class繼承的方法重寫定義變數的符號
```python=
from string import Template
class MyTemplate(Template):
    delimiter = '%'  
s = MyTemplate('%who knows?')
s.substitute(who='Tom')
# 'Tom knows?'
```

## 惡意腳本注入
雖然前面提到的str.format方法方便，但是很有可能在面對處理使用者輸入的值時，遭到惡意字元的注入，來看個範例:
```python=
"""
source: 
https://realpython.com/python-string-formatting/#4-template-strings-standard-library
"""
# 金鑰、密碼、token等等
SECRET = 'this-is-a-secret'

class Error:
    def __init__(self):
        pass

# A malicious user can craft a format string that
# can read data from the global namespace:
### 使用者輸入惡意字元
user_input = '{error.__init__.__globals__[SECRET]}'

# This allows them to exfiltrate sensitive information,
# like the secret key:
err = Error()
user_input.format(error=err)
```
![](https://i.imgur.com/Y61exkz.png)
上方範例中，使用者輸入惡意字元:`'{error.__init__.__globals__[SECRET]}'`，經格式化處理後，會發生金鑰或token等機密性資料洩漏的問題。

### 解決方法
那如果改成**Template String**的話呢？
```python=
# solution
SECRET = 'this-is-a-secret'

class Error:
    def __init__(self):
        pass
user_input = '${error.__init__.__globals__[SECRET]}'
Template(user_input).substitute(error=err) 

# ValueError: Invalid placeholder in string
```
執行上述範例會得到一個`ValueError`的錯誤結果，較能有效防止洩漏機密資訊。

## 使用時機
綜合以上的方法，可依照不同時機點，建議使用不同格式化字串的方式，下面簡單做個整理：
* 面對User輸入的字元，使用**Template String**，避免惡意腳本注入
* 非User輸入的字元，如果使用Python3.6以下的版本，採用**str.format**
* 非User輸入的字元且使用Python3.6以上的版本，推薦使用`f`-string方法

![](https://i.imgur.com/m59AoEC.png)
[Source](https://realpython.com/python-string-formatting/#4-template-strings-standard-library)

以上為格式化字串的總整理，如果有寫不清楚或是錯誤之處，請留言跟我說！


# 參閱
* [PyFormat: Using % and .format() for great good!](https://pyformat.info/)
* [PEP 498 -- Literal String Interpolation](https://www.python.org/dev/peps/pep-0498/)
* [Python 字串格式化（套用變數）
](http://cw1057.blogspot.com/2017/05/python_25.html)
* [Python格式化字符串f-string概覽](https://blog.csdn.net/sunxb10/article/details/81036693)

