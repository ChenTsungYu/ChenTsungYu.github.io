---
title: "[Kubernetes] Kubernetes 基礎(二) Pod 操作"
catalog: true
date: 2021/09/10 8:00:10
tags: [Kubernetes, K8s]
categories: [DevOps]
toc: true
---
# 前言
延續上一篇[[Kubernetes] Kubernetes 基礎(ㄧ) 架構及元件](https://chentsungyu.github.io/2021/09/07/DevOps/K8s/%5BKubernetes%5D%20Kubernetes%20%E5%9F%BA%E7%A4%8E(%E3%84%A7)%20%E6%9E%B6%E6%A7%8B%E5%8F%8A%E5%85%83%E4%BB%B6/)討論 Kubernetes 的架構與元件後，接著來探討如何操作 Kubernetes  的 Pod 元件吧！ 

> 以下簡稱 Kubernetes 為 **K8s**。

<!-- more -->
在正式操作前，先認識一下什麼是 **kubectl**
# Kubectl
kubectl 是 Kubernetes 的命令列工具(Command Line tool)，透過指令的方式來管理整個 Kubernetes Cluster，如：取得 Cluster 各種不同資源資訊, 配置運行資源等，使用 Kubectl 前要先了解幾個常用的參數:
- Namespace
- Completion

## 命名空間 (Namespace)
透過命名空間在 Cluster 內將不同資源(Container, storage, Network 等)區分開來
## 自動補全 (Completion)
Kubernetes 提供自動補全 bash 指令的功能，透過 `Tab` 鍵幫助我們在使用 Kubectl 指令時，快速地把指令補完，執行下述指令就能啟用這項功能
```bash
source <(kubectl completion bash)
```

## 讀取 Kubernetes 資源的相關指令 - Get 
### 讀取某個 NameSpace 下的所有 Pods 資訊
```
kubectl -n <NameSpace> get pods
```
### 讀取某個 NameSpace 下特定的 Pods 資訊
```
kubectl -n <NameSpace> get pods <PodName>
```

> 若想看更詳細的資訊(e.g. NODE, IP..)，可以在指令後方加上參數 `-o=wide`
```
kubectl -n <NameSpace> get pods <PodName> -o=wide
```

也可改以 `yaml` 的形式描述 container ，參數改為 `-o=yaml` or JSON 形式: `-o=json`

> Kubernetes 有提供 **json path** 做較為複雜的輸出方式，如 `-0=jsonpath='...'` 


### 監聽 Pod - Watch
監聽 container 的變動，在部署的時候，可透過 watch 的方式去看某些 container 的變化是否如預期。
在指令裡加上參數 `-w` 即可
```
kubectl -n <NameSpace> get pods <PodName> -w
```

## 讀取 Kubernetes 資源的相關指令 - Describe 
用更上層的角度去看待資源，將多個事件、資源的資訊整合在一起，統一回傳給使用者，在 debug 時挺好用的指令
```
kubectl -n <NameSpace> describe pods <PodName>
```
# Kubeconfig 的管理
Kubeconfig 包含各式各樣的資訊 e.g. Cluster(一個 or 多個), user，可藉由 `kubectl` 來幫助我們管理這些資訊，`kubectl` 是一支用來與 k8s 叢集溝通的二進位 (binary) 工具。

我們可以運用 kubectl 來，除此之外，Kubeconfig 有個重要概念: **Context** 

## Context
以怎樣的身份(user)、基於預設的 Namespaces 去存取特定的 Cluster資訊，**是 Kubeconfig 的最小單元**，故操作 Kubeconfig 時都是以 Context 作為最小原件去操作。

## Kubeconfig 範例格式
主要分三大類別: **Cluster, Context, User**
```yaml=
apiVersion: v1 # 該元件的版本號
Kind: # 該元件屬性 e.g. Pod, Deployment, Service, Namespace, ReplicationController
clusters: # 描述多個 clusters
- cluster:
    certificate-authority-data:  # 描述 Certificate 的資訊
    server: # 紀錄連接的 Cluster 的位置
  name: # Cluster 名稱
 
contexts:
- context: # 把 user 和 cluster 資訊整合至 context
    cluster: 
    namespace: #
    user: #
users:
- name: # 此處定義 user 名稱
  user:
    client-certificate: # user 相關的 credential
    client-key: # user 相關的 credential
```

# Kubeconfig 相關指令
部署 Service 到 K8s Cluster 時，可把相關部署資源等資訊先定義於 yaml 上，再透過 `kubectl` 的指令建立所需資源
## 對 Pod 操作 (Imperative Management; 命令式管理)
通過這種方法告訴Kubernetes API你要創建，替換或刪除的內容
### 建立&查看 Pod
要在 K8s 上部署一項資源到 Pod 上，可以對事先定義好的 `yaml` 檔案執行 `kubectl` 的指令，`yaml` 檔照下方範例，部署一個 Nginx  服務到 Pod 上:
`pod.yaml`
```yaml=
apiVersion: v1
kind: Pod # 指定為 Pod
metadata:
  name: myapp-pod-nginx-demo
  labels:
    app: myapp-pod-nginx-demo # 定義好 Label 用於辨認
spec:
  containers:
  - name: myapp-pod-nginx-demo # 自訂的容器名稱
    image: nginx # container 指定的 Image
    resources: # 給定索取資源的上限
      limits:
        cpu: 200m
        memory: 200Mi
      requests:
          cpu: 100m
          memory: 64Mi
```
搭配 `kubectl create` 指令加上參數 `-f`，後面接定義好的檔案部署資源:
```yaml=
kubectl create -f pod.yaml
```
如果要查看 Pod 狀態，可以下 `get pod` 指令，後面接剛剛件好的 Pod 名稱
```yaml=
kubectl get pod myapp-pod-nginx-demo
```
**output**
```yaml=
NAME                   READY   STATUS    RESTARTS   AGE
myapp-pod-nginx-demo   1/1     Running   0          1m
```

想看更細部的資訊(name space, Node, Label, Containers等等)可以用 `describe pod` 的指令
```yaml=
kubectl describe pod myapp-pod-nginx-demo
```
### 刪除 Pod
若不需要這個 Pod 了，要將其移除可下 `delete pod`，或是 `delete -f` 接定義好的 yaml 檔
```yaml=
kubectl delete pod myapp-pod-nginx-demo
# or
kubectl delete -f pod.yaml
```
### 編輯 Pod
透過 `edit pod` 針對當前運作中的資源進行更新/替換，不需重新部署
```yaml=
kubectl edit pod myapp-pod-nginx-demo
```
雖然上面定義好的 `pod.yaml` 很簡短，但實際部署到系統時， K8s 的 API Server 會自動補上其他資訊，大部分都是系統預設值 e.g. DNS 設定、重啟政策

## 對 Pod 操作 (Declarative Management; 聲明式管理)
根據配置文件裡面列出的内容進行資源部署、修改及刪除等操作，讓 K8s 幫你維護資源狀態，概念比較偏向是告訴 Kubernetes 希望擁有的資源及狀態，確認資源應該要長什麼樣子，相較於 `create` 單純是創造的概念。 故根據資源狀態產生兩個對應的動詞: `apply`, `diff`
### kubectl apply
**語法**
```shell=
kubectl apply -f <file>
```
or
```shell=
kubectl apply -f <folder>
```
透過 `apply` 指令根據已經定義好的**一個 or 多個** yaml 檔，也可針對資料夾用遞迴的方式，把資料夾內的所有 yaml 檔送到 Kubernetes 裡面，告訴 Kubernetes 確保 yaml 描述的狀態與 Kubernetes 裡面完全一致。

### kubectl diff
`diff` 指令是在 `apply` 檔案時，跟目前 Kubernetes 檔案描述的狀態有哪些差異，修改哪些地方？有哪些變化？

### Work Flow
接著看張圖理解 `apply` 的流程：
![](https://i.imgur.com/202flKJ.png)

**圖片上半部分:**
左邊的 Config yaml 為定義 K8s 資源的 yaml 檔，描述 A~E 等多項資源，接著透過 `apply` 指令寫到 K8s 裡，K8s 會根據 yaml 檔描述的內容及預設值建立對應的資源，其中某個欄位會用於**記錄原始的檔案內容(用紅色的F標示)**，剩餘的部分(如 G~K)則 K8s 會自動根據預設值建立資源。

**圖片下半部分:**
若對原始定義的 Config yaml 內容作修改(如圖中橘色的 B~C)，經第二次 `apply` 後，K8s 會根據紀錄在F欄位的物件，將修改後的物件與原始存在K8s裡的物件進行比對。

如此一來，使用這變得方便許多，不需要取得完整的 yaml 檔內容(包含K8s 預設自動建立好的資源)，即可針對變動的檔案內容更新 K8s 裡的資源，實務上都採此法更新 K8s 資源，故 `apply` 與 `create` 的含意不同。

> `kubectl create` 表創造資源，而 `kubectl apply` 則是維護資源狀態，希望狀態是一致的。

### 範例
將前面 `create` 的 Nginx 範例改用 `apply` 來執行
```shell=
kubectl apply -f pod.yaml
```
**output**
```
pod/myapp-pod-nginx-demo created
```
把 image 改為 `httpd` ，將部署的服務改為 Apache Server
```
apiVersion: v1
kind: Pod # 指定為 Pod
metadata:
  name: myapp-pod-nginx-demo
  labels:
    app: myapp-pod-nginx-demo # 定義好 Label 用於辨認
spec:
  containers:
  - name: myapp-pod-nginx-demo
    image: httpd # 從 nginx 改為 httpd
    resources: # 給定索取資源的上限
      limits:
        cpu: 200m
        memory: 200Mi
      requests:
          cpu: 100m
          memory: 64Mi
```
在 `apply` 之前，可以先透過 `diff` 指令來觀察資源變化
```shell=
kubectl diff -f pod.yaml
```
或是透過 `get` 指令加上參數 `-o yaml` 以 `yaml` 形式列出檔案內容
```shell=
kubectl get -f pod.yaml -o yaml
```
觀察一下 `metadata` 裡的 `annotations` 區塊，可發現有個欄位名稱: **kubectl.kubernetes.io/last-applied-configuration**，此欄位用於記錄先前的使用檔案內容
```yaml=
metadata:
  annotations:
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"v1","kind":"Pod","metadata":{"annotations":{},"labels":{"app":"myapp-pod-nginx-demo"},"name":"myapp-pod-nginx-demo","namespace":"xxxx"},"spec":{"containers":[{"image":"nginx","name":"myapp-pod-nginx-demo","resources":{"limits":{"cpu":"200m","memory":"200Mi"},"requests":{"cpu":"100m","memory":"64Mi"}}}]}}
```
重新 `apply` 一次
```shell=
kubectl apply -f pod.yaml
```
**output**
```
pod/myapp-pod-nginx-demo configured
```
接著用 `get` 再次檢查`annotations` 區塊的 **kubectl.kubernetes.io/last-applied-configuration** 欄位:
```yaml=
metadata:
  annotations:
    kubectl.kubernetes.io/last-applied-configuration: |
      {"apiVersion":"v1","kind":"Pod","metadata":{"annotations":{},"labels":{"app":"myapp-pod-nginx-demo"},"name":"myapp-pod-nginx-demo","namespace":"xxxx"},"spec":{"containers":[{"image":"httpd","name":"myapp-pod-nginx-demo","resources":{"limits":{"cpu":"200m","memory":"200Mi"},"requests":{"cpu":"100m","memory":"64Mi"}}}]}}
```
確認 image 資訊從 `nginx` 更新為 `httpd`。

當然也可以透過 `describe` 的方式來查看該 Pod 當前運行的 image 是哪個
```shell= 
kubectl describe pod myapp-pod-nginx-demo
```

經過上述幾個範例實作後，大部分的情況下都會藉由 `apply` 的方式來維護描述 K8s 資源的檔案。另外列出使用聲明式管理的優劣
**優:**
- 直接對物件作修改，易於管理資源變化(可搭配 git 做版控)
- 支援整個資料夾

**劣:**
在開發環境較為缺乏彈性(並非所有環境都能拿到最初的 `yaml` 檔案做 `apply`)

### 總結聲明式管理
透過檔案的方式維護資源(下載、更新資源)，有效搭配版控追蹤每次修改的紀錄，能更有系統地除錯、追蹤及部署。

> 更多細節可查閱[文件1](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-v1/) or [文件2](https://v1-17.docs.kubernetes.io/docs/reference/generated/kubernetes-api/v1.17/#pod-v1-core)，再根據自身需求進行調整


## Pod Controller (Workload Controller)
Pod 底下擁有多種類型的 Controller，每種 Controller 都有合適的應用場景:
- [ReplicaSet](https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/): Pod 的副本的集合
- [Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/): 提供聲明式的方法來更新 Pods
- [Daemonset](https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/): 確保每一個 node 上都會有一個指定的 Pod 來運行特定的工作
- [StatefulSet](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/): 處理有狀態 Container
- [Job](https://kubernetes.io/docs/concepts/workloads/controllers/job/): 在特定時間完成批次工作
- [CronJob](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/): 定期排程工作

之後會針對 Pod 底下不同的 Controller 分篇做紀錄，本篇只有先單純列出 Pod 底下不同類型的 Controller
# 總結
本篇記錄如何透過 Kubectl 來對 Pod 元件進行常見的操作，並比較 **命令式管理與聲明式管理** 兩者的差異，最後透過幾個範例實際演練，下一篇會針對 Pod 底下的 Controller - `ReplicaSet` 做討論。

# Reference
- [Workload Resources](https://kubernetes.io/docs/concepts/workloads/controllers/)
- [Kubernetes Documentation - Pod](https://kubernetes.io/docs/concepts/workloads/pods/)
- [在 Minikube 上跑起你的 Docker Containers - Pod & kubectl 常用指令](https://ithelp.ithome.com.tw/articles/10193232)


