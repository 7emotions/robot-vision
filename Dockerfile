FROM osrf/ros:humble-desktop AS develop

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install -y \
    wget \
    curl \
    git \
    vim \
    tmux \
    python3-pip \
    ros-humble-usb-cam \
    ros-humble-serial \
    --no-install-recommends

# OpenCV
RUN apt-get update && apt-get install -y \
    libopencv-dev \
    python3-opencv \
    --no-install-recommends

# zsh & oh-my-zsh
RUN apt-get update && apt-get install -y zsh --no-install-recommends
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/install.sh)" --insecure

RUN chsh -s /bin/zsh ros

WORKDIR /ros2_ws

ENV ROS_DOMAIN_ID=0
ENV ROS_DISTRO=humble
ENV RCUTILS_LOGGING_BUFFER_SIZE=1024
ENV RMW_IMPLEMENTATION=rmw_cyclonedds_cpp

RUN pip3 install --upgrade pip

RUN pip3 install foxglove-cli

USER ros

CMD ["bash"]


FROM osrf/ros:humble-ros-base AS runtime

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install -y \
    ros-humble-usb-cam \
    ros-humble-serial \
    libopencv-dev \
    python3-opencv \
    --no-install-recommends

RUN apt-get update && apt-get install -y python3-pip --no-install-recommends
RUN pip3 install --upgrade pip

WORKDIR /app

COPY --from=develop /ros2_ws/install /app/install

ENV ROS_DOMAIN_ID=0
ENV ROS_DISTRO=humble
ENV RCUTILS_LOGGING_BUFFER_SIZE=1024
ENV RMW_IMPLEMENTATION=rmw_cyclonedds_cpp

CMD ["bash", "-c", "source /app/install/setup.bash"]