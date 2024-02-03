FROM debian:bookworm
RUN apt-get update && apt-get install -y --no-install-recommends \
            build-essential \
            cmake \
            curl \
            ca-certificates \
            git \
            gettext \
            luajit \
            ninja-build \
            unzip \
            wget \
            zsh \
            && apt-get clean \
            && rm -rf /var/lib/apt/lists/*
WORKDIR /temp
RUN git clone -b v0.9.5 --depth=1 https://github.com/neovim/neovim.git 
WORKDIR /temp/neovim
RUN make -j && make install && rm -rf /temp/neovim
WORKDIR /temp
RUN sh -c "$(wget --show-progress --progress=dot:mega -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.5/zsh-in-docker.sh)"

CMD ["/bin/zsh"]
