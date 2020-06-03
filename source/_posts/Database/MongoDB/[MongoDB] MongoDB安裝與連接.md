---
title: '[Database] MongoDB安裝與連接'
date: 2019/09/11 20:54:10
tags: [Database, MongoDB, NoSQL]
catalog: true
categories: Backend
---
<!-- toc -->
![](https://i.imgur.com/3oils8I.png)
# MongoDB
MongoDB是一個NoSQL的資料庫，相較傳統RDBMS，NoSQL資料庫不需事先定義schema，設計上面較為彈性，MongoDB也有類似SQL語法對資料庫進行資料操作的方法，本篇著重於紀錄MongoDB的安裝與連接。
<!--more--> 
# 安裝MongoDB
因為自己是用Mac，所以本篇以Mac為主，安裝的是社群版本。

## CLI安裝
使用CLI安裝方式

```clike=
brew tap mongodb/brew
```
```clike=
brew install mongodb-community@4.2
```

[官方教學](https://docs.mongodb.com/manual/tutorial/install-mongodb-on-os-x/)

## 手動安裝
[官方載點](https://www.mongodb.com/download-center/community)
[相關教學](https://www.runoob.com/mongodb/mongodb-osx-install.html)

# 安裝Mongo Compass
在本地操作MongoDB除了透過`Shell`指令之外，也可使用MongoDB官方的GUI工具進行管理，到下方的官方載點選擇對應版本及作業系統後即可下載。
[官方載點](https://www.mongodb.com/download-center/compass)
## 管理介面
![](https://i.imgur.com/wmSte8F.png)
# 連接遠端MongoDB的方式
連接方式可採以下幾種常見方式
## Connect to Cluster0
進入MongoDB官網，登入個人帳號，
![](https://i.imgur.com/kjylkq9.png)
### 方法一: Application
* 點擊**Connect Instructions**，選擇**Connect Your Application** 
* 選擇程式語言，並複製下方指令
![](https://i.imgur.com/4eZxgfV.png)
* 打開**Mongo Compass**，貼上剛才複製的指令，並將**password**替換成自己的用戶密碼
![](https://i.imgur.com/VOx4Hvf.png)
* 成功連上
![](https://i.imgur.com/Vr84xtT.png)

### 方法二: Fill in connection fields individually
![](https://i.imgur.com/Vq3y90r.png)
可輸入主機名稱、用戶帳號、密碼等欄位，如果是純粹在本地測試，**Hostname**輸入`localhost`，port預設為`27017`。


### 方法三: Mongo Shell
點擊**Connect Instructions**，選擇**Connect with the Mongo Shell** 

* 複製官方給的mongo shell
![](https://i.imgur.com/JnJEZBL.png)
* 打開終端機，輸入剛剛複製的指令，並輸入用戶密碼
![](https://i.imgur.com/Ff8loiK.png)

* 成功登入
![](https://i.imgur.com/d0iRtfx.png)

> 以上為MongoDB安裝及連接的方式