FROM node:alpine

ARG FLOOD_VERSION=master

RUN addgroup -S flood \
 && adduser -S -G flood -s /bin/sh -h /var/lib/flood flood \
 && apk add --no-cache --update mediainfo \
 && apk add --no-cache --update --virtual .build-deps \
        build-base \
        python \
        git \
 && cd /tmp \
 && git clone -b ${FLOOD_VERSION} https://github.com/jfurrow/flood.git \
 && cp /tmp/flood/package.json /var/lib/flood/ \
 && cp /tmp/flood/package-lock.json /var/lib/flood/ \
 && cd /var/lib/flood \
 && npm install \
 && cp -r /tmp/flood/client /var/lib/flood/ \
 && cp -r /tmp/flood/shared /var/lib/flood/ \
 && cp /tmp/flood/config.docker.js /var/lib/flood/config.js \
 && npm run build \
 && npm prune --production \
 && cp -r /tmp/flood/server /var/lib/flood/ \
 && chown -R flood: /var/lib/flood \
 && mkdir /data \
 && chown -R flood: /data \
 && rm -rf /tmp/* \
 && apk del .build-deps

EXPOSE 3000

VOLUME [ "/data" ]

WORKDIR /var/lib/flood

USER flood

CMD [ "npm", "start" ]