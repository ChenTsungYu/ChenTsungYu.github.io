---
title: '[Python] MySQL 資料操作'
date: 2019/09/13 20:54:10
tags: [Database, MySQL, Python]
catalog: true
categories: Backend
toc: true
---
![](https://i.imgur.com/v9Jp9x8.png)
<!-- toc -->
# 前言
本篇用於紀錄使用Python操作MySQL

# 安裝MySQL
因為之前有下載[MAMP](https://progressbar.tw/posts/27)，裡面已經安裝過MySQL。

# 安裝pysql
```clike=
pip install pymysql
或
pip3 install pymysql
```
安裝完成後建立名為**crud_tes**t的資料庫。
<!--more--> 
# 實作
## 引入`pymysql`並創建`cursor`
```python=
import pymysql
db = pymysql.connect("127.0.0.1", port=8889 , user="root", password="root", db="crud_test", charset='utf8') # db為指定的資料庫名稱
#建立操作游標
cursor = db.cursor()
```
>### `cursor()`為獲得python執行ＭySQL語法的方法

## 查詢資料庫版本
sql查詢指令為`SELECT VERSION()`
```python=
#==========  查詢資料庫版本  =======
sql = 'SELECT VERSION()' 

#執行語法
cursor.execute(sql)
print("Success!!!!")
#選取第一筆結果
data = cursor.fetchone()

print ("Database version : %s " % data)
#關閉連線
db.close()

# 回傳結果：Database version : 5.6.35 
```
## 新增資料
### 先定義表格結構
![](https://i.imgur.com/jXhfqzh.png)
### `insert`語法:
`insert into 資料表名稱(欄位1, 欄位2, 欄位3....) values (欄位1的值,欄位2的值, 欄位3的值.... );`
### 範例
```python=
import pymysql
from datetime import datetime
db = pymysql.connect("127.0.0.1", port=8889 , user="root", password="root", db="crud_test", charset='utf8')
#建立操作游標
cursor = db.cursor()

# sql 新增
sql = "insert into student_record(sid, name, gender, age, score) values (1, 'Jean', 'female', '20', 100);"

#執行語法
try:
  cursor.execute(sql)
  #提交修改
  db.commit()
  print('success')
except:
  #發生錯誤時停止執行SQL
  db.rollback()
  print('error')

# 提交commit，不然無法存新建或者修改的資料
db.commit()
# #選取第一筆結果
data = cursor.fetchone()
```
> ### 務必記得提交commit，不然無法存新建或者修改的資料

### 查看結果：新增成功一筆資料
![](https://i.imgur.com/mAipoIu.png)

## 修改資料
### `update`語法:
`update record set 欄位名 where 更新條件` 
> ### `set`後面接更新目標的欄位，`where`後面接更新的條件

### 範例
```python=
import pymysql
from datetime import datetime
db = pymysql.connect("127.0.0.1", port=8889 , user="root", password="root", db="crud_test", charset='utf8')
#建立操作游標
cursor = db.cursor()
# sql 修改
sql = "update record set name= 'Tony' where age = '30' " 
try:
  cursor.execute(sql)
  #提交修改
  db.commit()
  print('success')
except:
  #發生錯誤時停止執行SQL
  db.rollback()
  print('error')

db.commit() # 提交commit，不然無法存新建或者修改的資料
#選取第一筆結果
data = cursor.fetchone()


#關閉連線
db.close()
```

## 查詢
` select 目標欄位 from 資料表`，返回值的資料型態為**tuple**
### 範例(選取第一筆結果):
```python=
import pymysql
from datetime import datetime
db = pymysql.connect("127.0.0.1", port=8889 , user="root", password="root", db="crud_test", charset='utf8')
#建立操作游標
cursor = db.cursor()
# sql 查詢
sql = "select * from student_record"


#執行語法
try:
  cursor.execute(sql)
  #提交修改
  db.commit()
  print('success')
except:
  #發生錯誤時停止執行SQL
  db.rollback()
  print('error')
# 提交commit，不然無法存新建或者修改的資料
db.commit()
#選取第一筆結果
data = cursor.fetchone()
print(data)

# (1, 'Jean', 'female', 20, 100)
```
### 範例(選取全部結果):
採用`fetchall()`
```python=
import pymysql
from datetime import datetime
db = pymysql.connect("127.0.0.1", port=8889 , user="root", password="root", db="crud_test", charset='utf8')
#建立操作游標
cursor = db.cursor()
# sql 查詢
sql = "select * from student_record"


#執行語法
try:
  cursor.execute(sql)
  #提交修改
  db.commit()
  print('success')
except:
  #發生錯誤時停止執行SQL
  db.rollback()
  print('error')
# 提交commit，不然無法存新建或者修改的資料
db.commit()
#選取第一筆結果
data = cursor.fetchall()
print(data)

# ((1, 'Jean', 'female', 20, 100), (2, 'Tom', 'male', 21, 70), (3, 'Tony', 'male', 22, 60), (4, 'Jack', 'male', 30, 90))
```

### 範例(指定取回查詢筆數):
`fetchmany(size= number)`，`size`限制查詢筆數。
```python=
import pymysql
from datetime import datetime
db = pymysql.connect("127.0.0.1", port=8889 , user="root", password="root", db="crud_test", charset='utf8')
#建立操作游標
cursor = db.cursor()
# sql 查詢
sql = "select * from student_record"

#執行語法
try:
  cursor.execute(sql)
  #提交修改
  db.commit()
  print('success')
except:
  #發生錯誤時停止執行SQL
  db.rollback()
  print('error')
# 提交commit，不然無法存新建或者修改的資料
db.commit()
#選取第一筆結果
data = cursor.fetchmany(size=2)
print(data)

# ((1, 'Jean', 'female', 20, 100), (2, 'Tom', 'male', 21, 70))
```

## 刪除
`delete from 資料表名稱 where 刪除條件`

### 範例

```python=
import pymysql
from datetime import datetime
db = pymysql.connect("127.0.0.1", port=8889 , user="root", password="root", db="crud_test", charset='utf8')
#建立操作游標
cursor = db.cursor()
# sql 查詢
sql = "delete from student_record where name= 'Jack' " 

#執行語法
try:
  cursor.execute(sql)
  #提交修改
  db.commit()
  print('success')
except:
  #發生錯誤時停止執行SQL
  db.rollback()
  print('error')
# 提交commit，不然無法存新建或者修改的資料
db.commit()
#選取第一筆結果
data = cursor.fetchmany(size=2)
print(data)
```
### 結果
![](https://i.imgur.com/9lNuuNt.png)

# 參考文章
[Day22- Python X MySql 2](https://ithelp.ithome.com.tw/articles/10208099)
