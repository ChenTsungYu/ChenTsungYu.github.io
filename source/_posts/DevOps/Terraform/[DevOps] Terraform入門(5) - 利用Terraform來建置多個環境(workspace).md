---
title: "[Terraform] Terraform入門(5) - 利用Terraform來建置多個workspace"
catalog: true
date: 2020/04/13 00:00:00
tags: [DevOps, Terraform,w3HexSchool, AWS]
categories: [DevOps]
toc: true
---
> 鼠年全馬鐵人挑戰 - WEEK 10
<!-- toc -->
# 前言
不知不覺Terraform這系列的隨手筆記寫到第五篇，本文記錄如何透過撰寫Terraform腳本來開啟S3、DynamoDB，綁定IAM User，並建置在不同workspace下。
<!--more-->
# Hands on Lab
## 初始化專案
```bash=
# Configure the AWS Provider
provider "aws" {
  region  = "us-east-2"
  version = "~> 2.55"
}
```
執行下方指令做初始化
```bash=
terraform init
```
## 建立S3 bucket、DynamoDB
再來就是建立S3 bucket、DynamoDB，會分別定義S3 bucket、DynamoDB兩個`resource`，S3會設定生命週期為永久保存，並透過`versioning`設定來紀錄多個版本號，若未來開發時，專案改壞了還可以退回前一個版本！

```bash=
# Configure the AWS Provider
provider "aws" {
  region  = "us-east-2"
  version = "~> 2.55"
}

# S3 Bucket
resource "aws_s3_bucket" "backend_state" {
  bucket = "dev-application-backend-state01" # 自訂 bucket 名稱
  # 設定S3的生命週期
  lifecycle { # 永久保存
    prevent_destroy = true
  }
  # 儲存多個版本號，若之後開發上遇到問題，可退回舊的版本
  versioning{
      enabled = true
  }
  server_side_encryption_configuration{
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

# Locking - DynamoDB 
resource "aws_dynamodb_table" "dynamodb_demo" {
  name = "dev_application_dynamodb01"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"
  attribute {
    name = "LockID"
    type = "S" # 以字串的方式儲存
  }
}
```
完成上述程式碼後執行下指令完成建立
```bash=
terraform apply
```
查看兩者是否成功新增
### S3
![](https://i.imgur.com/NW0swtW.png)

### DynamoDB
![](https://i.imgur.com/i03JNUE.png)

## 配置IAM User
接著我們要將前面建立的S3、DynamoDB賦予某個User，為了方便管理，另外新建一個名為**users**的資料夾，目錄結構如下:
![](https://i.imgur.com/rwZMzkD.png)
接著建立`main.tf`，並寫入下方程式碼，執行`terraform init`初始化
```bash=
terraform {
  backend "s3"{
    bucket = "dev-application-backend-state01"
    key = "backendState-proj-dev" 
    region = "us-east-2"
    dynamodb_table = "dev_application_dynamodb01"
    encrypt = true
  }
}
# Configure the AWS Provider
provider "aws" {
  region  = "us-east-2"
  version = "~> 2.55"
}

# AWS IAM User
resource "aws_iam_user" "my_iam_user" {
  name = "my_iam_user_demo" # 被賦予的User名稱
}

```
執行`terraform apply`後查看新建立的User
![](https://i.imgur.com/dmDfve3.png)
查看S3設定，會發現剛才給予加密的種類-AES
![](https://i.imgur.com/WIPBmVx.png)
## 修改S3存放檔案的路徑
上面的範例程式碼成功執行後，檔案會放在S3的**根目錄底下**，實務上可能會有很多專案存放，這時要個別歸類在不同的專案目錄下，所以我們將原始`key`**(作爲檔案存放路徑**)改為`dev/user/backendState-proj-dev`。
```bash=
terraform {
  backend "s3"{
    bucket = "dev-application-backend-state01"
    # key = "backendState-proj-dev" 
    key = "dev/user/backendState-proj-dev" # 可自訂檔案路徑
    region = "us-east-2"
    dynamodb_table = "dev_application_dynamodb01"
    encrypt = true
  }
}
# Configure the AWS Provider
provider "aws" {
  region  = "us-east-2"
  version = "~> 2.55"
}

# AWS IAM User
resource "aws_iam_user" "my_iam_user" {
  name = "my_iam_user_demo"
}

```
>### 修改前要記得先執行`terraform init`進行初始化

![](https://i.imgur.com/Ftjcw0A.png)
系統會提示是否將狀態複製到新的狀態。
初始化完成後重新刷新頁面，會看到原本**backendState-proj-dev**的檔案路徑變成在`dev/user/`這個路徑下。
![](https://i.imgur.com/dcZ6cnm.png)

## 建置多個workspace
### 查看當前的workspace
```bash=
terraform workspace show
```
尚未建立其他workspace的情況下，workspace名稱為**default**。

### 建立新workspace
語法如下，**workspace**為自定的名稱
```bash=
terraform workspace new workspace
```
範例以`prod-dev`作為新的workspace名稱
```bash=
terraform workspace new prod-dev
```
![](https://i.imgur.com/5yQMQ9K.png)
建立完新的workspace後要進行初始化
```bash=
terraform init
```
回到AWS S3 console介面會發現新增`env:`資料夾，裡面存放剛才建立的workspace
![](https://i.imgur.com/QqF7Iun.png)
### 查看`env:`資料夾
![](https://i.imgur.com/IKBc5Xq.png)

不過這邊要注意一個地方，點開剛才建立workspace裡的檔案

![](https://i.imgur.com/wDqjAxp.png)
會發現物件是空的！
![](https://i.imgur.com/YEKKkQj.png)
> ### 怎麼回事？？？

因為我們把IAM User寫死了，造成與前一個workspace使用同一組IAM User name，因此將`aws_iam_user`這個resource修改為動態的IAM User，以當前的workspace name作為前綴
```bash=
resource "aws_iam_user" "my_iam_user" {
  # name = "my_iam_user_demo"
  name = "${terraform.workspace}_my_iam_user_demo"
}
```
接著執行`terraform plan`觀察變化
![](https://i.imgur.com/GI6YiLB.png)
`prod-dev`變為前綴名稱，接著執行`terraform apply`
回到workspace裡的檔案：
![](https://i.imgur.com/ap3yeBY.png)
這一次物件裡面就不是空的～～～之後不管在其他workspace建立的IAM User也不會衝突！

### 切換至特定的workspace
如果要切回原本的workspace，語法如下方，**workspace**可替換成目前存在的workspace名稱
```bash=
terraform workspace select workspace
```
以切換回**default**為例：
```bash=
terraform workspace select default
```
![](https://i.imgur.com/8aFgWs2.png)
### 查看所有的workspace
```bash=
terraform workspace list
```
![](https://i.imgur.com/oqkPz40.png)
`*`之處表當前所處的workspace

>除了使用指令查看當前所處的workspace之外，也可以到專案資料夾下的`.terraform`目錄裡面有一個名為`environment`的檔案，裡面會顯示當前workspace名稱。

最終的檔案目錄結構如下:
![](https://i.imgur.com/mxGa2uG.png)


