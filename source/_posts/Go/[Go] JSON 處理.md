---
title: "[Go] JSON 處理"
catalog: true
date: 2020/01/18 20:23:10
tags: Go
categories: Backend
toc: true
---
<!-- toc -->
# 什麼是 JSON？
JSON 全名為: **Javascript Object Notation**
是一種輕量的資料交換格式，在網路資料傳輸領域非常常見，很多 open data 都是採這樣的格式做為資料互動的介面。
<!--more-->
JSON 範例:
表示多個使用者，每個使用者帶有 `name`, `gender`, `age`, `Country` 這幾類的資料屬性
```json=
"users": [
    {
        "name": "Tom",
        "gender": "Male",
        "Age": 24,
        "Country": "Taiwan"
    },
    {
        "name": "Jack",
        "gender": "Male",
        "Age": 40,
        "Country": "Taiwan"
    },
    {
        "name": "Amy",
        "gender": "Female",
        "Age": 30,
        "Country": "US"
    },
    {
        "name": "Jean",
        "gender": "Female",
        "Age": 33,
        "Country": "UK"
    }
]
```

Go 提供名為 `json` 的 package，可以藉由這個 package 讓我們對 JSON 做編碼、解碼等操作

# 產生 JSON
Go 語言的 `json`  package 裡面有個叫做 `Marshal` 的函式可對資料編碼成 JSON 格式。

## 語法結構：
```go=
func Marshal(v interface{}) ([]byte, error)
```
上述語法結構中：
- `interface{}`: 可用來存放`任意資料型別的物件`，剛好適用於解析未知結構的 json 資料格式
- `[]byte`: `byte` 型別的 `slice` 在 Go 語言裡用來編碼、解碼
- `error`: 回傳可能的錯誤結果

`Marshal` 範例
```go=
// JSON is string data 

type permission map[string]bool

type user struct {
	name, password string
	// permission     map[string]bool
	permission
}

user := []user{
    {"tom", "2332424", nil},
    {"jack", "4434345", permission{"admin": true}},
    {"james", "43434343", permission{"viewer": true}},
    {"John", "34447831", permission{"write": true}},
}

data, err := json.Marshal(user)

if err != nil {
    fmt.Println(err)
    return
}

fmt.Println(string(data)) // [{},{},{},{}]
```

執行上方範例，看到輸出結果竟然是 `[{},{},{},{}]`???


原因是 Go 在編碼 JSON 時，**只有首字母為大寫的 key 值才會被輸出**，也就是說，只有**匯出的欄位才會被輸出**，JSON 解析的時候**只會解析能被匯出的欄位**，找不到的欄位會被忽略。

我們可以利用這個特點：
若接收到一個資料量很大的 JSON 資料結構而**只想取得其中部分的資料**時，只需將想要的資料對應的**欄位名稱採大寫開頭**，即可達成目的。

## struct tag
但 `key` 值需要小寫或其他的名稱怎麼辦呢？ Go 語言提供了 `struct tag` 來實現小寫或其他的名稱，來看改寫上面的範例:
```go=

type permissions map[string]bool

type user struct {
    Name     string `json:"name"`
    Password string `json:"password"`
    // permission     map[string]bool
    Permissions permissions `json:"perms"`
}


user := []user{
    {"tom", "2332424", nil},
    {"jack", "4434345", permissions{"admin": true}},
    {"james", "43434343", permissions{"viewer": true}},
    {"John", "34447831", permissions{"write": true}},
}

data, err := json.Marshal(user)

if err != nil {
    fmt.Println(err)
return
}

fmt.Println(string(data))

// output
// [{"name":"tom","password":"2332424","perms":null},{"name":"jack","password":"4434345","perms":{"admin":true}},{"name":"james","password":"43434343","perms":{"viewer":true}},{"name":"John","password":"34447831","perms":{"write":true}}]
```
### struct tag 幾個特點:
- 欄位的 `tag` 是 `"-"`: 這個欄位**不會輸出到 JSON**
- `tag` 中帶有自訂名稱，那麼這個自訂名稱會出現在 JSON 的欄位名中，例如上面例子中 
- `tag` 選項中如果有 `"omitempty"` ，表該欄位如果值為空值，就不會輸出到 JSON 中
- 若欄位是 `bool`, `string`, `int`, `int64` 等型別，而 `tag` 中帶有 `",string"` ，該欄位在輸出到 JSON  候會將該欄位對應的值轉換成 JSON 字串

