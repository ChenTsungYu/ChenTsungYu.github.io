---
title: "[Terraform] Terraform入門(3) - list&map"
catalog: true
date: 2020/04/04 8:00:10
tags: [DevOps, Terraform, AWS]
categories: [DevOps]
toc: true
---
<!-- toc -->
# 前言
本篇為Terraform系列的第三篇，主要紀錄在Terraform中的list和map兩種資料結構
<!--more-->
# Hands on Lab
## List
terraform list 如同一般程式語言的陣列結構，我們可以存放多個元素在陣列內，透過索引值(index)的方式進行查找。
```bash=
# declare variable
variable "names" {
  default = ["tom", "jack", "tonny"]
}

# Configure the AWS Provider
provider "aws" {
  region  = "us-east-2"
  version = "~> 2.55"
}

resource "aws_iam_user" "my_iam_user" {
  count = length(var.names)
  name  = var.names[count.index]
}
```
分別執行下方指令
```bash=
terraform init
terraform apply
```

在AWS IAM User分別新增`tom`、`jack`、`tonny`三位Users

接著進入terraform console
```bash=
terraform console
```
### 取得變數長度
```bash=
length(var.names)

# 3
```

### 反轉list中的元素順序
```bash=
reverse(var.names)
# [
#   "tonny",
#   "jack",
#   "tom",
# ]
```

### 合併list
```bash=
concat(var.names, ["amy"])
```
注意，合併時，資料結構為**list**，否則會報`Invalid value for "seqs" parameter: all arguments must be lists or tuples; got
string.`的錯誤訊息
![](https://i.imgur.com/AAuuSBv.png)
> `concat()`合併list時，不影響原始的list

### 排序list
```bash=
sort(var.names)
```

### 檢查是否存在
可以透過`contains`進行元素是否存在，存在的話回傳為`true`，反之為`false`。
```bash=
contains(var.names, "tom")
contains(var.names, "hey")
```
![](https://i.imgur.com/s2rVgKa.png)

### 限定範圍
```bash=
range(start, end, space)
```
* start：表起始值
* end：表結束值(實際印出的值為end-1)
* space：間隔(預設為1)

```bash=
range(1,10)
```
![](https://i.imgur.com/PYkFQ6w.png)

```bash=
range(1,20, 2)
```
![](https://i.imgur.com/CCq1Bpu.png)

更多Terraform 內建的functions可參考[官方文件](https://www.terraform.io/docs/configuration/functions.html)

### 添加terraform list
terraform list預設index以數值0開始做排序，如果想改以element名稱來排序的話，改成下方作法:
`main,tf`
```bash=
# declare variable
variable "names" {
  default = ["jason","tom", "jack", "chris"]
}

# Configure the AWS Provider
provider "aws" {
  region  = "us-east-2"
  version = "~> 2.55"
}

resource "aws_iam_user" "my_iam_user" {
  # count = length(var.names)
  # name  = var.names[count.index]
  for_each = toset(var.names)
  name = each.value
}
```
`for_each`可參考[官方文件](https://www.terraform.io/docs/configuration/resources.html), `each.value`可參考[官方文件](https://www.terraform.io/docs/configuration/expressions.html#local-named-values)
執行`terraform apply -refresh=false`後查看`terraform.tfstate`這個檔案內容，觀察變化。

![](https://i.imgur.com/NtHgcLD.png)
`index_key`由原本的數值轉為`jack`

## map
map在Terraform中的資料結構用`{key : value}`來表示，如要取得key對應的value值，語法為`key.value`。
範例
```bash=
# declare variable
variable "names" {
  default = {
    tom : "Taiwan",
    jack : "UK",
    chris : "US",
  }
}

# Configure the AWS Provider
provider "aws" {
  region  = "us-east-2"
  version = "~> 2.55"
}
```
進入`terraform console`
### 取得map內所有資料
```bash=
var.names
```
### 取得某個key對應的value
```bash=
var.names.jack
```
![](https://i.imgur.com/2sZtba9.png)
### map內取得所有的key名稱
```bash=
keys(var.names)

# [
#   "chris",
#   "jack",
#   "tom",
# ]
```
### map內取得所有的value
```bash=
values(var.names)

# [
#   "US",
#   "UK",
#   "Taiwan",
# ]
```

### 查看特定值
採`lookup(obj, "key")`
* `obj`: 目標物件
* `key`: 物件中的某個key
```bash=
lookup(var.names, "jack")

# UK
```

## 綜合練習
假設今天想建立三個IAM Users，分別讓每個User加上tag，tag值為對應所在的國家 
```bash=
# declare variable
variable "users" {
  default = {
    tom : "Taiwan",
    jack : "UK",
    chris : "US",
  }
}
# Configure the AWS Provider
provider "aws" {
  region  = "us-east-2"
  version = "~> 2.55"
}
resource "aws_iam_user" "my_iam_user" {
  for_each = var.users
  name = each.key # 對每個user加上key
  tags = {
    country :each.value # 加上key對應的value
  }
}
```
上述程式碼寫完執行`terraform apply`
查看aws IAM User管理介面，會新增程式碼寫的3個user
![](https://i.imgur.com/nojhPp7.png)
可點開單一user查看詳情，確認剛才建立的tag是否有真的加上去，以chris為例:
![](https://i.imgur.com/7bTuXjB.png)


或是採第二種做法： 原物件內再包一層物件
```bash=
variable "users" {
  default = {
    tom : {country :"Taiwan", department: "ABC"}
    jack : {country :"UK", department: "EFG"},
    chris : {country :"US", department: "XYZ"},
  }
}

# Configure the AWS Provider
provider "aws" {
  region  = "us-east-2"
  version = "~> 2.55"
}

resource "aws_iam_user" "my_iam_user" {
  for_each = var.users
  name = each.key
  tags = {
    # country :each.value
    country :each.value.country # 直接從第二層物件取value
    department :each.value.department
  }
}
```
![](https://i.imgur.com/QbNTAKR.png)

## 補充
本篇包含前面幾篇有關Teraaform的文章範例裡面，有提到`terraform apply`指令，眼尖的人會發現我後面在下執行的指令時，會在後面加`-refresh=false`。
主因是若日後專案變大，Terraform寫得腳本愈多，涉及到的服務愈來愈雜，每次執行時會花大量時間進行資源的請求，為了減少每次請求的數量及時間，採用cache的方式，每次執行時**只更新有異動的部分**，而非對所有服務重新請求所有的服務資源。

[Ref](https://www.terraform.io/docs/state/purpose.html)
> For larger infrastructures, querying every resource is too slow. Many cloud providers do not provide APIs to query multiple resources at once, and the round trip time for each resource is hundreds of milliseconds. On top of this, cloud providers almost always have API rate limiting so Terraform can only request a certain number of resources in a period of time. Larger users of Terraform make heavy use of the -refresh=false flag as well as the -target flag in order to work around this. In these scenarios, the cached state is treated as the record of truth.
