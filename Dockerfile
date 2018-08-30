FROM alpine:3.8

ENV DENO_VERSION 0.1.1

RUN addgroup -g 1000 deno \
    && adduser -u 1000 -G deno -s /bin/sh -D deno \
    && apk add --no-cache --virtual .build-deps \
        curl \
    && curl -fsSLO --compressed "https://github.com/denoland/deno/releases/download/v$DENO_VERSION/deno_linux_x64.gz" \
    && gunzip -c "deno_linux_x64.gz" > deno \
    && chmod u+x deno \
    && mv ./deno /usr/local/bin/deno \
    && ln -s /usr/local/bin/deno /bin/deno \
    && apk del .build-deps \
    && rm deno_linux_x64.gz

CMD [ "deno" ]
