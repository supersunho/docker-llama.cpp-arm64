# Stage 1: Build stage
FROM ubuntu:22.04 AS builder

# Install build dependencies including ccache
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    libssl-dev \
    ccache \
    && rm -rf /var/lib/apt/lists/*

# Set up ccache
ENV CC=ccache
ENV CXX=ccache
ENV PATH=/usr/lib/ccache:$PATH
ENV CCACHE_DIR=/ccache

WORKDIR /app

# Clone llama.cpp from official repository at specified version
ARG LLAMA_VERSION=latest
RUN if [ "$LLAMA_VERSION" = "latest" ]; then \
    git clone https://github.com/ggerganov/llama.cpp.git .; \
    else \
    git clone https://github.com/ggerganov/llama.cpp.git . --branch $LLAMA_VERSION --depth 1; \
    fi

# Build with ccache and OpenSSL support
RUN mkdir build && cd build && \
    cmake .. -DCMAKE_BUILD_TYPE=Release \
             -DBUILD_SHARED_LIBS=ON \
             -DLLAMA_OPENSSL=ON && \
    cmake --build . --config Release -j$(nproc) && \
    cmake --install . --prefix /app/install

# Stage 2: Runtime stage
FROM ubuntu:22.04

# Install runtime dependencies (libssl3 for Ubuntu 22.04)
RUN apt-get update && apt-get install -y \
    libgomp1 \
    libssl3 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy built files from builder stage (excluding ccache)
COPY --from=builder /app/install /usr/local

# Update shared library cache
RUN ldconfig

EXPOSE 8080

ENTRYPOINT ["/usr/local/bin/llama-server"]
CMD ["--host", "0.0.0.0", "--port", "8080"]
