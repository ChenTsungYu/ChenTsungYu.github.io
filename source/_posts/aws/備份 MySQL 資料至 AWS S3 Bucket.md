---
title: "[AWS] 備份 MySQL 資料至 AWS S3 Bucket"
catalog: true
date: 2020/09/30 09:00
tags: [AWS, MySQL, w3HexSchool, Linux]
categories: [Cloud]
---
> 鼠年全馬鐵人挑戰 - WEEK 20

<!-- toc -->
# 前言
現實生活中的系統，為了避免資料遺失，系統平時都該備份資料庫的資料。當系統發生問題時，能在最快的時間點還原原始資料。本篇文章紀錄如何將既有的MySQL資料庫內資料，藉由 Crontab 指令定期備份至 AWS S3
<!--more-->

# 前置作業
- 既有的MySQL資料庫，裡面有多張資料表
- OS: Ubuntu 18.04
- MySQL 5.7+
- AWS 帳號
- 下載 [AWS Cli tools](https://aws.amazon.com/tw/cli/)

# 流程
本文會依照下方流程實作備份:
- 什麼是 S3 Bucket
- 建立S3 Bucket
- 建立 IAM User
- 依照政策 賦予 IAM User 權限
- 撰寫備份用的 shell script
- 制定 Cron job 定期任務排程

## 什麼是 AWS S3
S3 是 AWS 提供的儲存服務，用於存放和擷取任意數量的資料，資料會以物件的形式進行儲存，花費的成本低廉，所以備份至S3是不錯的選擇。
## 建立S3 Bucket
進入已經創建好的 AWS 帳號，選擇 S3 服務，點擊**Create bucket**，接著輸入自訂的 bucket 名稱，下方選單選擇想要存放的Region
![](https://i.imgur.com/MOl80K8.png)
輸入完畢後點擊**Create bucket**
![](https://i.imgur.com/mQQwTuR.png)
## 建立 IAM User
![](https://i.imgur.com/l6SAzJP.png)
輸入User Name 且自訂密碼
![](https://i.imgur.com/9kikcfW.png)
新建policy
![](https://i.imgur.com/2CZaYcl.png)
貼上下方的JSON格式資料，並將資料內的`mysqlsourcebackup`替換成自己創建S3 Bucket 所取的名稱，修改完畢後點擊**Review Policy**
```json=
{
"Version": "2012-10-17",
"Statement": [
 {
  "Effect": "Allow",
  "Action": ["s3:ListAllMyBuckets"],
  "Resource": "arn:aws:s3:::*"
},
{
  "Effect": "Allow",
  "Action": [
    "s3:ListBucket",
    "s3:GetBucketLocation"
  ],
  "Resource": "arn:aws:s3:::mysqlsourcebackup"

},
{
  "Effect": "Allow",
  "Action": [
    "s3:PutObject",
    "s3:GetObject",
    "s3:DeleteObject"
  ],
  "Resource": "arn:aws:s3:::mysqlsourcebackup/*"


}
]
}
```
![](https://i.imgur.com/bX5M5Vv.png)
接著替自己創建的policy取名後，點擊**Create Policy**
![](https://i.imgur.com/Tsseakw.png)
回到剛剛創建User的介面，搜尋新創建的policy名稱進行勾選，就可以繼續執行一步到創建完成。
![](https://i.imgur.com/J7fFnle.png)
下載個人金鑰置個人電腦，金鑰為機密資訊，務必好好保管！也可以寄信至個人信箱
![](https://i.imgur.com/DYx2RuZ.png)
## 撰寫備份用的 shell script
### 建立`runbackup.sh`
```bash=
sudo vim runbackup.sh
```
填入下方程式碼，並修改`=`後方的值：
- `your_access_key`、`your_secret_key`: 為剛才創建帳號時下載的金鑰資訊
- `s3_region`: S3 bucket 所在之區域
- `S3_BUCKET`: S3 bucket 名稱
- 其餘為MySQL相關資訊: `host_name(e.g. localhost)`、`MYSQL_PORT(e.g. 3306)`

```bash=
#!/bin/bash
## 填入 AWS User Credential 的資訊
AWS_ACCESS_KEY_ID=your_access_key \
AWS_SECRET_ACCESS_KEY=your_secret_key \
## 填入 S3 資訊
AWS_DEFAULT_REGION=s3_region \
S3_BUCKET=your_buket_name \
## 填入MySQL資訊
MYSQL_HOST=host_name \
MYSQL_PORT=db_port \
MYSQL_USER=db_user \
MYSQL_PASS=db_password \
MYSQL_DB=db_name \
## 執行 backup.sh
bash -x backup.sh
```
修改完畢後按下`ESC`+`:wq!`儲存關閉。

### 建立`backup.sh`
```shell=
sudo vim backup.sh
```
寫入下方程式碼
```bash=
#!/bin/bash
cd /tmp
file=$(date +%A%d%B%Y).sql
mysqldump \
  --host ${MYSQL_HOST} \
  --port ${MYSQL_PORT} \
  -u ${MYSQL_USER} \
  --password="${MYSQL_PASS}" \
  ${MYSQL_DB} > ${file}
if [ "${?}" -eq 0 ]; then
  gzip ${file}
  aws s3 cp ${file}.gz s3://${S3_BUCKET}
  rm ${file}.gz
else
  echo "Error backing up mysql"
  exit 255
fi
```
修改完畢後按下`ESC`+`:wq!`儲存關閉。
### 測試腳本
```bash=
bash -x runbackup.sh
```
執行上述指令執行`runbackup.sh`這支腳本，到 S3 Bucket 的管理介面查看有沒有上傳成功！
![](https://i.imgur.com/q4Bi8tm.png)
## 制定 Cron job 定期任務排程
### 下載
```bash=
sudo apt update & sudo apt install cron 
```
確保有在背景執行
```bash=
sudo systemctl enable cron
```
成功的話會提示跟下方相同的訊息
```
Output
Synchronizing state of cron.service with SysV service script with /lib/systemd/systemd-sysv-install.
Executing: /lib/systemd/systemd-sysv-install enable cron
```
### 編輯 crontab
```bash=
crontab -e
```
執行上方指令，會跳出下方的提示資訊
```bash=
Output
no crontab for sammy - using an empty one

Select an editor.  To change later, run 'select-editor'.
  1. /bin/nano        <---- easiest
  2. /usr/bin/vim.basic
  3. /usr/bin/vim.tiny
  4. /bin/ed

Choose 1-4 [1]: 
```
個人習慣用Vim，故輸入`2`，可依個人習慣自由選擇，選擇好之後就會進入新建立的 crontab
![](https://i.imgur.com/OvxhGr3.png)
在下方新增排程時間，以及要執行的指令，假設是 **每天凌晨12:00** 進行排程任務，執行`runbackup.sh`這支檔案，就可以寫成下方的指令：
```bash=
0 0 * * * root bash -x /home/coupon/runbackup.sh
```
修改完畢後按下`ESC`+`:wq!`儲存關閉。
### 補充
- `bash -x /home/coupon/runbackup.sh` 為要執行的檔案，要確認檔案的所在位置是正確的！
- Crontab 時間結構

| 欄位 | 允許範圍 |
| -------- | -------- |
| minute     | 0-59 |
| hour     | 0-23 |
| day_of_month     | 1-31 |
| month     | 1-12 or JAN-DEC |
| day_of_week     | 0-6 or SUN-SAT |

- crontab 執行規則如下:
```bash=
minute hour day_of_month month day_of_week command_to_run
```

更多細節參考Digital Ocean Community所撰寫的[文章](https://www.digitalocean.com/community/tutorials/how-to-use-cron-to-automate-tasks-ubuntu-1804)，還蠻清楚的！
