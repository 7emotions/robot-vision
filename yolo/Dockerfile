FROM nvidia/cuda:12.1.1-cudnn8-devel-ubuntu22.04

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    cmake \
    git \
    wget \
    unzip \
    libgl1-mesa-glx \
    libglib2.0-0 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# PyTorch (CUDA 12.1)
RUN pip install torch torchvision torchaudio --index-url https://mirrors.aliyun.com/pypi/simple/ --trusted-host mirrors.aliyun.com

RUN pip install ultralytics

COPY . /app/.

ENV PYTHONUNBUFFERED=1

WORKDIR /app/.
