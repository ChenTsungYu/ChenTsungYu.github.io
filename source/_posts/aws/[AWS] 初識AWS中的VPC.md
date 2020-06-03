---
title: "[AWS] 初識AWS中的VPC"
date: 2020-04-28
tags: [AWS, w3HexSchool]
categories: [Cloud]
toc: true
---

>鼠年全馬鐵人挑戰 - WEEK 13

![](https://i.imgur.com/e85z7IM.jpg)
<!--toc-->
# 前言
本文做為有關VPC的閱讀筆記
<!--more-->
# 何謂VPC
VPC全名是Virtual Private Cloud，是一個建立在雲端上的封閉區域網路，一般來說，基於安全考量，公司都會有自己的一套內部網路環境，對外網路會有一台防火牆保護，避免外部隨意連進來，在防火牆內就像是一個VPC。
想像一種情況，若有公司內部的資料庫開放讓外部進行連線，只要有正確的帳號密碼，誰都可以連進來，那將是非常危險的事情。若是即使帳號密碼正確，但只有某幾台機器可以連進來，安全性相對提高，後者即是VPC的主要功能。
VPC中可以選擇自己的 IP 地址範圍、建立子網路(subnet)、配置路由表(Route Table)和網路閘道(Internet Gateway)，以及選擇公有和私有網路

> 每個Region的網路互相獨立，同一個Region可同時建立多個VPC，VPC間彼此獨立不干擾。

# Amazon VPC 包含哪些部分？
## Elastic IP(EIP):
即固定IP，以AWS EC2來說，預設是使用變動的IP，每次重啟EC2時都會賦予新的IP，若要讓EC2綁定一組固定IP，就可以在EC2的管理介面中配發一組EIP給他。
### 需注意的重點：
Elastic IP在每個Region剛開始只會給5個額度，用完需另外申請。
## Subnet(子網路): 
Subnet就是在VPC的網段下，再細分不同的子網段。Subnet可區分為**Public**、**Private**和**Vpn-Only**三種，以公司內部網路來看，會切成不同的子網段。
**Public**: 直接對外服務，擁有Elastic IP(EIP)，透過 Internet Gateway可直接訪問Internet
**Private**: 私有的子網段，該網段只能與內部網路溝通，無法直接訪問 Internet
**VPN-Only**：只允許特定的VPN連接
### Subnet需注意的幾個重點：
* 每個subnet的CIDR Block不能重複，也不能大於VPC
* 一般來說，subnet除了切開CIDR外，還會區分不同的AZ(可用區域)，避免單一個區域內機房失效的問題

## Route Table(路由表):
一般網路封包在傳送時，起點到終點位置的傳輸路徑由Router來決定，而Route Table可決定往特定網段(Destination)的封包如何傳送(Target)
### 常見Target類型：
* local
* NAT Portal
* internet gateway(簡稱igw)
* virtual gateway(簡稱vgw)可用在連接企業內部的VPN

### 幾個注意的重點
* 每個 subnet 只能指定零或一張 route table
* 可以設其中一張route table為預設值；讓未指定的subnet都參照它

## Internet Gateway:
讓VPC與外部網際網路溝通的通道，Route Table會將封包往 Gateway送，即可對外進行溝通。
## NAT
全名為**Network Address Translation**，主要的功能是連結內部與外部的網路，如區域網路內的服務器，只允許內對外的連線，但不允許外對內的連線，皆透過同一個對外IP來進行對外部的溝通。
### 注意的重點:
* 在**Public subnet**建立一個NAT Gateway
* NAT Gateway需指定一組EIP，建立外部連線

## Endpoint(端點)
在**Private subnet**內，連接AWS某些Service時 e.g. S3，可透過建置Endpoint來串接。

## VPC需注意的幾個重點：
* VPC在設定之後不能改，要改只能重建
* 每個區域的每個AWS帳戶最多5個VPC，要更多的話需要跟AWS發ticket
* VPC 的subnet可以從最小`/28`到最大`/16`，即最少可以開14個IP addresses的VPC，以及最大65534個IP addresses的VPC。
* 每個VPC可擁有200 subnets
* 每個VPC都是獨立環境，可透過NAT來連接不同VPC
* VPC的計費：
如果是建立、使用VPC本身的話不收其他費用。但VPC內包含其他AWS服務的話，如：EC2，則會收取其他Services的使用費，依照這些資源公佈的費率計算，可能還需支付資料傳輸費用。

# 範例討論
最後以官方文件的範例來做討論。
![](https://i.imgur.com/gwjvpnl.png)
圖片取自[官方文件](https://docs.aws.amazon.com/vpc/latest/userguide/how-it-works.html)
上圖為官方給的預設VPC架構圖，可從AWS Console進行點擊
![](https://i.imgur.com/eYzBgRO.png)
預設的架構會是：
* 預設VPC會發的CIDR為`172.31.0.0/16`
* 預設替每一個AZ分配一個`/20`的Subnet: `172.31.0.0/20`、`172.31.16.0/20`
* 兩個Subnet內各有一台EC2 instance，即`172.31.0.5`、`172.31.16.5`
* EC2 instance會自動被分配一組外部IP，即圖片中的Public IP: `203.0.113.17`、`203.0.113.23`，只要重新開機，會自動重新分配新的IP。
* 透過**Internet Gateway**建立對外網的連線，即`igw-id`
* 兩個Subnet都會遵循Main route table建立的路徑，只要收件者IP是`172.31.0.0/16`的網段，網路封包就會往內網送；其餘封包(`0.0.0.0/0`表任意連線)，就往Internet Gateway發送。

# 參考文件
* [Official Docs](https://aws.amazon.com/tw/vpc/faqs/)
* [AWS 內 VPC 與 Subnet 規劃、理解](https://shazi.info/aws-%E5%85%A7-vpc-%E8%88%87-subnet-%E8%A6%8F%E5%8A%83%E3%80%81%E7%90%86%E8%A7%A3/)
