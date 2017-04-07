FROM ruby:2.3.3
MAINTAINER "Watermark Dev <dev@watermark.org>"

RUN apt-get update && apt-get install --fix-missing -y \
  build-essential \
  locales \
  postgresql-client-9.4 \
  nodejs
RUN gem install bundler

ENV BUNDLE_GEMFILE=/app/Gemfile \
  BUNDLE_JOBS=20 \
  BUNDLE_PATH=/bundle

RUN mkdir /app
ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock
RUN cd /app && bundle install --jobs 20 --retry 5 --full-index
ADD . /app

WORKDIR /app
CMD ["rspec"]
