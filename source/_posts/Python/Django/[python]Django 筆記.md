---
title: "[Python] Django 筆記"
catalog: true
date: 2020/01/11 20:23:10
tags: [Python, Django]
categories: Backend
toc: true
---
![](https://miro.medium.com/max/1000/1*AbJ5qeiBxQ8qzVKzh3OJ2Q.jpeg)
<!-- toc -->
# 什麼是 Django?
一個基於python建立的Ｗeb框架(Framework)，幫你把大部分的程式架構都建構好，開發者可基於這個骨幹結構做開發應用，加強程式開發速度、重用性和程式的可讀性。相較於傳統的MVC(Model-View-Contorller)架構，Django也有屬於它的MTV(Model-Template-Views)架構。
<!--more--> 
# Django的運作的架構及流程
## 架構
Django架構主要分為下面四個部分
* Django本體：主要提供路由的功能
* Model: 與資料溝通
* View: 處理請求，進行資料計算，並決定顯示template資料內容
* Template: 資料呈現，主要檔案是放靜態頁面，通常是html文件
* Cache: 保存擷取過的網頁資料，加速瀏覽速度


MTV與一般看到的MVC架構稍微不同的點在於Template主要放純靜態網頁的資料。

## 流程
接著來看Django的運作流程
![](https://i.imgur.com/T9XBtAP.png)
假設有用戶要訪問Django架設的頁面，會在瀏覽器上輸入網址，瀏覽器在得到網址之後，會經過路由，如果路由發現這個網頁的內容使用者已經有，快取(Cache)模組就會返還之前擷取過的資料，加速瀏覽速度;若沒有，則會去找Template要網頁資料，Template回傳基本的html網頁之後，Template顯示的內容一部分的資料需透過View去決定，有些內容可能需要從資料撈取的話，會透過Model向資料庫溝通。

# Hands on Lab
## 使用Pipenv在虛擬環境中安裝django
```bash=
pipenv install django
```

## 建立Django專案
專案名稱為stocks
```bash=
django-admin.py startproject stocks
```

資料夾結構
![](https://i.imgur.com/dwWdpLd.png)

## Django的Management commands
`manage.py` 為Django提供的命令列工具，提供許多不同功能的指令。
### 啟動Django伺服器
切換stocks資料夾下
```python=
python manage.py runserver
```
![](https://i.imgur.com/33Oq8En.png)
打開瀏覽器輸入 `http://127.0.0.1:8000/` 或是 `http://localhost:8000/`，會看到django專案已成功在 web server 上執行。

![](https://i.imgur.com/n86jCmP.png)
若想了解有哪些指令可用，輸入 `help`或`-h`指令會列出所有指令列表:
```python=
python manage.py -h
```
上圖可以看到紅色錯誤訊息，我們需要對資料庫做同步。
```python=
python manage.py migrate
```
指令會根據你對 Model 的修改刪除建立一個新的 migration 檔案，讓 migrate 指令執行時，可以照著這份紀錄更新資料庫。[Model說明文件](https://docs.djangoproject.com/en/3.0/topics/migrations/)

![](https://i.imgur.com/wpydeQw.png)

## Admin
大部份網站都設計有管理後台，讓管理者方便新增或異動網站內容。
而這樣的管理後台，Django 也有內建一個 App -- Django Admin 。只需要稍微設定，網站就能擁有管理後台功能。

建立一個管理員帳號(superuser)
```python=
python manage.py createsuperuser
```
接著將帳號密碼等設定完成後重啟一次Django，輸入剛設定的管理員(superuser)即可登入

![](https://i.imgur.com/ZeYp1Rh.png)

## 建立 Django application（app）
每一個 Django project 裡面可以有多個 Django apps。實作時，通常會依功能分成不同 app，方便管理及重複使用。
以quotes為app的名稱為例:
```python=
python manage.py startapp quotes
```
此時的檔案目錄結構多一個quotes專案(app)資料夾
![](https://i.imgur.com/bEGYDgi.png)

但若要讓 Django 知道要管理哪些 apps，還需再調整設定檔。
作法： **打開 `stocks/settings.py`，找到 INSTALLED_APPS**
![](https://i.imgur.com/tqVgRTj.png)


注意 app 之間有時候需要特定先後順序，盡量將自訂的apps加在最後面


在quotes專案資料夾下創建一個名為url.py的檔案。

假如一個project中有多個app，用以上的方式來管理url可能會造成比較混亂的局面，為了解決這個問題，我們可以用include的方法來配置url
```python=
from django.contrib import admin
from django.urls import path , include # 配置url

urlpatterns = [
    path('admin/', admin.site.urls),
    path('', include("quotes.urls") ),
]
```

## Django 的 MTV 架構處理 request 的流程:
1. 瀏覽器送出 HTTP request
2. Django依URL配置分配至對應的View
3. View進行資料庫的操作或其他運算，並回傳HttpResponse物件
4. 瀏覽器依據 HTTP response 顯示網頁畫面

## Django的MTV架構

## View
用 render 這個 function 產生要回傳的 HttpResponse 物件
建立一個function用於處理 HttpRequest 物件，並回傳 HttpResponse 物件，下圖範例是在quotes資料夾下的`views.py`檔
![](https://i.imgur.com/vvh5BCu.png)
從網頁接收到 request 後，會將 request 中的資訊封裝產生一個 HttpRequest 物件，並當成第一個參數，傳入對應的 view function。[HttpResponse 物件官方說明](https://docs.djangoproject.com/en/3.0/ref/request-response/)

上面可以看到當`about(requset)`被呼叫時，回傳一個名為about.html的網頁名稱。
## URL 設定
在quotes資料夾下建立一個新資料夾做templates，templates資料夾下新增`about.html`檔，現在要對**about**這個網頁做路徑對應的配置，通常會定義在`urls.py`檔，所以在quotes資料夾下創建`urls.py`，建立URL 與 view 的對應關係，稱作**URL conf (URL configuration)**
範例:
```python=
from django.urls import path
from . import views
urlpatterns = [
    # 設置路徑、接收view回傳的頁面
    path('about.html', views.about, name= "about"),
]
```
從`views.py`將定義好的function 做import。

再到stocks資料夾下的`urls.py`做配置，先`import include`，加入`quotes.urls`，連結quotes的url配置，方便進行管理。
![](https://i.imgur.com/E4a5QA9.png)


## Template
Template可以幫助我們將前端頁面存放的一個獨立資料夾，一來不會全部丟在view內，二來如果未來也比較好與做前端頁面的人合作，對方只需要將寫好的頁面放置在template下即可。
![](https://i.imgur.com/NhmmNpY.png)
打開資料夾`settings.py`，搜尋`TEMPLATES`，便能夠看到以上設定。
Django 預設會去找 TEMPLATES 的設定，`DIRS`是讓Django額外搜尋TEMPLATES的目錄
![](https://i.imgur.com/j4ics73.png)
`settings.py`內搜尋`BASE_DIR`，透過`BASE_DIR`設定，可以了解預設的專案的路徑。

## Model
Django預設使用後端的資料庫系統為SQLite，可以在`settings.py`檔案下搜尋`DATABASES`，Django已先做好設置。
![](https://i.imgur.com/cPbAOZp.png)
### 說明:
* ENGINE -- 要使用的資料庫引擎。例如：
  MySQL: django.db.backends.mysql
  SQLite3: django.db.backends.sqlite3
  PostgreSQL: django.db.backends.postgresql_psycopg2
* NAME -- 資料庫名稱
若使用**MySQL**或**PostgreSQL**等其他資料庫，還需另外設定它的位置、名稱、使用者。
### Model的幾個重點:
* 負責資料層、操作Database 
* 基於[ORM](https://ithelp.ithome.com.tw/articles/10207752)，且用Class 定義資料格式，建立資料欄位。
* Model Fields 可為 Django Model 定義不同型態資料屬性，紀錄幾個比較常用的:
  CharField — 字串欄位，適合像 title、location 這種有長度限制的字串。
  TextField — 合放大量文字的欄位
  URLField — URL 設計的欄位
  DateTimeField — 日期與時間的欄位，使用時會轉成Python datetime 型別。
  

### 步驟
* 到model.py檔內建立名為Stock的物件，Django會依據這個建立資料表，以及資料表裡的欄位設定。
```python=
class Stock(models.Model):
    # CharField: 定義資料格式為字串 
    ticker = models.CharField(max_length=10) 
    def __str__(self):
        return self.ticker
```
* 接著執行`python manage.py makemigrations`，makemigrations會告訴 Django，Model有所變動，這會建立一個遷移（migration）檔案。
* 對Model進行註冊，需要在讓Django知道，有哪些Model需要管理後台。
![](https://i.imgur.com/VhhHvaa.png)
### 資料庫同步，完成遷移。
```bash=
python manage.py migrate
```
執行上述指令即可完成遷移。



# 參考教學:
[來源1](https://medium.com/@leealice033/%E6%8A%80%E8%A1%93%E7%AD%86%E8%A8%98-django-%E4%B8%89-b7a289a52f38)
[來源2](https://djangogirlstaipei.gitbooks.io/django-girls-taipei-tutorial/)
[來源3](https://blog.kdchang.cc/2016/06/11/python-django-starter-kit/)
