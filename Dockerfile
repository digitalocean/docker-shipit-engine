FROM ruby:2.6.2-alpine

RUN apk add --no-cache --update \
  build-base \
  git \
  linux-headers \
  nodejs \
  postgresql-client \
  postgresql-dev \
  sqlite-dev \
  tzdata \
  yarn

ENV CI=true
ENV SHIPIT_VERSION=v0.27.1

RUN git config --global user.email "you@example.com"
RUN git config --global user.name "Your Name"

RUN gem install rails -v 5.2 --no-document
RUN gem install minitest --no-document

WORKDIR /usr/src

RUN rails _5.2_ new shipit \
  --skip-action-cable --skip-turbolinks --skip-action-mailer --skip-active-storage \
  -m https://raw.githubusercontent.com/Shopify/shipit-engine/${SHIPIT_VERSION}/template.rb

WORKDIR /usr/src/shipit

COPY config/ config/

ENV RAILS_ENV=production \
    RAILS_LOG_TO_STDOUT=enabled \
    RAILS_SERVE_STATIC_FILES=enabled

COPY entrypoint.sh .
ENTRYPOINT ["./entrypoint.sh"]

RUN bundle exec rake assets:precompile

EXPOSE 3000

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
