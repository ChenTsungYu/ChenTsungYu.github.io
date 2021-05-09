---
title: "[Go] Struct(結構) 基礎"
catalog: true
date: 2020/01/15 20:23:10
tags: Go
categories: Backend
toc: true
---
<!-- toc -->
# 前言
在 Go 語言中，提供了像 `struct` 這樣的**複合式型別**，先前幾篇文章裡，範例中的變數都是存單一的值，若想用變數表示較複雜的概念，例如： 建立一個自訂型別 `Person` 表一個人的實體。

這個實體擁有其屬性：**姓名(name)**、**性別**和**年齡(age)** ，對照現實世界的實體都可以使用結構表示，而範例包含已命名**欄位&屬性**，將相關資料分組在一起形成**一個單位**。
<!--more-->
Go 語言使用 `type` 定義一新型別
根據前面提及的範例轉換成程式碼如下：
```go=
// 定義一個 Person 實例
// 未簡化
type Person struct {
    Name string
    Gender string
    Age    int
}

// 針對同資料型別的欄位進行簡化
type Person struct {
    Name, Gender string
    Age    int
}
```

# struct 的宣告和初始化 
## 宣告 struct
前面已經有初步示範如何定義一個 `struct` 結構，而宣告 struct 型別跟一般變數一樣
```go=
var p Person // p 現在為 Person 型別的變數
```
`struct` 預設值為**零**。對於 `struct` 來說，零表所有欄位均設定為其對應的零值。以上述定義好的 `Person` 舉例，欄位 Name 和 Gender 因型別為 `string` ，故預設值為 `""`，而 `Age` 型別為 `int` ，故預設為 `0`。

```go=
var s Person
fmt.Println("Person s: ", s) // Person s:  {  0}
s.Age = 22
s.Name = "Jack"
fmt.Println("Person s: ", s) // Person s:  {Jack  22}
```
## 初始化 struct
我們可以在初始化時給值
```go=
p := Person{"Tom", "Male", 25}
// 存取 p 的 name 屬性
fmt.Printf("The person's name is %s , gender is %s , age is %d\n", p.Name, p.Gender, p.Age) 
// The person's name is Tom , gender is Male , age is 25
```

需注意的是： **不能僅初始化一部分欄位**
```go=
var p = Person{"Tom"} // Compiler Error: too few values in struct initializer
```

### 初始化 struct 時對欄位命名 (無換行符號分隔多個欄位)
透過 `field:value` 的方式初始化 `struct`，這樣欄位順序就無關緊要。
將上個範例加上欄位命名做改寫：
```go=
p := Person{Age: 25, Name: "Tom", Gender: "Male"}
// 存取 p 的 name 屬性
fmt.Printf("The person's name is %s , gender is %s , age is %d\n", p.Name, p.Gender, p.Age) 
// The person's name is Tom , gender is Male , age is 25
```
比較兩者的輸出結果並無差異。

### 初始化 struct 時對欄位命名 (有換行符號分隔多個欄位)
為提高可讀性，可以用換行符號分隔多個欄位，需注意該情形下**必須以逗號結尾**
```go=
p := Person{
    Age: 25, 
    Name: "Tom", 
    Gender: "Male",
}
```

#### 僅初始化一部分欄位
採用欄位命名來初始化 `struct` 允許**只有初始化一部分欄位**，其他未初始化的欄位均設定為其**對應的零值**
```go=
p := Person{
    Age: 25,
}

fmt.Printf("The person's name is %s , gender is %s , age is %d\n", p.Name, p.Gender, p.Age) 
// The person's name is  , gender is  , age is 25
```

## 存取 struct 的欄位
對 struct 結構使用點 `.` 來存取 `struct` 的各個欄位所對應的值，也可以做賦值
```go=
type VideoGame struct {
    Title, Genre string
    Published    bool
}

pacman := VideoGame{
    Title:     "Pac-Man",
    Genre:     "Arcade Game",
    Published: true,
}

fmt.Printf("pacman: %+v\n", pacman) // pacman: {Title:Pac-Man Genre:Arcade Game Published:true}
fmt.Println("VideoGame Title: ", pacman.Title) // VideoGame Title:  Pac-Man
fmt.Println("VideoGame Genre: ", pacman.Genre) // VideoGame Genre:  Arcade Game

// assgin 新的值給 Published 欄位
pacman.Published = false
fmt.Println("VideoGame: ", pacman) 
// VideoGame:  {Pac-Man Arcade Game false}
```

