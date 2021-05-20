---
title: "[ELK] 如何備份 Elastic Cloud 的 Snapshot 至 AWS S3"
catalog: true
date: 2021/03/13 23:51:53
tags: [DevOps, ELK, Kibana]
categories: [DevOps]
toc: true
---
# 前言
Elastic Cloud 提供快照 (Snapshot) 機制來備份 Cluster 的資料，我們可以將其連接至 AWS S3 上進行保存。

本文將示範如何將 Elastic Cloud Snapshot 存放至 AWS S3 服務，並設置 Policy 進行定期備份工作。
# 流程大綱
- AWS IAM 設置
- AWS S3 Bucket 設置
- Elastic Cloud Credential 設置 
- Elastic Cloud Repositories 和 Policy 設置

<!--more-->
# 實作
## AWS IAM 設置
### 建立 User
- 進入 AWS Console 的 IAM 服務頁面 
- 點擊左方欄位的 User，找到上方的 Add User 按鈕建立專門操作 S3 的 User
![](https://i.imgur.com/Q0ccu4d.png)
- 建立成功後會產生憑證資訊，點擊 Download .csv  下載至自己電腦
![](https://i.imgur.com/Z2kiEFD.png)

### 建立 Policy
- 點擊左方欄位的 Policies，找到上方的 Add Policy 按鈕建立專門操作 S3 的 Policy
![](https://i.imgur.com/iDTjBFJ.png)
- 貼下下方 JSON 格式的資料，定義好 Policy
```json=
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:ListAllMyBuckets",
            "Resource": "arn:aws:s3:::*"
        },
        {
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": [
                "arn:aws:s3:::elastic-cloud-snapshot-demo",
                "arn:aws:s3:::elastic-cloud-snapshot-demo/*"
            ]
        }
    ]
}
```
其中，本文以 `elastic-cloud-snapshot-demo` 為要存放 Snapshot 的 S3 Bucket Name，可自行替換成自訂的名稱。
![](https://i.imgur.com/exnL0HH.png)
- 自訂 Policy Name 後點擊 Create Policy 完成建立 
![](https://i.imgur.com/OihaHrO.png)
- 將目標 Policy Attach 至新建立的 User
- 選擇 Attach
 ![](https://i.imgur.com/AXA1WIK.png)
- 搜尋並選擇剛才新建的 User

## AWS S3 Bucket 設置
- 建立 S3 Bucket，自訂 Bucket 名稱，本文範例為 `elastic-cloud-snapshot-demo`，可自行替換成自訂的名稱。
![](https://i.imgur.com/0PYyNON.png)

## Elastic Cloud Credential 設置
- 進入 Elastic Cloud 後台管理介面，選擇要備份至 S3 的 Cluster → 左方列表中的 Security →  點擊右下 Elasticsearch Keystore 的 Add settings 按鈕
![](https://i.imgur.com/lAJKEAZ.png)
- 添加剛才於 AWS IAM 服務中新建 User 時所載的憑證資訊，裡面會包含 Access Key 和 Secret Key， 需要將這些資訊填入 KeyStore 中。
![](https://i.imgur.com/fc78XcH.png)
- 兩者皆填入後查看一下是否有顯示於畫面中
![](https://i.imgur.com/byNzoHE.png)

## Elastic Cloud Repositories 和 Policy 設置
- 於 Elastic Cloud 中設置 Registries 
![](https://i.imgur.com/V8fy393.png)
- 自訂 Repository 名稱 →  選擇 S3 → 點擊 Next
![](https://i.imgur.com/K6UaU5W.png)
- 填入 **Client** 名稱 (本文為 default) → 輸入目標的 S3 Bucket 名稱 (本文為 elastic-cloud-snapshot-demo)，其餘參數可依自身需求做調整，設定完點擊 Register 按鈕完成建立。
![](https://i.imgur.com/aUUiOiC.png)
- 建立成功後選擇剛剛建好的 Repository，可點擊下方的 Verify repository 檢驗是否成功連結
![](https://i.imgur.com/sQczAXW.png)
- 若成功連結會出現下圖的圖示
![](https://i.imgur.com/ojWv5Ty.png)
- 對該 Repository 新增對應的 Policy
![](https://i.imgur.com/ZDphPyQ.png)
- 輸入自訂的 **Policy Name** (本文為 elastic-cloud-cluster-backup) → 輸入自訂的 **Snapshot Name**  (本文為 `<cluster-daily-snap-{now/d}>` ) → 選擇目標 **Repository** → 設置 **Schedule** 排定備份的頻率
![](https://i.imgur.com/GtqIkGE.png)
- 選擇備份來源 Index (也可以點擊上方按鈕開啟 all data 做 全選)
![](https://i.imgur.com/koFlkvk.png)
- 最後確認一下設置的 Policy 資訊
![](https://i.imgur.com/Oz1rVLf.png)
- 設置成功後可以回 Snapshot 頁面查看是否有存在依剛剛規則所建好的 Snapshot 囉！
![](https://i.imgur.com/rsK8mmW.png)
- 回到 S3 Bucket 查看資料是否有成功備份
![](https://i.imgur.com/k7ewY83.png)

以上為備份 Elastic Cloud Snapshot 至 AWS S3 服務的整套流程。

# 相關參考文件
- [Configure a snapshot repository using AWS S3 ](https://www.elastic.co/guide/en/cloud/current/ec-aws-custom-repository.html)
- [Repository Settings](https://www.elastic.co/guide/en/elasticsearch/plugins/7.11/repository-s3-repository.html)


