---
title: "[Python] 實戰系列 - 抓取台灣銀行牌告匯率寫入MySQL"
catalog: true
date: 2019/09/14 20:23:10
tags: [Python, Project, MySQL, Pandas]
categories: Backend
toc: true
---
<!-- toc -->
# 前言
本篇主要紀錄學習過pandas、檔案寫入、MySQL後做整合。
# 實作步驟:
1. pandas讀取html的table標籤，轉為dataframe
2. 處理dataframe
3. 篩選目標欄位，並更改欄位名稱
4. 更改某欄位的值
5. 轉為`.csv`並存入MySQL
<!--more--> 
## 觀察目標網頁並擷取資料
![](https://i.imgur.com/YGBsT1C.png)

引入相關工具，使用pandas讀取html。
```python=
import pandas as pd
from datetime import datetime
import pymysql

url = 'https://rate.bot.com.tw/xrt?Lang=zh-TW'
#讀取網頁
dfs=pd.read_html(url) # 輸出資料為一個list

dfs[0]
```
![](https://i.imgur.com/LzZOeF0.png)
顯示出來的資料表有許多不需要的欄位資料

## 過濾資料
先確認資料格式，確認為dataframe後，過濾出目標值。
![](https://i.imgur.com/STPIQvd.png)
```python=
currency=dfs[0]
type(currency) # 確認資料格式

# 過濾出要的值： 前五個columns
currency_fix=currency.iloc[:,0:5] 
currency_fix
```
### 查看過濾後的dataframe
![](https://i.imgur.com/blyrILH.png)

### 自訂欄位名稱
```python=
currency_fix.columns=[u'幣別',u'現金匯率-本行買入',u'現金匯率-本行賣出',u'即期匯率-本行買入',u'即期匯率-本行賣出']
currency_fix
```
### 更新幣別欄位的資料
```python=
currency_fix[u'幣別'] # 查看"幣別"欄位
```
### 對幣別進行重新命名
```python=
# 採用正規表達式過濾字元，其中`w+`表示過濾出應英文字且一個以上
currency_fix[u'幣別'] = currency_fix[u'幣別'].str.extract('\((\w+)\)')
currency_fix[u'幣別']
```
![](https://i.imgur.com/FBsAoCN.png)
查看資料結果
```python=
currency_fix
```
![](https://i.imgur.com/YzdWq0N.png)

## 寫入`.csv`並存入資料庫
![](https://i.imgur.com/Dx2495y.png)
### 程式碼
```python=
currency_fix.to_csv('currency.csv')
df = pd.read_csv("./currency.csv", sep=',')

engine = create_engine('mysql+pymysql://root:root@localhost:8889/exrate?charset=utf8')
df.to_sql('test_currency', engine, index = False,index_label = False)

print("Write to MySQL successfully!")
```

![](https://i.imgur.com/8xBH8ig.png)

> 感謝大數學堂提供的教學影片，簡單又快速上手

# 參考
[抓取台灣銀行的牌告匯率](https://www.largitdata.com/course/85/)