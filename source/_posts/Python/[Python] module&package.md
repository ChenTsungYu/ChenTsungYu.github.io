---
title: "[Python] Module&Package"
catalog: true
date: 2019/08/05 20:23:10
tags: Python
categories: Backend
---
<!-- toc -->
# 前言
任何一個python程式都可以作為python的模組(**模組是一個.py的檔案**)，裡面有許多定義的變數和函式供其他程式使用，模組設計目的是由其他程式引入並使用，將功能模組化帶來的好處是模組化的程式可以在不同程式引入，減少重複寫相同功能的情況。同時，如果有別人別人寫好實用的模組，可以透過引入的方式，直接拿來使用。
<!--more--> 
# 引入
## `import`方法
Python引入模組的方法(`import`)有四種:
```python=
# 單純引入
import module
# 將引入的模組進行重新命名，將name替換自訂的模組名稱 -> 常用於模組名稱太長的情形
import module as name
# 引入模組內特定的函式或變數 
from module import variable/function
# 引入模組內所以有的函式或變數
from module import *
```
* 單純引入模組的情況下，若要呼叫該模組內特定的函式或變數，需要`module.function`或 `module.variable` 來呼叫目標函式或是變數。
* `from module import variable/function`使用時機在於，有些module相當龐大，若每次都要將整個module的內容引入，會有效能問題。

# 自訂一個模組
假設自訂一個名為`mod.py`的模組，要讓`main.py`引入使用，將兩個檔案的程式碼**放在同一個目錄下**執行。
```python=
""""
mod.py
被導出的模組
"""
var = "This is variable"

def sayHello():
    return "This is mod.py"

def sayGoodBy():
    return "Bye!"
```

```python=
####  main.py

import mod # 需要與mod.py同一目錄下
print(mod.sayHello()) # 呼叫 sayHello函式 -> This is mod.py
print(mod.var) # 呼叫var變數 -> This is variable
```

# 模組的路徑
實際情況是，不可能總是把所有的程式碼放在同一個路徑或是資料夾。為了要讓這一份程式碼能在同一個環境底下任何時候都能使用，需要將檔案設定在Python環境的路徑。那Python 如何知道在哪裡搜尋模組的路徑呢？
這時可以使用`sys`模組幫助我們尋找模組路徑。
```python=
import sys
print(sys.path)
# 結果
"""
['/Users/tsungyuchen/Desktop/python_practice', 
'/Library/Frameworks/Python.framework/Versions/3.7/lib/python3.7', 
'/Users/tsungyuchen/Library/Python/3.7/lib/python/site-packages'
]
"""
```
印出結果為Python尋找模組的路徑，我們可以看到`Python/3.7/lib/python/site-packages`的路徑，將`mod.py`將入此資料夾後，電腦上其他位置的專案就可以直接引入此模組。
## 路徑配置
有時`import`模組會出現`ImportError`的錯誤訊息，大多數的情況都是路徑的問題，為了解決上述問題，需要新增模組搜尋路徑，可以使用以下幾種方式：
### 增加路徑
通過`sys`模組的`append()`方法在Python環境中增加搜尋路徑，語法結構為:
```python=
sys.path.append('新增的搜尋路徑')
```

### 修改環境變數
修改`PYTHONPATH`變數。
* 打開vim
```bash=
vim ~/.bashrc
```
* 設置路徑並添加以下內容：
```bash=
export PYTHONPATH=$PYTHONPATH:你要的路徑
```

