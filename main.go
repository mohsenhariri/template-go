package main

import (
	"fmt"
	"github.com/mohsenhariri/template-go/initializers"
	"net/http"
)

func main() {
	http.HandleFunc("/", handler)
	addr := fmt.Sprintf(":%s", initializers.Port)
	fmt.Printf("Listening on %s...\n", addr)
	http.ListenAndServe(addr, nil)
}

func handler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Hello, World!")
}


func init() {
	initializers.CheckEnv()
}