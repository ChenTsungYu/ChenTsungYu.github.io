---
title: "[Python] 爬蟲筆記2-requests&BeautifulSoup"
date: 2019/Apr/02 20:23:10
tags: [Python, WebScraping]
categories: Backend
archive: true
---
<!-- toc -->
# 前言
繼上篇筆記之後，本篇主要紀錄我常用的爬蟲工具：`requests`、`BeautifulSoup`這兩個模組。
# 所需先備知識-了解網站請求
向網站發請求時，GET與POST是常見的HTTP Method，爬蟲大多採用這兩種[方法](https://blog.toright.com/posts/1203/%E6%B7%BA%E8%AB%87-http-method%EF%BC%9A%E8%A1%A8%E5%96%AE%E4%B8%AD%E7%9A%84-get-%E8%88%87-post-%E6%9C%89%E4%BB%80%E9%BA%BC%E5%B7%AE%E5%88%A5%EF%BC%9F.html)。

## 安裝requests和bs4
```python=
pip install bs4
pip install requests
```
## 引入模組
```python=
import requests
from bs4 import BeautifulSoup
```
<!--more--> 
# requests
requests模組可以讀取網站的原始碼，再利用正規表達式取得目標資料。

## GET Method
假設今天要抓取PTT的[NBA版](https://www.ptt.cc/bbs/NBA/index.html)，讀取網頁的方法會是:
```python=
requests.get("目標網址", headers=你設置的header)
```
範例:
```python=
header={'User-Agent': 'Mozilla/5.0'}
url = requests.get("https://www.ptt.cc/bbs/NBA/index.html", headers=header)
```
**requests相關知識:**
1. http狀態碼: `resp.status_code` 
http狀態碼(status code)，用於表示向網站請求的狀態。
* 通常2開頭為請求成功
* 開頭為4為請求失敗，表示**Client端**錯誤
* 開頭為5為請求失敗，表示**Server端**錯誤
可以依照http狀態碼來排查問題，更詳細的狀態說明可以看[這篇](https://poychang.github.io/http-status-code/)。
2. 查看網頁編碼: `url.encoding`
有時候解析下來的網頁會有文字編碼問題，python3內所有的文字都是 `unicode`類型的`str`，可以透過encoding的方式查看編碼，也可以改變網頁編碼，如:
```python=
print(url.encoding) # utf-8

# 改變編碼方式
url.encoding = 'big5'
print(url.encoding) # big5
```
3. 解析網頁內容
確定網頁請求成功後(狀態碼為200)，接著進行網頁內容解析，獲取的資料大部分會用上面兩種型式儲存:
* text: 返回的是 Unicode型態的資料，常用於字串。
* content: 返回的是bytes型態的資料，常用於圖片、文件。

4. 在網址列加上[查詢參數(Query String)](https://nkust.gitbook.io/python/qu-ji-qiao)
有時會在發GET請求時，在網址列加上查詢的參數，可採自訂payload(dic資料型態)的方法，GET以params為參數，將自訂的參數值assign給params:
```python=
payload = {'key1': 'value1', 'key2': 'value2'}
requests.get("目標網址", params=payload)
```
以[雅虎股市新聞](https://tw.stock.yahoo.com/news_list/url/d/e/N1.html?q=&pg=1)為例，參數`pg`後面挾帶的數值表示頁數:
```python=
payload = {'q': '', 'pg': '2'}
page = requests.get("https://tw.stock.yahoo.com/news_list/url/d/e/N1.html", headers=header, params=payload)
print(page.url)
# 結果: https://tw.stock.yahoo.com/news_list/url/d/e/N1.html?q=&pg=1
```

## POST Method
相較於GET，POST請求的資料通常都是網頁讓使用者填表單時會採用的方法。POST以data為參數，將自訂的參數值assign給data:
```python=
payload = {'key1': 'value1', 'key2': 'value2'}
requests.post("目標網址", data=payload)
```
範例:
```python=
payload = {'key1': 'value1', 'key2': 'value2'}
page = requests.post("http://httpbin.org/post", headers=header,data=page)
print(page.text)
```

## Session Method
有時使用者(Client)造訪網站時，網站(server)為了要辨識使用者身份，會發一個憑證給訪問者，憑證若**儲存在Client端稱作cookie**，**存在Server端稱作Session**，兩者常用於紀錄登入者資訊，這時可用Session方法紀錄cookie訊息。

### 實作:
假設今天目標為PTT的八卦版，在第一次訪問時會導向另一個頁面先確定使用者是否超過18歲，以網路爬蟲來說，必須先經由認證的行為來取得合法身份，使用者資訊會夾雜在session裡面。
在**我同意**的按鈕上點擊右鍵打開開發者工具觀察元素，可以發現預設值為**yes**，並以`POST`的形式傳送資料，

![](https://i.imgur.com/m9w1CEs.png)

```python=
import requests
payload = {
   'from': 'https://www.ptt.cc/bbs/Gossiping/index.html',
 'yes': 'yes'
 }
headers = {
 'user-agent': 'Mozilla/5.0'
}
rs = requests.Session()
rs.post('https://www.ptt.cc/ask/over18', data=payload, headers=headers)
res = rs.get('https://www.ptt.cc/bbs/Gossiping/index.html', headers=headers)

print(res.text)
```
上述範例程式碼中，`from`表來源網頁，`yes`為按鈕的預設值。

# BeautifulSoup
通常解析出來的網頁結構都比較複雜，要擷取特定資料需要其他工具來協助我們，這時`BeautifulSoup`就派上用場了，當然除了`BeautifulSoup`之外，常用的工具還包含`xpath`、`正規表示式(re)`等方法，本篇先記錄`BeautifulSoup`。
延續上一段未完成的PTT八卦版程式碼，如果要取得多個標題文章，可以用下面這段完整的程式碼:
```python=
# PTT八卦版爬蟲
import requests
from bs4 import BeautifulSoup
payload = {
   'from': 'https://www.ptt.cc/bbs/Gossiping/index.html',
 'yes': 'yes'
 }
headers = {
 'user-agent': 'Mozilla/5.0'
}
rs = requests.Session()
rs.post('https://www.ptt.cc/ask/over18', data=payload, headers=headers)
res = rs.get('https://www.ptt.cc/bbs/Gossiping/index.html', headers=headers)
soup = BeautifulSoup(res.text, 'html.parser')
items = soup.select('.r-ent')
for item in items:
    print(item.select('.date')[0].text, item.select('.author')[0].text, item.select('.title')[0].text)
```
`BeautifulSoup(res.text, 'html.parser')`採用解析器:`html.parser`是Python內建的，除了`html.parser`外，還支援`lxml`，更多解析器及比較可參考[這篇文章](https://beautifulsoup.readthedocs.io/zh_CN/v4.4.0/)
```python=
soup.prettify()
```
上述方法可印出完整的HTML結構(排版後)。
接著觀察網頁結構的HTML標籤
## 常用的方法
### find()、find_all()
* find("標籤名稱"): 回傳**第一個**符合指定的標籤內容，找不到則回傳`None`。
* find_all("標籤名稱"): 回傳**多個**符合指定的標籤內容，是一個**list結構**，找不到則回傳空的list。

#### 獲取標籤內容
```python=

## 範例
soup.find('p').text # 印出第一個p標籤
soup.find_all('p')[0].get_text() # 印出第一個p標籤的文字內容

soup.find_all(class_="outer-text") # 取得有class得tag
soup.find(id='link2') # 取得有id得tag
```
上述的`soup.find('h1')`也可以寫作`soup.h1`。
### 注意
> find用.text顯示文字
find用.get_text()顯示文字(資料型態須為字串)

#### 尋找指定的標籤中符合屬性條件的內容
```python=
find("標籤名", { "屬性名" : "屬性值"}) 或 find_all("標籤名", { "屬性名" : "屬性值"})
```
範例
```python=
soup.find('h1',{'class':'hello'}) # 印出第一個h4標籤且class名稱為hello中的內容
```
####  取得標籤的屬性內容
如果想取得回傳值的屬性內容也可以用`get("屬性名稱")`或是`["屬性名稱"]`
```python=
<a id="link" href="http://example.com"></a>

dataList = soup.select("#link")
# 取得href的屬性內容
print(dataList[0].get("href")) # http://example.com

print(dataList[0]["href"]) # http://example.com
```

#### 搜尋多個標籤
```python=
tags = soup.find_all(["title", "p"])
```
#### 搜尋多個標籤並限制數量
```python=
tags = soup.find_all(["title", "p"], limit=2)
```


### select()
以CSS選擇器的方式定位元素，讀取指定的資料，回傳值是**list**的資料結構。
常見的CSS選擇器:
* 標籤
* id(唯一): 要獲取具有id的標籤需在前面加上`#`，如`select("#title")`，id表唯一的選擇器。
* class(類別): 要獲取具有class的標籤需在前面加上`.`，如`select(".title")`，class選擇器可以同時擁有多個。
範例:
```python=
bs.select('h1')      # 尋找h1標籤
bs.select('#id_tag')  # 尋找id名為id_tag
bs.select('.class_tag')  # 尋找class名為Pclass_tag
```

#### 多層 
如果遇上層層嵌套的結構時可以採用範例的方法:
獲取`html`底下的`head`底下的`title`標籤內容
```python=
title = soup.select("html head title")
```
### 直接選擇標籤Tag
```python=
# 輸出title標籤
print(soup.title)
# 輸出title標籤的屬性
print(soup.title.name)
# 輸出title標籤的內容
print(soup.title.string)
# 輸出網頁中的所有文字
soup.get_text()
```

> 以上為requests&BeautifulSoup常用的方法

