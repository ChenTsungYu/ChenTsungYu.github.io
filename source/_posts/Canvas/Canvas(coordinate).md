---
title: '[Canvas] 座標系操作'
catalog: true
date: 2019/07/14 20:01:34
tags: Canvas
categories: Frontend
toc: true
---
<!-- toc -->
## 坐標系轉移
繪製同樣的圖形有相同的座標，我們可以透過座標系轉換，繪製在不同的位置/角度。

### 轉移方法
* Translate(x,y): 相對當下位置偏移(x,y)
* Rotate(deg): 以當下位置為中心(相對於原點)旋轉的角度(deg)
* Scale(x,y): 以當下位置為中心(相對於原點)作縮放(x,y)
<!--more--> 
### 狀態保存&還原
* save(): 保存當下狀態
* restore(): 還原上一個儲存狀態

**原則:** 採資料結構的先進後出(stack)，即最先儲存的狀態，還原順序是排最後。

---
## 座標轉換在繪製物件的應用
* 因座標重置，較容易指定
* 用相對位置去思考會比較直覺
* 可在當前座標做額外繪製

### setTransform (直接設定矩陣)
![](https://i.imgur.com/xclfK2Q.png)



| A X縮放 | C Y傾斜 | E X偏移 |
| -------- | -------- | --- |
| B X傾斜  | D Y縮放  | D Y偏移

若要進行重設，**設定(1,0,0,1,0,0)**，將x,y的縮放設為1倍，其餘設為0。

### 相對關係的繪製
假設今天要繪製一連串的矩形，可採以下方式:
```javascript=
ctx.save(); // 儲存初始狀態

for(let i=0; i<7; i++){
    ctx.fillRect(0,0,50,50);
    
    ctx.translate(50,0);
}

ctx.restore(); // 還原成初始狀態
```

### 相對角度的繪製
每隔45度，繪製多個圓形環繞圓心。

```javascript=
ctx.save(); // 儲存初始狀態

for(let i=0; i<8; i++){
    ctx.beginPath();
    
    // 繪製圓形
    ctx.arc(50, 0, 10 ,0 ,Math.PI*2);
}
    ctx.fill();
    ctx.rotate(Math.PI / 4);

ctx.restore(); // 還原成初始狀態
```