將上述特點套入範例:
```go=
type permissions map[string]bool

type user struct {
    Name     string `json:"name"`
    Password string `json:"password"`
    Age      int    `json:"age,string"`
    Permissions permissions `json:"perms,omitempty"`
}

user := []user{
    {"tom", "2332424", 20, nil},
    {"jack", "4434345", 30, permissions{"admin": true}},
}

data, err := json.Marshal(user)

if err != nil {
    fmt.Println(err)
    return
}

fmt.Println(string(data))
// output
// [{"name":"tom","password":"2332424","age":"20"},{"name":"jack","password":"4434345","age":"30","perms":{"admin":true}}]
```
觀察輸出結果，`name` 為 `tom` 的 user 因為 `perms` 被添加了 `"omitempty"` 選項，故 `perms` 沒有值輸出(西相較於上個範例的 `"perms":null` )，而 `jack` 則輸出 `perms":{"admin":true}`。

另外，`age` 原始型別為 `int` ，藉由 `",string"` 選項被轉成**字串**。

`Marshal` 函式只有在**轉換成功的時候才會回傳資料**，轉換的過程中需要注意幾點：
- JSON 物件 `key` 值只支援 `string` 型別，故編碼(encoding) 一個 `map` 型別必須是 `map[string]T` 這種型別 (補充： `T` 是 Go 語言中的**任意型別**)
- **巢狀資料**是不能編碼 JSON
- **指標**於編碼時會輸出指標指向的內容，而**空指標**則會輸出 `null`

# 解析 JSON
前面已經提到如何產生 JSON 資料，接著看如何解析 JSON 吧！
而`json` 這個 package 提供 `Unmarshal` 函式來解析 JSON。

於 `json.UnMarshal()` 方法接收的是位元組(Bytes)切片(Slice)，需先把 **JSON 字串轉換成位元組切片**

## 語法結構：
```go=
func Unmarshal(data []byte, v interface{}) error
```

### 已知 JSON 資料結構的情形下
來看段範例
```go=
type User struct {
    ID             int
    Name           string
    Money          float64
    Skills         []string
    Relationship   map[string]string
    Identification Identification
}

type Identification struct {
    Phone bool `json:"phone"`
    Email bool `json:"email"`
}

var jsonData = []byte(`{"ID":1,"Name":"Tony","Money":10.1,"Skills":["program","rich","play"],"Relationship":{"Dad":"Hulk","Mon":"Natasha"},"Identification":{"phone":true,"email":false}}`)
var user User

err := json.Unmarshal(jsonData, &user)

if err != nil {
    fmt.Println("error:", err)
}

fmt.Printf("%+v\n", user)
// {ID:1 Name:Tony Money:10.1 Skills:[program rich play] Relationship:map[Dad:Hulk Mon:Natasha] Identification:{Phone:true Email:false}}
```

### 未知 JSON 資料結構的情形下
若不知道被解析的來源 JSON 資料結構，可採用 `interface{}` 來存任意資料型別的物件。

`json` 套件採用 `map[string]interface{}` 和`[]interface{}` 結構來存放任意的 JSON 物件和陣列。

Go 型別和 JSON 型別的對應關係整理成下方資訊：
- `bool`: JSON booleans,
- `float64`: JSON numbers,
- `string`: JSON strings,
- `nil`: JSON null.

範例:
假設有如下的 JSON 資料
```go=
jsonData := []byte(`{"Name":"Eve","Age":6,"Parents":["Alice","Bob"]}`)
```
在不知其結構情況下，將其解析到 `interface{}` 裡
```go=
var v interface{}
json.Unmarshal(jsonData, &v)

jdata := v.(map[string]interface{})

fmt.Println("jdata after parsing json:  ", jdata) 
// jdata after parsing json:   map[Age:6 Name:Eve Parents:[Alice Bob]]
```
這時 f 變數裡等同存放了一個 `map` 型別，`key` 值為 `string`，值存在空的 `interface{}` 裡，同下方範例
```go=
v := map[string]interface{}{
    "Name":    "Eve",
    "Age":     6,
    "Parents": []interface{}{"Alice", "Bob"},
}
fmt.Println("v: ", v) // v:  map[Age:6 Name:Eve Parents:[Alice Bob]]
```

