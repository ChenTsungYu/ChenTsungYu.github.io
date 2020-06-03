---
title: "[Terraform] Terraform入門(1)"
catalog: true
date: 2020/04/02 8:00:10
tags: [DevOps, Terraform, w3HexSchool, AWS]
categories: [DevOps]
toc: true
---
> 鼠年全馬鐵人挑戰 - WEEK 08

![](https://i.imgur.com/YvU9Gc6.png)
<!-- toc -->
# 前言
因目前實習公司代理許多雲服務，有使用Terraform撰寫腳本來管理雲平台，藉此機會筆記一下學習Terraform這項工具。本篇會紀錄如何實際撰寫Terraform腳本來操作AWS S3、IAM這兩項服務。
<!--more-->
# 什麼是Terraform？
Terraform是由HashiCorp這家公司所開發，是一個基礎架構即程式碼(Infrastructure as Code;簡稱IaC)的開源工具，關於IaC架構的細節可參考[這篇](https://www.ithome.com.tw/tech/106167)，而且它支持多種雲環境，還可以進行版本控制。
可以想像一種情況，如果今天有多個雲要進行管理，可能架構會隨時需要調整，或是要配置資料庫、網路安全等設定時Terraform變成是很好的工具去管理這些雲端的基礎架構。以AWS為例，有了Terraform後，我們便不再需要透過手動操作滑鼠點擊console介面，只要撰寫好 Terraform 腳本，一鍵就能完成想要做的事情，透過程式碼去管理擁有的雲端資源。
簡單歸納一下Terraform的優點及特色
* 針對擁有的雲端服務做版本控管
* 自動化測試雲端架構
* 容易閱讀，一起開發的人可閱讀腳本理解目前使用的雲服務相關設定
* 在不同的環境下(如: 開發、測試、實際上線)，雲服務的配置都會相同
* Terraform的檔案副檔名是`*.tf`
* 用[HCL](http://lifuzu.com/blog/2019/02/10/using-terraform-external-data-source/)語言撰寫
* 跨平台(支援哪些平台可看[官方文件](https://www.terraform.io/docs/providers/))

# Hands On Lab
## 安裝
[官方載點](https://learn.hashicorp.com/terraform/getting-started/install.html)
如果是Mac的話可以使用Homebrew
```bash=
brew install terraform
```
當然也可以手動下載壓縮檔，解壓縮到`/usr/bin`、`/usr/local/bin` 目錄，解壓縮得到編譯好的執行檔。
## 查看版本
檢查是否可執行terraform，開啟終端機，輸入`terraform -version`，會顯示當前terraform版本訊息
![](https://i.imgur.com/GjwMRMh.png)

## 初始化Provider
先來個範例吧！
在專案資料夾建立一個名為`main.tf`的檔案
```bash=
# Configure the AWS Provider
provider "aws" {
  region = "us-east-2"
}
```
下指令進行初始化
```bash=
terraform init
```
terraform 會根據在當前的目錄下產生一些本地端設定，並根據上面的設定下載相對應的二進位檔，放到`.terraform`目錄中。
上述的程式碼中，`provider`用於決定對哪一個平台操作 `region`是AWS需要的屬性，表示地區。
![](https://i.imgur.com/foPxFOr.png)
## 配置Provider
將終端機出現的`version = "~> 2.55"` 這段資訊加入`main.tf`內。
```bash=
# Configure the AWS Provider
provider "aws" {
  region = "us-east-2"
  version = "~> 2.55"
}
```
## 查看當前目錄結構
![](https://i.imgur.com/2TawSA9.png)
## 下載並匯出 Access Key
開啟終端機，輸入下方指令，並替換成自從AWS download下來的Access Key
```bash=
export AWS_ACCESS_KEY_ID=Your Access Key
export AWS_SECRET_ACCESS_KEY=Your SECRET ACCESS Key
```
## 建立S3
### 配置resource
`resource`是表示決定用指定雲平台中的哪個服務(資源)，採類似JSON的結構，結構大概會是
```bash=
resource 雲端服務(服務)名稱 自定資源名稱 {
  屬性 = 值
}
```
以AWS S3作為範例:
```bash=
# plan - excute
resource "aws_s3_bucket" "my_s3_bucket" {
    bucket = "my-s3-bucket-terraform-01"
}
```
上述程式碼表示以aws_s3_bucket為雲端資源(AWS有S3這項儲存靜態資源的服務)，並自定義一個`my_s3_bucket`名稱
### 查看Terraform異動
在實際執行之前觀察 Terraform 將做哪些哪些改變，這是為了防止我們修改到我們不應該修改的東西，或是有不是我們預期的結果
```bash=
terraform plan
```
![](https://i.imgur.com/VMlNyM0.png)
### 執行/創建
```bash=
terraform apply
```
![](https://i.imgur.com/ulyBx4V.png)
這裡 Terraform 一樣會輸出相關的資訊內容，告訴你會有哪些改變，並讓你輸入去確認是否真的要執行，只要輸入 yes，就會實際開啟S3服務了。
![](https://i.imgur.com/G9lZodz.png)
建立成功！

成功後回到S3 管理介面就會看到剛剛建立好的bucket囉！
![](https://i.imgur.com/hGalTTq.png)
### 查看狀態(state)
terraform在執行完後，會在當前目錄下產生一個`terraform.tfstate`檔，此檔案包含了透過terraform 產生出來resource的詳細資訊，而terraform依據這個檔案來追蹤及維護resource。
輸入下方指令可秀出當前resource狀態的相關資訊
```bash=
terraform show
```
![](https://i.imgur.com/IfUQbgf.png)
### 異動
假設今天我們把`bucket = "my-s3-bucket-terraform-01"`改成`bucket = "my-s3-bucket-terraform-02"`並執行`terraform apply`，會看到如下圖所示的異動資訊
![](https://i.imgur.com/LsqXfbB.png)
回到S3管理介面會看到名稱已經做更動
![](https://i.imgur.com/g2SyYqH.png)

> 因為`terraform.tfstate`保留所有resource的狀態，執行terraform命令時，這個檔案必須要存在，確保 terraform可以正確的監聽resource的狀況。

另外，透過`terraform plan`指令，可以讓你在實際執行之前觀察Terraform將做哪些哪些改變
### 啟動Versioning
S3有個[Versioning的功能](https://docs.aws.amazon.com/AmazonS3/latest/dev/Versioning.html)，現在我們要透過撰寫`.tf`黨的方式來開啟這個功能，於`resource`內添加`versioning {enabled = true}`這段程式碼
```bash=
resource "aws_s3_bucket" "my_s3_bucket" {
    bucket = "my-s3-bucket-terraform-02"
    versioning {
        enabled = true
    }
}
```
添加完畢之後執行`terraform apply`，terraform會自動幫我們變更S3的設定，執行後會看到下方這段訊息:
![](https://i.imgur.com/F8bv84x.png)
表示versioning功能已被開啟，接著回到aws S3的console介面點選`my-s3-bucket-terraform-02`，找到`Properties`
![](https://i.imgur.com/LdredzD.png)
上圖可檢視此功能成功被開啟！
### 刪除
執行`terraform destroy`就可以清除所有的資源，會要你輸入`yes`做為確認。
## terraform console
terraform也提供console的方式來遠端操作
### 實作
執行下方指令進入console
```bash=
terraform console
```
![](https://i.imgur.com/mWQurQU.png)
如果要查看剛剛建立的S3 bucket，依照resource中的`type.name`的方式輸入指令，如:
```bash=
aws_s3_bucket.my_s3_bucket
```
表示從aws_s3_bucket這個resource中選擇剛剛建立的my_s3_bucket
![](https://i.imgur.com/upE1g3l.png)
執行指令後會秀出該Bucket內含的相關資訊。
當然我們也可以往下找更詳細的資訊，如剛剛新增的`versioning`指令
```bash=
aws_s3_bucket.my_s3_bucket.versioning
```
![](https://i.imgur.com/RD3DQDZ.png)
回傳值為一個**list**資料結構的資訊，所以可以近一步取得list內的物件。
```bash=
aws_s3_bucket.my_s3_bucket.versioning[0].enabled
```
![](https://i.imgur.com/oaUuKMP.png)
### 退出console
```bash=
exit
```
## Output 查看輸出訊息
除了利用console查看`.tf`配置的訊息外，也可以撰寫`output`語法來輸出我們想要的訊息，例如印出剛剛在console內看到的訊息，可以把`aws_s3_bucket.my_s3_bucket.versioning[0].enabled`放入`output`中，如：
```bash=
output "my_s3_bucket_versioning" {
  value = aws_s3_bucket.my_s3_bucket.versioning[0].enabled
}
```
`my_s3_bucket_versioning`為自己定義的名稱，接著執行`terraform apply -refresh=false`查看訊息
![](https://i.imgur.com/69YRDlT.png)
或是可以印出完整的訊息
```bash=
output "my_s3_bucket_detail" {
  value = aws_s3_bucket.my_s3_bucket
}
```
## 操作IAM
接著用terraform腳本來建立AWS IAM User
```bash=
# IAM User
resource "aws_iam_user" "my_iam_user" {
    name = "my_iam_user001"
}
```
在終端機輸入指令
```bash=
terraform plan -out iam.tfplan
```
![](https://i.imgur.com/s22KCDD.png)
畫面會提示輸入`terraform apply "iam.tfplan"`的指令
![](https://i.imgur.com/reELhuw.png)
印出上圖訊息表示成功建立IAM User
![](https://i.imgur.com/SkqPeBp.png)
如上圖，進入IAM User Console介面就會看見剛剛建立好的User哦！
當然我們也可以印出output來做檢查
```bash=
output "my_iam_user_detail" {
  value = aws_iam_user.my_iam_user
}
```
![](https://i.imgur.com/akev1CY.png)
### 更新IAM User name
假設要更改User名`my_iam_user001`為`my_iam_user001_update`
```bash=
# IAM User
resource "aws_iam_user" "my_iam_user" {
    name = "my_iam_user001_update"
}
```
更改完畢後，輸入下方指令
```bash=
terraform apply -target=aws_iam_user.my_iam_user
```
### 建立多個IAM User
本篇只有先記錄最基礎的用法，更多相關用法可參考[官方文件](https://www.terraform.io/docs/providers/aws/r/iam_user.html)。假設今天要一次建立兩個User，做法是給予IAM User這個Resource次數(count)，並透過物件的方式assign，如：
```bash=
resource "aws_iam_user" "my_iam_user" {
    count = 2
    name = "my_iam_user_${count.index}"
}
```
其中index編號是從0開始，執行`terraform apply`後打開console介面會看到新建立的兩個User，分別為`my_iam_user_0`、`my_iam_user_1`
![](https://i.imgur.com/pYtq42f.png)
## 補充一些較常用的指令
* `terraform fmt`： 將指令進行統一格式，改善因多人共同開發，各自風格差異過大的問題。
* `terraform graph`： 圖形化所有資源的相異性。
* `terraform import` : 導入目前已經在雲端上手動建立資源到Terraform中。
* `terraform validate`： 用於驗證是否存在語法錯誤。

以上透過AWS兩個服務範例來實作Terraform腳本，倘若有疏漏或錯誤之處，可在下方留言讓我知道！

# 參閱
[Terraform 入門學習筆記](https://godleon.github.io/blog/DevOps/terraform-getting-started/)


