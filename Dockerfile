FROM ruby:3.2.1
RUN mkdir /kabuol
WORKDIR /kabuol
RUN bundle config path 'vendor/bundle' && \
  bundle config set force_ruby_platform true
COPY Gemfile /kabuol/Gemfile
COPY Gemfile.lock /kabuol/Gemfile.lock
RUN bundle install
COPY . /kabuol
