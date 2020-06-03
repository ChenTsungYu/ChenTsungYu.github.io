---
title: "[AWS] 用AWS Elastic Beanstalk 部署你的第一個Django應用"
catalog: true
date: 2020/03/15 17:00:10
tags: [AWS, Python, w3HexSchool]
categories: [Cloud]
---
<!-- toc -->

> 鼠年全馬鐵人挑戰 - WEEK 05


# 前言
本篇著重在如何使用AWS Elastic Beanstalk佈建你的Django專案，相較於EC2，Elastic Beanstalk讓開發者更能專注在撰寫程式上，不需花費額外時間建置環境。

# 前置作業
* AWS Free Tier(一年期的免費帳號)
* Python 3.6
* pip
* virtualenv
* awsebcli

<!--More-->
# Hands On Lab
## 本地建置Django專案
### 建立名為`eb_django`的專案資料夾
```bash=
mkdir eb_django

cd eb_django
```
在該資料夾下建立虛擬環境，`eb-virt`可替換成自己要的名稱。
```bash=
virtualenv eb-virt
```
開啟虛擬環境
```bash=
source eb-virt/bin/activate
```
### 下載並建立django專案
```bash=
pip install django==2.1.1
```
這邊值得注意的是，AWS官方文件有提到版本相容的問題:
>For Django version compatibility with Python, see What Python version can I use with Django? Django 2.2 is incompatible with the Elastic Beanstalk Python 3.6 platform. The latest compatible version is Django 2.1.

因為平台上的Python3.6以上版本與Django2.2不相容，所以Djanogo版本要指定在2.1.1(現在Django官方都已經出到3.0了...)

