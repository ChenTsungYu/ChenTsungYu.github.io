---
title: "[AWS] 初探AWS"
catalog: true
date: 2020/03/02 17:00:10
tags: AWS
categories: [Cloud]
toc: true
---
<!-- toc -->
# 前言
近幾年雲端供應商大量投資雲端基礎建設及雲端計算，為了解決客戶的痛點，不斷地推出更多更完善的服務，隨著雲端服務在市場的接受度及普遍度提升，越來越多企業將自家服務上雲，乘著這股潮流來多了解一下雲端服務!
<!--more-->

# Cloud Computing
雲端運算式透過網路連線進行利用網路資源，做各式的資源運算，我們可以透過租用的方式共享軟硬體，並在不同終端設備及裝置上享有這些服務。

企業或是一般大眾可依據自身需求，向雲端服務的供應商購買能夠滿足他們需求的服務，不須從頭開始採購硬體設備,配置網路及架設環境等，購買服務後可立即享有目標資源。

另一方面來說，用戶其實可以不需要了解複雜的雲計算所需的基礎設施，甚至不需要有深厚的專業知識，大幅降低用戶的使用門檻，同時提升用戶的營運效率，另外，雲服務有個"用多少, 付多少"的特性，解決傳統用戶因使用效率不佳而造成資源浪費的問題。

# 指標供應商
目前雲服務供應商前三大影響力的分別是: Amazon(AWS), Microsoft(Azure), Google(GCP)，這三家大廠佔雲端市場極大的比例。
來看下圖2019的調查報告可窺知一二。[Ref](https://kinsta.com/blog/google-cloud-vs-azure/)

![](https://i.imgur.com/GjFCgvH.png)


# 雲服務架構種類
- IaaS: 基礎架構即服務
- PaaS: 平台即服務
- SaaS: 軟體即服務

## IaaS
雲端服務供應商提供的服務(如AWS, GCP)包含網路建置, Server採購等硬體設施，或是運用虛擬化的技術，公司只需專注在硬體設備外的項目即可，如作業系統 , 應用程式等等。

傳統公司作法可能會是內部自建機房，但伴隨而來的維護問題，大幅提高企業成本，加上雲端虛擬技術逐漸蓬勃發展，開始推動這類服務，解決公司在基礎建設方面所遇到的困難點。
### 優點
* 靈活度高且可以擴展
* 可多人使用
* 優化資源的利用率

範例服務: EC2
為AWS提供了虛擬服務器，EC2的用戶不需擁有實體服務器。

## PaaS
PaaS服務通常會包含IaaS的範圍，也就是除了基礎架構服務器，儲存和網路外，還將作業系統, 開發環境交由廠商管理，企業可以專注在Application的開發與部署。

### 優點
* 靈活度高且可以擴展
* 可多人使用
* 無需具備廣泛的系統管理知識即可輕鬆運行

範例服務: [Elastic Beanstalk](https://aws.amazon.com/elasticbeanstalk/?nc1=h_ls)

## SaaS
SaaS服務則是連同Application都幫你管理好，用戶可以直接使用。


雲服務的類型與傳統相比可看下圖
![](https://i.imgur.com/A9ijXd8.png)
[圖片源](https://www.cloudindustry.com/au/cloud-computing-models-demystified/)

上面的比較圖可以概略知道傳統的本地部署(On-Premises)採用虛擬化技術的管理工具，軟硬體的管理,維護都是企業自己做。

如果以分層的角度來看，金字塔最底層為IaaS往上依序為PaaS, SaaS
![](https://i.imgur.com/WmAqQQb.png)

[圖片源](https://www.researchgate.net/figure/Illustration-of-cloud-computing-layers-as-a-collection-of-services-XaaS_fig3_236218233)


[這篇文章](https://www.bigcommerce.com/blog/saas-vs-paas-vs-iaas/#the-three-types-of-cloud-computing-service-models-explained)有更詳細的介紹。

# AWS成本定價
AWS的費用計算可以簡單用一句話總結: "用多少算多少"
計算的種類大略分幾類:
- 使用時間
- 使用單位
- 占用的資源
- 使用方式

以EC2為例:
![](https://i.imgur.com/F4ts4Zf.jpg)
[圖片源](https://www.slideshare.net/AmazonWebServices/reducing-the-total-cost-of-it-infrastructure-with-aws-cloud-economics)
如果是有長期穩定的需求，相較於On Demand，可以選擇RI([Reserved Instance](https://aws.amazon.com/ec2/pricing/reserved-instances/?nc1=h_ls))或是[Spot](https://aws.amazon.com/tw/ec2/spot/)方案，享有更好的折扣。

# 官方認證考試
為了推廣自家服務，AWS官方推出一系列的考證制度，另一方面也可以作為對服務了解程度的參考依據。

# 免費試用帳號
AWS推出為期一年的免費帳號([註冊連結點我](https://aws.amazon.com/tw/free/?all-free-tier.sort-by=item.additionalFields.SortRank&all-free-tier.sort-order=asc))，想玩玩看AWS服務的話由此註冊。

# 費用計算
官方很貼心的提供兩種計算機，讓用戶可以快速計算費用
* [每月成本簡易計算器](https://calculator.s3.amazonaws.com/index.html)
可讓用戶估計單一或多個服務的價格，另外也提供使用範本來估算完整服務價格。

* [TCO 計算器](https://aws.amazon.com/tw/tco-calculator/)
預估使用 AWS所節省的費用，並提供比較後的詳細報告，屬於全面性的。

# 參閱
[Overview of Amazon Web Services](https://d1.awsstatic.com/whitepapers/aws-overview.pdf?did=wp_card&trk=wp_card)