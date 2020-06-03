---
title: '[Database] Microsoft SQL Server 操作'
catalog: true
date: 2019/07/14 20:23:10
tags: [Database, SQL Server]
categories: Backend
---
<!-- toc -->
## 如何連接至別人的SQLServer 
- 確定自己的Server是否有新增sysuser(SQL Server的安全性->登入->創建，設定密碼、勾選sysadmin)。
- 知道對方IP Address。
<!--more--> 
## 查看SQLServer的port
C: -> window ->  system32 -> drivers -> etc -> service，將service這個檔案貼到記事本，查看MS SQL Server的port number。 

## 設定port
- 到電腦的防火牆進階設定
- 新增輸入規則
- 選連接埠
- 勾選TCP協定，指定port no. 1443

![](https://i.imgur.com/g6Hxcsa.png)

### 自動流水號設定:
點選該資料欄位，將下方的表格往上拉(資料行屬性)，點選識別規格，狀態改為"是"，起始值(識別值種子)設100000，增量數值為9
![](https://i.imgur.com/HZKOI3L.png)


## 新增資料
```sql=
insert into IDTest(ch)
values('Test')

select @@IDENTITY
```

## 線上叢書
滑鼠點在兩個@@之間後按下F1，可開啟線上叢書。

#### 索引:查詢指令功能

![](https://i.imgur.com/ElQNjrn.png)

-----

### 到上方工具列的 "工具" 下拉點選 "選項" -> Designer ->取消勾選"防止儲存資料表重建的變更"
![](https://i.imgur.com/5bIYiXy.png)

---

## 公式運算練習: 
#### 計算回報日(resDate) = 詢價日(reqDate) + 3天

- 點**ReqDate**欄位，至下方表格找**預設欄位**輸入 **(GetDate())**
- 點**ResDate**欄位，設定 **(ReqDate + 3)**


~~~sql=
// 新增
insert into DTest(ReqDate, ch)
values('2019-5-19 14:00:00', 'Alex')
select * from DTest

// 修改
Update DTest
Set ReqDate= ('2019-5-19 16:00:00')
Where ch = 'Alex'
select * from DTest
~~~

![](https://i.imgur.com/ymFzdGD.png)
## Note
以**天**為單位使用"整數"，**時分秒**以"小數點"表示，如15分鐘: 15./24*60

## Join合併表格
**def:**
用於反正規化，將原先參照的table順著Reference合併為一個大的table，(小表格併為大表格)。

問題：哪一個客戶市交易量最大的客戶?
需要的表格有訂單、訂單明細、客戶

### 說明
將Order table叫出來，並將Order Details與Customers合併至Order

![](https://i.imgur.com/6rrdW2X.png)


#### 步驟一：
~~~sql=
select * From Orders as O
~~~
### 說明:
O 為 `as`所命名的別名，可簡化物件名稱，圖中O為Order的別名。`as`可以省略
![](https://i.imgur.com/OCOlU7M.png)



#### 步驟二:
~~~sql=
select * From Orders as O
inner join [Order Details] OD
On O.OrderID = OD.OrderID     //合併條件
~~~
### 說明 :
將orders及order details 兩張表作合併(`join`)，分別命名為O及OD
![](https://i.imgur.com/RcRDl9z.png)


#### 步驟三:

~~~sql=
select * From Orders as O
inner join [Order Details] OD
On O.OrderID = OD.OrderID
inner join [Customers] C
On C.CustomerID = O.CustomerID  //合併條件
~~~
### 說明:
`on`作為合併條件，圖中是將O的OrderId與OD的OrderId做合併條件

![](https://i.imgur.com/pz7CmNd.png)

#### 步驟四:
~~~sql=
select C.CompanyName, UnitPrice*Quantity*(1-Discount) From Orders as O
inner join [Order Details] OD
On O.OrderID = OD.OrderID
inner join [Customers] C
On C.CustomerID = O.CustomerID
~~~
### 說明:
將Customer這張表納入作合併，UnitPrice*Quantity*(1-Discount)為總和運算式。
![](https://i.imgur.com/pJxhDAW.png)

#### 步驟五:
~~~sql=
select C.CompanyName, UnitPrice*Quantity*(1-Discount) as LineTotal From Orders as O
inner join [Order Details] OD
On O.OrderID = OD.OrderID
inner join [Customers] C
On C.CustomerID = O.CustomerID
~~~
### 說明:
查詢合併後的資料表，欄位名稱為Companyname，以及經過運算式所得的值，命名為LineTotal。
![](https://i.imgur.com/Arwj0If.png)

#### 步驟六:
~~~sql=
select O.OrderID,C.CompanyName, UnitPrice*Quantity*(1-Discount) as LineTotal From Orders as O
inner join [Order Details] OD
On O.OrderID = OD.OrderID
inner join [Customers] C
On C.CustomerID = O.CustomerID
~~~
### 說明:
查詢 **O** 的OrderID、Companyname、LineTotal (注意: OrderID需指定為哪張表的OrderID，**若無指定會報錯誤訊息: 模稜兩可** )
![](https://i.imgur.com/xKGLREz.png)


#### 步驟七:

~~~sql=
select O.OrderID,C.CompanyName, UnitPrice*Quantity*(1-Discount) as LineTotal From Orders as O
inner join [Order Details] OD
On O.OrderID = OD.OrderID
inner join [Customers] C
On C.CustomerID = O.CustomerID

Group by CompanyName
~~~
### 說明:
![](https://i.imgur.com/F3NnfHz.png)
錯誤原因：OrderID 非Groupby條件或總合運算所以必須拿掉

~~~sql=
select C.CompanyName, SUM( UnitPrice*Quantity*(1-Discount) ) as Total From Orders as O
inner join [Order Details] OD
On O.OrderID = OD.OrderID
inner join [Customers] C
On C.CustomerID = O.CustomerID
Group by CompanyName
~~~
### 說明:
刪除OrderID即可正常執行，`Group by` 為群聚條件，依指定條件合併，將多筆record合併成單一record

![](https://i.imgur.com/mf63esm.png)

#### 步驟八:排序(由大到小)
~~~sql=
select C.CompanyName, SUM( UnitPrice*Quantity*(1-Discount) ) as Total From Orders as O
inner join [Order Details] OD
On O.OrderID = OD.OrderID
inner join [Customers] C
On C.CustomerID = O.CustomerID
Group by CompanyName
Order by Total Desc  //反序
~~~
### 說明:
`Order by`作為排序條件，`Desc`為反排序
![](https://i.imgur.com/zcbJRfY.png)

#### 步驟九:挑出前幾筆資料(在select後面加上"Top 數字")
~~~sql=
select Top 1 C.CompanyName, SUM( UnitPrice*Quantity*(1-Discount) ) as Total From Orders as O
inner join [Order Details] OD
On O.OrderID = OD.OrderID
inner join [Customers] C
On C.CustomerID = O.CustomerID
Group by CompanyName
Order by Total Desc
~~~

#### 顯示第一筆資料
![](https://i.imgur.com/ndrCCKN.png)

#### 顯示前五筆資料
![](https://i.imgur.com/hjaZ0da.png)
## 新增View
**def:**
檢視: 將常用的`select`查詢建成虛擬資料來源，以方便查詢使用，**實際上不存放資料**，只存放`select`，使用時才查詢資料。

### 說明:將以上複雜的查詢建立成一個View(方便以後快速查詢)
~~~sql=
create view dbo.TopCustomers
as
select C.CompanyName, SUM( UnitPrice*Quantity*(1-Discount) ) as Total From Orders as O
inner join [Order Details] OD
On O.OrderID = OD.OrderID
inner join [Customers] C
On C.CustomerID = O.CustomerID
Group by CompanyName

select * From TopCustomers
~~~
### 說明:
`Create view` 建立view，`alter view`修改view。

![](https://i.imgur.com/lHm2iRw.png)

~~~sql=
select Top 10 * From TopCustomers //從View中挑選前10筆資料
~~~
![](https://i.imgur.com/WmPgkM2.png)

### 建立有排序(大到小)且取前10筆資料
~~~sql=
create view dbo.Top10Customers
as
select Top 10 C.CompanyName, SUM( UnitPrice*Quantity*(1-Discount) ) as Total From Orders as O
inner join [Order Details] OD
On O.OrderID = OD.OrderID
inner join [Customers] C
On C.CustomerID = O.CustomerID
Group by CompanyName
Order by Total Desc
~~~
![](https://i.imgur.com/mllQcr4.png)

~~~sql=
select * from Top10Customers
~~~
![](https://i.imgur.com/yhJpfK1.png)

## clustered index 查詢: WHERE比對
### 完整比對
```sql=
select * from Products
WHERE ProductName = 'Ipoh Coffee'
```
***特殊情況***
若資料有單引號，例如：Bon app'
在單引號裡，則用雙引號表示 -> ' Bon app'' '

### 模糊比對
```sql=
select * from Products
WHERE ProductName like 'c%'           //字串開頭為c

select * from Products
WHERE ProductName like 'c_a%'         //第一個字元為c，第二個字元為任意，第三個字元為a

select * from Products
WHERE ProductName like '[A-F]%'       //開頭為A或B或C或D或E或F字元的字串

select * from Products
WHERE ProductName like '[^A-F]%'      //開頭不為A或B或C或D或E或F字元的字串

select * from Products
WHERE ProductName like '[^A-F, ^M-Q]%' //開頭為G或H或I或J或K或L字元的字串
```
## like 關鍵字
> % : 不管任何字
 _ : 忽略任一字元
 []: 該字元為指定的區間
 [^ ]: 該字元不為指定的區間

## Q：哪些客戶沒有消費?
##### 說明：選出沒有在Orders裡出現的CustomerID
~~~sql=
select * from Customers
where CustomerID Not In
( select Distinct CustomerID from Orders)
//Distinct->不重複
~~~
## Q：哪些產品沒有售出?
##### 說明：選出沒有在Orders裡出現的ProductID
~~~sql=
select * from Products
where ProductID Not In
( select Distinct ProductID from Orders)
~~~
## Q：哪些產品未曾售出?(課堂小考)
~~~sql=
select * from Products

WHERE ProductID Not In 
(select Distinct ProductID From [Order Details])

~~~

## 複製原有table 至新的table
```sql=
// 建立相同的schema&資料的table
select * into product2 from Products
select * from product2

// 建立一個相同schema但資料為空的table
select * into product3 from Products
where 1 = 2
select * from product3

// 複製products內的資料到product3這個空的table
insert into product3
select * from Products
```
## Inner Join：合併條件為兩邊都有的欄位
```sql=
select E.EmployeeID, O.EmployeeID from Employees E
inner join [orders] O
On E.EmployeeID = O.EmployeeID
```
## (Right/Left/Full) Outer Join：
以(右邊/左邊/一邊)的Data Object為基礎全部顯示，(右邊/左邊/一邊)有而另一邊沒有的顯示為Null。

```sql=
select E.EmployeeID, O.EmployeeID from Employees E
Left Outer join [orders] O
On E.EmployeeID = O.EmployeeID
```
## Union：
將兩個結構相容(欄位數相同，資料格式相容)的資料集疊加，欄位數不動，資料筆數增加。

#### 範例一：A+B資料
```sql=
select * from Products Where ProductID < 10  //->A資料
union //合併
select * from Products Where ProductID >30 AND ProductID < 50 //->B資料
```

#### 範例二：B+A資料
```sql=
select * from Products Where ProductID >30 AND ProductID < 50 //->B資料

union

select * from Products Where ProductID < 10 //->A資料
```

#### 範例三：僅取 ProductID [ID], ProductName [Name]，兩個欄位合併。
#### 合併後的欄位名稱為：ID、Name
```sql=
select ProductID [ID], ProductName [Name] from Products Where ProductID < 10

union

select ProductID [No.], ProductName [User] from Products Where ProductID >30 AND ProductID < 50

```
#### 合併後的欄位名稱為：NO.、User
```sql=
select ProductID [No.], ProductName [User] from Products Where ProductID >30 AND ProductID < 50

union

select ProductID [ID], ProductName [Name] from Products Where ProductID < 10
```

---
## Cross Join
將Left資料物件的每一筆record都和Right資料物件的每一筆record做合併 =>欄位數相加，資料數相乘。
### 操作
分別建立 Name1、 Name2 、Name3 三個table，在三個table中個別新增10筆資料。

**Name1**
| 欄位名稱 | 資料結構 | 
| -------- | -------- | 
| 姓     | NVarChar(2)     |

**Name2**
| 欄位名稱 | 資料結構 | 
| -------- | -------- |
| 名1     | NChar(1)|
**Name3**
| 欄位名稱 | 資料結構 | 
| -------- | -------- |
| 名2     | NChar(1)|

```sql=
select [姓]+ [名1] + [名2] [姓名] 
from Name1 
cross join Name2 
cross join Name3 

//Cross Join後總共會產生1000筆資料。
```
## 以XML作為格式作查詢
```sql=
select * from Customers for XML auto
```

---
## Stored Procedures
預存程序：儲存在DBMS端的程式碼，方便重複執行一些動作，程式碼也是SQL語法寫成。
位於"可程式性"資料夾之下。
```sql=
select * from Orders
exec [dbo].[Sales by Year] ' 1996-07-04 00:00:00.000', ' 1996-11-26 00:00:00.000' 
//exec -> 執行
//[dbo].[Sales by Year] -> 預存程式的名稱
```