* 退出後保存(相關指令說明[點我](https://blog.csdn.net/luo200618/article/details/52510781))，再重新啟動。
```bash=
source ~/.bashrc
```

# Package
有時會需要將功能類似的module進行整合，會需要將這些模組放在同個package下。
package可簡單看作一個資料夾，若要讓電腦辨認這是一個可被引入的package，該package下必須要放一個`__init__.py` 檔案。
此檔案可以為空，或是寫入任何該package或該package內module被引入時要執行的程式碼。
## 引用方法
```python=
import package

import package.module

from package import module1, module2...
```
### 範例
假設有一個名為**pkg**的資料夾(視為一個package)，底下有`mod1.py`、`mod2.py`、`mod3.py`三個模組，透過`main.py`檔進行呼叫。
![](https://i.imgur.com/LUs0ot1.png)

在`__init__.py`為空的情況下寫以下範例:
```python=
# mod1.py
var1 = "This is variable1"

def sayHello():
    return "This is mod1.py"

def sayGoodBy():
    return "Bye!"

# mod2.py
var2 = "This is variable2"

def sayHello():
    return "This is mod2.py"

def sayGoodBy():
    return "Bye!"
```
分別引入`mod1.py`、`mod2.py`
```python=
# main.py
from pkg import mod1, mod2

print(mod1.sayHello())
print(mod2.sayHello())

"""
This is mod1.py
This is mod2.py
"""
```

### `__init__.py` 配置
在`__init__.py`加入該package下不同的模組所呼叫的函式或變數。
`__init__.py`配置個模組下呼叫的函數
```python=
# __init__.py
from .mod1 import sayHello
from .mod2 import sayHello
```

```python=
# main.py
import pkg 

print(dir(pkg)) # 檢視一個模組中含有的內容（attribute）
print(pkg.mod1.sayHello())
print(pkg.mod2.sayHello())
```
![](https://i.imgur.com/yYaiqax.png)

## 檢視模組、package中的內容(attribute)
```python=
print(dir(pkg))
print("=============")
print(dir(pkg.mod1))
"""
['__builtins__', '__cached__', '__doc__', '__file__', '__loader__', '__name__', '__package__', '__path__', '__spec__', 'mod1', 'mod2', 'sayHello']
=============
['__builtins__', '__cached__', '__doc__', '__file__', '__loader__', '__name__', '__package__', '__spec__', 'sayGoodBy', 'sayHello', 'var1']
"""
```
上述範例可以看到該package及模組中的內容。
* `__builtins__`表內建模組，不需要手動匯入，所以在啟動Python時系統就會自動匯入了，任何程式都能直接使用它們。
* `__doc__`: 查看對於該模組的文件說明。
* `__file__`: 查看模組所在路徑
* `__package__`：該package的名稱
* `__name__`：該package的名稱



# 常用模組
## `os`模組
包含了常用的作業系統功能，提供系統操作的方法。
```python=
import os

#取得系統平台資訊
os.name
#獲取當前工作目錄
os.getcwd()
# 取得指定目錄中所有的檔案與子目錄名稱
os.listdir(path)
# 判斷該項目是否為普通檔案
os.path.isfile
# 判斷該項目是否為目錄
os.path.isdir
# 列出指定的路徑下所有子目錄與檔案資訊
os.walk
#改變目前路徑
os.chdir(path)
#建立新目錄
os.makedir(path)
#刪除空目錄
os.removedirs(path)
#刪除文件
os.remove("文件名")
#執行Shell指令
os.system("命令")
#得到當前文件的絕對路徑
os.path.abspath()
#輸入一個全路徑名。得到當前文件的路徑
os.path.dirname("pathName")
#輸入一個全路徑名。得到文件名
os.path.basename("fullPathName")
#判斷路徑是否存在
os.path.exists("fullPathName")
#路徑拼接
os.path.join("pathName1","pathName2")
```
### 範例: 取得檔案列表
利用`os.listdir(path)`取得檔案列表
```python=
from os import listdir
from os.path import isfile, isdir, join, dirname
mypath = "django"
# 取得所有檔案與子目錄名稱
files = listdir(mypath)

# 以迴圈處理
for f in files:
  # 產生檔案的絕對路徑
  fullpath = join(mypath, f)
  # 判斷 fullpath 是檔案還是目錄
  if isfile(fullpath):
    print("檔案：", f)
  elif isdir(fullpath):
    print("目錄：", f)
    
"""
檔案： .DS_Store
目錄： stocks
檔案： Pipfile
檔案： Pipfile.lock
"""
```

### 範例: 拼接文件的絕對路徑
列出指定的路徑下所有子目錄與檔案資訊。
`os.walk` 將每一個目錄中的檔案都列出來，並且自動區分檔案與目錄。
```python=
from os import walk
from os.path import join
for root, dirs, files in walk(mypath):
  print("路徑：", root)
  print("目錄：", dirs)
  print("檔案：", files)
```
輸出結果

![](https://i.imgur.com/Q7pmYIc.png)

實際拼接
```python=
from os import walk
from os.path import join
mypath = "django"
# 取得所有檔案與子目錄名稱
for root, dirs, files in walk(mypath):
  for f in files:
    fullpath = join(root, f)
    print(fullpath)
```
印出所有檔案的絕對路徑
![](https://i.imgur.com/m015fAT.png)

## `sys`模組
```python=
import sys

sys.argv  # 回傳執行文件時的參數列表
sys.exit([arg])  # 退出當前程式
sys.modules  # sys.modules查詢當前系統模組包含的變數或類的路徑
sys.path  # sys.path查詢當前模組所處路徑
sys.platform  # sys.platform查詢當前直譯器執行的平臺
sys.stdin, stdout, stderr  # 常見輸入輸出
```

# 參考
[Day17-模組](https://ithelp.ithome.com.tw/articles/10207161)

[Day18-標準函式庫](https://ithelp.ithome.com.tw/articles/10207451)

[Python進階篇二：Python模組](https://codertw.com/%E7%A8%8B%E5%BC%8F%E8%AA%9E%E8%A8%80/9218/#outline__3)

[Python 列出目錄中所有檔案教學：os.listdir 與 os.walk](https://blog.gtwang.org/programming/python-list-all-files-in-directory/)

[Python 初學第十三講—模組](https://medium.com/ccclub/ccclub-python-for-beginners-tutorial-bfb6dfa69d52)

