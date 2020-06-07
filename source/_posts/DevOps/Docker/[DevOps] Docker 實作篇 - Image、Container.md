---
title: "[Docker] Docker 實作篇 - Image、Container"
catalog: true
date: 2020/04/19 17:00:10
tags: [DevOps, Docker, w3HexSchool]
categories: [DevOps]
toc: true
---

> 鼠年全馬鐵人挑戰 - WEEK 11

<!-- toc -->
# 前言
之前簡單的介紹過Docker後，本篇文紀錄Docker系統架構及操作Image、Container的基本指令。
<!--more-->
## Docker 系統架構
Docker系統架構主要是**Client-Server**架構，Client 端稱為Docker Client，Server端稱為Docker Daemon
![](https://i.imgur.com/26LiQlQ.png)
當我們對docker下指令時，會發request給Docker Daemon去執行指令對應的工作。
### Docker Daemon做哪些事?
* 管理多個container
* 管理多個從DockerHub pull下來或是在本地由dockerfile建立的Image
* 將本地建立好Image推到雲端上的repository

# Hands on Lab
初步了解Docker 系統架構後，接著來著手學習相關指令吧！
## Docker 登入
```bash=
docker login
```
執行上述指令後，輸入自己在Docker Hub上建立的帳號密碼就可以登入了
## Docker image相關的基本指令
### 查看相關指令說明
```bash=
docker run --help
```
### 查看所有的image
執行下方指令會列出所有local端的image
```bash=
docker images
```
![](https://i.imgur.com/rfveMIF.png)
### 遠端下載image
Docker Hub 上有大量的Image可以用，如果要從遠端的Docker Registry 下載至本地端，可以執行
```bash=
docker pull image_name
```
docker pull Image名稱的格式有兩種:
* Docker Registry位址：位址的格式一般是 <網域名/IP>[:連接埠號碼]。 預設位址是 Docker Hub。
* Repository name：Repository name是兩段式名稱:  `<使用者名稱>/image_name:image_tag`。對於 Docker Hub，若未給定使用者名稱，則預設為從官方的image，也就是library

#### 範例: pull非官方的Image
![](https://i.imgur.com/WrUHGP3.png)
例如今天我的docker hub上已經有個自己build好的image(如上圖)，我要將其pull下來，我可以執行下方指令
```bash=
docker pull tom861012/imagedemo:0.0.1.RELEASE
```
`tom861012`為我的docker hub帳號，`imagedemo`為image名稱而`0.0.1.RELEASE`為tag名。
#### 範例： 從官方的Image pull MySQL Image
將image_name替換成目標image，例如要下載MySQL這個image
```bash=
docker pull mysql
```
### 查找相關的image
若要查找存放在remote repository的image，可以用`search`這個指令
```bash=
docker search image_name
```
### 範例： MySQL Image
將image_name替換成目標image，例如要查找MySQL相關image
```bash=
docker search mysql
```
### 查看目標image的歷史紀錄
```bash=
docker image history image_name
```
### 查看目標image的相關數據資料
```bash=
docker image inspect image_name
```
### 刪除local端的image
```bash=
docker image remove image
或是
docker rmi
```
### 一次刪除不必要(未使用)的image
```bash=
docker rmi $(docker images --filter "dangling=true" -q --no-trunc)
```
### 替image加上tag
```bash=
docker tag  Image ID repository_address:image_tag
```
若在沒有指定 TAG 是哪個版本的情況下，預設會是`latest`表示最新版本，當然我們也自訂tag 名稱，如：加入Repository 版本號，打包出來的 Docker Image，後面的TAG 就會從`latest` 變成指定的版本號了。
實務上為了易於辨識，通常會在Tag中加入版本號。

## Container相關的基本指令
### 建立並執行docker container
```bash=
docker run -p port:container_port repository:image_tag_name
```
* `-p`: 為`--publish` 的簡寫
* `repository` 為DockerHub所存放Repository，其中包含多個Image，每個Image有不同的標籤(tag)
* `image_tag_name` : image的tag name

> 執行`docker run`時，若本地端無此Image存在時，會從DockerHub上找目標Repository拉下來(pull down)到本地
### docker run中間的過程
* 先在local image cache尋找該image
* 若找不到該image，會往遠端的image repository尋找(預設為**Docker Hub**)
* 拉下(pull)下載最新版本的image
* 根據pull下來的image來建新的container
* 在 docker engine 裡面給 container 私有網路上的虛擬 ip
* 開啟主機端的port(看你設定哪個port)並轉址到 containe的port(若沒有下`--publish`指令就不會打開任何 port)

### 背景執行: detach
在`docker run`的指令中加上`--detach`(或是簡寫`-d`)，可以讓docker在背景執行。
```bash=
docker run -p port:container_port -d repository:image_tag_name
```
這個指令會印出**container ID**

### 查看執行中的 Docker Container
```bash=
docker container ls
```
執行上述指令可以查看container相關的資訊，如ID、名稱、執行的Command、建立時間、所在的Image及對應的port等等。
或是執行下方指令也可以
```bash=
docker ps
```
### 停止docker container
```bash=
docker container stop containerID(可以取前四個)
```
或是將`stop`指令改為`kill`也可以
```bash=
docker container kill containerID(可以取前四個)
```
雖然`stop`、`kill`都可以將container停止，兩者的區別在於`kill`指令是強行終止container，而`stop`是循序的，會先给container發送一個TERM訊號(signal)，讓container做一些退出前必须的安全性操作，container自动停止運作，相對之下較為優雅(graceful)
### 刪除 container
```bash=
docker rm containerID
```
### 清理所有停止運行的container
```bash=
docker container prune
```
### 啟動已終止容器
利用`start`指令，將一個已經終止的容器啟動執行
```bash=
docker start container_name或id
```
### 觀察 container 的資源使用量
```bash=
docker stats 
```
`stats`指令會顯示目前所有執行中的 container所吃掉的 CPU, 記憶體, 網路和磁碟 I/O 等等，**它是即時性的**！讓使用者可以知道每個 Container 使用掉多少的系統資源。
### 限制container記憶體的使用量
加上`-m`這個指令參數表示`--memory`，可以指定記憶體的容量限制，如下方範例為限制**512m**
```bash=
docker run -p port:container_port -d -m 512m repository:image_tag_name
```
### 限制container CPU的使用量
加上`--cpu-quota`這個指令參數可以指定 CPU 資源限制，最大為**1000000**，下方範例為上限的一半: 500000
```bash=
docker run -p port:container_port -d -m 512m --cpu-quota=500000 repository:image_tag_name
```
### 查看log
查看container id的log
```bash=
docker logs containerID(可以取前四個)
```
## docker system相關的基本指令
### 查看docker系統資訊
```bash=
docker system info
```
### 查看硬碟使用情況
用了一段時間Docker後，會發現它佔用了不少硬碟空間，如果想知道硬碟的使用情況可以加上`df`指令
```bash=
docker system df
```
![](https://i.imgur.com/0WJTk5x.png)
### 監控事件活動
Docker 有提供`events`指令用來監聽Docker的事件紀錄，可用來查找問題，例如容器一直執行不起來的時候，就可以使用 docker events 來觀察到底是失敗在哪一個階段。
```bash=
docker system events
```
下這個指令時，記得要開另外一個終端機，因為這個指令是一直持續監控事件的狀態，所以要一直讓他run才有辦法監聽事件
### 刪除所有未使用的 containers, networks, images
```bash=
docker system prune
```

# 參考教學
[docker 快速學習自我挑戰 Day1](https://tingsyuanwang.github.io/blogs/2017/07/23/docker-%E5%BF%AB%E9%80%9F%E5%AD%B8%E7%BF%92%E8%87%AA%E6%88%91%E6%8C%91%E6%88%B0-Day1/)

[docker入門觀念](https://hackmd.io/@titangene/docker-getting-started-slide?print-pdf#/)

[手把手教你安裝、使用 docker 並快速產生 Anaconda 環境 (1)](https://hackmd.io/@bluewings1211/SJkLOW9_l?type=view#%E5%88%97%E5%87%BA%E6%98%A0%E5%83%8F%E6%AA%94)