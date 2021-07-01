# [Kubernetes] Kubernetes 前導
###### tags: `kubernetes`

# 常見的容器部署模型 (Deploying model)
- 單一節點部署一個容器 (Single Container/Single Node)
- 單一節點部署多個容器
- 多節點部署多個容器

## 單一節點部署一個容器 (Single Container/Single Node)



# 架構 Architecture
包含:
- Control Plane(控制平面)

## Control Plane
Control Plane 裡有不同的應用程式，這四個角色組合成 Kubernetes 最重要的大腦功能，負責管控整個 Kubernetes 叢集(Cluster)，四個角色分別是：
- API Server
- Scheduler
- Controller
- Etcd

Kubernetes 可以在不同的節點(Node 或稱 Worker)來運行容器，Worker 可以部署在虛擬機、實際的 server 甚至是容器(container)上(將 container 部署在container上)。

Worker 與 Control Plane 之間可藉由安裝在 Worker 上的 **代理程式(Agent)** 與 Control Plane 的 API Server 來進行溝通，同步目前 Cluster 內的最新狀況。

> ### 整個 Control Plane + 所有的 Workers = Kubernetes Cluster

另外，使用者端要與 Kubernetes Cluster 互動，一般有三種方式:
- API: 習慣撰寫程式的開發者可藉由 API 的方式與 Kubernetes 溝通
- CLI (Command Line Interface)：Kubernetes 提供一系列的工具列指令來溝通，這也是最常見的方式
- UI (使用者介面)：網頁的方式操作 Kubernetes 

接著說明 Control Plane 的四個重要角色
### API Server
管理 API 的伺服器，即 Control Plane 的前端，前述提到三種與 Kubernetes 互動的方式，所有有的請求都是透過 API Server 第一個處理。

換言之，若 API Server 無法正常運作，使用者使用的所有工具都無法對 Kubernetes 內部的資源進行存取

### Etcd
以 `key-value` 為儲存形式的資料庫，儲存 Kubernetes Cluster 的所有資源以及狀態，因為是儲存資料的地方，故相對應的資料備份、災難還原等措施相當重要

### Scheduler
替 API Server 從 container 裡面尋找合適的節點來部署，將資訊回傳給 API Server

**Scheduler 如何運作？**

假設有多個候選節點，Scheduler 從 API Server 收到 Container 資訊時，將 Container 相關資訊進行過濾(filtering)，根據需求(e.g. 最低的 CPU 數量)淘汰不適合的節點，第一次過濾後留下符合條件的節點。

接著 Scheduler 根據特定的算法對剩下的節點進行加權，最後選出加權分數最高的節點，再透過 Scheduler 回傳給 API Server。

### Controller
整個 Control Plane 的控制中心，是一個無窮迴圈的應用程式，監聽 Cluster 內的各種事件，根據事件立即反應，做出對應的處理，通過 API Server 將結果回傳出去。

目前 Controller 分四種:
- Node: 管理節點
- Replication
- Endpoints
- Service Account

> 四種 Controller 存放於同個執行檔內


## 節點(Node; Worker)上的代理程式(Agent)
代理程式分三類：
- Kubelet
- Kube-proxy
- Container-runtime

### Kubelet
跟 API Server 進行溝通的應用程式，同時**確保節點上 container 的運行狀態**。少了它，該節點就無法被 Kubernetes 管理，進行監控。

> 需要注意的是：Kubelet 只會管理跟 Kubernetes 有關的 container，也就是由 Kubernetes 建立的 container。
> 其餘像是透過 docker command 建立的 container 等等一蓋不管

### Kube-proxy
提供基本的網路功能給運行中的 container

# Kubernetes 的標準化
Kubernetes 是個開源軟體，其架構也極為複雜，為了能夠有效地銜接各式各樣的解決方案，提供不同的介面標準，只要是符合標準的解決方案，就能銜接到 Kubernetes 上。

- CRI (Container Runtime Interface)
- CNI (Container Network Interface)
- CSI (Container Storage Interface)

## Container Runtime Interface (CRI)
Kubernetes 提供支援**運算資源**的標準化介面。
Kubelet 本身透過 CRI 去呼叫 Container Runtime，可以看作是額外的一個應用程式，接收從 Kubelet 發送出來的請求，負責建立、管理運行中的 container(符合 Container Runtime Interface;CRI)。

## Container Network Interface (CRI)
Kubernetes 提供支援**網路架構**的標準化介面


## Container Storage Interface (CRI)
Kubernetes 提供支援**儲存空間**的標準化介面