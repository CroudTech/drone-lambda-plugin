FROM golang as buildstage


COPY ./ /go/src/github.com/CroudTech/drone-lambda-plugin
WORKDIR /go/src/github.com/CroudTech/drone-lambda-plugin
RUN go get ./...
RUN CGO_ENABLED=0 GOOS=linux go build main.go


FROM alpine

RUN apk update && \
    apk add \
    ca-certificates && \
    rm -rf /var/cache/apk/*

ENV AWS_SDK_LOAD_CONFIG=true

RUN pwd

COPY --from=buildstage /go/src/github.com/CroudTech/drone-lambda-plugin/main /bin/

ENTRYPOINT ["/bin/main"]

