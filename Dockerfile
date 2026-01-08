# syntax=docker/dockerfile:1

# ---------- Stage 1: Base ----------
ARG RUBY_VERSION=3.3.3
FROM ruby:$RUBY_VERSION-bullseye AS base

WORKDIR /rails

# Install system dependencies
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y \
      curl libjemalloc2 libvips libpq-dev build-essential git libyaml-dev pkg-config nodejs yarn && \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/*

# Set production environment variables (but BUNDLE_DEPLOYMENT nanti di-set setelah bundle install)
ENV RAILS_ENV="production" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development:test"

# ---------- Stage 2: Build ----------
FROM base AS build

COPY Gemfile Gemfile.lock ./
COPY vendor/cache vendor/cache

RUN gem update --system && \
    gem install bundler -v 2.4.22

ENV BUNDLE_WITHOUT="development:test"

RUN bundle config set without 'development test' && \
    bundle install --full-index --jobs 4 --retry 3 && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache

COPY . .

RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

# ---------- Stage 3: Runtime ----------
FROM base

# Copy gems and app from build stage
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# Non-root user
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp
USER rails

# Set deployment mode now
ENV BUNDLE_DEPLOYMENT="1"

# Entrypoint
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Expose port
EXPOSE 80

# Default CMD
CMD ["bin/rails", "server", "-b", "0.0.0.0", "-p", "80"]
