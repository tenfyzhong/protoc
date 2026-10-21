# protoc

Docker image with protoc 3.6.1 and the legacy `github.com/golang/protobuf/protoc-gen-go`
generator v1.5.4, built using Go 1.26.10. The compiler and protoc archives are SHA-256
checked before installation.

This updates the bundled Go build toolchain while preserving protoc and the generator
package family, including `plugins=grpc`. The former unpinned `go get` selected the
upstream default branch, so a unique historical generator version cannot be recovered
from this repository. The final v1.5.4 release is now pinned for reproducible builds.

Run `docker build -t protoc .`. CI builds the image, checks the embedded Go compiler
version, and generates, compiles, and round-trip tests protobuf/gRPC code. It does not
publish any image. Existing registry images need a separate rebuild and rollout.

The generator itself does not import `crypto/x509`; this is patched build tooling,
not a claim of an exposed certificate-verification path in the generator. The legacy
Ubuntu base and protoc version are deliberately unchanged by this targeted update.
