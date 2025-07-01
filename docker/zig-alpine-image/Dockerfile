FROM alpine:latest AS zig-build
RUN mkdir zig
WORKDIR /zig
RUN apk update && apk upgrade && apk add curl \
    && curl https://ziglang.org/download/0.14.1/zig-x86_64-linux-0.14.1.tar.xz --output zig0.14.tar.xz \
	&& tar -xJf zig0.14.tar.xz
CMD ["/bin/ash"]

FROM alpine:latest
RUN mkdir zig0.14
WORKDIR /
COPY --from=zig-build /zig/zig-x86_64-linux-0.14.1 /zig0.14
ENV PATH="$PATH:/zig0.14"
CMD ["/bin/ash"]