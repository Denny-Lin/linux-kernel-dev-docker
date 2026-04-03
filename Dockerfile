FROM --platform=linux/arm64 ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    git \
    build-essential \
    libncurses-dev \
    flex \
    bison \
    openssl \
    libssl-dev \
    dkms \
    libelf-dev \
    libudev-dev \
    libpci-dev \
    libiberty-dev \
    autoconf \
    bc \
    rsync \
    vim \
    git-email \
    python3 \
    python3-pip \
    kmod \
    cpio \
    wget \
    curl \
    file \
    gcc-x86-64-linux-gnu \
    && pip3 install --no-cache-dir ply GitPython \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /linux-kernel