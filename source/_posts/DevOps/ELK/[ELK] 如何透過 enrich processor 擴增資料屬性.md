---
title: "[ELK] 如何透過 enrich processor 擴增資料屬性"
catalog: true
date: 2021/04/17 23:51:53
tags: [DevOps, ELK, Elasticsearch]
categories: [DevOps]
toc: true
---
# 前言
在資料處理的過程中，會針對資料源的不完整或是冗余的資料訂定 pipelines 來做預處理，Elastic 官方提供 elastic ingest pipeline 功能，將一連串的制定好的處理器(Processors) 匯集在一個 pipeline ，對來源資料做結構化處理。

我們可以設置多個獨立的 Processors 在同個 Pipeline 裡面，在來源資料送進 Elasticsearch 做 indexing 之前，會經過指定的 Pipeline， Pipeline 裡含有多個 Processors， Processor 可以做的事情很多，如: 重新命名、新增欄位、資料型別&大小寫轉換，甚至支援正規表達式，可以做複雜的判斷式。

本文主要示範其中一種 Processor - Enrich Processor
<!--more-->
# Enrich Processor
Enrich Processor 的功能是針對傳入資料源(elasticsearch 中的 document)擴增資料屬性，下方圖片展示整個擴增資料的運作流程：
![](https://i.imgur.com/ymrYERY.png)
由上圖可知資料源(incoming documnet)送進 Elasticsearch 前，經過預先設置好的 pipeline，pipeline 裡面包含多個定義好且相互獨立的 processor 。

**Enrich Processor** 可選定已經存在於 Elasticsearch 的某個 index，指定被選定的 index 某個欄位作為參考(**注意: 這個參考欄位必須是來源 documents 也有的欄位**)，將被選定的 index 中的其他欄位 mapping 至來源 document，形成新的資料欄位。
 
看完前面說明，對 processor 有初步概念後，接著來實作吧！
# Let's get technical at the Hands-on Labs
藉由官方範例來實做一個 Enrich Processor。
以下範例皆於 Kibana 的 Dev tool 進行：
## 新建 Index
下述方法來建立名為 postal_codes 的 index

```
PUT /postal_codes
{
  "mappings": {
    "properties": {
      "location": {
        "type": "geo_shape"
      },
      "postal_code": {
        "type": "keyword"
      }
    }
  }
}
```
## 新增 document
向 postal_codes 裡新增一個 document 中，包含 post_code 及相關位置的資料
```
PUT /postal_codes/_doc/1?refresh=wait_for
{
  "location": {
    "type": "envelope",
    "coordinates": [ [ 13.0, 53.0 ], [ 14.0, 52.0 ] ]
  },
  "postal_code": "96598"
}
```

可透過 `GET` 方法來查詢 index 內容
```
GET /postal_codes/_search
```
## 新建 enrich policy
透過 `enrich policy API` 來制定 enrich policy 給新建立的 enrich processor，enrich policy 必須涵蓋：
- 一個或多個來源 index： 已存在的 elasticsearch 裡的 index
- match_field: 用於配對的參考欄位(field)，這個欄位必須是來源 document 和已存在的 document 共有的
- enrich_fields：配對後要新增至來源 document 中的欄位。這些欄位必須存在來源 index 裡

接著來建立新的 policy - `postal_policy`
```
PUT /_enrich/policy/postal_policy
{
  "geo_match": {
    "indices": "postal_codes",
    "match_field": "location",
    "enrich_fields": [ "location", "postal_code" ]
  }
}
```

上述範例表示透過 `geo_match` 的方法，來源 index（source index）- `postal_codes` 會透過 `location` 欄位來進行配對，如果配對到 指定的 field name ，則會將 `location` 及 `postal_code` 這兩個欄位一同添加到來源 index 的 document 裡面

其他 match 方法可參考[文件](https://www.elastic.co/guide/en/elasticsearch/reference/7.12/put-enrich-policy-api.html)

## 執行 enrich policy： execute enrich policy
執行 `execute enrich policy API` 為該 enrich policy 建一個來源 index
執行成功回傳下述結果：
```json=
{
  "status" : {
    "phase" : "COMPLETE"
  }
}
```

## 查詢enrich policy
```
GET /_enrich/policy
```
查詢結果如下
```json=
{
 "config" : {
  "geo_match" : {
  "name" : "postal_policy",
  "indices" : [
   "postal_codes"
  ],
  "match_field" : "location",
  "enrich_fields" : [
    "location",
    "postal_code"
    ]
   }
 }
}
```

## 建立 pipeline
透過 `PUT pipeline API` 方法來新增 or 更新 enrich processor 至名為 `postal_lookup` 的 pipeline 中
```
PUT /_ingest/pipeline/postal_lookup
{
  "processors": [
    {
      "enrich": {
        "description": "Add 'geo_data' based on 'geo_location'",
        "policy_name": "postal_policy",
        "field": "geo_location",
        "target_field": "geo_data"
      }
    }
  ]
}
```
回傳結果
```json=
{
  "acknowledged" : true
}
```
### 說明
- policy_name: 於 pipeline 指定 enrich policy
- field: 配對的欄位，前述範例以 `geo_location` 為配對的欄位
- target_field: 配對成功後，來源 document 會新增的欄位名稱

## 新增來源資料
新增 document 並指定 `postal_lookup` 這個 pipeline 擴增資料
```
PUT /users/_doc/0?pipeline=postal_lookup
{
  "first_name": "Mardy",
  "last_name": "Brown",
  "geo_location": "POINT (13.5 52.5)"
}
```
查詢 users
```
GET /users/_doc/0
```
查詢結果
```json=
{
  "_index" : "users",
  "_type" : "_doc",
  "_id" : "0",
  "_version" : 1,
  "_seq_no" : 0,
  "_primary_term" : 1,
  "found" : true,
  "_source" : {
    "geo_location" : "POINT (13.5 52.5)",
    "last_name" : "Brown",
    "geo_data" : {
      "location" : {
        "coordinates" : [
          [
            13.0,
            53.0
          ],
          [
            14.0,
            52.0
          ]
        ],
        "type" : "envelope"
      },
      "postal_code" : "96598"
    },
    "first_name" : "Mardy"
  }
}
```
由上述查詢結果得知，透過 pipeline 裡的 enrich processor 擴增了 geo_data 裡的資料，包含coordinates 以及 postal_code
# Enrich processor 幾個要注意的點
- 建好 enrich policy 後，將無法更新或更改。反之，可以藉由建立並執行新的 enrich policy 替換舊的 policy
- 使用 `delete enrich policy API` 刪除舊的 enrich policy
- (重要)enrich policy 連接的來源 index (source index) 若有更新資料，則需要重新執行 `execute enrich policy API` 更新舊的 source index。 
**以下擷取自部分文件內容**
> ### Update an enrich index 
> Once created, you cannot update or index documents to an enrich index. Instead, **update your source indices and execute the enrich policy again**. This creates a new enrich index from your updated source indices and deletes the previous enrich index.
> 
> If wanted, you can **reindex or update** any already ingested documents using your ingest pipeline.

# 小結
前面實作了如何建立 enrich processor 至 pipeline 中，並將來源資料(document) 指定由該 pipeline 處理，將配對到的 document 擴充欄位，這個概念類似於關連式資料庫的 `Join Table`，透過 enrich processor 我們能夠藉由已存在的資料對來源資料進行擴增。

# Reference
- [Set up an enrich processor](https://www.elastic.co/guide/en/elasticsearch/reference/7.x/enrich-setup.html#create-enrich-source-index)