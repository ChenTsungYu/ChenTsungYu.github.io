---
title: "[Python] 爬蟲筆記3- Selenium"
catalog: true
date: 2019/09/03 20:23:10
tags: [Python, WebScraping]
categories: [Backend]
toc: true
---
<!-- toc -->
# 前言
Selenium 是一個瀏覽器自動化測試工具，最初是為了自動化測試開發，在爬蟲流行開始後，也成為其中一種爬蟲工具。它的功能可以控制瀏覽器，模擬人對瀏覽器操作，整個過程是自動化的。
selenium支援Java、JavaScript、Python等多種主流程式語言，本篇主要用Python實作。

# 安裝Selenium
```python=
pip install selenium
```
成功後，顯示**Successfully installed selenium.**
<!--more--> 

# 下載webdriver
要讓Selenuim能夠控制瀏覽器、跟瀏覽器進行溝通，就需要使用Webdriver
主流瀏覽器webdriver載點:
* [Chrome](https://sites.google.com/a/chromium.org/chromedriver/downloads)
* [Edge](https://developer.microsoft.com/en-us/microsoft-edge/tools/webdriver/)
* [Firefox](https://firefox-source-docs.mozilla.org/testing/geckodriver/Support.html)
自己主要以Chrome為主要瀏覽器，所以下載ChromeDriver

# 實作
`.get('目標網址')`
```python=
from selenium import webdriver  #從library中引入webdriver
browser = webdriver.Chrome('./chromedriver') # 建立chrome browser 物件
browser.get('https://www.google.com/') 
```

:::warning

## 可能會遇到的問題:
### 版本問題
webdriver的版本要和目前瀏覽器的版本相符合，不然會有版本號不同的錯誤訊息，瀏覽器會有閃退的情況，如下方:
![](https://i.imgur.com/hLzVqpM.png)
#### 解決方法
1. 確認Chrome 瀏覽器版本

開啟瀏覽器右上方的選單
![](https://i.imgur.com/1ykOBox.png)

選擇說明>關於 Google Chrome
![](https://i.imgur.com/0eRuISN.png)

查看當前版本
![](https://i.imgur.com/2o21GhU.png)


2. 下載可支援此Chrome版本的ChromeDriver
![](https://i.imgur.com/YnNaDi2.png)

### 路徑問題
執行`browser = webdriver.Chrome()`之後，會顯示`Message: ‘chromedriver’ executable needs to be in PATH.`
#### 解決方法
把chromeDriver與的.py檔放置在同一目錄下，避免程式找不到ChromeDriver。
:::

## 執行結果
![](https://i.imgur.com/lGQqFkh.png)
運行後，即可看到Chrome目前受到自動測試軟體控制，完成第一個Chrome自動化專案，我們剛才的動作就是在模擬瀏覽器登入Google網站！

## 關閉瀏覽器
前面的實作會發現打開瀏覽器後無法自動關閉瀏覽器，這時候可以執行`close()`進行關閉。
```python=
browser.close()
```

## 讓瀏覽器在背景執行
1. `webdriver.ChromeOptions()` 來宣告options
2. `options.add_argument('--headless')` 背景執行
3. 將`options`加入Chrome方法裡面

*註: `executable_path` 為webdriver執行的路徑
```python=
options = webdriver.ChromeOptions()
options.add_argument('--headless')

browser=webdriver.Chrome(chrome_options=options, executable_path='./chromedriver')
#在瀏覽器打上網址連入
browser.get("https://www.google.com/") 
```
上述程式碼可以在不開啟瀏覽器的情況下執行自動化腳本

## 開啟無痕模式
將程式碼加入`options.add_argument("--incognito")`即可以無痕模式開啟瀏覽器
```python=
options = webdriver.ChromeOptions()
options.add_argument("--incognito")   
browser=webdriver.Chrome(chrome_options=options, executable_path='./chromedriver')
browser.get("https://www.google.com/") 
```
![](https://i.imgur.com/ygwNnYk.png)

## 瀏覽器視窗設定
* 視窗大小設定: `browser.set_window_size(480, 800)`
* 視窗最大化: `browser.maximize_window()`
* 視窗最小化: `browser.minimize_window()`

## 常用定位網頁元素的方法
* 搜尋帶有特定id名稱的元素: `find_element_by_id()`
* 搜尋帶有特定name屬性名稱的元素: `find_element_by_name()`
* 搜尋帶有特定class名稱的元素:`find_element_by_class_name()`
* 搜尋帶有特定名稱的網頁標籤:`find_element_by_tag_name()`
* 用Xpath來定位網頁元素: `find_element_by_xpath()` 
* 用CSS選擇器定位網頁元素`find_element_by_css_selector()`

上述的方法都只有搜尋**第一個符合條件的元素**，如果要搜尋多個元素，只要在`find_element`上改為`find_elements`即可，返回結果為`list`的資料結構。

## Xpath
Xpath 全名為**XML Path Language**，即XML路徑語言，它可以在XML檔案中查找。最初設計是用來尋找XML檔案，但是它同樣也適用在搜尋HTML檔。
另外，XPath的定位元素功能十分強大，提供非常簡潔的定位方法，幾乎所有我們想要定位的元素節點都可以靠XPath幫我們完成。

Xpath的語法非常多，先記錄比較常用的規則，掌握大方向後其他的再找文件很快就能上手。

### XPath常用規則
`/` :  從當前節點選取直接子節點
`//` : 從當前節點選取子孫節點
`.` : 選取當前節點
`..` : 選取當前節點的父節點
`@` : 選取屬性

[不錯的範例文章](https://dotblogs.com.tw/supershowwei/2018/09/03/145254)

## selenium 的等待
selenium等待方式常見的有下列3種，各有其優缺點。
### 强制等待
從`time`模組裡面叫出`sleep`方法，強迫程式需過指定的時間後才可往下執行。
```python=
from time import sleep
options = webdriver.ChromeOptions()
options.add_argument("--incognito")   
browser=webdriver.Chrome(options=options, executable_path='./chromedriver')
browser.get("https://www.google.com/") 
sleep(3)  # 強制等待3秒再執行下一步
browser.close()
```

### 隱性等待
隱形等待是設一個最長的等待時間，若在規定時間內網頁載入完成，則執行下一步，否則一直等到時間截止，然後執行下一步。
這裡有一個問題: 程式會一直等待整個頁面載入完成。
```python=
options = webdriver.ChromeOptions()
options.add_argument("--incognito")   
browser=webdriver.Chrome(chrome_options=options, executable_path='./chromedriver')
browser.implicitly_wait(10) # 隱性等待最長時間為10秒再執行下一步
browser.get("https://www.google.com/") 
browser.close()
```

### 顯性等待
`WebDriverWait`，配合`until()`和`until_not()`方法，能根據判斷條件而進行彈性設定等待時間。

詳細的應用參考[這篇](https://stackoverflow.max-everyday.com/2019/01/python-selenium-wait/)。

# 獲得元素的相關訊息

## 整理
* `size` 獲得元素的尺寸
* `text` 獲得元素的文字內容
* `get_attribute(name)` 獲得該屬性名對應的屬性值
* `page_source` 回傳網頁原始碼
* `driver.title` 回傳網頁標題
* `current_url` 獲得當前網頁的網址
* `is_displayed()` 判斷此元素是否可見
* `is_enabled()` 判斷此元素是否被使用
* `is_selected()` 判斷此元素是否被選到
* `tag_name` 回傳元素的tagName
## 範例
### 顯示元素尺寸
`find_element_by_id("size").size`
### 顯示元素文字
`find_element_by_id("txt").text`

# 從隱藏元素中獲取文字
在某些情況下，元素的文字會被隱藏，我們需要獲得隱藏元素的文字。這些內容在使用`element.attribute('attributeName')`很常遇到,透過`textContent`,`innerText`,`innerHTML`等屬性獲取。

* `innerHTML`: 回傳元素的內部HTML，包含所有的HTML標籤。

* `textContent` 和`innerText`只會得到文字內容，而**不會包含HTML 標籤**。
> `textContent` 是 W3C 相容的文字內容屬性，但是 IE 不支援
`innerText` 不是 W3C DOM 的指定內容，FireFox不支援


# 操作元素的方法
下面整理幾個比較常用模擬訪問瀏覽器常用的操作方法。
## 整理
* `clear()`: 清除元素内容
* `send_keys()`: 鍵盤輸入的值
* `click()`: 點擊元素
* `submit()`: 送出表單

更多參考[這篇](https://blog.csdn.net/Eastmount/article/details/48108259)

# 操作瀏覽器按鈕
* `back()`: 按瀏覽器 "上一頁" 鈕
* `forward()`: 按瀏覽器 "下一頁" 鈕
* `refresh()`: 按瀏覽器 "更新" 鈕
* `quit()`: 按瀏覽器 "關閉" 鈕, 同時關閉驅動程式
* `close()`: 按瀏覽器 "關閉" 鈕
 
# 獲得Cookie
`.get_cookies()`

# 儲存網頁截圖(screenshot)
`save_screenshot(filename)`: 將目前網頁儲存為 **.png** 檔案下載。
*註:
>傳入參數若單純只有檔名, 則png檔會儲存在 **Python 安裝目錄下**;若要存在指定目錄下，則需傳入包含路徑之檔名。

## 範例程式:
```python=
from selenium import webdriver   
browser=webdriver.Chrome()             
browser.get("http://google.com")  
browser.save_screenshot("google.png")   #儲存PNG圖檔
```

# 總結
啟用`selenium`之後，被指定的瀏覽器就會開啟，並依照自己撰寫的腳本執行，所有網頁的操作，包含: 輸入帳號、密碼、點選按鈕、滾動頁面、變化視窗等，都可以進行模擬操作。
因為是真正的瀏覽器在運作，可以輕鬆的繞過大部分網站反爬蟲機制，但也導致運行速度極慢。實際上還是會先嘗試使用`requests`獲取網頁原始碼，但如果實在無法突破對方網站伺服器的阻隔時，再嘗試改用`selenium`。
我自己的話通常只有遇到動態載入的網頁才會使用`selenium`。