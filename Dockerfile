FROM ruby:2.7.8
MAINTAINER "Watermark Dev <dev@watermark.org>"

# HACK: Needed for debian to provide latest version of postgres client
RUN echo 'deb http://apt.postgresql.org/pub/repos/apt/ buster-pgdg main' > \
 /etc/apt/sources.list.d/pgdg.list
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | \
 apt-key add -

RUN apt-get update && apt-get install --fix-missing -y \
  build-essential \
  locales \
  postgresql-client-9.6 \
  nodejs

ENV BUNDLE_GEMFILE=/app/Gemfile \
  BUNDLE_JOBS=20 \
  BUNDLE_PATH=/bundle \
  BUNDLER_VERSION=2.1.4

RUN gem update --system
RUN gem install bundler:2.1.4

RUN mkdir /app

COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock

WORKDIR /app

RUN bundle install

ADD . /app
