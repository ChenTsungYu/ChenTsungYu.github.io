---
title: "[Go] Map"
catalog: true
date: 2020/01/10 20:23:10
tags: Go
categories: Backend
toc: true
---

<!-- toc -->
# 前言
本文主要紀錄 Go 語言中的 Map
<!--more-->
# Golang 中的 map
`map` 為 Golang 中鍵值對(**key-value**)的資料結構，左側為 `key` ，右側為 `value`，有以下幾個特性:
- **排列無一定順序**
- `key` 在 map 是唯一的，而 `value` 可能不是
- 適合用在： 基於 `key` 快速尋找、取得和刪除資料
- `map` 的零值為 `nil`

# 相關操作
## 宣告 map
語法結構
```go=
var m map[KeyType]ValueType
```
### 說明
- **KeyType**: 鍵的資料型別
- **ValueType**: 值的資料型別

## map 的零值
前面提到過 `map` 的零值為 `nil`，而值為 `nil` 的 map 沒有 `key`，來看以下範例:
```go=
var m map[string]int

fmt.Println(m)

if m == nil {
    fmt.Println("m is nil")
}
```
輸出
```go=
m is nil
```
若將 `key` 加到值為 `nil` 的 `map` 的會導致 Golang 於執行時期發生錯誤
```go=
var m map[string]int

m["hello"] = 1
```
彙報如同下方的錯誤
```go=
panic: assignment to entry in nil map
```

## 初始化 map 實例
使用 `make()` 函示即可建一個 `map` 實例，該函式會回傳已初始化及可以使用的 `map` 值
語法結構
```go=
make(map[KeyType]KeyType)
```
來看範例
```go=
m := make(map[string]int) // 等同 m := map[string]int {} or var m = map[string]int{}

fmt.Println(m)      // map[]
fmt.Println(len(m)) // 0

if m == nil {
    fmt.Println("m is nil")
} else {
    fmt.Println("m is not nil")
}

m["hello"] = 1
fmt.Println(m) // map[hello:1]
// 取得特定 key 對應的 value
fmt.Println(m["hello"]) // 1
```
輸出結果為：
```go=
map[]
0
m is not nil
map[hello:1]
1
```
## 初始化 map 時給值
遇到已知 `map` 中會有 key-value 的情形，可以如下方範例建立 `map`
```go=
var m = map[string]int{
    "one":   1,
    "two":   2,
    "three": 3,
    "four":  4,
    "five":  5, 
}

fmt.Println(m) // map[five:5 four:4 one:1 three:3 two:2
```
注意:
> 最後一個**必需加上逗號**，否則將出現編譯錯誤
> 若是最後一個 key-value 項目後不換行，最後一個就不需要逗號

```go=
t := map[string]int{"t1": 1, "t2": 2}
fmt.Println(t) // map[t1:1 t2:2]
```
## 可用來做為 `key` 的值
Golang 裡可用來做為 `key` 的值，須為 **comparable** 型態，如：數值、字串、布林值、channel、pointer、struct、interface 等等，注意：**函式、切片(slice)、map 皆不能做為** `key`
## map 為參考型別
若將 `map` 指派給新變數時，它們皆參考同樣底層的資料結構

```go=
mm1 := map[string]int{
    "one":   1,
    "two":   2,
    "three": 3,
    "four":  4,
    "five":  5,
}

mm2 := mm1
fmt.Println("mm1 = ", mm1)
fmt.Println("m2 = ", mm2)
fmt.Println("========")
mm2["ten"] = 10
fmt.Println("mm1 = ", mm1)
fmt.Println("mm2 = ", mm2)
```
由下述結果可知，將 mm1 賦值給 mm2 後(`mm2 := mm1`)，只改變 mm2 的 `key` 對應的值，mm1 相同名稱的 `key` 也跟著改變 -> 一個改變，另一個也相應的改變
```go=
mm1 =  map[five:5 four:4 one:1 three:3 two:2]
mm2 =  map[five:5 four:4 one:1 three:3 two:2]
========
mm1 =  map[five:5 four:4 one:1 ten:10 three:3 two:2]
mm2 =  map[five:5 four:4 one:1 ten:10 three:3 two:2
```
## key-value 的操作
### map 存取
寫過 Python 的人對這個用法: `m[key]` 一點也不陌生，類似於對 **dictionary** 的操作
```go=
// 初始化 map
var person = make(map[string]string)

// 把 key, value 加到 map 裡
person["name"] = "Tom" 
person["gender"] = "male"
person["country"] = "ROC"

fmt.Println(person) //  // map[country:ROC gender:male name:Tom]

// 取得目標 key 對應的值
fmt.Println(person["name"]) // Tom

// 若是指定的 key 存在，則會覆寫該 key 原先對應的值 
person["name"] = "Jack"
fmt.Println(person) // map[country:ROC gender:male name:Jack]
```

