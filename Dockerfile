FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Los_Angeles

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    wget \
    vim \
    git \
    build-essential \
    cmake \
    python3 \
    python3-pip \
    locales \
    sudo --fix-missing

RUN sed -i 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/install.sh)" --insecure

RUN chsh -s /bin/zsh root

RUN mkdir -p /home/dev/ros2_ws/src && \
    chown -R root:root /home/dev/ros2_ws

USER root
WORKDIR /home/dev/ros2_ws

RUN sudo apt-get update && apt-get install -y curl gnupg lsb-release
RUN sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg

RUN echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null

RUN sudo apt-get update && sudo apt-get install -y \
    ros-humble-desktop \
    ros-humble-rclcpp \
    ros-humble-rviz2 \
    ros-humble-tf2-ros \
    ros-humble-geometry2 \
    ros-humble-nav2-bringup

RUN echo "source /opt/ros/humble/setup.bash" >> ~/.zshrc
RUN echo "source /home/dev/ros2_ws/install/setup.bash" >> ~/.zshrc

RUN sudo apt-get update && sudo apt-get install -y \
    libopencv-dev \
    python3-opencv

RUN wget https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB -O intel-gpg-key.pub && \
    sudo apt-key add intel-gpg-key.pub && \
    sudo add-apt-repository "deb https://apt.repos.intel.com/openvino/latest/apt ubuntu $(lsb_release -sc) main" && \
    sudo apt-get update && sudo apt-get install -y \
    intel-openvino-runtime-dev \
    intel-openvino-dev-tools

RUN sudo apt-get update && sudo apt-get install -y libserial-dev

RUN sudo apt-get clean && rm -rf /var/lib/apt/lists/*

USER root
RUN rm -rf /tmp/* /var/tmp/*

CMD ["/bin/zsh"]