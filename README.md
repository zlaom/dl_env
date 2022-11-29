# Dockerfile for basic deep learning environment

## Features

- cuda version 11.4.2
- miniconda3 latest
- aliyun apt source
- basic development tools `wget git tmux curl vim zip`
- oh-my-zsh with plugins `zsh-autosuggestions zsh-syntax-highlighting`
- custom password setting

## Change cuda version

if cuda version not match you drive you can change cuda version by search in [nvidia/cuda/tags](https://hub.docker.com/r/nvidia/cuda/tags)

## Auto connect

- add you ssh publice key to `authorized_keys` file
- enter root path
- run `docker build -t [image name self define] .` for example `docker build -t my_env_zsh:latest .`
- run `docker run -d --gpus all --shm-size=16G -p 1022:22 -p 1080:8080 -v /data:/data my_env_zsh:v1`
- use ssh connect to port `1022` with user `root`

## Password connect

- enter root path
- run `docker build -t [image name self define] .` for example `docker build -t my_env_zsh:latest .`
- run `docker run -d --gpus all --shm-size=16G -p 1022:22 -p 1080:8080 -v /data:/data my_env_zsh:latest`
- use ssh connect to port `1022` with user `root` and password `PHuTs9k^6D`
