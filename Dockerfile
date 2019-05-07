FROM touchbistro/alpine-ruby:2.6.2-build as aller

ARG github_key=null

RUN mkdir /root/.ssh && \
  git config --global user.email "devops+githubrelease@touchbistro.com" && \
  git config --global user.name "tb-releases" && \
  echo "$github_key" | base64 -d > /root/.ssh/tb-releases.key && \
  chmod 600 /root/.ssh/tb-releases.key && \
  echo 'github.com ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ== \
  bitbucket.org ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAubiN81eDcafrgMeLzaFPsw2kNvEcqTKl/VqLat/MaB33pZy0y3rJZtnqwR2qOOvbwKZYKiEO1O6VqNEBxKvJJelCq0dTXWT5pbO2gDXC6h6QDXCaHo6pOHGPUy+YBaGQRGuSusMEASYiWunYN0vCAI8QaXnWMXNMdFP3jHAJH0eDsoiGnLPBlBp4TNm6rYI74nMzgz3B9IikW4WVK+dc8KZJZWYjAuORU3jc1c/NPskD2ASinf8v3xnfXeukU0sJ5N6m5E8VLjObPEO+mN2t/FZTMZLiFqPWc/ALSqnMnnhwrNi2rbfg/rd/IpL8Le3pSBne8+seeFVBoGqzHM9yXw==' >> /root/.ssh/known_hosts && \
  eval `ssh-agent -s` && \
  ssh-add -D && \
  ssh-add  /root/.ssh/tb-releases.key && \ 
  pip3 install git+ssh://git@github.com/TouchBistro/aller.git@master#egg=aller && \
  rm -rf /root/.ssh/

FROM touchbistro/alpine-ruby:2.6.2-build as release

COPY --from=aller /usr/bin /usr/bin
COPY --from=aller /usr/lib /usr/lib

RUN apk add --no-cache --update \
    postgresql-client \
    tzdata \
    && apk add --no-cache --virtual .build-deps \
      build-base \
      postgresql-dev \
      sqlite-dev

ENV CI=true
ENV SHIPIT_VERSION=v0.27.1

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

COPY lib/tasks/cronfix.rake lib/tasks/cronfix.rake

RUN bundle exec rake assets:precompile

EXPOSE 3000

CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
