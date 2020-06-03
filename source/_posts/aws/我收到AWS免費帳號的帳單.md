---
title: "[AWS] 我收到AWS寄來免費帳號的帳單"
date: 2020-05-09
tags: [AWS, w3HexSchool]
categories: [Cloud]
toc: true
---

> 鼠年全馬鐵人挑戰 - WEEK 14

<!-- toc -->
# 前言
本篇為個人經驗分享，會寫下這篇的原因是我在AWS註冊Free Tier帳號後，在使用過程中意外收到90美金的帳單，內容將涵蓋我為何會收到帳單到成功全額退款，給有遇到相同問題的人一個參考。
<!--more-->

# 起因
有天收到來自AWS的帳款通知信，信中顯示總金額為90美金，剛開始收到信還疑惑為何被收這麼高的費用(2700台幣對我來說負擔不小啊.....)
![](https://i.imgur.com/h2keouw.png) 

心想完了...月初就要面臨吃土，可憐哪。[圖片源](https://zi.media/@whyhtd01com/post/kottzc)
仔細想想，當初也是辦理免費帳號，怎會突然被收費了呢？而且一直以為我應該有把沒用的服務關掉(？)打開帳單明細發現不得了......
![](https://i.imgur.com/K34Coet.png)
>  Database Migration Service這項服務收了我75美金？？？

記得之前玩的時候明明有關掉，細看服務啟用的區域才發現，天阿...原來開在Oregon的服務被我漏掉了...而且我還開Multi-AZ(傻眼貓咪)，看完帳單後就立刻先把帳號關閉，避免再被收費。
上網搜一下是否有人跟我遇到相同問題，看到Quora上有不少人遇到這種情況，原來我不孤單(?)
![](https://i.imgur.com/xwi1jl3.png)
看到有人收到千元的帳單頓時覺得我只是小錢嘛～而且也有成功撤銷費用，看起來我應該也有機會，所以就發Issue給AWS Support囉！
# 如何發issue?
## 進入Support Center
![](https://i.imgur.com/zumJcmo.png)
登入AWS帳號後，右上角有個Support下拉選單，點擊**Support Center**，選擇Account and billing support -> Billing -> Charge Inquiry
![](https://i.imgur.com/FxXr0rE.png)
## 建立並填寫Case
![](https://i.imgur.com/yz6mNvZ.png)
描述一下自己被收費的情況，下方可以上傳檔案，建議把收到的帳單附上去，Support可以比較快針對問題去解決
![](https://i.imgur.com/3W51FfE.png)
填寫完成之後就可以點擊最下方的**Submit**進行提交！
# Support回應
![](https://i.imgur.com/RHkjP2e.png)
看完AWS Support回信內容才了解產生費用的原因是我**使用非免費帳號所涵蓋的服務範圍**，才被收取費用。
當時心想...怎麼沒有一個機制是提醒使用者這是非免費的服務範圍，收到帳單後詢問才知道...
好啦，一部分原因可能是我在使用每個服務前沒有特別去查該服務是否在免費範圍內，不過如果能多一個警示機制會不會更好呢？不用每次都去查。[點我看AWS免費方案](https://aws.amazon.com/free/?nc1=h_ls&all-free-tier.sort-by=item.additionalFields.SortRank&all-free-tier.sort-order=asc)
後續照AWS Support給的指示完成後，馬上收到好消息
![](https://i.imgur.com/ivlS3fQ.png)
除了原本被收90美金的費用全額撤銷，連五月份目前所產生的費用也都被免除了！整個流程三天內搞定！
![](https://i.imgur.com/qNTFTNn.png)
查看帳單，成功全額退款，我不必月初吃土了！
另外AWS Support還有提醒可以開啟費用警示的功能(我現在才知道原來有這功能)，一開始還抱怨說怎麼可以無預警收我錢，AWS太可惡了！不過AWS回覆算還不錯，整個處理流程速度很快，值得讚美一下！(恩….真香)
# 費用查看
如果要查看帳戶當前產生的費用可至**My Billing Dashboard**
![](https://i.imgur.com/hrLSCbp.png)
選擇左方的Cost Explorer可以查看每天或每月使用服務情形
![](https://i.imgur.com/rpTTEer.png)
或是到**Bills**也可以查看帳單明細
![](https://i.imgur.com/YBGp7Qj.png)
# 透過帳單警示來監控自訂的預估費用
根據AWS Support的指示，可以利用CloudWatch這項服務來監控AWS服務產生的費用，啟用帳單提醒，並寄信通知！[官方教學](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/monitor_estimated_charges_with_cloudwatch.html#turning_on_billing_metrics)
## 開啟帳單提醒
若要建立預估費用警示，必須先啟用帳單提醒
打開Billing的頁面，點擊左方選項[Preferences](https://console.aws.amazon.com/billing/home?#/preferences)
勾選**Receive Billing Alerts.**
![](https://i.imgur.com/2lo1YVW.png)
當然你要勾選其他的也可以，選好後點Save。
## 建立帳單警示
開啟[CloudWatch](https://console.aws.amazon.com/cloudwatch/home?region=us-east-1)
選擇左方列表中的**Alarm**，並點擊Create Alarm
![](https://i.imgur.com/AeOwIj6.png)
選擇**Select metric** -> **All metrics tab** -> **Billing** -> **Total Estimated Charge** -> **USD**
完成上述步驟點選**Next**，選擇**Static**
![](https://i.imgur.com/pP0G0WP.png)
接著看你想選擇哪個條件，設定完你要的條件後按**Next**
![](https://i.imgur.com/bP9jtJW.png)
再來是選擇**In alarm** -> **Create new topic** -> **填寫topic name、Email endpoints** -> 點擊**Create topic**
![](https://i.imgur.com/tDCmFXH.png)
它會結合AWS SNS的發信服務，所以要到剛才自己填寫的信箱去收信，點擊確認信中用來開通服務的連結，再回到剛剛Alarm的畫面，點擊**Next**。
![](https://i.imgur.com/Vk0T9l2.png)
填寫Alarm Name後點點擊**Next**會進入**Preview and create**的頁面
![](https://i.imgur.com/S1l3wVo.png)
確認無誤後點**Create alarm**即可完成設定！
![](https://i.imgur.com/eKR0ePv.png)
當Status顯示綠色就OK囉！
# 後記
有這次的經驗後，在玩雲服務時都特別注意一下相關的條款，還有利用一些警示功能來避免意外被收取大量費用，如果真的不幸收到大筆帳單，只要發Issue給Support，描述一下誤用的情形(他們會查看帳號使用服務的情形是否符合你的描述)，基本上有很高的機率能收到全額退款！