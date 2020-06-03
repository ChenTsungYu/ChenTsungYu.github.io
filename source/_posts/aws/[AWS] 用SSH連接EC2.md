---
title: "[AWS] 用SSH連接EC2"
catalog: true
date: 2020/03/25 8:00:10
tags: [AWS, w3HexSchool]
categories: [Cloud]
toc: true
---

> 鼠年全馬鐵人挑戰 - WEEK 07

# 前言
本篇文章紀錄如何開啟AWS的EC2，採用SSH的方式連接，並在Ubuntu的作業系統環境下架設Apache Server。
* 電腦配備：Mac
* AWS免費帳號(一年期)

<!--more-->
# 步驟
## 進入AWS Management Console
點選EC2
![](https://i.imgur.com/hSN7D1m.png)

## 建立Instance
![](https://i.imgur.com/TPjc1Jg.png)

## 選擇AMI
![](https://i.imgur.com/bZqG28O.png)
以**ubuntu**為例：
![](https://i.imgur.com/CN47FPV.png)

## 選擇Instance Type
![](https://i.imgur.com/0n1pbf8.png)
tab3、4、5可以先略過，到**6.Configure Security Group**配置Security Group
![](https://i.imgur.com/ImjYeay.png)
* Add Rule
* 下拉選單選擇**HTTP**
* Review and Launch

## 建立Key Pair
點擊**Review and Launch**會進入設定Key Piar的畫面，如果是初次建Instance，選單內無法選擇**existing key pair**，點選**Create a new key pair**
![](https://i.imgur.com/gDjwkR3.png)

## 設定&下載Key Pair
可替自己的Key Pair命名，命名完成後點擊**Download Key Pair**將檔案下載至本地後再點選**Launch Instance**
![](https://i.imgur.com/16IuWfU.png)


### 建置成功！
![](https://i.imgur.com/BaBvIHq.png)

## 查看建立的Instance
回到EC2的主畫面，點選左方的**Instances**欄位。
![](https://i.imgur.com/a26cQCY.png)
進入Instance的管理介面後即可看到剛剛開設的Instance，點擊該Instance再點擊上方的**Connect**

## 連接Instance
![](https://i.imgur.com/1pwxkbn.png)

### 更改檔案權限
剛才download下來的Key Pair會下載至本地，可將`.pem`的檔案放置在自己的專案資料夾。
開啟終端機，將路徑切換至該專案資料夾下，輸入下面的指令，更改檔案權限為**Read by owner**:
```bash=
chmod 400 你的key_pair
```

### SSH連接
複製example給的指令進行SSH連接
```bash=
ssh -i "yourpem.pem" ubuntu@yourinstance.compute-1.amazonaws.com
```
### 成功連接!
![](https://i.imgur.com/1Tmq2r3.png)

## 安裝Apache Server
分次執行下方指令，安裝Apache
```bash=
sudo apt-get update
sudo apt-get install apache2
sudo apt-get install libapache2-mod-wsgi
```

## 訪問網站
回到Instances管理介面，點選該Instance會看到**Public DNS (IPv4)**，複製網址後即可訪問
![](https://i.imgur.com/kgTUKwN.png)
### 訪問預設的畫面
![](https://i.imgur.com/ijZdTba.png)

完成上述所有步驟就完成環境的架設囉！
