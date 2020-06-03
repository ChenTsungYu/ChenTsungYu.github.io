---
title: 'Git/Github操作'
catalog: true
date: 2019/07/14 21:23:10
tags: Github
categories: Tool
---
<!-- toc -->
# 前言
本篇筆記如何用Git上傳自己的專案到github上面。
## 下載
首先，先在搜尋引擎輸入Git找到[官網](https://git-scm.com/)，進入官網後滾輪往下滑動會看到電腦可安裝版本。

![Win10為例](https://cdn-images-1.medium.com/max/2028/1*rQ5PIDZ_GTGlt3SUVmypXA.png)*Win10為例*
<!--more--> 
點選下載安裝後就可以到"開始"內找尋有無git的檔案，接著打開命令提示字元(或作終端機)，在"開始”的地方搜尋 cmd ，打開介面後輸入: git --version 可以看到目前下載的版本。

![](https://cdn-images-1.medium.com/max/2000/1*lPnPFrPtpRj8QDtxE8iDjg.png)

### 接下來進行Git本機端基本操作:

先到自己的專案建立資料夾，例如我在D槽建立資料夾名為: project1，回到命令提示字元設定檔案路徑，今天我將專案資料夾放D槽，那我的路徑就是

![](https://cdn-images-1.medium.com/max/2000/1*RLxQVvK0_2JqQ-A7THM5xw.png)

d:表示路徑切換至D槽， cd 後接資料夾路徑名稱。

## 基本指令如下:

### git init: 初始化 Git Repository

### git status: 觀察Repository檔案追蹤狀況

### git add 檔名 : 將檔案加入追蹤清單，如: git add .

### git commit -m “此處填版本訊息”: 建一組版本更新訊息

### git branch: 查看分支(branch) : 預設為 master

### git remote -v: 查詢遠端的repository

### git log: 查詢更改紀錄

### git remote add 雲端名稱(自己取) 網址 :將本機端和Github雲端上的專案相連

### git push 遠端空間名稱 遠端空間的分支(名稱): 將本機端的資料上傳(push) 到雲端

### git clone 遠端空間網址(clone那邊) 本機資料夾名稱: 下載/複製(clone)Github雲端專案到本機端

## 開始進行實作:

輸入指令: git init 進行初始化，可以看到以下畫面，要注意的點在windows下系統預設會隱藏資料夾檔案。

![](https://cdn-images-1.medium.com/max/2000/1*fLw0lHVYhv0ae55MeE9EAg.png)

透過資料夾上方工具列的部分可以找到"檢視"，點擊後找到隱藏項目進行勾選，就可以看到我們隱藏的git資料夾。

![](https://cdn-images-1.medium.com/max/2000/1*KYsW-h0Z6T8MhtHF3Gyljg.png)

![隱藏的資料夾浮現了!](https://cdn-images-1.medium.com/max/2000/1*6MY3R0Y21a-LyIpMONeU1A.png)*隱藏的資料夾浮現了!*

輸入: git status 觀察Repository檔案追蹤狀況。

![](https://cdn-images-1.medium.com/max/2000/1*lhgrPxtjd8mCx1dn10ZETg.png)

可以看見預設的分支(branch)是master。

將我的專案放入該資料夾內

![](https://cdn-images-1.medium.com/max/2000/1*nUWRVEqSIr2PQlEpF_zwwg.png)

我們在命令提示字元輸入 git status 來看發生什麼事

![跳出我們剛剛新增檔案的相關訊息](https://cdn-images-1.medium.com/max/2000/1*1GVTqWQy68qgXaknBOH4Ug.png)*跳出我們剛剛新增檔案的相關訊息*

另外只要修改過專案的程式碼也會被記錄。

輸入 **git add .** 將檔案加入追蹤清單，並輸入git status 查看狀態。

![顯示更新訊息](https://cdn-images-1.medium.com/max/2000/1*LkC41ZdGNzV2oQBjGwop0Q.png)*顯示更新訊息*

### 輸入 git commit -m “此處填版本訊息”

![](https://cdn-images-1.medium.com/max/2000/1*OAXQLM6YTqlWzRBujqHqrQ.png)

再輸入一次 git status，可以發現訊息已經被清空，之前的更改紀錄已經被保留，後續可以在github上看到。

![](https://cdn-images-1.medium.com/max/2000/1*gh8y7kmhOM1Bb5CqUk48eQ.png)

![git branch指令可以看到分支名稱](https://cdn-images-1.medium.com/max/2000/1*_HPGeoOtLywZ6MXv42NUqA.png)*git branch指令可以看到分支名稱*

註冊一個[github帳號](https://github.com/)，登入後看到畫面右上角

![點選"Your repositories"](https://cdn-images-1.medium.com/max/2000/1*GEeBsPYsuBrgJdWlAUh-BQ.png)*點選"Your repositories"*

點入之後看到畫面中間有個綠色的"New"按鈕，取你要的repository名稱再點選creat repository。

![](https://cdn-images-1.medium.com/max/2000/1*7nG18UJjsQbQ4iXE-cutIA.png)

創建完成會在畫面看到自己建立的repository名稱，點選後進入畫面。

![看到自己的網址複製起來](https://cdn-images-1.medium.com/max/2000/1*XfoZGfVqbY_aUjNK5norqQ.png)*看到自己的網址複製起來*

### 接下來要進行遠端操作

輸入 git remote -v 進行遠端查詢，因為還沒連接到遠端，所以是空的，

再來輸入 git remote add name url (name建立自己的遠端空間名稱;url為遠端地址，把剛剛複製的網址貼上即可)

輸入git remote -v 進行查詢。

![](https://cdn-images-1.medium.com/max/2000/1*is3ZoD7WRfzmvLo7ATiajw.png)

輸入 git push name branchName(name 遠端空間名稱; branchName 遠端空間的分支名稱)

![遠端傳輸成功!](https://cdn-images-1.medium.com/max/2000/1*47d3XZFBMSnAFsk6LaGr8w.png)*遠端傳輸成功!*

養成確認的好習慣: git status

![](https://cdn-images-1.medium.com/max/2000/1*GJ3cQpkpvzjeRKMUyn0oeA.png)

回到github上剛剛新增repository的地方進行頁面重整，另外在畫面可以看到我們初次新增的commit 名為 "first version"。

![刷新後成功載入!](https://cdn-images-1.medium.com/max/2008/1*Ik-mvQsNXAa712TZeo3xDQ.png)*刷新後成功載入!*

最後是實作複製的部分，把別的專案複製(clone)下來。

輸入 git clone 遠端空間網址(clone那邊) 本機資料夾名稱

以我下載demo這個repository為例

![複製你要的遠端空間網址](https://cdn-images-1.medium.com/max/2000/1*qoKXsD0vikx6O1AvB-mD0g.png)*複製你要的遠端空間網址*

接下來要將demo整個clone到我本機端，命名為project1的資料夾。

![clone成功!](https://cdn-images-1.medium.com/max/2000/1*zoBVhPc9CkBcViboKdt6iA.png)*clone成功!*

查看我的project1資料夾是不是有另一個叫project1的資料夾。

![](https://cdn-images-1.medium.com/max/2000/1*71ZJOBuIBd-9-4wluFk75w.png)

結束! 以上為今日筆記。
