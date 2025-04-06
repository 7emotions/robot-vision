FROM nvidia/cuda:12.1.1-cudnn8-devel-ubuntu22.04

WORKDIR /app

# 安装基本依赖
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

# 设置 Python 软链接 (如果需要)
# RUN ln -s /usr/bin/python3 /usr/bin/python
# RUN ln -s /usr/bin/pip3 /usr/bin/pip

# 安装 PyTorch (CUDA 12.1)
RUN pip install torch torchvision torchaudio --index-url https://mirrors.aliyun.com/pypi/simple/ --trusted-host mirrors.aliyun.com

# 安装 ultralytics
RUN pip install ultralytics

# 复制你的项目代码和数据
COPY . /app/.

# 设置环境变量
ENV PYTHONUNBUFFERED=1

# 定义工作目录 (根据你的项目结构调整)
WORKDIR /app/.

# 训练命令示例 (使用 ultralytics CLI)
# CMD yolo train model=yolov10s.yaml data=your_data.yaml epochs=100