---
title: "[ELK] Hello! ELK"
catalog: true
date: 2020/05/16 23:51:53
tags: [DevOps, ELK, w3HexSchool, Elasticsearch]
categories: [DevOps]
toc: true
---
> 鼠年全馬鐵人挑戰 - WEEK 15
<!--toc-->
![](https://i.imgur.com/ySo1b1H.png)
[圖片源](https://www.mile.cloud/zh-hant/elastic/)
# 前言
最近因為實習環境需要接觸ELK，故藉此機會來筆記一下，加深學習印象。
<!--more-->
# 什麼是ELK？
其實大家所稱的ELK並非一套軟體，而是由三個不同的開源軟體的字首縮寫所構成的套件，三者為:
* Logstash: 蒐集日誌(log)，為日誌資料處理系統，可同時從多個來源獲取資料
* Elasticsearch: 強大的搜尋功能
* Kibana: 將資料視覺化的報表軟體

ELK時常被應用在解決搜尋、紀錄、保安分析、指標分析、營運分析等問題，越來越多企業採用ELK，可見[此篇文章](https://medium.com/elkplus/%E8%AA%B0%E5%9C%A8%E7%94%A8elk-d8924de3c7b6)的整理。
## ELK workflow
ELK的整體運作流程可參考下方圖片:
![](https://i.imgur.com/HtBGNps.png) [圖片源](https://www.howtoforge.com/tutorial/how-to-setup-elk-logstash-as-centralized-log-management-server/)
整體運作流程是將設備的日誌，透過檔案或系統的log傳送給Logstash進行解析，再存入ElasticSearch進行查詢/統計，最後由Kibana將統計結果以資料視覺化呈現。
# 安裝
對ELK有初步認識後就來動手安裝吧！
## Elasticsearch
至[官方載點](https://www.elastic.co/guide/en/elasticsearch/reference/current/targz.html)找到適合自己作業系統的檔案進行下載，Mac的話，下載完`tar.gz`的檔案後，至終端機執行下方指令解壓縮
```bash=
tar -xzf elasticsearch-7.6.2-darwin-x86_64.tar.gz
```
接著切換到`elasticsearch-7.6.2`目錄下執行`bin`資料夾下的`elasticsearch`執行檔
```bash=
./bin/elasticsearch
```
### 測試是否安裝成功
預設會開在port號9200，到另外一個終端機上執行
```bash=
curl 127.0.0.1:9200
```
![](https://i.imgur.com/z8IBmkj.png)
如果成功的話會回傳一個JSON格式的資料
## Kibana
至[官方載點](https://www.elastic.co/downloads/kibana)找到適合自己作業系統的檔案進行下載，Mac的話，下載完`tar.gz`的檔案後，至終端機執行下方指令解壓縮

```bash=
tar -xzf kibana-7.6.2-linux-x86_64.tar.gz
```
接著切換到`kibana-7.6.1-darwin-x86_64`目錄下執行`bin`資料夾下的`kibana`執行檔
```bash=
./bin/kibana
```
> ### 注意: 要先把elasticsearch 給run起來後再起kibana

預設會開在port號5601，訪問`http://localhost:5601`可確任是否有成功啟動kibana
![](https://i.imgur.com/BaetlIz.png)
## LogStash
Logstash 是一套 Log 分析框架，可以幫助我們處理各式各樣的 Log。[官方載點](https://www.elastic.co/fr/downloads/logstash)

# Elasticsearch basic architecture
前面安裝完ELK後，接著要討論Elasticsearch的基礎架構
![](https://i.imgur.com/qD8dsyQ.png)
## Node 節點
上圖的每個**節點(Node)** 就是一個Elasticsearch的**實例(Instance)**，用於儲存資料，一台機器可以同時啟用多個Node。
## Cluster 叢集
而**叢集(Cluster)** 是由一個或者多個擁有相同**cluster name**配置的Node所組成，在預設的情況下，每個Cluster之間是互相獨立的。

當然，如果要跨叢集(Cross-Cluster)進行搜尋也是可以，不過實際上比較少會這樣使用，通常同時啟用多個Cluster是為了不同目的，如：一個Cluster用於搜尋電商的AP，另一個Cluster則負責AP的效能管理(Performance Management)。
## Document 文檔
![](https://i.imgur.com/hS87946.png)
稱作**文檔**，是搜尋資料的最小單元，以**JSON**作為儲存的資料格式，在一個`Index`或者`Type`中，可以存儲很多個`document`。
## index 索引
![](https://i.imgur.com/tnkJHtk.png)
`index`在Elasticsearch中相當於一個資料庫，所以`index`底下會包含多個document

# 整理幾個重要的相關名詞
* `index`: 在Elasticsearch中`index`相當於一個資料庫。
* `type`: 相當於資料庫中的一個表。 
* `id`: 類似資料庫的**主鍵(Primary Key)**，作為唯一的值，`document`中的的ID可以由Elasticsearch自動分配，或手動添加到index時分配給它們。 
* `node`: 節點是Elasticsearch實例(Instance)，可以看成叢集(Cluster)中的一個節點。
  一台機器可以執行多個實例，但是同一台機器上的實例在配置上要確保http和tcp Port不同。 
* `cluster`: 表一個叢集，叢集中有多個節點，其中有一個會被選爲主節點，這個主節點是可以通過選舉産生的，主從節點是對於集群內部來說的。 
* `document`: 稱作**文檔**，是搜尋資料的最小單元，可能是 log 文件中的一筆紀錄 ，以**JSON**（由一堆 `Key:Value` 的資料組成）作為儲存的資料格式。在一個`Index`或者Type中，可以存儲很多個`document`。雖然`document`是儲存在`Index`中，但實際上，它必需被索引或分配到`Index`中的一個Type上。

# 參閱
* [What is an Elasticsearch Index?](https://www.elastic.co/blog/what-is-an-elasticsearch-index)
* [Introduction to the Elasticsearch Architecture](https://codingexplained.com/coding/elasticsearch/introduction-elasticsearch-architecture)