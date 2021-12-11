---
title: "Kubernetes 基礎(四) Pod Controller - Deployment"
catalog: true
date: 2021/09/18 8:00:10
tags: [Kubernetes, K8s]
categories: [DevOps]
toc: true
---
# 前言
![](https://miro.medium.com/max/240/0*X-_IGBEAB88amxNO.png)

上篇文章 - [[Kubernetes] Kubernetes 基礎(三) Pod Controller - ReplicaSet](https://chentsungyu.github.io/2021/09/14/DevOps/K8s/%5BKubernetes%5D%20Kubernetes%20%E5%9F%BA%E7%A4%8E(%E4%B8%89)%20Pod%20Controller%20-%20ReplicaSet/) 探討如何透過 `ReplicaSet` 管理多個 Pod 副本，確保 K8s 在任何時間點能保有特定數量的 Pod 於 Cluster 中運行。

本文接著討論 Pod 的另一種 Controller - `Deployment`

<!-- more -->

# 什麼是 Deployment Controller？
相較於先前討論 `ReplicaSet` 用於管理多個 Pod 副本（多個相同的  Pod），`Deployment` 則是利用 `ReplicaSet` 來更新 Pod 的版本。

`Deployment` 提供更動版本的功能，可以決定升級為新版或是退回舊版(rollback)，概念像是告訴 K8s Cluster 要什麼版本的 Pod，`Deployment` 負責變更且維持該版本的 Pod，一般用於處理**版本更新與降版**的流程。 

# 實作
## 範例
跟前幾篇文章一樣用 nginx 服務作為範例，撰寫一個 `Deployment` 的 yaml 檔:
`deployment.yaml`
```yaml=
apiVersion: apps/v1
kind: Deployment
metadata: # 定義 Deployment 的名稱
  name: myapp-deployment-demo
  labels:
    app: myapp-deployment-demo
spec: # 描述 ReplicaSet 的規格
  replicas: 3
  selector:
    matchLabels:
      app: myapp-nginx-demo
  template: # 定義 Pod 的 Template
    metadata:
      labels: # 定義 Pod 名稱
        app: myapp-nginx-demo
    spec:
      containers: # 定義 Pod 裡的 container 資訊
      - name: myapp-nginx-demo
        image: nginx
        resources:
          limits:
            cpu: 200m
            memory: 200Mi
          requests:
              cpu: 100m
              memory: 64Mi
```
進行 `apply`
```
kubectl apply -f deployment.yml 
```
下 `get` 指令查看 Pod 狀態
```
kubectl get deployments myapp-deployment-demo
```
output
```
NAME                        READY   UP-TO-DATE   AVAILABLE   AGE
myapp-deployment-demo   3/3     3            3           2m8s
```
# Deployment 如何更新(Rollout Update)？
前面有提到 `Deployment` 最主要的功能就是負責變更、維持 Pod 的版本，那 `Deployment` 是如何對 Pod 做更新的？
## Deployment 更新的流程
![](https://i.imgur.com/Veulb83.gif)
[圖片源](https://www.bluematador.com/hs-fs/hubfs/blog/new/Kubernetes%20Deployments%20-%20Rolling%20Update%20Configuration/Kubernetes-Deployments-Rolling-Update-Configuration.gif?width=1600&name=Kubernetes-Deployments-Rolling-Update-Configuration.gif)

從上面的 gif 圖來看，`Deployment` 會先創造一個 `ReplicaSet`，裡面有三個 Pod，若想把 Pod 裡的 Image 由 nginx 改成別的 image，如: httpd，或是想更新 image 版本，原始的 `ReplicaSet` 底下有多個相同版本的 Pod，當 `Deployment` 進行更新時採取的策略是**盡可能安全**：
- 先起一個新版 `ReplicaSet` (如圖中的 `ReplicaSet v2`)
- `ReplicaSet v2` 會**循序地**創造新的 Pod
- 當新的 Pod 啟動，變成 Runing 的狀態時，舊版對應的 Pod 才會被砍掉，照這個循環去迭代新的 Pod
- Rollout Update 的過程中有些是新版，有些是舊版
- 舊的 `ReplicaSet` (如圖中的 `ReplicaSet v1`) 可以選擇要不要保留。 保留的好處在於，若有退版需求，將前述步驟反過來，循序地降回舊版

### 如何觀察 Rollout Update 的變化？
`kubectl` 有提供相關指令可以觀察 `Deployment` 的變化。
**語法**
```shell=
kubectl rollout status deployment <deployment_name>
```
執行 `rollout status` 的指令前，先把 **myapp-deployment-demo** 的 yaml 檔裡的 image 從 **nginx** 改為 **http**，接著重新 `apply`。
> 建議先開兩個終端機的視窗，一個執行 `apply`，一個執行 ` rollout status`，於 `rollout status` 的終端機視窗觀察變化

`apply`
```shell=
kubectl apply -f deployment.yml 
```
`rollout status`
```shell=
kubectl rollout status deployment myapp-deployment-demo
```
看到輸出類似下方結果:
```
Waiting for deployment "myapp-deployment-demo" rollout to finish: 0 out of 3 new replicas have been updated...
Waiting for deployment "myapp-deployment-demo" rollout to finish: 1 out of 3 new replicas have been updated...
Waiting for deployment "myapp-deployment-demo" rollout to finish: 1 out of 3 new replicas have been updated...
Waiting for deployment "myapp-deployment-demo" rollout to finish: 1 out of 3 new replicas have been updated...
Waiting for deployment "myapp-deployment-demo" rollout to finish: 2 out of 3 new replicas have been updated...
Waiting for deployment "myapp-deployment-demo" rollout to finish: 2 out of 3 new replicas have been updated...
Waiting for deployment "myapp-deployment-demo" rollout to finish: 2 out of 3 new replicas have been updated...
Waiting for deployment "myapp-deployment-demo" rollout to finish: 1 old replicas are pending termination...
Waiting for deployment "myapp-deployment-demo" rollout to finish: 1 old replicas are pending termination...
deployment "myapp-deployment-demo" successfully rolled out
```

### 如何降版(Roll Back)？
執行 `rollout undo` 的指令即可降版(Roll Back)回去。
**語法**
```
kubectl rollout undo deployment <deployment_name>
```
將剛剛的 `Deployment` 範例降回上一個版本
```
kubectl rollout undo deployment myapp-deployment-demo
```
觀察 `rollout status` 的輸出結果
```
Waiting for deployment "myapp-deployment-demo" rollout to finish: 1 out of 3 new replicas have been updated...
Waiting for deployment "myapp-deployment-demo" rollout to finish: 1 out of 3 new replicas have been updated...
Waiting for deployment "myapp-deployment-demo" rollout to finish: 1 out of 3 new replicas have been updated...
Waiting for deployment "myapp-deployment-demo" rollout to finish: 2 out of 3 new replicas have been updated...
Waiting for deployment "myapp-deployment-demo" rollout to finish: 2 out of 3 new replicas have been updated...
Waiting for deployment "myapp-deployment-demo" rollout to finish: 2 out of 3 new replicas have been updated...
Waiting for deployment "myapp-deployment-demo" rollout to finish: 1 old replicas are pending termination...
Waiting for deployment "myapp-deployment-demo" rollout to finish: 1 old replicas are pending termination...
deployment "myapp-deployment-demo" successfully rolled out
```
# 總結
前面幾個範例中，已透過 `kubectl apply` 指令去操作 `Deployment`，更新服務的版本。

大部分的情況下都會採用 `Deployment` 的方式進行部署，可以滾動式地更新不同環境裡的服務，避免服務因為部署的關係(等待新的 image 下載等等)而突然中斷。

下篇文章會接著討論 Pod 底下的 Controller - `DaemonSet`

# Reference
- [Kubernetes Documentation - Deployment](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/)
- [Kubernetes Deployment](https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/deployment-v1/)
- [Performing a Rolling Update](https://kubernetes.io/docs/tutorials/kubernetes-basics/update/update-intro/)
- [Kubernetes Rolling Update Configuration](https://www.bluematador.com/blog/kubernetes-deployments-rolling-update-configuration)

