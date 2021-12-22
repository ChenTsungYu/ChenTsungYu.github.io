---
title: "[Kubernetes] Kubernetes 基礎(六) Pod Controller - Job/CronJob"
catalog: true
date: 2021/10/01 8:00:10
tags: [Kubernetes, K8s]
categories: [DevOps]
toc: true
---

# 前言
![](https://miro.medium.com/max/240/0*X-_IGBEAB88amxNO.png)

上篇談到 Daemonset, StatefulSet 兩種 Pod controller，本篇將會探討 Kubernetes 一次性的運算單元 - **Job/CronJob**

Job/CronJob 的命名跟先前已經不同，因為是一次性的運算，以 Job 為基本單元，已經沒有任何 Set 概念，在正式討論 Job/CronJob 之前，先了解到應用程式的生命週期分兩大類：
- **不會結束 e.g. 持續運行的 Daemon**
  前述提到的 DeamonSet, StatefulSet, Deploymnet, ReplicaSet 都屬於此類型
- **會結束的 e.g. 一次性的任務**
   Job, CronJob 都屬於此類一次性的運算單元 
 
<!-- more -->
# Job
由於 K8s 最基本的運算單元是 Pod，故以 Pod 來描述 Job。

Job 的定義:
> 於週期內有多少數量的 Pods 成功地結束任務，跑 Job 時，可指定 Job 數量、分配方式如: 一次跑一個(one by one) 或是平行分配(parallelism)

## 流程:
![](https://i.imgur.com/ad1tDky.png)

上圖範例是 Job 在執行的流程，我們定義:
- completions 為 2
- parallelism 為 1

上述設定預期 Pod 成功結束的數量為2，Job controller 會先建立一個 Pod， 待這個 Pod 成功結束之後，Job controller 會偵測到結果，接著再建立第二個 Pod 執行 Job，結束後 Job controller 也會知道結果，當 Job 收到成功的 Pod 數量與預期的相同時，代表 Job 順利成功結束。

換而言之，若將 parallelism 改為 2，表同時創造兩個不同的 Pods 各自處理，最後收到成功的 Pod 數量與預期的相同時，也代表 Job 順利成功結束。

簡單小結 one by one 與 parallelism 兩者:
- **completions != 1, parallelism = 1**
  -> One by one， 無平行化，一次跑一個
- **completions = N, parallelism = N**
  -> parallelism，有設定平行化，一次全部執行

### 相關設定說明:
- **completions**: 預期成功的 Pod 數量
- **parallelism**: 預期同時執行的 Pod 數量。預設為 **1**
- **backoffLimit**: 嘗試失敗的次數。超過指定次數，整個 Job 就會被視為 failed
- **activeDeadlineSeconds**: 嘗試失敗的時間。超過指定的時間整個 Job 就會被視為 failed， Job 會把創造出來的 Pod 都砍掉回收

Job 會持續產生 Pod 直到達到預期的成功數量，為了避免 Job 無止盡地產生 Pod 來重新嘗試執行任務，我們可藉參數調整對 Job 定義成功或失敗的條件。

這邊有個注意的點是:
> Pod 是否為 Deamon 還是 Job/CronJob 是由 **Container 去決定**，故 Pod 裡的 Container 是應用程式包成 container image 時，預先設定好讓應用程式執行的 command 是持續運行還是一次 or 批次性的任務，Kubernetes 只是使用其結果。

## 範例
範例源自官方[範例](https://kubernetes.io/docs/concepts/workloads/controllers/job/)微幅改寫
`job.yml`
```yaml=
apiVersion: batch/v1
kind: Job
metadata:
  name: pi
spec:
  template:
    spec:
      containers:
      - name: pi
        image: perl
        command: ["perl",  "-Mbignum=bpi", "-wle", "print bpi(2000)"]
        resources:
          limits:
            cpu: 100m
            memory: 100Mi
          requests:
            cpu: 50m
            memory: 50Mi
      restartPolicy: Never
  backoffLimit: 4
  completions: 5
  activeDeadlineSeconds: 5 # Job 跑超過 5 秒視為失敗
```
上述範例是定義 Job 執行一個 Perl 語言的任務，根據 completions 設定預期會完成的 Pod 數量為 5，由於 yaml 檔中未設定 parallelism (平行)，所以是一次跑一個 Pod，需等第一個 Pod **跑起來 -> 執行 -> 結束** 回報給 Job controller 後才會再往下建立第二個 Pod 接續後面的任務，直到第 5 個 Pod 結束。

可藉由 `--watch` 來觀察 Job 建立 Pod 的變化
```
kubectl get jobs --watch
```
output:
```
NAME  COMPLETIONS    DURATION     AGE
pi    1/5            2m8s         2m10s
pi    2/5            2m44s        2m46s
pi    3/5            3m40s        3m42s
pi    4/5            4m36s        4m38s
pi    5/5            5m37s        5m39s
```

也可透過 `describe` 查看 Job 細節
```shell=
kubectl describe jobs.batch pi
```
output:
```
Events:
  Type    Reason            Age    From            Message
  ----    ------            ----   ----            -------
  Normal  SuccessfulCreate  5m37s  job-controller  Created pod: pi-q6vg8
  Normal  SuccessfulCreate  4m6s   job-controller  Created pod: pi-fgfpf
  Normal  SuccessfulCreate  2m54s  job-controller  Created pod: pi-xsfp4
  Normal  SuccessfulCreate  119s   job-controller  Created pod: pi-m2vjz
  Normal  SuccessfulCreate  62s    job-controller  Created pod: pi-hg6cj
  Normal  Completed         1s     job-controller  Job completed
```

從 `describe` 輸出的內容可知當五個 Pod 都成功結束後，最終結果為  **Job completed**。 

再透過 `tree` 指令觀察 Job 結構關係
```
NAMESPACE  NAME      READY  REASON        AGE
stg  Job/pi          -                    14m
stg  ├─Pod/pi-fgfpf  False  PodCompleted  13m
stg  ├─Pod/pi-hg6cj  False  PodCompleted  10m
stg  ├─Pod/pi-m2vjz  False  PodCompleted  11m
stg  ├─Pod/pi-q6vg8  False  PodCompleted  14m
stg  └─Pod/pi-xsfp4  False  PodCompleted  12m
```
在 Job 裡，Pod 是一個批次性的任務，任務跑完就結束，結束的 Pod 狀態都會被標記成 `False`

接著看一下 Job
```
kubectl get jobs pi
```
output:
```
NAME   COMPLETIONS   DURATION   AGE
pi     5/5           5m37s      21m
```
定義好的 5 個 Pod 都成功完成任務，**COMPLETIONS** 這欄就會顯示 **5/5**

# CronJob
相較於前述提到的 Job，CronJob 其實就是 Job 加上 schedule 的概念，可以在某個固定時間點去執行 Job，如：希望每天(固定時間點)清理節點上不必要的資料(單次性工作)，而 schedule 設置的規則跟 Linux 的 [crontab](http://linux.vbird.org/linux_basic/0430cron.php) 是一模ㄧ樣的方式(五個符號去描述時間點)

## 範例
```yaml=
apiVersion: batch/v1
kind: CronJob
metadata:
  name: pi
spec:
  schedule: '*/1 * * * *' # 執行 Job 的時間
  jobTemplate:
    spec: 
      template:
        spec:
          containers:
          - name: pi
            image: perl
            command: ["perl",  "-Mbignum=bpi", "-wle", "print bpi(2000)"]
            resources:
              limits:
                cpu: 100m
                memory: 100Mi
              requests:
                cpu: 50m
                memory: 50Mi
          restartPolicy: Never
      backoffLimit: 4
      completions: 5
```
apply 定義好的 cronjob 檔案
```
kubectl apply -f cronjob.yml
```
透過 `tree` 觀察結構:
```
kubectl tree cronjob pi
```
output
```
NAMESPACE  NAME                       READY  REASON        AGE
stg  CronJob/pi                 -                    3m37s
stg  ├─Job/pi-27320665          -                    3m26s
stg  │ ├─Pod/pi-27320665-c5pnf  False  PodCompleted  3m24s
stg  │ └─Pod/pi-27320665-l9pnh  True                 100s
stg  ├─Job/pi-27320666          -                    2m25s
stg  │ ├─Pod/pi-27320666-r6l6h  False  PodCompleted  2m23s
stg  │ └─Pod/pi-27320666-tksn2  True                 42s
stg  └─Job/pi-27320667          -                    89s
stg    └─Pod/pi-27320667-fhjqr  True                 88s
```

以 CronJob 的角度來看，CronJob 管理 Job，而 Job 管理底下的 Pod，由一個個抽象層往上疊加，每一層專注在自己的功能。

# 總結
Job/CronJob 適合用在一次性的工作，而 CronJob 提供了排程的功能，可以讓 Job 在某個固定時間點執行，透過額外的參數設定可滿足不同需求，如: 是否要平行執行 Job？或是 Job 之間有依賴關係必須依序進行，或重新嘗試的次數等等，增加使用上的彈性！


# 參考
- [Kubernetes - Job](https://kubernetes.io/docs/concepts/workloads/controllers/job/)
- [Kubernetes - CronJob](https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/)