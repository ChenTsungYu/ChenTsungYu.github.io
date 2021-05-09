---
title: "[SSL] Nginx 整合 Certbot 替網站加上 SSL"
catalog: true
date: 2020/07/20 19:23:10
tags: [SSL, Certbot, Ubuntu]
categories: Network
toc: true
---
<!--toc-->
## 前言
[上一篇](https://medium.com/tsungs-blog/django-%E5%9C%A8ubuntu%E4%B8%AD%E9%81%8B%E7%94%A8nginx-gunicorn-%E6%9E%B6%E8%A8%AD-django-api-server-6d41c165a2c7)架設完 Server 後會發現網站是未加密的狀態，因此瀏覽器會將該網站標示為 **"不安全"**，本文記錄如何替網站加上 SSL 憑證進行加密。
<!--more-->
## 環境
- OS: Ubuntu 18.04
- Server: Nginx 1.14

## 下載 Certbot
```bash=
sudo add-apt-repository ppa:certbot/certbot
sudo apt install python-certbot-nginx
```
## 確認 Nginx’s 設定檔
[上一篇](https://medium.com/tsungs-blog/django-%E5%9C%A8ubuntu%E4%B8%AD%E9%81%8B%E7%94%A8nginx-gunicorn-%E6%9E%B6%E8%A8%AD-django-api-server-6d41c165a2c7)有提到Nginx的相關設定，查看一下
```bash=
cat /etc/nginx/sites-available/project_name.conf
```
確認填寫的網址`server_name example.com www.example.com;`

若遇到`inactive`的狀況，則執行`sudo ufw enable`
![](https://i.imgur.com/4LNfUxH.png)
```bash=
sudo ufw enable
sudo ufw status
```
## 取得 SSL Certificate
使用 nginx 執行 certbot，並使用`-d`指定我們希望的網域名稱，對其發行 certificates。
```bash=
sudo certbot --nginx -d example.com -d www.example.com
```

系統會要求輸入email，輸入完畢後再選擇**Agree**。接著會詢問選擇是否要將所有的資源請求導向HTTPS的網域，故選擇`2`

![](https://i.imgur.com/xJY5nym.png)

## 更新 SSL certificates
```bash=
sudo cerbot renew --dry-run
```
若出現錯誤訊息: `sudo: cerbot: command not found`，可以採用以下方式。

找出certbot路徑
```bash=
which certbot
```
接著執行下方指令，將`certbot_path`替換成剛剛拿到的路徑名稱
```bash=
sudo certbot_path renew --dry-run
```
設定成功的訊息
![](https://i.imgur.com/KoKXC8M.png)

## 自動更新憑證
由於 Let’s Encrypt 憑證簽發為**每三個月一次**，也就是每 90 天必須更新（renew）一次，雖然 SSL For Free 提供訂閱通知的機制，在憑證過期前會收到電子郵件告知你要更新憑證。

不過身為一位工程師，秉持**能自動就不要手動**的精神，我們可以藉由 crontab 設置排程工作定期幫我們更新 SSL 憑證。
### 確認憑證狀態
```bash=
sudo certbot certificates
```
會出現類似下方訊息
```bash=
Saving debug log to /var/log/letsencrypt/letsencrypt.log

- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Found the following certs:
  Certificate Name: xxxx.xxxx.com
    Domains: xxxx.xxxxxx.com
    Expiry Date: xxxx-xxxx-xxxx 03:44:52+00:00 (VALID: 89 days)
    Certificate Path: /etc/letsencrypt/live/xxxxxx.xxxxxx.com/fullchain.pem
    Private Key Path: /etc/letsencrypt/live/xxxxxx.xxxxxx.com/privkey.pem
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
```
上述資訊可看出憑證距離到期還有多久的時間
### 設置排程工作
```bash=
sudo crontab -e
```
### 寫入排程規則
下方指令以固定每月1號進行 renew SSL 憑證為例，其中 `--quiet` 表不產生輸出結果
```bash=
0 0 1 * * /usr/bin/certbot renew --quiet
```
想了解更多排程規則可以試試這個[網站](https://crontab.guru/every-month)，幫助大家能快速了解自己設的規則

## Reference
- [Update: Using Free Let’s Encrypt SSL/TLS Certificates with NGINX](https://www.nginx.com/blog/using-free-ssltls-certificates-from-lets-encrypt-with-nginx/)