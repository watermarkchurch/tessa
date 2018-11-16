FROM ruby:2.3.3
MAINTAINER "Watermark Dev <dev@watermark.org>"

# HACK: Needed for debian to provide latest version of postgres client
RUN echo 'deb http://apt.postgresql.org/pub/repos/apt/ jessie-pgdg main' > \
  /etc/apt/sources.list.d/pgdg.list
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | \
  apt-key add -

RUN apt-get update && apt-get install --fix-missing -y \
  build-essential \
  locales \
  postgresql-client-9.6 \
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
