# Tags: https://hub.docker.com/r/osrf/ros/tags
FROM osrf/ros:melodic-desktop-full

# Author Information
LABEL author="Bruce Chan Jian Le <jianle001@e.ntu.edu.sg>"
LABEL maintainer="Bruce Chan Jian Le <jianle001@e.ntu.edu.sg>"
LABEL website="https://github.com/BruceChanJianLe/docker-nvidia-ubuntu-ros"
LABEL license="MIT"

# Set colorful prompt
ENV TERM xterm-256color

# Set LANG in order to display emoji
ENV LANG en_US.UTF-8

# Replace shell with bash
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Update and upgrade
RUN apt-get update -y -qq \
        && apt-get upgrade -y -qq \
        && apt-get -y autoclean -qq

# Common dependencies
RUN apt-get update -y -qq && apt-get install -y -qq vim \
        git \
        gdb \
        tmux \
        curl \
        wget \
        python3-dev \
        python3-pip \
        apt-utils \
        bash-completion

# Add a user with the same user_id as the user outside of the container
# Note that this requires a docker build argument `user_id`
ARG user_id
ENV USERNAME developer
RUN useradd -U --uid ${user_id} -ms /bin/bash $USERNAME \
    && echo "$USERNAME:$USERNAME" | chpasswd \
    && adduser $USERNAME sudo \
    && echo "$USERNAME ALL=NOPASSWD: ALL" >> /etc/sudoers.d/$USERNAME

# Commands below are run as developer user
USER $USERNAME

# Let the container starts in the developer's home folder
WORKDIR /home/$USERNAME

# Make a mounting directory
RUN mkdir -p /home/$USERNAME/docker_mount

# Setup tmux and vim
RUN curl -o ~/.tmux.conf https://raw.githubusercontent.com/BruceChanJianLe/TMUX_Setup/master/.tmux.conf \
        && curl https://raw.githubusercontent.com/imomaliev/tmux-bash-completion/master/completions/tmux > ~/.bash_completion \
        && echo "source ~/.bash_completion" >> ~/.bashrc \
        && curl -o ~/.vimrc https://raw.githubusercontent.com/BruceChanJianLe/vim/master/.vimrc \
        && git clone https://github.com/chriskempson/base16-shell.git ~/.config/base16-shell \
        && echo -e "\n# Base16 Shell" >> ~/.bashrc \
        && echo "BASE16_SHELL=\"\$HOME/.config/base16-shell/\"" >> ~/.bashrc \
        && echo "[ -n \"\$PS1\" ] && \\"  >> ~/.bashrc \
        && echo "    [ -s \"\$BASE16_SHELL/profile_helper.sh\" ] && \\"  >> ~/.bashrc \
        && echo "        eval \"\$(\"\$BASE16_SHELL/profile_helper.sh\")\"" >> ~/.bashrc

RUN mkdir -p ~/.vim/undodir \
        && curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

RUN vim +PlugInstall +qa

# Setup color prompt and git
RUN echo -e "\nparse_git_branch() {\n git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'\n}" >> ~/.bashrc \
        && echo -e "\nPS1='🐳\${debian_chroot:+(\$debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[01;31m\]\$(parse_git_branch)\[\033[00m\]\$ '" >> ~/.bashrc \
        && sed -ie 's|#    . /etc/bash_completion|. /etc/bash_completion|g' ~/.bashrc 

# Source ROS and cartographer
RUN echo -e "\nsource /opt/ros/\$ROS_DISTRO/setup.bash" >> ~/.bashrc

# Installing cartographer
RUN sudo apt-get update -y && sudo apt-get install -y python-wstool \
        python-rosdep \
        ninja-build \
        stow \
        && rosdep update \
        && mkdir -p ~/catkin_ws/src \
        && cd ~/catkin_ws \
        && wstool init src \
        && wstool merge -t src https://raw.githubusercontent.com/cartographer-project/cartographer_ros/master/cartographer_ros.rosinstall \
        && wstool update -t src \
        # Only needed for Ubuntu 16
        # && src/cartographer/scripts/install_proto3.sh \
        && rosdep install --from-paths src --ignore-src --rosdistro=${ROS_DISTRO} -y \
        && src/cartographer/scripts/install_abseil.sh \
        && source /opt/ros/${ROS_DISTRO}/setup.bash \
        && sudo apt-get remove ros-${ROS_DISTRO}-abseil-cpp -qq \
        && catkin_make_isolated --install --use-ninja

# Source Cartographer
RUN echo -e "source ~/catkin_ws/install_isolated/setup.bash" >> ~/.bashrc

# config & cleanup
RUN sudo apt-get autoclean -y -qq && \
        sudo apt-get autoremove -y -qq && \
        sudo rm -rf /var/lib/apt/lists/* /tmp/*

# Run colorful prompt
CMD ["/bin/bash", "-l" ]