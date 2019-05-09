FROM golang:1.12
MAINTAINER Oliver Nadj <mr.oliver.nadj@gmail.com>
ADD main.go /go/src/main.go
EXPOSE 8080
WORKDIR /go/src
ENTRYPOINT [ "go", "run", "main.go"]
