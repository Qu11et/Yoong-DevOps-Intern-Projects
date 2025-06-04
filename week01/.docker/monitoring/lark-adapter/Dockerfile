FROM golang:1.21-alpine AS builder

WORKDIR /app

COPY main.go .

RUN go mod init lark-alertmanager-adapter && \
    go mod tidy && \
    go build -o lark-alertmanager-adapter .

FROM alpine:latest
COPY --from=builder /app/lark-alertmanager-adapter /usr/local/bin/
EXPOSE 8080
CMD ["lark-alertmanager-adapter"]