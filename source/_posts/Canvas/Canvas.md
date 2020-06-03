---
title: '[Canvas] 入門'
catalog: true
date: 2019/07/14 21:01:34
subtitle: "Basic Concept"
tags: Canvas
categories: Frontend
toc: true
---
<!-- toc -->
# Go!
## 特性
* 可自由繪製元件區域
* 可控制每像素的顏色與繪製
* 有較高的操控度
* 可動態改寫圖片
<!--more--> 
## 掌握要點
* 繪製圖形
* 向量概念
* 三角函數
* 物件導向開發

#### 像素
在一個固定寬度和高度的圖片內，切割成一個個的小格子，canvas可分別指定每個格子的顏色

### 如何知道在那些像素做改變？
透過點座標的方式定位，根據原點指定垂直（Y軸）及橫向（X軸）偏移，確認位置

----
## Canvas的坐標系方向

* 原點設置在左上角
* 角度為逆時鐘
* 原點往下延伸為＂Y軸＂
* 0度表X軸方向
* 90度表Y軸方向

## 如何使用Canvas
以繪出一個填滿黑色的三角形為例：
![](https://i.imgur.com/Frgo9MO.png)

在HTML加上`canvas#mycanvas`，加上Canvas標籤後設置id，方便抓取。

在JS中:
```javascript=
const canvas　= document.getElementById('mycanvas');
const ctx = canvas.getContext("2d"); // 指定繪圖介面，在2D上繪圖

 // 設定畫布尺寸，將畫布尺寸設為等同視窗尺寸大小，撐滿整個視窗
canvas.width = window.innerWidth;

canvas.height = window.innerHeight;
 
// 起始點座標(50,50)，繪製直線連到
 ctx.beginPath(); // 開始進行繪圖
 ctx.moveTo(50,50);
 ctx.lineTo(100,100);
 ctx.lineTo(250,20);
 ctx.closePath();// 關閉繪製
 ctx.fillStyle　=　"black"; // 繪製顏色
 ctx.fill(); // 進行填滿繪製

```
## 基礎圖形
* 填滿矩形：fillRect(x,y,w,h)
* 繪製框線矩形strokeRect(x,y,w,h)
* 清除矩形範圍clearRect(x,y,w,h)
* 設置框線的寬度 lineWidth
* 設置圖形透明度 globalAlpha


#### x,y表座標位置，w,h表寬和高

## 路徑繪圖
上述的基礎圖形只能繪出矩形，若要畫出其他圖形，可採用**路徑繪圖**的方式完成。

> 開始一個新的路徑，給予點座標，做連線操作，再指定填色或線條顏色，最後將路徑填色描繪出來。

* 路徑的開始＆關閉：beginPath＆closePath
* 移動＆畫線: moveTo、lineTo、arc(弧形)...
* 指定填色或線條顏色:fillStyle、lineStyle
* 將路徑填色&描繪出來: stroke(描繪路徑線條)、fill(將圖案填滿)

### 圓形的路徑
* arc(x,y,r,start Angle,end Angle,state)
  x,y 為圓心座標，r為半徑，state為畫弧方向: true表逆時針； false表順時針(預設)
  
* 計算弧度：0-360必須寫 0～2*Math.PI
* 角度是　＂逆順時針選由下方開始旋轉＂

### 色彩系統
* rgb
* rgba
* hsl(彩度,飽和度,亮度)，正常值:(50%,50%)
* hsla(彩度,飽和度,亮度,透明度)

### 時間函數＆動畫
* setInterval(updateFn,time)
* requestAnimationFrame(update):
給定一個函數後，自動判斷何時該更新畫面，提升動畫效能。
* 更新影格:
 使用clearRect或fillRect
 覆蓋上次繪圖的圖形
 