建立django專案
```bash=
django-admin startproject ebdjango
```
現在的專案案目錄結構會是
```
eb_django/
  | - eb-virt
  |     | -- bin
  |     | -- include
  |     | -- lib
  | - ebdjango
          |-- ebdjango
          |   |-- __init__.py
          |   |-- settings.py
          |   |-- urls.py
          |   `-- wsgi.py
          `-- manage.py
```
執行Django專案
```python=
cd ebdjango

python manage.py runserver
```
運行後會看到`Starting development server at http://127.0.0.1:8000/`的訊息，訪問`http://127.0.0.1:8000/`網頁後就會看到django預設畫面
![](https://i.imgur.com/MDUTn3f.png)
### 保存相依套件
保存相依套件的資訊在`requirements.txt`，之後Elastic Beanstalk會依照`requirements.txt`這個檔案內容來判斷執行您應用程式的EC2 Instance應該需安裝哪些套件。
```bash=
pip freeze > requirements.txt
```
查看內容
```bash=
cat requirements.txt
```
![](https://i.imgur.com/X8JDZfY.png)

### 配置.ebextensions 目錄
建立 .ebextensions 的目錄
```bash=
mkdir .ebextensions
```
確認專案目錄結構
```bash=
ls -a
```
![](https://i.imgur.com/nDJ1YGy.png)
開啟目錄
```bash=
open .ebextensions/
```
在`.ebextensions`目錄下
建立配置的檔案`django.config`
```bash=
touch django.config
```
寫入下方指令
```bash=
option_settings:
  aws:elasticbeanstalk:container:python:
    WSGIPath: ebdjango/wsgi.py
```
> WSGIPath 設定會指定 Elastic Beanstalk 用於啟動應用程式的 WSGI 指令位置。

離開虛擬環境
```bash=
deactivate
```

>以資訊安全來說，這邊我會比較建議用IAM建立一個User來進行服務的建置，盡量不使用Root Account直接使用CLI操作服務，使用IAM建立User，並給予User相對應的使用權限與特定的AWS服務，如果加上MFA的多重認證機制，安全性會更高，不過本篇只先做到用IAM建立一個擁有特定服務的User。
## IAM
IAM是AWS提供權限控管的一項服務，你可以透過IAM來創建User，指派特定權限或服務資源給該名User。
當然，他也可以以群組的方式做集體的權限管理，不過不在本篇討論範圍，只需要知道它可以幫助我們做權限管理。

### 建立User
先登入註冊好的AWS免費帳號，點擊右上角的個人帳號，會出現下拉選單，選擇**My Security Credential**，
![](https://i.imgur.com/3FET47h.png)

進入頁面後點選左方選單的**Users**，右方的畫面有個**Add User**按鈕
![](https://i.imgur.com/HEf1JFp.png)
進入**Add User**畫面
![](https://i.imgur.com/xC4ByxM.png)
這個頁面主要是設定User名稱、AWS的操作方式，本篇是兩個都選，而**AWS Management Console access**，方便我們之後可以從AWS的管理介面查看專案情況，你可以自訂密碼，或是自動產生。

### 配置User權限
![](https://i.imgur.com/3l6ZnM3.png)
Elastic Beanstalk會使用到EC2、S3等服務，所以我們也要同時給予這些服務的權限政策給建立的User，分別在搜尋欄找`AWSElasticBeanstalkFullAccess`、`AmazonEC2FullAccess`、`AmazonS3FullAccess`三項服務的所有權限。後續得**Add tags**可忽略。

### Review
![](https://i.imgur.com/o6quj45.png)
確認上述勾選的權限都被列在上面後就可以建User囉
![](https://i.imgur.com/pib1dZO.png)
記得將Key保留在本地哦！
另外，下載完的`.csv`裡有附IAM帳號登入的連結，點擊後輸入剛剛自訂的密碼即可以IAM的形式進行登入，登入時會再要求你更改一組新密碼。

## ebcli
接下來我們要透過Elastic Beanstalk提供的CLI來建置環境

### 確認專案目錄的結構
```bash=
~/ebdjango/
|-- .ebextensions
|   `-- django.config
|-- ebdjango
|   |-- __init__.py
|   |-- settings.py
|   |-- urls.py
|   `-- wsgi.py
|-- db.sqlite3
|-- manage.py
`-- requirements.txt
```
### 下載ebcli
```bash=
pip install awsebcli
```

### AWS ebcli登入
```bash=
aws configure
```
執行上方指令後會要求輸入`AWS Access Key ID`和`AWS Secret Access Key`，將剛才載下來的檔案，裡面有這兩者的資訊，確定一下兩者是否正確輸入！
![](https://i.imgur.com/4JmhaXb.png)

### 初始化EB CLI 儲存庫
透過下方指令初始化EB CLI儲存庫。
```bash=
eb init -p python-3.6 django-project
```
終端機會提示`Application django-project has been created.`建立成功的訊息，接著查看當前檔案結構變化
![](https://i.imgur.com/2pO3ozs.png)

### 建立部署環境
```bash=
eb create django-env
```
### 查看部署環境
```bash=
eb status
```
![](https://i.imgur.com/n6XwQEs.png)
複製`CNAME`的訊息，它代表你的網域位置。

### 配置domain
將剛剛複製的網址貼到Django專案中的`settings.py`檔內
```python=
ALLOWED_HOSTS = ['django-env.eba-mjgjyqkj.us-west-2.elasticbeanstalk.com', '127.0.0.1:8000']
```
> 後面加上`127.0.0.1:8000`的原因是實際開發時，都是先在本地測試，確定沒問題之後，在push到repository上，未加上`'127.0.0.1:8000'`的話，本地是無法進行訪問的哦。
### 部署
```bash=
eb deploy
```
看到`Environment update completed successfully`表示部署成功！

### 開啟瀏覽畫面
```bash=
eb open
```
![](https://i.imgur.com/vNqx3zG.png)

### 配置儲存靜態檔案
如果要儲存靜態檔案，只要在`settings.py`中增加下方程式碼
```python=
STATIC_ROOT = 'static'
```
### 後台管理的畫面
```bash=
python manage.py collectstatic
```
### 關掉Elastic Beanstalk
如果暫時不需要使用這個專案的話，記得關掉，不然還是會一直使用AWS的資源，這些消耗的資源還是要算錢的XD所以務必記得關掉
```bash=
eb terminate django-env
```
使用`eb terminate`終止Elastic Beanstalk環境，不過上面的指令只有終止環境及於其中執行的所有AWS資源，但它不會刪除應用程式，所以隨時能夠再次執行`eb create`，以同一組態(config)建立更多的環境。

### 移除專案資料夾和虛擬環境
如果不再需要此應用程式，執行下指令移除專案資料夾和虛擬環境。
```bash=
rm -rf ~/eb-virt
rm -rf ~/ebdjango
```
## 建立自動化佈署(Continuous Deployment; CD)
> 這個是另外補充的，如果要跑CD流程的話記得回到Root Account將CodePipelineFullAccess，賦予給User，不然User是沒有權限使用這項服務的喔XD，或是直接從Root Account 來做CodePipeline設定(懶人法)

剛才部署好Django程式之後，接著我們可以利用AWS的CodePipeline來幫我們做自動化部署。
我們將剛剛本地建置好的Django專案push至Github上
### 建Repository
到自己的Github上建立新的Repository
![](https://i.imgur.com/Bqnb3gI.png)

## CodePipeline
建置好專案的Repository後至CodePipeline主頁面點選**Create pipeline**
![](https://i.imgur.com/XnScJ0W.png)
### 設定
設定Pipeline name後直接點選**Next**
![](https://i.imgur.com/KfihvaK.png)
### Add source stage
選擇**Github**及剛剛建立的Repository
![](https://i.imgur.com/gD1xydO.png)

### Add deploy stage
![](https://i.imgur.com/Ug1t9g2.png)

### Review
設定完成後會至Review頁面，點擊**Create**
### 建置完成
![](https://i.imgur.com/xhS2quy.png)
之後只要每次程式碼改動，push到Github上就會自動部署到Elastc Beanstalk。

# 參閱
[Official Doc](https://docs.aws.amazon.com/elasticbeanstalk/latest/dg/create-deploy-python-django.html#python-django-configure-for-eb)