FROM emscripten/emsdk:3.1.23

# default build arguments
ARG GREENLAB_BENCHMARK_C_REPO="marinoandrea/green-lab"
ARG GREENLAB_BENCHMARK_C_HASH="main"
ARG GREENLAB_BENCHMARK_C_URL="applications/helloBenchmark/c/main.c"
ARG GREENLAB_BENCHMARK_C_VOLUME="/var/green-lab"

WORKDIR /var/compilation

# download benchmark source code
RUN curl -o main.c https://raw.githubusercontent.com/${GREENLAB_BENCHMARK_C_REPO}/${GREENLAB_BENCHMARK_C_HASH}/${GREENLAB_BENCHMARK_C_URL}
# compile C benchmark
CMD emcc main.c -o ${GREENLAB_BENCHMARK_C_VOLUME}/benchmark.c.wasm