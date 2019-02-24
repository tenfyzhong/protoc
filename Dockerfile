FROM ubuntu:16.04
MAINTAINER tenfy "tenfy@tenfy.cn"

ENV PATH=$PATH:/usr/local/go/bin
RUN apt update && apt install -y unzip curl git && apt clean
RUN curl -OL https://github.com/google/protobuf/releases/download/v3.6.1/protoc-3.6.1-linux-x86_64.zip && \
        unzip protoc-3.6.1-linux-x86_64.zip -d protoc3 && \
        mv protoc3/bin/* /usr/local/bin/ && \
        mv protoc3/include/* /usr/local/include/ && \
        rm -rf protoc3 && \
        curl -OL https://dl.google.com/go/go1.8.linux-amd64.tar.gz && \
        export GOPATH=/root/go && \
        mkdir -p $GOPATH/bin && \
        tar -C /usr/local -xzf go1.8.linux-amd64.tar.gz && \
        go get -v github.com/golang/protobuf/protoc-gen-go && \
        go build github.com/golang/protobuf/protoc-gen-go && \
        go install github.com/golang/protobuf/protoc-gen-go && \
        mv $GOPATH/bin/* /usr/local/go/bin/ && \
        rm -rf $GOPATH && \
        mkdir /pipeline && \
        chown 777 /pipeline

ENTRYPOINT ["/usr/local/bin/protoc"]
