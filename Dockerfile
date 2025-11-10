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

# Copy Gemfile first for caching
COPY Gemfile Gemfile.lock ./

# Update RubyGems & Bundler, install net-pop/net-protocol explicitly
RUN gem update --system && \
    gem install bundler -v "~> 2.5" && \
    gem install net-protocol -v "~> 0.2.2" && \
    gem install net-pop -v "~> 0.1.2"

# Install gems
RUN bundle update net-pop net-imap net-smtp mail && \
    bundle config set --local without 'development test' && \
    bundle install --jobs 4 --retry 3 --no-deployment && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Copy application code
COPY . .

# Precompile bootsnap
RUN bundle exec bootsnap precompile app/ lib/

# Precompile assets (without needing secret key)
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
