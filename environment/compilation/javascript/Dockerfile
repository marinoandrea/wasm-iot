FROM ubuntu:22.04

WORKDIR /var

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
WORKDIR /var/javy
RUN ./install-wasi-sdk.sh && make
