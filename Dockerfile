FROM ruby:3.2.3-bullseye

RUN apt-get update -qq && apt-get install -y -qq --no-install-recommends ca-certificates curl gnupg gnupg2 libsndfile1-dev build-essential libvips-dev mediainfo vim

RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -

RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ bullseye-pgdg main" | tee /etc/apt/sources.list.d/pgdg.list

RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash

RUN apt-get update -qq && apt-get install -y -qq --no-install-recommends nodejs postgresql-client-15

RUN corepack enable

RUN gem update --system && gem install bundler:2.5.6

WORKDIR /srv/app
COPY Gemfile /srv/app/Gemfile
COPY Gemfile.lock /srv/app/Gemfile.lock
COPY . /srv/app

COPY docker/entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

ENV BUNDLE_PATH=/bundle \
    BUNDLE_BIN=/bundle/bin \
    GEM_HOME=/bundle
ENV PATH="${BUNDLE_BIN}:${PATH}"

EXPOSE 6333

CMD ["bin/puma", "-C", "config/puma.rb"]
