FROM ruby:2-alpine

RUN apk --no-cache add git bash

RUN mkdir -p /app
WORKDIR /app
COPY Gemfile Gemfile.lock /app/
COPY vendor /app/vendor
RUN bundle --local
COPY . /app/

