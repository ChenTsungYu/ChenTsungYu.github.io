---
title: "[Kubernetes] Kubernetes 基礎(ㄧ) 架構及元件"
catalog: true
date: 2021/09/07 8:00:10
tags: [Kubernetes, K8s]
categories: [DevOps]
toc: true
---
# 前言
![](https://miro.medium.com/max/240/0*X-_IGBEAB88amxNO.png)

Kubernetes 是一個用於管理多個容器的大型管理平台，原先是 Google 內部自行研發的系統，後來開源出來，讓世界各地的開發者都能加入開發、優化的行列，近期工作上開始接觸 Kubernetes，藉此記錄一下學習到的知識。
<!-- more -->
# 常見的容器部署模型 (Deploying Model)
以下列舉幾個常見的容器部署模型：
- 單一節點部署一個容器 (Single Container/Single Node)
- 單一節點部署多個容器 (Multiple Container/Single Node)
- 多節點部署多個容器 (Multiple Container/Multiple Node) => **Kubernetes 主要解決的問題** 

在單一節點上的容器部署，用 Docker 來實作的話可藉由撰寫 Dockerfile 以及 docker-compose 來完成。

當遇到多節點的容器部署問題時，其實 Docker 有推出 **Docker Swarm** 這樣的解決方案，但非本文記錄的重點，而 Kubernetes 的誕生也是為了解決多節點部署多個容器的問題，接著來了解一下 Kubernetes 的架構以及必須知道的元件吧！

# [Kubernetes Cluster Architecture](https://kubernetes.io/docs/concepts/overview/components/)
![](https://i.imgur.com/zPPhrN3.png)
Kubernetes Cluster 是由一個主要節點(Master Node) 與多個 Worker Node 所構成的叢集架構，Cluster 架構主要由下述兩大項所構成：
- Control Plane(控制平面)：也就是主要節點(Master Node)，扮演 Kubernetes 大腦的角色
- Node (節點; 又作 Worker Node)：可部署於虛擬機 or 實際的 Server 上，甚至能將 worker 放置於 container 裡面(藉由 **container in container** 的技術)。

## Master Node (主要節點)
Kubernetes 運作的指揮中心，可負責管理其他 Woker Node。一個 Master Node 中有四個組件：API Server、Etcd、Scheduler、Controller。

### Control Plane (控制平面)
Control Plane 裡有不同的應用程式，這四個角色組合成 Kubernetes 最重要的大腦功能，負責管控整個 Kubernetes 叢集(Cluster)，四個角色分別是：
- **API Server**
- **Scheduler**
- **Controller**
- **Etcd**

Kubernetes 可以在不同的節點(Node)來運行容器，Worker Node 可以部署在虛擬機、實際的 Server 甚至是容器(Container)上(將 Container 部署在 Container 上)。

Worker Node 與 Control Plane 之間可藉由安裝在 Worker Node 上的 **代理程式(Agent)** 與 Control Plane 裡的 API Server 進行溝通，同步目前 Cluster 內最新的狀況。

> ### 整個 Control Plane + 所有的 Workers = Kubernetes Cluster

另外，使用者端要與 Kubernetes Cluster 互動，一般有三種方式:
- API: 習慣撰寫程式的開發者可藉由 API 的方式與 Kubernetes 溝通
- CLI (Command Line Interface)：Kubernetes 提供一系列的工具列指令來溝通，這也是最常見的方式
- UI (使用者介面)：網頁的方式操作 Kubernetes 

**加入使用者後的整個 Kubernetes 架構圖：**

![](https://i.imgur.com/PYBCq0c.png)

接著探討 Control Plane 裡的四個重要角色:
### API Server
API Server 是管理 API 的伺服器，即 Control Plane 的前端，前述提到三種與 Kubernetes 互動的方式，所有的請求都是透過 API Server 第一個處理，由上方的架構圖可以看出： **每個 Node 彼此間的溝通都必須要透過 api server 代為轉介**。

換言之，若 API Server 無法正常運作，使用者使用的所有工具都無法對 Kubernetes 內部的資源進行存取

### Etcd
以 `key-value` 為儲存形式的資料庫，儲存 Kubernetes Cluster 的所有資源以及狀態，因為是儲存資料的地方，故相對應的資料備份、災難還原等措施相當重要

### Scheduler
替 API Server 從 container 裡面尋找合適的節點來部署，將資訊回傳給 API Server

**Scheduler 如何運作？**
![](https://i.imgur.com/yVWFl9A.png)

假設有多個候選節點，Scheduler 從 API Server 收到 Container 資訊時，將 Container 相關資訊進行過濾(filtering)，根據需求(e.g. 最低的 CPU 數量)淘汰不適合的節點，第一次過濾後留下符合條件的節點。

接著 Scheduler 根據特定的算法對剩下的節點進行加權，最後選出加權分數最高的節點，再透過 Scheduler 回傳給 API Server。

### Controller
整個 Control Plane 的控制中心，是一個持續於背景執行的應用程式，監聽 Cluster 內的各種事件和狀態，根據事件立即反應，做出對應的處理，通過 API Server 將結果回傳出去。

目前 Controller 分四種:
- Node: 管理節點
- Replication
- Endpoints
- Service Account

> 四種 Controller 存放於同個執行檔內

## 節點(Worker Node)
作為 Kubernetes 的硬體最小單位，每個節點上都會運行代理程式用於跟 API Server 溝通，代理程式分三類：
- Kubelet
- Kube-proxy 
- Container-runtime

### Kubelet
**跟 API Server 進行溝通的應用程式**，同時**確保節點上 container 的運行狀態**。少了它，該節點就無法被 Kubernetes 管理，進行監控。

> 需要注意的是：Kubelet 只會管理跟 Kubernetes 有關的 container，也就是由 Kubernetes 建立的 container。
> 其餘像是透過 docker command 建立的 container 等等一蓋不管

### Kube-proxy
提供基本的網路功能給運行中的 container，在 Node 上扮演傳遞資訊的角色。

## Container Runtime
負責容器執行的程式

# Kubernetes 的標準化介面
Kubernetes 是個開源軟體，其架構也極為複雜，為了能有效銜接各式各樣的解決方案，提供不同的介面標準，兼容不同的 container 實作，只要是符合標準的解決方案，就能銜接到 Kubernetes 上。 
結構如下圖:

![](https://i.imgur.com/mMNh48T.png)

以下列出最常見的標準:
- CRI (Container Runtime Interface)
- CNI (Container Network Interface)
- CSI (Container Storage Interface)
- Device Plugin (跟硬體有關，不在文討論範圍)

## Container Runtime Interface (CRI)
Kubernetes 支援**運算資源**的標準化介面。
以 Kubelet 為例：
![](https://i.imgur.com/nLFOGnz.png)
上圖所示，Kubelet 透過 CRI 與 Container Runtime 溝通，後面的  Implement Methods 表示每個 Container Runtime 實作方法皆不相同，而最終會產生 Container，這些建立好的 container 皆是基於 OCI (Open Container Initiative) 的標準。

Kubelet 本身透過 CRI 去呼叫 Container Runtime，而 Container Runtime 可以看作是額外的一個應用程式，接收從 Kubelet 發送出來的請求，負責建立、管理運行中的 container(符合 Container Runtime Interface;CRI)。

## Container Network Interface (CNI)
Kubernetes 管理多個節點的容器平台，節點之間該如何溝通？
Kubernetes 提供支援**網路架構**的標準化介面，確保 containers 能夠順利的在跨節點進行溝通，為所有的 containers 提供基本的網路能力。

CNI 可以做的事情很多，本文列舉常見的:
- Container 間的網路連接
  - Container to Container
  - Container to WAN
  - WAN to Container
  - In-Cluster communication (跨節點溝通)
- IP 位置的配發/移除
  - 固定 IP
  - 浮動 IP

接續上面得 Kubelet 流程，當 Kubelet 透過 CRI 呼叫 Container Runtime 啟用 container，container成功啟用後，Container Runtime 會將 Container 資訊帶入 CNI，故 CNI 是以 Container 為單位進行處理(啟用 Container 時，CNI也會被跟著呼叫一次;移除Container時亦同)。

## Container Storage Interface (CSI)
Kubernetes 提供支援**儲存方面**的標準化介面，可讓使用者可以更容易地將各式各樣的儲存設備(e.g. 檔案系統)整合進 Kubernetes 中。

目前 Kubernetes 提供兩種方式進行儲存:
- In-tree configuration (早期)
- CSI configuration 

# Kubernetes 的運算資源
前述提到 Kubernetes 的架構以及標準化介面，接著討論的是 Kubernetes 運算資源，在 Kubernetes 裡，運算單元可分為兩大類：
- Pod 
- Pod Controller

## Pod
- 最小的運算單元，一個 Pod 即一個應用程式
- Pod 裡面可擁有**一個或多個 containers*(但一般來說一個 Pod 最好只有一個 container)
- 同個 Pod 裡的所有 containers 彼此共享資源: 網路、儲存、IPC(Inter Process Communication; 透過 shard memory 的方式在不同應用程式之間進行溝通)

## Pod Controller
基於 Pod 去構築不同的使用邏輯，用於各式情境。

## 加入 Pod 之後，Kublet 建立資源的流程 
![](https://i.imgur.com/GZfQpxZ.png)

上圖的流程大致如下：

Client 端將撰寫好的檔案透過指令或是使用介面發出請求，告訴 API Server： 幫我 **建立一個 Pod** ，以及 Pod 的相關資訊。

接著 API Server, Scheduler, Controller 相互合作後得到一個合適的節點(Node)來部署這個 Pod，並將 Pod 資訊(e.g. 名稱、container 數量) 送至該節點上的 Kubelet。

接著 Kubelet 將解析收到的資訊，透過 CRI 將 container 資訊送給 Container Runtime，Container Runtime 收到 Pod 內的資訊(一個 or 多個 Container)，最後再依照不同的實作方式建立出對應的 container。 

上圖以 Container Runtime 為界劃分的話，Container Runtime 往後即 Container(有可能是 docker，或是其他類型的 Container)，而Container Runtime 經由 CRI 一路往前推至 API Srever 都是 **以 Pod 為單位** 進行溝通。

Pod 本身是一個抽象概念，由一個 or 多個 Container 所組成，Kubernetes 讓這些 Containers 在 Pod 中以下共享資源:
- Network
- Storage
- IPC

## Network
Pod 內 containers 共享的網路包含 IP, port 等，故要注意同一個 Pod 裡面部署不同的 Webserver 在多個 container 時， port 號要記得切開
## Storage
可共用相同的檔案系統(可選)
## IPC (Inter Process Communication)
透過 shard memory 的方式共享資源

## Pod 概念圖
![](https://i.imgur.com/I0VAEVN.png)

如同前面所提到，Pod 本身是一個抽象概念，每個 Pod 借助 CNI 擁有對外的存取能力(如圖片中 Network Interface 所示)，大部分的情況 CNI 會協助準備一張網卡分配 IP，，Pod 內的所有 container 對外IP為 **10.244.1.2**(共享 Network)，而 container 之間用 **127.0.0.1** 進行溝通。

另外，Storge 的共享如圖片所示的 **volume**，不同的 container 儲存的資料雖然掛在不同路徑，但儲存來源相同。

## Pod 裡的 container 狀態
Pod 裡的 container 擁有自己的狀態，如：
- Running: 運行中
- Terminated: 結束，可能的結果為成功(任務順利結束)或失敗(container crash)。
- Waiting: Container 仍處於等待的狀態(e.g. 等待 Image 下載)

## Pod 本身的狀態
Pod 本身也有狀態描述，會和 Container 有關係(因為 Pod 是一個抽象層，而 Kubernetes 都是看 Pod，但實際運行的是 Container)。

實際部署 container 到 Pod 上時，能夠正確辨識 Pod 狀態有助於理解問題，Pod 分以下幾種狀態:
- Pending
- Running
- Succeeded
- Failed
- Unknown

### Pending
只要ㄧ個 container 尚未建立起來，整個 Pod 就會處於 Pending 狀態，未能成功運行可能的原因是： container **沒有 CNI**，沒有 CNI，container 就沒有辦法正常運作。
### Running
只要ㄧ個 container 正常運作，整個 Pod 就會顯示 Running。
### Succeeded
Pod 裡所有的 container 都正常結束，就稱整個 Pod 成功結束
### Failed
反之，Pod 裡只要有一個 container 非正常結束，整個 Pod 會呈現 Failed 狀態
### Unknown
扣除前面的四種狀態，剩下的歸在 Unknown

## Pod 的重啟政策(Restart Policy)
Pod 提供幾項重啟政策，跟 docker 概念類似，有使用過 docker 的人對這些重啟政策肯定不陌生，設定政策決定要不要重啟 container:
- Never: 永不重啟
- Always: 總是重啟
- OnFailure：失敗才重啟

## Pod 的排程策略 (Schedule Strategy)
Pod 提供相關屬性決定如何部署。
- Node Affinity: 希望讓 Pod 靠近節點
  - Label: 用於辨識 Pod 配置在哪些節點上(e.g. 混合式的 Cluster 架構)
  - Affinity
  - Anti-Affinity
- Node Taints: 希望讓 Pod 遠離節點
>  注意:
> **預設情況下**，Control Plane 的節點**不允許部署任何 Pod**(No Schedule)，避免一般在使用的 container 與 Control Plane 的節點爭奪資源

# 總結
寫到這邊大致可以了解 Kubernetes 的基礎架構、所需的元件，以及每個元件在 Kubernetes 所扮演的角色，下篇文章紀錄如何在 Kubernetes 上操作 Pod 元件