package main

import (
	"database/sql"
	"encoding/base64"
	"encoding/json"
	"fmt"
	"net/http"
	"time"

	"github.com/dgrijalva/jwt-go"

	_ "github.com/go-sql-driver/mysql"
)

var db *sql.DB
var jwtKey = []byte("vecyhkjuchociib")

//User : user struct
type User struct {
	Name     string `json:"name"`
	Email    string `json:"email"`
	Password string `json:"password"`
	Country  string `json:"country"`
}

//Claims : claims for json web token
type Claims struct {
	Username string `json:"username"`
	jwt.StandardClaims
}

//ArticleResponse : result of the fetched articles
type ArticleResponse struct {
	Status       string    `json:"status"`
	TotalResults int       `json:"totalResults"`
	Articles     []Article `json:"articles"`
}

//Article : articles
type Article struct {
	Source      Source `json:"source"`
	Author      string `json:"author"`
	Title       string `json:"title"`
	Description string `json:"description"`
	Publishedat string `json:"publishedAt"`
	Content     string `json:"content"`
	Url         string `json:"url"`
	UrlToImage  string `json:"urlToImage"`
}

//Source : is the source for the aricle
type Source struct {
	Id   string `json:"id"`
	Name string `json:"name"`
}

//ResponseArticles : is the source for the aricle
type ResponseArticles struct {
	Image       string `json:"image"`
	Title       string `json:"title"`
	Description string `json:"description"`
	Url         string `json:"url"`
}

func main() {
	var err error
	db, err = sql.Open("mysql", "root@tcp(127.0.0.1:3306)/news")
	if err != nil {
		panic(err.Error())
	}
	fmt.Println("Listening on port 8080")
	http.HandleFunc("/signup", createUser)
	http.HandleFunc("/login", login)
	http.HandleFunc("/articles", getArticles)
	http.ListenAndServe(":8080", nil)
}

func base64Encode(src []byte) []byte {
	return []byte(base64.StdEncoding.EncodeToString(src))
}
func base64Decode(src []byte) ([]byte, error) {
	return base64.StdEncoding.DecodeString(string(src))
}

func createUser(w http.ResponseWriter, r *http.Request) {

	var user User
	err := json.NewDecoder(r.Body).Decode(&user)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}
	password := base64Encode([]byte(user.Password))
	_, err = db.Query("INSERT INTO users(name, email, password) VALUES ('" + user.Name + "','" + user.Email + "','" + string(password) + "');")
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		w.Write([]byte("500 - Something bad happened!"))
	}
	expirationTime := time.Now().Add(12 * time.Hour)
	claims := &Claims{
		Username: user.Name,
		StandardClaims: jwt.StandardClaims{
			ExpiresAt: expirationTime.Unix(),
		},
	}
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	tokenString, err := token.SignedString(jwtKey)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}
	fmt.Fprintf(w, tokenString)
}

func login(w http.ResponseWriter, r *http.Request) {
	var user User
	var userdb User
	err := json.NewDecoder(r.Body).Decode(&user)
	if err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}
	results, err := db.Query("SELECT name, email, password, country FROM users WHERE email = '" + user.Email + "';")
	if err != nil {
		panic(err.Error()) // proper error handling instead of panic in your app
	}
	for results.Next() {
		err = results.Scan(&userdb.Name, &userdb.Email, &userdb.Password, &userdb.Country)
		if err != nil {
			panic(err.Error()) // proper error handling instead of panic in your app
		}
	}
	password, err := base64Decode([]byte(userdb.Password))
	if err != nil {
		http.Error(w, "Not authorized", 401)
	}
	if user.Password != string(password) {
		http.Error(w, "Not authorized", 401)
		return
	}
	expirationTime := time.Now().Add(12 * time.Hour)
	claims := &Claims{
		Username: userdb.Name,
		StandardClaims: jwt.StandardClaims{
			ExpiresAt: expirationTime.Unix(),
		},
	}
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, claims)
	tokenString, err := token.SignedString(jwtKey)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		return
	}
	fmt.Fprintf(w, tokenString+";"+userdb.Name+";"+userdb.Country)
}

func getArticles(w http.ResponseWriter, r *http.Request) {
	/*token := r.Header.Get("Authorization")
	claims := &Claims{}
	tkn, err := jwt.ParseWithClaims(token, claims, func(token *jwt.Token) (interface{}, error) {
		return jwtKey, nil
	})
	if err != nil {
		w.WriteHeader(http.StatusUnauthorized)
		return
	}
	if !tkn.Valid {
		w.WriteHeader(http.StatusUnauthorized)
		return
	}
	fmt.Println(claims)*/
	var callUrl string
	keys, ok := r.URL.Query()["country"]
	if !ok || len(keys[0]) < 1 {
		callUrl = "https://newsapi.org/v2/top-headlines?country=us&apiKey=39d084dff8004ff5bb908b1feaba34de"
	} else {
		key := keys[0]
		callUrl = "https://newsapi.org/v2/top-headlines?country=" + key + "&apiKey=39d084dff8004ff5bb908b1feaba34de"
	}
	var articles ArticleResponse
	var temp ResponseArticles
	var data []ResponseArticles
	resp, err := http.Get(callUrl)
	if err != nil {
		w.WriteHeader(http.StatusUnauthorized)
		return
	}
	err = json.NewDecoder(resp.Body).Decode(&articles)
	for _, element := range articles.Articles {
		temp.Description = element.Description
		temp.Image = element.UrlToImage
		temp.Title = element.Title
		temp.Url = element.Url
		data = append(data, temp)
	}
	response, err := json.Marshal(data)
	if err != nil {
		panic(err)
	}
	fmt.Fprintf(w, string(response))
}
