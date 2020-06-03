---
title: '[Database] 資料庫入門'
catalog: true
date: 2019/07/14 20:50:10
tags: Database
categories: Backend
---
<!-- toc -->
# 前言
開始認識資料庫前，先知道一下什麼是**資料**?**資訊**?
## 資料(data):
> 指未經處理的原始紀錄
**e.g. 學生作業、考試成績**

另外，資料又分為**結構化**、**半結構化**、**非結構化**三種
<!--more--> 
### 結構化:
有明確格式和內容限制 **e.g. 資料庫**

### 半結構化:

有明確格式，無內容限制 **e.g. Excel、E-mail、Facebook**

### 非結構化:

無明確格式和內容限制 **e.g. 圖片、影片**

## 資訊(information):
> 指經過**”資料處理”**後的結果，產出有用的資訊。 e.g. 班級成績排名

好的資訊可以幫助決策者做出好決定! 要產出好的資訊，需透過好工具來達成，我們可以透過**資料庫系統**做統整。

## 什麼是資料庫(DataBase,DB)?
> 根據定義是指 **有方法且有組織性的將一群相關的資料集合起來並儲存在一起**

我會把它擬作一個**容器**，儲存程式、系統運作所需的資料，使用者可以使用SQL語法對容器中的檔案進行**新增(Create)**、**查詢(Read)**、**更改(Update)**、**刪減(Delete)**等操作，在CS領域稱這四大基本操作為**CRUD**。

另外資料庫有分關聯式和非關聯式資料庫，主要根據處理的資料格式來決定用哪種資料庫。

## 什麼是資料庫管理系統(DataBase Management System, DBMS )?

DBMS是一套提供多位使用者管理資料庫的軟體系統，負責資料存取和控制。一個DBMS會包含1~多個DB。常見的DBMS為:

### 關聯式資料庫管理系統:

MS(微軟) SQL Server、Oracle、MySQL(免費)

### 非關聯式資料庫管理系統:

MongoDB

### 資料庫系統(DataBase System) 的組成:

**一般來說一個資料庫系統主要包括:**

硬體、軟體(DBMS)、資料(DB)、使用者

使用者主要分三類:

1.一般終端使用者(end user)

2.程式設計師(Programmer)

3.資料庫管理師(DBA)

下面這張圖來說明彼此間的關係

