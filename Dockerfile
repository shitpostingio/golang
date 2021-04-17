# Shitposting custom golang docker image

# Pull from our tdlib debian base image
FROM ghcr.io/shitpostingio/tdlib:latest

ENV GOLANG_VERSION 1.16.3
ENV goRelArch linux-amd64
ENV goRelSha256 951a3c7c6ce4e56ad883f97d9db74d3d6d80d5fec77455c6ada6c1f7ac4776d2

# Utils
RUN apt-get update && apt-get install -y -qq \
    wget \
    openssl \
    ca-certificates \
    git \
    sshpass \
	# gcc for cgo
	g++ \
	gcc \
	libc6-dev \
	make \
	pkg-config

# Install go
RUN set -eux; \
    url="https://golang.org/dl/go${GOLANG_VERSION}.${goRelArch}.tar.gz"; \
	wget -O go.tgz "$url"; \
	echo "${goRelSha256} go.tgz" | sha256sum -c -; \
	tar -C /usr/local -xzf go.tgz; \
	rm go.tgz; \
    export PATH="/usr/local/go/bin:$PATH";

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 777 "$GOPATH"
WORKDIR $GOPATH

# Clean up all the mess done by installing stuff
RUN apt-get clean \
    && apt-get autoclean \
    && echo -n > /var/lib/apt/extended_states \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /usr/share/man/?? \
    && rm -rf /usr/share/man/??_*
