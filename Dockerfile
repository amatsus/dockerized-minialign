FROM docker.io/alpine:3.6 AS build-env
RUN apk --update add --no-cache --virtual .build-deps build-base git zlib-dev && \
    git clone https://github.com/ocxtal/minialign.git && \
    cd minialign && \
    git checkout refs/tags/minialign-0.5.2 && \
    sed -i "s/-march=native/-msse4 -mpopcnt/" Makefile && \
    make && make install && \
    apk del .build-deps && rm -rf /minialign

FROM docker.io/alpine:3.6
LABEL maintainer="akihiro.matsushima@riken.jp" \
      license="MIT" \
      architecture="Nehalem and later"
COPY --from=build-env /usr/local/bin/minialign /usr/local/bin/minialign
ENTRYPOINT [ "/usr/local/bin/minialign" ]
CMD ["-h"]
