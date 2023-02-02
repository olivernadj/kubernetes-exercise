package main
import (
	"log"
	"net/http"
)
func EchoHandler(writer http.ResponseWriter, request *http.Request) {
	request.Write(writer)
	writer.Write([]byte("\nGreetings from coderschool.vn V1.0\n"))
}
func main() {
	log.Println("starting server, listening on port 8080")
	http.HandleFunc("/", EchoHandler)
	http.ListenAndServe(":8080", nil)
}