接著透過斷言的方式來提取 JSON 資料
### Type assertions 型態斷言
型態斷言於[官方文件](https://golang.org/ref/spec#Type_assertions)有細部說明，本篇只會些微帶過

語法結構:
```go=
x.(T)
```

```go=
jdata := v.(map[string]interface{})

fmt.Println("jdata after parsing json:  ", jdata)

// fmt.Println("jdata after parsing json:  ", jdata)
```
接著用 for loop 印出所有資料
```go=
for k, v := range jdata {
    switch v := v.(type) {
    case string:
	fmt.Println(k, v, "(string)")
    case float64:
	fmt.Println(k, v, "(float64)")
    case []interface{}:
        fmt.Println(k, "(array):")
        for i, u := range v {
            fmt.Println("    ", i, u)
        }
    default:
        fmt.Println(k, v, "(unknown)")
    }
}

// Name Eve (string)
// Age 6 (float64)
// Parents (array):
//      0 Alice
//      1 Bob
```
再來看另一個範例:
```go=
package main

import (
    "encoding/json"
    "fmt"
)

type user struct {
    Name    string    `json:"username"`
    Permissions map[string]bool `json:"perms"`
}

func main() {
    input := []byte(`
    [
        {
            "username": "inanc"
        },
        {
            "username": "god",
            "perms": {
                "admin": true
            }
        },
        {
            "username": "devil",
            "perms": {
                "write": true
            }
        }
    ]`)

    var users []user
    if err := json.Unmarshal(input, &users); err != nil {
        fmt.Println(err)
        return
    }
    fmt.Println("users: ", users) // users:  [{inanc map[]} {god map[admin:true]} {devil map[write:true]}]
    for _, user := range users {
        fmt.Print("+ ", user.Name)

        switch p := user.Permissions; {
        case p == nil:
            fmt.Print(" has no power.")
        case p["admin"]:
            fmt.Print(" is an admin.")
        case p["write"]:
            fmt.Print(" can write.")
        }
        fmt.Println()
    }
}

// users:  [{inanc map[]} {god map[admin:true]} {devil map[write:true]}]
```


### 利用 *json.RawMessage 延遲解析
有時會在解析 JSON 時才會知道其資料結構，可透過使用 `json.RawMessage` 的方式來延遲解析，讓資料以 `byte` 的形式繼續存在，等待下次解析。
```go=
package main

import (
	"encoding/json"
	"fmt"
)

type Engineer struct {
	Skill       string `json:"skill"`
	Description string `json:"description"`
}

type Manager struct {
	Experienced bool `json:"experienced"`
}

type user struct {
	Name           string          `json:"username"`
	Permissions    map[string]bool `json:"perms"`
	Role           string          `json:"role"`
	Responsibility json.RawMessage
}

func main() {
	input := []byte(`
	[
		{
			"username": "inanc",
			"role": "Engineer",
			"Responsibility":{
                "skill":"Python&Golang",
                "description":"coding"
            }
		},
		{
			"username": "god",
			"role": "Manager",
			"Responsibility":{
				"experienced": true 
            },
			"perms": {
				"admin": true
			}
		},
		{
			"username": "devil",
			"role": "Engineer",
			"Responsibility":{
                "skill":"Infra&Network",
                "description":"coding"
            },
			"perms": {
				"deploy": true
			}
		}
	]`)

	var users []user
	if err := json.Unmarshal(input, &users); err != nil {
		fmt.Println(err)
		return
	}
	// fmt.Println("users: ", users) // users:  [{inanc map[]} {god map[admin:true]} {devil map[write:true]}]
	for _, user := range users {
		fmt.Print("+ ", user.Name)

		switch r := user.Role; r {
		case "":
			fmt.Println(" has no power.")
		case "Manager":
			fmt.Println(" is an Manager.")
			var responsibility Manager
			if err := json.Unmarshal(user.Responsibility, &responsibility); err != nil {
				fmt.Println("error:", err)
			}
			fmt.Println("Manager's responsibility: ", responsibility.Experienced)
		case "Engineer":
			fmt.Println(" is an Engineer.")
			var responsibility Engineer
			if err := json.Unmarshal(user.Responsibility, &responsibility); err != nil {
				fmt.Println("error:", err)
			}
			fmt.Println("Engineer's responsibility: ", responsibility.Description)
			fmt.Println("Engineer's skill: ", responsibility.Skill)
		default:
			fmt.Println("No Role")
		}

		fmt.Println()
	}
}
```