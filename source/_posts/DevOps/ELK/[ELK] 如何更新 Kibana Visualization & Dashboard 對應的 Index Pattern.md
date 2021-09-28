---
title: "[ELK] 如何更新 Kibana Visualization & Dashboard 對應的 Index Pattern"
catalog: true
date: 2021/03/15 23:51:53
tags: [DevOps, ELK, Kibana]
categories: [DevOps]
toc: true
---

# 前言
要將 Elasticsearch 內的資料做視覺化，透過 Kibana Visualization 拉圖表呈現，並整合進一張 Dashboard 中。

由於 Visualization 是對應於 Kibana 中的 index pattern，若今天把原始的 index pattern 刪除，重建一個同名的 index pattern，原始的 Visualization 會出現 `Could not locate that index-pattern` 這類的錯誤訊息，無法正常顯示。 如下圖所示：

![](https://i.imgur.com/z4I9VgM.png)

原因是每個建好的 index pattern 都會帶一個獨立 ID ，Kibana Visualization 會綁定該 ID，故原始 index pattern 被刪除時，即便新建一個同名 index pattern，ID 改變造成 Visualization 找不到原始綁定的 index pattern。

本篇文章會示範如何在不另外建 Visualization 和 Dashboard 的情況下，替換新的 Index Pattern

<!--more-->
# 實作
> Elastic Cloud 版本為 **7.10**

以下透過兩種方法來更新 Kibana Visualization，實際情況依照既有的 Visualization 數量。

1. 若要更改的 Visualization 數量很少: 
請在保存的對象設置下更改索引模式ID
2. 若要更改的 Visualization 數量很多(e.g. **同一張 Dashboard 下多個 Visualization**): 
匯出 JSON 物件（Objects），打開該物件，替換檔案內的舊 index pattern ID ，並重新匯入 Kibana Objects 中

## Visualization 數量少
- 點擊單一個 Visualization，會出現如下圖的提示訊息
![](https://i.imgur.com/LyiU5dM.png)
- 回到 **Stack Management** -> 點擊 **Index Pattern** -> 找到新建的 Index Pattern 
![](https://i.imgur.com/RkVsqTu.png)
- 點擊新建的 Index Pattern -> 於頁面最上方的網址列找到新的 Index Pattern ID，將其複製
![](https://i.imgur.com/lSurVSz.png)
- 到剛剛出現 Error 訊息的 Visualization 頁面 -> 滑鼠滾動至最下方
- 於 **references** 欄位中的 **id** 替換成新的 Index Pattern ID
![](https://i.imgur.com/BYBD33B.png)
- 替換完畢後點擊 **Save visualization object** -> 原本的 Visualization 恢復正常
![](https://i.imgur.com/ahL3Pyu.png)


## Visualization 數量多
下方以同一張 Dashboard 下有多個 Visualization 的情形下作為範例
- 進入Kibana 介面 -> 點擊畫面左上角的 icon 展開選單 -> **Stack Management**
![](https://i.imgur.com/nWnAa8b.png)
- 點擊 **Saved Objects**
![](https://i.imgur.com/4PRPaXm.png)
- 選擇目標 Object -> **Export**
![](https://i.imgur.com/qzT4Vxw.png)
- 打開下載至本機的 Object -> 將 Object 內的 id 全數替換新的 Index pattern ID
- 將修改完後的 Object 重新上傳至 Kibana **Saved Objects**
![](https://i.imgur.com/17Pd4Zp.png)
- 查看 Dashboard，所有圖表都正常顯示囉！
![](https://i.imgur.com/N3IP1rD.png)

以上為更新 Kibana Visualization & Dashboard 對應 Index Pattern ID 的方法

