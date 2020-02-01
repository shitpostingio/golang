# Shitposting custom golang docker image

# Pull from our tdlib debian base image
FROM registry.gitlab.com/shitposting/tdlib:latest

ENV GOLANG_VERSION 1.13.7
ENV goRelArch linux-amd64
ENV goRelSha256 b3dd4bd781a0271b33168e627f7f43886b4c5d1c794a4015abf34e99c6526ca3

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
