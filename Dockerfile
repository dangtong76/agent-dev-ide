# agent-ai-ide 1.0
FROM linuxserver/code-server:latest

# ENV for Code-server (VSCode)
ENV TZ="Asia/Seoul" \
    PUID=0 \
    PGID=1000 \
    DEBIAN_FRONTEND=noninteractive \
    PATH="/config/.local/bin:${PATH}"

# Make DIR for code-server
RUN mkdir /code && chown 1000:1000 /code

# Update & Install the packages
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    pkg-config \
    libcurl4-openssl-dev \
    clang \
    cmake \
    git \
    ca-certificates \
    curl \
    gnupg \
    software-properties-common \
    wget \
    unzip \
    apt-transport-https \
    telnet \
    net-tools \
    vim \
    iputils-ping \
    openjdk-17-jdk \
    python3 \
    python3-pip \
    python3-venv \
    gh \
    golang \
    nodejs \
    npm && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/apt/archives/*

# Python 소프트링크 설정
RUN ln -sf /usr/bin/python3 /usr/bin/python

# uv 설치
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# ollama 설치
RUN curl -fsSL https://ollama.com/install.sh | sh

# Llama cpp 설치
WORKDIR /opt
RUN git clone https://github.com/ggerganov/llama.cpp.git
WORKDIR /opt/llama.cpp
RUN cmake -B build -S . -DGGML_CPU=ON && cmake --build build -j"$(nproc)"
RUN mkdir -p /models


# Jupyter and ipython kernel  설치
RUN pip install --no-cache-dir --break-system-packages jupyter ipykernel ipython

# ENV for JDK
# ENV JAVA_HOME="/usr/lib/jvm/java-17-openjdk-arm64"
# ENV PATH="${JAVA_HOME}/bin:${PATH}"
# JDK 17 환경 설정 (리눅스 컨테이너용)
ENV JAVA_HOME="/usr/lib/jvm/java-17-openjdk-$(dpkg --print-architecture)"
ENV PATH="${JAVA_HOME}/bin:${PATH}"

# 아키텍처별 Docker 설치
RUN if [ "$(uname -m)" = "aarch64" ]; then \
        ARCH=arm64; \
    else \
        ARCH=amd64; \
    fi && \
    apt-get update && \
    install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc && \
    chmod a+r /etc/apt/keyrings/docker.asc && \
    echo "deb [arch=${ARCH} signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && \
    apt-get install -y docker-ce docker-ce-cli && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/cache/apt/archives/*
