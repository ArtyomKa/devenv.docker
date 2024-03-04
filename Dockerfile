FROM debian:bookworm
RUN apt-get update && apt-get install -y --no-install-recommends \
            build-essential \
            bat \
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


#install neovim
RUN wget --show-progress --progress=dot:mega  https://github.com/neovim/neovim/archive/refs/tags/v0.9.5.tar.gz -O neovim-0.9.5.tar.gz && \
    tar xvf neovim-0.9.5.tar.gz && \
    cd /temp/neovim-0.9.5 && \
    make -j && make install && rm -rf /temp/neovim-0.9.5

#install tpm, oh-my-zsh
RUN git clone --depth 1 https://github.com/NvChad/NvChad ~/.config/nvim && \
    # rm -rf ~/.config/nvim/.git && \
    wget --show-progress --progress=dot:mega  https://github.com/tmux-plugins/tpm/archive/refs/tags/v3.1.0.tar.gz -O tpm-v3.1.0.tar.gz && \
    tar xvf tpm-v3.1.0.tar.gz && \
    mkdir -p /root/.tmux/plugins && \
    mv tpm-3.1.0 tpm && \
    mv tpm /root/.tmux/plugins && \
    sh -c "$(wget --show-progress --progress=dot:mega -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.5/zsh-in-docker.sh)"  && \
    rm *.tar.gz

    


WORKDIR /root
#echo install zsh plugin manager
RUN git clone --recurse-submodules https://github.com/ArtyomKa/dotfiles.git

#install fzf
RUN git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && \
    ~/.fzf/install --xdg --no-fish --no-bash --no-update-rc --key-bindings --completion && \
    mv ~/.config/fzf/fzf.zsh  ~/dotfiles/.oh-my-zsh/custom/

WORKDIR /root/dotfiles

RUN rm /root/.bashrc \
          /root/.zshrc \
          /root/.oh-my-zsh/custom/example.zsh \
          /root/.oh-my-zsh/custom/themes/example.zsh-theme \
    && stow . # && nvim +silent +qall

WORKDIR /root
#RUN tar czf home.tar.gz /root/ && \
##    cd /etc/skel && \
#    tar xvf /tmp/home.tar.gz -C /etc/skel/ --strip-components=1 && rm /tmp/home.tar.gz
RUN cp -RL . /etc/skel && rm -rf /etc/skel/dotfiles
WORKDIR /root
CMD ["/bin/zsh"]
# CMD ["/bin/bash"]
