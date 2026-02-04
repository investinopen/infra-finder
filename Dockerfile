FROM ruby:3.2.3-bullseye

RUN apt-get update -qq && apt-get install -y -qq --no-install-recommends ca-certificates curl gnupg gnupg2 libsndfile1-dev build-essential libvips libvips-dev librsvg2-bin mediainfo vim

RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -

RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ bullseye-pgdg main" | tee /etc/apt/sources.list.d/pgdg.list

RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash

RUN apt-get update -qq && apt-get install -y -qq --no-install-recommends nodejs postgresql-client-15

RUN corepack enable

ENV BUNDLE_PATH=/bundle \
    BUNDLE_BIN=/bundle/bin \
    GEM_HOME=/bundle
ENV PATH="${BUNDLE_BIN}:${PATH}"

RUN gem update --system '4.0.5'
RUN gem install bundler -v '~> 4.0'

RUN bundle config set bin /bundle/bin --global
RUN bundle config set default_cli_command install --global

WORKDIR /srv/app
COPY Gemfile /srv/app/Gemfile
COPY Gemfile.lock /srv/app/Gemfile.lock
COPY . /srv/app

COPY docker/entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

EXPOSE 6333

CMD ["bin/puma", "-C", "config/puma.rb"]
