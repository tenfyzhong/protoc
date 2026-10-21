FROM ubuntu:16.04
MAINTAINER tenfy "tenfy@tenfy.cn"

ENV PATH=$PATH:/usr/local/go/bin GOTOOLCHAIN=local GOENV=off
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates unzip curl git && \
    rm -rf /var/lib/apt/lists/*
RUN curl -fsSL -o protoc.zip https://github.com/protocolbuffers/protobuf/releases/download/v3.6.1/protoc-3.6.1-linux-x86_64.zip && \
    echo '6003de742ea3fcf703cfec1cd4a3380fd143081a2eb0e559065563496af27807  protoc.zip' | sha256sum -c - && \
    unzip protoc.zip -d protoc3 && \
    mv protoc3/bin/* /usr/local/bin/ && \
    mv protoc3/include/* /usr/local/include/ && \
    rm -rf protoc3 protoc.zip && \
    curl -fsSL -o go.tar.gz https://go.dev/dl/go1.26.10.linux-amd64.tar.gz && \
    echo 'ccfe7ae822d2c2f41f4fe7c956199967a4dac22d0ee0d2b2bfdb440aab3b20c5  go.tar.gz' | sha256sum -c - && \
    tar -C /usr/local -xzf go.tar.gz && \
    rm go.tar.gz && \
    GOPATH=/root/go go install github.com/golang/protobuf/protoc-gen-go@v1.5.4 && \
    mv /root/go/bin/protoc-gen-go /usr/local/go/bin/ && \
    go version -m /usr/local/go/bin/protoc-gen-go | grep -F ': go1.26.10' && \
    rm -rf /root/go /root/.cache/go-build && \
    mkdir /pipeline && \
    chown 777 /pipeline

ENTRYPOINT ["/usr/local/bin/protoc"]
