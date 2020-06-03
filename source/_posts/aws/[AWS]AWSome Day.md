---
title: "[AWS] AWSome Day Online Conference"
date: 2020-04-29
tags: [AWS, Conference]
categories: [Conference]
toc: true
---
<!-- toc -->
![](https://i.imgur.com/JyE7SVS.png)
# 前言
[AWSome Day](https://aws.amazon.com/tw/events/awsome-day-online-conference-tw-2020/)是由官方所舉辦AWS Cloud的免費培訓課程，今年因為疫情的關係不同以往，採用Online Conference的方式，課程中會有專業講師將會深入淺出地以實作示範帶大家了解AWS的核心服務。 
<!--more-->
# 課程安排
其中課程講解內容會包括:
* 運算(Compute)
* 儲存(Storage)
* 資料庫(Database)
* 網路(Networking)
* AWS 資安、身份及訪問管理(Security)
* AWS 資料庫(Database)
* 大數據和機器學習(Big Data & Machine Learning)
* AWS 擴展及管理工具

課程前面會提及AWS的歷史、益處還有概略說一下架構
![](https://i.imgur.com/3Mqw7Lh.png)
上面的圖片可以看到左邊是傳統可能在地端會使用的工具或服務，AWS也有提供相對應功能的雲服務。
以Security來說，公司的**防火牆(Firewalls)** 對應到AWS的服務叫做**Security Group**，權限管理(**Administraors**)的部分則是使用**AWS IAM**
## 另外補充一下AWS常見服務
* AWS Route53: AWS的DNS服務。
* AWS Cloudfront: 是AWS Edge location上的一個服務，類似CDN，加速網路交付的內容。

## AWS的全球基礎建設(AWS Global Infrastructure)
可以參考我之前寫過的[一篇](https://chentsungyu.github.io/2020/03/03/aws/%5BAWS%5D%20Global%20Infrastructure/)
# AWS 核心服務
接著是討論AWS幾個比較重要且常見的核心服務
## 計算方面
### EC2
雲端上的虛擬機(Virtual Machine)，創建EC2可以客製化不同的規格，例如選擇AMI(看要哪種作業系統)、規格(CPU、Memory、Storage)、配置網路(IP address, security groups、key pair)等，操作流程可參考我之前寫的[[AWS] 用SSH連接EC2](https://chentsungyu.github.io/2020/03/25/aws/%5BAWS%5D%20%E7%94%A8SSH%E9%80%A3%E6%8E%A5EC2/)
EC2其中一個好處是**自動擴展**，可以依需求做Scale In/Scale Out，也就是會依照所需流量調整EC2的多寡，做有效的資源利用。
EC2的計費方式有很多種
![](https://i.imgur.com/DFDmHp2.png)


# AWS Serverless Service
Serverless為無伺服器的服務
## Lambda
採用Event Trigger，依據code的內容去執行，未執行即showdown，AWS推出Lambda並非用來取代EC2，Lambda也有其限制，EC2還是有自己的市場。
優點：
* 省去管理Server的成本
* 只有被trigger才會計費
### 流程
![](https://i.imgur.com/zVT1WbA.png)
### 範例
![](https://i.imgur.com/PAZlzdG.png)

# VPC
每個Region都有預設的VPC
![](https://i.imgur.com/iSW1dvt.png)
App Server
混合雲架構 DB從AWS Gateway來連接客戶的網路

# AWS 的儲存服務
## S3
儲存空間無上限
耐久性高，預估是99.999999999% 
object storage的形式儲存，可儲存多種不同形式的資料，如：
* Application file
* Media

### 結構
![](https://i.imgur.com/ZMzqgyj.png)
Bucket類似folder
object類似檔案
S3屬於託管的服務，不需要花心思在維護上，如:故障
### 原因
放在Region中跨AZ，需要該Region的所有AZ都故障才可能會使資料遺失 => 保存三個以上的備份
Region內有多個Region AZ

### 安全性
![](https://i.imgur.com/tWjp6Dl.png)
設置Bucket policy，來做權限控管。
### Versioning
保留紀錄，預設是關閉的(因為要另外儲存使用紀錄，造成額外費用)
### S3 等級
迎合不同屬性的資料分不同的等級(Class)，主要下方三者
![](https://i.imgur.com/piRF8bs.png)
考量點:
performance、Accessibility
### LifeCycle Policy
節省管理時間、有效控制成本

> Bucket Name必須是Global Unique，

### Demo
![](https://i.imgur.com/i7bWmRE.png)
![](https://i.imgur.com/5Z0Grut.png)
![](https://i.imgur.com/fioqEng.png)
選lifecycle
![](https://i.imgur.com/Oa9uAO9.png)

## EBS(Elastic Block Store)
儲存作業系統、應用程式類似本地的硬碟，冗餘(redundant)備份是在一個AZ
![](https://i.imgur.com/dLYV2C3.png)
![](https://i.imgur.com/54nAvfO.jpg)


EBS與EC2兩者的lifecycle可以分開，看個人設定。好比把電腦硬碟拔下來，裝在別台電腦上
![](https://i.imgur.com/jeYtkCX.png)

# AWS資安
相關的安全合規: AWS Artifact
## 共同責任模型(Shared Responsibility Model)
![](https://i.imgur.com/kIlMncC.png)
AWS與客戶之間的責任歸屬，會依選擇的服務不同，承擔的責任界線(圖片中的虛線)會跟著改變，如EC2，使用者要負責的地方就多一些。
這個模型是相當重要的，這會關係到問題發生時，判斷責任歸屬很重要的依據，而這在AWS Certificate也是幾乎必考，權重占比較多的重點考題。

### 範例模型

![](https://i.imgur.com/rJTxReN.png)
* SSL 傳送資料
* IAM驗證
* Cloudtrail: 監控API使用的情形

#### Multi-Tier Security Groups(多層的Security Groups)
![](https://i.imgur.com/oNRZBB9.png)
兩種SG，決定Server要採哪種方式連接
* HTTP
* Bastion Host: 俗稱跳板機

## IAM
主要做認證與授權
![](https://i.imgur.com/DQNargD.png)
認證方式：
* Console
* CLI
* SDK API


### User
個別使用者
### Group
可以將擁有相同權限的User
### Policies
* 採JSON格式
![](https://i.imgur.com/DnZJmkN.png)
* 用於assign給Users、Groups或Roles
![](https://i.imgur.com/wAVQb6O.png)
* 用於assign給Roles

### Roles
Role裡面放的是AWS的資源，可以attach不同的policy
![](https://i.imgur.com/1mbEbR7.png)
IAM Role會發有時效性的Token，S3 Service
>User、Group做驗證(你是誰)，Policies做授權(你可以做什麼)

### Best Practice
* Delete AWS root account access keys
* Activate multi-factor authentication (MFA): 
雙重認證，如綁定其他的軟體，輸入驗證碼。
* Only give IAM users permissions they need: 
即最小權限原則 => principle of least privilege
* Use roles for applications

官方提供的IAM[最佳實踐](https://docs.aws.amazon.com/IAM/latest/UserGuide/best-practices.html)
#### 辨認是root account還是IAM User
登入方式是否用AcoountID
# AWS Database服務
## RDS(Relational Database Service)
為何要使用RDS?
RDS是託管的服務
- 自動備份(Multi AZ、可跨Region)
- 穩定性高(跨AZ 做備份)
RDS會綁定VPC
## DynamoDB
AWS NoSQL的資料庫
## Aurora
AWS 基於自己的平台上開發的，可與MySQL、PostgreSQL兩種DB
**HA架構: 跨AZ做replica**
![](https://i.imgur.com/jT6mo6G.png)
### Aurora Serverless
Aurora新推出的無伺服器服務
# AWS 跨入AI領域
* Amazon Go
* 無人機
* 推薦系統
* 物流
* 智慧音箱

Amazon Fraud Detector : 偵測詐騙問題
## AI的難題
![](https://i.imgur.com/jANNAIK.png)
* 大量的資料
* 訓練模型：要用哪種演算法？如何去tune trainning model
* 評估預測結果
### SageMaker
ML的託管平台
Prepare、Build、Train & Tune 、Deploy & Manage
![](https://i.imgur.com/MQkOqG8.png)

# AWS 擴展/管理工具
Use Case
![](https://i.imgur.com/uy8zshu.png)
## ELB(附載均衡器)
可用於多個目標 (例如 Amazon EC2 instance、IP Address) 之間自動分配傳入的應用程式流量，而客戶(Client)端與ELB溝通時，會透過DNS。另外在創建ELB時，可在單一或跨AZ，處理應用程式的流量。
* 可作健康偵測(確保資料派送給非故障的EC2)
* 分散流量

## Auto Scaling
* 自動調整EC2的容量
* 透過CloudWatch來判定EC2要Scale In或scale Out(監控CPU使用量)
* 透過Scheduling，事先規劃(Scheduled Event)

## AWS CloudWatch
架構
![](https://i.imgur.com/gk3YMum.png)

## ELB+Auto Scaling+CloudWatch的組合
![](https://i.imgur.com/qciDEG9.png)

# AWS Trusted Advisor
提供最佳實踐的建議，可以看到的服務多寡會跟Support Plane level有關
- Cost optimization 
- Security
- Fault tolerance
- Performance improvement.

以上圖片多數取自於官方投影片