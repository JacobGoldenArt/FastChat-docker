FROM nvidia/cuda:12.0.0-cudnn8-runtime-ubuntu22.04

ARG FASTCHAT_VERSION="main"

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    apt-get update ; \
    apt-get upgrade -y ; \
    apt-get install -y git python3-dev python3-pip

RUN pip3 install --upgrade pip

RUN git clone -b "$FASTCHAT_VERSION" --depth 1 https://github.com/lm-sys/FastChat fastchat

WORKDIR /fastchat
RUN pip3 install .

# Added block to install GPTQ-for-LLaMa
RUN git clone https://github.com/qwopqwop200/GPTQ-for-LLaMa.git /fastchat/repositories/GPTQ-for-LLaMa && \
    cd /fastchat/repositories/GPTQ-for-LLaMa && \
    git switch fastest-inference-4bit && \
    python3 setup_cuda.py install && \
    pip3 install texttable

COPY entrypoint.sh .
RUN chmod +x entrypoint.sh
