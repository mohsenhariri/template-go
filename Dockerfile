FROM golang:1.20.2-alpine
WORKDIR /app
COPY go.mod ./
COPY go.sum ./
RUN go mod download
COPY *.go ./
COPY .env.docker ./
RUN go build -o /docker-gs-ping
EXPOSE 7000
CMD [ "/docker-gs-ping" ]
