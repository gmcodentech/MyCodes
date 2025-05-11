FROM alpine:latest AS web
WORKDIR /tmp
ADD http://host.docker.internal/webserver.tar.xz .
RUN tar -xjf webserver.tar.xz
RUN chmod 777 testserver



FROM scratch
COPY --from=web /tmp/testserver .
ENTRYPOINT ["./testserver"]