### 傳遞 struct： 值型別
`struct` 本身是值型別，若將一個 `struct` 的變數 assign 給另一個變數時，會複製原有的`struct` 變數且分派給一個新的 `struct` 。

同樣地，將 `struct` 傳遞給另一個函數時，該函數將取得複製後的 `struct`。

```go=
type Point struct {
    X, Y int
}

p1 := Point{10, 20}
p2 := p1 // 複製 p1 的 struct 結構給 p2
fmt.Println("p1 = ", p1) // p1 =  {10 20}
fmt.Println("p2 = ", p2) // p2 =  {10 20}

p2.X = 15
fmt.Println("\n =========== After modifying p2 ===========")
fmt.Println("p1 = ", p1) // p1 =  {10 20}
fmt.Println("p2 = ", p2) // p2 =  {15 20}
```

### 傳遞 struct： 指向 struct 的指標(pointer)
Go 允許透過**指標**直接存取 `struct` 的欄位，使用 `&` 符號取得指向 `struct` 的**指標**

```go=
type Rental struct {
    Address            string
    Rooms, Size, Price int
}

r := Rental{
    Address: "Taipei",
    Rooms:   111,
    Size:    222,
    Price:   9999,
}

r1 := &r

fmt.Printf("r1: %+v\n", r1) // r1: &{Address:Taipei Rooms:111 Size:222 Price:9999}

fmt.Printf("r1 with *: %+v\n", *r1) // r1 with *: {Address:Taipei Rooms:111 Size:222 Price:9999}

// ===============

fmt.Printf("with * -> Address: %s ; Price: %d ; Rooms:  %d ;  Size: %d \n", (*r1).Address, (*r1).Price, (*r1).Rooms, (*r1).Size) // with * -> Address: Taipei ; Price: 9999 ; Rooms:  111 ;  Size: 222

// 與上面相同
// r1.Address 等同於 (*r1).Address -> 以此類推
fmt.Printf("Address: %s ; Price: %d ; Rooms:  %d ;  Size: %d \n", r1.Address, r1.Price, r1.Rooms, r1.Size)
// Address: Taipei ; Price: 9999 ; Rooms:  111 ;  Size: 222 
```

### 有無使用指摽(pointer) 傳遞 struct 的差異
> 若指定或傳遞 `struct` 結構時，並非想要複製值域，可以使用指標

## new() 函數建立 struct 
使用 Go 的 `new()` 函數來建立 `struct` 的實例。`new()` 函數分配足夠的記憶體來符合所有的 `struct` 欄位，各自設為**零值**，回傳指派新的 `struct` 的指標
```go=
type Point struct {
    X, Y int
}
// 建立Point 的 struct 實例
p3 := new(Point) //  此處 p3 的型別為*Point

fmt.Println("p3: ", *p3) // p3:  {0 0}

p3.X = 1
p3.Y = 3
fmt.Println("p3: ", *p3) // p3: {1 3}
```

## struct 的匿名欄位
若匿名欄位為一個 `struct` 的時候，該 `struct` 所有欄位都會跟著(隱性)被引入當前定義的另一個 `struct`

```go=
type Human struct {
    Name     string
    Age, Weight int
}

type Student struct {
    Human  // 匿名欄位，Student 預設會包含 Human 下的所有欄位
    speciality string
}

// 初始化一個學生
tom := Student{Human{"Tom", 25, 120}, "Computer Science"}

// ===== 存取相應的欄位 =====

fmt.Println("His name is ", tom.Name)             // His name is  Tom
fmt.Println("His age is ", tom.Age)               // His age is  25
fmt.Println("His weight is ", tom.Weight)         // His weight is  120
fmt.Println("His speciality is ", tom.speciality) //His speciality is  Computer Science

//  ===== 修改欄位相應的值 =====

// 修改主修科目
tom.speciality = "Finance"
fmt.Println("Tom changed his speciality")
fmt.Println("His speciality is ", tom.speciality) // His speciality is  Finance
// 修改年齡
fmt.Println("Tom become old")
tom.Age = 46
fmt.Println("His age is", tom.Age) // His age is 46
// 修改體重
fmt.Println("Tom is not an athlet anymore")
tom.Weight += 60
fmt.Println("His weight is", tom.Weight) // His weight is 180
```
由上述範例可知，`Student` 組合了 `Human struct` 和 `string` 這些基本型別，實現欄位的繼承。

