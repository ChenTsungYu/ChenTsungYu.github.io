---
title: '[Database] Microsoft SQL Server 概念整理'
date: 2019/07/14 20:54:10
tags: [Database, SQL Server]
catalog: true
categories: Backend
---
<!-- toc -->
# 前言
這是本學期在課堂紹上學習的關聯式資料庫，他是微軟開發的一套資料庫管理系統。以下簡稱:**MS SQL Server**；資料庫簡稱DB
MS SQL Server主要分兩種DB
<!--more--> 
## System database
SQL Server 運作所需的DB，隨系統安裝時自動建立。底下有多個子類別:
### master
SQL Server的核心DB，存放所有user帳號&密碼、紀錄所有DB實體存放路徑。

### msdb
負責系統自動化管理所需資訊，如: 工作排程(job)、警示(alert)等。

### model
使用者資料庫的範本，DBA(資料庫管理師)建DB時，系統會先複製此DB再做調整，用於**設定DB初始狀態**。

### tempdb
SQL Server運作時，做運算或存放的DB，每次啟動時都會重新建立。


## User database
由DBA(資料庫管理師)建立，存放user資料。

### 補充幾個名詞:

#### DBA: 
資料庫管理師，在SQL Server中稱作System Administrator(SA)，在任何DB中都是DBO(資料庫擁有者)。

#### DBO(Database Owner):
資料庫擁有者，擁有資料庫的最高權限。

#### SQL Server Profiler
用於監看SQL Server所收到的指令，須具備SA(System Administrator)權限。

## SQL 語言主要分三大類: DDL、DCL、DML

### DDL(Data Definition Language): 資料定義語言
用於**管理容器**，為DBA操作介面，語法分三類:
* CREATE 建立
* ALTER 調整
* DROP 摧毀

### DCL(Data Control Language): 資料控制語言
用於**管理權限**，為DBA操作介面，語法分三類:
* GRANT 授權
* DENY 禁止
* REVOKE 中立

### DML(Data Manipulation Language): 資料操作語言
用於**管理權限**，是DB程式設計師操作DB時使用，語法分四類:
* Insert 新增
* Delete 刪除
* Update 修改
* Select 查詢

## SQL Server Data Type
在進入SQL Server 處理 data type的方式之前，先簡單了解一下字元碼。

### ASCII
為美國標準字源碼，主要用於顯示現代英語和其他西歐語言。
* 一個字元 = 1byte -> 處理一個英文字或數字
* 兩個字元處理一個中文字

### Big 5 
處理繁體中文

### Unicode
統一字元，又稱"標準萬國碼"
* 一個字元 = 2byte - > 中文、英文字或數字皆可處理
* 它可以使電腦得以呈現世界上數十種文字的系統

-----
概略了解字元編碼後就正式進入SQL Server的data type，在**文字處理**上，使用ASCII、Unicode作範例:
#### ASCII處理
* char() :  用於處理固定長度的字，若宣告的空間未用完會填入空白-> 節省時間
* varchar(): 用於處理變動長度的字，若宣告的空間未用完則不會將剩餘空間填入空白
* text : 處理長文字，可放入2G大小的字元。

#### Unicode處理
N表Unicode處理
* Nchar(): 用於處理固定長度的字
* Nvarchar(): 用於處理變動長度的字
* Ntext:處理長文字

**<Note>** 有些比較特殊的中字無法使用ASCII(Big5)處理，會顯示"?"。

#### 補充
**UTF-8**
一種針對Unicode的**可變長度**字元編碼，用來表示Unicode標準中的任何字元其編碼中的第一個位元組仍與ASCII相容，使得原來處理ASCII字元的軟體無需或只作少部份修改後，便可繼續使用。

-----

### 數字處理
數字資料型態主要分兩種: **整數、實數**

#### 整數
以`int`表示其資料型態。

#### 實數
可帶有小數點，主要分三類應用:
* 科學記號: 

用於表示極大的數，以**指數的方式儲存**，以`float`表示其資料型態。
* 精確數字: 

指定所需的整數及小數精確位數，以`decimal(t,n)`表示其資料型態，t表**全部有幾位精確數字**，n表**多少位小數**。
* 錢: 

錢這個種類比較特別，在真實世界中不會有人使用大於4位小數的金錢單位，所以在數字處理上獨立出一個錢的種類，`money`表示其資料型態。

---

### 時間、日期處理
* DateTime: 儲存資料型態為**日期&時間**
* Date: 儲存資料型態為**日期**
* Time: 儲存資料型態為**時間**


---

## 檔案種類

MS SQL Server中的檔案種類分作2種:
* Data File
* Transction Log File

### Data File
存放資料內容，檔案依照順訊細分2類
#### mdf(master data file):
第一個資料檔，副檔名為mdf。

#### ndf(secondary data file):
第二個以上的資料檔，副檔名為ndf。

### Transction Log File
儲存交易紀錄，副檔名為ldf。

#### 交易
一個以上的動作，具有要就完全完成，否則就當作一切未發生的狀態稱作交易，**ACID**可以用來描述交易的特性。

**A: Atomicity(單元性)**
參與交易的所有動作只能有兩種結果，要就**全部完成**，否則就**未曾發生過**

**C: Consistency(一致性)**
參與交易的每一個動作，若交易成功，則全部停留在交易成功後的狀態，若交易失敗，則全部回到交易前狀態。

**I: Isolation(孤立性)**
當交易進行時，若讀取資料，則其他交易**不可修改資料**，若交易修改資料，則其他交易**不可讀寫資料**。

**D: Durability(永久性)**
交易成功時，參與交易的資料會被正確反應到資料庫，不會消失。

舉個生活中的常見案例:
ATM提款: 從插卡開始~列印明細表前都算是交易。

### ACID與確保機制:
**A:** 
* 顯性交易

Begin 宣告交易
* 隱性交易

不必宣告即具有交易特性，如: Insert、Update、Delete

**C:**
* Rollback 

交易失敗藉此指令回到交易前狀態。
* Rollforward

交易成功，藉此指令更新到DB中。

**I:**
* lock:
S鎖定: 又稱共享鎖定
X鎖定: 又稱獨佔鎖定

**D:**
Write: 寫入DB
Read: 讀取DB資料

---
ODBC:
微軟所提出的開放DB連接介面，用來連接各種DBMS，即各DBMS共用。

## index: 
索引值，針對指定欄位事先排序，方便查詢。
* 優點: 查詢快速
* 缺點: 更改或維護的成本較高(**增加、刪除、修改速度慢**)

### 種類:
#### cluster index:
在table中選最常被查詢或排序的欄位或欄位組合作為cluster index，資料實際以此(index)做排序。

#### non cluster index:
將指定欄位或欄位組合作為索引值，並將欄位內容複製到table中且排序，將每筆資料的索引後的cluster index值複製到索引後的欄位中。

## join 
用於反正規化，將原先拆解的table順著Reference合併為一個較大的table。join有4種方式: **inner join、left outer join、right outer join、full outer join**


## union
將兩個結構相同(欄位數相同、資料類別相同)的資料集進行疊加。
