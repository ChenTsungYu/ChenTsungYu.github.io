---
title: "[Ansile] 入門概念"
catalog: true
date: 2021/03/17
tags: [DevOps,Ansible]
categories: [DevOps]
toc: true
---
# 什麼是 Ansile?
Ansile 是由 Red Hat(紅帽) 公司所提供，經開放原始碼社群進行開發，秉持**基礎設施即代碼**為其中一項理念，專注在 IT 自動化領域，透過撰寫 `YAML` 腳本對 IT 基礎設施進行操作及管理。

主要的優點：
- 以 YML 格式編寫，容易上手與維護
- 無代理(Agentless)程式
- 透過 SSH 進行連線，用於與遠端 Server 溝通。
- 不需要安裝在 Client 端

<!--more-->
## 特色
這裡列舉幾項 Ansible 的特色
### 無代理(Agentless)程式
簡單說明什麼是無代理(Agentless)程式，選擇一台裝有 Ansible 作為中央控管的主機，可藉由該主機遠端登入其他的目標主機。

**列點整理:**
- 於中央主機讀入寫好要 Ansible 進行相關操作的腳本
- Ansible 透過**網路**作**遠端連線**，直接對其他目標節點上的主機執行腳本下達的行為
- 遠端連線方式採用 **SSH**
- 採 **"推播"** 型的架構

也就是說，Ansible 能夠跟人為進行登入的行為相同

下圖解釋無代理(Agentless)程式的過程：
![](https://i.imgur.com/Jj4fKpt.png)
[圖片源](https://medium.com/@wintonjkt/ansible-101-getting-started-1daaff872b64)

# Ansile 組成及常見名詞
Ansible 組成主要仰賴以下幾個要素:
- Ansile 本體
- Inventory: 用於定義目標機器的連線資訊，撰寫遠端 Server 的資訊 -> "在哪裡" 來執行 Ansible
- Module: 在 Client 端執行的指令或一組類似指令
- Playbook: 照字面的意思為**劇本**。可以藉由事先定義好的Playbooks 來讓各個 Managed Node 進行指定的動作 (Plays) 和任務 (Tasks) -> 將需要自動化的東西都會寫在裡面
- Task: 單個需要自動化執行的任務
- Handler：用來觸發服務的狀態，e.g. 重啟，停止服務
- ansible.cfg：Ansible 主要的設定檔
- Role：將 Playbooks 跟其他相依檔案一同整合起來，作為 Module 使用

另外，Ansile 這套工具是基於 Python 所撰寫，許多設計哲學參考 Python。

## 區分機器角色
在 Ansible 裡，會將所有機器的角色區分成兩種
- **Control Machine (控制主機)**：這類主機需安裝 Ansible 且透過執行 **Playbook** 對 Managed Node (被控節點)進行部署。
- **Managed Node (被控節點)**：又作遙控節點 (Remote Node)。相對於控制主機，這類節點為透過 Ansible 進行部署的目標。 這類節點不需要安裝 Ansible ，但須確保該節點**可透過 SSH 與 control machine 溝通**

## Linter
Ansible 有對應的 linter 叫做 **Ansible-lint**，幫助開發者在撰寫的過程中維持 Ansible 的撰寫風格。

安裝
```bash=
sudo pip install ansible-lint
```
查看版本
```bash=
ansible-lint --version
```
output
```bash=
ansible-lint 4.2.0
```

# Hands on Lab
```yaml=
- name: Install nginx & PostgreSQL # 
  hosts: dev1
  become: true
  tasks:
  - name: Run command to update 
    shell: apt upgrade -y; apt update
  - name: Install nginx
    apt:
      name: nginx
      state: latest
  - name: Start NGINX
    service:
      name: nginx
      state: started
  - name: Install PostgreSQL
    apt:
      name: postgresql
      state: latest
  - name: Start PostgreSQL
    service:
      name: postgresql
      state: started
```