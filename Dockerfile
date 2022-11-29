FROM nvidia/cuda:11.4.2-runtime-ubuntu20.04

ENV DEBIAN_FRONTEND noninteractive

ARG SSH_CONFIG_FILE=/etc/ssh/sshd_config
ARG SSH_PASSWD=PHuTs9k^6D

# fix nvidia GPG key erro
RUN  rm /etc/apt/sources.list.d/cuda.list

# change ubuntu sources
RUN  sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list
RUN  apt-get clean
RUN apt-get update

# apt
RUN apt-get install -y --no-install-recommends apt-utils \
  wget \
  vim \
  git \
  curl \
  locales \
  zsh \
  zip \
  tmux \
  inetutils-ping \
  openssh-server

RUN locale-gen en_US.UTF-8

# oh-my-zsh
RUN sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && \
  chsh -s /usr/bin/zsh && \
  echo "export LC_CTYPE=en_US.UTF-8" >> ~/.zshrc

# oh-my-zsh plugins
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions && \
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting && \
  sed -i -E 's/^plugins=\(.*/plugins=(git z zsh-autosuggestions zsh-syntax-highlighting)/g' ~/.zshrc

# ssh key
RUN mkdir -p ~/.ssh/
COPY authorized_keys /root/.ssh/

# ssh 
RUN sed -i -E 's/.*PermitRootLogin .*/PermitRootLogin yes/g' ${SSH_CONFIG_FILE} \
  && sed -i -E 's/.*PubkeyAuthentication .*/PubkeyAuthentication yes/g' ${SSH_CONFIG_FILE} \
  && sed -i -E 's/.*AuthorizedKeysFile .*/AuthorizedKeysFile  %h\/.ssh\/authorized_keys/g' ${SSH_CONFIG_FILE} \
  && echo "root:${SSH_PASSWD}" | chpasswd \
  && /etc/init.d/ssh start

# conda
RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
  /usr/bin/zsh ~/miniconda.sh -b -p /opt/conda && \
  rm ~/miniconda.sh && \
  ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
  echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.zshrc && \
  echo "conda activate base" >> ~/.zshrc

RUN ln -s /data /root/workspace

WORKDIR /root/workspace
ENTRYPOINT  /usr/sbin/sshd -D
CMD  /usr/sbin/sshd -D