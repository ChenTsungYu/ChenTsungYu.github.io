---
title: "[AWS] Global Infrastructure"
catalog: true
date: 2020/03/03 17:00:10
tags: AWS
categories: [Cloud]
toc: true
---
<!-- toc -->
# 前言
前一篇初步理解AWS的架構及市場之後，接著探討AWS在全國佈建的基礎建設吧！
<!--more-->
# Concept
## Region & Available Zone & Edge Location
AWS的基礎設施是以區域(Region)與可用區域(Available Zone)為中心來建置。
* 區域(**Region**)地球上有多個可用區域的實體位置，多個Region之間由多條海纜佈建成一個全球網。
案例: 選擇客戶的客群節點靠近的區域，降低延遲

* 可用區域(**Available Zone**; 簡稱AZ): 由一或多個分散的資料中心(Data Center)所組成，而每個AZ就是一個可獨立運作的資料中心(可視為一個building)，放置於不同的獨立機構。![](https://i.imgur.com/IQHIoUO.png)

* 端點(**Edge Location**)為AWS服務裡面的最尾端。它可以與可用區域(AZ)互動，對所需資料進行快取，加速資料內容的讀取和使用，同時也是AWS CloudFront這個服務可運作的**最小單位**，目前分佈在42個國家/地區、84 個城市共 216 個連接點。

![](https://i.imgur.com/VqGBDTb.png)

### 幾個重點
AWS 的Global Infrastructure有幾個特點:
* 提供較高的穩定性
目前有已推出22個區域, 69個可用區域及200多個節點。
由於每個Region都是各自獨立，有助於提升伺服器的穩定性及容錯力。
* 計價差異
不同區域所提供的服務價格會有些微差異，故選擇區域時，通常都是看在哪裡能提供最快的服務或是挑選最便宜的區域
* 高可用性(High Availability; 簡稱: HA)
一個區域(Region)可能包含多個AZ，而多個AZ提供異地同步備份，達到高可用性，同時也有較低的延遲性
![](https://i.imgur.com/Alh7hzq.png) 
[圖片源](https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Concepts.MultiAZ.html)
以上圖為例：
上圖範例是AWS RDS(關聯式資料庫服務)進行異地備份，主要資料庫實體(Instance)會跨AZ，同步備份到其他AZ進行待命(Stanby)，達到資料備援的作用。

> 值得注意的是，不同的等級的基礎設施(Infra)則會影響用戶的花費以及對該區域的服務品質(quality)，所以在使用服務前務必慎選區域，減少不必要的問題。

