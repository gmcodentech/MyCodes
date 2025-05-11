FROM alpine-zig2:latest AS build
RUN mkdir /Example
WORKDIR /Example
COPY /code/server.zig .
RUN /tmp/zig014/zig build-exe -target x86_64-linux server.zig

FROM ubuntu:latest
COPY --from=build /Example/server .
RUN chmod +x server
ENTRYPOINT ["./server"]