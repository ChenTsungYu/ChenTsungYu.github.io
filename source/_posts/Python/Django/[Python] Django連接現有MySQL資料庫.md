---
title: "[Python] Django連接現有MySQL資料庫"
catalog: true
date: 2020/2/13 20:23:10
tags: [Python, Django, MySQL, w3HexSchool]
categories: Backend
toc: true
---

>鼠年全馬鐵人挑戰 - WEEK 01

<!-- toc -->
# 前言
Django預設的資料庫使用sqlite3，本篇紀錄如何從預設的sqlite3改完連接MySQL中現有的資料庫，本篇也作為今年參加[鼠年全馬鐵人挑戰](https://www.hexschool.com/2019/11/14/2019-11-14-w3Hexschool-2020-challenge/)的開篇 XD
<!--more--> 
# 安裝
我是在虛擬環境下安裝，使用`pipenv`做套件管理。
## 安裝`pymysql`
```python=
pipenv install pymysql
```
## 安裝`django`
```python=
pipenv install django
```
# 建立專案
## 建立名為mysite的專案名稱
```python=
django-admin startproject mysite
```
## 建立名為exrate的APP
```python=
python manage.py startapp exrate
```
# 相關設定
## 設定`__init__.py`檔
至專案根目錄(mysite)下的`__init__.py`檔，添加下方兩行程式碼:
```python=
import pymysql
pymysql.install_as_MySQLdb()
```
## 設定database
至專案根目錄(mysite)下的`settings.py`檔，替換成下方程式碼:
```python=
DATABASES = {
    'default': {
        # ========= 將預設的sqlite3 ENGINE 還有 NAME 註解掉 =========
        # 'ENGINE': 'django.db.backends.sqlite3',
        # 'NAME': os.path.join(BASE_DIR, 'db.sqlite3'),
        
        # ========= 配置自己的MySQL =========
        'ENGINE': 'django.db.backends.mysql',
        'NAME': 'exrate', # 目標資料庫的名稱
        'USER': 'your account', # 資料庫帳號
        'PASSWORD': 'your password', # 資料庫密碼
        'HOST': 'localhost', # 主機位置，可以先測本地localhost
        'PORT': '8889', # 設定連接埠
    }
}
```
# 連接
## 連接已有的資料庫與Django app
```python=
python manage.py inspectdb
```
## 可能會遇到的問題: 版本問題
執行上個連接步驟的指令時，可能會遇到以下錯誤:
![](https://i.imgur.com/KlqOKAD.png)
## 解決方法
上方圖片中的錯誤訊息有提示問題發生在哪個檔案，打開提示路徑下的目標檔案`base.py`，檔案內尋找`version = Database.version_info`的程式碼，會看到下方程式碼:
```python=
version = Database.version_info
if version < (1, 3, 13):
    raise ImproperlyConfigured('mysqlclient 1.3.13 or newer is required; you have %s.' % Database.__version__)
```
上述程式碼改成
```python=
version = Database.version_info
if version < (1, 3, 13):
    pass
    #raise ImproperlyConfigured('mysqlclient 1.3.13 or newer is required; you have %s.' % Database.__version__)
```
更改後存檔，在執行一次連接MySQL資料庫的指令
```python=
python manage.py inspectdb
```
執行結果
![](https://i.imgur.com/3Lps7zZ.png)
## 引用inspectdb套件建立模型
### 第一種方法
複製執行後所看到的程式碼內容貼到建立的app專案資料夾中的`models.py`

### 第二種方法
將下方指令中的myapp替換成自己建立的app專案名稱並執行
```python=
python manage.py inspectdb > myapp/models.py 
```
## 建立migrations資料表
myapp替換成自己建立的app專案名
```python=
python manage.py makemigrations myapp
```
## migrate同步資料表
myapp替換成自己建立的app專案名
```python=
python manage.py migrate myapp
```


> ##  完成遷移！

# 參考資料
[官方文件-舊有資料庫遷移](https://docs.djangoproject.com/en/3.0/howto/legacy-databases/)