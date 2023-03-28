FROM ruby:3.2.1

WORKDIR /app

RUN bundle config path 'vendor/bundle'