值得注意的是：
> 若繼承與被繼承的 struct 發生欄位欄位名稱衝突(field names conflict)，以較上層的 struct 優先次序較高

另外，`Student` 亦可存取 `Human` 這個欄位作為欄位名
```go=
tom.Human = Human{"Marcus", 30, 70} 
tom.Human.Age -= 1
fmt.Println("tom.Age: ", tom.Age) // tom.Age:  29
```

除 `struct` 欄位之外，所有的**內建型別**和**自訂型別**都可以作為匿名欄位

```go=
type Human struct {
    name        string
    age, weight int
}

type Student struct {
    Human      // 匿名欄位，struct
    Skills     // 匿名欄位，自訂的型別 string slice
    int        // 內建型別 int 作為匿名欄位
    speciality string
}

// 初始化學生 Jenny
jenny := Student{Human: Human{"Jenny", 35, 50}, speciality: "Biology"}
// 存取相應的欄位
fmt.Println("Her name is ", jenny.name)             // Her name is  Jenny
fmt.Println("Her age is ", jenny.age)               // Her age is  35
fmt.Println("Her weight is ", jenny.weight)         // Her weight is  50
fmt.Println("Her speciality is ", jenny.speciality) // Her speciality is  Biology
// 修改 skill 技能欄位
jenny.Skills = []string{"anatomy"}
fmt.Println("Her skills are ", jenny.Skills) // Her skills are  [anatomy]
jenny.Skills = append(jenny.Skills, "pyhon", "golang")
fmt.Println("Her skills now are ", jenny.Skills) // Her skills now are  [anatomy pyhon golang]
// 修改匿名內建型別欄位前， int 預設初始值為 0
fmt.Println("Her preferred number is", jenny.int) // Her preferred number is 0
// 修改匿名內建型別欄位後
jenny.int = 3
fmt.Println("Her preferred number is", jenny.int) // Her preferred number is 3
```
透過上述範例可知， `struct` 既可以將 `struct` 作為匿名欄位，**自訂型別**、**內建型別**都可以作為匿名欄位，還能於對應的欄位上面做函式操作（如例子中的 `append()`）

## struct 的比較
若兩個 `struct` 變數的所有對應欄位都相等，則兩者相等
```go=
type Point struct {
    X, Y int
}

p1 := Point{3, 4}
p2 := Point{3, 4}

if p1 == p2 {
    fmt.Println("p1 and p2 相等")
} else {
    fmt.Println("p1 and p2 不相等")
}

// output: p1 and p2 相等
```

## 匯出 struct 和 struct 欄位
在 Go 設計的規則中，有幾個是一定要知道的:
- 大寫字母開頭的變數、函式、`struct` 型別和 `struct` 欄位都是**可匯出**的，可供外部的 package 中存取 -> **公有變數**
- 反之小寫字母開頭的變數、函式是**不可匯出**的，僅能在同一 package 中可見 -> **私有變數**

# Ref
- [Golang - Pointer, Structs, Methods](https://mgleon08.github.io/blog/2018/05/08/golang-pointer-structs-methods/#nested_structs)
- [使用 Golang 打造 Web 應用程式 - struct](https://willh.gitbook.io/build-web-application-with-golang-zhtw/02.0/02.4)
- [Golang struct 教學與範例](https://calvertyang.github.io/2019/11/15/golang-structs-tutorial-with-examples/)
- [Golang 結構入門](https://openhome.cc/Gossip/Go/Struct.html)
- [golang 傳值、傳指標 觀點](https://medium.com/caesars-study-review-on-web-development/golang-%E5%82%B3%E5%80%BC-%E5%82%B3%E6%8C%87%E6%A8%99-%E8%A7%80%E9%BB%9E-20bcdd42169a)
