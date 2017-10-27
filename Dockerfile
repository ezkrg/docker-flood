FROM node:alpine

ARG FLOOD_VERSION=1.0.0

RUN apk add --no-cache --update --virtual .build-deps git \
 && git clone -b v${FLOOD_VERSION} https://github.com/jfurrow/flood.git \
 && cd flood \
 && npm install --production \
 && npm cache clean --force \
 && cp config.docker.js config.js \
 && apk del .build-deps

EXPOSE 3000

WORKDIR /flood

CMD [ "npm", "start" ]