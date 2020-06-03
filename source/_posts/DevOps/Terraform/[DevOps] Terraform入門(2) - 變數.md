---
title: "[Terraform] Terraform入門(2) - 變數"
catalog: true
date: 2020/04/03 8:00:10
tags: [DevOps, Terraform, AWS]
categories: [DevOps]
toc: true
---
<!-- toc -->
# 前言
本篇為Terraform系列的第二篇，紀錄Terraform如何定義及應用變數
<!--more-->
# Hands on Lab
##  變數宣告
`variable`開頭做變數宣告，後面接自定義的變數名稱，如下方範例，變數名為`iam_user_name`，變數值為`my_iam_user`
```bash=
variable "iam_user_name" {
  default = "my_iam_user"
}
```
> 若無給予`default`這個屬性的話，執行`terraform apply`後會要求輸入值。

![](https://i.imgur.com/Q7yn49m.png)
### 匯出變數
除了上面使用變數宣告的方法外，也可以在終端機中輸入指令來定義變數，如:
#### Mac版
採`export TF_VAR_iam_user_name=VALUE`的語法來匯出變數。
```bash=
export TF_VAR_iam_user_name="test_prefix"
```
匯出變數後執行`terraform plan -refresh=false`查看變化
![](https://i.imgur.com/W7vUuqK.png)
上圖可觀察到`iam_user_name`替換成`test_prefix`


#### Windows版
相異於Mac指令，Windows版採用`SET VARIABLE=VALUE`指令來匯出變數。
## 取用變數值
採`var.*`的方式來取得變數值，如延續[上一篇文的範例](https://chentsungyu.github.io/2020/04/02/DevOps/Terraform/%5BDevOps%5D%20Terraform%E5%85%A5%E9%96%80/):
```bash=
resource "aws_iam_user" "my_iam_user" {
  count = 2
  name  = "${var.iam_user_name}_${count.index}"
}
```
更改後執行`terraform apply`指令。
另外也可以透過`terraform console`的方式驗證是否能取得變數值。
![](https://i.imgur.com/BtuDWQ8.png)
## 賦予變數型態
既然能給變數值，那當然也可以定義變數型態啦，只要在宣告變數的地方給予`type`屬性，並指定哪個型態作為屬性值。如：
```bash=
variable "iam_user_name" {
  default = "my_iam_user"
  type = string #any(預設) or number, boolen, list, map
}
```

## 統一管理變數(variable)
我們可以另外建一個`terraform.tfvars`或是`*.auto.tfvars`檔案來集中管理變數。
### 範例
於根目錄下建立一`terraform.tfvars`檔案，此檔寫入
```bash=
iam_user_name = "tf_file_test_iam_user_name"
```
表示宣告變數`iam_user_name`，並賦予值`tf_file_test_iam_user_name`。
執行`terraform plan -refresh=false`查看變化
![](https://i.imgur.com/sLAPLZ5.png)
