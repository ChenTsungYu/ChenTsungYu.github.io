---
title: "[Kubernetes] Kubernetes 基礎(三) Pod Controller - ReplicaSet"
catalog: true
date: 2021/09/14 8:00:10
tags: [Kubernetes, K8s]
categories: [DevOps]
toc: true
---
# 前言
上篇文章 - [[Kubernetes] Kubernetes 基礎(二) Pod 操作](https://chentsungyu.github.io/2021/09/10/DevOps/K8s/%5BKubernetes%5D%20Kubernetes%20%E5%9F%BA%E7%A4%8E(%E4%BA%8C)%20Pod%20%E6%93%8D%E4%BD%9C/) 討論如何透過 kubectl 指令對 K8s 做一系列的操作，本篇主要記錄 Pod Controller 中的 `ReplicaSet`
<!-- more -->
## 什麼是 ReplicaSet？
上篇文章有提到 Pod 是 K8s 的最小運算單元，若今有負載平衡的需求時，是無法只單靠 Pod 來達成的，因為一個 Pod 即一個應用程式，只會運行一份(本身無複製能力)。

某些情況下會需要可以運行多份應用程式，做負載平衡、分散流量，而 `ReplicaSet` 可以幫助我們達成這件事。

## ReplicaSet 幾項重點：
- **副本的概念、管理相同的 Pod** 
- **確保可在任何時間點 Pod 可以保有指定數量的副本** -> 會事先在 ReplicaSet 裡定義好數量，超過定義好的數量就砍掉多的，反之則補回來。
- **確保 Pod 是可用的、可存取的**
- Pod 和 ReplicaSet 是不同的資源，透過 `selector` 將兩者綁一起


在實作之前，我們可先透過 `kubectl api-resources` 指令列出所有支援的 API 資源，以及該項資源的縮寫，後續針對不同資源操作時，可以用縮寫做替換。

由於本文重點在討論 `ReplicaSet` 這項 API 資源，可搭配 `grep` 只擷取 `ReplicaSet` 相關資訊

```shell=
kubectl api-resources | grep replicasets
```
**output**
```
AME            SHORTNAMES    APIVERSION    NAMESPACED    KIND
replicasets    rs            apps/v1       true          ReplicaSet
```

## 實作
### 列出 ReplicaSet
```yaml=
kubectl get rs <ReplicaSet Name>
```
### 範例
`replicasets.yml`
```yaml=
apiVersion: apps/v1
kind: ReplicaSet
metadata: # 定義 ReplicaSet 名稱
  name: myapp-rs-demo
  labels:
    app: myapp-rs-demo
spec: # 描述 ReplicaSet 規格
  replicas: 3
  selector: # 指定目標 Pod
    matchLabels:
      app: myapp-nginx-demo
  template: # 定義 Pod 的 Template
    metadata:
      labels: # 定義 Pod 名稱
        app: myapp-nginx-demo
    spec:
      containers: # 定義 Pod 裡的 container 資訊
      - name: myapp-rs-demo
        image: nginx
```
需注意幾個上方範例中的欄位:
- **seletor**: ReplicaSet 透過 **seletor** 裡定義的 **matchLabels** 與 Pod 的 **labels** 對應。上方範例是對應到 `app: myapp-nginx-demo` 這個 Label
- **第一層的 spec**: 用於描述 ReplicaSet
- **第二層的 spec**: 用於描述 Pod 裡的 Container
- **template**: 用於定義 Pod

將上述範例進行 `apply`
```
kubectl apply -f replicasets.yml
```
`get` 查看剛剛建立的 `ReplicaSet`
```
kubectl get rs myapp-rs-demo
```
**output**
```
NAME            DESIRED   CURRENT   READY   AGE
myapp-rs-demo   3         3         3       2m56s
```
輸出結果裡面，**DESIRED** 表期望跑多少個 Ready 的 Pod; **CURRENT** 表目前跑多少個 Pod; **READY** 表目前多少個 Pod 是處於 Ready 狀態。

成功建立 `ReplicaSet` 後看一下 Pod 資訊看是不是有三個 Pod
```
kubectl get pods -o wide
```
試著砍掉其中一個 Pod 
```
kubectl delete pod <Pod Name>
```
過一段時間後再下 `get` 指令會發現 `ReplicaSet` 已生出新的 Pod，並把數量控制在 3 個。

若把 `get` 改為 `describe` 列出 Pod 細部資訊：
```
Labels:       app=myapp-nginx-demo
Annotations:  kubernetes.io/psp: eks.privileged
Status:       Running
IP:           10.132.110.154
IPs:
  IP:           10.132.110.154
ｘ:  ReplicaSet/myapp-rs-demo
Containers:
  myapp-rs-demo:
  .
  .
```
由於 Pod 是由 `ReplicaSet` 去管理，故有一個名為 **Controlled By** 的欄位用來記錄哪個 `ReplicaSet` 來管理資源，透過 yaml 的方式辨識該 Pod 是單獨的 Pod 還是上頭(範例是`ReplicaSet`)有其他元件控制。

## 概念圖
![](https://i.imgur.com/Nozo1bn.png)
上圖解釋 `ReplicaSet` 的概念與流程，包含 Pod 數量，以及 `seletor` 對應的 Pod label

一般在定義 `ReplicaSet` 的時候，Pod 的 label 與 `seletor` 的 label 都會設定一樣

# 總結
本篇文章記錄了如何透過 `ReplicaSet` 來建立多個 Pod，由 `ReplicaSet` 幫我們控制好 Pod 數量。

下一篇會針對 Pod 底下的 Controller - `Deployment` 做討論。

# Reference
- [Introduction to Kubernetes ReplicaSet](https://www.kubermatic.com/blog/introduction-to-kubernetes-replicasets/)
- [Kubernetes Documentation - ReplicaSet](https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/)