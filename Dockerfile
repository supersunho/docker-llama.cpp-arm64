# Stage 1: Build stage
FROM ubuntu:22.04 AS builder

# Install build dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Clone llama.cpp from official repository
RUN git clone https://github.com/ggerganov/llama.cpp.git .

# Build with OpenSSL support
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

# Copy built files from builder stage
COPY --from=builder /app/install /usr/local

# Update shared library cache
RUN ldconfig

EXPOSE 8080

ENTRYPOINT ["/usr/local/bin/llama-server"]
CMD ["--host", "0.0.0.0", "--port", "8080"]
