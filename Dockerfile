# Multi-stage build leve para Rails
FROM ruby:3.3-slim AS base

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    git \
    libpq-dev \
    nodejs \
    npm \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Bundle install
COPY Gemfile Gemfile.lock ./
RUN bundle config set --local deployment 'false' && \
    bundle install --jobs 4 --retry 3

# Copy app
COPY . .

# Precompile assets (se houver)
RUN bundle exec rails assets:precompile 2>/dev/null || true

EXPOSE 3000

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
