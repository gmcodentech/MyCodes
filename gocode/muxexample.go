package main

import (
	"fmt"
	"encoding/json"
	"net/http"
)

type Book struct{
	Title string
	Price float32
	Pages uint32
}

func GetRoutes() *http.ServeMux{
	mux := http.NewServeMux()
	mux.HandleFunc("/",welcome)
	mux.HandleFunc("/books",getBooks)
	return mux
}

func welcome(w http.ResponseWriter,r *http.Request){
	w.Write([]byte("Welcome to my site"))
}

func getBooks(w http.ResponseWriter,r *http.Request){
	w.Header().Set("Content-Type","application/json")
	list := []Book{
		Book{Title:"PHP",Price:100.4,Pages:90},
		Book{Title:".Net",Price:89.4,Pages:545},
		Book{Title:"Java",Price:81.4,Pages:980},
	}
	
	json.NewEncoder(w).Encode(list);
}

func main(){	
	
	serv := &http.Server{
		Handler : GetRoutes(),
		Addr:":3000",
		
	}
	fmt.Println("started listening on 3000");
	serv.ListenAndServe();
}