---
title:  '[JavaScript] 使用Google Map API'
catalog: true
date: 2019/07/19 13:45:01
tags: [JavaScript, GoogleMap]
categories: [Frontend]
toc: true
---
>筆記如何使用Google Map API 進行服務
<!-- toc -->
# 前言
Google Maps是現代人形影不離的工具，交通的部分時常都得依靠他的幫忙，這篇就來筆記這項強大服務的使用方法吧!
<!--more--> 
## 前置作業
1. Build API Key

使用方式是[參考這篇](https://tutorials.webduino.io/zh-tw/docs/socket/useful/google-map-1.html)。

2. How to use it?

使用方式有分: **Maps JavaScript API、Google Maps Embed API、Google Static Maps API**

## Maps JavaScript API

API key要放在`<script > 中src="YOUR_API_KEY的位置"`。
> ref: [官方教學](https://developers.google.com/maps/documentation/javascript/tutorial)
```html=
<iframe src="https://medium.com/media/05cea78661b5fbd4070f58aafb9380fd" frameborder=0></iframe>
```
在畫面上放入一個 id名為map的`<div>`標籤載入地圖，透過`google.maps.Map()`的方法建立地圖物件。

`center`定義中心點經緯度，`lat` 是緯度 latitude，`lng`是經度 longitude，`zoom` 指定放大比例，數字越大，放越大。

### 緯度與經度取得(Latitude & Longitude)

* 可以從網站上獲得 => [https://www.latlong.net/](https://www.latlong.net/)

* google map上點擊位置後,從網址中可以撈到

實作:
```html=
<iframe src="https://medium.com/media/17bc327ac83126ed1f3b13af896226ed" frameborder=0></iframe>
```
![右邊的map2設定無法滑鼠拖曳](https://cdn-images-1.medium.com/max/2000/1*6OLgMWEv9Kaq6EvWHElT-w.png)*右邊的map2設定無法滑鼠拖曳*

<補充>
> `mapTypeId`: 顯示地圖種類，如:
> `google.maps.MapTypeId.HYBRID` : 衛星+街道圖
> `google.maps.MapTypeId.ROADMAP`: 一般街道圖
> `google.maps.MapTypeId.SATELLITE`: 衛星圖
> `google.maps.MapTypeId.TERRAIN`: 地形圖
> `mapTypeControl: false`表不顯示切換地圖類型的使用者元件
> `scaleCont:rol: false`表不顯示縮放地圖大小的使用者元件
> `draggable: false` 使用者無法用滑鼠進行拖曳，改變地圖的顯示位置

### 利用Geocoder取得經緯度

Google Map提供Geocoder的服務，將地名與經緯度做對照，讓使用者可利用地名查詢經緯度，查詢結果為**JSON**格式。

建立Geocoder物件
> `new google.maps.Geocoder()`

範例:
```html=
<iframe src="https://medium.com/media/ff643a563fd520906a4b07d97a87e208" frameborder=0></iframe>
```
![](https://cdn-images-1.medium.com/max/2000/1*a4cdzdSj1KsYwXxTgpuqUQ.png)

<note>免費的Geocoder查詢服務每日2500次的限制。

在地圖中加入標記(Marker)
```javascript=
    // 建立 Marker 物件

    var marker = new google.maps.Marker({

    position: latlng, // 標記的位置

    map: mymap,            // 標記要放的地圖

    title: 地名  // 滑鼠移到標記上面時顯示的文字

    });
```
範例:

獲取各縣市紫外線強度
```html=
<iframe src="https://medium.com/media/070d7b016b6e9a9d8c78b4dcce8bd85a" frameborder=0></iframe>
```
![](https://cdn-images-1.medium.com/max/2000/1*iqkVE-SCjzt-Xkyyg1EeHw.png)

<note>

WGS84是經緯度座標的一種，Google Maps也是採用WGS84，但是格式採用的是純數字格式。WGS84以資料中花蓮縣為例

![](https://cdn-images-1.medium.com/max/2000/1*Ak1eEE7wohsIbtWYhEggPA.png)

WGS84經緯度格式除了度之外還有分、秒，三者之間以逗點隔開，其中分、秒都是六十進位，若要將上述WGS84經緯度格式轉換成十進位，才能將經緯度用於Google Maps，採以下作法:

JS的`split()`方法分割字串，將`"23,58,30"`以逗號為分隔符`split(',')`，分割成3個數字的陣列:` ['23', '58','30']`

後續轉成字串陣列進行換算。
```javascript=
    lat = 23 +       // 度
    58 / 60       // 1度 = 60分
    30 / 3600    // 1度 = 60分 = 3600秒
```
### 更換圖標
在建立Maker物件中新增一個icon屬性。
```javascript=
    var marker = new google.maps.Marker({

    position: latlng, // 標記的位置

    map: mymap,            // 標記要放的地圖

    // 滑鼠移到標記上面時顯示的文字
    title: this.SiteName+','+this.County+',紫外線指數'+this.UVI,

    label: uvi.toString() , // 將 UV 指數數值轉回字串

     // 更換圖標
    icon: 'http://maps.google.com/mapfiles/ms/micons/sunny.png'
    });
```
[相關教學文](https://www.oxxostudio.tw/articles/201801/google-maps-6-marker-image.html)
### Google Maps Embed API

### 啟用

到Google API 服務頁面的資訊主頁，選擇**Map Embed API**，進入後點選啟用。

![](https://cdn-images-1.medium.com/max/2000/1*9XdtRVP8F4_eVLpLROIXKg.png)

由Google Maps網站取得嵌入式地圖，選擇要的地點後，點選左邊的選單，找到嵌入地圖的位置。

![](https://cdn-images-1.medium.com/max/2000/1*ZwnUim_qW0ou6WJn5dwZeA.png)

點選"嵌入地圖"，複製`<ifram>`標籤內的URL，貼到`<body>`內即可顯示。

![](https://cdn-images-1.medium.com/max/2000/1*DHUZj_AD6zbDbXtqcjwjUA.png)

範例:
```html=
<iframe src="https://medium.com/media/2bac1b3f4d13d998f09954ce323f5829" frameborder=0></iframe>
```
![](https://cdn-images-1.medium.com/max/2000/1*qUi6L_njuEzuo4-y8_QYiQ.png)

### 可以採用自訂嵌入式地圖
```html=
<iframe src="https://medium.com/media/3e66a90d33c7a67197589b7dbfd5c6a4" frameborder=0></iframe>
```
上述的code可獲得一樣結果。

![](https://cdn-images-1.medium.com/max/2000/1*qUi6L_njuEzuo4-y8_QYiQ.png)

### place:

一班表示位置的地圖，需用參數 `q` 指定要顯示的位置。位置字串中若有空白(如英文地名)，須改用 `+` 號代替。另外，URL中不同參數要用` &` 隔開，`palce`之後的參數無一定順序。

### view:

單純檢視地圖，無其他標示，需用`center`、`zoom`來控制，`center`內的參數前後分別為: 緯度、經度，以逗點分開。

`maptype`指定地圖類型，如statellite(衛星圖)、roadmap(街道圖;為預設)。

<note>

參數`zoo=0`時，表示將全世界的地圖納入一個圖塊中，數字每增加1，橫向及縱向各放大2，如`zoo=2` 時，每個圖塊就是1/16大小的全球地圖。

directions:

顯示路線，至少需用`origin`、`destination`參數，其餘如`waypoint`、`mode`、`avoid`等為選擇性的參數。
> `origin`: 指定起點
> ``destination``: 指定終點
> `waypoint`s: 中間經過的路線
> `mode`: 指定交通方式
> `avoid`: 避開方式

範例:
```html=
<iframe src="https://medium.com/media/ee8fc0cb51e3fc30570a1cea1db28996" frameborder=0></iframe>
```
起點名稱後面可多加一個郵遞區號的參數，可以使定位更精確，如上面的70449，若經過多個地點(waypoints)，彼此用 `|` 符號分開。

### search

搜尋模式，例如搜尋某地餐廳、商家，同樣用 q 做參數指定。

## streetview

街景模式，必須location指定經緯度，如一個鏡頭看世界，有幾個可選用參數，不同參數一樣用" & " 隔開。
>  以下三個參數都用角度(數字)表示
> `heading`: 鏡頭朝向哪個方向，北邊為0度，順時針增加
> `pitch`: 指定仰角，水平為0，向上為上，向下為負
> `fov`: 指定視野寬度，指定範圍 10~110，預設為90
```html=
<iframe src="https://medium.com/media/1e483a375d3aaaf44c8279f65d21ca95" frameborder=0></iframe>
```
![左邊為街景圖](https://cdn-images-1.medium.com/max/2000/1*z75p2ISL3Hp0F9oM35CqrQ.png) 


## Google Static Maps API

若不想使用`<ifram>`標籤，可改用靜態地圖(Static Maps)。

如何使用? [官網](https://developers.google.com/maps/documentation/maps-static/web-service-best-practices?hl=zh-tw)有詳細說明

建立`<img>`標籤載入網頁的靜態地圖，將src屬性設為API的URL，並加上適當參數。

基本的參數如`center`、`zoom`之外，還有其他選用參數可調整。
> `format`: 影像檔類型，預設為png，可設為png32、gif、jpg。如果要較大的圖檔，可利用format=jpg 減少檔案大小。
> `maptype`: satellite(衛星圖)、hybrid(衛星+地名+路名)、terrian(地形圖)、roadmap(街景圖，為預設)。
> `size`: 指定地圖大小，預設為1，例如: size=100x100，即回傳100x100大小的地圖。
> `scale`: 指定圖像放大的比例(多少像素表示)，如size=100x100&scale=2，會回傳200x200大小的地圖。
> `visible`: 指定要出現在地圖上的地標，使用此參數可省略zoom，若要指定多個地標，可用 | 符號分開。
```html=
<iframe src="https://medium.com/media/95b73953bc9683c317ac1a4aaa0df0c4" frameborder=0></iframe>
```
![](https://cdn-images-1.medium.com/max/2000/1*_Cqpo8qPB_FbxM0-ZU72Tw.png)

Tip: 免費Google Static Map最大只會回傳640x640大小，若設`scale=2`可得1280x1280大小的地圖

### 自訂地圖樣式

在靜態地圖中，可利用style參數指定地圖樣式，多個參數用|隔開。
> `&style`=參數:參數值

可選參數:
> `hue`: 設定地圖色調(RGB)，參數格式0xRRGGBB，如要紅色的話:0xFF0000
> `lightness`: 設定地圖亮度，數值範圍: -100(全黑)~100(全白)
> `saturation`: 設定地圖飽和度，數值範圍: -100(飽和度最小)~100(飽和度最大)
```html=
<iframe src="https://medium.com/media/1dfb9d18d0e9fbd18bdde42f8a8f5fe2" frameborder=0></iframe>
```
範例:

![](https://cdn-images-1.medium.com/max/2000/1*6Myu503CF_tbAAmxwihU7w.png)

### 在地圖上加上marker(標記)

我們還可以在加上標記，放入靜態地圖。語法格式如下:
`markers=size:value|color:value|label:value|地點`

地點(必要參數): 地點可使用地名或經緯度，若有多個地點可用|分開
> `size`: marker的大小，可設為 tiny、small、mid，預設為normal(最大)。
> `color`: marker的顏色，可使用0xRRGGBB格式或是預設的顏色名(black、white、brown、green、orange、purple、red、yellow、white)
> `label`: 顯示marker中的英文字(大寫)或數字(0~9)。

實作: 高雄市空氣汙染指標

到[政府開放資料平台](https://data.gov.tw/dataset/40448)獲取[JSON資料](https://opendata.epa.gov.tw/ws/Data/AQI/?$format=json)
```html=
<iframe src="https://medium.com/media/5b0f3ce5c9c226b40c559c02328a12f0" frameborder=0></iframe>
```

![](https://cdn-images-1.medium.com/max/2000/1*mHKxlHP3dPFGSJhAjXuxYA.png)

程式結果如上圖(竟然不是紅色的，真令人驚訝XD)。

<note> 

在JSON格式中，PM2.5包含小數點，所以不使用`object.attr(物件.屬性)`的方式讀取，改採`object ["attr"]`的方法讀取值，屬性名一定要用`[]`括起來，類似存取陣列元素。

