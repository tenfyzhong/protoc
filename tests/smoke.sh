#!/usr/bin/env bash
set -euo pipefail

test "$(protoc --version)" = "libprotoc 3.6.1"
go version | grep -F 'go1.26.10 '
go version -m "$(command -v protoc-gen-go)" | grep -F ': go1.26.10'
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
cd "$work"
cat > smoke.proto <<'PROTO'
syntax = "proto3";
package smoke;
option go_package = "example.com/protocsmoke;smoke";
message Greeting { string text = 1; }
service Greeter { rpc Greet(Greeting) returns (Greeting); }
PROTO
protoc --go_out=plugins=grpc,paths=source_relative:. smoke.proto
cat > go.mod <<'MOD'
module example.com/protocsmoke

go 1.26.10

require (
  github.com/golang/protobuf v1.5.4
  google.golang.org/grpc v1.75.1
)
MOD
cat > smoke_test.go <<'GO'
package smoke

import (
    "testing"
    "github.com/golang/protobuf/proto"
)

func TestGeneratedRoundTrip(t *testing.T) {
    want := &Greeting{Text: "patched compiler"}
    data, err := proto.Marshal(want)
    if err != nil { t.Fatal(err) }
    got := new(Greeting)
    if err := proto.Unmarshal(data, got); err != nil { t.Fatal(err) }
    if !proto.Equal(want, got) { t.Fatalf("got %v, want %v", got, want) }
}
GO
go mod tidy
go test ./...
go vet ./...
