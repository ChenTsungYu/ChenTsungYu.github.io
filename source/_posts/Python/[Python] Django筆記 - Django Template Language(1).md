---
title: "[Python] Django筆記 - Django Template Language(1)"
catalog: true
date: 2020/02/20 20:23:10
tags: [Python, Django, w3HexSchool]
categories: Backend
---

> 鼠年全馬鐵人挑戰 - WEEK 02

<!-- toc -->
# 前言
Django提供獨特的模板語法，將HTML頁面做動態載入。因為在HTML檔，無法使用python來撰寫程式，Django的模板引擎讓撰寫好的python程式碼可以建構在網頁上面。簡單來說，透過模板語法，我們可以在HTML檔寫入python的程式碼，讓網頁變成動態載入的狀態。
<!--more-->

# Template相關設定(Configuration)
至專案根目錄下找到`settings.py`檔案，搜尋`TEMPLATES`，便能夠看到以下設定：
![](https://i.imgur.com/R3d7WNk.png)

>Django 預設去找 `TEMPLATES` 的設定
`DIRS`: 為Django額外搜尋`TEMPLATES`的目錄，如果要另外設定的話，在這個地方填寫自訂的路徑

一般情況下，會習慣在每個新增**apps** 專案目錄下創建該**apps**的專屬`templates`資料夾，因為Django預設會去找名為**templates**資料夾下的檔案。

## 實作
### 註冊APP
先建立Django application(app)，例如建立名為food的app，並在`settings.py`檔案下找到`INSTALLED_APPS`，在末端加入`'food'`。
![](https://i.imgur.com/O48nqBc.png)
### 指定專案路徑
再到`urls.py`，設定`path('food/', include("food.urls") ),`，指定food專案的根路徑。
![](https://i.imgur.com/Qnx3afA.png)
### 建立模板
在food資料夾下另外設立一個**template**目錄，新增`index.html`(我有多一層food資料夾做區分)
`index.html`
```html=
<!DOCTYPE html>  
<html lang="en">  
    <head>  
        <meta charset="UTF-8">  
        <title>Index</title>  
    </head>  
    <body>  
        <h2>Welcome to Django!!!</h2>  
    </body>  
</html>  
```
### 載入模板並進行渲染(`render`)
app專案下的`views.py`寫入下方程式碼
```python=
from django.shortcuts import render
from django.http import HttpResponse
from django.template import loader 
def index(request):
    template = loader.get_template('food/index.html') # getting our template  
    return HttpResponse(template.render())       # rendering the template in HttpResponse  
```
### 查看頁面
開啟伺服器，執行`python3 manage.py runserver`，原始網頁路徑加上`/food`即可看到渲染出來的`index.html`畫面
![](https://i.imgur.com/vPv3kHM.png)

# 各式語法
## 變數(Variables)
兩個花括弧`{ {} }`裡面放入傳遞過去的變數。
### 範例
傳遞`Hello index!`訊息，並assign給變數名`txt`，將此變數傳遞到`index.html`檔進行渲染。
`views.py`
```python=
from django.shortcuts import render
def index(request):
    txt = "Hello index!"
    return render(request, 'food/index.html', {"txt": txt} )
```

在`index.html`檔中加入`<h3>  { {txt} } </h3>`，變數的值就會被模板語法渲染上去了！
```html=
<!DOCTYPE html>  
<html lang="en">  
    <head>  
        <meta charset="UTF-8">  
        <title>Index</title>  
    </head>  
    <body>  
        <h2>Welcome to Django!!!</h2>  
        <h3>  { {txt} } </h3>
    </body>  
</html> 
```
![](https://i.imgur.com/8f0Zd5c.png)

## 標籤(Tags)
Django提供填入標籤的模板語法: `{ % tag % }`，藉由`{ % tag % }`可以寫入更複雜的邏輯，如:`if-else`、`for`等等。
### 條件判斷
```python=
{ % if athlete_list % }
    Number of athletes: { { athlete_list|length } }
{ % elif athlete_in_locker_room_list % }
    Athletes should be out of the locker room soon!
{ % else % }
    No athletes.
{ % endif % }
```
### 迴圈
```python=
<ul>
{ % for athlete in athlete_list % }
    <li>{ { athlete.name } }</li>
{ % endfor % }
</ul>
```

## 繼承
Django提供繼承的模板語法，讓開發者可以做到重複利用、彈性更動。
### 區塊標籤(block tags)
定義一個區間，讓繼承者做更動 => 彈性更動
```python=
{ % block name % } .... { % endblock  % }
```
### 展延標籤(extends tags)
很多時候一個網站某部分的頁面會重複，為了避免一直寫重複的代碼，可以使用**extends tags**。 => 重複利用
```python=
{ % extends "xxx.html" % }
```
實際應用時，通常會針對網頁重複的部分獨立出一個HTML檔。
### 實作
建立一個`base.html`的HTML，網頁內容重複的部分都寫在這個檔，例如:網站的導覽條
![](https://i.imgur.com/u8PafO2.png)

`base.html`
```html=
<!doctype html>
<html lang="en">
  <head>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
    <title>Index</title>
  </head>
  <body>
        <nav class="navbar navbar-dark bg-dark">
             <a href="#" class="navbar-brand"> FoodApp</a>
             <div class="navbar">
                    <a href="#" class="nav-item nav-link"> Add Item</a>
                    <a href="#" class="nav-item nav-link" > Delete Item</a>
                    <a href="#" class="nav-item nav-link"> Menu Item</a>
             </div>
        </nav>
    { % block body % }
        { % comment % } 
         此處為彈性更動之處
        { % endcomment % }
    { % endblock  % }
    <!-- Optional JavaScript -->
    <!-- jQuery first, then Popper.js, then Bootstrap JS -->
    <script src="https://code.jquery.com/jquery-3.4.1.slim.min.js" integrity="sha384-J6qa4849blE2+poT4WnyKhv5vZF5SrPo0iEjwBvKU7imGFAV0wwj1yYfoRSJoZ+n" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js" integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous"></script>
  </body>
</html>
```
`{ % block body % }{ % endblock % }`內就是之後被引入其他檔案中，會變動的內容。
再來看`index.html`檔
```html=
{ % extends 'food/base.html' % }
<!doctype html>
<html lang="en">
  <head>
    <!-- Required meta tags -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css" integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh" crossorigin="anonymous">
    <title>Index</title>
  </head>
  <body>
  { % block body % }

        { % for item in item_list % }
              <div class="row">
                   <div class="col-md-3 offset-md-2">
                          <img class="card" height="150px" src="{ { item.item_iamge } }">
                  </div>
                  <div class="col-md-4">
                        <h3>{ { item.item_name } }</h3>
                        <h4>{ { item.item_desc } }</h4>
                        <h5>${ { item.item_price } }</h5>
                  </div>
                  <div class="col-md-2">
                      <a href="{ % url 'food:detail' item.id% }" class="btn btn-success">Details</a>
                  </div>
             </div>

        { % endfor % }
        
    { % endblock  % }
    <!-- Optional JavaScript -->
    <!-- jQuery first, then Popper.js, then Bootstrap JS -->
    <script src="https://code.jquery.com/jquery-3.4.1.slim.min.js" integrity="sha384-J6qa4849blE2+poT4WnyKhv5vZF5SrPo0iEjwBvKU7imGFAV0wwj1yYfoRSJoZ+n" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js" integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo" crossorigin="anonymous"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js" integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6" crossorigin="anonymous"></script>
  </body>
</html>
```
上面`index.html`檔案內的`{ % extends 'food/base.html' % }`作為繼承`base.html`的結構，並在`{ % block body % }... { % endblock  % }`內寫上要變動的內容
#### 結果
![](https://i.imgur.com/nBZ3Zmh.png)

### 跨站請求偽造的防護
```python=
{ % csrf_token % }  
```
# 參閱
* [Official Doc](https://docs.djangoproject.com/en/3.0/ref/templates/language/#templates)
* [Django 命名空間(NameSpace)](https://ithelp.ithome.com.tw/articles/10204346)
* [Django Tutorial- Template](https://www.javatpoint.com/django-template)
* [Day14 : Template 的運作](https://ithelp.ithome.com.tw/articles/10201397)