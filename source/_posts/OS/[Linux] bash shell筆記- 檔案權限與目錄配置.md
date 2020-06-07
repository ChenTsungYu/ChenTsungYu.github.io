---
title: "[Mac/Linux] bash shell筆記- 檔案權限與目錄"
catalog: true
date: 2020/03/08 20:23:10
tags: [Mac, Linux, w3HexSchool] 
categories: OS
toc: true
---

> 鼠年全馬鐵人挑戰 - WEEK 04

<!-- toc -->
# 前言
本文紀錄如何在bash shell做檔案權限的配置。
<!--more-->
# 檔案具有的三種身份
Linux檔案的基本權限有九個，分別是**owner、group、others**三種身份各有自己的read、write、execute權限
* 檔案擁有者(user)
* 群組(group)
* 其他人(other)

如果對所有開啟檔案所有權限，顯示的字元為：`-rwxrwxrwx`，需要把這九個權限(不包含`-`)，以三個為一組做區分。

# 相關指令
## 查看vim是否存在
`vi`
## 查看vim的路徑
`which vim`或是`which is vim`或`whereis vim`
![](https://i.imgur.com/iycyiZj.png)

## 建立檔案
`vim fileName`或是`vim fileName.sh`，`.sh`可加可不加。
### 範例
```bash=
vim pb_do
```
![](https://i.imgur.com/vH6fPPD.png)
會進入vim的編輯模式，看到新增的pb_do檔，輸入`echo "hi!"`後，執行`:wq!`保存並退出。

## 查看系統變數
`$PATH`或是`echo $PATH`
![](https://i.imgur.com/WwStCjv.png)

## 執行檔案
```bash=
./pb_do
```
執行上方指令會跳出權限不足的訊息
```bash=
sudo ./pb_do
```
執行上方指令會跳出`sudo: ./pb_do: command not found`，表示無法執行該檔案，所以要查看該檔案內容判斷是否可執行
```bash=
ls -l pb_do
```
![](https://i.imgur.com/0oHRFAV.png)
打開發跳出的訊息只有`r`、`rw`，表示此檔案只可讀取(`r`)、寫入(`w`)，而沒有`x`(執行)

## 修改檔案/目錄的權限 - `chmod`
在Linux或其他類Unix作業系統中, 每個檔案及目錄都會有一個權限, 這個權限會定義誰可以**讀取(`r`)、寫入(`w`)及執行(`x`)** 該檔案。
檔案權限的改變需下`chmod`指令，設定方法有兩種：
* 數字類型
* 符號類型

上一個pb_do的例子可以看到vim寫入的新檔案沒有執行的權限，所以需要修改檔案目錄權限`chmod`，更多說明可翻閱鳥哥[這篇文章](http://linux.vbird.org/linux_basic/0210filepermission.php)

## 符號類型修改檔案權限
### 範例： 加入執行的權限
延續上個例子，針對pb_do**加入**執行的權限
```bash=
chmod +x pb_do
```
![](https://i.imgur.com/x4vdxPH.png)
上圖可發現原本檔案資訊只有`-rw-r--r--@`變成`-rwxr-xr-x`，新增了`x`執行權限。

現在擁有執行權限後，執行：
```bash=
./pb_do
```
![](https://i.imgur.com/rEdBFfr.png)
成功執行剛剛加入的檔案！

### 範例： 移除執行的權限
延續上個例子，針對pb_do**移除**執行的權限。
```bash=
chmod -x pb_do
```
![](https://i.imgur.com/gvUamus.png)
將`+x`替換成`-x`即可移除

> ### 如果檔案權限為`-rwxr-xr-x`表示:
> * user(u)：`u`表示**檔案擁有者**才具有可讀、可寫、可執行的權限
> * group 與 others (g/o)：表示group與others即具有可讀與執行的權限。

再看一個例子：
### 只對檔案擁有者修改執行的權限
```bash=
chmod u+x pb_do
```
![](https://i.imgur.com/k3HbwLh.png)
`u`表示檔案使用者


### 修改group的權限
```bash=
chmod g+x pb_do
```
![](https://i.imgur.com/J6oVF3c.png)
同理可以應用在新增寫入的權限上，例如
```bash=
chmod g+w pb_do
```
![](https://i.imgur.com/a9upCyU.png)
加入`w`寫入的檔案權限`-rwxrwxr--`

### 修改others執行的權限
```bash=
chmod o+x pb_do
```
![](https://i.imgur.com/lm8u2a9.png)
加入`o`執行檔案的權限`-rwxrwxr--`

### 修改所有的執行權限
`a`表示所有，指令替換成`a`，例如刪除所有身份的使用權限
```bash=
chmod a-x  pb_do
```
![](https://i.imgur.com/9qeykyI.png)
刪除所有身份的執行權限



## 數字類型修改檔案權限
除了透過符號來標示檔案權限之外，也可以使用數字來代表各個權限，個人是不太喜歡用死背的，稍微用推的很快就可以知道數字對應的權限。

文章開頭有提到檔案的基本權限有九個，三個看作一組，如果拆開了看就是`rwx`為一組(`rwx`三個權限都有的情況下)，數字加總是`7`，以二進位來看的話就是`111`。
來看段範例:
假設今天要配置檔案權限是檔案擁有者可讀、寫、執行，其餘兩個身份只開放讀、執行，所以設定權限的變更時，輸入的數值就是755，詳情如下
```bash=
owner = rwx = 4+2+1 = 7
group = r-x = 4+0+1 = 5
others= r-x = 4+0+1 = 5
```
執行下面指令
```bash=
chmod 755 pb_do
```
輸出結果：`-rwxr-xr-x`
![](https://i.imgur.com/cPjJzZp.png)
上圖結果證實數值也可以做檔案權限管理。

當然也可以把三個身份的三個權限都開啟，指令會變成:
```bash=
chmod 777 pb_do
```
結果： `-rwxrwxrwx`
![](https://i.imgur.com/EXtMEdl.png)

簡單歸納數值代表的權限
* r:4
* w:2
* x:1

回顧一下，掌握幾個原則就可以完成配置檔案權限囉！
* 每個檔案的九個基本權限(三個身份與各自擁有的權限)
* 三個字元看作一組，分別代表的三個身份
* 符號類型修改檔案權限(`r`/`w`/`x`)
* 數字類型修改檔案權限(用二進位去思考，或是直接記對應的數值)。

> 若內容或觀念有誤，歡迎在下面留言給我。

# 參閱
[Linux 的檔案權限與目錄配置](http://linux.vbird.org/linux_basic/0210filepermission.php)
