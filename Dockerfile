FROM debian:bookworm
RUN apt-get update && apt-get install -y --no-install-recommends \
            build-essential \
            cmake \
            curl \
            ca-certificates \
            git \
            gettext \
            luajit \
            npm \
            mc \
            ninja-build \
            python3 \
            python3-dev \
            python3-pip \
            python3-venv \
            ripgrep \
            tmux \
            stow \
            unzip \
            wget \
            zsh \
            && apt-get clean \
            && rm -rf /var/lib/apt/lists/*
WORKDIR /temp
RUN git clone -b v0.9.5 --depth=1 https://github.com/neovim/neovim.git 
WORKDIR /temp/neovim
RUN make -j && make install && rm -rf /temp/neovim

RUN touch test.txt
RUN sh -c "$(wget --show-progress --progress=dot:mega -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.5/zsh-in-docker.sh)"

WORKDIR /root
#echo install zsh plugin manager
RUN git clone --recurse-submodules https://github.com/ArtyomKa/dotfiles.git

WORKDIR /root/dotfiles

# RUN git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1 && rm /root/.bashrc /root/.zshrc && stow . && nvim +silent +qall
RUN git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1 \
    && rm /root/.bashrc \
          /root/.zshrc \
          /root/.oh-my-zsh/custom/example.zsh \
          /root/.oh-my-zsh/custom/themes/example.zsh-theme \
    && stow . && nvim +silent +qall

WORKDIR /tmp
RUN tar czf home.tar.gz /root/
WORKDIR /etc/skel
RUN tar xvf /tmp/home.tar.gz --strip-components=1 && rm /tmp/home.tar.gz

WORKDIR /root
CMD ["/bin/zsh"]
# CMD ["/bin/bash"]
