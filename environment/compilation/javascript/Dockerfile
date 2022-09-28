FROM ubuntu:22.04 

# default build arguments
ARG GREENLAB_BENCHMARK_JS_REPO="marinoandrea/green-lab"
ARG GREENLAB_BENCHMARK_JS_HASH="main"
ARG GREENLAB_BENCHMARK_JS_URL="applications/helloBenchmark/javascript/hello.js"
ARG GREENLAB_BENCHMARK_JS_VOLUME="/var/green-lab/compilation/javascript"

WORKDIR /root

# Update default packages
RUN apt-get update

# install necesary packages
RUN apt-get install -y \
    build-essential \
    curl \
    git \
    clang \
    cmake

# install rustup
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y 
ENV PATH="/root/.cargo/bin:${PATH}"
# install stable version of rust 
RUN rustup install stable && rustup default stable
# add WASM compilation target
RUN rustup target add wasm32-wasi

# install javy (JS to WASM compiler)
RUN git clone https://github.com/Shopify/javy.git 
WORKDIR /root/javy
RUN ./install-wasi-sdk.sh && make

# download benchmark source code
RUN curl -o benchmark.js https://raw.githubusercontent.com/${GREENLAB_BENCHMARK_JS_REPO}/${GREENLAB_BENCHMARK_JS_HASH}/${GREENLAB_BENCHMARK_JS_URL}
# compile JS benchmark
RUN ./target/release/javy benchmark.js -o ${GREENLAB_BENCHMARK_JS_VOLUME}/benchmark.js.wasm
