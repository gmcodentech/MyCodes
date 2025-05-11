FROM alpine-zig2:latest AS build
WORKDIR /tmp
COPY test.zig .
RUN /tmp/zig014/zig  build-exe -target x86_64-linux test.zig

FROM ubuntu:latest
WORKDIR /tmp
COPY --from=build /tmp/test . 
RUN chmod 777 ./test
CMD ["./test"]