![資料庫、資料庫管理系統、資料庫系統間的關係](https://cdn-images-1.medium.com/max/2000/1*Jakop8RHfrNeTlz6edwmZQ.png)*資料庫、資料庫管理系統、資料庫系統間的關係*

## 資料庫的出現及設計目的為何?

**集中管理資料**，增加資料的**完整性**和**一致性**，並建立一個整合的管理機制，把資料管理和程式設計分開，使用標準化的查詢語言(SQL語法)。

為了解決傳統檔案處理系統資料的方式，資料庫主要提供了以下優點:

1. 減少資料的重複或不一致:

傳統的方式可能造成大量資料重複，或是更新的時候不完整，導致資料不一致

2. 讓資料具共享性:

將資料維護在單一的倉庫(Repository)中它只需要定義一次，就可讓不同的使用者存取。

3. 減少維護成本及開發時間:

4. 資料的安全性:

資料庫均有完善的保密系統，透過資料庫管理師進行管理

5. 資料獨立性:

資料庫中每一項資料都具有「獨立性」， 資料的結構和存取方法是固定的，不因用途不同而有所不同。

缺點:

1. DBMS成本較高

2. 當DBMS發生故障時，比較難復原(集中控制)

另外，課堂主要介紹兩個常用的資料分析方式:

1. 正規化法(傳統)

2. 個體關係模型(ER-model)

參考網址: [http://www.angle.com.tw/File/Try/51MGA02103-2.pdf](http://www.angle.com.tw/File/Try/51MGA02103-2.pdf)


筆記傳統的分析模型:** 正規化**

## 正規化( Normalization)
> 透過蒐集原有作業的表單進行分析、拆解，避免重複和不一致，得出Data Schema

資料庫是存大量資料的地方，內含多個資料表(table)，我們的目標是要找出這些表格之間的關係，將大的資料表拆成小的資料表。順便來認識一些名詞。

### 資料表(table): 由1~n個欄位(column或稱field)及資料錄(record或稱row)，每個row表一筆資料，而每個field表一筆資料的屬性。

![](https://cdn-images-1.medium.com/max/2000/1*rgF5KOmLaUMlaYwBbMTmgw.png)

### Data Schema: 資料庫本身的描述，包括資料庫結構的描述，以及在資料庫上應該遵守的限制。

### 資料庫實例 (database instance)： 在某個特定時刻所儲存的實際資料，也稱作資料庫狀態 (database state)。

## 鍵值屬性:

在關聯式資料庫中，每一個關聯(表格)會有許多不同的鍵值屬性 (Key Attribute) ，可以分成兩個部份來探討：

### 一、屬性(Attribute)：

是指一般屬性或欄位。

### 二、鍵值屬性(Key Attribute)：

由一個或一個以上的屬性所組成， 並且在一個關聯中，必須要具有「**唯一性**」的屬性來當作「鍵 (Key)」。

關聯式資料庫(RDBMS)中，常見的鍵(Key)可分為：**候選鍵(Candidate)、主鍵(Primary Key)、外來鍵(Foreign Key)及替換鍵**。

### 候選鍵:

可**唯一識別**資料表(Table)中的每一筆資料屬性的組合。

### 主鍵(Primary Key):

從候選鍵中挑一個最適合或常用到的作為主鍵，**如果沒有合適的，就定義一組流水號。**

**主鍵要求:**

不允許重複、不允許為null(無法進行邏輯運算)*註

### 外來鍵(Foreign Key):

兩個資料表(Table)具有關係(Relationship)時，會產生參照關係，將被參照的表格(Table)中的Primary Key，納入參照的Table中做為Foriegn Key。

**外來鍵要求:**

1. 在被參照的Table中必須為**Primary Key。**

1. 當參照的Table新增一筆資料時，Foriegn Key的值在被參照的Table中必須已經存在。

1. Foreign Key允許為null，但修改值時會檢查是否存在**Primary Key。**

1. 當被參照的Table要刪除一筆資料時，DBMS會檢查該筆資料是否被Foreign Key所參照，如果是，就不能被刪除。

### 替換鍵:

其他落選的候選鍵。

## 正規化的形式

### 第一正規化: 去除多值

每個Field只允許放一個單位，若有多個值則分成多筆資料(Row)，並決定Table中的**Primary Key。**

### **第二正規化: 去除部分相依**

1. **Primary Key**可能不只一個Field所構成，若Primary Key只有一個Field，則不須另外做第二正規化(因為已經滿足)。

2. 檢查所有**非Primary Key的Field，**確認該Field必須由**所有Primary Key的Field共同決定，**不能只有部分決定**。**

3. **若部分Primary Key的Field就能決定的話，需要另外拆出一個新的表格。**

### 第三正規化: 去除遞移關係

1. 先完成第二正規化

1. 檢查所有Field是否有間接決定的現象，意思是**Primary Key**決定某個Field，而且這個Field可決定其他的Field。

1. 將發生決定的遞移現象的Field拆成新的Table。

以上為正規化的流程，之後再補上實作的例子。

註:

NULL – 「虛值」，在資料庫中為了識別**某一屬性是使用者未給值**的特殊情況，記為Null，NULL因為是未定值，**無法與其他值做比較**。

再來筆記另一種常用的資料庫分析模型:

### [實體關係模型( Entity-relationship model, **ERD**)](https://zh.wikipedia.org/wiki/ER%E6%A8%A1%E5%9E%8B)

最早由美籍華裔電腦科學家[陳品山](https://zh.wikipedia.org/wiki/%E9%99%88%E5%93%81%E5%B1%B1)所提出的概念模型。

目的: 在導出Database Schema，並提供資料儲存及業務規則間的圖型化檢驗 機制。

先說明一下ERD的符號:

Entity(實體): 用一矩形表示， 現實世界事物的一種抽象表示，大多是名詞， 如: 客戶與商品都是個體。

![](https://cdn-images-1.medium.com/max/2000/1*tc3OlesbDBcJaNEybK-APg.png)

Attribute(屬性): 用橢圓表示， 描述一個個體會有的特徵、特性。如: 客戶明、客戶住址、客戶編號。

![](https://cdn-images-1.medium.com/max/2000/1*7sxzJfDs8XNFulKkBHyypQ.png)

Relationship(關係): 用菱形表示，描述或傳達個體與個體之間的關聯性。 例: 客戶和商品之間有一『**銷售**』關聯，因此兩個體間存在一**銷售關係**。

![](https://cdn-images-1.medium.com/max/2000/1*NJLYp5KaxmMpmX5JeEdg9w.png)

作法:

1. 觀察使用者情境或需求描述，找出重要的人、事、時、地、物，畫作Entity。

1. 依Entity找出重要的Attribute，以直線連接Entity。

1. 找出Entity之間找出重要的關係，在Entity間畫出Relationship直接連接Entity。

範例:

![](https://cdn-images-1.medium.com/max/2000/1*mTY-FMDr9ISu4-UiRTbe-g.png)

<注意>

正確的ERD可以自動滿足正規化的所有流程。

陳品山的ERD可以允許多對多、多元關係，且**只描述重要屬性**。

不描述外來鍵，只描述主鍵。

不適合表達複雜的資料庫結構(Schema)

## 概念資料模型(Conceptual Data Model,CDM)

亦稱作鳥爪圖，用於資料模型(Data Model)中的概念分析，CDM處於**系統分析階段，還不需要決定使用哪個資料庫管理系統(DBMS)。**

範例圖示:

![](https://cdn-images-1.medium.com/max/2000/1*sOUHK2Bn2WDknK5tPvm9Zw.png)

實體關係的描述可為一對一、多對多、一對多。

"+"表一定要有值，空心圓表沒有值，像鳥爪一樣的圖示表示多個。

<注意>

畫底線者表示該實體的主鍵(Primary Key)。

畫CDM時，只允許二元關係，不描述外來鍵，但可以設定主鍵。

若兩個實體間有多對多的關係(都是鳥爪圖案)，則需要拆成2個一對多關係的實體。

例如上圖的訂單和產品之間的關係是多對多，那我們還可以拆分成下圖

![](https://cdn-images-1.medium.com/max/2000/1*aEdSr95z2j8QsPgOZx4d7Q.png)

中間新增一個訂單明細，跟其他兩者關係成一對多的關係。

當要把多對多的關係拆出更細節的一對多關係時，就開始進入**系統設計**階段。

筆記一下系統開發的生命週期:

![](https://cdn-images-1.medium.com/max/2000/1*C04IDNz5s-WVePpdpLDy8g.png)

## 實體資料模式(Physical Data Model,PDM)

實體資料模式是依實際運作上的考量，在特定資料庫系統上實現的結果，和上篇CDM不同的是， CDM是用來表達真實資料庫的抽象概念。

上篇最後有提到，具有多對多關係的兩個Entity需拆出兩組一對多關係的Entity。另外，因為需在特定的資料庫系統上實現，所以在畫PDM前**一定要先選定哪種資料庫管理系統**(DBMS)，選定之後就不可再做修改。

PDM示意圖(By Power Designer):

![](https://cdn-images-1.medium.com/max/2000/1*cHCWvKIEm2IzQtdKr_lAUA.png)

<注意>

此階段需選定哪個資料庫管理系統。

PDM中的Entity可以設定外來鍵(Foreign Key)。

箭頭指向**被參照的Entity**，箭尾為**參照Entity**，將被參照Entity中的主鍵拉到參照Entity內作為外來鍵。

**關係: 箭頭指向為一，箭尾為多**

另外紀錄模型內常用的資料型態:

char(): 表字元，**有固定長度**，()內可填入字元的最大長度，用於較有固定長度的資料，例如: 名字。 優點: 處理省時間

varchar():表字元，**變動長度，**可隨著不同輸入的資料長度**，**對最大長度做彈性調整，例如: 地址。 優點: 省空間

Integer: 整數

date: 日期

time: 時刻

datetime: 時間(包含日期、時間)
