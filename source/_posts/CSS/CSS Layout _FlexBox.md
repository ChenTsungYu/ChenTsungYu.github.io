---
title: '[CSS] Flexbox 排版'
catalog: true
date: 2019/07/14 17:23:10
tags: Css
categories: Frontend
toc: true
---
<!-- toc -->
# 前言
這篇要討論的是比較新式的排版-FlexBox
FlexBox為了**適應不同螢幕尺寸和顯示設備**而生的布局模式。現在因為手機普及，使用者大多用手機上網，為了改善使用者體驗，寫網頁需要考量到網頁呈現在手機上的排版方式。
# Go!
<!--more--> 
FlexBox的特徵:

首先，要先將FlexBox做分類， 分為**外容器屬性(Container)**與**內元件屬性(Items)。**

![](https://cdn-images-1.medium.com/max/2000/1*h7mkSdBrIBz2AGA01h1Q0g.png)

## 外容器(Container):

若想切換FlexBox的排版模式，要在CSS樣式宣告display，display分為兩種：

1.display:** flex** 為塊級元素，似block

２.display: **inline-flex** 為行內塊元素，似inline-block

以下提供範例:

~~~htmlmixed=
<style>
      * {
           margin: 0;
           padding: 0;
        }
        .box {
          max-width: 100%;
          border: 3px black solid;
          display:flex;
        }
        .item {
            width: 150px;
            text-align: center;
            padding: 1rem;
            font-size: 2rem;
        }
        .item:nth-of-type(1) {
            background: red;
            padding-bottom: 1rem;
            font-size: 2rem;
        }
        .item:nth-of-type(2) {
            background: yellow;
            padding-bottom: 5rem;
            font-size: 2rem;
        }
        .item:nth-of-type(3) {
            background: green;
             font-size: 2rem;
        }
        .item:nth-of-type(4) {
            background: blue;
            font-size: 2rem;
        }
        .item:nth-of-type(5) {
            background: pink;
            font-size: 2rem;
        }
    </style>    
<div class="box">
        <div class="item1 item">item1</div>
        <div class="item2 item">item2</div>
        <div class="item3 item">item3</div>
        <div class="item4 item">item4</div>
        <div class="item5 item">item5</div>
    </div>
~~~

當外層盒子宣告display時，裡面的盒子會變成水平排列。

![](https://cdn-images-1.medium.com/max/2000/1*8IPyQsqR8RRVdxun7-XagQ.png)

好，到這邊我們需要先瞭解幾件事情：

* .box 已經變成了 Flexbox Model 排版模式，會直接影響到其第一層子元素( item)的排版行為。

* .box 是 Flexbox Model 中的 Flex container。

* item 是 Flexbox Model 中的 Flex item(s)，因為是 .box的第一層子元素。

* 此範例適用於任何父子元素，不僅限於 ul、li，也可以用在任何 div 或其它元素。

## Flex Container 相關屬性，此上圖程式碼為例

### 共有六種屬性可以設定，在記屬性前必須需先了解FlexBox的兩個軸線。

![](https://cdn-images-1.medium.com/max/2000/1*KQSIbMKZvIqYhldd8pYWuw.png)

當 .box 設定為 **display:flex **時，就代表會有這兩個隱形的軸，**Main Axis** 表示**從左至右**；**Cross Axis **表示**從上至下**。

當** flex-direction** 設定為以下的值時，就會影響到**第一層子元素(Flex Items)**的排列方向：

* row：為預設值，代表 Flex Items 會從左至右依序排列。

* column：代表 Flex Items 會從上至下依序排列。

* row-reverse：代表 Flex Items 會從右至左依序排列。

* column-reverse：代表 Flex Items 會從下至上依序排列。

程式碼(前四個):

~~~htmlmixed=
.box{
  // 第一種
  flex-direction: row || column || row-reverse || column-reverse;
}
~~~

![flex-direction: row-reverse;](https://cdn-images-1.medium.com/max/2020/1*WEfJZYhCNuUEkP5buHLpUg.png)*flex-direction: row-reverse;*

![flex-direction: column](https://cdn-images-1.medium.com/max/2000/1*zHqd6ItJcVAQrkylyQdhsg.png)*flex-direction: column*

![flex-direction: column-reverse](https://cdn-images-1.medium.com/max/2000/1*xiIO9KTLmCDwg4rLfBMOBw.png)*flex-direction: column-reverse*

~~~htmlmixed=
.box{
 /* 第2種*/
  flex-wrap: wrap || no-wrap || wrap-reverse;
}
~~~

說明：

* wrap：代表當 Flex Items 數量過多，多到 Flex Container 裝不下的時候，會斷行，會斷行的方向會是往下斷行。

![flex-wrap: wrap](https://cdn-images-1.medium.com/max/2000/1*a5AgSc84eL6vtwL8u0K8xw.png)*flex-wrap: wrap*

* no-wrap：此為**預設值**，代表即使 Flex Items 數量過多，依然不會斷行，Flex Container 都會試圖去包含這些 Flex Items 在同一列。

![flex-wrap: nowrap](https://cdn-images-1.medium.com/max/2000/1*kVr4tHeO01m5QQ-NECNK9Q.png)*flex-wrap: nowrap*

* wrap-reverse：代表當 Flex Items 數量過多，多到 Flex Container 裝不下的時候，會斷行，會斷行的方向會是往上斷行。

![flex-wrap: wrap-reverse](https://cdn-images-1.medium.com/max/2000/1*nZx6vVl3o-450T0DHpncgg.png)*flex-wrap: wrap-reverse*

* flex-flow 單純只是個 flex-direction 和 flex-wrap 同時用的縮寫

~~~htmlmixed=
.box{
/* 第三種*/
  flex-flow: <flex-direction> <flex-wrap>;
}
~~~

* justify-content 是用來定義 Flex Items 該如何在 Main Axis 排列。

~~~htmlmixed=
.box{
/* 第四種 */
  justify-content: flex-start || flex-end || center || space-between || space-around || space-evenly ;
}
~~~

**flex-start**：是預設值。代表 Flex Items 從 Main Axis 的起點開始排列。

**flex-end**：代表 Flex Items 整個的結尾要往 Main Axis 的尾端貼齊。

**center：**item針對 Main Axis 來置中。

**space-between：** 各個 Flex Item 延著 Main Axis **平均分散**，但 Flex Item 之間會**保留相同大小的空間，首、尾都要貼緊邊界**。

**space-around：**各個 Flex Item 延著 Main Axis 平均分散，但每一個 Flex Item 周圍都要保持相同的距離，**在不設margin下**，**首、尾不貼邊界，且距離邊界保留的空間大小相等**。

**space-evenly：**每個小方塊之間和與父容器之間擁有相同的間隔。

## space-between & space-around & space-evenly區別

* space-between：每個小方塊**擁有相同的間隔**，但與父容器之間沒有間隔。

* space-around：每個小方塊之間與父容器有間隔，但小方塊與父容器之間的間隔是小方塊彼此間隔的一半。 **假設今天與父容器的間隔為X，那小方格之間的間隔就是2X。**

* space-evenly：每個小方塊之間和與父容器之間擁有相同的間隔。**假設今天與父容器的間隔為X，那小方格之間的間隔仍為X。**

來看看實作:

![justify-content: flex-start](https://cdn-images-1.medium.com/max/2720/1*QSFSTSfEEfh5F6sf9ntXVg.png)*justify-content: flex-start*

![justify-content: flex-end](https://cdn-images-1.medium.com/max/2744/1*weDasYtK5HQJ6rs4q-6Nyw.png)*justify-content: flex-end*

![justify-content: center](https://cdn-images-1.medium.com/max/2720/1*JW_9ZPuA9aEt5qV4Y_iK4A.png)*justify-content: center*

![justify-content: space-between](https://cdn-images-1.medium.com/max/2734/1*yJmxX8l6nSXtuWntYC54MQ.png)*justify-content: space-between*

![justify-content: space-around](https://cdn-images-1.medium.com/max/2720/1*m3JambN1uARfE0r6gOQgwg.png)*justify-content: space-around*

### align-items :

與 justify-content 非常相似，但定義 Flex Items 該如何在 **Cross Axis 排列**

* flex-start： 表Flex Items **高度並不會增加**至 Flex Container 的高度，各 Flex Items 會直接對齊 Cross Axis 的起點。

![](https://cdn-images-1.medium.com/max/2508/1*OQGoib5oNgA2YiYZYWcEpg.png)

* flex-end： 表Flex Items **高度並不會增加**至 Flex Container 的高度，各 Flex Items 會直接對齊 Cross Axis 的最終點。

![](https://cdn-images-1.medium.com/max/2508/1*b1P1tmkgWF561rcRPeNhYw.png)

* center：每個 Flex Items 會直接對齊** Cross Axis 高度的中間**。

![](https://cdn-images-1.medium.com/max/2504/1*f0sE5eWxGP8-y8YPyWsFow.png)

* stretch：**預設值，**表 Flex Items 的高度，沿著 Cross Axis，都會自動增加高度至 Flex Container 的高度。按照字面就是延伸，**將Item的高度延伸至Container的高度**。

![](https://cdn-images-1.medium.com/max/2506/1*A2YEzdPBLFYSQKTkXFl9Yg.png)

* baseline：會依據 Flex Items 的基準線來對齊。下圖範例可知雖然各個item高度不同，但對齊的基準是文字內容。

![](https://cdn-images-1.medium.com/max/2000/1*NY7tyQgYB8I_afXY7DLPHA.png)

### align-content:

主要是用在 Flex Container 中的 **Flex Items 產生多行**時，這些 Flex Item 該如何針對 Cross Axis 來排列。

~~~htmlmixed=
.box{
 /* 第六種 */
  align-content: flex-start || flex-end || center || stretch;
}
~~~

* flex-start：遇到 Flex Items 斷行，會沿著 Cross Axis 排列，似置頂的方式：

![](https://cdn-images-1.medium.com/max/2000/1*uu3MEalvqE9QjZ7k0a45kQ.png)

* flex-end：遇到 Flex Items 斷行，會沿著 Cross Axis 會如下排列(置底)：

![](https://cdn-images-1.medium.com/max/2000/1*dBzk-cYUOYnQbNHkUjw08g.png)

* center: 遇到 Flex Items 斷行，會沿著 Cross Axis 會如下排列(置中)：

![](https://cdn-images-1.medium.com/max/2000/1*Rei0E53Kr2nciE3WOuHEkw.png)

* stretch：預設值，遇到 Flex Items 斷行，各 items 的**高度會沿著 Cross Axis 自動增減**。

![](https://cdn-images-1.medium.com/max/2000/1*Dip5yZi0ntRUyODglRUcig.png)

## <note>

**Main Axis和Across Axis 會因為flex-direction的設置而有所不同，當flex-direction設置為column時，Main Axis和Across Axis要和flex-direction: row時相反。**

### 即row的**Main Axis = column的Across Axis，反之亦然。**

## Flex Item :

上面實作完Container相關的屬性後，往下實作Flex Item 相關屬性。

### Flex Item共有六種屬性可以設定:

~~~htmlmixed=
.item{
 /* 第一種 *\
  order: <number>; // 預設值 0
}
~~~

### order :

可以是任何的整數，所有的 Flex Items 預設值都是0。所有的 Flex Items 排列順序都會按照 order 值的大小，從最小開始排，**依序排到最大值**。

~~~htmlmixed=
.item:nth-of-type(1) {
            background: red;
            order: 1;
}
~~~

因為item的order被設為1，比其他item的order值(預設為0)還要大，故排至最後。

![](https://cdn-images-1.medium.com/max/2372/1*RWosnmm2HB-du7EDqPFKjQ.png)

### flex-grow:

設定該 Flex Item 自行延伸，將多餘空間填滿。 flex-grow **預設值是 0**，其表不延展填滿。

***若同時有多個元素都設有數值時,是**相對倍數做放大。**

*** **不可為負值**，但可為小數點。

~~~htmlmixed=
.item{
  // 第二種
  flex-grow: 0 ; // 預設值是 0
}
~~~

若將item1的flex-grow值設為1，可以得下面結果:

![剩餘的空間被 item1 所填滿](https://cdn-images-1.medium.com/max/2692/1*5goK4FLcD0uxJt_qk1DeRg.png)*剩餘的空間被 item1 所填滿*

### flex-shrink:

元件的縮減，是一個數值，空間分配不足時會改變當前元件的收縮程度，預設值為 1，如果**設置為 0 則不會縮放**。收縮的程度也是相對於其他元素的。數值**不可為負數**。

***可用於在改變螢幕大小時，將不重要的資訊做縮小。

```htmlmixed=
.item{
   /* 第三種 */
  flex-shrink:1  // 預設值是 1
}
```

以下範例實作，將item1的flex-shrink設為4，會得到以下結果:

![item1 所小的幅度大於其他 item](https://cdn-images-1.medium.com/max/2000/1*EAKgVtcNXdZReI43fwYorA.png)*item1 所小的幅度大於其他 item*

### flex-basis:

元件的基準值， 用來設定 Flex Item 的寬度，單位可以是任何百分比、不同的單位值(e.g. px ,rem)， **預設值為auto。 預設**情況下，Flex Item 的**寬度是會依據內容來自動變寬。**

```htmlmixed=
.item:nth-of-type(1) {
           flex-basis: 50px;
}
```
![item1被限制在50px的寬度](https://cdn-images-1.medium.com/max/2692/1*iUMhvmCwWHTvpGMwGo7QFw.png)*item1被限制在50px的寬度*

### flex:

flex 是縮寫，分別代表 flex-grow、flex-shrink、flex-basis。

**flex: default **是 flex: 0 1 auto; 的縮寫。

```htmlmixed=
.item{
   /* 第五種 */
  flex: <flex-grow> <flex-shrink> <flex-basis>; // 預設值依序為 0 1 auto;
}
```

**如果要設其中1個或2個單位的話,會有不同結果:**

**1個值:**

**flex:2; /* **flex-grow** */**

**flex: 30px ; /* **flex-basis** */**

**2個值:**

**flex: 1 30px; /* **flex-grow | flex-basis ***/**

**flex: 2 2 ; /* **flex-grow | flex-shrink** */**

### align-self:

只會影響特定 Flex Item ，針對該Flex Item的Cross Axis 排列方式調整，不會影響到其它的 Flex Items。下面範例以**item3為調整對象**。

```htmlmixed=
.item{
   /* 第六種  */
  align-self: auto || flex-start || flex-end || center || baseline || stretch; 
  // 預設值是 stretch;
}
```

* auto：該 Flex Item 的值，會直接參考 Flex Container 的 align-items 值，兩者相同。

![](https://cdn-images-1.medium.com/max/2692/1*HiHtnyKlPeRRF5obEIEWCw.png)

* flex-start：該 Flex Item 會對齊 Cross Axis 的起點，高度不會自動擴展。

![](https://cdn-images-1.medium.com/max/2692/1*cFLhxQ-6TmzfYntITJpC4g.png)

* flex-end：該 Flex Item 會對齊 Cross Axis 的底部，高度不會自動擴展。

![](https://cdn-images-1.medium.com/max/2692/1*owbTS_kon1vF6tp7KlpBiA.png)

* center：該 Flex Item 會對齊 Cross Axis 的中間，高度不會自動擴展。

![](https://cdn-images-1.medium.com/max/2692/1*q7sqKkvzBZ2q7M-rlTK4jA.png)

* baseline： 有設定成 baseline 的這些 Flex Items ，會彼此對齊 baseline。

![將 item1~3 都設 baseline](https://cdn-images-1.medium.com/max/2692/1*wefi3pPkS6T5CXP7eTgeCA.png)*將 item1~3 都設 baseline*

* stretch(預設)：該 Flex Item 會自動擴展，佔滿整個 Flex Container。

![](https://cdn-images-1.medium.com/max/2692/1*HiHtnyKlPeRRF5obEIEWCw.png)

以上為這次的筆記整理，相較以往的排版，這樣的排版的確彈性許多。