### 取得未分派給 map 中 key
若分派得 key 尚未存於 `map` ，則會得到 `map` 值型別的`零值`
```go=
city := person["city"]
fmt.Println(city) // ""
```
在上面的範例中，由於名為 `city` 的 `key` 不存於 `map` 中，得到 `map` 值型別對應的零值。由於 `map` 值的型別是 `string`，因此輸出的結果為 `""`

> 所以在`Golang` 中即便 `key` 不存於 `map` 裡，也**不會出現執行時期錯誤**

### 如何檢查 map 中不存在的 key?
其實使用 mapName[key] 時，除了得到分派給特定的 `key` 對應的值，同時回傳一個`布林值`。換句話說，若是沒有該 `key` ，即回傳該值的資料型別的零值，第二個是布林值，指出鍵是否存在。
拿上述範例來看
```go=
name, ok := person["name"]
fmt.Println("name: ", name, ok)

city, ok := person["city"]
fmt.Println("city: ", city, ok)
```
回傳結果
```go=
name:  Jennifer true
city:   false
```
從結果可知，若該 `key` 是存在的，回傳布林值為 `true`，反之則為 `false`。
藉由上述方法，我們也能單純做檢查 `key` 是否存在，使用 `_` 略過回傳的值
```go=
if _, ok := person["name"]; ok {
    fmt.Println("Name existed")
} else {
    fmt.Println("No name")
}

if _, ok := person["city"]; ok {
    fmt.Println("City existed")
} else {
    fmt.Println("No city")
}
```
結果
```go=
name:  Jennifer
No city
```

## 刪除 map 中的 `key`
使用內建函式 `delete()` 刪除 map 中的 `key`，而函式不會回傳任何值。若該 `key` 不存於 `map`中，也不會執行任何操作。
### 語法結構
```go=
delete(map, key)
```
範例
```go=
person := map[string]string{
    "name":    "Tom",
    "gender":  "male",
    "country": "ROC",
}

fmt.Println(person) // map[country:ROC gender:male name:Tom]

delete(person, "gender")
fmt.Println(person) // map[country:ROC name:Tom]
```

## 迭代 map
透過 `for` 迴圈搭配 `range` 迭代 `map`

```go=
person := map[string]string{
    "name":    "Tom",
    "gender":  "male",
    "country": "ROC",
}

fmt.Println("====== 迭代 key, value ======")
for k, v := range person { // 迭代 key, value
    fmt.Println("key: ", k)
    fmt.Println("value: ", v)
}

fmt.Println("====== 只迭代 key ======")
for k := range person { // 只迭代 key
    fmt.Println("key: ", k)
}

fmt.Println("====== 只迭代 value ======")
for _, v := range person { // 只迭代 value
    fmt.Println("value: ", v)
}
```
結果
```go=
====== 迭代 key, value ======
key:  name
value:  Tom
key:  gender
value:  male
key:  country
value:  ROC
====== 只迭代 key ======
key:  name
key:  gender
key:  country
====== 只迭代 value ======
value:  Tom
value:  male
value:  ROC
```
### 排序 map
本文開頭有提及 map **排列無一定順序**，若要將結果做排序，必須另外處理
```go=
person := map[string]string{
    "name":    "Tom",
    "gender":  "male",
    "country": "ROC",
}

keys := make([]string, 0, len(person))
for key := range person {
    keys = append(keys, key)
}
sort.Strings(keys)

for _, key := range keys {
    fmt.Printf("%s : %q\n", key, person[key])
}
```
結果
```go=
country : "ROC"
gender : "male"
name : "Tom"
```