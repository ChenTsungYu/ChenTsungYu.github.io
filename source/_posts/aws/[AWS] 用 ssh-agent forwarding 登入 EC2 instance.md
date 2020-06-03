---
title: "[AWS] 用 ssh-agent forwarding 登入 EC2 instance"
catalog: true
date: 2020/05/25
tags: [AWS,w3HexSchool]
categories: [Cloud]
toc: true
---

> 鼠年全馬鐵人挑戰 - WEEK 17
<!--tablet-->
# 前言
在實習做的專案中，要用Terraform撰寫`.tf`腳本建置VPC，具體的架構類似下方的圖，實作的過程中因為要用ssh連EC2 Instances，藉此機會筆記一下用ssh連機器的正確做法，避免犯相同錯誤。另外，本篇的做法適用於Linux/MacOS，Windows作法可參考本文最後附上的參考連結。
<!--more-->
# 情境
假設今天要建一個VPC環境，在此環境下有兩台EC2 Instances，位於Public subnet內的EC2可以供外部進行連線，而Private subnet內的EC2只能透過Public subnet內的EC2來連線，Public subnet下的EC2稱之為「跳板機」(bastion)，可看下圖說明
[Resource](https://medium.com/tensult/creating-vpc-endpoint-for-amazon-s3-using-terraform-7a15c840d36f)
![](https://i.imgur.com/d7eM9o7.jpg)
要實作ssh連入bastion再連到Private EC2，之前的作法都是:
`private key` 傳入 bastion，再把bastion內的`private key`用 ssh -i `private key` 的方式登入 Private EC2。

不過...

ssh 的 Private key 是非常機密的資訊，應只保留在本地電腦，不應放在 bastion 主機內使用。


更安全的做法是: 使用 ssh-agent 做forwarding
參考本篇[文章](https://aws.amazon.com/tw/blogs/security/securely-connect-to-linux-instances-running-in-a-private-amazon-vpc/)中強調的重點:

>You should enable SSH agent forwarding with caution. When you set up agent forwarding, a socket file is created on the forwarding host, which is the mechanism by which the key can be forwarded to your destination. Another user on the system with the ability to modify files could potentially use this key to authenticate as you.


從「本地端」的 Private key 在 bastion 進行 forwarding，在 bastion 使用 ssh private key 的時候就不需要再使用 `-i` 來指定連接的 key。

# ssh-agent
ssh-agent是一個讓你不把Private key上傳到伺服器上，就可以完成遠端登入的工具，使我們可在多個伺服器之間來去自如。

## 開啟ssh-agent
```bash=
eval $(ssh-agent -s)
```
執行上述指令會回傳`Agent pid ***`

## 添加Private key
將key pair 加入keychain
```bash=
ssh-add myKeyPair.pem
```
![](https://i.imgur.com/YX93Ajh.png)

## 查看已存儲的Private key
```bash=
ssh-add -L
```
執行上述指令會顯示Private key轉成 public key的資訊

## 遠端登入
以前的登入方式都採`ssh -i *.pem`的方式
```bash=
ssh -i "myKeyPair.pem" ami@ec2publicDNS
```
![](https://i.imgur.com/vH976jb.png)
改成下方的方式連
```bash=
ssh –A user@<bastion-IP-address or DNS-entry>
```
`bastion-IP-address`是放Public Subnet的Instance IP
上圖範例來說，就是在終端機執行下方指令連到bastion。
```bash=
ssh -A ubuntu@ec2-3-235-159-222.compute-1.amazonaws.com
```
成功連入bastion的畫面
![](https://i.imgur.com/iEKdhWq.png)

## 連入Private Instance
```bash=
ssh ami@Private IP
```
![](https://i.imgur.com/obdjRAV.png)
以我的測試的Private EC2 Instance為例
```bash=
ssh ubuntu@10.0.2.171
```
成功連入Private EC2 Instance的畫面
![](https://i.imgur.com/ooaSK2q.png)

# 參閱
* [Securely Connect to Linux Instances Running in a Private Amazon VPC](https://aws.amazon.com/tw/blogs/security/securely-connect-to-linux-instances-running-in-a-private-amazon-vpc/)
* [AWS 建議用 ssh-agent forwarding 登入你的 EC2 instance](https://shazi.info/aws-%E5%BB%BA%E8%AD%B0%E7%94%A8-ssh-agent-forwarding-%E7%99%BB%E5%85%A5%E4%BD%A0%E7%9A%84-ec2-instance/)