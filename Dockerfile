FROM centos

SHELL ["/bin/bash", "-c"]

ARG LINARO_GCC_VERSION=gcc-linaro-5.5.0-2017.10-x86_64_aarch64-elf
ARG LINARO_LIB_VERSION=sysroot-newlib-linaro-2017.10-aarch64-elf

# Fetch dependencies
RUN yum install -y wget which make file autoconf git

# Fetch toolchain
WORKDIR /root/x-tools
RUN wget https://releases.linaro.org/components/toolchain/binaries/latest-5/aarch64-elf/${LINARO_GCC_VERSION}.tar.xz
RUN tar -xvf $LINARO_GCC_VERSION.tar.xz

RUN wget https://releases.linaro.org/components/toolchain/binaries/latest-5/aarch64-elf/${LINARO_LIB_VERSION}.tar.xz
RUN tar -xvf $LINARO_LIB_VERSION.tar.xz

# Cleanup
RUN rm -rf ${LINARO_GCC_VERSION}.tar.xz
RUN rm -rf ${LINARO_LIB_VERSION}.tar.xz

# Fetch Rust
RUN curl https://sh.rustup.rs -sSf | sh -s -- --default-toolchain nightly -y
ENV PATH /root/.cargo/bin:$PATH
# RUN echo 'source $HOME/.cargo/env' >> $HOME/.bashrc

# Fetch dependencies
RUN yum install -y binutils gcc


# Fetch Xargo
RUN cargo install xargo
RUN rustup component add rust-src