---
title: "[Terraform] Terraform入門(4) - 利用Terraform來操作AWS EC2"
catalog: true
date: 2020/04/12 00:00:00
tags: [DevOps, Terraform,w3HexSchool, AWS]
categories: [DevOps]
toc: true
---

> 鼠年全馬鐵人挑戰 - WEEK 09

<!-- toc -->
# 前言
本篇為Terraform系列的第四篇，主要實作用Terraform遠端建立並連接EC2，代替之前手動點擊aws console，IAM的部分會選擇Amazon Linux AMI，閱讀本篇建議要先了解AWS EC2的相關知識。
<!--more-->
# Hands on Lab
## 建立Security Group
屬性可詳見官方給的[sample](https://www.terraform.io/docs/providers/aws/r/security_group.html)

```bash=
# Configure the AWS Provider
provider "aws" {
  region  = "us-east-2" #選擇你要的區域
  version = "~> 2.55"
}

// HTTP Server ->Security Group
// Security Group(即fire wall)=>  80 port : TCP , 22 port : TCP, CIDR: ["0.0.0.0/0"]
resource "aws_security_group" "http_server_sg" {
  name = "http_server_sg"
  vpc_id = "VPC ID" # 貼上AWS 預設的VPC ID
  ingress{ # ingress為入口的限制規則
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
    ingress{ # ingress為入口的限制規則
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress{ # 出口規則
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    name = "http_server_sg"
  }

}
```
依照上述程式碼執行`terraform apply`，即可成功建立Security Group

> 有關Security Group設定的rule，範例的設定不是比較安全的做法，如ingress設定。
> NOTE: Setting protocol = "all" or protocol = -1 with from_port and to_port will result in the EC2 API creating a security group rule with all ports open. This API behavior cannot be controlled by Terraform and may generate warnings in the future.
> 上述為其中一個有關安全設定的提醒，更多安全建議可參考[官方文件](https://www.terraform.io/docs/providers/aws/r/security_group_rule.html)

> 務必要看清楚當前**VPC所在的Region**，別像我一樣第一次實作把不同Region的VPC ID貼上去，結果一直跳出`The vpc ID  does not exist`的錯誤！

到AWS EC2的管理介面，左方列表找到**Security Groups**即可看見剛剛新建的Security Group
![](https://i.imgur.com/zVPbHHg.png)

## 下載key pair
至AWS EC2的管理介面，左方列表找到**Key Pairs**，進入頁面點擊**Create key pair**。
取名為ec2-terraform，選擇**pem**檔
![](https://i.imgur.com/qE86mz7.png)
完成建立的同時，會下載一組key pair到本地，將此檔移入專案資料夾中，接著更改檔案權限
```bash=
chmod 400 ec2-terraform.pem
```
`chmod 400`表示只有擁有者才能夠修改的權限，非擁有者只能夠讀取

## 建立EC2
接續上面的範例程式碼，接著新增`aws_instance`這個resource
```bash=
resource "aws_instance" "http_server" {
  ami = "ami-0e01ce4ee18447327" # 對應 Amazon Linux 2 AMI
  key_name = "ec2-terraform" # 下載至本地的pem檔檔名
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.http_server_sg.id]
  subnet_id = "subnet-16ee127d"
}
```
點擊**Launch Instance**，選擇AMI為**Amazon Linux 2 AMI**，Instance Type為**t2.micro**
AMI對應id的部分可以在Choose AMI的管理介面中看到每個IAM專屬的ID
![](https://i.imgur.com/mWpYvUl.png)
而Instance Type的部分可以參考AWS提供的type，不一定要按照上述範例
![](https://i.imgur.com/teCgPzD.png)

`vpc_security_group_ids`的話，其實可以從 **.tfstate** 檔案中找到security group 的id，不過建議靈活一點，不要直接寫死，還是透過`aws_security_group.http_server_sg.id`來取得id會比較好。

`subnet_id`的話，回到VPC管理介面，左方欄位有**subnet**，可找到想要的subnet id

確認沒問題之後可以先下`terraform validate`進行驗證，接著執行`terraform apply`就可以囉！
![](https://i.imgur.com/yWED9K1.png)

## 連接EC2
現在要進行遠端連接EC2，我的作法在專案目錄下新增一資料夾，名為aws_key_pair，並原先下載的key pair移入此資料夾下，再設一變數`aws_key_pair`，裡面存放key pair的位置路徑。
接著新增resource設定`connection`屬性。
* `type = "ssh"`: 表我們採用SSH的方式連接
* `host = self.public_ip`: 表主機對應的ip
* `private_key = file(var.aws_key_pair)`: 私鑰從本地專案夾內進行路徑搜尋，找到下載下來的`.pem`檔

接著設定`provisioner`屬性，`"remote-exec"`表進行遠端操作下達的指令，給定`inline`陣列，裡面存放要下達的指令，每行指令`,`區隔

```bash=
variable "aws_key_pair" {
  default = "./aws_key_pair/ec2-terraform.pem"
}

resource "aws_instance" "http_server" {
  ami = "ami-0e01ce4ee18447327" # 對應 Amazon Linux 2 AMI
  key_name = "ec2-terraform" # 下載至本地的pem檔檔名
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.http_server_sg.id]
  subnet_id = "subnet-16ee127d"
  
  connection { # 遠端連接EC2
    type = "ssh"
    host = self.public_ip # 公有ip
    user = "ec2-user"
    private_key = file(var.aws_key_pair)
  }
  provisioner "remote-exec" {      # 遠端執行指令
    inline = [                     # 連接遠端時，會開始執行一系列的指令
      "sudo yum install httpd -y", # install httpd
      "sudo service httpd start",  # start
      # 印出字串訊息至index.html 檔
      "echo Welcome to virtual server which is at ${self.public_dns} | sudo tee /var/www/html/index.html", # copy file
    ]
  }
}
```
新增連接EC2的程式碼後，須先將EC2 terminate才會執行`remote-exec`的指令，所以先執行`terraform destroy`，再執行`terraform apply`
![](https://i.imgur.com/GJ15gYt.png)
在終端機上大概會看到上述的執行畫面。
接著從`.tfstate`檔中找到`public_dns`對應的網址，貼上網址之後就可以順利訪問剛剛的內容囉！
![](https://i.imgur.com/Ijic44r.png)

## 進階：選用預設的VPC
直接使用預設(default)的VPC，將它改為動態的，用來取代原本寫死的`vpc_id`，Terraform會自動根據當前Provider設定的Region，找該Region下預設的VPC ID，這樣就不會發生像我上述犯下的錯誤: **找錯Region的VPC ID**
執行下方指令
```bash=
terraform apply -target=aws_default_vpc.default
```
並修改`vpc_id`給定的值
```bash=
# vpc_id = "vpc-4dbe6a26" # 貼上AWS 預設的VPC ID
  vpc_id = aws_default_vpc.default.id # 使用預設的VPC ID
```
執行下方指令
```bash=
terraform apply -refresh=false
```

### 完整程式碼
```bash=
# Configure the AWS Provider
provider "aws" {
  region  = "us-east-2"
  version = "~> 2.55"
}

resource "aws_default_vpc" "default" {
  
}
// HTTP Server ->Security Group
// Security Group(即fire wall)=>  80 port : TCP , 22 port : TCP, CIDR: ["0.0.0.0/0"]
resource "aws_security_group" "http_server_sg" {
  name   = "http_server_sg"
  # vpc_id = "vpc-4dbe6a26" # 貼上AWS 預設的VPC ID
  vpc_id = aws_default_vpc.default.id # 使用預設的VPC ID
  ingress {               // ingress為入口的限制規則
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress { // ingress為入口的限制規則
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress { # 讓任何人都能連進來
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    name = "http_server_sg"
  }
}

variable "aws_key_pair" {
  default = "./aws_key_pair/ec2-terraform.pem"
}
resource "aws_instance" "http_server" {
  ami                    = "ami-0e01ce4ee18447327"
  key_name               = "ec2-terraform"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.http_server_sg.id]
  subnet_id              = "subnet-16ee127d"

  connection { # 遠端連接EC2
    type        = "ssh"
    host        = self.public_ip # 公有ip
    user        = "ec2-user"
    private_key = file(var.aws_key_pair)
  }
  provisioner "remote-exec" {      # 遠端執行指令
    inline = [                     # 連接遠端時，會開始執行一系列的指令
      "sudo yum install httpd -y", # install httpd
      "sudo service httpd start",  # start
      # 印出字串訊息至index.html 檔
      "echo Welcome to virtual server which is at ${self.public_dns} | sudo tee /var/www/html/index.html", # copy file
    ]
  }
}

```
另外值得一提的是，官方有提到`aws_default_vpc`不同於其他的resource，Terraform並不會額外建立這項資源，而是直接將它納入管理。
> The `aws_default_vpc` behaves differently from normal resources, in that Terraform does not create this resource, but instead "adopts" it into management.
[官方文件](https://www.terraform.io/docs/providers/aws/r/default_vpc.html)