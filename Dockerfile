FROM ubuntu:14.04.5

RUN apt update -y \
    && apt install curl git gcc g++ make ccache -y \
    && cd home && git clone --depth=1 --branch=master https://github.com/denoland/deno.git denoland/deno \
    && cd denoland/deno && git submodule update --init --recursive \
    && export CARGO_HOME=$HOME/denoland/deno/third_party/rust_crates/ \
    && export RUSTUP_HOME=$HOME/.rustup/ \
    && export RUST_BACKTRACE=1 \
    && export CARGO_TARGET_DIR=$HOME/target \
    && export PATH=$HOME/denoland/deno/third_party/llvm-build/Release+Asserts/bin:$CARGO_HOME/bin:$PATH \
    && export RUSTC_WRAPPER=sccache \
    && export SCCACHE_BUCKET=deno-sccache \
    && export TRAVIS_COMPILER=g++ \
    && export CXX=g++ \
    && export CXX_FOR_BUILD=g++ \
    && export CC=gcc \
    && export CC_FOR_BUILD=gcc \
    && export CASHER_DIR=$HOME/denoland/deno/.casher \
    && echo 'install node.js v8' \
    && curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash - \
    && apt-get install -y nodejs build-essential \
    && curl -sSf https://sh.rustup.rs | sh -s -- -y --default-toolchain 1.30.0 \
    && rustup default 1.30.0 \
    && export PATH="`pwd`/prebuilt/linux64:$PATH" \
    && rm -rf "$RUSTUP_HOME"downloads \
    && rm -rf "$RUSTUP_HOME"tmp \
    && rm -rf "$RUSTUP_HOME"toolchains/*/etc \
    && rm -rf "$RUSTUP_HOME"toolchains/*/share \
    && ./tools/setup.py \
    && ./tools/build.py -C target/release -j2

CMD [ "/home/denoland/deno/target/debug/deno" ]
