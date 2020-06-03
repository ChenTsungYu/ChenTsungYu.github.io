---
title: "[Docker] Docker化你的Python Flask APP 並上傳至Docker Hub"
catalog: true
date: 2020-04-26 17:00:10
tags: [DevOps, Docker, w3HexSchool]
categories: [DevOps]
---

> 鼠年全馬鐵人挑戰 - WEEK 12

<!-- toc -->
# 前言
本篇將透過撰寫Dockerfile來打包自己的 Docker Image，用於建置Python Flask 環境，並將打包好的Docker Image上傳至DockerHub。
<!--more-->
# Hands on Lab
## 建`Dockerfile`、`requirements.txt`
建立Dockerfile
```bash=
touch Dockerfile
```
在`requirements.txt`寫入`flask`，docker run的時候會下載flask這個相依套件
```bash=
echo "flask" > requirements.txt
```
## 撰寫Dockerfile
Dockerfile 開頭必須是`FROM`指定一個底層映像檔(image)
`Dockerfile`
```dockerfile=
FROM python:alpine3.10 
WORKDIR /app 
COPY . /app 
RUN pip3 install -r requirements.txt 
EXPOSE 5000 
CMD python3 ./index.py 

#COPY requirements.txt /app/requirements.txt
#ENTRYPOINT ["python", "./index.py"]
# 指令：docker build -t tom861012/imagedemo:0.0.1.RELEASE . 注意最後面的"."為當前目錄"
# FROM https://hub.docker.com/_/python
# WORKDIR 工作目錄
# COPY  複製的位置
# RUN    Build 時會執行的指令，下載相依套件
# EXPOSE   container 啟動時會監聽的port
# CMD   執行 Container 時的指令
```
接著建立`index.py`
```python=
from flask import Flask
helloworld = Flask(__name__)
@helloworld.route("/")
def run():
    return "{\"message\":\" Flask App Demo v1\"}"
if __name__ == "__main__":
    helloworld.run(host="0.0.0.0", port=int("5000"), debug=True)
```
### 建立並執行container
寫入上述的Dockerfile內容後，執行
```dockerfile=
docker build -t tom861012/imagedemo:0.0.1.RELEASE .
```
> * 注意最後面的`.`為當前目錄，是假設Dockerfile在當前目錄下，因此會以`.`結尾
> * 注意build指令，`-t`後面接的是repository地址，因為之後要push到自己Docker Hub的位置，而每個 Repository 的**前綴字都會是登入帳號**，所以上述範例`tom861012`為我自己的帳號

![](https://i.imgur.com/LUP2WMK.png)
成功build一個Flask App後會看到類似上圖的內容，接著用剛build好的image以背景模式來run一個container起來。
```bash=
docker run -p 5000:5000 -d imagedemo:0.0.1.RELEASE
```
![](https://i.imgur.com/TF0z1uc.png)
看到返回的containerID後就表示成功囉！
進入到`http://0.0.0.0:5000/`
![](https://i.imgur.com/PsM1QQG.png)

### 查看log
```bash=
docker logs -f containerID
```
### 查看images
```bash=
docker images
```
執行上述指令就可以觀察到新建立得`tom861012/imagedemo`這個image囉
![](https://i.imgur.com/IQd1IBm.png)
### 查看歷史紀錄
```bash=
docker history containerID
```
## Build好的Image推到Docker Hub
在push之前務必要記得先做`docker login`的動作
```bash=
 docker push tom861012/imagedemo:0.0.1.RELEASE
```
再到自己的Docker Hub頁面去看
![](https://i.imgur.com/VOvYOEf.png)

## 語法回顧
* `FROM [Docker Image Name:TAG]`
指定這個映像檔要以哪一個Image為基底來建構
* `WORKDIR` 設定工作目錄
* `COPY`  複製本地端的檔案/目錄到映像檔的指定位置中
* `RUN` Build Image 時會執行的指令，下載相依套件
* `EXPOSE` container 啟動時會監聽的port
* `CMD` 執行 Container 時的指令