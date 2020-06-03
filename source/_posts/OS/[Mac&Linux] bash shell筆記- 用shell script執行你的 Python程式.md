---
title: "[Mac/Linux] bash shell筆記- 用shell script執行你的 Python程式"
catalog: true
date: 2020/03/22 20:23:10
tags: [Mac, Linux, w3HexSchool] 
categories: OS
---

> 鼠年全馬鐵人挑戰 - WEEK 06

<!-- toc -->
# 前言
本篇紀錄如何用shell script執行寫好的Python檔案。
<!--more-->
# 實作
## 範例
假設一個檔案裡面有一支由Python撰寫的script，名為`echo.py`。如果要利用shell去執行`echo.py`，記得先新增檔案權限給`echo.py`:
```bash=
chmod u+x echo.py
```
執行Python檔
```bash=
python echo.py
```
![](https://i.imgur.com/eQ5qKJ2.png)
印出`python print`，但是無法用bash的指令來執行。

若要使用bash指令來執行Python檔案，需先確認python主程式的位置
```bash=
which python
```
![](https://i.imgur.com/aNgiIfc.png)
回傳Python主程式的位置

在檔案內容的開頭加上`#!`，後面加上執行主程式的所在位置
```python=
#!/Users/tsungyuchen/anaconda3/bin/python
print("python print")
```
接著執行`./echo.py`
![](https://i.imgur.com/XLFukc2.png)

### Hashbang
是一個由井號(`#`)和驚嘆號(`!`)構成的字元，需寫在文字檔案的第一行的前兩個字元，作業系統的程式載入器會分析Hashbang後的內容，將這些內容作為直譯器指令，並呼叫該指令。 如: 以指令`#!/bin/bash`開頭的檔案在執行時會實際呼叫位於`/bin/bash`程式。

以上範例為簡單用Shell Script來執行Python程式碼



