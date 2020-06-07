---
title: '[Database] MongoDB 資料操作'
date: 2019/09/12 20:54:10
tags: [Database, MongoDB, NoSQL]
catalog: true
categories: Backend
toc: true
---
<!-- toc -->
# 前言
本篇紀錄MongoDB整合Python的pymongo及mongo shell進行資料庫操作，安裝方式參考[本篇](https://chentsungyu.github.io/2019/09/14/Database/MongoDB/%5BMongoDB%5D%20MongoDB%E5%AE%89%E8%A3%9D%E8%88%87%E9%80%A3%E6%8E%A5/)。

# 傳統SQL與MongoDB兩者對應關係
在操作MongoDB前需要了解兩者的對應關係，才能理解如何下操作指令
![](https://i.imgur.com/eeT0Hbv.png)
<!--more--> 
# 使用Pymongo
## 安裝pymongo
```python=
pip install pymongo
```
## 連接pymongo
連接MongoDB時，需使用PyMongo庫裡面的`MongoClient`。一般來說，傳入MongoDB的host及port即可，其中第一個參數為主機位置(host)，第二個參數為port(如果不傳參數，預設是27017)
```python=
from pymongo import MongoClient # 引入pymongo
# 連接pymongo
client = MongoClient(host='localhost', port=27017) 
```
### 純字串的連接方式
```python=
client = MongoClient('mongodb://localhost:27017/')
```

### 連接雲端的MongoDB
* 點擊Connect Instructions -> 選擇Connect Your Application -> 選擇程式語言，並複製下方指令
![](https://i.imgur.com/RPFpic5.png)

* 貼上剛才複製的指令，並將password替換成自己的用戶密碼
```python=
client = MongoClient("mongodb://tomchen:user_password@cluster0-shard-00-00-q0zkl.mongodb.net:27017,cluster0-shard-00-01-q0zkl.mongodb.net:27017,cluster0-shard-00-02-q0zkl.mongodb.net:27017/test?ssl=true&replicaSet=Cluster0-shard-0&authSource=admin&retryWrites=true&w=majority")
```
## 建立/指定資料庫
MongoDB中可以建立多個資料庫，需要指定操作哪個資料庫。
以test資料庫為例:
### 方法1
```python=
db = client.test
```
### 方法2
```python=
db = client['test']
```

## 建立/指定Collection
MongoDB中的collection對應傳統資料庫的table
建立students為collection名稱
### 方法1
```python=
collection = db.students
```
### 方法2
```python=
collection = db[students]
```

## 新增資料
### 新增單筆資料
採`insert_one()`方法
```python=
student = {
    'id': '20170101',
    'name': 'Jordan',
    'age': 20,
    'gender': 'male'
}

result = collection.insert_one(student)
print(result)
```
![](https://i.imgur.com/1dA4RaG.png)

### 新增多筆資料
採`insert_many()`方法，傳入一個陣列形式的資料結構
```python=
students = [
    {
        'id': '20180101',
        'name': 'Jean',
        'age': 20,
        'gender': 'female'
    },
        {
        'id': '20190101',
        'name': 'Tom',
        'age': 22,
        'gender': 'male'
    },
]

result = collection.insert_many(students)
print(result.inserted_ids) # 回傳 ObjectId
```
![](https://i.imgur.com/yj1bscT.png)

## 查詢
可以利用`find_one()`或`find()`方法進行查詢，其中`find_one()`查詢得到的是符合條件的第一個結果。
> 如果查詢結果不存在，則會返回`None`

### 查詢單一筆資料
如查詢name為Tom的資料
```python=
result = collection.find_one({'name': 'Tom'})
print(type(result)) # 回傳結果是dic類型
print(result)
```
![](https://i.imgur.com/9SJc3GH.png)

### 根據ObjectId來查詢
需要使用package-`bson`裡面的objectid
```python=
from bson.objectid import ObjectId
result = collection.find_one({'_id': ObjectId('5e41253fe2d639ab3976e620')})
print(result)
```
### 查詢多筆資料
> #### 查詢多筆資料時，務必要在查詢的結果轉為list
```python=
result = list(collection.find({'name': 'Tom'}))
print(result)
```
![](https://i.imgur.com/Q0IwCdt.png)

### 條件查詢
#### 大於的條件
在dic內使用`$gt`作為篩選條件
```python=
results = list(collection.find({'age': {'$gt': 20}}))
print(results)
```
![](https://i.imgur.com/ZWIGufq.png)

#### 小於的條件
在dic內使用`$lt`作為篩選條件
```python=
result = list(collection.find({'age': {'$lt': 22}}))
print(results)
```
![](https://i.imgur.com/YdDKUH1.png)

#### 配合正規表達式
在dic內使用`$regex`作為篩選條件，如: 查詢名字以T開頭的學生資料
![](https://i.imgur.com/9O73usl.png)

## 更新
### 方法一`update()`
使用`update()`方法，如更新name為Tom的age：先指定查詢條件，再查詢該筆資料，修改年齡後呼叫`update()`方法將原條件和修改後的資料傳入
```python=
condition = {'name': 'Tom'}
student = collection.find_one(condition)
print(student)
student['age'] = 25
result = collection.update_one(condition, student)
print(result)
```
回傳結果:
![](https://i.imgur.com/BkQPMy5.png)

也可以使用`$set`對資料進行更新
```python=
result = collection.update(condition, {'$set': student})
```
### 方法二: `update_one()`和`update_many()`是官方比較推薦的方法
`update_one()`和`update_many()`是官方比較推薦的方法，用法更加嚴謹
```python=
result = collection.update_one(condition, {'$set': student})
```
嚴謹的方法會回傳`UpdateResult object`，而`matched_count`和`modified_count`屬性則是指獲得匹配的資料數量和更動的資料數量
![](https://i.imgur.com/kJBtDCF.png)

另外的例子:
#### update_one()
指定查詢條件為`age`大於20，更新條件為`{'$inc': {'age': 1}}`，也就是`age`加1，執行之後會將第一條符合條件的資料`age`加1。
```python=
condition = {'age': {'$gt': 20}}
result = collection.update_one(condition, {'$inc': {'age': 1}})
print(result)
print(result.matched_count, result.modified_count)

```
![](https://i.imgur.com/k2HFvWj.png)

#### update_many()
```python=
condition = {'age': {'$gt': 20}}
result = collection.update_many(condition, {'$inc': {'age': 1}})
print(result)
print(result.matched_count, result.modified_count)
```
![](https://i.imgur.com/4U55exm.png)
回傳結果可看到所有資料都被更新


## 刪除
使用`delete_one()`和`delete_many()`方法指定刪除的條件，此時符合條件的資料會被刪除。
```python=
result = collection.delete_many({'name': 'Jean'})
print(result)
print(result.deleted_count) 
result = collection.delete_many({'age': {'$gt': 25}})
print(result.deleted_count)
```
`deleted_count`為被刪除的數量
![](https://i.imgur.com/lUpuiEG.png)


# 使用Mongo Shell
mongo 是一個用來操作MongoDB的JavaScript介面，可以使用它來進行新增、刪除、修改、查詢資料庫中的資料，另外也可以進行資料庫管理。

## 連結本地
```bash=
mongo
```
打開終端機執行`mongo` 以MongoDB Shell來連線到MongoDB。![](https://i.imgur.com/zZKG463.png)
上圖表示連結成功！

>若無加上任何參數，`mongo`指令預設會連線到`localhost: 27017`，如果要改變主機與連接埠，參考 [mongo Shell Reference Page](https://docs.mongodb.com/manual/reference/program/mongo/#syntax)。

## 查看基本的操作說明
```bash=
help
```
一開始進入 MongoDB Shell 時，可以執行`help`來查看基本的操作說明

## 選擇 database
在輸入資料之前，先下`use`指令來選擇目標database。

## 新增資料
MongoDB內新增資料採`insert()`方法，所有儲存在collection中的 document都會有一個 `_id`的field名稱作為 **primary key**，如果輸入資料時沒有加上這個 field，MongoDB 會自動產生一個 `ObjectId` 作為 `_id`。
範例：
寫入一個名為students的collection
```python=
db.students.insert({
    "name" : "Tom",
    "sid" : "41704620",
    "gender" : "male" ,
    "family" : {
      "fatherName" : "father",
      "matherName" : "mather",
      "totalMember": 3
    },
    "city" : "金門",
    "grades" : [
      {
        "subject": "體育",
        "date": ISODate("2019-10-01T00:00:00Z"),
        "grade" : "A+",
        "score" : 95
      },
      {
        "subject": "國文",
        "date" : ISODate("2014-01-16T00:00:00Z"),
        "grade" : "A-",
        "score" : 80
      }
    ]
  }
)
```
![](https://i.imgur.com/edoSMBS.png)
成功寫入！
> 如果遇到 collection 不存在的狀況，MongoDB 會自動建立這個 collection。在執行之後，會傳回一個 `WriteResult` 物件，`nInserted` 的值就是輸入資料的筆數
> ![](https://i.imgur.com/w3S9EYQ.png)

## 查詢資料
### 未指定條件
執行`find()`不加任何查詢條件時，會列出該collection中所有的 documents。
```python=
db.students.find()
```
![](https://i.imgur.com/bIvcbWl.png)
查詢成功！

### 指定查詢條件

#### 範例1
查詢某個物件
```python=
db.students.find({"name" : "Tom"})
```
![](https://i.imgur.com/KrZzcQl.png)

#### 範例2
查詢某個物件下的特定物件，使用dot`.`的方式取得。
```python=
db.students.find({"family.fatherName" : "father"})
```
![](https://i.imgur.com/roKNIS4.png)

#### 範例3
也可以用於查詢陣列中的field值。
```python=
db.students.find({"grades.grade" : "A+"})
```
![](https://i.imgur.com/3cqBkk2.png)

### 配合運算子查詢條件
#### 範例1
大於條件
```python=
db.students.find({"grades.score" : {$gt: 90} })
```
#### 範例2
小於條件
```python=
db.students.find({"grades.score" : {$lt: 90} })
```
### 多個查詢條件
做`AND`運算
```python=
db.students.find( {"gender" : "male","city" : "金門"} )
```
![](https://i.imgur.com/4kXIKj1.png)

做`OR`運算
```python=
db.students.find(
  { $or: [ { "gender" : "male" }, { "city" : "金門" } ] }
)
```
![](https://i.imgur.com/JLjMx1r.png)

### 排序查詢結果
讓查詢的結果依照 field 來排序，可以加`sort()`方法，並且指定排序的 field名稱與排列方式，1:表遞增;-1：表遞減。
```python=
db.students.find().sort( { "grades": 1 } )
```

[更多查詢條件](https://docs.mongodb.com/manual/reference/operator/query/)

## 列出所有的collections
下方三行指令擇一
```python=
show collections
show tables
db.getCollectionNames()
```
![](https://i.imgur.com/SmKLQG8.png)

## 資料庫系統資訊
```python=
db.stats()
```
![](https://i.imgur.com/uRGjZ9i.png)


# 參考教學
[MongoDB 基礎入門教學：MongoDB Shell 篇](https://blog.gtwang.org/programming/getting-started-with-mongodb-shell-1/)

[Python操作MongoDB看這一篇就夠了](https://juejin.im/post/5addbd0e518825671f2f62ee)