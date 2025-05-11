FROM golang
RUN mkdir /Example
WORKDIR /Example
COPY index.go .
RUN go build -o main index.go
CMD ["./main"]