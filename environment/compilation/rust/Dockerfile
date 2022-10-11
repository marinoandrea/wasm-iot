FROM rust:1.64.0

# default build arguments
ARG GREENLAB_BENCHMARK_RUST_REPO="marinoandrea/green-lab"
ARG GREENLAB_BENCHMARK_RUST_HASH="main"
ARG GREENLAB_BENCHMARK_RUST_ROOT_URL="applications/helloBenchmark/rust"
ARG GREENLAB_BENCHMARK_RUST_VOLUME="/var/green-lab"

RUN rustup target add wasm32-wasi

WORKDIR /var/compilation

# download benchmark source code
RUN mkdir src
RUN curl -o src/main.rs https://raw.githubusercontent.com/${GREENLAB_BENCHMARK_RUST_REPO}/${GREENLAB_BENCHMARK_RUST_HASH}/${GREENLAB_BENCHMARK_RUST_ROOT_URL}/src/main.rs
RUN curl -o Cargo.toml  https://raw.githubusercontent.com/${GREENLAB_BENCHMARK_RUST_REPO}/${GREENLAB_BENCHMARK_RUST_HASH}/${GREENLAB_BENCHMARK_RUST_ROOT_URL}/Cargo.toml
# compile Rust benchmark
CMD cargo build --target wasm32-wasi --release && \
    mv ./target/wasm32-wasi/release/rust.wasm ${GREENLAB_BENCHMARK_RUST_VOLUME}/benchmark.rust.wasm 