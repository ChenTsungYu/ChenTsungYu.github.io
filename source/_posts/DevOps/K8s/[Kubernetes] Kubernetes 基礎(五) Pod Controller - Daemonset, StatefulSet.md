---
title: "[Kubernetes] Kubernetes 基礎(五) Pod Controller - Daemonset, StatefulSet"
catalog: true
date: 2021/09/25 8:00:10
tags: [Kubernetes, K8s]
categories: [DevOps]
toc: true
---

# 前言
![](https://miro.medium.com/max/240/0*X-_IGBEAB88amxNO.png)

[上篇](https://chentsungyu.github.io/2021/09/18/DevOps/K8s/%5BKubernetes%5D%20Kubernetes%20%E5%9F%BA%E7%A4%8E(%E5%9B%9B)%20Pod%20Controller%20-%20Deployment/)討論 `Deployment` 做滾動式部署，本篇則會接著探討另外兩種 Controller - `Daemonset`, `StatefulSet` 。
<!-- more -->

# Daemonset 是什麼
`Daemonset` 用來確保所有符合資格的節點(e.g. 節點被標示為有[污點](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/)就不具資格)都有一份運行的 Pod，故每個節點上的 Pod 數量就只有一份。

## 案例
- Cluster storage daemon
- CNI daemon
- Logs collection daemon
- Monitoring daemon

## 概念圖
![](https://i.imgur.com/ujBGX1w.png)

從上圖來理解 `Daemonset` 的概念，圖中有三個 **符合資格** 的節點，`Daemonset` 便會在這三個節點上各產生一個 Pod，以此類推，若有第四個節點產生時，`Daemonset` 也會在這個節點上產生一個新的 Pod。故即便節點數量無法事先估計，但 `Daemonset` 能根據當前的節點數量動態產生所需的 Pod。

相較於前面提及的 Deployment，Deployment 須先設定要幾個副本，無法事先估計好節點上數量，Deployment 部署的 Pod 同時也無法保證能均勻地散落在不同節點上(Deployment 是透過 [scheduler filtering and scoring](https://kubernetes.io/docs/concepts/scheduling-eviction/kube-scheduler/) 來選擇合適節點做部署)，故有可能出現多個 Pods 部署於相同節點上面

## 範例
`daemonset.yml`
```yaml=
apiVersion: apps/v1
kind: DaemonSet
metadata:
  labels:
    app: nginx
  name: test-ds
spec:
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      tolerations:
        - key: node-role.kubernetes.io/master
          effect: NoSchedule
      containers:
        - name: nginx-server
          image: nginx
          imagePullPolicy: IfNotPresent
          resources:
            limits:
              cpu: 200m
              memory: 500Mi
            requests:
              cpu: 50m
              memory: 50Mi
```
注意:
- yaml 檔裡不需描述 replica 數量: K8s 本身有一套算法偵測目前有幾個節點可部署 Pod
- 如果部署的是 master server 且沒有拔掉 Taints 的話，`Daemonset` 不會起作用(因為 Daemonset ㄧ樣是去部署 Pod，所以 Taints 的 Noschedule 會阻擋部署)。當然也可以藉由設定拿掉 Taints，或是設定 `Daemonset` 可容忍(tolerate) Taints，忽略 Noschedule

### 部署 Daemonset
將上述範例的 yaml 檔進行 apply
```shell=
kubectl apply -f daemonset.yml
```
output:
```
daemonset.apps/tets-ds created
```
接著觀察一下啟動的 Pods 資訊，可知 Pod 分別部署在不同節點上
```
kubectl get pods -o wide
```

透過 kubectl tree 來查看 `DaemonSet` 結構關係
```
NAMESPACE  NAME                                    READY  REASON  AGE  
stg  DaemonSet/test-ds                       -              2m16s
stg  ├─ControllerRevision/test-ds-ffc67f7fb  -              2m14s
stg  ├─Pod/test-ds-99hlm                     True           2m14s
stg  ├─Pod/test-ds-jfdvh                     True           2m13s
stg  ├─Pod/test-ds-pjf5t                     True           2m12s
```

> 注意:
> **ControllerRevision** 控管相關的版本資訊(因為不能使用 `ReplicaSet` 來管理，`ReplicaSet` 是確保任何時間點維持著特定的 Pod 數量)

# StatefulSet
Stateful 表有狀態的意思，故 `StatefulSet` 是用來存放 **有狀態的 Pods** 的集合。

相較於先前用 `Daemonset` 或是 `Deployment` 所部署的 Pod 本身都是無狀態的，意味著每次 Pod 被砍掉時，重新產生的 Pod 都是全新的，無任何狀態資訊在裡面，每次可能都要透過項 DB 的服務額外存取。

有些情況下會希望 Pod 本身是有狀態的，Stateful 的 Pod 本身可以不停地重啟，每次重啟都不影響功能運作，確保 Pod 都擁有自己的獨立狀態
- Stable, unique network identifiers: 如獨立的 DNS Name 做網路存取
- Stable, persistent storage
- Order, graceful deployment and scaling
- Ordered, automated rolling updates

`StatefulSet` 在使用上有個特性:
- 每個 Pod 的名稱後面都會帶一組**有續性的流水號**(並非透過 hash 方式產生亂碼): 帶有流水號的 Pod 名稱可用來辨識 Pod 身份。
- 部署方式採 **one-by-one**，依序進行部署
- 更新方式也是採 **one-by-one**，以倒過來的順序對 Pod 做更新 (對比 deployment 的 rolling update，事先建新的 Pod 再砍掉舊的)

## 常見案例:
當 `StatefulSet` 結合網路、儲存功能時，即使原本的 Pod 被砍掉，被重新部署在不同節點上，仍然可藉由相同的 DNS 名以及相關 Storage 資料去存取相同名稱的 Pod 。

以網路為例: 
每個 Pod 都有各自的 DNS，可根據需求藉由 DNS 存取不同的 Pod 上的應用程式，採一對一的方式，一個 DNS name 對到固定的 Pod。即使 Pod 重啟跑到別的節點上，固定的 DNS 仍會指向重啟後的 Pod。

![](https://i.imgur.com/Sd1a8vj.png)

儲存功能也是相同的道理，每個儲存空間對應到固定的 Pod，確保 Pod 能拿到相同的儲存空間

## 範例
`statefulset.yml`
注意: `StatefulSet` 需要表明多少個副本(Replica)
```yaml=
apiVersion: apps/v1
kind: StatefulSet
metadata:
  labels:
    app: nginx
  name: test-sts
spec:
  replicas: 2
  serviceName: "nginx"
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
        - name: nginx-server
          image: nginx
          imagePullPolicy: IfNotPresent
          resources:
            limits:
              cpu: 100m
              memory: 100Mi
            requests:
              cpu: 50m
              memory: 50Mi
```
將上述範例的 yaml 檔進行 apply
```
kubectl apply -f statefulset.yml 
```

接著觀察一下啟動的 Pods 時資訊
```
kubectl get pods -o wide
```
output
```shell=
NAME         READY   STATUS    RESTARTS   AGE     IP               NODE                                           NOMINATED NODE   READINESS GATES
test-sts-0   1/1     Running   0          2m12s   10.xxx.xxx.xxx   ip-xx-xxx-xxx-xxx.us-west-2.compute.internal    <none>           <none>
test-sts-1   1/1     Running   0          2m7s    10.xxx.xxx.xx    ip-xx-xxx-xxx-xxx.us-west-2.compute.internal   <none>           <none>
```
根據結果可知藉由 `statefulset` 建立出來的 Pod 名稱後面都有帶有流水號，範例中定義 replicas 為 2，創造兩個帶有編號，且號碼為 0 開始的 Pod 名稱 

也可以藉由 `tree` 指令列出 `statefulset` 結構，了解 `statefulset` 是如何管理的
```
kubectl tree sts test-sts
```
output:
```
NAMESPACE  NAME                                      READY  REASON  AGE
stg  StatefulSet/test-sts                      -              33s
stg  ├─ControllerRevision/test-sts-7f9b576867  -              31s
stg  ├─Pod/test-sts-0                          True           31s
stg  └─Pod/test-sts-1                          True           14s
```

# 總結
`Daemonset` 的使用時機: 

希望在每個節點上都只跑一支應用程式，且是自動隨著節點數量動態調整(產生新節點時 Pod 自動部署 or 節點減少時，主動移除 Pod)，確保每個節點上都有部署一支應用程式

`statefulset` 的使用時機: 
`StatefulSet` 因為是用來存放 **有狀態的 Pods** 的集合，故搭配網路、儲存功能時會更有意義，具體案例可參考 K8s 官方部落格曾發布 MongoDB 的案例，文章內容大概是描述如何透過 K8s 的 `StatefulSet` 產生多個副本的 MongoDB，舉例來說有三個 Pods，三個 Pods 存放相同資料，彼此相互同步，使用者可以隨時存取任何一個，確保拿到的資料都是一致的，更多細節可看[官網文章](https://kubernetes.io/blog/2017/01/running-mongodb-on-kubernetes-with-statefulsets/)。

下一篇將探討 K8s 一次性的運算單元 - Job/CronJob

# Reference
- [Kubernetes Documentation - DaemonSet](https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/)
- [Kubernetes Documentation - StatefulSets](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/)