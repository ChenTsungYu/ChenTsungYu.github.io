---
title: "[Django] 在 Ubuntu 中運用 Nginx、Gunicorn 架設 Django API Server"
catalog: true
date: 2020/07/19
tags: [Python, Django, w3HexSchool, Ubuntu] 
categories: Backend
toc: true
---
>鼠年全馬鐵人挑戰 - WEEK 19
<!--toc-->
# 前言
目前正在進行一個Side Project，用朋友開給我的虛擬機(VM)架設一台API Server，趁還有記憶時趕快來筆記一下。

## 前置作業:
- OS: Ubuntu 18.04
- Web Framework: Django 3.0; djangorestframework 3.11
- Server: Nginx 1.14
- Database: MySQL
<!--more-->

# 實作
架構圖如下:
![](https://i.imgur.com/IRUbP5n.png)
## 安裝環境
安裝所需要的環境，會下載python3、mysql、nginx
```
sudo apt-get update
sudo apt-get install python3-pip python3-dev mysql-server libmysqlclient-dev nginx
```
## 資料庫
```bash=
sudo mysql_install_db
sudo mysql_secure_installation
```
執行上述指令進行初始化，系統會詢問一些相關設定，可以全部都採預設的方式。其中，要設定root權限的密碼，設定完之後執行下方指令登入root帳號
```bash=
mysql -u root -p
```
完成登入便會進入MySQL Shell，在Shell中寫下腳本建立資料庫
```bash=
CREATE DATABASE <yourprojectname> CHARACTER SET UTF8;
```
將上述的`<yourprojectname>`替換成自己要建立的資料庫名稱，其中`utf8`為Django預設得編碼。

接著是在MySQL中建立另一個User，建議之後都使用User的帳號來登入資料庫！
```bash=
CREATE USER <yourdbuser>@localhost IDENTIFIED BY '<password>';
```
上述指令中，`<yourdbuser>`為自訂的User名稱，`<password>`為自訂的密碼，注意密碼要以字串的形式撰寫(要有`''`)。
```bash=
GRANT ALL PRIVILEGES ON <yourprojectname>.* TO <yourdbuser>@localhost;
```
執行上述指令，賦予剛建立的User訪問資料庫的權限。
```bash=
FLUSH PRIVILEGES;
exit
```
## 專案
下載相依套件
```bash=
sudo -H pip3 install --upgrade pip
sudo -H pip3 install virtualenv
```
如果先前在Github上的repo已經有專案，可以直接Clone到Ubuntu的環境中
```bash=
git clone repoAddress
```
或是直接在Ubuntu中建立新的專案
```bash=
mkdir ~/<yourprojectdir>
cd ~/<yourprojectdir>
```
在專案資料夾中建立虛擬環境
```bash=
virtualenv <yourenv>
```
啟動虛擬環境
```bash=
source <yourenv>/bin/activate
```
以我為例，我的虛擬環境名稱為`env`
![](https://i.imgur.com/vlS6qMf.png)

啟動虛擬環境後會看到終端機的最左方有的`(env)`表示啟動虛擬環境，若要退出虛擬環境則執行`deactive`。

下載專案所需的相依套件
```bash=
pip3 install django gunicorn pymysql djangorestframework
```
建立Django restframework的手把手教學可以參考[官網範例](https://www.django-rest-framework.org/tutorial/quickstart/)。

本文是直接Clone之前已經在Github建立好的Repo，建立Django專案的部分便不多加詳述，主要是紀錄部署到實際環境需要修改的設定。

到Django主要專案的資料夾下，建立一個名為`__init__.py`的檔案
```bash=
vim __init__.py
```
寫下下方程式碼
`__init__.py`
```python=
import pymysql
pymysql.version_info = (1, 3, 13, "final", 0)
pymysql.install_as_MySQLdb()
```
寫完上述程式碼後儲存離開`ESC`+`:wq!`
接著在`settings.py`中做下方幾個更改
```bash=
vim settings.py
```
`settings.py`
```python=
ALLOWED_HOSTS = [ 'domain.com', '<yourserverip>', 'localhost']

# 此數將預設的SQLite替換成MySQL
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': '<yourdatabasename>', # 資料庫名稱
        'USER': '<yourdbuser>', # 資料庫使用者帳號
        'PASSWORD': '<password>', # 資料庫密碼
        'HOST': 'localhost', # 主機位置
        'PORT': '3306', 
    }
}

STATIC_URL = '/static/'
STATIC_ROOT = os.path.join(BASE_DIR, 'static/')
```
寫完上述程式碼後儲存離開`ESC`+`:wq!`
`ALLOWED_HOSTS`為網域名稱、IP，還有設定連接Mysql資料庫，輸入剛才前面設定資料時，建立的資料庫名稱、使用者帳號、密碼。最後是`STATIC_ROOT`為設定靜態資源的根路徑。

執行
```bash=
python3 manage.py collectstatic
```
執行下方指令進行資料庫遷移
```bash=
python3 manage.py makemigrations
python3 manage.py migrate
```
## gunicorn
### 使用gunicorn測試Server
```bash=
cd ~/<yourprojectdir>
gunicorn --bind 0.0.0.0:8000 <yourproject>.wsgi
```
成功後會看到下方畫面
![](https://i.imgur.com/kLJvnAb.png)
接著訪問你的伺服器IP加上Port號即可查看目前運作狀況，如`xxx.xxx.xx.xx:8000`。
跳出當前虛擬環境
```bash=
deactivate
```
### 設定gunicorn
建立`gunicorn.socket`
```bash=
sudo vim /etc/systemd/system/gunicorn.socket
```
檔案寫入
```bash=
[Unit]
Description=gunicorn socket

[Socket]
ListenStream=/run/gunicorn.sock

[Install]
WantedBy=sockets.target
```
寫完上述程式碼後儲存離開`ESC`+`:wq!`

確認一下gunicorn的位置，因為後續建立`gunicorn.service`檔時會使用到
```bash=
which gunicorn
```
執行上述指令會回傳gunicorn的路徑

建立`gunicorn.service`
```bash=
sudo vim /etc/systemd/system/gunicorn.service
```
`gunicorn.service`
檔案寫入
```bash=
[Unit]
Description=gunicorn daemon
Requires=gunicorn.socket
After=network.target

[Service]
User=<youruser> # 此處輸入這台機器的使用者名
Group=www-data
WorkingDirectory=<path/to/yourprojectdir> # 輸入Django專案的路徑
ExecStart=<gunicorn_path> \   # 輸入gunicorn的路徑
          --access-logfile - \
          --workers 3 \
          --bind unix:/run/gunicorn.sock \
          <yourproject>.wsgi:application

[Install]
WantedBy=multi-user.target
```
寫完上述程式碼後儲存離開`ESC`+`:wq!`
啟用 Gunicorn socket
```bash=
sudo systemctl start gunicorn.socket
sudo systemctl enable gunicorn.socket
```
檢查Gunicorn socket是否運作成功
```bash=
sudo systemctl status gunicorn.socket
```
![](https://i.imgur.com/B5Jqzhs.png)
成功會顯示綠色`active`字樣

檢查gunicorn.sock 檔案是否存在`/run`這個資料夾中
```bash=
file /run/gunicorn.sock
```
![](https://i.imgur.com/hSUerTR.png)
如果發現沒有在`/run`這個資料夾中，或是有其他問題，可以執行下方指令查看Log找問題
```bash=
sudo journalctl -u gunicorn.socket
```
測試Server運作情況
```bash=
sudo systemctl status gunicorn
```
![](https://i.imgur.com/TlnV07m.png)
或是發`Curl`測試
```bash=
curl --unix-socket /run/gunicorn.sock localhost
```
回傳結果為HTML格式的資料
要對gunicorn排查問題也可以執行下方指令看Log
```bash=
sudo journalctl -u gunicorn
```
若遇到問題，且查看Log後將問題排除，需要再重新run一次gunicorn
```bash=
sudo systemctl daemon-reload
sudo systemctl restart gunicorn
```

## 配置Nginx代理傳給Gunicorn

```bash=
sudo vim /etc/nginx/sites-available/project_name.conf
```
`project_name`修改為專案名稱
`project_name.conf`
```bash=
server {
    listen 80;
    server_name <domain_name> <server_ip>; # 此處輸入網域名及ip，兩者以空格隔開。

    location = /favicon.ico { access_log off; log_not_found off; }
    location /static/ {
        root <your_static_root_path>; # static的根目錄位置
    }

location / {
        include proxy_params;
        proxy_pass http://unix:/run/gunicorn.sock;
    }
}
```
將檔案連結到啟動網站的目錄來啟動該檔案
```bash=
sudo ln -s /etc/nginx/sites-available/project_name.conf /etc/nginx/sites-enabled
sudo nginx -t
sudo systemctl restart nginx
```

設防火牆需要開放80 port上的流量，並刪除8000 port，禁止訪問。
```bash=
sudo ufw delete allow 8000
sudo ufw allow 'Nginx Full'
```
建立成功！
![](https://i.imgur.com/I2K0s4c.png)










