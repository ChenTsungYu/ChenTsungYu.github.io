---
title: "[Github Action] 整合 AWS OIDC 進行 CI/CD 安全強化"
catalog: true
date: 2022/11/127 16:00:10
tags: [DevOps, GithubAction, CICD]
categories: [DevOps]
toc: true
---

<!-- toc -->
# 前言
目前公司的專案大量使用 [Github Action](https://github.com/features/actions) 跑自動化 CI/CD 的 pipelines 去部署服務到 AWS 環境，近期將原本 CI/CD pipelines 上與 AWS service 驗證的 workflows 做調整，驗證方式從原本藉由 IAM User 進行 assume role  的方式改成透過 AWS ODIC 的方式完成 assume role。

相較於以前的作法，使用 IAM user 的 secrets 驗證，OIDC 的作法能幫助我們省去管理金鑰的麻煩。

本文會 AWS 作為 cloud provider，設定方法也是以 AWS 為範例，以下內容建議有 GitHub Action 及 AWS IAM 這兩項先備知識比較能理解。
<!--more-->
# OIDC
OpenID Connect 以 OAuth 2.0 為基礎設計，藉由一組短期的 token 交換作為驗證方式，用於認證使用者登入，GitHub Actions 提供 OIDC 的驗證/授權機制，與其他第三方的雲服務供應商 (如： AWS, Azure, Google Cloud Platform 等) 進行整合，提供 CI/CD 工作流程上更簡便的設計。

## 使用 OIDC 好處
### 不需要提供 secrets
以前的作法都是從 cloud service IAM 產出驗證的 secrets，將這些 secret 存放在 GitHub secrets 裡面，在 workflow 透過變數的方式帶入。

OIDC 的作法可以省去這些 secrets，只要 OIDC 與 Cloud provider 上的信任政策設定好即可，不需要額外產生驗證的 secrets，也避免 secret 可能外洩的問題。
### 簡化身份驗證和授權管理
試想如果今天有多個 workflows 需要與不同 cloud service 互動，要限縮權限的話勢必需要產生擁有 could service 相應權限的 secrets，最終它們可能會四散在不同 repo 裡，管理的數量也會隨需求越來越多。

OIDC 因為不需要產生額外的 secrets 驗證，就不用考慮管理問題。
### 省去輪換 secrets 的工作
大部分的組織政策會要求 secret 要定期輪換，要換這麼多 secrets 也是相當耗時的事情。

而 OIDC 完全不必考慮 secrets 輪換。
### 權限控制的範圍
OIDC 在 cloud provider 上的信任政策設定能將授權範圍限縮在某個 repository 甚至到某個 brach。
## 流程
![workflow diagram](/images/workflow.png)

OIDC 在 cloud 之間的交換流程上分為幾個步驟：
1. 在 cloud provider 上建立 OIDC 信任政策，設定 IAM Role 與 GitHub provider workflows 間的存取政策，讓 GitHub 的 OIDC Provider 之後送來的 token 做驗證。
2. 每次 GitHub Action 的 workflow 被觸發時，GitHub 的 OIDC provider 會自動生成一組獨立的 OIDC token (即 JSON Web Token)，作為 workflow 的身份驗證，將其發送至 cloud provider。
3. Cloud provider 對收到的 Token 內容與 OIDC 信任政策的設定進行驗證
4. 一旦驗證成功，Cloud provider 會提供 GitHub OIDC provider 一組效期短的 access token，且僅在這個 workflow 運行期間有效。

> 注意:
> GitHub Actions 使用 OIDC 作為驗證管道時，務必確認對接的服務提供商支援這類的驗證方式。

# 設定方式
要在 AWS 上設定 OIDC 與 GitHub Actions 互動，會需要先到 AWS console 頁面，選擇 IAM 這項服務，並於左方導覽列找到 **“Identity providers”**。
![Identity providers](/images/Identity_providers.png)

點擊後畫面右方有個 **“Add provider”** 按鈕，新增我們要的 provider
![Add provider](/images/add_provider.png)

接著勾選 **“OpenID Connect”** 並於 **“Provider URL”** 輸入匡輸入驗證用的 OIDC URL 及 Audience
![OIDC URL & Audience](/images/OIDC_URL_audience.png)

這個設定步驟要注意兩個地方:
- Provider URL: 
如果是使用官方維護的 GitHub server，填：`https://token.actions.githubusercontent.com`
若為組織內部自己架設的，則填寫 OIDC connector 的 endpoint。
- Audience:
採用 AWS 官方的 [action](https://github.com/aws-actions/configure-aws-credentials)，填 `sts.amazonaws.com`

都填好後即可新增 provider，畫面如下：
![providers](/images/providers.png)

接著我們要建立一個 for assume role 用途的 IAM role，這樣 CI/CD workflow 執行時才能有權限與 AWS 上的服務互動。

一樣在 IAM 頁面左方導覽列找到 Roles → Create role → Trusted entity type 選 **“Web identity”** → Identity provider 選剛剛建好的 provider 後進入下一頁選擇綁定的權限。
![IAM Identity provider](/images/iam_id_provider.png)

將 role 希望擁有權限的相關 Policies 在此步驟裡面都加進來，例如想要操作 S3，我們就需搜尋 S3 相關的 Policies。 
![Policies](/images/policies.png)

最後是訂定 role 的名稱，下方 `Federated` 裡會自動帶入 OIDC provider 的 arn，確認好後就能新增 for S3 權限的 role。
![IAM S3 Role](/images/IAM_S3_Role.png)

建好之後回到剛才 role 裡面，編輯 trust policy (信任政策)。
![trust policy](/images/trust_policy.png)

一開始建立好的 role 並沒有針對 GitHub repository 做存取權範圍的設定，所以要在 trust policy 裡的 `Condition` 定義範圍。

trust policy 定義範圍的方法有許多種，也支援 wildcard (`*`) 符號，範圍可以選擇特定的 repo 、某個 repo 下的 branch 等，通用格式如下：
`repo:<orgName/repoName>:environment:<environmentName>`

```yaml
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Federated": "arn:aws:iam::<accountId>:oidc-provider/token.actions.githubusercontent.com"
            },
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
                "StringEquals": {
                    "token.actions.githubusercontent.com:aud": "sts.amazonaws.com"
                },
                "StringLike": {
                    "token.actions.githubusercontent.com:sub": "repo:<orgName/repoName>:environment:<environmentName>"
                }
            }
        }
    ]
}
```
**Note:**
- `aud` 描述的是剛剛在 id provider 填入的內容; `sub` 則是指定驗證/授權的 GitHub repo。
- `StringEquals` 與 `StringLike` 兩者在使用上稍有不同，`StringEquals` 適用於完全相符的名稱，例如希望指定某個 repo 下的 main branch，而 `StringLike` 搭配 wildcard 可選取某個特定範圍，例如某個 repo 下所有的 branch。
- `sub` 裡指定的 repo 如果有多個時，改成 `[  "repo:<orgName/repoName>:environment:<environmentName>", "repo:<orgName/repoName>:environment:<environmentName>", ......  ]`  的寫法。

範例：指定個人 GitHub 帳號下 repo 名為 **gh-action-demo** 的所有 branch
`repo:ChenTsungYu/gh-action-demo:*`

未來在這個 repo 下觸發 GitHub Action 的 workflow 時，OIDC provider 便有權與設定好的 IAM role 互動，更多範例可參考官方文件 - [Example subject claims](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/about-security-hardening-with-openid-connect#example-subject-claims)

## 在 GitHub workflow 加入權限
於 OIDC 驗證的 workflow 裡務必要設置權限
```yaml
permissions:
  id-token: write # This is required for requesting the JWT
  contents: read  # This is required for actions/checkout
```
## 範例：
在目標要觸發 CI/CD 的 GitHub repo 下建立 Action workflow，透過 Action assume 到前面建好的 IAM role: `github-actions-role-s3` ，查詢所有的 S3 buckets。

GitHub repo 下的資料夾結構：
```yaml
|-- .github
|   -- workflows
|      -- aws-oidc.yaml
```

![GitHub repo](/images/GitHub_repo.png)
`aws-oidc.yaml` 便是我們要觸發的 Action workflow。

將下方範例的 `<account ID>` 替換成自己的 AWS account ID

```yaml
name: AWS OIDC connector
on:
  workflow_dispatch:

# permissions settings for the token.
permissions:
      id-token: write
      contents: read

jobs:
  oidc-s3:
    runs-on: [ubuntu-latest]
    steps:
    - uses: actions/checkout@v3   
        
    - name: OIDC config of github-actions-role for aws credential
      uses: aws-actions/configure-aws-credentials@v1-node16
      with:
          role-session-name: GithubActionsTerraform
          role-skip-session-tagging: true
          role-to-assume: arn:aws:iam::<account ID>:role/github-actions-role-s3
          aws-region: ap-northeast-1

		- name: check aws identity
      run: aws sts get-caller-identity

      # Check all buckets from AWS s3
    - name:  list s3
      run: |
          aws s3 ls
```

上面的 workflow 範例分別進行了 AWS 驗證，assume 到建立好的 IAM role - `github-actions-role-s3` ，查詢 account 下所有的 S3 buckets。

將新增的 workflow 加進 git commit 後推上 GitHub，並於 repo 的 Action 分頁點選剛剛自訂的 workflow - AWS OIDC connector，找到畫面右方按鈕 “Run workflow” 觸發 workflow

![workflows](/images/workflows.png)

等 workflow 跑完的結果
![workflow result](/images/workflow_result.png)

點進去 workflow 可以看到 job 裡每個 step 執行結果，在 list s3 這個 step 能與 AWS S3 正常互動，列出了 AWS account 下所有的 S3 buckets。
![S3 buckets](/images/S3_buckets.png)

# 總結
前面介紹 OIDC 設置的整個流程中，與 AWS service 之間的互動沒有一個地方需要管理驗證用的 secret，GitHub provider 與 AWS 之間互相傳遞 token 進行驗證的過程都在背後默默進行，我們沒有另外產生額外的 secret 來驗證。

如此一來，後續有其他的 GitHub repos 要使用相同 IAM role 執行別的任務時，只需將 role 的 trust policy 設定加上指定的 repos 即可，不僅減少管理 secret 的工作，同時也避免 secret 可能外洩的問題。

# 參考
- [Creating a role for web identity or OpenID Connect Federation (console)](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_create_for-idp_oidc.html)
- [https://github.com/aws-actions/configure-aws-credentials#assuming-a-role](https://github.com/aws-actions/configure-aws-credentials#assuming-a-role)
- [https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services#adding-the-identity-provider-to-aws](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services#adding-the-identity-provider-to-aws)