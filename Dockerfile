FROM ruby:2.5-alpine

RUN mkdir -p /app
WORKDIR /app
COPY Gemfile Gemfile.lock /app/
COPY vendor /app/vendor
RUN bundle --local
COPY . /app/

