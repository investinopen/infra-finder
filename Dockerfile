FROM debian:trixie-slim AS base

WORKDIR /srv/app

ENV BUNDLE_SILENCE_ROOT_WARNING=1 \
    DEBIAN_FRONTEND=noninteractive \
    DEBCONF_NONINTERACTIVE_SEEN=true

RUN <<EOF
    set -ex
    apt-get update -qq
    apt-get install -y -qq --no-install-recommends \
        extrepo \
        ca-certificates \
        curl \
        gnupg2 \
        libjemalloc2 \
        librsvg2-bin \
        libvips \
        libvips-dev \
        postgresql-common
    extrepo enable mise
    apt-get remove -y --auto-remove extrepo
    apt-get update
    /usr/share/postgresql-common/pgdg/apt.postgresql.org.sh -y
    apt-get install -y mise build-essential postgresql-client-15
    rm -rf /var/lib/apt/lists/*
EOF

ENV GEM_HOME=/usr/local/bundle \
    GEMRC=/usr/local/etc/gemrc \
    MISE_DATA_DIR=/usr/local/share/mise \
    PATH="/usr/local/share/mise/shims:/usr/local/bundle/bin:$PATH" \
    RAILS_LOG_TO_STDOUT=true \
    RAILS_SERVE_STATIC_FILES=true \
    PORT=8080 \
    LD_PRELOAD=libjemalloc.so.2

COPY mise.toml /srv/app/
COPY --chmod=+r docker/common/gemrc /usr/local/etc/gemrc

RUN mise install

EXPOSE 8080

CMD ["bin/puma", "-C", "config/puma.rb"]

FROM base AS devel

COPY --chmod=+x docker/dev/bins/ \
    docker/dev/entrypoint \
    /usr/local/bin/

VOLUME ["/srv/app", "/srv/app/node_modules", "/usr/local/bundle"]

ENTRYPOINT ["/usr/local/bin/entrypoint"]

# We have to re-declare CMD after setting ENTRYPOINT
CMD ["bin/puma", "-C", "config/puma.rb"]

FROM base AS prod-base

ENV BUNDLE_FROZEN=1 \
    BUNDLE_WITHOUT=development:test \
    RAILS_ENV=production \
    NODE_ENV=production \
    RACK_ENV=production \
    PIDFILE=/tmp/puma.pid

RUN <<EOF
    groupadd -r -g 10001 app
    useradd -r -g app -u 10001 app
    mkdir /home/app
    chown -R app:app /home/app
EOF

FROM prod-base AS gems

COPY Gemfile Gemfile.lock /srv/app/

RUN --mount=type=cache,target=/cache/bundle,sharing=locked <<EOF
    set -ex
    GEM_HOME=/cache/bundle bundle install
    GEM_HOME=/cache/bundle bundle clean --force
    mkdir -p /usr/local/bundle
    cp -a /cache/bundle/. /usr/local/bundle/
    rm -rf /usr/local/bundle/cache
EOF

FROM prod-base AS yarn

COPY .yarnrc.yml package.json yarn.lock ./

RUN --mount=type=cache,target=/root/.yarn/berry/cache \
    YARN_ENABLE_GLOBAL_CACHE=false \
    yarn install --immutable

FROM prod-base AS prod

COPY --from=gems /usr/local/bundle /usr/local/bundle
COPY --from=yarn /srv/app/node_modules /srv/app/node_modules
COPY . /srv/app
COPY --chmod=+x docker/prd/tasks/ /srv/app/mise/tasks/

RUN mise build

USER 10001:10001

RUN mise trust -a
