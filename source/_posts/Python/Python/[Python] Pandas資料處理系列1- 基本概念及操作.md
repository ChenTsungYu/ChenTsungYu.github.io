---
title: "[Python] Pandas資料處理- 基本概念及操作"
catalog: true
date: 2019/09/04 20:23:10
tags: [Python, Pandas]
categories: Backend
toc: true
---
<!-- toc -->
# 前言
Pandas是python的一個數據分析的函式庫，提供簡易使用的資料格式，使用者透過這項工具快速操作及分析資料，提供十分容易操作的資料結構如：**DataFrame**。
Pandas不但可以網頁中的表格資料，還能從外部匯入資料，將這些資料進行排序、修改或是做成統計相關的圖表。
<!--more--> 
# 安裝 Pandas
```python=
pip install pandas  
```

# Pandas資料結構
* Series
是一維陣列的資料結構，能夠保存不同資料的型態，如：整數、字串、浮點數。
* DataFrame
是一個二維陣列的資料結構，可以操作某行/列，或是多行/列的資料，也可以做排序、插入、修改或刪除等操作。

**DataFrame** 是常用資料處理的格式，尤其是在做報表處理的時候非常方便。

# Series基本操作
## 建立Series
`Series`可以處理一維資料的型態包含陣列(array)、字典(dictionary)、單一資料。
### 資料為陣列(array)時
```python=
import pandas as pd 

cars = ["高雄", "花蓮", "台東", "台北", "台中"]

select = pd.Series(cars)  
print(select)  
```
![](https://i.imgur.com/dEhBLwv.png)


### 資料為字典(dictionary)時
```python=
import pandas as pd

seri = {  
    "col0": "0",
    "col1": "1",
    "col2": "2",
    "col3": "3",
    "col4": "4",

}
seris = pd.Series(seri)
seris
```
![](https://i.imgur.com/zSGAHV4.png)
### 取值
#### 透過**索引值或key名**，篩選出目標值
```python=
print(seris[1]) # 依照索引值取單一值
print("--------")
print(seris["col2"]) # 依照key名稱取單一值
print("--------")
print(seris[[0, 2, 4]]) # 依照索引值取多個值
print("--------")
print(seris[["col1", "col3", "col4"]]) # 依照key名稱取多個值
print("--------")
```
![](https://i.imgur.com/jTGniZI.png)

#### 透過**索引值或key名**，篩選出目標值
透過切片(`slice`)的方式進行索引值或key名，分割出目標值的範圍。
```python=
print(seris[:3]) # slice方法依照索引值選取目標範圍
print("--------")
print(seris[:"col3"]) # slice方法依照"key"名稱選取目標範圍
```
![](https://i.imgur.com/snAGu2G.png)

### 資料為資料為單一資料時
```python=
import pandas as pd

student = "Tom"  
ser = pd.Series(student, index = range(3))  
print(ser)  

"""
結果
0    Tom
1    Tom
2    Tom
dtype: object
"""
```

# DataFrame基本操作
## 建立DataFrame
### 資料為陣列(array)時
```python=
import pandas as pd

students = [["A", "male"],["B", "female"], ["C", "male"]]

df = pd.DataFrame(students, columns = ["name", "gender"]) # 指定欄位名稱  
df
```
![](https://i.imgur.com/8kmWhmO.png)

### 資料為字典(dictionary)時
```python=
import pandas as pd

students = {  
    "name": ["A","B", "C"],
    "stid": [1,2, 3],
    "gender": ["male","female", "male"],
    "age": [20, 30, 40],
    "city": ["高雄", "台北", "台中"]
}
df = pd.DataFrame(students)
df
```
![](https://i.imgur.com/9opfitL.png)


## 讀取資料
pandas支援的資料格式很多種，常見的格式包含:
* `read_csv()` 讀取*.csv格式的檔案
* `read_html()` 讀取*.heml格式的檔案
* `read_sql()` 讀取*.csv格式的檔案
* `read_excel()` 讀取*.xlsx格式的檔案
* `read_json()` 讀取*.json格式的檔案

## 寫入資料
* `to_csv()` 讀取*.csv格式的檔案
* `to_html()` 讀取*.heml格式的檔案
* `to_sql()` 讀取*.csv格式的檔案
* `to_excel()` 讀取*.xlsx格式的檔案
* `to_json()` 讀取*.json格式的檔案


## 說明
* `encoding="utf-8-sig"`: 將BOM去除的`utf-8`編碼
* `index_col=0`: 去除索引欄位

## 寫入資料範例(`*.csv`為例)
```python=
import pandas as pd
scores = [
    [60, 70, 80], [90, 66, 50], [47, 50, 88]
]
students = [
    "student1", "student2", "student3"
]
subjects = [
    "國", "英", "數"
]
df = pd.DataFrame(scores, columns=subjects, index=students )
print(df)

df.to_csv("scores.csv", encoding="utf-8-sig")
```

## 讀取資料範例
```python=
import pandas as pd
# 讀檔
data = pd.read_csv("scores.csv", encoding="utf-8-sig", index_col=0)

data.head()
```
![](https://i.imgur.com/bT0SZuz.png)

### 讀取線`.csv`檔
透過正確的URL就可以讀取網路上的任意`.csv`檔案轉成DataFrame。
```python=
df = pd.read_csv('http://bit.ly/kaggletrain')
df.head()
```

## 顯示前5筆資料
`df.head()`: 使用.head()可以顯示資料，(預設5筆)，當然也能自訂，只需要內加上要顯示資料的筆數
![](https://i.imgur.com/Z8re3AY.png)

顯示最後一筆
`df.head(1)`
![](https://i.imgur.com/b2HYEmc.png)
## 顯示後5筆資料
`df.tail()`:
要顯示最後五筆資料則可以使用`df.tail()`，和`df.head()`一樣，可以在括號內加上要顯示資料的筆數

## 資料資訊
使用`df.info()`可以看到該檔案資訊
![](https://i.imgur.com/X6mLyFO.png)

## 知道檔案的大小
回傳訊息為：**顯示(rows,columns)**
![](https://i.imgur.com/GL1qUPQ.png)


## 篩選資料

### 選擇一項資料
`df["欄位名稱"]`
假設我們想要選擇某個科目的欄位所有資料，以**英文**為例
```python=
df["英"]
```
![](https://i.imgur.com/1ZwtWGI.png)

### 選擇某幾筆資料
假設我們要前兩筆英文科目的成績資料
```python=
df["英"][:2]
```
![](https://i.imgur.com/VnABNBv.png)

### 選擇多項資料
要擴增選擇的欄位很簡單，用一個`list`的資料結構即可完成。
`df[['欄位名稱','欄位名稱']]`
以取得**英文、數學**這兩格欄位為例
```python=
df[["英", "數"]].head()
```
![](https://i.imgur.com/Ax8rinI.png)

### `loc["x_label", "y_label"]`
`loc["x_label", "y_label"]`基於行(column)和列(row)進行資料篩選，`x_label`表示列(row)的篩選，而`y_label`則是基於行(column)。
#### 範例
原始資料:
![](https://i.imgur.com/ipPOCP0.png)
針對student1至student3及國文英文科進行篩選，採用切片(slice)的方式。
```python=
# 用index的標籤來篩選出資料 concat_df
concat_df.loc["student1":"student3", :"英"]
```
![](https://i.imgur.com/XcTFJGd.png)
### `iloc[]`
基於行和列的索引值進行篩選，索引值都是從0開始。
#### 範例
篩選列(row)的前五筆及行(column)的前兩筆
```python=
# 用index位置來篩選出資料
concat_df.iloc[:5, :2]
```
![](https://i.imgur.com/iR24spR.png)


###  運算子篩選資料
除了上述方法外，pandas也可以利用運算子的方式來篩選條件，如條件運算的:`==  !=`、`> <`、`>= <=`，
#### 範例
假設要篩選出英文分數>70分的學生
```python=
# 運算子篩選資料
concat_df["英"]  > 70
```
![](https://i.imgur.com/tEycEFI.png)

執行範例程式碼後可看到回傳條件顯示`True`或`False`，接著以`True`或`False`當作篩選條件
```python=
condition = (concat_df["英"]  > 70)
concat_df[condition]
```
![](https://i.imgur.com/9VUz4J4.png)

### 多個運算子篩選資料
如果過濾條件不只一個，布林運算子就派上用場了！
#### 範例
篩選出國等於80分、數學大於60分、英文大於70分的學生，三個條件都須符合的話用`and`運算，或是`&`符號。
```python=
condition1 = (concat_df["國"] == 80)
condition2 = (concat_df["數"] > 60)
condition3 = (concat_df["英"] > 70)
concat_df[(condition1 & condition2 & condition3)] 
```
![](https://i.imgur.com/ShoGXqR.png)



## 資料新增
新增column並加上資料，採用`insert()`方法
`df.insert(位置索引值,column="欄位名稱",value="該筆資料的值")`

新增一個叫**物理**的欄位名稱在索引值為1(第二個欄位)的位置，裡面的值是`[80, 90, 100]`
```python=
phy_arr=[80, 90, 100]
df.insert(1, column="物理", value=phy_arr)
```

![](https://i.imgur.com/cphLOmU.png)

### 空的資料填充
把`NaN`的資料代換成自訂的資料，語法: `fillna(要替換的值)`
範例:
```python=
df.fillna(0)
```

## 資料刪除
`DataFrame.drop(labels=None,axis=0, index="索引值", columns="欄位名", inplace=False)`

### 參數說明：
* labels: 要刪除的行/列的名字
* axis: 預設為0，指刪除列(row);若要刪除行(column)時要指定axis=1；
* index: 直接指定要刪除的列(row)
* columns: 直接指定要刪除的行(column)
* inplace =False，預設不改變原資料，而是回傳一個執行刪除操作後的新dataframe；
* inplace=True，會在原數據上進行刪除操作，無返回值。

因此，刪除行列有兩種方式：
1）labels=None,axis=0的組合
2）index或columns直接指定要刪除的行或列

### 注意
>1. 指定參數`axis = 0`表示要刪除的值(row)，`axis = 1`表示要刪除欄位(column)。
>2. 刪除資料的話，預設不改變原資料，而是回傳刪除後的新表格，所以要取新表格的資料要採用***賦值***的方式

### 刪除欄位列(column)
假設今天要刪除**物理**
```python=
# 刪除欄位
df.drop("物理", axis=1)

# 或是
df.drop(columns="物理")
```
![](https://i.imgur.com/tW3ShQc.png)

### 刪除列(row)
刪除索引值(index)為**student1**的列
```python=
df.drop("student1")

#或是
df.drop(index=["student1"])
```

![](https://i.imgur.com/Rijq0In.png)

若要刪除多個值，給定一個`list`即可。
![](https://i.imgur.com/PEwXToq.png)

刪除多個列也同理。

### 刪除空值
有時候得到的資料不一定是完全都有數值，很可能含有`NaN`，這時候就需要把它給刪除。
`df.dropna()`

## 資料排序

### `sort_values()`
指定欄位的數值排序採用`.sort_values("欄位名", ascending=True, axis=0)`方法，`ascending=True`和`axis=0`為預設的排列方式
```python=
df.sort_values("物理", ascending=True)

# 順序反轉
df.sort_values("物理", ascending=False)
```
![](https://i.imgur.com/mkrPX2h.png)

#### 當`axis=1`時，改以行(columns)為排序方式
```python=
df.sort_values("student1", axis=1)

# 反轉
df.sort_values("student1", ascending=False, axis=1)
```
![](https://i.imgur.com/z6Sdacu.png)

## 合併資料
合併多個CSV檔成單一DataFrame，若遇上相同類型的資料被分成多個不同的 CSV檔的情形，可以將之合併。
### 範例
假設本地分別有`scores1.csv`、`scores2.csv`兩個檔案。
```python=
scores1_df = pd.read_csv("scores1.csv", encoding="utf-8-sig", index_col=0)
print(scores1_df)
# ========
scores2_df = pd.read_csv("scores2.csv", encoding="utf-8-sig", index_col=0)
print(scores2_df)
```
![](https://i.imgur.com/GLmScWJ.png)

讀取DataFrames後發現格式一模一樣，可以將其進行合併。
使用`pd.concat` 將資料格式相同但分散在不同CSV檔合併成單一 DataFrame，方便之後處理。
```python=
concat_df = pd.concat([scores1_df, scores2_df],axis=0)
concat_df
```
![](https://i.imgur.com/j47ZKHz.png)


## 改變欄位名稱
### 方法一: `df.rename(rename_dic, axis=1)`
透過`df.rename(rename_dic, axis=1)`方法，回傳一個新的df，**不改變原始df**。
> pandas預設處理的軸為列(row)：以`axis=0`表示；而`axis=1`表示想以行(column)為單位
```python=
## 方法一: df.rename(rename_dic, axis=1)，不改變原始df
rename_dic = {"age": "a", "city": "ct"}
new_df = df.rename(rename_dic, axis=1) 
new_df
```

![](https://i.imgur.com/XHGojyA.png)

### 方法二:  `df.columns()`
透過`df.columns()`方法，**會改變原始df**，對目標欄位重新命名。
```python=
## 方法二:  df.columns() 
df.columns = ['na', 'id'] + list(df.columns[2:])
df
```
![](https://i.imgur.com/iWP0Oba.png)


# 參考資料
[Python for Data Science](https://github.com/PyDataScience/PythonforDataScience/tree/master/Pandas?fbclid=IwAR1ezon5b71LNNWSo9We2PGOoK78K2sy9jZPTgvq2lIn1R51EOEzX7clU5g)
[tutorials](https://pandas.pydata.org/pandas-docs/stable/getting_started/tutorials.html)
[[第 14 天] 常用屬性或方法（3）Data Frame](https://ithelp.ithome.com.tw/articles/10185922)

[資料科學家的 pandas 實戰手冊：掌握 40 個實用數據技巧](https://leemeng.tw/practical-pandas-tutorial-for-aspiring-data-scientists.html)

[[Day08]Pandas資料的取得與篩選！](https://ithelp.ithome.com.tw/articles/10194003)

