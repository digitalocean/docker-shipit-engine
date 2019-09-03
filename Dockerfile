FROM ruby:2.6.4-alpine3.10@sha256:f3eeb2b71ae7c004ca57ddb12618fde07dece33e6a0f0a50b53f03b83be76174

RUN apk add --no-cache --update \
    git \
    nodejs \
    postgresql-client \
    tzdata \
    yarn \
    && apk add --no-cache --virtual .build-deps \
      build-base \
      postgresql-dev \
      sqlite-dev

ENV CI=true
ENV SHIPIT_VERSION=v0.28.0

RUN git config --global user.email "you@example.com"
RUN git config --global user.name "Your Name"

RUN gem install rails -v 5.2 --no-document
RUN gem install minitest --no-document

WORKDIR /usr/src

RUN rails _5.2_ new shipit \
  --skip-action-cable --skip-turbolinks --skip-action-mailer --skip-active-storage \
  -m https://raw.githubusercontent.com/Shopify/shipit-engine/${SHIPIT_VERSION}/template.rb

RUN apk del .build-deps

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
