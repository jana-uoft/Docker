FROM node:12-alpine

RUN apk add --update && \
  npm install --global \
    eslint \
    prettier 
