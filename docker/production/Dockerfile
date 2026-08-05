FROM ruby:3.2.3-bullseye

RUN apt-get update -qq && apt-get install -y -qq --no-install-recommends \
    curl \
    gnupg2 \
    libglib2.0-0 libglib2.0-dev \
    libjemalloc2 \
    libpoppler-glib8 \
    librsvg2-bin \
    libsndfile1-dev \
    libvips \
    libvips-dev \
    mediainfo \
    postgresql-common

RUN /usr/share/postgresql-common/pgdg/apt.postgresql.org.sh -y

RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash

RUN apt-get update -qq && apt-get install -y -qq --no-install-recommends nodejs postgresql-client-15

WORKDIR /srv/app

ARG RAILS_ENV=production

ENV BUNDLE_WITHOUT=development:test \
    NODE_ENV=production \
    RACK_ENV=production \
    RAILS_ENV="${RAILS_ENV:-production}" \
    RAILS_LOG_TO_STDOUT=true \
    RAILS_SERVE_STATIC_FILES=true \
    PORT=8080
ENV LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libjemalloc.so.2

RUN corepack enable

RUN gem update --system '4.0.18'

RUN bundle config set --local without 'development test' && \
    bundle config set --local jobs $(nproc) && \
    bundle config set --local default_cli_command install

COPY Gemfile Gemfile.lock ./

RUN --mount=type=cache,target=/usr/local/bundle/cache \
    --mount=type=cache,target=/srv/app/vendor/cache \
    bundle cache && \
    bundle install && \
    bundle clean --force

COPY package.json yarn.lock ./

RUN yarn install --immutable

COPY . /srv/app

RUN SECRET_KEY_BASE_DUMMY=1 bin/rails assets:precompile

RUN bundle exec bootsnap precompile --gemfile app/ lib/ config/

EXPOSE 8080

CMD ["bin/puma", "-C", "config/puma.rb"]
