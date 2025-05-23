FROM ruby:3.2.8-alpine

ARG WORKDIR=/app

ENV RUNTIME_PACKAGES="tzdata postgresql-dev yarn git yaml-dev" \
    DEV_PACKAGES="build-base" \
    LANG=C.UTF-8 \
    TZ=Asia/Tokyo \
    RAILS_ENV=production

WORKDIR ${WORKDIR}

COPY Gemfile Gemfile.lock ./

RUN apk add --no-cache ${RUNTIME_PACKAGES} && \
    apk add --no-cache --virtual build-deps ${DEV_PACKAGES} && \
    bundle install -j4 && \
    apk del build-deps

COPY . .

RUN bundle exec rails assets:precompile

CMD ["bundle", "exec", "rails", "s", "-b", "0.0.0.0", "-p", "10000"]
