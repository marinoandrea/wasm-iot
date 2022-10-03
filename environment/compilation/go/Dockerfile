FROM golang:1.19.1

# default build arguments
ARG GREENLAB_BENCHMARK_GO_REPO="marinoandrea/green-lab"
ARG GREENLAB_BENCHMARK_GO_HASH="main"
ARG GREENLAB_BENCHMARK_GO_ROOT_URL="applications/helloBenchmark/go"
ARG GREENLAB_BENCHMARK_GO_VOLUME="/var/green-lab"

ENV GOOS=js 
ENV GOARCH=wasm

WORKDIR /var/compilation

# download benchmark source code
RUN curl -o main.go https://raw.githubusercontent.com/${GREENLAB_BENCHMARK_GO_REPO}/${GREENLAB_BENCHMARK_GO_HASH}/${GREENLAB_BENCHMARK_GO_ROOT_URL}/main.go
RUN curl -o go.mod  https://raw.githubusercontent.com/${GREENLAB_BENCHMARK_GO_REPO}/${GREENLAB_BENCHMARK_GO_HASH}/${GREENLAB_BENCHMARK_GO_ROOT_URL}/go.mod
# compile Go benchmark
CMD go build -o ${GREENLAB_BENCHMARK_GO_VOLUME}/benchmark.go.wasm