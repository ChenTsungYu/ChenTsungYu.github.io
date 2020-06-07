---
title: "[Mac/Linux] Command Line指令"
catalog: true
date: 2020/01/22 20:23:10
tags: [Mac, Linux] 
categories: OS
toc: true
---
> 本篇紀錄Mac常用的指令(會持續更新)
<!-- toc -->
# 基本指令
## 基本查詢
`man` 指令加上要查詢的指令來閱讀線上手冊，透過線上手冊可以查詢相關指令或是函數的名稱，如查詢`ls`的用法：
```clike=
man ls
```
![](https://i.imgur.com/0O8AQme.png)
按下鍵盤的`q`鍵即可離開。
<!--more--> 
## 查詢隱藏的檔案
`-a`可配合其他指令來查詢隱藏的檔案，如：
```clike=
ls -a
```
![](https://i.imgur.com/x2WhBRX.png)
上圖可看出，我電腦的家(home)目錄底下有許多隱藏的檔案

## 建立空檔案
執行`touch`並指定檔案名稱，當指定的檔案不存在時，`touch`就會自動建立一個空檔案，並將檔案的時間設定為目前的時間
`touch`

## 資料補齊
如果文件名稱過長，或是指令只記得一部分的情形，按下鍵盤上的**Tab**鍵，會看到相似檔名的候選名單。而如果只有一個，它就會自動全部補上。

## 資料夾
### 移除資料夾
後面加個 `-r` 的指令，就是指要移除資料夾以及裡面全部內容，`-r`為`--recurise`的縮寫。
```clike=
rm -r 資料夾
```

### 複製資料夾
```clike=
cp -r 舊資料夾名稱 新資料夾名稱
```
#### 範例
假設桌面有一新建的料夾test，內含`test.txt`的檔案
![](https://i.imgur.com/IimS34o.png)
如果要複製test資料夾，並命名新資料夾為test_folder，執行
```bash=
cp -r test test_folder
```
![](https://i.imgur.com/GRGDvN0.png)
上面可看出成功複製新的名為test_folder的資料夾。

若改成存在兩個資料夾，分別為test、test_folder，將test_folder複製到test資料夾內，可以執行
```bash=
cp -r test_folder/ test
```
![](https://i.imgur.com/76Bf3eF.png)
上圖可發現成功將test_folder複製到test資料夾！

## 萬用字元
萬用字元的好處是可以節省的時間，其中`*`代表"0個到無窮多個"任意字元，利用`*`搭配bash其他常用指令，處理資料就更方便快速！更多萬用字元的說明查閱[鳥哥的文章](http://linux.vbird.org/linux_basic/0320bash.php#settings_wildcard)。

`*`常用於刪除大量同個副檔名的檔案，如某個專案資料夾裡的`.log`檔，就可以使用`*.log`一次刪除所有log檔。

> 萬用字元`*`在做檔案或資料夾刪除時要特別小心，有時會誤刪部分相同的檔案及資料夾。

### 誤刪的情況
目前桌面上的資料夾有test、test1_folder、test_folder三個資料夾，以及`test.txt`、`test1.txt`兩個`.txt`檔案
![](https://i.imgur.com/Z8vM49l.png)
目標要刪除三個資料夾，如果採萬用字元的做法會是
```bash=
rm -r test*
```
執行上述命令會連同`test.txt`、`test1.txt`兩個`.txt`檔案刪除！
所以使用萬用字元做刪除要特別小心！


## 移除文件
```clike=
rm 檔案名
```
## 拷貝檔案
```clike=
cp 被拷貝的檔案名 拷貝後的檔案名
```
如: 拷貝 hi.txt 到 hello.txt
```clike=
cp hi.txt hello.txt
```

## 檔案的移動與更名
### 更名
```clike=
mv 原檔案名 新檔案名
```
範例
更名前:
![](https://i.imgur.com/JRQU2dR.png)
更名後: 將 **hi.txt** 改為 **hello.txt**
```clike=
mv hi.txt hello.txt
```
![](https://i.imgur.com/CKGqoVs.png)

### 移動
```clike=
mv 檔案路徑 目錄路徑
```
## 建立目錄
```clike=
mkdir 目錄名
```
## 檢視當前目錄的文件
```clike=
ls
```
![](https://i.imgur.com/HBNwRRa.png)

## 顯示目錄下檔案
```clike=
ls -al : 顯示目錄下隱藏的檔案
ls -l  : 顯示目錄下檔案
```
![](https://i.imgur.com/0i3DlxL.png)
上圖的訊息包含:權限、檔案大小、上次修改時間等

## 退回上一層
```clike=
cd ..
```
## 回到根目錄
```clike=
cd ~
```
![](https://i.imgur.com/0OabAaj.png)

## 開啟根目錄資料夾
```clike=
open /
```
## 開啟當下電腦使用者根目錄
```clike=
open ~
```
## 開啟當前目錄
```clike=
open .
```
## 顯示當前使用者目錄名稱
```clike=
echo ~
```
## 顯示當前目錄的路徑
```clike=
pwd
```
## 切換路徑
```clike=
cd 目標資料夾
```
### 切換至根目錄
```clike=
cd /
```

## 根目錄V.S.家(home)目錄
Mac 打開Terminal預設路徑會在家目錄下，可以看到`~`的符號
![家目錄下](https://i.imgur.com/Va5eL7C.png)
若想知道當前目錄的路徑，可輸入`pwd`
![](https://i.imgur.com/w9BPkYs.png)

如果是要切換至根目錄，可以輸入指令: `cd /`，切換路徑至根目錄夾下。

![根目錄](https://i.imgur.com/EqRkgG3.png)
輸入`ls`可查看當前目錄下所有的檔案
![](https://i.imgur.com/0AyRAwS.png)

如果要回到家目錄，輸入指令`cd ~`
![](https://i.imgur.com/3O5Y0xO.png)

### 觀念釐清
波浪線`～`等於電腦的名字，也就是說，`cd ~`與`cd /Users/tsungyuchen`兩者相等

## 絕對路徑 V.S. 相對路徑
### 絕對路徑
延續剛才上一個問題，`cd /Users/tsungyuchen` 路徑為斜線開頭，表示從根目錄開始。

### 相對路徑
從目前所在目錄開始算起

# 進階指令

## 找指定的檔案
`find` 指令可在執行指令的目錄下做搜尋，找指定的檔案，並回傳路徑。
### 在目前的目錄底下
#### 不分英文大小寫
```clike=
find -iname 要被搜尋的檔案名稱
```
#### 區分英文大小寫
```clike=
find -name 要被搜尋的檔案名稱
```
### 在 /home 目錄底下，找尋檔案
#### 不分英文大小寫
```clike=
find -iname 要被搜尋的檔案名稱
```
#### 區分英文大小寫
```clike=
find -name 要被搜尋的檔案名稱
```

## 快速查看某個檔案的內容
```clike=
cat 要查看的檔案內容
```
![](https://i.imgur.com/gq1gSL2.png)
>### 其實`cat`指令原始功能是將檔案合併，再顯示合併後的檔案，如果`cat`後方只接一個檔案，則直接顯示該檔案內容。

## 查詢檔案內的文字
不用打開文件，就能查詢檔案內的文字。
```clike=
grep "被搜尋的文字名稱" 你的檔案名稱
```
如:
text檔內有"hello"的文字內容
![](https://i.imgur.com/uWJKbom.png)
執行指令
```clike=
grep "he" text.txt
```
![](https://i.imgur.com/ZCAoCKB.png)

### 不區分大小寫的模式
搜尋字詞前面加前綴詞 `-i`
```clike=
grep -i "被搜尋的文字名稱" 你的檔案名稱
```

## `apt-get`
`apt-get` 是專門給 ubuntu, debian 等 Linux 系統使用的套件下載軟體

## `ssh`
常用來遠端連線

## 寫入
```clike=
echo "要寫入的內容" > 被寫入的檔案
```
其中`>`寫入時會覆蓋原本檔案的內容重新寫入。
### 範例(重新覆蓋):
假設今天桌面上有個`test.txt`檔，執行寫入方法:
```clike=
echo "hello test" > test.txt
```
查看被寫入的檔案內容：
```clike=
cat test.txt
```

覆蓋剛剛寫入的檔案
```clike=
echo "hello test will be cover" > test.txt
```

查看被寫入的檔案內容：
```clike=
cat test.txt
```
![](https://i.imgur.com/9hny3Tn.png)

若要不覆蓋原本的檔案，將上個範例的`>`改為`>>`即可。
### 範例(不覆蓋):
#### 寫入
```clike=
echo "add new test line" >> test.txt
```

> `echo`輸出的內容會斷行，若不想斷行可以改執行`printf`

#### 查看
```clike=
cat test.txt
```
![](https://i.imgur.com/o0MIJ2q.png)

## 合併檔案
可以透過`cat`指令將檔案進行合併顯示
### 輸出合併檔案(不影響原始檔案) 
如果要將兩個內容合併輸出，可使用`cat 檔案1 檔案2`的指令
如：
建立一個名為`cat.txt`的檔案與剛剛的`test.txt`進行合併輸出。
```clike=
echo "content will be concat" > cat.txt
```
```clike=
cat cat.txt
```
#### 輸出合併結果
![](https://i.imgur.com/JBArqy2.png)
> `cat`只有單純輸出合併結果，並不影響原始檔案內容

### 將合併檔案後的檔案輸出成新檔案
```clike=
cat 檔案1 檔案2 >> 合併後的新檔案
```
合併目標檔案，並產出合併過後的新檔案。如:
```clike=
cat test.txt cat.txt >> cat2.txt
```
![](https://i.imgur.com/rIuSvcq.png)
上圖例子產出`test.txt`和`cat.txt`合併過後的新檔案，名為`cat2.txt`。

## 移動檔案
將檔案進行移動。
```clike=
mv 目標的絕對路徑
```
### 範例
假設今天桌面有個`test_folder`目標資料夾，要將剛剛建立的`test.txt`檔移至目標資料夾。
```clike=
mv test.txt /Users/tsungyuchen/Desktop/test_folder/
```
![](https://i.imgur.com/7JJG9zl.png)

# 補充
## Mac如何清除系統上被佔用的Port?
### 查詢 PID
如: 查詢 Port:3000 狀態
```clike=
sudo lsof -i:3000 
```
### 清除 PID
查詢PID後，找到佔用該port對應的PID
```clike=
kill PID
```
如對應PID為32952，則:
```clike=
kill 32952
```

## 參考文章
[[Day22] Linux 介紹與基礎指令](https://ithelp.ithome.com.tw/articles/10208091)

[[Day23] Linux 進階指令](https://ithelp.ithome.com.tw/articles/10208312)
